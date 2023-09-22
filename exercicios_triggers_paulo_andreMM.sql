-- Exercícios Triggers

-- 1. crie um trigger que impeça a inserção de livros com o mesmo Titulo na tabela Livro
CREATE TRIGGER ImpedirInsercaoMesmoTitulo
ON Livro
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Livro WHERE isbn IN (SELECT isbn FROM INSERTED))
    BEGIN
        RAISEERROR('Não é possível adicionar livros com o mesmo título.', 16, 1)
        ROLLBACK TRANSACTION
    END
END

-- 2. crie um trigger que atualize automaticamente o ano de publicação na tabela Livro para o ano atual quando um novo livro é inserido
CREATE TRIGGER AtualizarAnoPublicacao
ON Livro
AFTER INSERT
AS
BEGIN
    UPDATE Livro
    SET ano = YEAR(GETDATE())
    FROM Livro
    WHERE isbn IN (SELECT isbn FROM INSERTED)
END

-- 3. crie um trigger que exclua automaticamente registros da tabela LivroAutor quando o livro correspondente é excluído da tabela Livro
CREATE TRIGGER ExcluirLivroAutor
ON Livro
AFTER DELETE
AS
BEGIN
    DELETE FROM LivroAutor
    WHERE fk_livro IN (SELECT isbn FROM DELETED)
END

-- 4. crie um trigger que atualize o número total de livros em uma categoria específica na tabela Categoria sempre que um novo livro é inserido nessa categoria
CREATE TRIGGER AtualizarTotalLivrosCategoria
ON Livro
AFTER INSERT
AS
BEGIN
    UPDATE Categoria
    SET total_livros = total_livros + 1
    FROM Categoria
    WHERE id IN (SELECT fk_categoria FROM INSERTED)
END

-- 5. crie um trigger que restrinja a exclusão de categorias na tabela Categoria se houver livros associados a essa categoria
CREATE TRIGGER RestringirExclusaoCategoria
ON Categoria
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Livro WHERE fk_categoria IN (SELECT id FROM DELETED))
    BEGIN
        RAISEERROR('Não é possível excluir categorias com livros associados.', 16, 1)
    END
    ELSE
    BEGIN
        DELETE FROM Categoria
        WHERE id IN (SELECT id FROM DELETED)
    END
END

-- 6. crie um trigger que registre em uma tabela de auditoria sempre que um livro for atualizado na tabela Livro
CREATE TRIGGER RegistrarAuditoriaLivro
ON Livro
AFTER UPDATE
AS
BEGIN
    INSERT INTO TabelaAuditoria (Operacao, DataHora, Descricao)
    SELECT 'Atualização de Livro', GETDATE(), 'Livro atualizado: ' + isbn
    FROM INSERTED
END

-- 7. crie um trigger que calcule automaticamente o número total de livros escritos por um autor na tabela Autor sempre que um novo livro é associado a esse autor na tabela LivroAutor
CREATE TRIGGER AtualizarTotalLivrosAutor
ON LivroAutor
AFTER INSERT
AS
BEGIN
    UPDATE Autor
    SET total_livros = total_livros + 1
    FROM Autor
    WHERE id IN (SELECT fk_autor FROM INSERTED)
END

-- 8. crie um trigger que restrinja a atualização do ISBN na tabela Livro para impedir que ele seja alterado
CREATE TRIGGER RestringirAtualizacaoISBN
ON Livro
INSTEAD OF UPDATE
AS
BEGIN
    RAISEERROR('Não é possível alterar o ISBN de um livro.', 16, 1)
END

-- 9. crie um trigger que limite o número de livros escritos por um autor na tabela LivroAutor para um máximo de 5 livros por autor
CREATE TRIGGER LimiteLivrosPorAutor
ON LivroAutor
AFTER INSERT
AS
BEGIN
    DECLARE @AutorID INT
    SELECT @AutorID = fk_autor FROM INSERTED
    
    IF (SELECT COUNT(*) FROM LivroAutor WHERE fk_autor = @AutorID) > 5
    BEGIN
        RAISEERROR('Limite de 5 livros por autor atingido.', 16, 1)
        ROLLBACK TRANSACTION
    END
END

-- 10. crie um trigger que atualize automaticamente o campo total_livros na tabela Categoria sempre que um novo livro daquela categoria for inserido na tabela Livro
CREATE TRIGGER AtualizarTotalLivrosCategoria
ON Livro
AFTER INSERT
AS
BEGIN
    UPDATE Categoria
    SET total_livros = total_livros + 1
    FROM Categoria
    WHERE id IN (SELECT fk_categoria FROM INSERTED)
END