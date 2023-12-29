/*
Que tipo de informações relacionadas a COVID é possível recuperar analisando
os tipos de exames e analitos registrados?
*/

/*
Muita coisa sobre o coronavírus ainda não foi descoberta pela ciência, mas já se sabe que o micro-organismo 
afeta mais que o sistema respiratório. Por isso, a infecção pode causar alterações no hemograma, exame 
que avalia as células sanguíneas, e até em outros exames de sangue considerados comuns, como a creatinina.

Fonte: https://www.medicina.ufmg.br/covid-19-pode-causar-alteracoes-em-exames-de-sangue/#:~:text=Muita%20coisa%20sobre%20o%20coronav%C3%ADrus,considerados%20comuns%2C%20como%20a%20creatinina.
*/



-- Criando a view 
DROP MATERIALIZED VIEW IF EXISTS testeCovidResultados;
CREATE MATERIALIZED VIEW IF NOT EXISTS testeCovidResultados AS 
	SELECT DISTINCT id_paciente, false as detectado
		FROM exames
		WHERE lower(de_exame) LIKE '%covid%'
		AND lower(de_resultado) LIKE '%não detectado%'
	UNION
	SELECT DISTINCT id_paciente, true as detectado
		FROM exames
		WHERE lower(de_exame) LIKE '%covid%'
		AND lower(de_resultado) LIKE 'detectado%';
	
-- Número de amostras da view
SELECT 'PCR não detectado', COUNT(*) as n_amostras
	FROM testeCovidResultados
	WHERE detectado = false
UNION
SELECT 'PCR detectado', COUNT(*) as n_amostras
	FROM testeCovidResultados
	WHERE detectado = true;


-- Exames de creatinina
SELECT 'PCR negativo', AVG(REPLACE(de_resultado, ',', '.')::float) as media_creatinina, COUNT(*) AS n_amostras
    FROM exames e
	NATURAL JOIN testeCovidResultados tcr
    WHERE lower(de_resultado) ~ '^\d+(.\d+)?$'
	AND de_exame = 'Creatinina'
	AND de_analito = 'Creatinina'
	AND tcr.detectado = false
UNION
SELECT 'PCR positivo', AVG(REPLACE(de_resultado, ',', '.')::float) as media_creatinina, COUNT(*) AS n_amostras
    FROM exames e
	NATURAL JOIN testeCovidResultados tcr
    WHERE lower(de_resultado) ~ '^\d+(.\d+)?$'
	AND de_exame = 'Creatinina'
	AND de_analito = 'Creatinina'
	AND tcr.detectado = true;


-- Exames de hemograma/hemoglobina
SELECT 'PCR negativo', AVG(REPLACE(de_resultado, ',', '.')::float) AS avg_hemoglobina, COUNT(*) AS n_amostras
	FROM exames e 
	NATURAL JOIN testeCovidResultados tcr
	WHERE de_exame = 'Hemograma'
	AND de_analito = 'Hemoglobina' 
	AND tcr.detectado = false
UNION
SELECT 'PCR positivo', AVG(REPLACE(de_resultado, ',', '.')::float) AS avg_hemoglobina, COUNT(*) AS n_amostras
	FROM exames e 
	NATURAL JOIN testeCovidResultados tcr
	WHERE de_exame = 'Hemograma'
	AND de_analito = 'Hemoglobina' 
	AND tcr.detectado = true;

	
	

	