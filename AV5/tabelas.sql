-- Tabela para Habilidades (para popular a nested table)
CREATE TABLE tb_habilidades_or OF tp_habilidade_or;

-- Tabela para Freelancers
CREATE TABLE tb_freelancers_or OF tp_freelancer_or (
    CPF PRIMARY KEY,
    NESTED TABLE Habilidades STORE AS nt_habilidades_freela
);

-- Tabela para Clientes
CREATE TABLE tb_clientes_or OF tp_cliente_or (
    CPF PRIMARY KEY
);

-- Tabela para Projetos
CREATE TABLE tb_projetos_or OF tp_projeto_or (
    IDProjeto PRIMARY KEY,
    SCOPE FOR (Cliente_REF) IS tb_clientes_or,
    NESTED TABLE Propostas STORE AS nt_propostas_projeto
);