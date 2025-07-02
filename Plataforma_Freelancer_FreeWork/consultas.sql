-- Consultas SQL

-- ALTER TABLE
ALTER TABLE Freelancer
ADD Portfolio_URL VARCHAR2(255);

-- INSERT INTO
-- Inserindo um novo usuário que será tanto cliente quanto freelancer
INSERT INTO Usuario (CPF_PK, Nome, Senha, Email, CEP_FK, Numero_Endereco, Complemento_Endereco)
VALUES ('99988877766', 'Julia Mendes', 'julia123', 'julia.mendes@email.com', '51000000', '500', 'Ap 802');

INSERT INTO Freelancer (CPF_Usuario_FK_PK, DataEntrada, Curriculo, Portfolio_URL)
VALUES ('99988877766', SYSDATE, 'Nova freelancer especialista em UX/UI design.', 'http://juliaportfolio.com');

INSERT INTO Cliente (CPF_Usuario_FK_PK, DataRegistro)
VALUES ('99988877766', SYSDATE);


-- UPDATE
-- Atualizando a URL do portfólio do freelancer
UPDATE Freelancer
SET Portfolio_URL = 'http://juliaportfolio.dev'
WHERE CPF_Usuario_FK_PK = '99988877766';


-- DELETE
-- Inserindo e deletando um projeto
INSERT INTO Projeto VALUES (seq_projeto.NEXTVAL, '66666666666', 'Projeto Teste para Deletar', 'Descrição de teste.', SYSDATE, SYSDATE + 10, 100.00, 'Cancelado');

DELETE FROM Projeto
WHERE Titulo = 'Projeto Teste para Deletar' AND CPF_Cliente_FK = '66666666666';


-- CREATE INDEX
-- Criando um índice na coluna Titulo da tabela Projeto para otimizar buscas por títulos de projetos
CREATE INDEX idx_projeto_titulo ON Projeto(Titulo);


-- SELECT-FROM-WHERE, INNER JOIN, LIKE, ORDER BY
-- Consulta para encontrar todos os freelancers cujo nome começa com 'J' e que são da categoria 'Design Gráfico'
-- Junta informações de Usuario, Freelancer, Freelancer_Categoria e Categoria
SELECT
    u.Nome,
    u.Email,
    c.Nome AS Categoria
FROM
    Usuario u
INNER JOIN
    Freelancer f ON u.CPF_PK = f.CPF_Usuario_FK_PK
INNER JOIN
    Freelancer_Categoria fc ON f.CPF_Usuario_FK_PK = fc.CPF_Freelancer_FK
INNER JOIN
    Categoria c ON fc.IDCategoria_FK = c.IDCategoria_PK
WHERE
    u.Nome LIKE 'J%'
    AND c.Nome = 'Design Gráfico'
ORDER BY
    u.Nome;


-- BETWEEN, IS NOT NULL
-- Consulta para selecionar projetos publicados no primeiro semestre de 2024
-- e que possuem um complemento de endereço do cliente preenchido
SELECT
    p.Titulo,
    p.DataPublicacao,
    u.Nome AS Nome_Cliente
FROM
    Projeto p
JOIN
    Cliente c ON p.CPF_Cliente_FK = c.CPF_Usuario_FK_PK
JOIN
    Usuario u ON c.CPF_Usuario_FK_PK = u.CPF_PK
WHERE
    p.DataPublicacao BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD') AND TO_DATE('2024-06-30', 'YYYY-MM-DD')
    AND u.Complemento_Endereco IS NOT NULL;


-- GROUP BY, HAVING, COUNT, AVG, MIN, MAX
-- Mostra a quantidade de propostas, o valor médio, mínimo e máximo das propostas de cada freelancer
-- Exibe apenas freelancers que fizeram mais de uma proposta e cuja média de valor é superior a 600
SELECT
    u.Nome,
    COUNT(prop.IDProposta_PK) AS "Qtd. Propostas",
    AVG(prop.ValorProposto) AS "Média de Valor",
    MIN(prop.ValorProposto) AS "Menor Proposta",
    MAX(prop.ValorProposto) AS "Maior Proposta"
FROM
    Usuario u
JOIN
    Freelancer f ON u.CPF_PK = f.CPF_Usuario_FK_PK
JOIN
    Proposta prop ON f.CPF_Usuario_FK_PK = prop.CPF_Freelancer_FK
GROUP BY
    u.Nome
HAVING
    COUNT(prop.IDProposta_PK) >= 1 AND AVG(prop.ValorProposto) > 600
ORDER BY
    "Média de Valor" DESC;


-- LEFT OUTER JOIN, IS NULL
-- Listar todos os freelancers e os títulos dos projetos para os quais eles enviaram propostas
-- Obs.: freelancers que nunca enviaram propostas também aparecerão na lista, com o título do projeto como nulo
SELECT
    u.Nome AS Freelancer,
    p.Titulo AS Projeto
FROM
    Freelancer f
JOIN
    Usuario u ON f.CPF_Usuario_FK_PK = u.CPF_PK
LEFT OUTER JOIN
    Proposta prop ON f.CPF_Usuario_FK_PK = prop.CPF_Freelancer_FK
LEFT OUTER JOIN
    Projeto p ON prop.IDProjeto_FK = p.IDProjeto_PK
ORDER BY
    u.Nome;


-- SUBCONSULTA COM OPERADOR RELACIONAL (=)
-- Encontrar o nome do cliente que publicou o projeto mais caro
SELECT Nome
FROM Usuario
WHERE CPF_PK = (
    SELECT CPF_Cliente_FK
    FROM Projeto
    WHERE ValorEstimado = (
        SELECT MAX(ValorEstimado) FROM Projeto
    )
);

-- SUBCONSULTA COM IN
-- Listar o nome e o email de todos os usuários que são clientes
SELECT Nome, Email
FROM Usuario
WHERE CPF_PK IN (SELECT CPF_Usuario_FK_PK FROM Cliente);


-- SUBCONSULTA COM ANY
-- Encontrar freelancers que propuseram um valor maior que qualquer proposta para o projeto de ID 1,
-- além de excluir o próprio freelancer da comparação
SELECT u.Nome
FROM Usuario u
JOIN Proposta p ON u.CPF_PK = p.CPF_Freelancer_FK
WHERE p.ValorProposto > ANY (
    SELECT ValorProposto
    FROM Proposta
    WHERE IDProjeto_FK = 1
) AND u.CPF_PK != '11111111111'; -- 


-- SUBCONSULTA COM ALL
-- Encontrar o projeto cujo valor estimado é maior que todos os valores propostos por freelancers para qualquer projeto
SELECT Titulo, ValorEstimado
FROM Projeto
WHERE ValorEstimado > ALL (
    SELECT ValorProposto
    FROM Proposta
    WHERE ValorProposto IS NOT NULL
);

-- UNION
-- Listar o nome de todos os usuários que são freelancers ou clientes
(SELECT u.Nome FROM Usuario u JOIN Freelancer f ON u.CPF_PK = f.CPF_Usuario_FK_PK)
UNION
(SELECT u.Nome FROM Usuario u JOIN Cliente c ON u.CPF_PK = c.CPF_Usuario_FK_PK);


-- MINUS
-- Listar usuários que são freelancers mas não são clientes
(SELECT u.Nome
 FROM Usuario u
 WHERE u.CPF_PK IN (SELECT CPF_Usuario_FK_PK FROM Freelancer))
MINUS
(SELECT u.Nome
 FROM Usuario u
 WHERE u.CPF_PK IN (SELECT CPF_Usuario_FK_PK FROM Cliente));


-- CREATE VIEW
-- Criando uma visão que simplifica a consulta de detalhes de contratos,
-- juntando informações de projeto, cliente, freelancer e contrato
CREATE OR REPLACE VIEW vw_Detalhes_Contrato AS
SELECT
    c.IDContrato_PK,
    p.Titulo AS Titulo_Projeto,
    cli_u.Nome AS Nome_Cliente,
    free_u.Nome AS Nome_Freelancer,
    prop.ValorProposto,
    c.DataInicio,
    c.DataTermino,
    c.Status AS Status_Contrato
FROM
    Contrato c
JOIN
    Proposta prop ON c.IDProposta_FK = prop.IDProposta_PK
JOIN
    Projeto p ON prop.IDProjeto_FK = p.IDProjeto_PK
JOIN
    Freelancer free ON prop.CPF_Freelancer_FK = free.CPF_Usuario_FK_PK
JOIN
    Usuario free_u ON free.CPF_Usuario_FK_PK = free_u.CPF_PK
JOIN
    Cliente cli ON p.CPF_Cliente_FK = cli.CPF_Usuario_FK_PK
JOIN
    Usuario cli_u ON cli.CPF_Usuario_FK_PK = cli_u.CPF_PK;

-- Usando a view criada
SELECT * FROM vw_Detalhes_Contrato WHERE Status_Contrato = 'Concluído';


-- Consultas PL/SQL


SET SERVEROUTPUT ON;

-- BLOCO ANÔNIMO, %TYPE, SELECT ... INTO
-- Bloco anônimo para buscar o email de um usuário específico e exibir ele
DECLARE
    v_cpf_usuario Usuario.CPF_PK%TYPE := '11111111111';
    v_email_usuario Usuario.Email%TYPE;
BEGIN
    SELECT Email INTO v_email_usuario
    FROM Usuario
    WHERE CPF_PK = v_cpf_usuario;

    DBMS_OUTPUT.PUT_LINE('O email do usuário ' || v_cpf_usuario || ' é: ' || v_email_usuario);
END;
/


-- CREATE PROCEDURE, USO DE PARÂMETROS (IN, OUT), IF ELSIF, EXCEPTION WHEN
-- Procedimento para atualizar o status de um projeto
-- Valida o novo status e trata exceções caso o projeto não seja encontrado
CREATE OR REPLACE PROCEDURE prc_atualizar_status_projeto (
    p_id_projeto IN Projeto.IDProjeto_PK%TYPE,
    p_novo_status IN Projeto.Status%TYPE,
    p_mensagem OUT VARCHAR2
)
IS
    v_count NUMBER;
BEGIN
    -- Verifica se o projeto existe
    SELECT COUNT(*) INTO v_count FROM Projeto WHERE IDProjeto_PK = p_id_projeto;

    IF v_count = 0 THEN
        p_mensagem := 'ERRO: Projeto com ID ' || p_id_projeto || ' não encontrado.';
        RETURN;
    END IF;

    -- Valida o novo status
    IF p_novo_status IN ('Aberto', 'Em andamento', 'Concluído', 'Cancelado') THEN
        UPDATE Projeto
        SET Status = p_novo_status
        WHERE IDProjeto_PK = p_id_projeto;
        COMMIT;
        p_mensagem := 'Status do projeto ' || p_id_projeto || ' atualizado para "' || p_novo_status || '" com sucesso.';
    ELSE
        p_mensagem := 'ERRO: Status "' || p_novo_status || '" é inválido.';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensagem := 'ERRO inesperado ao atualizar projeto: ' || SQLERRM;
END;
/
-- Exemplo de uso do Procedure
DECLARE
    v_msg VARCHAR2(200);
BEGIN
    prc_atualizar_status_projeto(p_id_projeto => 2, p_novo_status => 'Em andamento', p_mensagem => v_msg);
    DBMS_OUTPUT.PUT_LINE(v_msg);
    prc_atualizar_status_projeto(p_id_projeto => 999, p_novo_status => 'Concluído', p_mensagem => v_msg);
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/


-- CREATE FUNCTION, %ROWTYPE, CASE WHEN
-- Função que retorna a reputação de um freelancer com base na sua nota média de avaliação
CREATE OR REPLACE FUNCTION fnc_reputacao_freelancer (
    p_cpf_freelancer IN Freelancer.CPF_Usuario_FK_PK%TYPE
) RETURN VARCHAR2
IS
    v_media_notas NUMBER;
    v_reputacao VARCHAR2(20);
BEGIN
    -- Usando %ROWTYPE implicitamente no SELECT INTO
    SELECT AVG(a.Nota) INTO v_media_notas
    FROM Avaliacao a
    JOIN Contrato c ON a.IDContrato_FK = c.IDContrato_PK
    JOIN Proposta p ON c.IDProposta_FK = p.IDProposta_PK
    WHERE p.CPF_Freelancer_FK = p_cpf_freelancer;

    IF v_media_notas IS NULL THEN
        RETURN 'Sem avaliações';
    END IF;

    v_reputacao :=
        CASE
            WHEN v_media_notas >= 9 THEN 'Excelente'
            WHEN v_media_notas >= 7 THEN 'Bom'
            WHEN v_media_notas >= 5 THEN 'Regular'
            ELSE 'A melhorar'
        END;

    RETURN v_reputacao;
END;
/
-- Exemplo de uso da Function
BEGIN
    DBMS_OUTPUT.PUT_LINE('Reputação do freelancer 11111111111: ' || fnc_reputacao_freelancer('11111111111'));
    DBMS_OUTPUT.PUT_LINE('Reputação do freelancer 44444444444: ' || fnc_reputacao_freelancer('44444444444'));
END;
/

-- CURSOR (OPEN, FETCH, CLOSE), LOOP EXIT WHEN, FOR IN LOOP, WHILE LOOP
-- Procedimento que mostra 3 tipos de loops e o uso de cursores explícitos
CREATE OR REPLACE PROCEDURE prc_demonstrar_loops_e_cursores (
    p_cpf_cliente IN Cliente.CPF_Usuario_FK_PK%TYPE
)
IS
    CURSOR c_projetos_cliente IS
        SELECT Titulo, ValorEstimado FROM Projeto WHERE CPF_Cliente_FK = p_cpf_cliente;
    
    v_projeto_rec c_projetos_cliente%ROWTYPE;

    v_contador NUMBER := 1;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- USANDO LOOP EXIT WHEN COM CURSOR EXPLÍCITO ---');
    OPEN c_projetos_cliente;
    LOOP
        FETCH c_projetos_cliente INTO v_projeto_rec;
        EXIT WHEN c_projetos_cliente%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Projeto: ' || v_projeto_rec.Titulo || ' | Valor: ' || v_projeto_rec.ValorEstimado);
    END LOOP;
    CLOSE c_projetos_cliente;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- USANDO FOR IN COM CURSOR IMPLÍCITO ---');
    -- FOR IN LOOP é mais conciso, não precisa de OPEN, FETCH, CLOSE
    FOR rec IN (SELECT Nome, Email FROM Usuario WHERE CEP_FK = '50000000') LOOP
        DBMS_OUTPUT.PUT_LINE('Usuário de Recife: ' || rec.Nome || ' (' || rec.Email || ')');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- USANDO WHILE ---');
    WHILE v_contador <= 3 LOOP
        DBMS_OUTPUT.PUT_LINE('Contagem do While: ' || v_contador);
        v_contador := v_contador + 1;
    END LOOP;

END;
/
-- Exemplo de uso do Procedure
BEGIN
    prc_demonstrar_loops_e_cursores('22222222222');
END;
/

-- USO DE RECORD, USO DE ESTRUTURA DE DADOS DO TIPO TABLE
-- Bloco anônimo que usa um tipo RECORD customizado e um tipo TABLE (collection)
-- para armazenar um resumo de freelancers e suas habilidades
DECLARE
    -- Definindo um tipo de RECORD
    TYPE t_freelancer_habilidade_rec IS RECORD (
        nome_freelancer   Usuario.Nome%TYPE,
        nome_habilidade   Habilidade.Nome%TYPE
    );

    -- Definindo um tipo de COLLECTION baseada no record
    TYPE t_freelancer_habilidade_tab IS TABLE OF t_freelancer_habilidade_rec;

    -- Instanciando a collection
    v_freelancer_habilidades t_freelancer_habilidade_tab;

BEGIN
    -- Populando a collection com uma consulta
    SELECT u.Nome, h.Nome
    BULK COLLECT INTO v_freelancer_habilidades
    FROM Usuario u
    JOIN Freelancer_Habilidade fh ON u.CPF_PK = fh.CPF_Freelancer_FK
    JOIN Habilidade h ON fh.IDHabilidade_FK = h.IDHabilidade_PK
    ORDER BY u.Nome;

    -- Iterando pela collection para exibir os dados
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- RELATÓRIO DE FREELANCERS E HABILIDADES (USANDO RECORD E TABLE) ---');
    FOR i IN 1..v_freelancer_habilidades.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Freelancer: ' || v_freelancer_habilidades(i).nome_freelancer ||
            ' | Habilidade: ' || v_freelancer_habilidades(i).nome_habilidade
        );
    END LOOP;
END;
/


-- CREATE OR REPLACE PACKAGE, CREATE OR REPLACE PACKAGE BODY
-- Criando um package para agrupar funcionalidades relacionadas a gestão de Propostas
-- 1. PACKAGE SPEC
CREATE OR REPLACE PACKAGE pkg_gestao_propostas AS

    -- Procedure para criar uma nova proposta
    PROCEDURE prc_criar_proposta (
        p_id_projeto      IN Proposta.IDProjeto_FK%TYPE,
        p_cpf_freelancer  IN Proposta.CPF_Freelancer_FK%TYPE,
        p_valor_proposto  IN Proposta.ValorProposto%TYPE,
        p_prazo_proposto  IN Proposta.PrazoProposto%TYPE
    );

    -- Função para obter o número de propostas de um projeto
    FUNCTION fnc_contar_propostas_projeto (
        p_id_projeto IN Projeto.IDProjeto_PK%TYPE
    ) RETURN NUMBER;

END pkg_gestao_propostas;
/


-- 2. PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY pkg_gestao_propostas AS

    -- Implementação do Procedure
    PROCEDURE prc_criar_proposta (
        p_id_projeto      IN Proposta.IDProjeto_FK%TYPE,
        p_cpf_freelancer  IN Proposta.CPF_Freelancer_FK%TYPE,
        p_valor_proposto  IN Proposta.ValorProposto%TYPE,
        p_prazo_proposto  IN Proposta.PrazoProposto%TYPE
    ) IS
        v_max_proposta_id NUMBER;
    BEGIN
        SELECT NVL(MAX(IDProposta_PK), 0) + 1 INTO v_max_proposta_id FROM Proposta;

        INSERT INTO Proposta (IDProposta_PK, IDProjeto_FK, CPF_Freelancer_FK, ValorProposto, PrazoProposto, Status)
        VALUES (v_max_proposta_id, p_id_projeto, p_cpf_freelancer, p_valor_proposto, p_prazo_proposto, 'Aguardando');

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Proposta ' || v_max_proposta_id || ' criada com sucesso.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Erro ao criar proposta: ' || SQLERRM);
    END;

    -- Implementação da Função
    FUNCTION fnc_contar_propostas_projeto (
        p_id_projeto IN Projeto.IDProjeto_PK%TYPE
    ) RETURN NUMBER IS
        v_total_propostas NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total_propostas
        FROM Proposta
        WHERE IDProjeto_FK = p_id_projeto;

        RETURN v_total_propostas;
    END;

END pkg_gestao_propostas;
/
-- Exemplo de uso do Package
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- USANDO O PACOTE pkg_gestao_propostas ---');
    -- Chamando a função do pacote
    DBMS_OUTPUT.PUT_LINE('O projeto 1 tem ' || pkg_gestao_propostas.fnc_contar_propostas_projeto(1) || ' proposta(s).');

    -- Chamando o procedure do pacote
    pkg_gestao_propostas.prc_criar_proposta(
        p_id_projeto     => 1,
        p_cpf_freelancer => '44444444444',
        p_valor_proposto => 780,
        p_prazo_proposto => TO_DATE('2024-03-25', 'YYYY-MM-DD')
    );
END;
/
-- CREATE OR REPLACE TRIGGER (COMANDO)
-- Trigger de comando que audita operações DML na tabela Projeto
CREATE OR REPLACE TRIGGER trg_auditar_projetos
BEFORE INSERT OR UPDATE OR DELETE ON Projeto
DECLARE
    v_operacao VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Operação ' || v_operacao || ' na tabela Projeto em ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
END;
/

-- Testando o trigger de comando
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TESTANDO TRIGGER DE COMANDO ---');
    -- Inserção (disparará o trigger)
    INSERT INTO Projeto VALUES (seq_projeto.NEXTVAL, '22222222222', 'Projeto Teste Trigger', 'Descrição teste.', SYSDATE, SYSDATE + 10, 500.00, 'Aberto');
    
    -- Atualização (disparará o trigger)
    UPDATE Projeto SET ValorEstimado = 550 WHERE Titulo = 'Projeto Teste Trigger';
    
    -- Exclusão (disparará o trigger)
    DELETE FROM Projeto WHERE Titulo = 'Projeto Teste Trigger';
    
    COMMIT;
END;
/


-- CREATE OR REPLACE TRIGGER (LINHA)
-- Trigger de linha que registra histórico de alterações na tabela Proposta
CREATE OR REPLACE TRIGGER trg_historico_propostas
AFTER UPDATE OF ValorProposto, PrazoProposto, Status ON Proposta
FOR EACH ROW
BEGIN
    -- Verifica se houve mudança no valor proposto
    IF :OLD.ValorProposto != :NEW.ValorProposto THEN
        DBMS_OUTPUT.PUT_LINE('Proposta ' || :NEW.IDProposta_PK || 
                            ': Valor alterado de ' || :OLD.ValorProposto || 
                            ' para ' || :NEW.ValorProposto);
    END IF;
    
    -- Verifica se houve mudança no prazo proposto
    IF :OLD.PrazoProposto != :NEW.PrazoProposto THEN
        DBMS_OUTPUT.PUT_LINE('Proposta ' || :NEW.IDProposta_PK || 
                            ': Prazo alterado de ' || TO_CHAR(:OLD.PrazoProposto, 'DD/MM/YYYY') || 
                            ' para ' || TO_CHAR(:NEW.PrazoProposto, 'DD/MM/YYYY'));
    END IF;
    
    -- Verifica se houve mudança no status
    IF :OLD.Status != :NEW.Status THEN
        DBMS_OUTPUT.PUT_LINE('Proposta ' || :NEW.IDProposta_PK || 
                            ': Status alterado de "' || :OLD.Status || 
                            '" para "' || :NEW.Status || '"');
    END IF;
END;
/

-- Testando o trigger de linha
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- TESTANDO TRIGGER DE LINHA ---');
    -- Atualizando valor e status (disparará o trigger para cada linha afetada)
    UPDATE Proposta 
    SET ValorProposto = ValorProposto * 1.1, 
        Status = 'Aceita'
    WHERE IDProposta_PK IN (1, 2);
    
    -- Atualizando prazo (disparará o trigger)
    UPDATE Proposta
    SET PrazoProposto = PrazoProposto + 5
    WHERE IDProposta_PK = 3;
    
    COMMIT;
END;
/
