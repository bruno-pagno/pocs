/*
 * Exercício 1 - Criação de indíces
*/

-- Consulta do exercício
DROP INDEX IF EXISTS idxExamesO;

CREATE INDEX idxExamesO ON exames(de_origem)
	WHERE de_origem = 'Unidades de Internação';

EXPLAIN ANALYZE SELECT * FROM exames ex
    JOIN pacientes p ON p.id_paciente = ex.id_paciente
    JOIN desfechos d ON p.id_paciente = d.id_paciente
    WHERE ex.de_origem = 'Unidades de Internação';
/*
Sem índice: 223001.90
índice sem WHERE: 210637.25 -> 5.8%
Índice com WHERE: 209782.42 -> 6.3%
*/

-- Consulta proposta pelo grupo
DROP INDEX IF EXISTS exames_covid;

CREATE INDEX exames_covid ON exames(de_exame);

EXPLAIN ANALYZE SELECT * FROM exames
	WHERE de_exame = 'Hemograma';
/*
Sem índice: 139630.05 
Com índice: 131676.15 
Melhora:  6.3%
*/

EXPLAIN ANALYZE SELECT * 
	FROM exames e
	JOIN desfechos d ON e.id_atendimento = d.id_atendimento
	WHERE de_exame = 'PLAQUETAS';
/*
Sem índice: 126397.56 
Com índice: 103904.04 
Melhora: 21.6%
*/	


	
	