-- 1 Crie um Trigger que impeça a inserção de livros com o mesmo titulo na tabela

IF OBJECT_ID('PreventDuplicateTitle', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER PreventDuplicateTitle;
END

-- Criar o Trigger utilizando AFTER
GO
CREATE TRIGGER PreventDuplicateTitle
ON Livro
AFTER INSERT
AS
BEGIN
	--Verificar se há titulos duplicados
	--Como o trigger é um AFTER o titulo esta presente
	--"na memória"
	IF EXISTS (
		SELECT titulo 
		FROM Livro 
		GROUP BY titulo 
		HAVING COUNT(*)>1
	)
	BEGIN
		--se houver titulos duplicados, desfazer a inserção
		ROLLBACK TRANSACTION;
		RAISERROR ('Não permitido titulos duplicados', 16, 1)
		PRINT('Não permitido titulos duplicados');
	END
END;
GO

 --Testando a resposta do exercicio 1
SELECT * FROM Livro;
INSERT INTO Livro VALUES ('12345', 'Harry Potter', 2000, 1, 1);



--3 Crie um Trigger que exclua automaticamente registro
--da tabela LivroAutor quando o livro correspondente é excluido da tabela Livro

IF OBJECT_ID('TriggerExcluiLivro', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER TriggerExcluiLivro;
END
GO
--Criando o Trigger
CREATE TRIGGER TriggerExcluiLivro
ON Livro
INSTEAD OF DELETE
AS
BEGIN
	--Excluir registro de Livro Autor associados ao livro
	DELETE FROM LivroAutor
	WHERE fk_livro IN (SELECT isbn FROM deleted)

	--Excluir o livro da tabela
	DELETE FROM Livro
	WHERE isbn IN (SELECT isbn FROM deleted)
END
GO


SELECT
	Autor.id AS AutorID,
	Autor.nome AS NomeAutor,
	Autor.nacionalidade AS Nacionalidade,
	Livro.isbn AS ISBN,
	Livro.titulo AS TituloLivro,
	Livro.ano AS AnoPublicacao
FROM Autor
JOIN LivroAutor ON Autor.id = LivroAutor.fk_autor
JOIN Livro ON LivroAutor.fk_livro = Livro.isbn
ORDER BY Autor.nome, Livro.ano;

--Testando Trigger
DELETE FROM Livro WHERE Livro.titulo = ('Harry Potter e A Pedra Filosofal')


CREATE PROCEDURE teste
AS
SELECT 'Paulo' AS Nome

EXECUTE teste;

--------------
CREATE PROCEDURE p_TituloAno
AS
SELECT titulo, ano
FROM Livro
EXEC p_TituloAno  


---------------------
CREATE PROCEDURE Autor
AS
SELECT 
	Autor.id AS AutorID,
	Autor.nome AS NomeAutor,
	Autor.nacionalidade AS Nacionalidade,
	Livro.isbn AS ISBN,
	Livro.titulo AS TituloLivro,
	Livro.ano AS AnoPublicacao
FROM Autor
	JOIN LivroAutor ON Autor.id = LivroAutor.fk_autor
	JOIN Livro ON LivroAutor.fk_livro = Livro.isbn
ORDER BY Autor.nome, Livro.ano;
 
EXEC Autor

------------------------
CREATE PROCEDURE p_LivroISBN
WITH ENCRYPTION
AS
SELECT titulo, isbn
FROM Livro

EXEC sp_helptext p_LivroISBN

--Parametro de entrada
ALTER PROCEDURE teste (@par1 AS int)
AS
SELECT @par1

EXEC teste 22

--Exemplo 3
ALTER PROCEDURE teste(@par1 AS int, @par2 AS varchar(20))
AS
BEGIN
SELECT @par1
SELECT @par2
END
EXEC teste 22, 'Vermelho'
EXEC teste @par1 = 25, @par2 = 'Laranja'

--Exemplo 4
ALTER PROCEDURE p_TituloAno(@ANO INT, @TITULO varchar(100))
AS
BEGIN
SELECT titulo AS 'Livro', ano AS 'ANO Publicacao'
FROM Livro
WHERE ano>@ANO and titulo like '%'+@titulo+'%'

EXEC p_TituloAno @ANO = 2000, @TITULO = Potter 'Vermelho'
EXEC teste @par1 = 25, @par2 = 'Laranja'

--Exemplo 6 Inserção de dados
CREATE PROCEDURE p_insere_editora (@nome VARCHAR(50))
AS
INSERT INTO Editora(nome)
VALUES(@nome)
EXEC p_insere_editora @nome = 'Editora Exemplo'
SELECT * FROM editora

--Exemplo 7 Parâmetro com valor padrão
CREATE PROCEDURE p_teste_valor_padrao(
@param1 INT,
@param2 VARCHAR(20) = 'Valor Padrão')
AS
SELECT 'Valor do parâmetro 1:' + CAST(@param1 AS VARCHAR)
SELECT 'Valor do parâmetro 2:' + @param2

EXEC p_teste_valor_padrao 30
EXEC p_teste_valor_padrao @param1 = 40, @param2 = 'Valor Modificado'

--Parâmetros de saída
ALTER PROCEDURE teste (@par1 AS INT OUTPUT)
AS
SELECT @par1*2
RETURN @par1*2
DECLARE @valor INT

EXEC @valor = teste 15
PRINT @valor



