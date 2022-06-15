--------------------------------------------------------
--  Arquivo criado - Quinta-feira-Novembro-04-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ERRO_LOG_POVOA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ERRO_LOG_POVOA" (p_tb_name varchar2, p_code_erro number, p_msg_erro varchar2, p_data date)
is
begin
    INSERT INTO log_povoa_erros (NOME_TABELA, cod_erro, msg_erro, data_carga) values (p_tb_name, p_code_erro, p_msg_erro, p_data);
    commit;
end;

/
