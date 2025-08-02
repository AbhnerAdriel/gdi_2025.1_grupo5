SET SERVEROUTPUT ON;

-- Povoando habilidades
INSERT INTO tb_habilidades_or VALUES (tp_habilidade_or(1, 'Oracle SQL'));
INSERT INTO tb_habilidades_or VALUES (tp_habilidade_or(2, 'PL/SQL'));
INSERT INTO tb_habilidades_or VALUES (tp_habilidade_or(3, 'Java'));
INSERT INTO tb_habilidades_or VALUES (tp_habilidade_or(4, 'UX Design'));

-- Inserindo Clientes
INSERT INTO tb_clientes_or VALUES (
    tp_cliente_or(
        '22222222222',
        'Maria Souza',
        'maria.souza@cliente.com',
        tp_endereco_or('Av. Brasil', 'Aldeota', 'Fortaleza', 'CE'),
        tp_contatos_va('(85)88888-2222'),
        TO_DATE('2024-03-01','YYYY-MM-DD')
    )
);

INSERT INTO tb_clientes_or VALUES (
    tp_cliente_or(
        '66666666666',
        'Luana Costa',
        'luana.costa@cliente.com',
        tp_endereco_or('Av. das Nações', 'Centro', 'Curitiba', 'PR'),
        tp_contatos_va('(41)97777-8888', 'luana.c.telegram'),
        TO_DATE('2024-01-05','YYYY-MM-DD')
    )
);

-- Inserindo Freelancers
INSERT INTO tb_freelancers_or VALUES (
    tp_freelancer_or(
        '11111111111',
        'João Silva',
        'joao.silva@freela.com',
        tp_endereco_or('Rua das Flores', 'Centro', 'Recife', 'PE'),
        tp_contatos_va('(81)99999-1111'),
        TO_DATE('2023-01-10','YYYY-MM-DD'),
        'Especialista em Banco de Dados Oracle.',
        tp_habilidades_nt(
            tp_habilidade_or(1, 'Oracle SQL'),
            tp_habilidade_or(2, 'PL/SQL')
        )
    )
);

INSERT INTO tb_freelancers_or VALUES (
    tp_freelancer_or(
        '44444444444',
        'Ana Beatriz'
    )
);
-- Atualizando o freelancer criado com o construtor mínimo
UPDATE tb_freelancers_or f
SET f.Endereco = tp_endereco_or('Rua Verde', 'Boa Viagem', 'Recife', 'PE'),
    f.Habilidades = tp_habilidades_nt(tp_habilidade_or(4, 'UX Design'))
WHERE f.CPF = '44444444444';


-- Inserindo um Projeto com Propostas Aninhadas
INSERT INTO tb_projetos_or VALUES (
    tp_projeto_or(
        1,
        'Sistema de Gestão de Freelancers',
        'Desenvolver um sistema completo em Oracle.',
        (SELECT REF(c) FROM tb_clientes_or c WHERE c.CPF = '22222222222'),
        tp_propostas_nt(
            tp_proposta_or(
                101,
                5000,
                (SELECT REF(f) FROM tb_freelancers_or f WHERE f.CPF = '11111111111')
            ),
            tp_proposta_or(
                102,
                4800,
                (SELECT REF(f) FROM tb_freelancers_or f WHERE f.CPF = '44444444444')
            )
        )
    )
);

COMMIT;