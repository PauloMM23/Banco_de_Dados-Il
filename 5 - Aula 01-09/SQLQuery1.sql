--Selecionando o banco a ser utilizado
USE Biblioteca;

--Meu primeiro Trigger com AFTER
CREATE TRIGGER tgr_primeiro_trigger
ON dbo.Editora
AFTER INSERT
AS
PRINT 'Olá meu primeiro Trigger'

--Inserindo um valr para Ativação do Trigger
INSERT INTO Editora (nome) VALUES ('Editora do Juca');

--Remover o Trigger criado
DROP TRIGGER tgr_primeiro_trigger

DROP TRIGGER verifica_nome
--Verificar se um nome ja existe
CREATE TRIGGER verifica_nome
ON dbo.Editora
AFTER INSERT
AS
BEGIN
		DECLARE @nome VARCHAR(50);
		SELECT @nome = nome FROM inserted;
		
		IF (EXISTS(SELECT * FROM dbo.Editora WHERE nome LIKE (@nome)))
			BEGIN
				PRINT 'A Editora ' + @nome + ' já existe';
			END
		ELSE
			BEGIN
				INSERT INTO Editora (nome) VALUES (@nome);
				PRINT 'A Editora' + @nome + ' salva!';
			END
END

INSERT INTO Editora (nome) VALUES ('Paulo');

SELECT * FROM Editora;