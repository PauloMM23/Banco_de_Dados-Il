/* 3.  Em um sistema de gerenciamento de hotelaria, existem hotéis, quartos e reservas.
Os hotéis possuem várias características, como nome, localização e classificação
por estrelas. Os quartos têm um tipo (como individual, duplo ou suíte) e um preço
por noite. As reservas rastreiam qual cliente reservou qual quarto em datas
específicas.
Cada hotel possui um HotelID, Nome representando o nome do estabelecimento,
Localização que indica onde o hotel está situado, e Estrelas que mostra a
classificação de qualidade do hotel com base no número de estrelas.
Cada quarto é identificado por um QuartoID. Ele está associado a um HotelID que
indica a qual hotel pertence. O Tipo do quarto descreve se é individual, duplo, suíte,
entre outros. O quarto tem um PreçoPorNoite que indica o custo para uma estadia
de uma noite.
Cada reserva é única e identificada por um ReservaID. Está vinculada a um
QuartoID, indicando qual acomodação foi reservada. A reserva tem um Cliente
associado, representando a pessoa que fez a reserva. As datas de início e término
da estadia são representadas por DataInicio e DataFinal, respectivamente.
 */

-- A. Crie uma tabela temporal para manter o histórico de todas as relações (tabelas).
CREATE TABLE hoteis_historico (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_hotel INT,
    nome VARCHAR(100),
    localizacao VARCHAR(150),
    estrelas INT,
    data_inicio DATETIME2 GENERATED ALWAYS AS ROW START,
    data_fim DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (data_inicio, data_fim)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.hoteis_historico_history));

CREATE TABLE quartos_historico (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_quarto INT,
    id_hotel INT,
    tipo VARCHAR(100),
    preco_por_noite DECIMAL(10, 2),
    data_inicio DATETIME2 GENERATED ALWAYS AS ROW START,
    data_fim DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (data_inicio, data_fim)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.quartos_historico_history));

CREATE TABLE reservas_historico (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_reserva INT,
    id_quarto INT,
    cliente VARCHAR(255),
    data_inicio DATE,
    data_final DATE,
    data_inicio_estadia DATETIME2 GENERATED ALWAYS AS ROW START,
    data_final_estadia DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (data_inicio_estadia, data_final_estadia)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.reservas_historico_history));

-- B. Adicione um novo hotel à base de dados.
INSERT INTO hoteis (id_hotel, nome, localizacao, estrelas)
VALUES (203, 'Hotel Rockstar', 'Rio de Janeiro', 5);

-- C. Mude a classificação do 'Hotel Paradiso' para 5 estrelas e verifique o histórico na tabela hoteis_historico.
UPDATE hoteis
SET estrelas = 5
WHERE id_hotel = 201;

select * from hoteis_historico;

-- D. Liste todas as reservas do 'Hotel Sunlight' com os nomes dos clientes e datas.
SELECT R.*, H.nome AS nome_hotel
FROM reservas R
JOIN quartos Q ON R.id_quarto = Q.id_quarto
JOIN hoteis H ON Q.id_hotel = H.id_hotel
WHERE H.nome = 'Hotel Sunlight';

-- E. Encontre todos os quartos que ainda não foram reservados no 'Hotel Paradiso'.
SELECT Q.*
FROM quartos Q
WHERE Q.id_hotel = 201 AND Q.id_quarto NOT IN (SELECT id_quarto FROM reservas WHERE data_inicio_estadia <= GETDATE() AND data_final_estadia >= GETDATE());

-- F. Calcule a receita total para o 'Hotel Paradiso' com base nas reservas e preços dos quartos.
SELECT SUM(Q.preco_por_noite) AS receita_total
FROM reservas R
JOIN quartos Q ON R.id_quarto = Q.id_quarto
WHERE Q.id_hotel = 201;

-- G. "Lívia Santos" alega que tinha uma reserva no 'Hotel Sunlight' que começava em '2023-03-01'. Verifique a veracidade de sua afirmação.
SELECT * FROM reservas
WHERE cliente = 'Lívia Santos' AND data_inicio_estadia = '2023-03-01';

-- H. Verifique quantos quartos do tipo 'Suíte' foram reservados nos últimos 6 meses.
SELECT COUNT(*)
FROM reservas R
JOIN quartos Q ON R.id_quarto = Q.id_quarto
WHERE Q.tipo = 'Suíte' AND R.data_inicio_estadia >= DATEADD(MONTH, -6, GETDATE());
