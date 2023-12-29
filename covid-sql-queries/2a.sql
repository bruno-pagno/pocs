/*
 * Exercício 2 A - Senhas para pacientes
*/
ALTER TABLE pacientes
DROP COLUMN senha;
DROP TRIGGER IF EXISTS setSenhaPaciente ON pacientes;

SELECT * FROM pacientes;

DO $$
    DECLARE linha RECORD;
	BEGIN
		ALTER TABLE pacientes
		ADD COLUMN senha TEXT;

		FOR linha IN (SELECT * FROM pacientes) LOOP
			UPDATE pacientes
			SET senha = MD5(FORMAT('%s%s%s', linha.id_paciente, linha.ic_sexo, linha.aa_nascimento))
			WHERE id_paciente = linha.id_paciente;
		END LOOP;
	END;
$$;

CREATE OR REPLACE FUNCTION setSenha()
RETURNS TRIGGER AS $$
    BEGIN
        UPDATE pacientes
        SET senha = MD5(FORMAT('%s%s%s', NEW.id_paciente, NEW.ic_sexo, NEW.aa_nascimento))
		WHERE id_paciente = NEW.id_paciente;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER setSenhaPaciente
	AFTER INSERT ON pacientes
	FOR EACH ROW EXECUTE FUNCTION setSenha();
	
SELECT * FROM pacientes;

-- Inserindo um novo paciente
INSERT INTO pacientes VALUES
('0000000000000', 'M', 1960, 'BR', 'SP', 'SAO PAULO', 'CCCC', 1, NULL);

SELECT senha 
	FROM pacientes 
	WHERE id_paciente = '0000000000000';

DELETE FROM pacientes
	WHERE id_paciente = '0000000000000';

