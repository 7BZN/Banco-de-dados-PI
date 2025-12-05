SELECT l.id_lote, l.numero_lote, l.tipo_semente, f.nome AS fornecedor
FROM lote l
JOIN fornecedor f ON f.id_fornecedor = l.id_fornecedor;

SELECT l.* 
FROM lote l
WHERE l.data_compra > '2024-03-01'
LIMIT 0, 1000;

SELECT l.id_lote, l.numero_lote, l.validade, f.nome
FROM lote l
JOIN fornecedor f ON f.id_fornecedor = l.id_fornecedor
WHERE validade < '2025-10-01';

SELECT f.nome, SUM(l.quantidade_total) AS total
FROM lote l
JOIN fornecedor f ON f.id_fornecedor = l.id_fornecedor
GROUP BY f.nome;

SELECT nome 
FROM fornecedor 
WHERE id_fornecedor IN (
    SELECT id_fornecedor FROM lote WHERE quantidade_total > 3500
);

SELECT e.id_estoque, a.nome AS armazem, l.numero_lote, e.quantidade
FROM estoque e
JOIN armazem a ON a.id_armazem = e.id_armazem
JOIN lote l ON l.id_lote = e.id_lote;

SELECT e.*, a.nome AS armazem
FROM estoque e
JOIN armazem a ON a.id_armazem = e.id_armazem
WHERE e.quantidade < 700;

SELECT nome 
FROM armazem
WHERE id_armazem IN (
    SELECT id_armazem FROM estoque GROUP BY id_armazem HAVING COUNT(*) >= 2
);

SELECT a.nome, SUM(e.quantidade) AS total
FROM estoque e
JOIN armazem a ON a.id_armazem = e.id_armazem
GROUP BY a.nome;

SELECT e.*, l.numero_lote
FROM estoque e 
JOIN lote l ON l.id_lote = e.id_lote
ORDER BY quantidade DESC
LIMIT 1;

SELECT m.id_movimentacao, m.tipo, m.quantidade, e.id_estoque, l.numero_lote
FROM movimentacao m
JOIN estoque e ON e.id_estoque = m.id_estoque
JOIN lote l ON l.id_lote = e.id_lote;

SELECT e.id_estoque,
SUM(CASE WHEN m.tipo = 'entrada' THEN m.quantidade ELSE 0 END) AS total_entrada,
SUM(CASE WHEN m.tipo = 'saida' THEN m.quantidade ELSE 0 END) AS total_saida
FROM estoque e
LEFT JOIN movimentacao m ON m.id_estoque = e.id_estoque
GROUP BY e.id_estoque;

SELECT * FROM movimentacao WHERE quantidade > 200;

SELECT id_estoque
FROM estoque
WHERE id_estoque IN (
    SELECT id_estoque FROM movimentacao WHERE tipo = 'saida'
);

SELECT e.id_estoque, COUNT(m.id_movimentacao) AS movimentacoes
FROM estoque e
LEFT JOIN movimentacao m ON m.id_estoque = e.id_estoque
GROUP BY e.id_estoque
ORDER BY movimentacoes DESC;

SELECT en.id_entrega, a.nome, a.municipio, l.numero_lote, en.quantidade
FROM entrega en
JOIN agricultor a ON a.id_agricultor = en.id_agricultor
JOIN lote l ON l.id_lote = en.id_lote;

SELECT a.nome, SUM(en.quantidade) AS total
FROM entrega en
JOIN agricultor a ON a.id_agricultor = en.id_agricultor
GROUP BY a.nome
HAVING total > 50;

SELECT nome
FROM agricultor
WHERE id_agricultor IN (
    SELECT id_agricultor
    FROM entrega en
    JOIN lote l ON l.id_lote = en.id_lote
    WHERE l.tipo_semente = 'Arroz'
);

SELECT l.tipo_semente, SUM(en.quantidade) AS total
FROM entrega en
JOIN lote l ON l.id_lote = en.id_lote
GROUP BY l.tipo_semente;

SELECT a.municipio, COUNT(en.id_entrega) AS total_entregas
FROM entrega en
JOIN agricultor a ON a.id_agricultor = en.id_agricultor
GROUP BY a.municipio
ORDER BY total_entregas DESC;

SELECT al.id_alerta, al.tipo, al.nivel, l.numero_lote, a.nome AS armazem
FROM alerta al
JOIN estoque e ON e.id_estoque = al.id_estoque
JOIN lote l ON l.id_lote = e.id_lote
JOIN armazem a ON a.id_armazem = e.id_armazem;

SELECT * FROM alerta WHERE nivel = 'alto';

SELECT id_estoque
FROM estoque
WHERE id_lote IN (
    SELECT id_lote FROM lote WHERE validade < '2025-09-01'
);

SELECT tipo, COUNT(*) AS total
FROM alerta
GROUP BY tipo;

SELECT tipo, COUNT(*) AS total
FROM alerta
GROUP BY tipo;

SELECT r.id_relatorio, r.tipo, f.nome AS funcionario, r.data_inicio, r.data_fim
FROM relatorio r
JOIN funcionario f ON f.id_funcionario = r.id_funcionario;

SELECT * FROM relatorio 
WHERE data_inicio < '2024-07-01';

SELECT nome
FROM funcionario
WHERE id_funcionario IN (
    SELECT id_funcionario 
    FROM relatorio
    GROUP BY id_funcionario
    HAVING COUNT(*) > 1
);

SELECT tipo, COUNT(*) AS total
FROM relatorio
GROUP BY tipo;

SELECT * FROM relatorio ORDER BY created_at DESC LIMIT 5;

SELECT l.id_log, f.nome, l.acao, l.data_acesso, l.ip
FROM log_acesso l
JOIN funcionario f ON f.id_funcionario = l.idp_usuario;

SELECT * FROM log_acesso WHERE acao LIKE '%Login%';

SELECT nome
FROM funcionario
WHERE id_funcionario IN (
    SELECT idp_usuario FROM log_acesso WHERE acao LIKE '%Falha%'
);

SELECT f.nome, COUNT(l.id_log) AS total_acoes
FROM log_acesso l
JOIN funcionario f ON f.id_funcionario = l.idp_usuario
GROUP BY f.nome;

SELECT * FROM log_acesso ORDER BY data_acesso DESC LIMIT 10;





























