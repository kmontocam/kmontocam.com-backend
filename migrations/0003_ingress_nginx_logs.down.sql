DROP TRIGGER IF EXISTS notify_ingress_nginx_log ON log.ingress_nginx;

DROP FUNCTION IF EXISTS log.notify_ingress_nginx_log;

DROP TRIGGER IF EXISTS insert_ingress_nginx_log ON public.fluentbit;

DROP FUNCTION IF EXISTS log.ingress_nginx_log_schema;

DROP TABLE IF EXISTS log.ingress_nginx;

DROP SCHEMA IF EXISTS log CASCADE;

DROP TABLE IF EXISTS public.fluentbit;
