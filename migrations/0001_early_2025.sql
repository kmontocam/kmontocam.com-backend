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
  content = 'At the home campus in the city of <b>Monterrey</b>, <b>Mexico</b>. I completed several courses that cover a range of subjects, from Data Science: specializing in both Machine Learning and Deep Learning, some Statistical Analysis... All the way to Cryptography and Cybersecurity.'
WHERE
  language_code = 'en'
  AND html_id = 'studies-bs-description';

UPDATE "home"."translations"
SET
  content = 'Designed and developed infrastructure solutions for the Artificial Intelligence department, creating a microservice architecture on Kubernetes in the cloud. Built GPU-intensive applications and integrated OpenAI solutions with secure connections. Deployed databases and monitoring systems, managing resources with infrastructure as code for staging and production environments.'
WHERE
  language_code = 'en'
  AND html_id = 'experience-hey-description';

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

UPDATE "home"."translations"
SET
  content = 'En la capital del norte, <b>Monterrey</b>, <b>Nuevo León</b>. Cursé múltiples materias que cubren una gran variedad de temas. Desde Ciencia de Datos aplicada para desarrollar modelos de Machine Learning y Deep Learning, materias de Análisis Estadístico, hasta clases de criptografía y seguridad.'
WHERE
  language_code = 'es'
  AND html_id = 'studies-bs-description';

UPDATE "home"."translations"
SET
  content = 'Diseño y desarrollo de soluciones de infraestructura para el departamento de Inteligencia Artificial, creando una arquitectura de microservicios en Kubernetes en la nube. Construcción de aplicaciones intensivas en GPU e integración de soluciones de OpenAI con conexiones seguras. Despliegue de bases de datos y sistemas de monitoreo, gestionando recursos con infraestructura como código para entornos de staging y producción.'
WHERE
  language_code = 'es'
  AND html_id = 'experience-hey-description';
