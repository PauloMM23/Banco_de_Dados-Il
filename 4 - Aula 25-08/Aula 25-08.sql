DECLARE @nome_autor VARCHAR(100);
SELECT @nome_autor;
SET @nome_autor = 'Gabriel Pinto';
SELECT @nome_autor AS 'Nome do Autor';

DECLARE @titulo_Livro VARCHAR(100);
SELECT @titulo_Livro = Biblioteca.dbo.Livro.titulo
FROM Biblioteca.dbo.Livro
WHERE Livro.isbn = '9788577343348';
SELECT @titulo_Livro AS 'Título do Livro';

--Exemplo com cálculo - Calculando a idade de um livro
DECLARE @ano_publicacao INT, @ano_atual INT, @nome VARCHAR(100)
SET @ano_atual = 2023

--Atribui os valores
SELECT @ano_publicacao = ano, @nome = titulo
FROM Livro
WHERE isbn = '9788577343348'

--Mostra as informações na tela
SELECT @nome AS 'Nome Livro',
@ano_atual-@ano_publicacao AS 'Idade do Livro'

--Verificando o ano do livro CAST
SELECT 'O livro' + titulo + ' é do ano ' +
CAST(ano AS VARCHAR(10)) AS Ano
FROM Livro
WHERE isbn = '9788577343348'

--Verificando o ano do livro CONVERT
SELECT 'O livro' + titulo + ' é do ano ' +
CONVERT(VARCHAR(10), ano) AS Ano
FROM Livro
WHERE isbn = '9788577343348'

--update data de nascimento dos autores
update Autor
set data_nascimento = '1991-10-22'
where Autor.nome like 'Bianca M?l'

select * from autor

--verificando a data de nascimento do autor relativo ao id selecionado: ano-mês-dia
SELECT 'A data de nascimento de ' + nome + ' é: ' +
CONVERT(VARCHAR(50),data_nascimento)
FROM Autor
WHERE id = 1

--verificando a data de nascimento do autor relativo ao id selecionado: dia/mês/ano
SELECT 'A data de nascimento de ' + nome + ' é: ' +
CONVERT(VARCHAR(50), data_nascimento, 103)
FROM Autor
WHERE id = 1

--cadastrar o autor "Juca da Silva", se o mesmo não existir no banco
if 'Juca da Silva' NOT IN (SELECT nome FROM Autor)
	--Begin
		INSERT INTO Autor values('Juca da Silva', 'Brasil', '1985-04-20')
	--End

--ou
DECLARE @nome VARCHAR(100) = 'Juca da Silva';
IF NOT EXISTS (SELECT * FROM Autor WHERE Autor.nome = @nome)
	Begin
		INSERT INTO Autor VALUES (@nome, 'Brasil', '1985-04-20')
		UPDATE Autor
		SET Autor.nome = 'Marcos Piangers'
		WHERE Autor.id = 4
	END
ELSE
		UPDATE Autor
		SET Autor.data_nascimento = '1985-04-20'
		WHERE Autor.nome = @nome

select*from autor

--Contador do 0 ao 9 com WHILE
DECLARE @valor INT
SET @valor = 0

WHILE @valor<10
	BEGIN
		PRINT 'Número: ' + CAST(@valor AS VARCHAR(2))
		SET @valor = @valor+1
	END

--Alterar data_nascimento de todos os autores com WHILE
DECLARE @valor INT
SET @valor = 0

WHILE @valor < (SELECT max(id) FROM Autor)
	BEGIN
		UPDATE Autor
		SET data_nascimento = '1980-04-23'
		WHERE id = @valor

		SET @valor = @valor + 1
	END