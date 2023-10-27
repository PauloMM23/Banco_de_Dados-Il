/* 1. Suponha que você tenha um sistema de controle de funcionários para uma empresa.
Um dos requisitos é manter um histórico de cargos e salários dos funcionários ao
longo do tempo.
Cada Funcionario possui um FuncionarioID, Nome, Cargo, Salario, DataInicio
(contratação), DataFim (Desligamento da empresa). */

-- A. Crie uma tabela temporal para manter um histórico dos Funcionários
-- Criar tabela de Funcionários
CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome VARCHAR(100),
    cargo VARCHAR(100),
    salario DECIMAL(10, 2),
    data_inicio DATE,
    data_fim DATE
);

-- Criar tabela histórica para Funcionários
CREATE TABLE historico_funcionarios (
    id_historico INT PRIMARY KEY,
    id_funcionario INT,
    nome VARCHAR(100),
    cargo VARCHAR(100),
    salario DECIMAL(10, 2),
    data_inicio DATETIME2 GENERATED ALWAYS AS ROW START,
    data_fim DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (data_inicio, data_fim)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.historico_funcionarios_history));

-- B. Insira um novo funcionário na tabela Funcionarios.
INSERT INTO funcionarios (id_funcionario, nome, cargo, salario, data_inicio, data_fim)
VALUES (3, 'Pedro Castro', 'Desenvolvedor', 6000.00, '2022-02-10', NULL);

-- Visualizar funcionarios
select * from funcionarios;

-- C. Promova 4 vezes o funcionário inserido para um novo cargo com um aumento salarial.
-- Verifique como o histórico é mantido na tabela FuncionariosHistorico.
UPDATE funcionarios
SET cargo = 'Desenvolvedor Sênior', salario = 8500.00, data_fim = '2022-04-05'
WHERE id_funcionario = 3;

UPDATE funcionarios
SET cargo = 'Gerente', salario = 10000.00, data_fim = '2022-06-01'
WHERE id_funcionario = 3;

UPDATE funcionarios
SET cargo = 'Gerente Sênior', salario = 15000.00, data_fim = '2022-09-10'
WHERE id_funcionario = 3;

UPDATE funcionarios
SET cargo = 'Diretor', salario = 20000.00, data_fim = '2022-12-01'
WHERE id_funcionario = 3;

-- D. Liste todos os cargos anteriores de um funcionário específico, juntamente com os períodos em que ele ocupou esses cargos.
SELECT id_funcionario, nome, cargo, data_inicio, data_fim
FROM historico_funcionarios
WHERE id_funcionario = 3
ORDER BY data_inicio;

-- E. Determine o salário de um funcionário em uma data específica no passado.
SELECT TOP 1 salario
FROM historico_funcionarios
WHERE id_funcionario = 3 AND '2022-06-01' BETWEEN data_inicio AND data_fim
ORDER BY data_inicio DESC;

-- F. Liste todos os funcionários que já ocuparam o cargo de "Gerente" em algum momento.
SELECT DISTINCT id_funcionario, nome
FROM historico_funcionarios
WHERE cargo = 'Gerente';

-- G. Identifique as mudanças salariais de todos os funcionários no último ano.
SELECT id_funcionario, nome, salario, data_inicio, data_fim
FROM historico_funcionarios
WHERE data_fim >= DATEADD(YEAR, -1, GETDATE());

-- H. Desative o versionamento de sistema da tabela Funcionários e verifique o que acontece com a tabela FuncionariosHistorico.
ALTER TABLE funcionarios SET (SYSTEM_VERSIONING = OFF);

-- I. Um funcionário argumenta que nunca recebeu um aumento salarial nos últimos 2 anos.
-- Use a tabela temporal para verificar a validade dessa afirmação.
SELECT TOP 1 *
FROM historico_funcionarios
WHERE id_funcionario = 3 AND data_inicio <= '2022-02-10'
ORDER BY data_inicio DESC;

-- J. A empresa está conduzindo uma revisão e deseja saber quantos cargos um funcionário específico ocupou nos últimos 5 anos.
-- Forneça essa informação usando a tabela temporal.
SELECT COUNT(DISTINCT cargo) AS total_cargos
FROM historico_funcionarios
WHERE id_funcionario = 1 AND data_fim >= DATEADD(YEAR, -5, GETDATE());


