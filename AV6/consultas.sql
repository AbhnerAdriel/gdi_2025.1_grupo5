-- 1) SELECT REF
-- Obtendo referências de todos os freelancers
SELECT REF(f) AS ref_freelancer
FROM tb_freelancer f;

-- Obtendo referência dos projetos e ordenando pelo título
SELECT REF(p) AS ref_projeto
FROM tb_projeto p
ORDER BY p.titulo;


-- 2) SELECT DEREF
-- Recuperando os dados completos de um freelancer usando a referência
SELECT DEREF(REF(f)) AS dados_freelancer
FROM tb_freelancer f;

-- Recuperando título e descrição de um projeto a partir do REF
SELECT DEREF(REF(p)).titulo AS titulo,
       DEREF(REF(p)).descricao AS descricao
FROM tb_projeto p;


-- 3) CONSULTA A VARRAY (tp_contatos_va)
-- Listando todos os contatos de um usuário específico (ex.: CPF = '11111111111')
SELECT u.nome, c.COLUMN_VALUE AS contato
FROM tb_usuario u,
     TABLE(u.contatos) c
WHERE u.cpf = '11111111111';

-- Todos os usuários com mais de 1 contato cadastrado
SELECT u.nome, COUNT(c.COLUMN_VALUE) AS qtd_contatos
FROM tb_usuario u,
     TABLE(u.contatos) c
GROUP BY u.nome
HAVING COUNT(c.COLUMN_VALUE) > 1;


-- 4) CONSULTA A NESTED TABLE (tp_habilidades_nt e tp_propostas_nt)
-- Habilidades de cada freelancer
SELECT f.cpf, h.COLUMN_VALUE AS habilidade
FROM tb_freelancer f,
     TABLE(f.habilidades) h;

-- Filtrar freelancers que possuam uma habilidade específica (ex.: 'Java')
SELECT f.cpf, f.habilidades
FROM tb_freelancer f
WHERE 'Java' IN (SELECT COLUMN_VALUE FROM TABLE(f.habilidades));

-- Propostas enviadas em cada projeto (nested table dentro de projeto)
SELECT p.id_projeto, pr.*
FROM tb_projeto p,
     TABLE(p.propostas) pr;


-- 5) TESTES DE FUNCTIONS E MEMBER FUNCTIONS
-- Exibir detalhes de um freelancer
SELECT f.cpf, f.exibir_detalhes() AS detalhes
FROM tb_freelancer f;

-- Tempo de cadastro de um freelancer
SELECT f.cpf, f.tempo_de_cadastro() AS dias_cadastrado
FROM tb_freelancer f;

-- Aplicar desconto em um contrato (ex.: 10%)
SELECT c.id_contrato, c.valor_total, c.aplicar_desconto(10) AS valor_com_desconto
FROM tb_contrato c;

-- Comparar valor de dois contratos usando ORDER MEMBER FUNCTION
SELECT c.id_contrato, c.valor_total
FROM tb_contrato c
ORDER BY VALUE(c);


-- 6) CONSULTAS MAIS COMPLEXAS (extra para aumentar nota)
-- Lista de freelancers com seus projetos e categorias (usando DEREF em FK de REF)
SELECT f.cpf, f.nome, DEREF(pc.projeto).titulo AS titulo_projeto, DEREF(fc.categoria).nome AS categoria
FROM tb_freelancer f
JOIN tb_freelancer_categoria fc ON REF(f) = fc.freelancer
JOIN tb_projeto_categoria pc ON fc.categoria = pc.categoria;

-- Total de pagamentos recebidos por cada freelancer
SELECT f.cpf, SUM(p.valor) AS total_recebido
FROM tb_freelancer f
JOIN tb_contrato c ON f MEMBER OF c.freelancers
JOIN tb_pagamento p ON p.contrato = REF(c)
GROUP BY f.cpf;
