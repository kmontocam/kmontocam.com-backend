CREATE TABLE IF NOT EXISTS public.fluentbit (tag VARCHAR, time TIMESTAMP, data JSONB);

CREATE SCHEMA IF NOT EXISTS log;

CREATE TABLE IF NOT EXISTS log.ingress_nginx (
  ts TIMESTAMPTZ NOT NULL,
  HOST TEXT NOT NULL,
  PATH TEXT NOT NULL,
  method TEXT NOT NULL,
  status INTEGER NOT NULL,
  bytes_sent INTEGER NOT NULL,
  request_id TEXT NOT NULL,
  remote_addr INET NOT NULL,
  request_time NUMERIC(10, 3),
  http_referrer TEXT,
  request_proto TEXT NOT NULL,
  request_query TEXT,
  upstream_addr TEXT, -- NOTE: INET:PORT
  request_length INTEGER NOT NULL,
  http_user_agent TEXT NOT NULL,
  x_forwarded_for TEXT NOT NULL, -- NOTE: ? add validation of IPv6, IPv4
  proxy_protocol_addr INET, -- NOTE: always null, since ingress-nginx can't use `use-proxy-protocol` behind cf tunnel
  proxy_upstream_name TEXT NOT NULL,
  upstream_status INTEGER,
  upstream_response_time NUMERIC(10, 3),
  upstream_response_length INTEGER,
  proxy_alternative_upstream_name TEXT
);

CREATE OR REPLACE FUNCTION log.nginx_log_schema () RETURNS TRIGGER AS $$
DECLARE
  data JSONB;
BEGIN
    IF NEW.tag ILIKE '%ingress_nginx%' THEN
    data := NEW.data->'data';

    INSERT INTO
      log.ingress_nginx (
        ts,
        host,
        path,
        method,
        status,
        bytes_sent,
        request_id,
        remote_addr,
        request_time,
        http_referrer,
        request_proto,
        request_query,
        upstream_addr,
        request_length,
        http_user_agent,
        x_forwarded_for,
        proxy_protocol_addr,
        proxy_upstream_name,
        upstream_status,
        upstream_response_time,
        upstream_response_length,
        proxy_alternative_upstream_name
      )
    VALUES
      (
        (data ->> 'ts')::timestamptz,
        data ->> 'host',
        data ->> 'path',
        data ->> 'method',
        (data ->> 'status')::int,
        (data ->> 'bytes_sent')::int,
        data ->> 'request_id',
        (data ->> 'remote_addr')::inet,
        (data ->> 'request_time')::numeric,
        NULLIF(data ->> 'http_referrer', '-'),
        data ->> 'request_proto',
        NULLIF(data ->> 'request_query', '-'),
        NULLIF(data ->> 'upstream_addr', '-'),
        (data ->> 'request_length')::int,
        data ->> 'http_user_agent',
        data ->> 'x_forwarded_for',
        CASE
          WHEN data ->> 'proxy_protocol_addr' IN ('', '-') THEN NULL
          ELSE (data ->> 'proxy_protocol_addr')::inet
        END,
        data ->> 'proxy_upstream_name',
        NULLIF(data ->> 'upstream_status', '-')::int,
        NULLIF(data ->> 'upstream_response_time', '-')::numeric,
        NULLIF(data ->> 'upstream_response_length', '-')::int,
        NULLIF(data ->> 'proxy_alternative_upstream_name', '')
      );
      END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_trigger
        WHERE tgname = 'insert_nginx_log'
    ) THEN
      CREATE TRIGGER insert_nginx_log
      AFTER INSERT ON public.fluentbit FOR EACH ROW
      EXECUTE FUNCTION log.nginx_log_schema ();
    END IF;
END
$$ LANGUAGE plpgsql;
