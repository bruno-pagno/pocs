/*
 * Exercício 2 B - Geração de Logs
*/
DROP TABLE IF EXISTS LogAcesso;
CREATE TABLE IF NOT EXISTS LogAcesso (
    data_hora TIMESTAMP,
    operacao TEXT,
    tabela TEXT
);

CREATE OR REPLACE FUNCTION getLog()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO LogAcesso
            VALUES (NOW(), TG_OP, TG_TABLE_NAME);
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS geraLogPacientes ON pacientes;
DROP TRIGGER IF EXISTS geraLogExames ON exames;
DROP TRIGGER IF EXISTS geraLogDesfechos ON desfechos;

CREATE TRIGGER geraLogPacientes
AFTER INSERT OR UPDATE OR DELETE ON pacientes
FOR EACH ROW EXECUTE FUNCTION getLog();

CREATE TRIGGER geraLogExames
AFTER INSERT OR UPDATE OR DELETE ON exames
FOR EACH ROW EXECUTE FUNCTION getLog();

CREATE TRIGGER geraLogDesfechos
AFTER INSERT OR UPDATE OR DELETE ON desfechos
FOR EACH ROW EXECUTE FUNCTION getLog();

-- Comandos auxiliares
SELECT * FROM LogAcesso;
DELETE FROM LogAcesso;

-- Exemplo 1 - Log da criação de um paciente
INSERT INTO pacientes 
	VALUES ('0000','F',1974,'BR','SP','MMMM','CCCC',0,NULL);

-- Exemplo 2 - Criação de um desfecho e exame
INSERT INTO exames 
	VALUES('00000000', '0000', 'lorem', NOW(), 'HOSP', 'URINA TIPO 1',	'Cilindro :', 'Ausente', 'Ausentes', 0);

INSERT INTO desfechos
	VALUES('0000', '0000', '2020-11-30', 'Ambulatorial', 11, 'Consulta', '2020-11-30', 'Alta,a pedido', 1);

-- Exemplo 3 - Deletar um paciente (cascateamento)
DELETE FROM pacientes
	WHERE id_paciente = '0000';