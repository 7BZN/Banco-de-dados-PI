create database ipa_sementes;

use ipa_sementes;

create table fornecedor( 
	id_fornecedor int auto_increment primary key,
    nome varchar(120) not null,
    endereco varchar(200),
    email varchar(120),
    telefone varchar(20),
    cnpj VARCHAR(20) NOT NULL,
    created_at timestamp default current_timestamp
);

create table armazem (
	id_armazem int auto_increment primary key,
    nome varchar(120),
    localizacao varchar(200),
    capacidade int,
    responsavel varchar(120),
    created_at timestamp default current_timestamp,
    is_active boolean default true
);

create table lote (
	id_lote int auto_increment primary key,
    id_fornecedor int,
    numero_lote varchar(50) unique,
    tipo_semente varchar(100),
    variedade varchar(100),
    data_compra date,
    validade date,
    quantidade_total int default 0,
    created_at timestamp default current_timestamp,
    foreign key (id_fornecedor) references fornecedor (id_fornecedor)
);

create table estoque (
	id_estoque int auto_increment primary key,
    id_lote int,
    id_armazem int,
    quantidade int,
    created_at timestamp default current_timestamp,
    updated_at timestamp null,
    foreign key (id_lote) references lote(Id_lote),
    foreign key (id_armazem) references armazem(id_armazem)
);

create table movimentacao (
	id_movimentacao int auto_increment primary key,
    id_estoque int,
    tipo enum('entrada', 'saida') not null,
    quantidade int not null, 
    data_movimentacao datetime default current_timestamp,
    motivo varchar(200),
    created_at timestamp default current_timestamp,
    foreign key (id_estoque) references estoque(id_estoque)
);

create table agricultor (
	id_agricultor int auto_increment primary key,
    cpf varchar(20) unique not null, 
    nome varchar(120),
    municipio varchar(100),
    endereco varchar(200),
    telefone varchar(20),
    created_at timestamp default current_timestamp,
    is_active boolean default true
);

CREATE TABLE entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_agricultor INT NOT NULL,
    id_lote INT NOT NULL,
    quantidade INT NOT NULL,
    data_entrega DATE DEFAULT (CURDATE()),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_agricultor) REFERENCES agricultor(id_agricultor)
        ON DELETE CASCADE,
    FOREIGN KEY (id_lote) REFERENCES lote(id_lote)
        ON DELETE CASCADE
);


create table funcionario (
	id_funcionario int auto_increment primary key,
    cpf varchar(20) unique,
    nome varchar(150),
    email varchar(150) unique,
    senha varchar(255),
    telefone varchar(20),
    cargo varchar(100),
    created_at timestamp default current_timestamp,
    is_active boolean default true
    );
    
create table relatorio (
	id_relatorio int auto_increment primary key,
    id_funcionario int,
    tipo varchar(120),
    parametros text,
    data_inicio date,
    data_fim date,
    arquivos varchar(200),
    created_at timestamp default current_timestamp,
    foreign key (id_funcionario) references funcionario(id_funcionario)
);

create table alerta (
	id_alerta int auto_increment primary key,
    id_estoque int, 
    tipo enum('estoque_baixo', 'vencimento', 'erro_sistema'),
    nivel enum('baixo', 'medio', 'alto'),
    mensagem varchar(200),
    data_alerta datetime default current_timestamp,
    is_resolvido boolean default false,
    created_at timestamp default current_timestamp,
    foreign key (id_estoque) references estoque(id_estoque)
);

create table log_acesso (
	id_log int auto_increment primary key,
    idp_usuario int,
    acao varchar(200),
    data_acesso datetime default current_timestamp,
    ip varchar(50),
    created_at timestamp default current_timestamp
);