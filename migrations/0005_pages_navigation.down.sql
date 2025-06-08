DELETE FROM "home"."translations"
WHERE
  html_id LIKE 'root-nav-pages%'
  OR html_id LIKE 'live-nav-pages%';
