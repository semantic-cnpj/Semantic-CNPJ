--------------------------------------------------------
--  Arquivo criado - Quinta-feira-Novembro-04-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HIST_CARGA
--------------------------------------------------------

  CREATE TABLE "HIST_CARGA" 
   (	"DATA_CARGA" VARCHAR2(10 BYTE), 
	"VERSAO_LAYOUT" VARCHAR2(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_D_USR" ;
--------------------------------------------------------
--  DDL for Table LOG_POVOA_ERROS
--------------------------------------------------------

  CREATE TABLE "LOG_POVOA_ERROS" 
   (	"NOME_TABELA" VARCHAR2(60 BYTE), 
	"COD_ERRO" NUMBER, 
	"MSG_ERRO" VARCHAR2(300 BYTE), 
	"DATA_CARGA" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_D_USR" ;
--------------------------------------------------------
--  DDL for Trigger POVOA_NORM_T
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "POVOA_NORM_T" 
after insert on hist_carga
for each row
declare
tb_name varchar2(80);
result_povoa number := 0;
--array nomes tb norm
TYPE t_name_type IS VARRAY(24) 
        OF VARCHAR2(35) NOT NULL;
    t_names_tb_norm t_name_type  := t_name_type('RFB_EMPRESA','RFB_EMPRESA_HOLDING','RFB_ENDERECO','RFB_ENDERECO_EXTERIOR','RFB_ESTABELECIMENTO'
    ,'RFB_ESTABELECIMENTO_EXTERIOR','RFB_ESTRANGEIRO','RFB_NATUREZA_LEGAL','RFB_OPCAO_MEI','RFB_OPCAO_SIMPLES','RFB_PESSOA'
    ,'RFB_QUALIFICACAO','RFB_RAZAO_SITUACAO_CADASTRAL','RFB_SITUACAO_CADASTRAL','RFB_SITUACAO_ESPECIAL','RFB_SOCIEDADE_ESTRANGEIRO'
    ,'RFB_SOCIEDADE_COM_HOLDING','RFB_SOCIEDADE_COM_PESSOA_FISICA','RFB_TEM_ATIV_ECONOMICA_SECUNDARIA','RFB_TEM_ESTABELECIMENTO'
    ,'RFB_TEM_SITUACAO_ESPECIAL','RFB_TEM_SOCIEDADE_ESTRANGEIRA','RFB_TEM_SOCIEDADE_FISICA','RFB_TEM_SOCIEDADE_JURIDICA');

begin
    <<carrega_norm>>
    for i in 1..t_names_tb_norm.COUNT loop
    begin
        tb_name := t_names_tb_norm(i);
        execute immediate 'TRUNCATE TABLE '||tb_name;
        --DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE RFB_EMPRESA;');
        if i = 1 then
            result_povoa := povoa_rfb_empresa;
        elsif i = 2 then
            result_povoa := povoa_rfb_empresa_holding;
        elsif i = 3 then
            result_povoa := povoa_rfb_endereco;
        elsif i = 4 then
            result_povoa := povoa_rfb_endereco_exterior;
        elsif i = 5 then
            result_povoa := povoa_rfb_estabelecimento;
        elsif i = 6 then
            result_povoa := povoa_rfb_estabelecimento_exterior;
        elsif i = 7 then
            result_povoa := povoa_rfb_estrangeiro;
        elsif i = 8 then
            result_povoa := povoa_rfb_natureza_legal;
        elsif i = 9 then
            result_povoa := povoa_rfb_opcao_mei;
        elsif i = 10 then
            result_povoa := povoa_rfb_opcao_simples;
        elsif i = 11 then
            result_povoa := povoa_rfb_pessoa;
        elsif i = 12 then
            result_povoa := povoa_rfb_qualificacao_socio;
        elsif i = 13 then
            result_povoa := povoa_rfb_razao_situacao_cadastral;
        elsif i = 14 then
            result_povoa := povoa_rfb_situacao_cadastral;
        elsif i = 15 then
            result_povoa := povoa_rfb_situacao_especial;
        elsif i = 16 then
            result_povoa := povoa_rfb_sociedade_com_estrangeiro;
        elsif i = 17 then
            result_povoa := povoa_rfb_sociedade_com_holding;
        elsif i = 18 then
            result_povoa := povoa_rfb_sociedade_com_pessoa_fisica;
        elsif i = 19 then
            result_povoa := povoa_rfb_tem_ativ_economica_secundaria;
        elsif i = 20 then
            result_povoa := povoa_rfb_tem_estabelecimento;
        elsif i = 21 then
            result_povoa := povoa_rfb_tem_situacao_especial;
        elsif i = 22 then
            result_povoa := povoa_rfb_tem_sociedade_estrangeira;
        elsif i = 23 then
            result_povoa := povoa_rfb_tem_sociedade_fisica;
        elsif i = 24 then
            result_povoa := povoa_rfb_tem_sociedade_juridica;
        end if;
        if result_povoa = 13 then
            commit;
        end if;
    --end loop;
        exception
            when others then
                --INSERT INTO log_povoa_erros (NOME_TABELA, cod_erro, msg_erro, data_carga) values (tb_name, sqlcode, sqlerrm, TO_DATE(:new.data_carga));
                erro_log_povoa(tb_name, sqlcode, sqlerrm, TO_DATE(:new.data_carga));
            commit;
            --raise;
            continue carrega_norm;
    end;
    end loop carrega_norm;
end;

/
--ALTER TRIGGER "POVOA_NORM_T" DISABLE;
