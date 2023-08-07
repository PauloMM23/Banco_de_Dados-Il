create database biblioteca;

use biblioteca;

#criando tabela Livro
CREATE TABLE IF NOT EXISTS `biblioteca`.`Livro` (
  `idLivro` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `ano` INT NOT NULL,
  `editora` VARCHAR(45) NOT NULL,
  `autor` VARCHAR(45) NOT NULL,
  `isbn` VARCHAR(45) NOT NULL,
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

select * from categoria;

#inserindo atributos da tabela Livro
insert into livro (titulo, ano, editora, autor, Autor_idAutor, isbn, Categoria_idCategoria)
values ('Harry Potter e A Pedra Filosofal', 2000, 'Rocco', 'J.K. Rowling', 1, 8532511015, 1);
select * from livro;
insert into livro (titulo, ano, editora, autor, isbn)
values ('As Crônicas de Nárnia', 2009, 'Wmf Martins Fontes', 'Clive Staples Lewis', 9788578270698);

insert into livro (titulo, ano, editora, autor, isbn)
values ('O Espadachim de Carvão', 2013, 'Casa da Palavra', 'Affonso Solano', 9788577343348);

insert into livro (titulo, ano, editora, autor, isbn)
values ('O Papai É Pop', 2015, 'Belas Letras', 'Marcos Piangers', 9788581742458);

insert into livro (titulo, ano, editora, autor, isbn)
values ('Pior Que tá Não Fica', 2015, 'Matrix', 'Ciro Botelho - Tiririca', 9788582302026);

insert into livro (titulo, ano, editora, autor, isbn)
values ('Garota Desdobrável', 2015, 'Casa da Palavra', 'Bianca Mól', 9788577345670);

insert into livro (titulo, ano, editora, autor, isbn)
values ('Harry Potter e o Prisioneiro de Azkaban', 2000, 'Bucco', 'J.K. Rowling', 8532512062);

insert into categoria (descricao)
values ('Literatura Juvenil');

insert into autor (nome, nacionalidade)
values ('J.K. Rowling', 'Inglaterra');