-- Exercícios Stored Procedure

-- 1. crie uma procedure que permita inserir uma nova categoria na tabela "Categoria".
CREATE PROCEDURE InserirCategoria
    @tipo_categoria VARCHAR(50)
AS
BEGIN
    INSERT INTO Categoria (tipo_categoria)
    VALUES (@tipo_categoria)
END

-- 2. crie uma procedure para atualizar os detalhes de um livro (por exemplo, título, ano) pelo ISBN.
CREATE PROCEDURE AtualizarDetalhesLivro
    @isbn VARCHAR(50),
    @novo_titulo VARCHAR(100),
    @novo_ano INT
AS
BEGIN
    UPDATE Livro
    SET titulo = @novo_titulo, ano = @novo_ano
    WHERE isbn = @isbn
END

-- 3. desenvolva uma procedure para adicionar um novo autor à tabela "Autor".
CREATE PROCEDURE InserirAutor
    @nome VARCHAR(70),
    @nacionalidade VARCHAR(50)
AS
BEGIN
    INSERT INTO Autor (nome, nacionalidade)
    VALUES (@nome, @nacionalidade)
END

-- 4. implemente uma procedure para excluir um autor e remover sua associação com os livros na tabela "LivroAutor".
CREATE PROCEDURE ExcluirAutor
    @autor_id INT
AS
BEGIN
    DELETE FROM LivroAutor WHERE fk_autor = @autor_id
    DELETE FROM Autor WHERE id = @autor_id
END

-- 5. crie uma procedure que receba o nome de uma categoria e retorne todos os livros dentro dessa categoria.
CREATE PROCEDURE ListarLivrosPorCategoria
    @categoria VARHCAR(50)
AS
BEGIN
    SELECT Livro.*
    FROM Livro
    INNER JOIN Categoria ON Livro.fk_categoria = Categoria.id
    WHERE Categoria.tipo_categoria = @categoria
END

-- 6. desenvolva uma procedure que receba o nome de um autor e retorne todos os livros escritos por esse autor.
CREATE PROCEDURE ListarLivrosPorAutor
    @autor_nome VARCHAR(75)
AS
BEGIN
    SELECT Livro.*
    FROM Livro
    INNER JOIN LivroAutor ON Livro.isbn = LivroAutor.fk_livro
    INNER JOIN Autor ON LivroAutor.fk_autor = Autor.id
    WHERE Autor.nome = @autor_nome
END

-- 7. crie uma procedure que liste os livros publicados em um ano específico.
CREATE PROCEDURE ListarLivrosPorAno
    @ano INT
AS
BEGIN
    SELECT *
    FROM Livro
    WHERE ano = @ano
END

-- 8. implemente uma procedure para listar os livros publicados por uma editora específica.
CREATE PROCEDURE ListarLivrosPorEditora
    @editora_nome VARCHAR(80)
AS
BEGIN
    SELECT Livro.*
    FROM Livro
    INNER JOIN Editora ON Livro.fk_editora = Editora.id
    WHERE Editora.nome = @editora_nome
END

-- 9. desenvolva uma procedure que retorne uma lista de livros com ISBNs dentro de uma faixa específica.
CREATE PROCEDURE ListarLivrosPorFaixaISBN
    @isbn_min VARCHAR(50),
    @isbn_max VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Livro
    WHERE isbn BETWEEN @isbn_min AND @isbn_max
END

-- 10. crie uma procedure para contar o número de livros em cada categoria.
CREATE PROCEDURE ContarLivrosPorCategoria
AS
BEGIN
    SELECT Categoria.tipo_categoria, COUNT(*) AS total_livros
    FROM Livro
    INNER JOIN Categoria ON Livro.fk_categoria = Categoria.id
    GROUP BY Categoria.tipo_categoria
END