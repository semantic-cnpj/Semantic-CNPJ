-- tablespaces abaixo permanecem inalteradas, somente apos o povoamento das tabelas normalizadas poderemos indicar alteracao de tamanho

--Das tabelas normalizadas
--Empresa
CREATE TABLESPACE ts_norm_empresa
LOGGING DATAFILE 'ts_norm_empresa.dbf'
SIZE 65000m AUTOEXTEND ON NEXT 6500m EXTENT MANAGEMENT LOCAL;

--Estabelecimento 
CREATE TABLESPACE ts_norm_estabelecimento
LOGGING DATAFILE 'ts_norm_estabelecimento.dbf'
SIZE 80000m AUTOEXTEND ON NEXT 3000m EXTENT MANAGEMENT LOCAL;

--demais tabelas normalizadas - 
CREATE TABLESPACE ts_norm_demais_tb
LOGGING DATAFILE 'ts_norm_demais_tb.dbf'
SIZE 100000m AUTOEXTEND ON NEXT 10000m EXTENT MANAGEMENT LOCAL;

--Tablespaces: ts_extracao_empresas, ts_extracao_cnae_sec, ts_extracao_socios, ts_extracao_tb_fixas, ts_norm_empresa, ts_norm_estabelecimento, ts_norm_demais_tb, ts_norm_empresa_old, ts_norm_estabelecimento_old e ts_norm_demais_tb_old