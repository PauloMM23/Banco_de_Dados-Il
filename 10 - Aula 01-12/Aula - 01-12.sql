CREATE DATABASE AulaMT;
GO

-- import file using OPENROWSET
SELECT * 
FROM OPENROWSET (BULK'C:\Users\laboratorio\Downloads\data.json', SINGLE_CLOB) AS j;
GO

-- Converte a variável JSON em uma tabela
DECLARE @JSON VARCHAR(max)
SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK'C:\Users\laboratorio\Downloads\data.json', SINGLE_NCLOB) AS j;
SELECT * 
FROM OPENJSON (@JSON);
GO

-- Criar uma tabela e inserir os dados
DECLARE @JSON VARCHAR(max)
SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK'C:\Users\laboratorio\Downloads\data.json', SINGLE_NCLOB) AS j;
IF OBJECT_ID ('Pessoa', 'U') IS NOT NULL
	DROP TABLE Pessoa;

SELECT * INTO Pessoa
FROM OPENJSON (@JSON)
WITH
(
	nome VARCHAR(100),
	idade INT,
	sexo VARCHAR(20),
	email VARCHAR(100),
	celular VARCHAR(20),
	cidade VARCHAR(50),
	estado VARCHAR(3),
	endereco VARCHAR(100),
	numero INT
)

SELECT * FROM Pessoa;
GO

-- Inserir valores em uma tabela já existente
DECLARE @JSON VARCHAR(max)
SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK'C:\Users\laboratorio\Downloads\data (1).json', SINGLE_NCLOB) AS j;

INSERT INTO Pessoa
SELECT * FROM OPENJSON (@JSON)
WITH
(
	nome VARCHAR(100),
	idade INT,
	sexo VARCHAR(20),
	email VARCHAR(100),
	celular VARCHAR(20),
	cidade VARCHAR(50),
	estado VARCHAR(3),
	endereco VARCHAR(100),
	numero INT
)

SELECT * FROM Pessoa;

SELECT * FROM Pessoa 
WHERE sexo = 'feminino' AND idade BETWEEN 25 AND 30;


