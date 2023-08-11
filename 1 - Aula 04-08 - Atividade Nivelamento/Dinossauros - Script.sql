#criando a database dinossauros
create database dinossauros;

#colocando em uso a database dinossauros
use dinossauros;

#criando tabela Dinossauro
CREATE TABLE IF NOT EXISTS `dinossauros`.`Dinossauro` (
  `idDinossauros` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `grupo` VARCHAR(45) NOT NULL,
  `toneladas` INT NOT NULL,
  `ano` INT NOT NULL,
  `descobridor` VARCHAR(45) NOT NULL,
  `era` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `Eras_idEras` INT NOT NULL,
  `Grupos_idGrupos` INT NOT NULL,
  PRIMARY KEY (`idDinossauros`),
  INDEX `fk_Dinossauros_Eras1_idx` (`Eras_idEras` ASC) VISIBLE,
  INDEX `fk_Dinossauros_Grupos1_idx` (`Grupos_idGrupos` ASC) VISIBLE,
  CONSTRAINT `fk_Dinossauros_Eras1`
    FOREIGN KEY (`Eras_idEras`)
    REFERENCES `dinossauros`.`Eras` (`idEras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Dinossauros_Grupos1`
    FOREIGN KEY (`Grupos_idGrupos`)
    REFERENCES `dinossauros`.`Grupos` (`idGrupos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

#criando tabela Eras
CREATE TABLE IF NOT EXISTS `dinossauros`.`Eras` (
  `idEras` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `anoInicio` INT NOT NULL,
  `anoFim` INT NOT NULL,
  PRIMARY KEY (`idEras`))
ENGINE = InnoDB;

#criando tabela Grupos
CREATE TABLE IF NOT EXISTS `dinossauros`.`Grupos` (
  `idGrupos` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idGrupos`))
ENGINE = InnoDB;

#inserindo dados na tabela Dinossauro
insert into dinossauro (nome, grupo, toneladas, ano, descobridor, era, pais, Eras_idEras, Grupos_idGrupos)
values ('Saichania', 'Anquilossauros', 4, 1977, 'Maryanska', 'Cretáceo', 'Mongólia', 1, 1);

insert into dinossauro (nome, grupo, toneladas, ano, descobridor, era, pais, Eras_idEras, Grupos_idGrupos)
values ('Tricerátops', 'Ceratopsídeos', 6, 1887, 'John Bell Hatcher', 'Cretáceo', 'Canadá', 1, 1);

insert into dinossauro (nome, grupo, toneladas, ano, descobridor, era, pais, Eras_idEras, Grupos_idGrupos)
values ('Kentrossauro', 'Estegossauros', 2, 1909, 'Cientistas Alemães', 'Jurássico', 'Tanzânia', 1, 1);

insert into dinossauro (nome, grupo, toneladas, ano, descobridor, era, pais, Eras_idEras, Grupos_idGrupos)
values ('Pinacossauro', 'Anquilossauros', 6, 1999, 'Museu Americano de História Natural', 'Cretáceo', 'China', 1, 1);

insert into dinossauro (nome, grupo, toneladas, ano, descobridor, era, pais, Eras_idEras, Grupos_idGrupos)
values ('Alossauro', 'Terápodes', 3, 1877, 'Othniel Charles Marsh', 'Jurássico', 'América do Norte', 1, 1);

insert into dinossauro (nome, grupo, toneladas, ano, descobridor, era, pais, Eras_idEras, Grupos_idGrupos)
values ('Torossauro', 'Ceratopsídeos', 8, 1891, 'John Bell Hatcher', 'Cretáceo', 'USA', 1, 1);

insert into dinossauro (nome, grupo, toneladas, ano, descobridor, era, pais, Eras_idEras, Grupos_idGrupos)
values ('Anquilossauro', 'Anquilossauros', 8, 1906, 'Barnum Brown', 'Cretáceo', 'América do Norte', 1, 1);

#Inserindo dados na tabela Eras
insert into eras (nome, anoInicio, anoFim)
values ('Saichania', 145, 66);

insert into eras (nome, anoInicio, anoFim)
values ('Tricerátops', 145, 66);

insert into eras (nome, anoInicio, anoFim)
values ('Kentrossauro', 201, 145);

insert into eras (nome, anoInicio, anoFim)
values ('Pinacossauro', 85, 75);

insert into eras (nome, anoInicio, anoFim)
values ('Alossauro', 201, 145);

insert into eras (nome, anoInicio, anoFim)
values ('Torossauro', 145, 66);

insert into eras (nome, anoInicio, anoFim)
values ('Anquilossauro', 145, 66);

insert into eras (nome, anoInicio, anoFim)
values ('Saichania', 145, 66);

#inserindo dados na tabela Grupos
insert into grupos (nome)
values ('Anquilossauros');

insert into grupos (nome)
values ('Ceratopsídeos');

insert into grupos (nome)
values ('Estegossauros');

insert into grupos (nome)
values ('Terápodes');

#consultar todos os dados disponíveis de todos os dinossauros existentes em ordem alfabética de nome
select * from dinossauro
order by nome asc;

#consultar todos os dados disponíveis de todos os dinossauros existentes em ordem alfabética de descobridor
select * from dinossauro
order by descobridor asc;

#consultar todos os dados disponíveis dos dinossauros do grupo anquilossauros em ordem de ano de descoberta
select * from dinossauro
where grupo = 'anquilossauros'
order by ano asc;

#consultar todos os dados disponíveis dos dinossauros ceratopsídeos ou anquilossauros com ano de descoberta entre 1900 e 1999
select * from dinossauro
where grupo = 'Anquilossauros' or 'Ceratopsídeos'
and ano between 1900 and 1999;