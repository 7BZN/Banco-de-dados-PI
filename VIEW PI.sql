CREATE VIEW vw_lotes_fornecedor AS
SELECT 
    l.id_lote,
    l.numero_lote,
    l.tipo_semente,
    l.variedade,
    l.quantidade_total,
    f.nome AS fornecedor,
    f.telefone,
    l.data_compra,
    l.validade
FROM lote l
JOIN fornecedor f ON f.id_fornecedor = l.id_fornecedor;

CREATE VIEW vw_estoque_completo AS
SELECT 
    e.id_estoque,
    a.nome AS armazem,
    a.localizacao,
    l.numero_lote,
    l.tipo_semente,
    e.quantidade,
    e.created_at
FROM estoque e
JOIN lote l ON l.id_lote = e.id_lote
JOIN armazem a ON a.id_armazem = e.id_armazem;

CREATE VIEW vw_movimentacoes_detalhadas AS 
SELECT     
    m.id_movimentacao,
    m.tipo,
    m.quantidade,
    m.data_movimentacao,
    e.id_estoque,
    a.nome AS armazem,
    l.numero_lote
FROM movimentacao m
JOIN estoque e ON e.id_estoque = m.id_estoque
JOIN lote l ON l.id_lote = e.id_lote
JOIN armazem a ON a.id_armazem = e.id_armazem;

CREATE VIEW vw_entregas_agricultor AS
SELECT 
    en.id_entrega,
    a.nome AS agricultor,
    a.municipio,
    l.numero_lote,
    l.tipo_semente,
    en.quantidade,
    en.data_entrega
FROM entrega en
JOIN agricultor a ON a.id_agricultor = en.id_agricultor
JOIN lote l ON l.id_lote = en.id_lote;

CREATE VIEW vw_estoque_baixo AS
SELECT 
    e.id_estoque,
    a.nome AS armazem,
    l.numero_lote,
    e.quantidade
FROM estoque e
JOIN armazem a ON a.id_armazem = e.id_armazem
JOIN lote l ON l.id_lote = e.id_lote
WHERE e.quantidade < 700;

CREATE VIEW vw_alertas_detalhados AS
SELECT 
    al.id_alerta,
    al.tipo,
    al.nivel,
    l.numero_lote,
    a.nome AS armazem,
    al.mensagem,
    al.data_alerta
FROM alerta al
JOIN estoque e ON e.id_estoque = al.id_estoque
JOIN lote l ON l.id_lote = e.id_lote
JOIN armazem a ON a.id_armazem = e.id_armazem;

CREATE VIEW vw_relatorios_funcionarios AS
SELECT 
    r.id_relatorio,
    r.tipo,
    r.parametros,
    r.data_inicio,
    r.data_fim,
    f.nome AS funcionario,
    f.cargo
FROM relatorio r
JOIN funcionario f ON f.id_funcionario = r.id_funcionario;

CREATE VIEW vw_logs_detalhados AS
SELECT 
    l.id_log,
    f.nome AS usuario,
    l.acao,
    l.data_acesso,
    l.ip
FROM log_acesso l
JOIN funcionario f ON f.id_funcionario = l.idp_usuario;

CREATE VIEW vw_ranking_movimentacao AS
SELECT 
    e.id_estoque,
    l.numero_lote,
    COUNT(m.id_movimentacao) AS total_movimentacoes
FROM estoque e
LEFT JOIN movimentacao m ON m.id_estoque = e.id_estoque
JOIN lote l ON l.id_lote = e.id_lote
GROUP BY e.id_estoque, l.numero_lote
ORDER BY total_movimentacoes DESC;

CREATE VIEW vw_total_entregue_agricultor AS
SELECT 
    a.nome AS agricultor,
    a.municipio,
    SUM(en.quantidade) AS total_entregue
FROM entrega en
JOIN agricultor a ON a.id_agricultor = en.id_agricultor
GROUP BY a.nome, a.municipio;

CREATE VIEW vw_entradas_saidas_estoque AS
SELECT 
    e.id_estoque,
    SUM(CASE WHEN m.tipo = 'entrada' THEN m.quantidade ELSE 0 END) AS total_entrada,
    SUM(CASE WHEN m.tipo = 'saida' THEN m.quantidade ELSE 0 END) AS total_saida
FROM estoque e
LEFT JOIN movimentacao m ON m.id_estoque = e.id_estoque
GROUP BY e.id_estoque;

CREATE VIEW vw_lotes_proximos_vencimento AS
SELECT 
    l.id_lote,
    l.numero_lote,
    l.tipo_semente,
    l.validade,
    f.nome AS fornecedor
FROM lote l
JOIN fornecedor f ON f.id_fornecedor = l.id_fornecedor
WHERE l.validade <= DATE_ADD(CURDATE(), INTERVAL 90 DAY);

CREATE VIEW vw_agricultores_municipio_entregas AS
SELECT 
    a.municipio,
    COUNT(en.id_entrega) AS total_entregas
FROM agricultor a
LEFT JOIN entrega en ON en.id_agricultor = a.id_agricultor
GROUP BY a.municipio;

CREATE VIEW vw_estoque_por_tipo AS
SELECT 
    l.tipo_semente,
    SUM(e.quantidade) AS total_estoque
FROM estoque e
JOIN lote l ON l.id_lote = e.id_lote
GROUP BY l.tipo_semente;

CREATE VIEW vw_entrega_movimentacao_lote AS
SELECT 
    l.numero_lote,
    SUM(en.quantidade) AS total_entregue,
    SUM(CASE WHEN m.tipo = 'saida' THEN m.quantidade ELSE 0 END) AS total_mov_saida,
    SUM(CASE WHEN m.tipo = 'entrada' THEN m.quantidade ELSE 0 END) AS total_mov_entrada
FROM lote l
LEFT JOIN entrega en ON en.id_lote = l.id_lote
LEFT JOIN estoque e ON e.id_lote = l.id_lote
LEFT JOIN movimentacao m ON m.id_estoque = e.id_estoque
GROUP BY l.numero_lote;


















