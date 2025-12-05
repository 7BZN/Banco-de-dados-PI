DELIMITER $$
CREATE FUNCTION fn_total_entradas(idEstoque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(m.quantidade)
    INTO total
    FROM movimentacao m
    WHERE m.id_estoque = idEstoque AND m.tipo = 'entrada';

    RETURN IFNULL(total, 0);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_total_saidas(idEstoque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(m.quantidade)
    INTO total
    FROM movimentacao m
    WHERE m.id_estoque = idEstoque AND m.tipo = 'saida';

    RETURN IFNULL(total, 0);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_estoque_real(idEstoque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN fn_total_entradas(idEstoque) - fn_total_saidas(idEstoque);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_dias_para_vencer(idLote INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE dias INT;
    
    SELECT DATEDIFF(validade, CURDATE())
    INTO dias
    FROM lote
    WHERE id_lote = idLote;

    RETURN dias;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_total_entregue_agricultor(idAgri INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT SUM(quantidade)
    INTO total
    FROM entrega
    WHERE id_agricultor = idAgri;

    RETURN IFNULL(total, 0);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_fornecedor_do_lote(idLote INT)
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
    DECLARE nomeFornecedor VARCHAR(200);

    SELECT f.nome
    INTO nomeFornecedor
    FROM fornecedor f
    JOIN lote l ON l.id_fornecedor = f.id_fornecedor
    WHERE l.id_lote = idLote;

    RETURN nomeFornecedor;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_ultima_movimentacao(idEstoque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE qtd INT;

    SELECT quantidade
    INTO qtd
    FROM movimentacao
    WHERE id_estoque = idEstoque
    ORDER BY data_movimento DESC
    LIMIT 1;

    RETURN IFNULL(qtd, 0);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_total_lotes_fornecedor(idForn INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM lote
    WHERE id_fornecedor = idForn;

    RETURN total;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_add_lote(
    IN p_fornecedor INT,
    IN p_numero VARCHAR(20),
    IN p_tipo VARCHAR(50),
    IN p_variedade VARCHAR(50),
    IN p_data_compra DATE,
    IN p_validade DATE,
    IN p_quantidade INT
)
BEGIN
    INSERT INTO lote (id_fornecedor, numero_lote, tipo_semente, variedade, data_compra, validade, quantidade_total)
    VALUES (p_fornecedor, p_numero, p_tipo, p_variedade, p_data_compra, p_validade, p_quantidade);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_atualizar_estoque(
    IN p_idEstoque INT,
    IN p_novaQtd INT
)
BEGIN
    UPDATE estoque
    SET quantidade = p_novaQtd, updated_at = NOW()
    WHERE id_estoque = p_idEstoque;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_registrar_movimentacao(
    IN p_idEstoque INT,
    IN p_tipo ENUM('entrada','saida'),
    IN p_qtd INT,
    IN p_motivo VARCHAR(200)
)
BEGIN
    INSERT INTO movimentacao(id_estoque, tipo, quantidade, motivo)
    VALUES (p_idEstoque, p_tipo, p_qtd, p_motivo);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_criar_alerta(
    IN p_idEstoque INT,
    IN p_tipo VARCHAR(50),
    IN p_nivel ENUM('baixo','medio','alto'),
    IN p_msg VARCHAR(255)
)
BEGIN
    INSERT INTO alerta(id_estoque, tipo, nivel, mensagem)
    VALUES (p_idEstoque, p_tipo, p_nivel, p_msg);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_registrar_entrega(
    IN p_agricultor INT,
    IN p_lote INT,
    IN p_qtd INT
)
BEGIN
    INSERT INTO entrega(id_agricultor, id_lote, quantidade)
    VALUES (p_agricultor, p_lote, p_qtd);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_criar_relatorio(
    IN p_funcionario INT,
    IN p_tipo VARCHAR(50),
    IN p_params TEXT
)
BEGIN
    INSERT INTO relatorio(id_funcionario, tipo, parametros, data_inicio, data_fim)
    VALUES (p_funcionario, p_tipo, p_params, CURDATE(), CURDATE());
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_add_agricultor(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(20),
    IN p_municipio VARCHAR(100),
    IN p_telefone VARCHAR(20)
)
BEGIN
    INSERT INTO agricultor(nome, cpf, municipio, telefone)
    VALUES (p_nome, p_cpf, p_municipio, p_telefone);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_update_agricultor(
    IN p_id INT,
    IN p_nome VARCHAR(100),
    IN p_municipio VARCHAR(100)
)
BEGIN
    UPDATE agricultor
    SET nome = p_nome,
        municipio = p_municipio
    WHERE id_agricultor = p_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_baixa_vencidos()
BEGIN
    UPDATE estoque e
    JOIN lote l ON l.id_lote = e.id_lote
    SET e.quantidade = 0
    WHERE l.validade < CURDATE();
END$$
DELIMITER ;

















