-- ==========================================
-- RESET COMPLETO DO BANCO SALES_ANALYTICS
-- Apaga tudo e recria a estrutura do zero
-- ==========================================

DROP DATABASE IF EXISTS sales_analytics;

CREATE DATABASE sales_analytics;
USE sales_analytics;

-- ==========================================
-- TABELA: CLIENTES
-- ==========================================
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo CHAR(1),
    data_nascimento DATE,
    telefone VARCHAR(20),
    email VARCHAR(120) UNIQUE,
    cidade VARCHAR(80),
    estado CHAR(2),
    data_cadastro DATE NOT NULL,
    CHECK (sexo IN ('M','F'))
);

-- ==========================================
-- TABELA: PRODUTOS
-- ==========================================
CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (preco >= 0),
    CHECK (estoque >= 0)
);

-- ==========================================
-- TABELA: FUNCIONARIOS
-- ==========================================
CREATE TABLE funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(120) UNIQUE,
    data_nascimento DATE,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    cidade VARCHAR(80),
    estado CHAR(2),
    data_admissao DATE NOT NULL,
    status ENUM(
        'Ativo',
        'Afastado',
        'Desligado'
    ) NOT NULL DEFAULT 'Ativo',
    CHECK (salario >= 0)
);

-- ==========================================
-- TABELA: PEDIDOS
-- ==========================================
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_pedido DATETIME NOT NULL,
    forma_pagamento ENUM(
        'PIX',
        'Cartão de Crédito',
        'Cartão de Débito',
        'Boleto',
        'Dinheiro'
    ) NOT NULL,
    desconto DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    frete DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    valor_total DECIMAL(10,2) NOT NULL,
    status ENUM(
        'Pendente',
        'Pago',
        'Enviado',
        'Entregue',
        'Cancelado'
    ) NOT NULL DEFAULT 'Pendente',
    data_entrega DATE,
    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (id_funcionario)
        REFERENCES funcionarios(id_funcionario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (valor_total >= 0),
    CHECK (desconto >= 0),
    CHECK (frete >= 0)
);

-- ==========================================
-- TABELA: ITENS_PEDIDO
-- ==========================================
CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (quantidade > 0),
    CHECK (preco_unitario >= 0)
);

-- ==========================================
-- ÍNDICES
-- ==========================================
CREATE INDEX idx_cliente ON pedidos(id_cliente);
CREATE INDEX idx_funcionario ON pedidos(id_funcionario);
CREATE INDEX idx_data_pedido ON pedidos(data_pedido);
CREATE INDEX idx_produto ON itens_pedido(id_produto);
CREATE INDEX idx_categoria ON produtos(categoria);
CREATE INDEX idx_marca ON produtos(marca);

-- Confirmação: todas as tabelas devem estar vazias
SELECT 'clientes' AS tabela, COUNT(*) AS total FROM clientes
UNION ALL
SELECT 'produtos', COUNT(*) FROM produtos
UNION ALL
SELECT 'funcionarios', COUNT(*) FROM funcionarios
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'itens_pedido', COUNT(*) FROM itens_pedido;
