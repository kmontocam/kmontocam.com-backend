DROP TRIGGER IF EXISTS insert_nginx_log ON public.fluentbit;

DROP FUNCTION IF EXISTS log.nginx_log_schema;

DROP TABLE IF EXISTS log.ingress_nginx;

DROP SCHEMA IF EXISTS log;

DROP TABLE IF EXISTS public.fluentbit;
