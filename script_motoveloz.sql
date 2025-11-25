-- ==========================================================
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- Necessário para que os comandos da atividade funcionem
-- ==========================================================

CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100),
    cpf VARCHAR(14),
    telefone VARCHAR(20),
    endereco VARCHAR(200)
);

CREATE TABLE MECANICO (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(50),
    data_admissao DATE
);

CREATE TABLE PECA (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome_peca VARCHAR(100),
    codigo_sku VARCHAR(20),
    valor_unitario DECIMAL(10,2),
    qtd_estoque INT
);

CREATE TABLE SERVICO (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao_servico VARCHAR(100),
    valor_mao_obra DECIMAL(10,2)
);

CREATE TABLE MOTOCICLETA (
    id_moto INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10),
    modelo VARCHAR(50),
    marca VARCHAR(50),
    ano_fabricacao INT,
    cor VARCHAR(20),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE ORDEM_SERVICO (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    data_abertura DATE,
    data_conclusao DATE,
    status VARCHAR(20),
    valor_total DECIMAL(10,2),
    id_moto INT,
    id_mecanico INT,
    FOREIGN KEY (id_moto) REFERENCES MOTOCICLETA(id_moto),
    FOREIGN KEY (id_mecanico) REFERENCES MECANICO(id_mecanico)
);

CREATE TABLE ITEM_OS_PECA (
    id_item_peca INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT,
    id_peca INT,
    quantidade_utilizada INT,
    valor_cobrado_momento DECIMAL(10,2),
    FOREIGN KEY (id_os) REFERENCES ORDEM_SERVICO(id_os),
    FOREIGN KEY (id_peca) REFERENCES PECA(id_peca)
);

CREATE TABLE ITEM_OS_SERVICO (
    id_item_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT,
    id_servico INT,
    observacao_tecnica VARCHAR(200),
    FOREIGN KEY (id_os) REFERENCES ORDEM_SERVICO(id_os),
    FOREIGN KEY (id_servico) REFERENCES SERVICO(id_servico)
);

-- ==========================================================
-- 2. INSERÇÃO DE DADOS (INSERT) - Item obrigatório 1
-- Povoando as tabelas principais
-- ==========================================================

-- Inserindo Clientes
INSERT INTO CLIENTE (nome_completo, cpf, telefone, endereco) VALUES 
('João Silva', '123.456.789-00', '(11) 99999-1111', 'Rua A, 123'),
('Maria Oliveira', '987.654.321-11', '(11) 98888-2222', 'Av. Brasil, 500'),
('Carlos Souza', '456.789.123-22', '(21) 97777-3333', 'Rua das Flores, 10');

-- Inserindo Mecânicos
INSERT INTO MECANICO (nome, especialidade, data_admissao) VALUES 
('Roberto Lima', 'Motor', '2023-01-15'),
('Fernanda Costa', 'Elétrica', '2023-03-20');

-- Inserindo Peças
INSERT INTO PECA (nome_peca, codigo_sku, valor_unitario, qtd_estoque) VALUES 
('Óleo 10W30', 'OLE-001', 35.00, 50),
('Filtro de Ar', 'FIL-002', 25.00, 30),
('Vela de Ignição', 'VEL-003', 15.00, 100),
('Pneu Traseiro', 'PNE-004', 250.00, 10);

-- Inserindo Serviços
INSERT INTO SERVICO (descricao_servico, valor_mao_obra) VALUES 
('Troca de Óleo', 20.00),
('Revisão Geral', 150.00),
('Troca de Pneu', 40.00);

-- Inserindo Motocicletas
INSERT INTO MOTOCICLETA (placa, modelo, marca, ano_fabricacao, cor, id_cliente) VALUES 
('ABC-1234', 'CG 160', 'Honda', 2022, 'Vermelha', 1),
('XYZ-9876', 'Fazer 250', 'Yamaha', 2021, 'Preta', 2);

-- Inserindo Ordens de Serviço (OS)
INSERT INTO ORDEM_SERVICO (data_abertura, status, valor_total, id_moto, id_mecanico) VALUES 
('2024-05-01', 'Concluído', 55.00, 1, 1),
('2024-05-02', 'Em Andamento', 0.00, 2, 2);

-- Inserindo Itens na OS (Peças e Serviços)
-- OS 1 (Troca de óleo da CG 160): Usou 1 Óleo e mão de obra de troca
INSERT INTO ITEM_OS_PECA (id_os, id_peca, quantidade_utilizada, valor_cobrado_momento) VALUES (1, 1, 1, 35.00);
INSERT INTO ITEM_OS_SERVICO (id_os, id_servico, observacao_tecnica) VALUES (1, 1, 'Cliente trouxe o filtro, trocado apenas óleo');


-- ==========================================================
-- 3. CONSULTAS (SELECT) - Item obrigatório 2
-- ==========================================================

-- Consulta 1: Listar todas as motos e seus donos
SELECT m.modelo, m.placa, c.nome_completo 
FROM MOTOCICLETA m
JOIN CLIENTE c ON m.id_cliente = c.id_cliente;

-- Consulta 2: Listar peças com estoque baixo (menor que 20 unidades)
SELECT nome_peca, qtd_estoque 
FROM PECA 
WHERE qtd_estoque < 20 
ORDER BY qtd_estoque ASC;

-- Consulta 3: Ver o histórico de serviços da oficina (Join triplo)
SELECT os.id_os, os.data_abertura, os.status, m.modelo, mec.nome AS nome_mecanico
FROM ORDEM_SERVICO os
JOIN MOTOCICLETA m ON os.id_moto = m.id_moto
JOIN MECANICO mec ON os.id_mecanico = mec.id_mecanico
WHERE os.status = 'Concluído';


-- ==========================================================
-- 4. ATUALIZAÇÃO E EXCLUSÃO (UPDATE/DELETE) - Item obrigatório 3
-- ==========================================================

-- UPDATE 1: Atualizar o telefone de um cliente
UPDATE CLIENTE 
SET telefone = '(11) 99999-9999' 
WHERE id_cliente = 1;

-- UPDATE 2: Baixar estoque de uma peça vendida
UPDATE PECA 
SET qtd_estoque = qtd_estoque - 1 
WHERE id_peca = 1;

-- UPDATE 3: Finalizar uma Ordem de Serviço e definir valor
UPDATE ORDEM_SERVICO 
SET status = 'Concluído', valor_total = 290.00 
WHERE id_os = 2;

-- DELETE 1: Remover um item de peça lançado errado na OS
DELETE FROM ITEM_OS_PECA 
WHERE id_item_peca = 1;

-- DELETE 2: Excluir um serviço que não é mais oferecido (se não estiver em uso)
DELETE FROM SERVICO 
WHERE id_servico = 3;

-- DELETE 3: Cancelar (excluir) uma Ordem de Serviço específica
DELETE FROM ORDEM_SERVICO 
WHERE id_os = 2;