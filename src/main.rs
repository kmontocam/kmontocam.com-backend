mod postgres;
use crate::postgres::models::home::LanguageSwitch;
use axum::body::Body;
use axum::extract::ws::Message;
use axum::extract::State;
use axum::http::HeaderValue;
use http::{Request, Response};
use postgres::models::home::LanguageCode;
use serde::{Deserialize, Serialize};
use sqlx::postgres::{PgListener, PgPoolOptions};
use sqlx::{Pool, Postgres};
use std::env;
use std::error::Error;
use std::str::FromStr;
use std::sync::Arc;
use std::time::Duration;
use tera::{Context, Tera};
use tower::ServiceBuilder;
use tower_http::trace::TraceLayer;
use tracing::{error, info, Span};

use axum::{
    extract::ws::{WebSocket, WebSocketUpgrade},
    extract::Path,
    http::header::{HeaderMap, SET_COOKIE},
    http::StatusCode,
    response::{AppendHeaders, Html, IntoResponse},
    routing::{any, get, post},
    Router,
};

use axum_extra::extract::cookie::{Cookie, CookieJar};

#[derive(Clone)]
struct AppState {
    pool: Pool<Postgres>,
    tera: Tera,
    listener: Arc<tokio::sync::Mutex<PgListener>>,
}

#[allow(dead_code)]
#[derive(Deserialize, Serialize)]
struct IngressNginxLog {
    ts: String,
    host: String,
    path: String,
    method: String,
    status: u16,
    bytes_sent: u64,
    request_id: String,
    remote_addr: String,
    request_time: f64,
    http_referrer: Option<String>,
    request_proto: String,
    request_query: Option<String>,
    upstream_addr: String,
    request_length: u64,
    http_user_agent: String,
    x_forwarded_for: String,
    proxy_protocol_addr: Option<String>,
    proxy_upstream_name: String,
    upstream_status: u16,
    upstream_response_time: f64,
    upstream_response_length: u64,
    proxy_alternative_upstream_name: Option<String>,
}

async fn health_check(State(state): State<AppState>) -> impl IntoResponse {
    let _ = sqlx::query!("SELECT 1 AS ignore")
        .fetch_one(&state.pool)
        .await
        .map_err(|e| {
            error!("{}", e);
            return (StatusCode::SERVICE_UNAVAILABLE, "unhealthy");
        });

    return "ok";
}

/// Hook to trigger a language switch in the document
async fn trigger_language_switch(Path(code): Path<String>) -> impl IntoResponse {
    let trigger = AppendHeaders([("HX-Trigger", "switch-language")]);
    let cookies = AppendHeaders([(SET_COOKIE, format!("LANG={}", code))]);
    return (trigger, cookies);
}

/// Event to translate the content of the document, triggered by `HX-Trigger: switch-language`
/// TODO: create span for the translation in order to include method and path in the response log
async fn language_switch(
    State(state): State<AppState>,
    jar: CookieJar,
    headers: HeaderMap,
) -> Html<String> {
    let desired_language: String = jar
        .get("LANG")
        .unwrap_or(&Cookie::new("LANG", "en"))
        .value()
        .to_string();

    let html_id: String = headers
        .get("HX-Trigger")
        .unwrap_or(&HeaderValue::from_str("").unwrap())
        .to_str()
        .unwrap()
        .to_string();

    let switch = sqlx::query_file_as!(
        LanguageSwitch,
        "src/postgres/queries/language_switch.sql",
        LanguageCode::from_str(&desired_language).unwrap_or_default() as LanguageCode,
        html_id
    )
    .fetch_one(&state.pool)
    .await
    .unwrap_or_default();

    return Html(switch.content);
}

async fn stream_ingress_nginx_logs(State(state): State<AppState>, mut stream: WebSocket) {
    let mut listener = state.listener.lock().await;

    // TODO: add html box to the page to display the logs
    // Allow notification listening for multiple ws clients
    let _ = listener
        .listen("ingress_nginx_log")
        .await
        .map_err(|e| stream.send(Message::Text(e.to_string())));

    loop {
        // TODO: define default message for stream on failure
        let notification = listener.recv().await.unwrap();

        let message = notification.payload().to_string();
        let log: IngressNginxLog = serde_json::from_str(&message).unwrap();

        let html = state
            .tera
            .render(
                "live/ingress-nginx.html",
                &Context::from_serialize(&log).unwrap(),
            )
            .unwrap();

        // TODO: handle client disconnect
        let _ = stream.send(Message::Text(html)).await.unwrap();
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let subscriber = tracing_logfmt::builder()
        .subscriber_builder()
        .with_max_level(tracing::Level::INFO)
        .finish();

    tracing::subscriber::set_global_default(subscriber)?;

    let pool = PgPoolOptions::new()
        .max_connections(4)
        .connect(&env::var("DATABASE_URL").expect("expected DATABASE_URL environment variable"))
        .await?;

    sqlx::migrate!("./migrations").run(&pool).await?;

    let listener = PgListener::connect_with(&pool).await?;

    let tera = Tera::new("templates/**/*.html")?;

    let state = AppState {
        pool,
        tera,
        listener: Arc::new(tokio::sync::Mutex::new(listener)),
    };

    let app = Router::new()
        .route("/health", get(health_check))
        .route("/language/:code", post(trigger_language_switch))
        .route("/language", get(language_switch))
        .route(
            "/logs/ingress-nginx/ws",
            any(|ws: WebSocketUpgrade, state: State<AppState>| async {
                ws.on_upgrade(|socket| stream_ingress_nginx_logs(state, socket))
            }),
        )
        .layer(
            ServiceBuilder::new().layer(
                TraceLayer::new_for_http()
                    .on_request(|request: &Request<Body>, _span: &Span| {
                        info!(
                            http = true,
                            method = %request.method(),
                            path = %request.uri().path(),
                        )
                    })
                    .on_response(
                        |response: &Response<Body>, latency: Duration, _span: &Span| {
                            info!(
                                http = true,
                                status = response.status().as_u16(),
                                latency = format!("{:.8}", latency.as_secs_f64()),
                                unit = "s"
                            )
                        },
                    ),
            ),
        )
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, app).await?;

    Ok(())
}
