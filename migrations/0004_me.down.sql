UPDATE "home"."translations"
SET
  content = 'Hello, World!'
WHERE
  language_code = 'en'
  AND html_id = 'home-heading';
