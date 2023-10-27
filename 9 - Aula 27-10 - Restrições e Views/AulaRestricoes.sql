CREATE DATABASE AulaRestricoes;
USE AulaRestricoes;

--Cadastro de um petshop
CREATE TABLE tbl_pessoa_pet
(
	id INTEGER PRIMARY KEY IDENTITY,
	nome_pessoa VARCHAR(50) NOT NULL,
	nome_pet VARCHAR(50) NOT NULL,
	num_pet INTEGER CHECK(num_pet > 0) NOT NULL,
	idade_pessoa INTEGER CHECK(idade_pessoa BETWEEN 18 AND 85),
	sexo_pet CHAR CHECK(sexo_pet IN('M', 'F', 'N'))
);
GO

--Testando restrições
INSERT INTO tbl_pessoa_pet VALUES('Herysson', 'Logan', 2, 35, 'M');
INSERT INTO tbl_pessoa_pet VALUES('Deise', 'Phoebs', 2, 36, 'F');

INSERT INTO tbl_pessoa_pet VALUES('Juca', 'Gargameu', 1, 18, 'M');

SELECT * FROM tbl_pessoa_pet;

--Exemplo para aplicar CASCADE
CREATE TABLE tbl_Pais
(
	id_pais INT PRIMARY KEY,
	nome_pais VARCHAR(50) UNIQUE NOT NULL,
	cod_pais VARCHAR(3) NOT NULL
);

CREATE TABLE tbl_Estados
(
	id_estados INT PRIMARY KEY,
	nome_estado VARCHAR(50) NOT NULL,
	cod_estado VARCHAR(3) NOT NULL,
	id_Pais INT
);
GO

--Criando restrição CHECK + CASCADE
ALTER TABLE tbl_Estados WITH CHECK
ADD CONSTRAINT [FK_estado_pais] FOREIGN KEY(id_Pais)
REFERENCES tbl_Pais(id_Pais)
ON DELETE CASCADE;

--Informações das tabelas
sp_help tbl_Estados;
GO
INSERT INTO tbl_Pais VALUES 
(1, 'Brasil', 'BR'),
(2, 'Canada', 'CA'),
(3, 'Estados Unidos', 'EUA');

INSERT INTO tbl_Estados VALUES
(1, 'Rio Grande do Sul', 'RS', 1),
(2, 'Acre', 'AC', 1),
(3, 'São Paulo', 'SP', 1),
(4, 'Sergipe', 'SE', 1);

INSERT INTO tbl_Estados VALUES
(5, 'California', 'CA', 3),
(6, 'Alasca', 'AK', 3),
(7, 'Florida', 'FL', 3),
(8, 'Arizona', 'AZ', 3);

INSERT INTO tbl_Estados VALUES
(9, 'Ontario', 'ON', 2),
(10, 'Quebec', 'QC', 2),
(11, 'Toronto', 'TR', 2),
(12, 'Nova Escocia', 'NS', 2);

SELECT * FROM tbl_Pais;
SELECT * FROM tbl_Estados;

DELETE FROM tbl_Pais WHERE id_pais = 1;
GO

--Outra forma de criação de restrições
CREATE TABLE tbl_Produto
(
	id_produto INT PRIMARY KEY,
	nome_produto VARCHAR(50),
	categoria VARCHAR(25)
);

CREATE TABLE tbl_Inventario
(
	id_inventario INT PRIMARY KEY,
	fk_id_Produto INT,
	quantidade INT,
	min_level INT,
	max_level INT,
	CONSTRAINT fk_inv_produto
		FOREIGN KEY (fk_id_Produto)
		REFERENCES tbl_Produto (id_produto)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--Inserindo alguns valores
INSERT INTO tbl_Produto VALUES
(1, 'Refrigerante', 'Bebidas'),
(2, 'Cerveja', 'Bebidas'),
(3, 'Tequila', 'Bebidas'),
(4, 'Energético', 'Bebidas');

INSERT INTO tbl_Inventario VALUES
(1, 1, 500, 10, 1000),
(2, 4, 50, 5, 50),
(3, 2, 1000, 5, 5000);

SELECT * FROM tbl_Produto;
SELECT * FROM tbl_Inventario;

UPDATE tbl_Produto SET id_produto = 550
WHERE id_produto = 1;

DELETE FROM tbl_Produto WHERE id_produto = 550;

--Removendo Restrição
ALTER TABLE tbl_Inventario DROP CONSTRAINT fk_inv_produto;

--Adicionando uma nova restrição
ALTER TABLE tbl_Inventario WITH CHECK
ADD CONSTRAINT [fk_inv_produto]
FOREIGN KEY (fk_id_produto)
REFERENCES tbl_Produto (id_produto)
ON UPDATE CASCADE
ON DELETE SET NULL;

--Remover o Energético
DELETE FROM tbl_Produto WHERE id_produto = 4;

SELECT * FROM tbl_Produto;
SELECT * FROM tbl_Inventario;