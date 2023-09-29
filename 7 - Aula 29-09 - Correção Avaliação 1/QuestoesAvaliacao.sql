-- Gabarito 1ª Avaliação
-- Questão 11

CREATE TRIGGER tr_VerificaDuplicidade
ON FUNCIONARIO
INSTEAD OF INSERT
AS
BEGIN
-- DECLARAÇÂO DAS VARIÁVEIS
	DECLARE @nome VARCHAR(15), 
			@sobrenome VARCHAR(15),
			@dataNasc DATE

-- ATRIBUIÇÂO DE VALORES
	SELECT @nome = Pnome, 
		   @sobrenome = Unome, 
		   @dataNasc = Datanasc

	FROM INSERTED
-- VERIFICAR NO BANCO A EXISTÊNCIA DE REGISTRO DUPLICADO
	IF EXISTS(SELECT 1 
			  FROM FUNCIONARIO 
			  WHERE Pnome = @nome 
			  AND Unome = @sobrenome 
			  AND Datanasc = @dataNasc
			  )

	-- RETORNA MENSAGEM DE ERRO
		RAISERROR('Já existe um funcionário com o mesmo nome, sobrenome e data de nascimento', 16,1)
	ELSE
	-- CASO NÃO TENHA DUPLICIDADE, INSERE OS VALORES NO BANCO
		INSERT INTO FUNCIONARIO
		SELECT * 
		FROM INSERTED

END
GO

SELECT * FROM FUNCIONARIO ORDER BY Pnome
INSERT INTO FUNCIONARIO VALUES ('Juca', 'S', 'da Silva', '98340347', '2012-01-01', 'Rua do Juca, 666, Santa Maria, RS', 'M', 150, '3445343', 4)


-- Questão 12
CREATE TABLE FUNCIONARIO_LOG(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	Operacao VARCHAR(10),
	DataHora DATETIME,
	Pnome VARCHAR(15),
	Unome VARCHAR(15),
	Datanasc DATE,
	Endereco VARCHAR(255),
	Sexo CHAR(1),
	Salario DECIMAL(10,2)
)
GO
--INSERT
CREATE TRIGGER tr_Funcionario_Insert_Log
ON FUNCIONARIO
AFTER INSERT
AS
	BEGIN
		INSERT INTO FUNCIONARIO_LOG (Operacao, DataHora, Pnome, Unome, Datanasc, Endereco, Sexo, Salario)
		SELECT 'INSERT', GETDATE(), Pnome, Unome, Datanasc, Endereco, Sexo, Salario
		FROM INSERTED
	END
GO

SELECT * FROM FUNCIONARIO ORDER BY Pnome

INSERT INTO FUNCIONARIO VALUES ('Arlindo', 'S', 'Arantes', '45748447', '1945-04-23', 'Rua do Juca, 666, Santa Maria, RS', 'M', 30000, '78534563', 4)

SELECT * FROM FUNCIONARIO_LOG ORDER BY LogID
GO

CREATE TRIGGER tr_Funcionario_Delete_log
ON FUNCIONARIO
AFTER DELETE
AS
BEGIN
	INSERT INTO FUNCIONARIO_LOG (Operacao, DataHora, Pnome, Unome, Datanasc, Endereco, Sexo, Salario)
	SELECT 'DELETE', GETDATE(), Pnome, Unome, Datanasc, Endereco, Sexo, Salario
	FROM DELETED
END
GO

SELECT * FROM FUNCIONARIO_LOG ORDER BY LogID
DELETE FROM FUNCIONARIO WHERE Cpf = '8809877'
GO


CREATE TRIGGER tr_Funcionario_Update_log
ON FUNCIONARIO
AFTER UPDATE
AS
BEGIN
	INSERT INTO FUNCIONARIO_LOG (Operacao, DataHora, Pnome, Unome, Datanasc, Endereco, Sexo, Salario)
	SELECT 'UPDATE', GETDATE(), Pnome, Unome, Datanasc, Endereco, Sexo, Salario
	FROM DELETED -- CONTÉM AS INFORMAÇÕES ANTIGAS QUE FORAM SUBSTITUÍDAS
END
GO

SELECT * FROM FUNCIONARIO_LOG ORDER BY LogID
UPDATE FUNCIONARIO SET Unome = 'da Silva' WHERE Cpf = '45345345376'
GO

--Questão 13
CREATE TRIGGER tr_Delete_Funcionario
ON FUNCIONARIO
INSTEAD OF DELETE
AS
BEGIN
-- DELETANDO DEPENDENTES
	DELETE FROM DEPENDENTE WHERE Fcpf IN (SELECT Cpf FROM DELETED)

-- ATUALIZAR O CAMPO DE SUPERVISOR
	UPDATE FUNCIONARIO SET Cpf_supervisor = NULL
	WHERE Cpf_supervisor IN (SELECT Cpf FROM DELETED)

-- ATUALIZAR GERENCIA DE DEPARTAMENTO
	UPDATE DEPARTAMENTO SET Cpf_gerente = NULL
	WHERE Cpf_gerente IN (SELECT Cpf FROM DELETED)
-- REMOVENDO O FUNCIONARIO DOS PROJETOS
	DELETE FROM TRABALHA_EM WHERE Fcpf IN (SELECT Cpf FROM DELETED)
-- DELETANDO FUNCIONARIO
	DELETE FROM FUNCIONARIO WHERE Cpf IN (SELECT Cpf FROM DELETED)
END
GO

SELECT * FROM FUNCIONARIO ORDER BY Pnome
DELETE FROM FUNCIONARIO WHERE Cpf = '66688444476'

GO

-- QUESTÃO 14
CREATE PROCEDURE sp_Adiciona_Funcionario
(
	@Cpf CHAR(11),
	@Pnome VARCHAR(15),
	@Unome VARCHAR(15),
	@Datanasc DATE,
	@Endereco VARCHAR(255),
	@Sexo CHAR(1),
	@Salario DECIMAL(10,2),
	@Supervisor CHAR(11) = NULL,
	@Dnr INT
)
AS
BEGIN
	INSERT INTO FUNCIONARIO (Cpf, Pnome, Unome, Datanasc, Endereco, Sexo, Salario, Cpf_supervisor, Dnr)
	VALUES(@Cpf, @Pnome, @Unome, @Datanasc, @Endereco, @Sexo, @Salario, @Supervisor, @Dnr)
	PRINT'Funcionário inserido com sucesso!'
END
GO

EXEC sp_Adiciona_Funcionario
	@Cpf = '12345085',
	@Pnome = 'João',
	@Unome = 'Silva',
	@Datanasc = '1990-01-01',
	@Endereco = 'Rua ABC, 123',
	@Sexo = 'M',
	@Salario = 3000.00,
	@Dnr = 5

SELECT * FROM FUNCIONARIO ORDER BY Pnome
GO

-- Questão 15
CREATE PROCEDURE sp_Aumenta_Salario
(
	@Porcentagem DECIMAL (5,2),
	@Dnome VARCHAR(15)
)
AS
BEGIN
	UPDATE FUNCIONARIO
	SET Salario = Salario + Salario * (@Porcentagem/100)
	WHERE Dnr IN (SELECT Dnumero FROM DEPARTAMENTO WHERE Dnome = @Dnome)
	PRINT'Salario Alterado com Sucesso!'
END
GO

SELECT * FROM FUNCIONARIO
INNER JOIN DEPARTAMENTO
ON Dnr = Dnumero
ORDER BY Dnr

EXEC sp_Aumenta_Salario
	@Porcentagem = 10,
	@Dnome = 'Pesquisa'

SELECT * FROM FUNCIONARIO_LOG ORDER BY LogID