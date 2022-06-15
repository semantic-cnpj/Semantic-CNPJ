--------------------------------------------------------
--  Arquivo criado - Quinta-feira-Fevereiro-24-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function POVOA_RFB_EMPRESA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_EMPRESA" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
/*
INSERT INTO RFB_EMPRESA
SELECT  CONCAT(CONCAT(root_cnpj,'-'),razao_uri)
       ,root_cnpj
       ,razao_social 
       ,CONCAT(CONCAT(opc_simples,'-'),root_cnpj) 
       ,CONCAT(CONCAT(opc_mei,'-'),root_cnpj)
       ,capital_social
       ,tem_porte 
       ,ente_federativo 
       ,id_qualif 
       ,id_nat 
       ,uri_est_mat 
FROM 
(
SELECT  e.CNPJ_BASICO                                                    AS root_cnpj 
	       ,REPLACE(regexp_replace(nome_fantasia,'[^a-zA-Z ]',''),' ','_')   AS nome_uri 
	       ,REPLACE(regexp_replace(e.RAZAO_SOCIAL ,'[^a-zA-Z ]',''),' ','_') AS razao_uri 
	       ,e.RAZAO_SOCIAL                                                   AS razao_social 
	       ,CASE WHEN s.OPC_SIMPLES = '' THEN 'OUTROS' 
	             WHEN s.OPC_SIMPLES = 'S' THEN 'SIM' 
	             WHEN s.OPC_SIMPLES = 'N' THEN 'N√O'  ELSE 'OUTROS' END AS opc_simples 
	       ,CASE WHEN s.OPC_MEI = '' THEN 'OUTROS' 
	             WHEN s.OPC_MEI = 'S' THEN 'SIM' 
	             WHEN s.OPC_MEI = 'N' THEN 'N√O'  ELSE 'OUTROS' END     AS opc_mei 
	       ,q.id_uri                                                         AS id_qualif 
	       ,n.id_uri                                                         AS id_nat 
	       ,e.CAPITAL_SOCIAL                                                 AS capital_social 
	       ,CASE WHEN e.PORTE = '1' OR e.PORTE = '01' THEN 'N√O INFORMADO' 
	             WHEN e.PORTE = '2' OR e.PORTE = '02' THEN 'MICRO EMPRESA' 
	             WHEN e.PORTE = '3' OR e.PORTE = '03' THEN 'EMPRESA DE PEQUENO PORTE' 
	             WHEN e.PORTE = '5' OR e.PORTE = '05' THEN 'DEMAIS' END      AS tem_porte 
	       ,e.ENTE_FEDERATIVO                                                AS ente_federativo
        ,CONCAT(est.CNPJ_BASICO,CONCAT(est.CNPJ_ORDEM,CONCAT(est.CNPJ_DV,CONCAT('-',est.UF)))) as uri_est_mat
	FROM EXTR_EMPRESAS e 
	INNER JOIN 
	(
		SELECT  cod
		       ,descricao  
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
		FROM DOM_QUALIFICACAO_SOCIO 
	) q
	ON e.qualif_resp = q.COD
	INNER JOIN 
	(
		SELECT  codigo 
		       ,natureza_juridica 
		       ,translate ( replace(UPPER(natureza_juridica),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri 
		       ,replace(codigo,'-','') AS id
		FROM DOM_NATUREZA_JURIDICA 
	) n
	ON e.cod_nat_juridica = n.id 
	INNER JOIN 
	(
		SELECT  CNPJ_BASICO 
		       ,CNPJ_ORDEM 
		       ,CNPJ_DV 
		       ,MATRIZ_FILIAL 
		       ,NOME_FANTASIA
               , UF
		FROM EXTR_ESTABELECIMENTO 
	) est
	ON e.CNPJ_BASICO = est.CNPJ_BASICO
	INNER JOIN 
	(
		SELECT  CNPJ_BASICO 
		       ,OPC_SIMPLES 
		       ,OPC_MEI
		FROM EXTR_SIMEI
	) s
	ON e.CNPJ_BASICO = s.CNPJ_BASICO
	WHERE est.MATRIZ_FILIAL = '1'  
) aux;
*/
INSERT INTO RFB_EMPRESA
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Empresa/'||root_cnpj --CONCAT(CONCAT(root_cnpj,'-'),razao_uri)
       ,root_cnpj 
       ,razao_social 
       ,concat('http://www.sefaz.ma.gov.br/resource/RFB/Simples/',CONCAT(CONCAT(opc_simples,'-'),root_cnpj)) 
       ,concat('http://www.sefaz.ma.gov.br/resource/RFB/Mei/',CONCAT(CONCAT(opc_mei,'-'),root_cnpj)) 
       ,to_number(capital_social)
       ,tem_porte 
       ,ente_federativo 
       ,CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/',id_qualif) 
       ,CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Natureza_Legal/',id_nat) 
       ,CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/',uri_est_mat) as uri_est_mat
       ,CONCAT(CONCAT(opc_simples,'-'),root_cnpj) as id_opcao_simples
       ,CONCAT(CONCAT(opc_mei,'-'),root_cnpj) as id_opcao_mei
       ,id_qualif
       ,id_nat
       ,uri_est_mat
FROM 
(
	SELECT  e.CNPJ_BASICO                                                    AS root_cnpj 
	       ,REPLACE(regexp_replace(nome_fantasia,'[^a-zA-Z ]',''),' ','_')   AS nome_uri 
	       ,REPLACE(regexp_replace(e.RAZAO_SOCIAL ,'[^a-zA-Z ]',''),' ','_') AS razao_uri 
	       ,e.RAZAO_SOCIAL                                                   AS razao_social
	       ,CASE WHEN s.OPC_SIMPLES = '' THEN 'OUTROS' 
	             WHEN s.OPC_SIMPLES = 'S' THEN 'SIM' 
	             WHEN s.OPC_SIMPLES = 'N' THEN 'N√O'  ELSE 'OUTROS' END      AS opc_simples 
	       ,CASE WHEN s.OPC_MEI = '' THEN 'OUTROS' 
	             WHEN s.OPC_MEI = 'S' THEN 'SIM' 
	             WHEN s.OPC_MEI = 'N' THEN 'N√O'  ELSE 'OUTROS' END          AS opc_mei 
	       ,q.id_uri                                                         AS id_qualif 
	       ,n.id_uri                                                         AS id_nat 
	       ,CASE WHEN e.CAPITAL_SOCIAL IS NULL THEN 0 END                    AS capital_social 
	       ,CASE WHEN e.PORTE = '1' OR e.PORTE = '01' THEN 'NAO_INFORMADO' 
	             WHEN e.PORTE = '2' OR e.PORTE = '02' THEN 'MICRO_EMPRESA' 
	             WHEN e.PORTE = '3' OR e.PORTE = '03' THEN 'EMPRESA_DE_PEQUENO_PORTE' 
	             WHEN e.PORTE = '5' OR e.PORTE = '05' THEN 'DEMAIS' END      AS tem_porte 
	       ,e.ENTE_FEDERATIVO                                                AS ente_federativo 
	       ,CONCAT(est.CNPJ_BASICO,CONCAT(est.CNPJ_ORDEM,CONCAT(est.CNPJ_DV,CONCAT('-',est.UF)))) AS uri_est_mat
            -- CONCAT(est.CNPJ_BASICO,CONCAT(est.CNPJ_ORDEM,CONCAT(est.CNPJ_DV,CONCAT('-',REPLACE(regexp_replace(est.NOME_FANTASIA,'[^a-zA-Z ]',''),' ','_'))))) AS uri_est_mat
	FROM EXTR_EMPRESAS e
	LEFT OUTER JOIN 
	(
		SELECT  cod 
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
		FROM DOM_QUALIFICACAO_SOCIO 
	) q
	ON e.qualif_resp = q.COD
	INNER JOIN 
	(
		SELECT  codigo 
		       ,natureza_juridica 
		       ,translate ( replace(UPPER(natureza_juridica),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri 
		       ,replace(codigo,'-','') AS id
		FROM DOM_NATUREZA_JURIDICA 
	) n
	ON e.cod_nat_juridica = n.id
	INNER JOIN 
	(
		SELECT  CNPJ_BASICO 
		       ,CNPJ_ORDEM 
		       ,CNPJ_DV 
		       ,MATRIZ_FILIAL 
		       ,NOME_FANTASIA
               ,UF
		FROM EXTR_ESTABELECIMENTO 
        WHERE MATRIZ_FILIAL = '1'  
	) est
	ON e.CNPJ_BASICO = est.CNPJ_BASICO
	LEFT OUTER JOIN 
	(
		SELECT  CNPJ_BASICO 
		       ,OPC_SIMPLES 
		       ,OPC_MEI
		FROM EXTR_SIMEI 
	) s
	ON e.CNPJ_BASICO = s.CNPJ_BASICO
) aux;

  return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_EMPRESA_HOLDING
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_EMPRESA_HOLDING" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_EMPRESA_HOLDING
SELECT  CONCAT(CONCAT(root_cnpj,'-'),razao_uri) -- uri 
       ,nome_socio -- razao_social 
       ,root_cnpj -- cnpj_raiz
FROM 
(
	SELECT  DISTINCT CNPJ_BASICO                                        AS root_cnpj 
	       ,REPLACE(regexp_replace(nome_socio,'[^a-zA-Z ]',''),' ','_') AS razao_uri 
	       ,NOME_SOCIO as nome_socio
	FROM EXTR_SOCIO
	WHERE TIPO_SOCIO = '1'  
) aux;
  return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_ENDERECO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_ENDERECO" 
return int	
is
    povoamento integer := 13;
begin
    --begin
    <<carga>>
    --INSERT INTO RFB_ENDERECO
    for ender in (SELECT  /*CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Endereco/',id_endereco) -- uri OK 
       ,MAX(uf) -- unidade_federativa OK 
       ,MAX(CONCAT(CONCAT(municipio,'-'),uf)) -- municipio OK 
       ,MAX(CONCAT(CONCAT(logradouro,'-'),bairro)) -- logradouro
       ,MAX(numero) -- numero OK 
       ,MAX(complemento) -- complemento OK 
       ,MAX(cep) -- cep OK 
       ,MAX(CONCAT(CONCAT(bairro,'-'),municipio)) -- bairro
       ,MAX(nome_pais) -- pais OK */
       CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Endereco/',id_endereco) as id_endereco
       ,uf
       ,municipio
       ,logradouro
       ,numero
       ,complemento
       ,cep
       ,bairro
       ,nome_pais
       ,id_endereco AS id_hash
    FROM 
    (    
    SELECT   CASE WHEN e.CEP = '' THEN NULL ELSE cep END                                                                                   AS cep 
	       ,CASE WHEN e.LOGRADOURO = '' THEN NULL  ELSE REPLACE(regexp_replace(CONCAT(CONCAT(e.TIPO_LOGRADOURO,' '),e.LOGRADOURO),'[^a-zA-Z0-9 ]',''),' ','_') END AS logradouro 
	       ,CASE WHEN e.BAIRRO = '' THEN NULL  ELSE REPLACE(regexp_replace(e.BAIRRO,'[^a-zA-Z ]',''),' ','_') END                                  AS bairro 
	       ,CASE WHEN m.MUNICIPIO = '' THEN NULL  ELSE REPLACE(regexp_replace(m.MUNICIPIO,'[^a-zA-Z ]',''),' ','_') END                            AS municipio 
	       ,CASE WHEN p.NOME_PAIS = '' OR p.NOME_PAIS IS NULL THEN 'BRASIL'  ELSE REPLACE(regexp_replace(p.NOME_PAIS,'[^a-zA-Z ]',''),' ','_') END AS nome_pais 
	       ,CASE e.UF WHEN 'AC' THEN 'ACRE' WHEN 'AL' THEN 'ALAGOAS' WHEN 'AP' THEN 'AMAPA' WHEN 'AM' THEN 'AMAZONAS' WHEN 'BA' THEN 'BAHIA' WHEN 'CE' THEN 'CEARA' WHEN 'ES' THEN 'ESPIRITO_SANTO' WHEN 'GO' THEN 'GOIAS' WHEN 'MA' THEN 'MARANHAO' WHEN 'MT' THEN 'MATO_GROSSO' WHEN 'MS' THEN 'MATO_GROSSO DO SUL' WHEN 'MG' THEN 'MINAS_GERAIS' WHEN 'PA' THEN 'PARA' WHEN 'PB' THEN 'PARAIBA' WHEN 'PR' THEN 'PARANA' WHEN 'PE' THEN 'PERNAMBUCO' WHEN 'PI' THEN 'PIAUI' WHEN 'RJ' THEN 'RIO_DE_JANEIRO' WHEN 'RN' THEN 'RIO_GRANDE_DO_NORTE' WHEN 'RS' THEN 'RIO_GRANDE_DO_SUL' WHEN 'RO' THEN 'RONDONIA' WHEN 'RR' THEN 'RORAIMA' WHEN 'SC' THEN 'SANTA_CATARINA' WHEN 'SP' THEN 'SAO_PAULO' WHEN 'SE' THEN 'SERGIPE' WHEN 'TO' THEN 'TOCANTINS' WHEN 'DF' THEN 'DISTRITO_FEDERAL' ELSE NULL END AS uf 
	       ,CASE WHEN e.NUMERO = '' THEN NULL  ELSE numero END                                                                                     AS numero 
	       ,CASE WHEN e.COMPLEMENTO = '' THEN NULL  ELSE complemento END                                                                           AS complemento 
	       ,dbms_crypto.Hash(utl_raw.cast_to_raw(e.COD_PAIS ||p.NOME_PAIS||e.TIPO_LOGRADOURO||e.LOGRADOURO||nvl(e.NUMERO,0)||e.COMPLEMENTO||e.BAIRRO||nvl(e.CEP,0)||e.UF||e.COD_MUNICIPIO||m.MUNICIPIO),2) AS id_endereco --ora_hashÔºønm_cidade_exterior || cod_pais||nome_pais||tipo_logradouro||logradouro||numero||complemento||bairro||cep||uf||cod_municipio||municipioÔºø AS id_endereco
        FROM
        (
           SELECT CEP, LOGRADOURO, BAIRRO, NUMERO, UF, COMPLEMENTO, COD_PAIS, TIPO_LOGRADOURO, COD_MUNICIPIO FROM EXTR_ESTABELECIMENTO 
           WHERE NM_CIDADE_EXTERIOR = '' or NM_CIDADE_EXTERIOR IS NULL  
        ) e
        inner join
        (
            SELECT  COD_PAIS 
		       ,NOME_PAIS
            FROM DOM_PAIS 
            where cod_pais in (105,106)--somente brasil
        ) p
        ON (case when e.COD_PAIS is null then 105 end) = to_number(p.COD_PAIS)
        inner join
        (
            SELECT  COD_MUNICIPIO 
		       ,MUNICIPIO
            FROM DOM_MUNICIPIO 
        ) m
        ON e.COD_MUNICIPIO = to_number(m.COD_MUNICIPIO)
    ) aux) loop
        begin
            insert into rfb_endereco values(ender.id_endereco,ender.uf,ender.municipio,ender.logradouro,ender.numero,ender.complemento,ender.cep,ender.bairro,ender.nome_pais, ender.id_hash);
            commit;
    --end loop;
            exception
            when DUP_VAL_ON_INDEX then
                sys.dbms_output.put_line('duplicado');
                continue carga;
        end;
    end loop;
    --commit;
    --GROUP BY  id_endereco;
    return povoamento;
end;
/*
create or replace function povoa_rfb_endereco
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
    INSERT INTO RFB_ENDERECO
    SELECT  id_endereco -- uri OK 
       ,MAX(uf) -- unidade_federativa OK 
       ,MAX(CONCAT(CONCAT(municipio,'-'),uf)) -- municipio OK 
       ,MAX(CONCAT(CONCAT(logradouro,'-'),bairro)) -- logradouro
       ,MAX(numero) -- numero OK 
       ,MAX(complemento) -- complemento OK 
       ,MAX(cep) -- cep OK 
       ,MAX(CONCAT(CONCAT(bairro,'-'),municipio)) -- bairro
       ,MAX(nome_pais) -- pais OK 
    FROM 
    (
        SELECT  DISTINCT CASE WHEN e.CEP = '' THEN NULL ELSE cep END                                                                                   AS cep 
	       ,CASE WHEN e.LOGRADOURO = '' THEN NULL  ELSE REPLACE(regexp_replace(CONCAT(CONCAT(e.TIPO_LOGRADOURO,' '),e.LOGRADOURO),'[^a-zA-Z0-9 ]',''),' ','_') END AS logradouro 
	       ,CASE WHEN e.BAIRRO = '' THEN NULL  ELSE REPLACE(regexp_replace(e.BAIRRO,'[^a-zA-Z ]',''),' ','_') END                                  AS bairro 
	       ,CASE WHEN m.MUNICIPIO = '' THEN NULL  ELSE REPLACE(regexp_replace(m.MUNICIPIO,'[^a-zA-Z ]',''),' ','_') END                            AS municipio 
	       ,CASE WHEN p.NOME_PAIS = '' OR p.NOME_PAIS IS NULL THEN 'BRASIL'  ELSE REPLACE(regexp_replace(p.NOME_PAIS,'[^a-zA-Z ]',''),' ','_') END AS nome_pais 
	       ,CASE e.UF WHEN 'AC' THEN 'ACRE' WHEN 'AL' THEN 'ALAGOAS' WHEN 'AP' THEN 'AMAPA' WHEN 'AM' THEN 'AMAZONAS' WHEN 'BA' THEN 'BAHIA' WHEN 'CE' THEN 'CEARA' WHEN 'ES' THEN 'ESPIRITO_SANTO' WHEN 'GO' THEN 'GOIAS' WHEN 'MA' THEN 'MARANHAO' WHEN 'MT' THEN 'MATO_GROSSO' WHEN 'MS' THEN 'MATO_GROSSO DO SUL' WHEN 'MG' THEN 'MINAS_GERAIS' WHEN 'PA' THEN 'PARA' WHEN 'PB' THEN 'PARAIBA' WHEN 'PR' THEN 'PARANA' WHEN 'PE' THEN 'PERNAMBUCO' WHEN 'PI' THEN 'PIAUI' WHEN 'RJ' THEN 'RIO_DE_JANEIRO' WHEN 'RN' THEN 'RIO_GRANDE_DO_NORTE' WHEN 'RS' THEN 'RIO_GRANDE_DO_SUL' WHEN 'RO' THEN 'RONDONIA' WHEN 'RR' THEN 'RORAIMA' WHEN 'SC' THEN 'SANTA_CATARINA' WHEN 'SP' THEN 'SAO_PAULO' WHEN 'SE' THEN 'SERGIPE' WHEN 'TO' THEN 'TOCANTINS' WHEN 'DF' THEN 'DISTRITO_FEDERAL' ELSE NULL END AS uf 
	       ,CASE WHEN e.NUMERO = '' THEN NULL  ELSE numero END                                                                                     AS numero 
	       ,CASE WHEN e.COMPLEMENTO = '' THEN NULL  ELSE complemento END                                                                           AS complemento 
	       ,dbms_crypto.Hash(utl_raw.cast_to_raw(e.COD_PAIS ||p.NOME_PAIS||e.TIPO_LOGRADOURO||e.LOGRADOURO||e.NUMERO||e.COMPLEMENTO||e.BAIRRO||e.CEP||e.UF||e.COD_MUNICIPIO||m.MUNICIPIO),2) AS id_endereco --ora_hashÔºønm_cidade_exterior || cod_pais||nome_pais||tipo_logradouro||logradouro||numero||complemento||bairro||cep||uf||cod_municipio||municipioÔºø AS id_endereco
        FROM
        (
           SELECT CEP, LOGRADOURO, BAIRRO, NUMERO, UF, COMPLEMENTO, COD_PAIS, TIPO_LOGRADOURO, COD_MUNICIPIO FROM EXTR_ESTABELECIMENTO 
           WHERE NM_CIDADE_EXTERIOR = '' or NM_CIDADE_EXTERIOR IS NULL  
        ) e
        --FULL OUTER JOIN 
        LEFT OUTER JOIN 
        (
            SELECT  COD_PAIS 
		       ,NOME_PAIS
            FROM DOM_PAIS 
        ) p
        ON e.COD_PAIS = p.COD_PAIS
        --FULL OUTER JOIN 
        LEFT OUTER JOIN 
        (
            SELECT  COD_MUNICIPIO 
		       ,MUNICIPIO
            FROM DOM_MUNICIPIO 
        ) m
        ON e.COD_MUNICIPIO = m.COD_MUNICIPIO
        --WHERE e.NM_CIDADE_EXTERIOR = '' or e.NM_CIDADE_EXTERIOR IS NULL  
    ) aux
    GROUP BY  id_endereco;
    return povoamento;
end;*/

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_ENDERECO_EXTERIOR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_ENDERECO_EXTERIOR" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
    INSERT INTO RFB_ENDERECO_EXTERIOR
    SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Endereco/'|| aux.id_endereco -- uri OK  
       ,MAX(aux.cep) -- cep OK 
       ,MAX(aux.nome_pais) -- pais OK 
       --,MAX(CASE WHEN aux.nm_cidade_exterior IS NULL THEN NULL ELSE CONCAT(CONCAT(aux.nm_cidade_exterior,'-'),aux.nome_pais) END) AS city_ext -- cidade_exterior OK
       ,MAX(CONCAT(CONCAT(aux.nm_cidade_exterior,'-'),aux.nome_pais)) AS city_ext -- cidade_exterior OK
       ,aux.id_endereco AS ID_ENDERECO
    FROM 
    (
        SELECT  DISTINCT CASE WHEN e.CEP = '' THEN NULL ELSE cep END                                                                                   AS cep 
	       ,CASE WHEN p.NOME_PAIS = '' OR p.NOME_PAIS IS NULL THEN 'BRASIL'  ELSE REPLACE(regexp_replace(p.NOME_PAIS,'[^a-zA-Z ]',''),' ','_') END AS nome_pais 
	       ,dbms_crypto.Hash(utl_raw.cast_to_raw(e.nm_cidade_exterior ||e.COD_PAIS ||p.NOME_PAIS||e.CEP),2)                                        AS id_endereco
           ,e.NM_CIDADE_EXTERIOR
        FROM EXTR_ESTABELECIMENTO e
        INNER JOIN 
        (
            SELECT  COD_PAIS 
		       ,NOME_PAIS
            FROM DOM_PAIS 
        ) p
        ON e.COD_PAIS = p.COD_PAIS
        WHERE e.NM_CIDADE_EXTERIOR != '' 
        or e.NM_CIDADE_EXTERIOR IS NOT NULL  
    ) aux
    GROUP BY  aux.id_endereco;
    return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_ESTABELECIMENTO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_ESTABELECIMENTO" 
return int	
is
    povoamento integer := 13;
begin
INSERT INTO RFB_ESTABELECIMENTO
SELECT -- 'http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/'||CONCAT(CONCAT(cnpj,'-'),UF) as uri -- uri OK 
       cnpj  
       ,razao_social
       ,nome_fantasia 
       ,email 
       ,matriz_filial 
       ,cnae_fiscal 
       ,data_inicio_ativ 
       ,concat('http://www.sefaz.ma.gov.br/resource/RFB/Endereco/',id_endereco) as uri_endereco 
       --,NULL -- endereco_exterior
       ,phone_1 
       ,phone_2 
       ,fax 
       ,CONCAT ('http://www.sefaz.ma.gov.br/resource/RFB/Situacao_Cadastral/',CONCAT(CONCAT(CONCAT(CONCAT(situacao,'-'),cnpj),'-'),data_situacao))
       ,'http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/'||CONCAT(CONCAT(cnpj,'-'),UF) as uri -- uri OK 
       ,cnae_fiscal 
       ,id_endereco
       ,situacao
FROM 
(
	SELECT  /*DISTINCT*/ CONCAT(est.CNPJ_BASICO,CONCAT(est.CNPJ_ORDEM,est.CNPJ_DV))                                AS cnpj 
	       ,REPLACE(regexp_replace(est.NOME_FANTASIA,'[^a-zA-Z ]',''),' ','_')                                                                       AS nome_uri 
	       ,e.RAZAO_SOCIAL                                                                                                                            AS razao_social 
	       ,est.UF as UF
         ,CASE est.NOME_FANTASIA WHEN '' THEN NULL ELSE est.NOME_FANTASIA END                                                                               AS nome_fantasia 
	       ,CASE WHEN length(data_situacao) < 8 THEN NULL WHEN data_situacao like '00000000' THEN NULL ELSE to_char(to_date(data_situacao,'YYYY-MM-DD'),'YYYY_MM_DD') END as data_situacao
	       ,CASE est.SITUACAO WHEN '01' THEN 'NULA' WHEN '1' THEN 'NULA' WHEN '02' THEN 'ATIVA' WHEN '2' THEN 'ATIVA' WHEN '03' THEN 'SUSPENSA' WHEN '3' THEN 'SUSPENSA' WHEN '04' THEN 'INAPTA' WHEN '4' THEN 'INAPTA' WHEN '08' THEN 'BAIXADA' WHEN '8' THEN 'BAIXADA' END AS situacao 
	       ,CASE est.EMAIL WHEN '' THEN NULL ELSE est.EMAIL END                                                                                               AS email 
	       ,CASE est.MATRIZ_FILIAL WHEN '1' THEN 'MATRIZ' ELSE 'FILIAL' END                                                                               AS matriz_filial 
	       ,est.CNAE_FISCAL 
	       ,dbms_crypto.Hash(utl_raw.cast_to_raw(est.COD_PAIS ||p.NOME_PAIS||est.TIPO_LOGRADOURO||est.LOGRADOURO||est.NUMERO||est.COMPLEMENTO||est.BAIRRO||est.CEP||est.UF||est.COD_MUNICIPIO||m.MUNICIPIO),2) AS id_endereco 
         ,CASE WHEN length( est.DATA_INICIO_ATIV) < 8 THEN NULL WHEN  est.DATA_INICIO_ATIV like '00000000' THEN NULL ELSE est.DATA_INICIO_ATIV END                                           AS data_inicio_ativ 
	       ,CASE WHEN est.TELEFONE_1 IS NULL THEN NULL 
	             WHEN est.TELEFONE_1='' THEN NULL  ELSE '('||est.DDD_1||') '||est.TELEFONE_1 END                                                                  AS phone_1 
	       ,CASE WHEN est.TELEFONE_2 IS NULL THEN NULL 
	             WHEN est.TELEFONE_2 ='' THEN NULL  ELSE '('||est.DDD_2||') '||est.TELEFONE_2 END                                                                 AS phone_2 
	       ,CASE WHEN est.NUM_FAX IS NULL THEN NULL 
	             WHEN est.NUM_FAX='' THEN NULL  ELSE '('||est.DDD_FAX||') '||est.NUM_FAX END                                                                      AS fax
	FROM EXTR_ESTABELECIMENTO est
	INNER JOIN 
	(
		SELECT  CNPJ_BASICO
		       ,RAZAO_SOCIAL
		FROM EXTR_EMPRESAS 
	) e
	ON e.CNPJ_BASICO = est.CNPJ_BASICO 
 inner JOIN 
  (
    SELECT COD_PAIS, NOME_PAIS
    FROM DOM_PAIS
    WHERE to_number(COD_PAIS) = 105 OR to_number(COD_PAIS) = 106
  ) p 
  ON (case when est.COD_PAIS is null then 105 end) = to_number(p.COD_PAIS)
  left JOIN 
  (
    SELECT COD_MUNICIPIO, MUNICIPIO
    FROM DOM_MUNICIPIO 
  ) m ON est.COD_MUNICIPIO = to_number(m.COD_MUNICIPIO)
)aux;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_ESTABELECIMENTO_EXTERIOR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_ESTABELECIMENTO_EXTERIOR" 
return int	
is
    povoamento integer := 13;
begin
INSERT INTO RFB_ESTABELECIMENTO_EXTERIOR
SELECT 'http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/'||CONCAT(CONCAT(cnpj,'-'),UF) as uri
       ,cnpj 
       ,razao_social 
       ,nome_fantasia 
       ,email 
       ,matriz_filial 
       ,'http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/'||cnae_fiscal as uri_atividade_economica
       ,data_inicio_ativ 
			 --,null -- uri_endereÁo_nacional ok 
       ,concat('http://www.sefaz.ma.gov.br/resource/RFB/Endereco/',id_endereco) -- uri_endereÁo_exterior ok 
       ,phone_1 
       ,phone_2  
       ,fax 
       ,CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Situacao_Cadastral/',CONCAT(CONCAT(CONCAT(CONCAT(situacao,'-'),cnpj),'-'),data_situacao)) 
       ,cnae_fiscal as id_atividade_economica
       ,CAST(id_endereco AS VARCHAR2(50)) AS ID_ENDERECO
       ,situacao as id_situacao
FROM 
(
		SELECT  /*DISTINCT*/ CONCAT(est.CNPJ_BASICO,CONCAT(est.CNPJ_ORDEM,est.CNPJ_DV))                                AS cnpj
	       ,REPLACE(regexp_replace(est.NOME_FANTASIA,'[^a-zA-Z ]',''),' ','_')                                                             AS nome_uri 
	       ,e.RAZAO_SOCIAL                                                                                                                  AS razao_social 
	       ,est.UF as UF
				 ,CASE est.NOME_FANTASIA WHEN '' THEN NULL ELSE est.NOME_FANTASIA END                                                             AS nome_fantasia 
	       ,CASE WHEN length(data_situacao) < 8 THEN NULL WHEN data_situacao like '00000000' THEN NULL ELSE to_char(to_date(data_situacao,'YYYY-MM-DD'),'YYYY_MM_DD') END as data_situacao
	       ,CASE est.SITUACAO WHEN '01' THEN 'NULA' WHEN '1' THEN 'NULA' WHEN '02' THEN 'ATIVA' WHEN '2' THEN 'ATIVA' WHEN '03' THEN 'SUSPENSA' WHEN '3' THEN 'SUSPENSA' WHEN '04' THEN 'INAPTA' WHEN '4' THEN 'INAPTA' WHEN '08' THEN 'BAIXADA' WHEN '8' THEN 'BAIXADA' END AS situacao 
	       ,CASE est.EMAIL WHEN '' THEN NULL ELSE est.EMAIL END                                                                               AS email 
	       ,CASE est.MATRIZ_FILIAL WHEN '1' THEN 'MATRIZ' ELSE 'FILIAL' END                                                                   AS matriz_filial 
	       ,est.CNAE_FISCAL
	       ,(CAST (dbms_crypto.Hash(utl_raw.cast_to_raw(REPLACE(regexp_replace(est.NM_CIDADE_EXTERIOR,'[^a-zA-Z ]',''),' ','_') ||est.COD_PAIS ||p.NOME_PAIS||est.CEP),2) AS VARCHAR2(50)))                           AS id_endereco 
	       ,CASE WHEN length(DATA_INICIO_ATIV) < 8 THEN NULL WHEN DATA_INICIO_ATIV like '00000000' THEN NULL ELSE /*to_date(est.DATA_INICIO_ATIV,'YYYY-MM-DD')*/est.DATA_INICIO_ATIV END                         AS data_inicio_ativ 
	       ,CASE WHEN est.TELEFONE_1 IS NULL THEN NULL 
	             WHEN est.TELEFONE_1='' THEN NULL  ELSE '('||est.DDD_1||') '||est.TELEFONE_1 END                                            AS phone_1 
	       ,CASE WHEN est.TELEFONE_2 IS NULL THEN NULL 
	             WHEN est.TELEFONE_2 ='' THEN NULL  ELSE '('||est.DDD_2||') '||est.TELEFONE_2 END                                           AS phone_2 
	       ,CASE WHEN est.NUM_FAX IS NULL THEN NULL 
	             WHEN est.NUM_FAX='' THEN NULL  ELSE '('||est.DDD_FAX||') '||est.NUM_FAX END                                                AS fax
	FROM EXTR_ESTABELECIMENTO est
	INNER JOIN 
	(
		SELECT  CNPJ_BASICO 
		       ,RAZAO_SOCIAL
		FROM EXTR_EMPRESAS 
	) e
	ON e.CNPJ_BASICO = est.CNPJ_BASICO
	INNER JOIN 
	(
		SELECT  COD_PAIS
		       ,REPLACE(regexp_replace(NOME_PAIS,'[^a-zA-Z ]',''),' ','_') AS NOME_PAIS
		FROM DOM_PAIS 
        WHERE TO_NUMBER(COD_PAIS) != 105 AND TO_NUMBER(COD_PAIS) != 106
	) p
	ON est.COD_PAIS = TO_NUMBER(p.COD_PAIS)
	left outer JOIN 
	(
		SELECT  COD_MUNICIPIO
		       ,MUNICIPIO
		FROM DOM_MUNICIPIO 
	) m
	ON est.COD_MUNICIPIO = TO_NUMBER(m.COD_MUNICIPIO)
	--WHERE p.COD_PAIS != 105 AND p.COD_PAIS != 106
) aux;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_ESTRANGEIRO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_ESTRANGEIRO" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
    INSERT INTO RFB_ESTRANGEIRO
    SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Agente/'||uri_nome -- uri 
       ,MAX(nome_socio) -- nome 
       ,max(nome_pais) -- uri_pais
       ,uri_nome
    FROM 
    (
        SELECT  DISTINCT CONCAT(CONCAT('_','-'),REPLACE(regexp_replace(nome_socio,'[^a-zA-Z ]',''),' ','_')) AS uri_nome 
	       ,nome_socio 
	       ,REPLACE(regexp_replace(p.NOME_PAIS,'[^a-zA-Z ]',''),' ','_')                                 AS nome_pais
        FROM EXTR_SOCIO s
        --INNER JOIN 
        LEFT OUTER JOIN
        (
            SELECT  COD_PAIS 
		       ,NOME_PAIS
            FROM DOM_PAIS 
        ) p
        ON p.COD_PAIS = s.COD_PAIS_EXT
        WHERE S.TIPO_SOCIO = '3'  
    ) aux
    GROUP BY uri_nome;
    return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_FAIXA_ETARIA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_FAIXA_ETARIA" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT ALL
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (1, 1, 'Entre 0 a 12 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (2, 2, 'Entre 13 a 20 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (3, 3, 'Entre 21 a 30 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (4, 4, 'Entre 31 a 40 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (5, 5, 'Entre 41 a 50 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (6, 6, 'Entre 51 a 60 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (7, 7, 'Entre 61 a 70 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (8, 8, 'Entre 71 a 80 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (9, 9, 'Maiores de 80 anos')
   INTO RFB_FAIXA_ETARIA (uri_faixa_etaria, codigo, descricao) VALUES (0, 0, 'N„o se aplica')
SELECT 1 FROM DUAL;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_NATUREZA_LEGAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_NATUREZA_LEGAL" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_NATUREZA_LEGAL
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Natureza_Legal/'||codigo--id_uri
       ,codigo
       ,natureza_juridica 
FROM 
(
	SELECT  DISTINCT codigo 
	       --,id_uri 
	       ,natureza_juridica
	FROM 
	(
		SELECT  CODIGO 
		       ,NATUREZA_JURIDICA 
		       --,translate ( replace(UPPER(NATUREZA_JURIDICA),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri 
		       --,replace(CODIGO,'-','') AS id
		FROM DOM_NATUREZA_JURIDICA 
	) nat_jur 
) aux; 
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_OPCAO_MEI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_OPCAO_MEI" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_OPCAO_MEI
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Mei/'||CONCAT(CONCAT(OPC_MEI ,'-'),root_cnpj) 
       ,tipo_mei 
       ,data_exc_mei 
       ,data_opc_mei 
       ,CONCAT(CONCAT(OPC_MEI ,'-'),root_cnpj) as id_opcao_mei
FROM 
(
SELECT  CNPJ_BASICO                                                                                                                     AS root_cnpj 
	,OPC_MEI                                                                                                                         AS tipo_mei 
	,CASE WHEN OPC_MEI = '' THEN 'OUTROS' 
			WHEN OPC_MEI = 'S' THEN 'SIM' 
			WHEN OPC_MEI = 'N' THEN 'NAO'  ELSE 'OUTROS' END                                                                      AS OPC_MEI 
	,CASE DATA_OPC_MEI WHEN '' THEN NULL WHEN '00000000' THEN NULL ELSE to_char(to_date(DATA_OPC_MEI,'YYYY-MM-DD'),'YYYY-MM-DD') END AS data_OPC_MEI 
	,CASE DATA_EXC_MEI WHEN '' THEN NULL WHEN '00000000' THEN NULL ELSE to_char(to_date(DATA_EXC_MEI,'YYYY-MM-DD'),'YYYY-MM-DD') END AS data_EXC_MEI
FROM EXTR_SIMEI
) aux;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_OPCAO_SIMPLES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_OPCAO_SIMPLES" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_OPCAO_SIMPLES
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Simples/'||CONCAT(CONCAT(opc_simples,'-'),root_cnpj) 
       ,simples_type 
       ,class_simples
       ,data_exc_simples 
       ,data_opc_simples
       ,CONCAT(CONCAT(opc_simples,'-'),root_cnpj) as id_opcao_simples
FROM 
(
	SELECT  CNPJ_BASICO                                                                                                                             AS root_cnpj 
	       ,OPC_SIMPLES                                                                                                                             AS simples_type 
	       ,CASE WHEN OPC_SIMPLES = '' THEN 'OUTROS' 
	             WHEN OPC_SIMPLES = 'S' THEN 'SIM' 
	             WHEN OPC_SIMPLES = 'N' THEN 'NAO'  ELSE 'OUTROS' END                                                                          AS opc_simples 
	       ,CASE DATA_OPC_SIMPLES WHEN '' THEN NULL WHEN '00000000' THEN NULL ELSE to_char(to_date(DATA_OPC_SIMPLES,'YYYY-MM-DD'),'YYYY-MM-DD') END AS data_opc_simples 
	       ,CASE DATA_EXC_SIMPLES WHEN '' THEN NULL WHEN '00000000' THEN NULL ELSE to_char(to_date(DATA_EXC_SIMPLES,'YYYY-MM-DD'),'YYYY-MM-DD') END AS data_exc_simples 
	       ,CASE WHEN OPC_SIMPLES = '' THEN 'OTHERS' 
	             WHEN OPC_SIMPLES = 'S' THEN 'YES' 
	             WHEN OPC_SIMPLES = 'N' THEN 'NO'  ELSE 'OUTROS' END                                                                           AS class_simples
	FROM EXTR_SIMEI 
) aux;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_PESSOA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_PESSOA" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
    INSERT INTO RFB_PESSOA
    SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Pessoa/'||CONCAT(CONCAT(max(uri_cpf),'-'),max(uri_nome)) -- uri ok 
       ,cnpj_cpf_socio -- cpf ok 
       ,nome_socio -- nome ok 
       ,max(faixa_etaria) -- faixa ok OBS: N√øO CONSIGO PUXAR A FAIXA ET√?RIA DO REPRESENTANTE FICAR√? COMO 0 N√øO SE APLICA
       ,CONCAT(CONCAT(max(uri_cpf),'-'),max(uri_nome)) as id_pessoa
    FROM 
    (
        --SELECT  /*DISTINCT*/ regexp_replace(CNPJ_CPF_SOCIO,'[^0-9]','_')        AS uri_cpf 
	      /* ,CNPJ_CPF_SOCIO 
	       ,REPLACE(regexp_replace(NOME_SOCIO,'[^a-zA-Z ]',''),' ','_') AS uri_nome 
	       ,NOME_SOCIO 
	       ,FAIXA_ETARIA                                                AS faixa_etaria
        FROM EXTR_SOCIO
        WHERE tipo_socio = '2' UNION 
        SELECT  DISTINCT regexp_replace(CPF_REPRES,'[^0-9]','_')             AS uri_cpf 
	       ,CPF_REPRES                                                   AS cnpj_cpf_socio 
	       ,REPLACE(regexp_replace(NOME_REPRES,'[^a-zA-Z ]',''),' ','_') AS uri_nome 
	       ,CASE NOME_REPRES WHEN '' THEN NULL ELSE NOME_REPRES END      AS nome_socio 
	       ,'0'                                                          AS faixa_etaria
        FROM EXTR_SOCIO
        WHERE cpf_repres != ''  */
        SELECT  regexp_replace(CNPJ_CPF_SOCIO,'[^0-9]','_')                 AS uri_cpf 
                ,CNPJ_CPF_SOCIO
                ,REPLACE(regexp_replace(NOME_SOCIO,'[^a-zA-Z ]',''),' ','_') AS uri_nome 
                ,NOME_SOCIO 
                ,max(FAIXA_ETARIA)                                                AS faixa_etaria
        FROM EXTR_SOCIO
        WHERE tipo_socio = '2'
        and nome_socio is not null
        group by cnpj_cpf_socio, nome_socio UNION 
        SELECT regexp_replace(CPF_REPRES,'[^0-9]','_')                   AS uri_cpf 
	       ,CPF_REPRES                                                   AS cnpj_cpf_socio 
	       ,REPLACE(regexp_replace(NOME_REPRES,'[^a-zA-Z ]',''),' ','_') AS uri_nome 
	       ,CASE NOME_REPRES WHEN '' THEN NULL ELSE NOME_REPRES END      AS nome_socio 
	       ,case when nome_repres like max(nome_socio) then max(faixa_etaria) else '0' end AS faixa_etaria
        FROM EXTR_SOCIO
        --WHERE cpf_repres != ''  
        WHERE nome_repres is not null
        group by cpf_repres, nome_repres --order by 2
    ) aux
    group by cnpj_cpf_socio, nome_socio;
    return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_QUALIFICACAO_SOCIO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_QUALIFICACAO_SOCIO" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_QUALIFICACAO 
SELECT 
'http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/'||id_uri,
cast(COD as int),
DESCRICAO,
id_uri as id_qualificacao
FROM 
(SELECT DISTINCT id_uri,COD,DESCRICAO 
FROM (
  select COD, DESCRICAO,
			translate(replace(UPPER(TRIM(DESCRICAO)),' ','_'),
				'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ',
				'SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') as id_uri 
		from DOM_QUALIFICACAO_SOCIO
    ) qualific_socio) aux;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_RAZAO_SITUACAO_CADASTRAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_RAZAO_SITUACAO_CADASTRAL" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_RAZAO_SITUACAO_CADASTRAL 
SELECT 'http://www.sefaz.ma.gov.br/resource/RFB/Razao_Situacao_Cadastral/'||id_uri,Descricao,cast(Codigo as int),id_uri as id_razao_situacao_cadastral FROM (
SELECT DISTINCT id_uri,Descricao,Codigo FROM 
(
  select codigo, descricao, translate(replace(UPPER(trim(descricao)),' ','_'),
        'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ',
        'SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') as id_uri from MOTIVOS_SITUACAO
      motiv_situacao
      ) aux);
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_SITUACAO_CADASTRAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_SITUACAO_CADASTRAL" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_SITUACAO_CADASTRAL 
SELECT 'http://www.sefaz.ma.gov.br/resource/RFB/Situacao_Cadastral/'||(situacao||'-'||cnpj||'-'||data_situacao),val_data_situacao,situacao,id_uri, (situacao||'-'||cnpj||'-'||data_situacao) as id_situacao_cadastral  FROM (
SELECT DISTINCT CONCAT(CNPJ_BASICO,CONCAT(CNPJ_ORDEM,CNPJ_DV)) as cnpj,
  REPLACE(regexp_replace(nome_fantasia, '[^a-zA-Z ]', ''),' ','_') as nome_uri,
				CASE WHEN length(data_situacao) < 8 THEN NULL WHEN data_situacao = '00000000' THEN NULL ELSE to_char(to_date(data_situacao,'YYYY-MM-DD'),'YYYY_MM_DD') END as data_situacao,
                CASE WHEN length(data_situacao) < 8 THEN NULL WHEN data_situacao = '00000000' THEN NULL ELSE to_date(data_situacao,'YYYY-MM-DD') END as val_data_situacao,
				CASE situacao WHEN '1' THEN 'NULA' when '01' then 'NULA'
					WHEN '2' THEN 'ATIVA' WHEN '02' THEN 'ATIVA'
					WHEN '3' THEN 'SUSPENSA' WHEN '03' THEN 'SUSPENSA'
					WHEN '4' THEN 'INAPTA' WHEN '04' THEN 'INAPTA'
					WHEN '8' THEN 'BAIXADA' WHEN '08' THEN 'BAIXADA'
					ELSE 'NULL'
				END as situacao,
			    /*CASE situacao WHEN '1' THEN 'NULL'
					WHEN '2' THEN 'ACTIVE'
					WHEN '3' THEN 'SUSPENDED'
					WHEN '4' THEN 'UNFIT'
					WHEN '8' THEN 'DOWN'
					ELSE 'NULL'
				END as type_situacao,*/
				id_uri
			FROM EXTR_ESTABELECIMENTO LEFT OUTER JOIN 
            (select codigo, descricao, translate(replace(UPPER(trim(descricao)),' ','_'),
                'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ',
                'SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') as id_uri from MOTIVOS_SITUACAO)
            motiv_situacao ON EXTR_ESTABELECIMENTO.motivo_situacao = motiv_situacao.codigo ) aux;

return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_SITUACAO_ESPECIAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_SITUACAO_ESPECIAL" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_SITUACAO_ESPECIAL
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Situacao_Especial/'||(root_cnpj||'-'||data_sit_especial) 
       ,data_sit  
       ,sit_especial
       ,(root_cnpj||'-'||data_sit_especial) as id_situacao_especial
FROM 
(
	SELECT  DISTINCT CNPJ_BASICO                                                                                                    AS root_cnpj 
	       ,CASE DATA_SIT_ESPECIAL WHEN '00000000' THEN NULL ELSE to_char(to_date(DATA_SIT_ESPECIAL,'YYYY-MM-DD'),'YYYY_MM_DD') END AS data_sit_especial 
	       ,CASE DATA_SIT_ESPECIAL WHEN '00000000' THEN NULL ELSE to_date(DATA_SIT_ESPECIAL,'YYYY-MM-DD') END                       AS data_sit 
	       ,SIT_ESPECIAL
	FROM EXTR_ESTABELECIMENTO
	WHERE MATRIZ_FILIAL = '1' 
	AND SIT_ESPECIAL is not null 
) aux;

return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_SOCIEDADE_COM_ESTRANGEIRO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_SOCIEDADE_COM_ESTRANGEIRO" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_SOCIEDADE_COM_ESTRANGEIRO
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Sociedade/'||(id_uri||'-'||root_cnpj||'-'||uri_socio) AS uri_ 
       ,MAX(data_entrada)
       ,MAX(descricao) 
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/',rep_quali))
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Pessoa/',(uri_socio))) 
       ,MAX (CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Pessoa',(CONCAT(CONCAT(cpf_rep,'-'),nome_rep)))) 
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/',(id_uri))) 
       ,MAX((id_uri||'-'||root_cnpj||'-'||uri_socio)) AS id_sociedade
       ,MAX(id_uri) AS id_qualificacao_socio
       ,MAX(rep_quali) AS id_qualificacao_representante
       ,MAX(uri_socio) AS id_socio
       ,MAX(CONCAT(CONCAT(cpf_rep,'-'),nome_rep)) AS id_representante
FROM 
(
	SELECT  DISTINCT to_date(s.DATA_ENTRADA,'YYYY-MM-DD') as data_entrada
				 ,CONCAT(CONCAT(q.DESCRICAO,': '),s.NOME_SOCIO)                                                        AS descricao 
	       ,r.id_uri                                                                                             AS rep_quali 
	       ,REPLACE(regexp_replace(s.NOME_REPRES,'[^a-zA-Z ]',''),' ','_')                                       AS nome_rep 
	       ,regexp_replace(s.CPF_REPRES,'[^0-9]','_')                                                            AS cpf_rep 
	       ,s.CNPJ_BASICO                                                                                        AS root_cnpj 
	       ,q.id_uri                                                                                             AS id_uri 
	       ,CONCAT(CONCAT('_','-'),REPLACE(regexp_replace(s.NOME_SOCIO,'[^a-zA-Z ]',''),' ','_'))                AS uri_socio
	FROM EXTR_SOCIO s
	INNER JOIN 
	(
		SELECT  cod 
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
		FROM DOM_QUALIFICACAO_SOCIO 
	) q
	ON s.cod_qualificacao = q.COD
	LEFT OUTER JOIN -- Para permitir que representantes possam ser nulos
	(
		SELECT  cod 
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
		FROM DOM_QUALIFICACAO_SOCIO 
	) r
	ON s.cod_qualif_repres = r.COD
	WHERE tipo_socio = '3'  
) aux
GROUP BY  (id_uri||'-'||root_cnpj||'-'||uri_socio);

return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_SOCIEDADE_COM_HOLDING
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_SOCIEDADE_COM_HOLDING" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
    INSERT INTO RFB_SOCIEDADE_COM_HOLDING
    SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Sociedade/'||(id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio) AS uri_ 
       ,MAX(descricao)
       ,to_date(MAX(data_entrada),'YYYY-MM-DD') 
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/',rep_quali))
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Empresa/',cnpj_cpf_socio))
       -- MAX(CONCAT(CONCAT(cnpj_cpf_socio,'-'),nome_socio))
       ,MAX(CONCAT ('http://www.sefaz.ma.gov.br/resource/RFB/Pessoa/',(CONCAT(CONCAT(cpf_rep,'-'),nome_rep))))
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/',(id_uri)))
       ,MAX((id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio)) AS id_sociedade
       ,MAX(id_uri) AS id_qualificacao_socio
       ,MAX(rep_quali) AS id_qualificacao_representante
       ,MAX((cnpj_cpf_socio||'-'||nome_socio)) AS id_socio
       ,MAX(CONCAT(CONCAT(cpf_rep,'-'),nome_rep)) AS id_representante
    FROM 
    (
        SELECT  DISTINCT CASE WHEN length(s.DATA_ENTRADA) < 8 THEN NULL WHEN s.DATA_ENTRADA like '00000000' THEN NULL ELSE to_char(to_date(s.DATA_ENTRADA,'YYYY-MM-DD'),'YYYY_MM_DD') END as data_entrada
	       ,CONCAT(CONCAT(q.DESCRICAO,': '),s.nome_socio)                                                        AS descricao 
	       ,r.id_uri                                                                                             AS rep_quali 
	       ,REPLACE(regexp_replace(s.nome_repres,'[^a-zA-Z ]',''),' ','_')                                       AS nome_rep 
	       ,regexp_replace(s.cpf_repres,'[^0-9]','_')                                                            AS cpf_rep 
	       ,s.CNPJ_BASICO                                                                                        AS root_cnpj 
	       ,q.id_uri                                                                                             AS id_uri 
	       ,SUBSTR(s.cnpj_cpf_socio,0,9)                                                                         AS cnpj_cpf_socio 
	       ,REPLACE(regexp_replace(s.nome_socio,'[^a-zA-Z ]',''),' ','_')                                        AS nome_socio
        FROM 
        (
            select cnpj_basico, cnpj_cpf_socio, nome_socio, cpf_repres, nome_repres, data_entrada, cod_qualificacao, cod_qualif_repres
            from EXTR_SOCIO 
            WHERE tipo_socio = '1'
        ) s
        INNER JOIN 
        (
            SELECT  cod
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
            FROM DOM_QUALIFICACAO_SOCIO 
        ) q
        ON s.cod_qualificacao = q.COD
    --or s.cod_qualif_repres = q.COD
        LEFT OUTER JOIN -- Para permitir que representantes possam ser nulos
        (
            SELECT  cod
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
            FROM DOM_QUALIFICACAO_SOCIO 
        ) r
        ON s.cod_qualif_repres = r.COD
    ) aux
    GROUP BY  (id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio);
    return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_SOCIEDADE_COM_PESSOA_FISICA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_SOCIEDADE_COM_PESSOA_FISICA" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
    INSERT INTO RFB_SOCIEDADE_COM_PESSOA_FISICA
    SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Sociedade/'||(id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio) AS uri_ 
       ,MAX(descricao) 
       ,MAX(data_entrada) 
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Pessoa/',(CONCAT(CONCAT(cnpj_cpf_socio,'-'),nome_socio)))) 
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/',(id_uri)))
       ,MAX(CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Qualificacao/',(CONCAT(CONCAT(cnpj_cpf_representante,'-'),nome_representante)))) 
       ,MAX (CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Pessoa/',(id_uri_representante)))
       ,MAX((id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio)) AS id_sociedade
       ,MAX(id_uri) AS id_qualificacao_socio
       ,MAX(id_uri) AS id_qualificacao_representante
       ,MAX((id_uri||'-'||nome_socio)) AS id_socio
       ,MAX(CONCAT(CONCAT(cnpj_cpf_representante,'-'),nome_representante)) AS id_representante
    FROM 
    (
        /*SELECT  DISTINCT CASE WHEN length(s.DATA_ENTRADA) < 8 THEN NULL WHEN s.DATA_ENTRADA like '00000000' THEN NULL ELSE to_date(s.DATA_ENTRADA,'YYYY-MM-DD') END as data_entrada
	       ,s.CNPJ_BASICO                                                                                        AS root_cnpj 
	       ,CONCAT(CONCAT(q.DESCRICAO,': '),s.nome_socio)                                                        AS descricao 
	       ,q.id_uri                                                                                             AS id_uri 
	       ,regexp_replace(s.cnpj_cpf_socio,'[^0-9]','_')                                                        AS cnpj_cpf_socio 
	       ,REPLACE(regexp_replace(s.nome_socio,'[^a-zA-Z ]',''),' ','_')                                        AS nome_socio 
	       ,regexp_replace(s.CPF_REPRES,'[^0-9]','_')                                                            AS cnpj_cpf_representante 
	       ,REPLACE(regexp_replace(s.NOME_REPRES,'[^a-zA-Z ]',''),' ','_')                                       AS nome_representante 
	       ,r.id_uri                                                                                             AS id_uri_representante
        FROM 
        (
            select cod_qualificacao, cod_qualif_repres, cnpj_basico, nome_socio, cnpj_cpf_socio, cpf_repres, nome_repres, data_entrada
            from EXTR_SOCIO
            WHERE tipo_socio = '2'  
        ) s
        INNER JOIN 
        (
            SELECT  cod
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
            FROM DOM_QUALIFICACAO_SOCIO 
        ) q
        ON s.cod_qualificacao = q.COD
        LEFT OUTER JOIN -- Para permitir que representantes possam ser nulos
        (
            SELECT  cod 
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
            FROM DOM_QUALIFICACAO_SOCIO 
        ) r
        ON s.cod_qualif_repres = r.COD*/
        --WHERE tipo_socio = '2'  
        SELECT CASE WHEN length(s.DATA_ENTRADA) < 8 THEN NULL WHEN s.DATA_ENTRADA like '00000000' THEN NULL ELSE to_date(s.DATA_ENTRADA,'YYYY-MM-DD') END as data_entrada
	       ,s.CNPJ_BASICO                                                                                        AS root_cnpj 
	       ,CONCAT(CONCAT(q.DESCRICAO,': '),s.nome_socio)                                                        AS descricao 
	       ,q.id_uri                                                                                             AS id_uri 
	       ,regexp_replace(s.cnpj_cpf_socio,'[^0-9]','_')                                                        AS cnpj_cpf_socio 
	       ,REPLACE(regexp_replace(s.nome_socio,'[^a-zA-Z ]',''),' ','_')                                        AS nome_socio 
	       ,regexp_replace(s.CPF_REPRES,'[^0-9]','_')                                                            AS cnpj_cpf_representante 
	       ,REPLACE(regexp_replace(s.NOME_REPRES,'[^a-zA-Z ]',''),' ','_')                                       AS nome_representante 
	       ,q.id_uri                                                                                             AS id_uri_representante
        FROM 
        (
            select cod_qualificacao, cod_qualif_repres, cnpj_basico, nome_socio, cnpj_cpf_socio, cpf_repres, nome_repres, data_entrada
            from EXTR_SOCIO
            WHERE tipo_socio = '2'  
        ) s
        left outer JOIN 
        (
            SELECT  cod
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
            FROM DOM_QUALIFICACAO_SOCIO 
        ) q
        ON s.cod_qualificacao = q.COD or s.cod_qualif_repres = q.COD
        /*LEFT OUTER JOIN -- Para permitir que representantes possam ser nulos
        (
            SELECT  cod 
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
            FROM DOM_QUALIFICACAO_SOCIO 
        ) r
        ON s.cod_qualif_repres = r.COD
        */
    ) aux
    GROUP BY  (id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio);
    return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_TEM_ATIV_ECONOMICA_SECUNDARIA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_TEM_ATIV_ECONOMICA_SECUNDARIA" 
return int	
is
	--declaracao do cursor
    cursor c_new is select cnpj_basico, cnpj_ordem, cnpj_dv, uf, cnae_fiscal_sec from extr_estabelecimento;

    --declaracao das variaveis emp
    cnpj_basico EXTR_ESTABELECIMENTO.cnpj_basico%TYPE;
    cnpj_ordem EXTR_ESTABELECIMENTO.cnpj_ordem%TYPE;
    cnpj_dv EXTR_ESTABELECIMENTO.cnpj_dv%TYPE;
    uf EXTR_ESTABELECIMENTO.UF%type;
    cnae extr_estabelecimento.cnae_fiscal_sec%type;
    indice_i integer := 1;
    indice_f integer := 1;
begin
    open c_new;
	fetch c_new into cnpj_basico, cnpj_ordem, cnpj_dv,	uf, cnae;

    loop
        exit when c_new%notfound;
        if cnae is not null then
            insert into RFB_TEM_ATIV_ECONOMICA_SECUNDARIA VALUES ('http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/'||concat(CNPJ_BASICO,concat(CNPJ_ORDEM, concat(CNPJ_DV, concat('-',UF)))), 'http://www.sefaz.ma.gov.br/resource/RFB/Atividade_Economica/'||SUBSTR(cnae,0,7), concat(CNPJ_BASICO,concat(CNPJ_ORDEM, concat(CNPJ_DV, concat('-',UF)))), SUBSTR(cnae,0,7));
            --DBMS_OUTPUT.put_line('primeiro cnae '|| SUBSTR(cnae,0,7));
            indice_f := instr(cnae,',',1);
            while indice_f > 0 loop
                --DBMS_OUTPUT.put_line('indice i '|| indice_i);
                --DBMS_OUTPUT.put_line('indice f '|| indice_f);
                --sys.DBMS_OUTPUT.PUT_LINE('loop 1 cnpj '|| substr(cnae, indice_i+8, 7));
                --insert into RFB_TEM_ATIV_ECONOMICA_SECUNDARIA VALUES ('http://www.sefaz.ma.gov.br/resource/RFB/Atividade_Economica/'||concat(CNPJ_BASICO,concat(CNPJ_ORDEM, concat(CNPJ_DV, concat('-',UF)))), substr(cnae, indice_i+8, 7));
                insert into RFB_TEM_ATIV_ECONOMICA_SECUNDARIA VALUES ('http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/'||concat(CNPJ_BASICO,concat(CNPJ_ORDEM, concat(CNPJ_DV, concat('-',UF)))), 'http://www.sefaz.ma.gov.br/resource/RFB/Atividade_Economica/'||substr(cnae, indice_i+8, 7), concat(CNPJ_BASICO,concat(CNPJ_ORDEM, concat(CNPJ_DV, concat('-',UF)))), substr(cnae, indice_i+8, 7));
                indice_i := indice_f +1;
                indice_f := instr(cnae,',',indice_i);
            end loop;
            indice_i := 1;
        end if;
        fetch c_new into cnpj_basico, cnpj_ordem, cnpj_dv,	uf, cnae;
        exit when c_new%notfound;
    end loop;
    return 13;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_TEM_ESTABELECIMENTO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_TEM_ESTABELECIMENTO" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_TEM_ESTABELECIMENTO
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Empresa/'||root_cnpj_e 
       ,'http://www.sefaz.ma.gov.br/resource/RFB/Estabelecimento/'||cnpj_f
       ,root_cnpj_e as id_empresa
       ,cnpj_f as id_estabelecimento
FROM 
(
	SELECT  DISTINCT e.CNPJ_BASICO                                           AS root_cnpj_e 
	       ,CONCAT(f.CNPJ_BASICO,CONCAT(f.CNPJ_ORDEM,f.CNPJ_DV))             AS cnpj_f 
	       ,REPLACE(regexp_replace(e.razao_social,'[^a-zA-Z ]',''),' ','_')  AS razao_uri_e 
				 ,f.UF as UF
	FROM EXTR_EMPRESAS e
	INNER JOIN EXTR_ESTABELECIMENTO f
	ON e.CNPJ_BASICO = f.CNPJ_BASICO
	WHERE f.matriz_filial = '2'  
) aux; 

return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_TEM_SITUACAO_ESPECIAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_TEM_SITUACAO_ESPECIAL" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_TEM_SITUACAO_ESPECIAL
SELECT  CONCAT ('http://www.sefaz.ma.gov.br/resource/RFB/Empresa/',root_cnpj)
       ,CONCAT ('http://www.sefaz.ma.gov.br/resource/RFB/Situacao_especial/',CONCAT(CONCAT(root_cnpj,'-'),data_sit_especial))
       ,root_cnpj AS id_empresa
       ,CONCAT(CONCAT(root_cnpj,'-'),data_sit_especial) AS id_situacao_especial
FROM 
(
	SELECT  DISTINCT e.CNPJ_BASICO                                                                                                                  AS root_cnpj 
	       ,REPLACE(regexp_replace(e.razao_social,'[^a-zA-Z ]',''),' ','_')                                                                         AS razao_uri 
	       ,CASE est.data_sit_especial WHEN '00000000' THEN null ELSE to_char(to_date(est.data_sit_especial,'YYYY-MM-DD'),'YYYY_MM_DD') END AS data_sit_especial
	FROM EXTR_ESTABELECIMENTO est
	INNER JOIN EXTR_EMPRESAS e
	ON est.CNPJ_BASICO = e.CNPJ_BASICO
	WHERE est.matriz_filial = '1' 
	AND est.sit_especial is not null 
) aux;

return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_TEM_SOCIEDADE_ESTRANGEIRA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_TEM_SOCIEDADE_ESTRANGEIRA" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_TEM_SOCIEDADE_ESTRANGEIRA
SELECT  CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Empresa/',root_cnpj) 
       ,CONCAT('http://www.sefaz.ma.gov.br/resource/RFB/Socio/',(id_uri||'-'||root_cnpj||'-'||uri_socio))
       ,root_cnpj AS id_empresa
       ,(id_uri||'-'||root_cnpj||'-'||uri_socio) AS id_socio 
FROM 
(
	SELECT  DISTINCT s.CNPJ_BASICO                                                                AS root_cnpj 
	       ,REPLACE(regexp_replace(e.RAZAO_SOCIAL,'[^a-zA-Z ]',''),' ','_')                       AS razao_uri 
	       ,q.id_uri                                                                              AS id_uri 
	       ,CONCAT(CONCAT('_','-'),REPLACE(regexp_replace(s.NOME_SOCIO,'[^a-zA-Z ]',''),' ','_')) AS uri_socio
	FROM EXTR_SOCIO s
	INNER JOIN EXTR_EMPRESAS e
	ON e.CNPJ_BASICO = s.CNPJ_BASICO
	INNER JOIN 
	(
		SELECT  cod 
		       ,descricao 
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
		FROM DOM_QUALIFICACAO_SOCIO
	) q
	ON s.COD_QUALIFICACAO = q.COD
	WHERE tipo_socio = '3'  
) aux;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_TEM_SOCIEDADE_FISICA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_TEM_SOCIEDADE_FISICA" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_TEM_SOCIEDADE_FISICA
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Empresa/'||root_cnpj 
       ,'http://www.sefaz.ma.gov.br/resource/RFB/Sociedade/'||(id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio)
       ,root_cnpj AS id_empresa
       ,(id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio) AS id_socio 
FROM 
(
	SELECT  DISTINCT s.CNPJ_BASICO                                        AS root_cnpj 
	       ,REPLACE(regexp_replace(razao_social,'[^a-zA-Z ]',''),' ','_') AS razao_uri 
	       ,q.id_uri                                                      AS id_uri 
	       ,regexp_replace(s.CNPJ_CPF_SOCIO,'[^0-9]','_')                 AS cnpj_cpf_socio 
	       ,REPLACE(regexp_replace(s.NOME_SOCIO,'[^a-zA-Z ]',''),' ','_') AS nome_socio
	FROM EXTR_SOCIO s
	INNER JOIN EXTR_EMPRESAS e
	ON e.CNPJ_BASICO = s.CNPJ_BASICO
	INNER JOIN 
	(
		SELECT  cod
		       ,descricao  
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
		FROM DOM_QUALIFICACAO_SOCIO 
	) q
	ON s.COD_QUALIFICACAO = q.COD
	WHERE tipo_socio = '2'  
) aux;
return povoamento;
end;

/
--------------------------------------------------------
--  DDL for Function POVOA_RFB_TEM_SOCIEDADE_JURIDICA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "UFC2"."POVOA_RFB_TEM_SOCIEDADE_JURIDICA" 
return int	
is
	--declaracao das variaveis emp
    povoamento integer := 13;
begin
INSERT INTO RFB_TEM_SOCIEDADE_JURIDICA
SELECT  'http://www.sefaz.ma.gov.br/resource/RFB/Empresa/'||root_cnpj
       ,'http://www.sefaz.ma.gov.br/resource/RFB/Sociedade/'||(id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio)
       ,root_cnpj AS id_empresa
       ,(id_uri||'-'||root_cnpj||'-'||cnpj_cpf_socio||'-'||nome_socio) AS id_socio 
FROM 
(
	SELECT  DISTINCT s.CNPJ_BASICO                                  AS root_cnpj
	       ,REPLACE(regexp_replace(e.RAZAO_SOCIAL,'[^a-zA-Z ]',''),' ','_') AS razao_uri
	       ,q.id_uri                                                      AS id_uri
	       ,SUBSTR(s.CNPJ_CPF_SOCIO,0,9)                                    AS cnpj_cpf_socio
	       ,REPLACE(regexp_replace(s.NOME_SOCIO,'[^a-zA-Z ]',''),' ','_')   AS nome_socio
	FROM EXTR_SOCIO s
	INNER JOIN EXTR_EMPRESAS e
	ON e.CNPJ_BASICO = s.CNPJ_BASICO
	INNER JOIN 
	(
		SELECT  cod
		       ,descricao
		       ,translate (replace(UPPER(TRIM(descricao)),' ','_'),'øøøøY¡«…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’À‹œ÷—›Â·ÁÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ıÎ¸ÔˆÒ˝ˇ','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS id_uri
		FROM DOM_QUALIFICACAO_SOCIO
	) q
	ON s.COD_QUALIFICACAO = q.COD
	WHERE tipo_socio = '1'  
) aux;
return povoamento;
end;

/
