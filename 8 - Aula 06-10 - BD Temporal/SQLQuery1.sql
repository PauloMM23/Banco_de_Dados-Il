-- Meu primeiro Banco de Dados Temporal
CREATE DATABASE DB_Temporal;
GO

-- Colocando o banco em utilização
USE DB_Temporal;
GO

IF OBJECT_ID('dbo.InventarioCarros', 'U') IS NOT NULL
BEGIN
-- Ao excluir uma tabela temporal, precisamos primeiro desativar o controle de versão
	ALTER TABLE dbo.InventarioCarros SET (SYSTEM_VERSIONING = OFF)
	DROP TABLE dbo.InventarioCarros
END
GO

/* As principais coisas a serem observadas com nossa tabela
1- Ela tem que conter CHAVE PRIMÁRIA.
2- Ela tem que conter dois campos datetime2, marcados com GENERATED ALWAYS AS ROW START/END
3- Ela deve conter a instrução PERIOD FOR SYSTEM_TIME
4- Ela precisa conter a propriedade de SYSTEM_VERSIONING = ON
*/
CREATE TABLE InventarioCarros 
(
	CarroID INT PRIMARY KEY IDENTITY(500,1),
	Ano INT,
	Marca VARCHAR(40),
	Modelo VARCHAR(40),
	Cor VARCHAR(10),
	Quilometragem INT,
	Disponivel BIT NOT NULL DEFAULT 1,
	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH
(
	--providencia um nome para a tabela de históricos
	SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.HistoricoInventarioCarros)
)
GO

--Se consultarmos nossas tabelas
SELECT * FROM dbo.InventarioCarros;
SELECT * FROM dbo.HistoricoInventarioCarros;

--Preenchendo com os carros mais escolhidos das agências
INSERT INTO dbo.InventarioCarros (Ano, Marca, Modelo, Cor, Quilometragem, Disponivel)
VALUES 
(2004, 'Fiat', 'Uno', 'Branco', 150000, 1),
(2015, 'Ford', 'Ka', 'Preto', 30000, 1),
(2023, 'Hyundai', 'HB20', 'Prata', 0, 1),
(2023, 'Hyundai', 'HB20', 'Branco', 0, 1);
GO

--Verificando os valores inseridos em ambas tabelas
SELECT * FROM dbo.InventarioCarros;
SELECT * FROM dbo.HistoricoInventarioCarros;
GO

-- A tabela de histórico somente é populada com a alteração de informações
INSERT INTO dbo.InventarioCarros (Ano, Marca, Modelo, Cor, Quilometragem, Disponivel)
VALUES 
(2023, 'Honda', 'City', 'Prata', 50000, 1);

-- Vamos alugar alguns carros
UPDATE dbo.InventarioCarros SET Disponivel = 0
WHERE CarroID = 501;
UPDATE dbo.InventarioCarros SET Disponivel = 0
WHERE CarroID = 504;
GO

SELECT * FROM dbo.InventarioCarros;
SELECT * FROM dbo.HistoricoInventarioCarros;
GO

-- Depois de um tempo, nossos clientes devolvem seus carros
UPDATE dbo.InventarioCarros SET Disponivel = 1, Quilometragem = 50000
WHERE CarroID = 501;
UPDATE dbo.InventarioCarros SET Disponivel = 1, Quilometragem = 60000
WHERE CarroID = 504;
GO

SELECT * FROM dbo.InventarioCarros;
SELECT * FROM dbo.HistoricoInventarioCarros;
GO

-- Continuando nossos negócios
UPDATE dbo.InventarioCarros SET Disponivel = 0
WHERE CarroID = 500;
GO

-- PT no Uno, muita emoção na estrada
DELETE FROM dbo.InventarioCarros WHERE CarroID = 500;
GO

SELECT * FROM dbo.InventarioCarros;
SELECT * FROM dbo.HistoricoInventarioCarros;
GO

-- Relembrar dos dias do apice da saudo do nosso negócio
SELECT * FROM dbo.InventarioCarros
FOR SYSTEM_TIME AS OF '2023-10-06 13:06:53' ORDER BY CarroID;

-- Recuperar todo o histórico de um veículo
SELECT * FROM dbo.InventarioCarros
FOR SYSTEM_TIME ALL
WHERE CarroID = 501;

-- Verificando carros que deram PT (Removido do Banco)
SELECT DISTINCT
	h.CarroID AS CarroPT
FROM 
	dbo.InventarioCarros t
	RIGHT JOIN dbo.HistoricoInventarioCarros h
	ON t.CarroID = h.CarroID
WHERE
	t.CarroID IS NULL