UPDATE "home"."translations"
SET
  content = 'I am <b>Kevin Montoya</b>, a college senior with a keen interest in <span class="underline-data">Data Applications</span>, <span class="underline-swe">Software Engineering</span> and <span class="underline-ai">Artificial Intelligence</span>. I am truly passionate when these domains intersect, but anything involving a technological aspect captivates me.'
WHERE
  language_code = 'en'
  AND html_id = 'home-intro';

UPDATE "home"."translations"
SET
  content = '<span class="bs-title">B.S. in Data Science and Mathematics Engineering</span><br>My studies began in August 2020, I anticipate graduating sometime in June 2024.'
WHERE
  language_code = 'en'
  AND html_id = 'studies-bs-intro';

UPDATE "home"."translations"
SET
  content = 'At the home campus in the city of <b>Monterrey</b>, <b>Mexico</b>. I have been involved in several courses that cover a range of subjects, from Data Science: specializing in both Machine Learning and Deep Learning, some Statistical Analysis... All the way to Cryptography and Cybersecurity.'
WHERE
  language_code = 'en'
  AND html_id = 'studies-bs-description';

UPDATE "home"."translations"
SET
  content = 'Since August 2023, I have been immersed in crafting infrastructure solutions for the Artificial Intelligence department. I designed and developed a complete microservice architecture, built upon Kubernetes in the cloud, featuring GPU-intensive applications and OpenAI solutions with secure connections. Additionally, I have deployed databases and monitoring systems, managing resources using infrastructure as code to handle staging and production environments.'
WHERE
  language_code = 'en'
  AND html_id = 'experience-hey-description';

UPDATE "home"."translations"
SET
  content = 'Mi nombre es  <b>Kevin Montoya Campaña</b>, voy en cuarto año de carrera y me interesa mucho todo lo que tiene que ver con <span class="underline-data">Aplicaciones de Datos</span>, <span class="underline-swe">  Software</span> e <span class="underline-ai">Inteligencia Artificial</span>. Mi parte favorita es cuando estas tres intersectan, pero cualquier cosa que tenga un aspecto tecnológico me llama la atención.'
WHERE
  language_code = 'es'
  AND html_id = 'home-intro';

UPDATE "home"."translations"
SET
  content = '<span class="bs-title">Ingeniería en Ciencia de Datos y Matemáticas</span><br>Empecé la carrera en plena pandemia, espero graduarme en junio de 2024.'
WHERE
  language_code = 'es'
  AND html_id = 'studies-bs-intro';

UPDATE "home"."translations"
SET
  content = 'En la capital del norte, <b>Monterrey</b>, <b>Nuevo León</b>. He cursado múltiples materias que cubren una gran variedad de temas. Desde Ciencia de Datos aplicada para desarrollar modelos de Machine Learning y Deep Learning, materias de Análisis Estadístico, hasta clases de criptografía y seguridad.'
WHERE
  language_code = 'es'
  AND html_id = 'studies-bs-description';

UPDATE "home"."translations"
SET
  content = 'Desde agosto de 2023, he desarrollado la infraestructura y arquitectura de software para el equipo de Inteligencia Artificial. He diseñado e implementado soluciones basadas en microservicios en la nube, utilizando Kubernetes. Esta arquitectura soporta aplicaciones demandantes en GPU, junto con servicios de OpenAI mediante conexiones seguras. Además, he desplegado bases de datos y sistemas de monitoreo, utilizando infraestructura como código para gestionar ámbientes de pruebas y producción.'
WHERE
  language_code = 'es'
  AND html_id = 'experience-hey-description';
