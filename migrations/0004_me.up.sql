UPDATE "home"."translations"
SET
  content = 'Me'
WHERE
  language_code = 'en'
  AND html_id = 'home-heading';
