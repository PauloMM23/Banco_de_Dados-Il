#criando a database biblioteca
create database biblioteca;

#colocando em uso a database biblioteca
use biblioteca;

#criando tabela Livro
CREATE TABLE IF NOT EXISTS `biblioteca`.`Livro` (
  `idLivro` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `ano` INT NOT NULL,
  `editora` VARCHAR(45) NOT NULL,
  `autor` VARCHAR(45) NOT NULL,
  `isbn` VARCHAR(45) NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  `Categoria_idCategoria` INT NOT NULL,
  `Autor_idAutor` INT NOT NULL,
  PRIMARY KEY (`idLivro`),
  INDEX `fk_Livro_Categoria1_idx` (`Categoria_idCategoria` ASC) VISIBLE,
  INDEX `fk_Livro_Autor1_idx` (`Autor_idAutor` ASC) VISIBLE,
  CONSTRAINT `fk_Livro_Categoria1`
    FOREIGN KEY (`Categoria_idCategoria`)
    REFERENCES `biblioteca`.`Categoria` (`idCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Livro_Autor1`
    FOREIGN KEY (`Autor_idAutor`)
    REFERENCES `biblioteca`.`Autor` (`idAutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

#criando tabela Autor
CREATE TABLE IF NOT EXISTS `biblioteca`.`Autor` (
  `idAutor` INT NOT NULL auto_increment,
  `nome` VARCHAR(45) NOT NULL,
  `nacionalidade` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAutor`))
ENGINE = InnoDB;

#criando tabela Categoria
CREATE TABLE IF NOT EXISTS `biblioteca`.`Categoria` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB;

#inserindo dados na tabela Livro
insert into livro (titulo, ano, editora, autor, categoria, isbn, Autor_idAutor, Categoria_idCategoria)
values ('Harry Potter e A Pedra Filosofal', 2000, 'Rocco', 'J.K. Rowling', 'Literatura Juvenil', 8532511015, 1, 1);

insert into livro (titulo, ano, editora, autor, categoria, isbn, Autor_idAutor, Categoria_idCategoria)
values ('As Crônicas de Nárnia', 2009, 'Wmf Martins Fontes', 'Clive Staples Lewis', 'Literatura Juvenil', 9788578270698, 2, 1);

insert into livro (titulo, ano, editora, autor, categoria, isbn, Autor_idAutor, Categoria_idCategoria)
values ('O Espadachim de Carvão', 2013, 'Casa da Palavra', 'Affonso Solano', 'Ficção Científica', 9788577343348, '3', 2);

insert into livro (titulo, ano, editora, autor, categoria, isbn, Autor_idAutor, Categoria_idCategoria)
values ('O Papai É Pop', 2015, 'Belas Letras', 'Marcos Piangers', 'Humor', 9788581742458, 4, 3);

insert into livro (titulo, ano, editora, autor, categoria, isbn, Autor_idAutor, Categoria_idCategoria)
values ('Pior Que tá Não Fica', 2015, 'Matrix', 'Ciro Botelho - Tiririca', 'Humor', 9788582302026, 5, 3);

insert into livro (titulo, ano, editora, autor, categoria, isbn, Autor_idAutor, Categoria_idCategoria)
values ('Garota Desdobrável', 2015, 'Casa da Palavra', 'Bianca Mól', 'Literatura Juvenil', 9788577345670, 6, 1);

insert into livro (titulo, ano, editora, autor, categoria, isbn, Autor_idAutor, Categoria_idCategoria)
values ('Harry Potter e o Prisioneiro de Azkaban', 2000, 'Bucco', 'J.K. Rowling', 'Literatura Juvenil', 8532512062, 1, 1);

#inserindo dados na tabela Autor
insert into autor (nome, nacionalidade)
values ('J.K. Rowling', 'Inglaterra');

insert into autor (nome, nacionalidade)
values ('Clive Staples Lewis', 'Inglaterra');

insert into autor (nome, nacionalidade)
values ('Affonso Solano', 'Brasil');

insert into autor (nome, nacionalidade)
values ('Marcos Piangers', 'Brasil');

insert into autor (nome, nacionalidade)
values ('Ciro Botelho - Tiririca', 'Brasil');

insert into autor (nome, nacionalidade)
values ('Bianca Mól', 'Brasil');

#inserindo dados na tabela Categoria
insert into categoria (descricao)
values ('Literatura Juvenil');

insert into categoria (descricao)
values ('Ficção Científica');

insert into categoria (descricao)
values ('Humor');

#Consultar todos os dados disponíveis de todos os livro existentes na biblioteca em ordem alfabética de título
select * from livro
order by titulo ASC;

#Consultar todos os dados disponíveis de todos os livro existentes na biblioteca em ordem alfabética de autor
select * from livro
order by autor ASC;

#Consultar todos os dados disponíveis dos livro da categoria de Literatura Juvenil em ordem de ano
select * from livro
where categoria = 'Literatura Juvenil'
order by ano ASC;

#Consultar todos os dados disponíveis dos livros de Humor ou Ficção Científica com ano entre 2000 e 2010
select * from livro
where (categoria = 'Humor' or categoria = 'Ficção Científica')
and ano between 2000 and 2010;