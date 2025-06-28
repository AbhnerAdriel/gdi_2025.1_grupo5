
-- DROP TABLES (em ordem para evitar erros por dependência)
DROP TABLE Freelancer_Habilidade CASCADE CONSTRAINTS;
DROP TABLE Freelancer_Categoria CASCADE CONSTRAINTS;
DROP TABLE Edicao_Projeto CASCADE CONSTRAINTS;
DROP TABLE Indicacao CASCADE CONSTRAINTS;
DROP TABLE Avaliacao CASCADE CONSTRAINTS;
DROP TABLE Pagamento CASCADE CONSTRAINTS;
DROP TABLE Contrato CASCADE CONSTRAINTS;
DROP TABLE Proposta CASCADE CONSTRAINTS;
DROP TABLE Projeto CASCADE CONSTRAINTS;
DROP TABLE Habilidade CASCADE CONSTRAINTS;
DROP TABLE Categoria CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Freelancer CASCADE CONSTRAINTS;
DROP TABLE Contato_Usuario CASCADE CONSTRAINTS;
DROP TABLE Usuario CASCADE CONSTRAINTS;
DROP TABLE Endereco CASCADE CONSTRAINTS;

-- TABELAS PRINCIPAIS
CREATE TABLE Endereco (
    CEP_PK VARCHAR2(10) PRIMARY KEY,
    Rua VARCHAR2(100),
    Bairro VARCHAR2(50),
    Cidade VARCHAR2(50),
    Estado VARCHAR2(2)
);

CREATE TABLE Usuario (
    CPF_PK VARCHAR2(11) PRIMARY KEY,
    Nome VARCHAR2(100),
    Senha VARCHAR2(50),
    Email VARCHAR2(100) UNIQUE,
    CEP_FK VARCHAR2(10),
    Numero_Endereco VARCHAR2(10),
    Complemento_Endereco VARCHAR2(50),
    CONSTRAINT fk_usuario_endereco FOREIGN KEY (CEP_FK) REFERENCES Endereco(CEP_PK)
);

CREATE TABLE Contato_Usuario (
    CPF_Usuario_FK VARCHAR2(11),
    Contato VARCHAR2(20),
    PRIMARY KEY (CPF_Usuario_FK, Contato),
    FOREIGN KEY (CPF_Usuario_FK) REFERENCES Usuario(CPF_PK)
);

CREATE TABLE Freelancer (
    CPF_Usuario_FK_PK VARCHAR2(11) PRIMARY KEY,
    DataEntrada DATE,
    Curriculo CLOB,
    FOREIGN KEY (CPF_Usuario_FK_PK) REFERENCES Usuario(CPF_PK)
);

CREATE TABLE Cliente (
    CPF_Usuario_FK_PK VARCHAR2(11) PRIMARY KEY,
    DataRegistro DATE,
    FOREIGN KEY (CPF_Usuario_FK_PK) REFERENCES Usuario(CPF_PK)
);

CREATE TABLE Categoria (
    IDCategoria_PK NUMBER PRIMARY KEY,
    Nome VARCHAR2(50)
);

CREATE TABLE Habilidade (
    IDHabilidade_PK NUMBER PRIMARY KEY,
    Nome VARCHAR2(50)
);

CREATE TABLE Projeto (
    IDProjeto_PK NUMBER PRIMARY KEY,
    CPF_Cliente_FK VARCHAR2(11),
    Titulo VARCHAR2(100),
    Descricao CLOB,
    DataPublicacao DATE,
    PrazoDesejado DATE,
    ValorEstimado NUMBER,
    Status VARCHAR2(20),
    FOREIGN KEY (CPF_Cliente_FK) REFERENCES Cliente(CPF_Usuario_FK_PK)
);

-- RELACIONAMENTOS
CREATE TABLE Proposta (
    IDProposta_PK NUMBER PRIMARY KEY,
    IDProjeto_FK NUMBER,
    CPF_Freelancer_FK VARCHAR2(11),
    ValorProposto NUMBER,
    PrazoProposto DATE,
    Status VARCHAR2(20),
    FOREIGN KEY (IDProjeto_FK) REFERENCES Projeto(IDProjeto_PK),
    FOREIGN KEY (CPF_Freelancer_FK) REFERENCES Freelancer(CPF_Usuario_FK_PK)
);

CREATE TABLE Contrato (
    IDContrato_PK NUMBER PRIMARY KEY,
    IDProposta_FK NUMBER UNIQUE,
    DataInicio DATE,
    DataTermino DATE,
    Status VARCHAR2(20),
    FOREIGN KEY (IDProposta_FK) REFERENCES Proposta(IDProposta_PK)
);

CREATE TABLE Pagamento (
    IDContrato_FK NUMBER,
    IDPagamento NUMBER,
    Valor NUMBER,
    DataPagamento DATE,
    Metodo VARCHAR2(30),
    PRIMARY KEY (IDContrato_FK, IDPagamento),
    UNIQUE(IDContrato_FK),
    FOREIGN KEY (IDContrato_FK) REFERENCES Contrato(IDContrato_PK)
);

CREATE TABLE Avaliacao (
    IDContrato_FK NUMBER,
    CPF_Avaliador_FK VARCHAR2(11),
    CPF_Avaliado_FK VARCHAR2(11),
    Nota NUMBER CHECK (Nota BETWEEN 0 AND 10),
    Comentario CLOB,
    DataAvaliacao DATE,
    PRIMARY KEY (IDContrato_FK, CPF_Avaliador_FK, CPF_Avaliado_FK),
    FOREIGN KEY (IDContrato_FK) REFERENCES Contrato(IDContrato_PK),
    FOREIGN KEY (CPF_Avaliador_FK) REFERENCES Usuario(CPF_PK),
    FOREIGN KEY (CPF_Avaliado_FK) REFERENCES Usuario(CPF_PK)
);

CREATE TABLE Indicacao (
    CPF_Indicador_FK VARCHAR2(11),
    CPF_Indicado_FK VARCHAR2(11),
    DataIndicacao DATE,
    Motivo VARCHAR2(100),
    PRIMARY KEY (CPF_Indicador_FK, CPF_Indicado_FK),
    FOREIGN KEY (CPF_Indicador_FK) REFERENCES Freelancer(CPF_Usuario_FK_PK),
    FOREIGN KEY (CPF_Indicado_FK) REFERENCES Freelancer(CPF_Usuario_FK_PK)
);

CREATE TABLE Edicao_Projeto (
    IDProjeto_FK NUMBER,
    IDEdicao NUMBER,
    CampoAlterado VARCHAR2(50),
    ValorAnterior VARCHAR2(200),
    NovoValor VARCHAR2(200),
    PRIMARY KEY (IDProjeto_FK, IDEdicao),
    FOREIGN KEY (IDProjeto_FK) REFERENCES Projeto(IDProjeto_PK)
);

CREATE TABLE Freelancer_Categoria (
    CPF_Freelancer_FK VARCHAR2(11),
    IDCategoria_FK NUMBER,
    PRIMARY KEY (CPF_Freelancer_FK, IDCategoria_FK),
    FOREIGN KEY (CPF_Freelancer_FK) REFERENCES Freelancer(CPF_Usuario_FK_PK),
    FOREIGN KEY (IDCategoria_FK) REFERENCES Categoria(IDCategoria_PK)
);

CREATE TABLE Freelancer_Habilidade (
    CPF_Freelancer_FK VARCHAR2(11),
    IDHabilidade_FK NUMBER,
    PRIMARY KEY (CPF_Freelancer_FK, IDHabilidade_FK),
    FOREIGN KEY (CPF_Freelancer_FK) REFERENCES Freelancer(CPF_Usuario_FK_PK),
    FOREIGN KEY (IDHabilidade_FK) REFERENCES Habilidade(IDHabilidade_PK)
);
