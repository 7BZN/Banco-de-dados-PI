DELIMITER $$
CREATE TRIGGER tg_funcionario_after_insert
AFTER INSERT ON funcionario
FOR EACH ROW
BEGIN
    INSERT INTO log_acesso (idp_usuario, acao, ip)
    VALUES (NEW.id_funcionario, 'Funcionario cadastrado no sistema', '0.0.0.0');
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_funcionario_after_update
AFTER UPDATE ON funcionario
FOR EACH ROW
BEGIN
    INSERT INTO log_acesso(idp_usuario, acao, ip)
    VALUES (NEW.id_funcionario, 'Dados do funcionário atualizados', '0.0.0.0');
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_funcionario_after_delete
AFTER DELETE ON funcionario
FOR EACH ROW
BEGIN
    INSERT INTO log_acesso(idp_usuario, acao, ip)
    VALUES (OLD.id_funcionario, 'Funcionário removido do sistema', '0.0.0.0');
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_movimentacao_after_insert
AFTER INSERT ON movimentacao
FOR EACH ROW
BEGIN
    IF NEW.tipo = 'entrada' THEN
        UPDATE estoque 
        SET quantidade = quantidade + NEW.quantidade
        WHERE id_estoque = NEW.id_estoque;
    ELSE
        UPDATE estoque 
        SET quantidade = quantidade - NEW.quantidade
        WHERE id_estoque = NEW.id_estoque;
    END IF;
END$$
DELIMITER ;

DELIMITER $$

CREATE TRIGGER tg_movimentacao_before_insert
BEFORE INSERT ON movimentacao
FOR EACH ROW
BEGIN
    DECLARE qtdAtual INT;

    SELECT quantidade INTO qtdAtual
    FROM estoque
    WHERE id_estoque = NEW.id_estoque;

    IF NEW.tipo = 'saida' THEN
        IF qtdAtual < NEW.quantidade THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Erro: Saída maior que o estoque disponível!';
        END IF;
    END IF;

END$$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_estoque_baixo_after_update
AFTER UPDATE ON estoque
FOR EACH ROW
BEGIN
    IF NEW.quantidade < 500 THEN
        INSERT INTO alerta(id_estoque, tipo, nivel, mensagem)
        VALUES (NEW.id_estoque, 'Estoque Baixo', 'alto', 'Quantidade em nível crítico!');
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_lote_insert_audit
AFTER INSERT ON lote
FOR EACH ROW
BEGIN
    INSERT INTO relatorio(id_funcionario, tipo, parametros, data_inicio, data_fim)
    VALUES (1, 'AUDITORIA_LOTE', CONCAT('Lote criado: ', NEW.numero_lote), NOW(), NOW());
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_lote_delete_report
AFTER DELETE ON lote
FOR EACH ROW
BEGIN
    INSERT INTO relatorio(id_funcionario, tipo, parametros, data_inicio, data_fim)
    VALUES (1, 'EXCLUSAO_LOTE', CONCAT('Lote removido: ', OLD.numero_lote), NOW(), NOW());
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_armazem_after_insert
AFTER INSERT ON armazem
FOR EACH ROW
BEGIN
    INSERT INTO log_acesso(idp_usuario, acao, ip)
    VALUES (1, CONCAT('Novo armazém criado: ', NEW.nome), '127.0.0.1');
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_agricultor_after_update
AFTER UPDATE ON agricultor
FOR EACH ROW
BEGIN
    INSERT INTO relatorio(id_funcionario, tipo, parametros, data_inicio, data_fim)
    VALUES (1, 'UPDATE_AGRICULTOR', CONCAT('Agricultor atualizado: ', NEW.nome), NOW(), NOW());
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_lote_vencido_after_update
AFTER UPDATE ON lote
FOR EACH ROW
BEGIN
    IF NEW.validade < CURDATE() THEN
        INSERT INTO alerta(id_estoque, tipo, nivel, mensagem)
        SELECT e.id_estoque, 'Lote Vencido', 'alto', 'Lote ultrapassou a validade!'
        FROM estoque e
        WHERE e.id_lote = NEW.id_lote;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_entrega_alta_quantidade
AFTER INSERT ON entrega
FOR EACH ROW
BEGIN
    IF NEW.quantidade > 200 THEN
        INSERT INTO alerta(id_estoque, tipo, nivel, mensagem)
        SELECT e.id_estoque, 'Entrega Grande', 'medio', 'Entrega acima do normal detectada'
        FROM estoque e
        WHERE e.id_lote = NEW.id_lote;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_movimentacao_after_delete
AFTER DELETE ON movimentacao
FOR EACH ROW
BEGIN
    INSERT INTO relatorio(id_funcionario, tipo, parametros, data_inicio, data_fim)
    VALUES (1, 'DELETE_MOVIMENTACAO', CONCAT('Movimentação removida ID: ', OLD.id_movimentacao), NOW(), NOW());
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_estoque_after_update
AFTER UPDATE ON estoque
FOR EACH ROW
BEGIN
    INSERT INTO relatorio(id_funcionario, tipo, parametros, data_inicio, data_fim)
    VALUES (
        1,
        'UPDATE_ESTOQUE',
        CONCAT('Estoque ID ', NEW.id_estoque, ' atualizado de ', OLD.quantidade, ' para ', NEW.quantidade),
        NOW(),
        NOW()
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_estoque_prevent_negative
BEFORE UPDATE ON estoque
FOR EACH ROW
BEGIN
    IF NEW.quantidade < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: O estoque não pode ficar negativo!';
    END IF;
END$$
DELIMITER ;















