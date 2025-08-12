-- Tipo para o endereço
CREATE OR REPLACE TYPE tp_endereco_or AS OBJECT (
    Rua VARCHAR2(100),
    Bairro VARCHAR2(50),
    Cidade VARCHAR2(50),
    Estado VARCHAR2(2)
);
/

-- Tipo para contatos
CREATE OR REPLACE TYPE tp_contatos_va AS VARRAY(5) OF VARCHAR2(50);
/

-- Tipo para Habilidade
CREATE OR REPLACE TYPE tp_habilidade_or AS OBJECT (
    IDHabilidade NUMBER,
    Nome VARCHAR2(50)
);
/
-- Tipo Nested Table para armazenar um conjunto de habilidades
CREATE OR REPLACE TYPE tp_habilidades_nt AS TABLE OF tp_habilidade_or;
/

-- TIPO PAI (BASE) - USUÁRIO
CREATE OR REPLACE TYPE tp_usuario_or AS OBJECT (
    CPF VARCHAR2(11),
    Nome VARCHAR2(100),
    Email VARCHAR2(100),
    Endereco tp_endereco_or,
    Contatos tp_contatos_va,
    NOT INSTANTIABLE MEMBER FUNCTION exibir_detalhes RETURN VARCHAR2
) NOT FINAL NOT INSTANTIABLE;
/

-- TIPO FILHO - FREELANCER (herda de Usuário)
CREATE OR REPLACE TYPE tp_freelancer_or UNDER tp_usuario_or (
    DataEntrada DATE,
    Curriculo CLOB,
    Habilidades tp_habilidades_nt,
    OVERRIDING MEMBER FUNCTION exibir_detalhes RETURN VARCHAR2,
    CONSTRUCTOR FUNCTION tp_freelancer_or(p_cpf VARCHAR2, p_nome VARCHAR2) RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY tp_freelancer_or AS
    OVERRIDING MEMBER FUNCTION exibir_detalhes RETURN VARCHAR2 IS
    BEGIN
        RETURN 'FREELANCER: ' || self.Nome || ' (CPF: ' || self.CPF || ') - Email: ' || self.Email;
    END;

    CONSTRUCTOR FUNCTION tp_freelancer_or(p_cpf VARCHAR2, p_nome VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        self.CPF := p_cpf;
        self.Nome := p_nome;
        self.Email := LOWER(REPLACE(p_nome, ' ', '.')) || '@freela.com';
        self.DataEntrada := SYSDATE;
        RETURN;
    END;
END;
/

-- TIPO FILHO - CLIENTE (herda de Usuário)
CREATE OR REPLACE TYPE tp_cliente_or UNDER tp_usuario_or (
    DataRegistro DATE,
    OVERRIDING MEMBER FUNCTION exibir_detalhes RETURN VARCHAR2,
    FINAL MEMBER FUNCTION tempo_de_cadastro RETURN NUMBER
) FINAL;
/

CREATE OR REPLACE TYPE BODY tp_cliente_or AS
    OVERRIDING MEMBER FUNCTION exibir_detalhes RETURN VARCHAR2 IS
    BEGIN
        RETURN 'CLIENTE: ' || self.Nome || ' (CPF: ' || self.CPF || ') - Email: ' || self.Email;
    END;

    FINAL MEMBER FUNCTION tempo_de_cadastro RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(SYSDATE - self.DataRegistro);
    END;
END;
/

-- Tipo para Proposta
CREATE OR REPLACE TYPE tp_proposta_or AS OBJECT (
    IDProposta NUMBER,
    ValorProposto NUMBER,
    Freelancer_REF REF tp_freelancer_or,
    MEMBER PROCEDURE aplicar_desconto(p_percentual NUMBER),
    ORDER MEMBER FUNCTION comparar_valor(p_proposta tp_proposta_or) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY tp_proposta_or AS
    MEMBER PROCEDURE aplicar_desconto(p_percentual NUMBER) IS
    BEGIN
        self.ValorProposto := self.ValorProposto * (1 - p_percentual / 100);
        DBMS_OUTPUT.PUT_LINE('Desconto aplicado. Novo valor: ' || self.ValorProposto);
    END;

    ORDER MEMBER FUNCTION comparar_valor(p_proposta tp_proposta_or) RETURN NUMBER IS
    BEGIN
        IF self.ValorProposto < p_proposta.ValorProposto THEN
            RETURN -1;
        ELSIF self.ValorProposto > p_proposta.ValorProposto THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;
END;
/

-- Nested Table para armazenar propostas dentro de um projeto
CREATE OR REPLACE TYPE tp_propostas_nt AS TABLE OF tp_proposta_or;
/

-- Tipo para Projeto
CREATE OR REPLACE TYPE tp_projeto_or AS OBJECT (
    IDProjeto NUMBER,
    Titulo VARCHAR2(100),
    Descricao CLOB,
    Cliente_REF REF tp_cliente_or,
    Propostas tp_propostas_nt,
    MAP MEMBER FUNCTION obter_id RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY tp_projeto_or AS
    MAP MEMBER FUNCTION obter_id RETURN NUMBER IS
    BEGIN
        RETURN self.IDProjeto;
    END;
END;
/

PROMPT Tipos criados com sucesso.;
