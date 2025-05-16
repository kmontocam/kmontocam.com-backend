INSERT INTO
  "home"."translations" (language_code, html_id, content)
VALUES
  (
    'en',
    'nav-languages',
    '<li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "en"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-US''); toggleCollapsedMenu(''toggle-menu'')"><span>English</span></li><li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "es"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-LA''); toggleCollapsedMenu(''toggle-menu'')"><span>Spanish</span></li>'
  ),
  (
    'es',
    'nav-languages',
    '<li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "en"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-US''); toggleCollapsedMenu(''toggle-menu'')"><span>Inglés</span></li><li hx-post="https://api.kmontocam.com/home/v1/language/{code}" hx-vals=''{"code": "es"}'' hx-swap="none" hx-trigger="click" onclick="changeDomLanguage(''en-LA''); toggleCollapsedMenu(''toggle-menu'')"><span>Español</span></li>'
  );

DELETE FROM "home"."translations"
WHERE
  html_id = 'switch-to-es'
  AND html_id = 'switch-to-en';

UPDATE "home"."translations"
SET
  content = 'I am <b>Kevin Montoya</b>, a Machine Learning Engineer with experience in <span class="underline-kubernetes">Kubernetes</span>, <span class="underline-cloud">Cloud Infrastructure</span> and <span class="underline-development">Development for AI and Data Applications</span>. I truly enjoy technology and am always looking for something new to learn.'
WHERE
  language_code = 'en'
  AND html_id = 'home-intro';

UPDATE "home"."translations"
SET
  content = '<span class="bs-title">B.S. in Data Science and Mathematics Engineering</span><br />Began studies in August 2020 and graduated in June 2024.</p>'
WHERE
  language_code = 'en'
  AND html_id = 'studies-bs-intro';

UPDATE "home"."translations"
SET
  content = 'Mi nombre es <b>Kevin Montoya</b>, ingeniero en Inteligencia Artificial con experiencia en <span class="underline-kubernetes">Kubernetes</span>, <span class="underline-cloud">Infraestructura de Nube</span> y <span class="underline-development">Desarrollo de aplicaciones de Datos e IA</span>. Disfruto mucho la tecnología y siempre estoy buscando algo nuevo para aprender.'
WHERE
  language_code = 'es'
  AND html_id = 'home-intro';

UPDATE "home"."translations"
SET
  content = '<span class="bs-title">Ingeniería en Ciencia de Datos y Matemáticas</span><br>Empecé la carrera en plena pandemia, me gradué en junio de 2024.'
WHERE
  language_code = 'es'
  AND html_id = 'studies-bs-intro';
