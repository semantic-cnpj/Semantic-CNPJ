CREATE TABLE EXTR_EMPRESAS 
(
  CNPJ_BASICO VARCHAR2(8 BYTE) 
, RAZAO_SOCIAL VARCHAR2(170 BYTE) 
, COD_NAT_JURIDICA VARCHAR2(4 BYTE) 
, QUALIF_RESP VARCHAR2(2 BYTE) 
, CAPITAL_SOCIAL VARCHAR2(26 BYTE) 
, PORTE VARCHAR2(2 BYTE) 
, ENTE_FEDERATIVO VARCHAR2(156 BYTE) --NOVO CAMPO OK
) 
LOGGING 
TABLESPACE ts_extracao_empresa--USERS 
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

CREATE TABLE EXTR_ESTABELECIMENTO 
(
  CNPJ_BASICO VARCHAR2(8 BYTE) 
, CNPJ_ORDEM VARCHAR2(4 BYTE) 
, CNPJ_DV VARCHAR2(2 BYTE) 
, MATRIZ_FILIAL CHAR(1 BYTE) 
, NOME_FANTASIA VARCHAR2(70 BYTE) 
, SITUACAO VARCHAR2(2 BYTE) 
, DATA_SITUACAO VARCHAR2(8 BYTE) 
, MOTIVO_SITUACAO VARCHAR2(2 BYTE) 
, NM_CIDADE_EXTERIOR VARCHAR2(55 BYTE) 
, COD_PAIS VARCHAR2(3 BYTE) 
, DATA_INICIO_ATIV VARCHAR2(8 BYTE) 
, CNAE_FISCAL VARCHAR2(7 BYTE) 
, CNAE_FISCAL_SEC VARCHAR2(1400 BYTE) 
, TIPO_LOGRADOURO VARCHAR2(21 BYTE) 
, LOGRADOURO VARCHAR2(70 BYTE) 
, NUMERO VARCHAR2(10 BYTE) 
, COMPLEMENTO VARCHAR2(156 BYTE) 
, BAIRRO VARCHAR2(60 BYTE) 
, CEP VARCHAR2(8 BYTE) 
, UF VARCHAR2(2 BYTE) 
, COD_MUNICIPIO VARCHAR2(4 BYTE) 
, DDD_1 VARCHAR2(4 BYTE) 
, TELEFONE_1 VARCHAR2(8 BYTE) 
, DDD_2 VARCHAR2(4 BYTE) 
, TELEFONE_2 VARCHAR2(8 BYTE) 
, DDD_FAX VARCHAR2(4 BYTE) 
, NUM_FAX VARCHAR2(8 BYTE) 
, EMAIL VARCHAR2(115 BYTE) 
, SIT_ESPECIAL VARCHAR2(28 BYTE) 
, DATA_SIT_ESPECIAL VARCHAR2(8 BYTE) 
) 
LOGGING 
TABLESPACE ts_extracao_estabelecimento--USERS 
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

COMMENT ON COLUMN EXTR_ESTABELECIMENTO.CNAE_FISCAL_SEC IS 'VALOR MULTIPLO DE 7, MULTIPLICADO POR 20';

CREATE TABLE EXTR_SOCIO 
(
  CNPJ_BASICO VARCHAR2(8 BYTE) 
, TIPO_SOCIO CHAR(1 BYTE) 
, NOME_SOCIO VARCHAR2(150 BYTE) 
, CNPJ_CPF_SOCIO VARCHAR2(14 BYTE) 
, COD_QUALIFICACAO VARCHAR2(2 BYTE) 
, DATA_ENTRADA VARCHAR2(8 BYTE) 
, COD_PAIS_EXT VARCHAR2(3 BYTE) 
, CPF_REPRES VARCHAR2(11 BYTE) 
, NOME_REPRES VARCHAR2(60 BYTE) 
, COD_QUALIF_REPRES VARCHAR2(2 BYTE) 
, FAIXA_ETARIA VARCHAR2(1 BYTE) --novo campo OK
) 
LOGGING 
TABLESPACE ts_extracao_socio--USERS 
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

CREATE TABLE EXTR_SIMEI 
(
  CNPJ_BASICO VARCHAR2(8 BYTE) 
, OPC_SIMPLES CHAR(1 BYTE) 
, DATA_OPC_SIMPLES VARCHAR2(8 BYTE) 
, DATA_EXC_SIMPLES VARCHAR2(8 BYTE) 
, OPC_MEI CHAR(1 BYTE) 
, DATA_OPC_MEI VARCHAR2(8 BYTE) --NOVA COLUNA OK
, DATA_EXC_MEI VARCHAR2(8 BYTE) --NOVA COLUNA OK
) 
LOGGING 
TABLESPACE ts_extracao_simei--USERS 
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

--tabelas de dominio
CREATE TABLE DOM_PAIS 
(
  COD_PAIS VARCHAR2(3 BYTE) 
, NOME_PAIS VARCHAR2(70 BYTE) 
) 
LOGGING 
TABLESPACE ts_extracao_tb_dominios--USERS --ts_extracao_tb_fixas
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

CREATE TABLE DOM_MUNICIPIO 
(
  COD_MUNICIPIO VARCHAR2(4 BYTE) 
, MUNICIPIO VARCHAR2(50 BYTE) 
) 
LOGGING 
TABLESPACE ts_extracao_tb_dominios--USERS --ts_extracao_tb_fixas
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

CREATE TABLE DOM_QUALIFICACAO_SOCIO 
(
  COD NUMBER(38, 0) 
, DESCRICAO VARCHAR2(128 BYTE) 
) 
LOGGING 
TABLESPACE ts_extracao_tb_dominios--USERS --ts_extracao_tb_fixas
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

CREATE TABLE DOM_NATUREZA_JURIDICA 
(
  CODIGO VARCHAR2(4 BYTE) 
, NATUREZA_JURIDICA VARCHAR2(128 BYTE) 
) 
LOGGING 
TABLESPACE ts_extracao_tb_dominios--USERS --ts_extracao_tb_fixas
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

CREATE TABLE DOM_CNAES 
(
  CNAE VARCHAR2(7 BYTE) 
, DESCRICAO VARCHAR2(170 BYTE) 
) 
LOGGING 
TABLESPACE ts_extracao_tb_dominios--USERS --ts_extracao_tb_fixas
PCTFREE 10 
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

--tabelas fixas nao sofreram alteracoes
CREATE TABLE MOTIVOS_SITUACAO 
(
  CODIGO NUMBER(38, 0) 
, DESCRICAO VARCHAR2(128 BYTE) 
) 
LOGGING 
TABLESPACE ts_extracao_tb_dominios--ts_extracao_tb_fixas  
INITRANS 1 
STORAGE 
( 
  INITIAL 65536 
  NEXT 1048576 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;