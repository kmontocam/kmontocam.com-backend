DELETE FROM "home"."translations"
WHERE
  html_id = 'nav-languages';

INSERT INTO
  "home"."translations" (language_code, html_id, content)
VALUES
  ('en', 'switch-to-es', 'Spanish'),
  ('es', 'switch-to-es', 'Español'),
  ('en', 'switch-to-en', 'English'),
  ('es', 'switch-to-en', 'Inglés');

UPDATE "home"."translations"
SET
  content = 'I am <b>Kevin Montoya</b>, a Machine Learning Engineer with experience in <span class="border-b-4 border-[#326ce5]">Kubernetes</span>, <span class="border-b-4 border-[#4040b2]">Cloud Infrastructure</span> and <span class="border-b-4 border-[#616265]">Development for AI and Data Applications</span>. I truly enjoy technology and am always looking for something new to learn.'
WHERE
  language_code = 'en'
  AND html_id = 'home-intro';

UPDATE "home"."translations"
SET
  content = '<span class="text-black dark:text-white text-2xl italic py-5">B.S. in Data Science and Mathematics Engineering</span><br />Began studies in August 2020 and graduated in June 2024.'
WHERE
  language_code = 'en'
  AND html_id = 'studies-bs-intro';

UPDATE "home"."translations"
SET
  content = 'Mi nombre es <b>Kevin Montoya</b>, ingeniero en Inteligencia Artificial con experiencia en <span class="border-b-4 border-[#326ce5]">Kubernetes</span>, <span class="border-b-4 border-[#4040b2]">Infraestructura de Nube</span> y <span class="border-b-4 border-[#616265]">Desarrollo de aplicaciones de Datos e IA</span>. Disfruto mucho la tecnología y siempre estoy buscando algo nuevo para aprender.'
WHERE
  language_code = 'es'
  AND html_id = 'home-intro';

UPDATE "home"."translations"
SET
  content = '<span class="text-black dark:text-white text-2xl italic py-5">Ingeniería en Ciencia de Datos y Matemáticas</span><br />Empecé la carrera en plena pandemia, me gradué en junio de 2024.'
WHERE
  language_code = 'es'
  AND html_id = 'studies-bs-intro';
