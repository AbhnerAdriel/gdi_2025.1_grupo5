
-- DROP SEQUENCES
DROP SEQUENCE seq_projeto;
DROP SEQUENCE seq_contrato;
DROP SEQUENCE seq_pagamento;
DROP SEQUENCE seq_categoria;
DROP SEQUENCE seq_habilidade;

-- CRIAÇÃO DAS SEQUENCES
CREATE SEQUENCE seq_projeto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_contrato START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pagamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_categoria START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_habilidade START WITH 1 INCREMENT BY 1;


-- INSERÇÕES DE DADOS

-- Endereços
INSERT INTO Endereco VALUES ('50000000', 'Rua das Flores', 'Centro', 'Recife', 'PE');
INSERT INTO Endereco VALUES ('60000000', 'Av. Brasil', 'Aldeota', 'Fortaleza', 'CE');
INSERT INTO Endereco VALUES ('51000000', 'Rua Verde', 'Boa Viagem', 'Recife', 'PE');
INSERT INTO Endereco VALUES ('70000000', 'Rua do Sol', 'Asa Norte', 'Brasília', 'DF');
INSERT INTO Endereco VALUES ('80000000', 'Av. das Nações', 'Centro', 'Curitiba', 'PR');

-- Usuários
INSERT INTO Usuario VALUES ('11111111111', 'João Silva', 'senha123', 'joao@email.com', '50000000', '100', 'Ap 101');
INSERT INTO Usuario VALUES ('22222222222', 'Maria Souza', 'senha456', 'maria@email.com', '60000000', '200', NULL);
INSERT INTO Usuario VALUES ('33333333333', 'Carlos Lima', 'senha789', 'carlos@email.com', '50000000', '150', NULL);
INSERT INTO Usuario VALUES ('44444444444', 'Ana Beatriz', 'ana123', 'ana@email.com', '51000000', '45', 'Bloco B');
INSERT INTO Usuario VALUES ('55555555555', 'Felipe Torres', 'felipe456', 'felipe@email.com', '70000000', '80', NULL);
INSERT INTO Usuario VALUES ('66666666666', 'Luana Costa', 'luana789', 'luana@email.com', '80000000', '300', 'Casa');

-- Contatos
INSERT INTO Contato_Usuario VALUES ('11111111111', '(81)99999-1111');
INSERT INTO Contato_Usuario VALUES ('11111111111', 'joao.whatsapp');
INSERT INTO Contato_Usuario VALUES ('22222222222', '(85)88888-2222');
INSERT INTO Contato_Usuario VALUES ('44444444444', '(81)91234-5678');
INSERT INTO Contato_Usuario VALUES ('55555555555', '(61)99876-4321');
INSERT INTO Contato_Usuario VALUES ('66666666666', '(41)97777-8888');

-- Freelancers
INSERT INTO Freelancer VALUES ('11111111111', TO_DATE('2023-01-10','YYYY-MM-DD'), 'Currículo do João');
INSERT INTO Freelancer VALUES ('33333333333', TO_DATE('2023-02-15','YYYY-MM-DD'), 'Currículo do Carlos');
INSERT INTO Freelancer VALUES ('44444444444', TO_DATE('2023-05-20','YYYY-MM-DD'), 'Currículo da Ana');
INSERT INTO Freelancer VALUES ('55555555555', TO_DATE('2023-06-15','YYYY-MM-DD'), 'Currículo do Felipe');

-- Clientes
INSERT INTO Cliente VALUES ('22222222222', TO_DATE('2024-03-01','YYYY-MM-DD'));
INSERT INTO Cliente VALUES ('66666666666', TO_DATE('2024-01-05','YYYY-MM-DD'));

-- Categorias
INSERT INTO Categoria VALUES (seq_categoria.NEXTVAL, 'Design Gráfico');
INSERT INTO Categoria VALUES (seq_categoria.NEXTVAL, 'Desenvolvimento Web');
INSERT INTO Categoria VALUES (seq_categoria.NEXTVAL, 'Marketing Digital');
INSERT INTO Categoria VALUES (seq_categoria.NEXTVAL, 'Tradução');
INSERT INTO Categoria VALUES (seq_categoria.NEXTVAL, 'Suporte Técnico');

-- Habilidades
INSERT INTO Habilidade VALUES (seq_habilidade.NEXTVAL, 'Photoshop');
INSERT INTO Habilidade VALUES (seq_habilidade.NEXTVAL, 'HTML/CSS');
INSERT INTO Habilidade VALUES (seq_habilidade.NEXTVAL, 'JavaScript');
INSERT INTO Habilidade VALUES (seq_habilidade.NEXTVAL, 'SEO');
INSERT INTO Habilidade VALUES (seq_habilidade.NEXTVAL, 'Inglês Fluente');
INSERT INTO Habilidade VALUES (seq_habilidade.NEXTVAL, 'Atendimento ao Cliente');

-- Projetos
INSERT INTO Projeto VALUES (seq_projeto.NEXTVAL, '22222222222', 'Logo para Startup', 'Criar logotipo moderno', TO_DATE('2024-03-15','YYYY-MM-DD'), TO_DATE('2024-03-30','YYYY-MM-DD'), 800.00, 'Aberto');
INSERT INTO Projeto VALUES (seq_projeto.NEXTVAL, '22222222222', 'Site Institucional', 'Desenvolver site para clínica', TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-04-30','YYYY-MM-DD'), 2000.00, 'Aberto');
INSERT INTO Projeto VALUES (seq_projeto.NEXTVAL, '66666666666', 'Campanha de SEO', 'Melhorar rankeamento no Google', TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-06-01','YYYY-MM-DD'), 1200.00, 'Aberto');
INSERT INTO Projeto VALUES (seq_projeto.NEXTVAL, '66666666666', 'Tradução de Documentos', 'Traduzir 50 páginas para inglês', TO_DATE('2024-05-10','YYYY-MM-DD'), TO_DATE('2024-05-20','YYYY-MM-DD'), 600.00, 'Aberto');

-- Propostas
INSERT INTO Proposta VALUES (1, 1, '11111111111', 750.00, TO_DATE('2024-03-20','YYYY-MM-DD'), 'Aguardando');
INSERT INTO Proposta VALUES (2, 2, '33333333333', 1900.00, TO_DATE('2024-04-05','YYYY-MM-DD'), 'Aguardando');
INSERT INTO Proposta VALUES (3, 3, '44444444444', 1100.00, TO_DATE('2024-05-05','YYYY-MM-DD'), 'Aceita');
INSERT INTO Proposta VALUES (4, 4, '55555555555', 590.00, TO_DATE('2024-05-11','YYYY-MM-DD'), 'Aceita');

-- Contratos
INSERT INTO Contrato VALUES (seq_contrato.NEXTVAL, 1, TO_DATE('2024-03-22','YYYY-MM-DD'), NULL, 'Em andamento');
INSERT INTO Contrato VALUES (seq_contrato.NEXTVAL, 2, TO_DATE('2024-04-10','YYYY-MM-DD'), NULL, 'Em andamento');
INSERT INTO Contrato VALUES (seq_contrato.NEXTVAL, 3, TO_DATE('2024-05-06','YYYY-MM-DD'), TO_DATE('2024-06-02','YYYY-MM-DD'), 'Concluído');
INSERT INTO Contrato VALUES (seq_contrato.NEXTVAL, 4, TO_DATE('2024-05-12','YYYY-MM-DD'), TO_DATE('2024-05-21','YYYY-MM-DD'), 'Concluído');

-- Pagamentos
INSERT INTO Pagamento VALUES (1, seq_pagamento.NEXTVAL, 750.00, TO_DATE('2024-03-25','YYYY-MM-DD'), 'Pix');
INSERT INTO Pagamento VALUES (2, seq_pagamento.NEXTVAL, 1900.00, TO_DATE('2024-04-15','YYYY-MM-DD'), 'Cartão');
INSERT INTO Pagamento VALUES (3, seq_pagamento.NEXTVAL, 1100.00, TO_DATE('2024-06-02','YYYY-MM-DD'), 'Boleto');
INSERT INTO Pagamento VALUES (4, seq_pagamento.NEXTVAL, 590.00, TO_DATE('2024-05-21','YYYY-MM-DD'), 'Pix');

-- Avaliações
INSERT INTO Avaliacao VALUES (1, '22222222222', '11111111111', 9, 'Ótimo trabalho', TO_DATE('2024-03-28','YYYY-MM-DD'));
INSERT INTO Avaliacao VALUES (1, '11111111111', '22222222222', 10, 'Cliente excelente', TO_DATE('2024-03-28','YYYY-MM-DD'));
INSERT INTO Avaliacao VALUES (3, '66666666666', '44444444444', 8, 'Trabalho bom, mas atrasou um pouco.', TO_DATE('2024-06-03','YYYY-MM-DD'));
INSERT INTO Avaliacao VALUES (3, '44444444444', '66666666666', 9, 'Cliente claro e objetivo.', TO_DATE('2024-06-03','YYYY-MM-DD'));

-- Indicações
INSERT INTO Indicacao VALUES ('11111111111', '33333333333', TO_DATE('2024-05-01','YYYY-MM-DD'), 'Bom profissional');
INSERT INTO Indicacao VALUES ('44444444444', '55555555555', TO_DATE('2024-06-05','YYYY-MM-DD'), 'Trabalhamos juntos em outro projeto.');

-- Edições de Projeto
INSERT INTO Edicao_Projeto VALUES (1, 1, 'Descricao', 'Criar logotipo moderno', 'Criar logotipo minimalista');
INSERT INTO Edicao_Projeto VALUES (3, 1, 'ValorEstimado', '1000.00', '1200.00');
INSERT INTO Edicao_Projeto VALUES (4, 1, 'PrazoDesejado', '2024-05-15', '2024-05-20');

-- Freelancer-Categoria
INSERT INTO Freelancer_Categoria VALUES ('11111111111', 1);
INSERT INTO Freelancer_Categoria VALUES ('33333333333', 2);
INSERT INTO Freelancer_Categoria VALUES ('44444444444', 3);
INSERT INTO Freelancer_Categoria VALUES ('55555555555', 4);

-- Freelancer-Habilidade
INSERT INTO Freelancer_Habilidade VALUES ('11111111111', 1);
INSERT INTO Freelancer_Habilidade VALUES ('33333333333', 2);
INSERT INTO Freelancer_Habilidade VALUES ('33333333333', 3);
INSERT INTO Freelancer_Habilidade VALUES ('44444444444', 4);
INSERT INTO Freelancer_Habilidade VALUES ('44444444444', 5);
INSERT INTO Freelancer_Habilidade VALUES ('55555555555', 6);
