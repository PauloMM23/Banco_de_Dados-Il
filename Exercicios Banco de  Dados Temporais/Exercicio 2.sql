/* 2. Imagine que você tem um sistema de controle de pacientes para um hospital. Um
dos requisitos é manter um histórico das condições médicas dos pacientes ao longo
do tempo.
Cada paciente possui um PacienteID, Nome, Condição (representando o diagnóstico
médico atual), Medicamento (remédio prescrito para a condição), DataDiagnóstico e
DataFinalização (se e quando a condição foi resolvida). */

-- A. Crie uma tabela temporal para manter um histórico dos Pacientes (PacientesHistorico).
CREATE TABLE PacientesHistorico (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    nome VARCHAR(100),
    condicao VARCHAR(100),
    medicamento VARCHAR(100),
    data_diagnostico DATE,
    data_finalizacao DATE,
    CONSTRAINT fk_id_paciente FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente)
);

-- B. Insira um paciente na tabela Pacientes que foi diagnosticado com essa “nova doença”.
INSERT INTO pacientes (id_paciente, nome, condicao, medicamento, data_diagnostico, data_finalizacao)
VALUES (116, 'Junior Silva', 'nova doença', 'MedicamentoND', '2023-02-05', NULL);

select * from pacientes;

-- C. Atualize a condição de "Bia Souza" para indicar que ela se recuperou da doença.
-- Em seguida, verifique como o histórico é mantido na tabela PacientesHistorico.
UPDATE pacientes
SET condicao = 'recuperado', data_finalizacao = '2023-03-01'
WHERE id_paciente = 102;

select * from pacientes;
select * from PacientesHistorico;

-- D. Liste todas as condições médicas anteriores de "Carlos Menezes".
SELECT id_paciente, nome, condicao, medicamento, data_diagnostico, data_finalizacao
FROM PacientesHistorico
WHERE id_paciente = 103
ORDER BY data_diagnostico;

-- E. Determine a condição médica de "Eduardo Lopes" em '2022-10-01'.
SELECT TOP 1 condicao
FROM PacientesHistorico
WHERE id_paciente = 105 AND '2022-10-01' BETWEEN data_diagnostico AND COALESCE(data_finalizacao, '2023-12-31')
ORDER BY data_diagnostico DESC;

-- F. Liste todos os pacientes que foram diagnosticados com a "Nova doença" em janeiro de 2023.
SELECT id_paciente, nome, data_diagnostico
FROM PacientesHistorico
WHERE condicao = 'nova doença' AND MONTH(data_diagnostico) = 1 AND YEAR(data_diagnostico) = 2023;

-- G. Altere 2 pacientes com “Nova doença” para Bronquite.
UPDATE pacientes
SET condicao = 'bronquite'
WHERE condicao = 'nova doença'
LIMIT 2;

-- H. Identifique todos os pacientes que tiveram a "Nova doença" e, posteriormente, desenvolveram "Bronquite".
SELECT DISTINCT PH1.id_paciente, PH1.nome
FROM PacientesHistorico PH1
JOIN PacientesHistorico PH2 ON PH1.id_paciente = PH2.id_paciente
WHERE PH1.condicao = 'nova doença' AND PH2.condicao = 'bronquite' AND PH1.data_finalizacao < PH2.data_diagnostico;

-- I. Desative o versionamento do sistema da tabela pacientes e verifique o que acontece com a tabela PacientesHistorico.
ALTER TABLE pacientes SET (SYSTEM_VERSIONING = OFF);

-- J. "Alex Costa" argumenta que foi diagnosticado com "Bronquite" no passado.
-- Use a tabela temporal para verificar a validade dessa afirmação.
SELECT TOP 1 *
FROM PacientesHistorico
WHERE id_paciente = 101 AND condicao = 'bronquite'
ORDER BY data_diagnostico DESC;

-- K. O hospital deseja saber quantos pacientes foram diagnosticados com a "Nova doença" nos últimos 6 meses.
SELECT COUNT(*)
FROM PacientesHistorico
WHERE condicao = 'nova doença' AND data_diagnostico >= DATEADD(MONTH, -6, GETDATE());


