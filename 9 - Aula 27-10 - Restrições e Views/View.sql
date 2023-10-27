CREATE VIEW vw_Livros AS

SELECT livro.isbn AS 'ISBN', Livro.titulo AS 'Título', Livro.ano AS 'Ano', Editora.nome AS 'Editora', 
concat(autor.nome, ' (' ,autor.nacionalidade, ')') AS 'Autor/Nacionalidade', categoria.tipo_categoria AS 'Categoria'
FROM livro, editora, autor, categoria, livroautor
WHERE livro.fk_editora = editora.id
AND livro.fk_categoria = categoria.id AND livroautor.fk_autor = autor.id AND livroautor.fk_livro = livro.isbn;

SELECT * FROM vw_Livros ORDER BY Título;