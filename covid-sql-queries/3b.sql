/*
Analisando a quantidade de registros de um determinado exame de COVID em
relação a data de coleta ou período (por exemplo semanal), é possível indicar
tendências de alta e/ou baixa que auxiliariam a especialistas m´edicos em analises
futuras?
*/

CREATE OR REPLACE VIEW exames_quinzena AS
SELECT
	((dt_coleta - MIN(dt_coleta) OVER()))/15+1 AS quinzena, de_exame, de_analito, de_resultado
	FROM exames
	WHERE lower(de_exame) LIKE '%covid%'
	ORDER BY 1;
	
SELECT *, COUNT(*)
FROM exames_quinzena
GROUP BY 1, 2, 3, 4;