--------------------------------------------------------
--  Arquivo criado - Ter�a-feira-Junho-07-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View REDESIM_CARTORIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_CARTORIO" ("ID", "NUMERO_CARTORIO", "COMARCA") AS 
  (
    SELECT CONCAT('CART�RIO-',TSO_NUMCARTORIO) AS ID, 
    TSO_NUMCARTORIO AS numero_cartorio,
    TSO_NOMECOMARCA AS comarca 
    FROM APL_REDESIM.TAB_SOCIOS@DL_CENT 
    WHERE TSO_NUMCARTORIO IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_CONTRIBUINTE_ICMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_CONTRIBUINTE_ICMS" ("CNPJ_CPF", "NOME", "INSCRICAO_ESTADUAL", "FONTE") AS 
  (
    SELECT ID AS CNPJ_CPF, CASE WHEN NOME_FANTASIA IS NOT NULL THEN NOME_FANTASIA ELSE RAZAO_SOCIAL END AS NOME,
    TO_CHAR(INSCRICAO_ESTADUAL) AS INSCRICAO_ESTADUAL,
    'REDESIM' AS FONTE
    FROM
    REDESIM_ESTABELECIMENTO est
    WHERE
    ID_tipo_contribuicao = 'CONTRIBUINTE_ICMS'
    AND ID > 0
    UNION ALL
    SELECT ID AS CNPJ_CPF, NOME,
    '' AS INSCRICAO_ESTADUAL,
    'REDESIM' AS FONTE
    FROM
    REDESIM_PESSOA pessoa
    WHERE
    ID_tipo_contribuicao = 'CONTRIBUINTE_ICMS'
    AND ID > 0
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_DOCUMENTO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_DOCUMENTO" ("ID", "CODIGO_DOCUMENTO", "IDENTIDADE", "DOC_ORGAO_EMISSOR", "ORGAO_EMISSOR") AS 
  (
    SELECT 
    CASE TSO_TIPODOCUMENTO 
        WHEN 1 THEN 'RG'
        WHEN 2 THEN 'CARTEIRA_DE_TRABALHO_E_PREVIDENCIA_SOCIAL'
        WHEN 3 THEN 'CERTIFICADO_DE_RESERVISTA'
        WHEN 4 THEN 'PASSAPORTE'
        WHEN 5 THEN 'CARTEIRA_DE_IDENTIDADE_PROFISSIONAL'
        WHEN 6 THEN 'CNH'
        WHEN 7 THEN 'CEDULA_DE_IDENTIDADE_ESTRANGEIRO'
        END AS ID,
    TSO_TIPODOCUMENTO AS CODIGO_DOCUMENTO,
    TSO_IDENTIDADE as identidade,
    CASE WHEN TSO_DOCORGAOEMISSOR IS NULL THEN '' ELSE TSO_DOCORGAOEMISSOR END as doc_orgao_emissor,
    CASE WHEN TSO_ORGAOEMISSOR IS NULL THEN '' ELSE TSO_ORGAOEMISSOR END as orgao_emissor
    FROM APL_REDESIM.TAB_SOCIOS@DL_CENT
    WHERE TSO_TIPODOCUMENTO IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_DOCUMENTO_COMPLEMENTAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_DOCUMENTO_COMPLEMENTAR" ("ID", "ROTULO", "CNPJ_ESTABELECIMENTO", "DATA_EVENTO", "DATA_VALIDADE", "MODELO", "NUMERO_DOCUMENTO", "URL", "SITUACAO", "DESCRICAO", "OBSERVACAO", "CODIGO_SUFRAMA", "ORGAO_EMISSOR", "CODIGO_PROCESSO", "ID_ARQUIVO", "ID_PROTOCOLO") AS 
  (
    SELECT TDC_ID AS ID,
        CONCAT(CONCAT(TDC_ID,'-'),TDC_PROTOCOLO) AS rotulo, 
        TDC_CNPJ as cnpj_estabelecimento, 
        TDC_DTEVENTO as data_evento,
        TDC_DTVALIDADE as data_validade, 
        TDC_MODELODOCUMENTO as modelo,
        TDC_NUMDOCUMENTO as numero_documento, 
        TDC_URL as url,    
        TDC_SITUACAO as situacao,
        TDC_DESCRICAO as descricao,
        TDC_OBSERVACAO as observacao,
        TDC_CODSUFRAMA as codigo_suframa,
        TDC_ORGAOEMISSOR as orgao_emissor,
        TDC_CODPROCESSO as codigo_processo, 
        TDC_TAR_ID AS ID_arquivo, 
        TDC_PROTOCOLO as ID_protocolo 
    FROM APL_REDESIM.TAB_DOCUMENTOS_COMPLEMENTARES@dl_cent
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_EMPRESA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_EMPRESA" ("ID", "RAZAO_SOCIAL", "NIRE", "DATA_ASSINATURA", "DATA_ULTIMO_ARQUIVAMENTO", "SITE", "CAPITAL_SOCIAL", "DATA_CONSTITUICAO", "DESTAQUE_CAPITAL", "ID_NATUREZA_LEGAL", "ID_PORTE", "CNPJ_RAIZ", "ROTULO") AS 
  (
    SELECT SUBSTR(TEM_CNPJ,0,8) AS ID, 
    TEM_RAZAOSOCIAL AS razao_social, TEM_NIRE AS nire, 
    TEM_DTASSINATURA AS data_assinatura, TEM_DTULTARQUIVAMENTO AS data_ultimo_arquivamento, 
    CASE WHEN TEM_SITIO IS NULL THEN '' END AS site,
    TEM_CAPITALSOCIAL AS capital_social, TEM_DTCONSTITUICAO AS data_constituicao, 
    TEM_DESTAQUECAPITAL AS destaque_capital, 
    TEM_NATUREZAJURIDICA AS ID_natureza_legal, 
    CASE  
        WHEN TEM_CAPITALSOCIAL <= 81000 THEN 'MEI'
                    WHEN TEM_CAPITALSOCIAL > 81000 AND TEM_CAPITALSOCIAL <= 3600000 THEN 'MICRO_EMPRESA'
                    WHEN TEM_CAPITALSOCIAL > 360000 AND TEM_CAPITALSOCIAL <= 4800000 THEN 'PEQUENO_PORTE'
                    WHEN TEM_CAPITALSOCIAL > 4800000 AND TEM_CAPITALSOCIAL <= 300000000 THEN 'MEDIO_PORTE'
                    WHEN TEM_CAPITALSOCIAL > 300000000 THEN 'GRANDE_PORTE'
    END as ID_porte,
    SUBSTR(TEM_CNPJ,0,8) AS cnpj_raiz, 
    CONCAT(CONCAT(SUBSTR(TEM_CNPJ,0,8),'-'),TEM_RAZAOSOCIAL) AS rotulo
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent
    WHERE
    TEM_CNPJ IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_ENDERECO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_ENDERECO" ("ID", "CIDADE", "ESTADO", "BAIRRO", "LOGRADOURO", "ID_CIDADE", "ID_BAIRRO", "ID_LOGRADOURO", "CEP", "CEP_CAIXA_POSTAL", "NUMERO", "COMPLEMENTO", "NOME_ENDERECO", "CNPJ") AS 
  (
SELECT 
    TEN_TEM_ID as ID,
    UPPER(REGEXP_REPLACE(CIDADE,'\s','_')) as CIDADE,
    UPPER(REGEXP_REPLACE(correios.UF,'\s','_')) AS ESTADO,
    CASE WHEN TEN_BAIRRO IS NULL THEN '' ELSE TEN_BAIRRO END as BAIRRO, 
    CASE WHEN TEN_ENDERECO IS NULL THEN '' ELSE TEN_ENDERECO END as LOGRADOURO,
    UPPER(REGEXP_REPLACE(CONCAT(CONCAT(CIDADE,'-'),correios.UF),'\s','_')) AS ID_CIDADE,
    UPPER(REGEXP_REPLACE(CONCAT(CONCAT(CIDADE,'-'),TEN_BAIRRO),'\s','_')) AS ID_BAIRRO,
    UPPER(REGEXP_REPLACE(CONCAT(CONCAT(TEN_ENDERECO,'-'),TEN_BAIRRO),'\s','_')) AS ID_LOGRADOURO,
    TO_CHAR(TEN_CEP) AS cep,
    TO_CHAR(TEN_CAIXAPOSTALCEP) AS cep_caixa_postal, 
    TEN_NUMERO AS numero,
    TEN_COMPLEMENTO AS complemento,
    CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TEN_TIPOLOGRADOURO,'-'),TEN_ENDERECO),'-'),TEN_NUMERO),'-'),TEN_BAIRRO),'-'),CIDADE) AS nome_endereco,
    TEM_CNPJ AS CNPJ
    FROM APL_REDESIM.TAB_EMPRESA@DL_CENT emp,APL_REDESIM.TAB_EMPRESA_ENDERECO@DL_CENT endereco, 
    QUALOCEP_CIDADE correios
    WHERE 
    emp.TEM_ID = endereco.TEN_ID
    AND
    endereco.TEN_CEP = correios.CEP
    
)
;
--------------------------------------------------------
--  DDL for View REDESIM_ENDERECO_SOCIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_ENDERECO_SOCIO" ("ID", "CIDADE", "ESTADO", "BAIRRO", "LOGRADOURO", "ID_CIDADE", "ID_BAIRRO", "ID_LOGRADOURO", "CEP", "CEP_CAIXA_POSTAL", "NUMERO", "COMPLEMENTO", "NOME_ENDERECO", "CNPJ_CPF", "INSCRICAO_ESTADUAL") AS 
  (
    SELECT --standard_hash(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TSO_TIPOLOGRADOURO,'-'),TSO_ENDERECO),'-'),
    --TSO_NUMERO),'-'),TSO_COMPLEMENTO),'-'),TSO_BAIRRO),'-'),TSO_CEP),'-'),'-'),CIDADE),'MD5') AS ID,
    TSO_TCC_ID AS ID,
    UPPER(REGEXP_REPLACE(CIDADE,'\s','_')) as CIDADE,
    UPPER(REGEXP_REPLACE(correios.UF,'\s','_')) AS ESTADO,
    CASE WHEN TSO_BAIRRO IS NULL THEN '' ELSE TSO_BAIRRO END as BAIRRO, 
    CASE WHEN TSO_ENDERECO IS NULL THEN '' ELSE TSO_ENDERECO END as LOGRADOURO,
    UPPER(REGEXP_REPLACE(CONCAT(CONCAT(CIDADE,'-'),correios.UF),'\s','_')) AS ID_CIDADE,
    UPPER(REGEXP_REPLACE(CONCAT(CONCAT(CIDADE,'-'),TSO_BAIRRO),'\s','_')) AS ID_BAIRRO,
    UPPER(REGEXP_REPLACE(CONCAT(CONCAT(TSO_ENDERECO,'-'),TSO_BAIRRO),'\s','_')) AS ID_LOGRADOURO,
    TSO_CEP as cep,
    CASE WHEN TSO_CAIXAPOSTAL IS NULL THEN '' ELSE TSO_CAIXAPOSTAL END as cep_caixa_postal, 
    TSO_NUMERO AS numero,
    TSO_COMPLEMENTO AS complemento,
    CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TSO_TIPOLOGRADOURO,'-'),TSO_ENDERECO),'-'),TSO_NUMERO),'-'),TSO_BAIRRO),'-'),CIDADE) AS nome_endereco,
    TSO_CPF_CNPJ AS CNPJ_CPF,
    TCC_RUC AS INSCRICAO_ESTADUAL  
    FROM APL_REDESIM.TAB_SOCIOS@dl_cent.sefaz.ma.gov.br socios, QUALOCEP_CIDADE correios, APL_REDESIM.TAB_SOLICITACAO@dl_cent.sefaz.ma.gov.br
    WHERE socios.TSO_CEP = correios.CEP
    AND 
    socios.TSO_TCC_ID = TCC_ID
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_ENTIDADE_INTEGRADA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_ENTIDADE_INTEGRADA" ("ID", "IDENTIDADE") AS 
  (
    SELECT DISTINCT TCC_CODEMISSOR as ID, CONCAT('EMISSOR-',TCC_CODEMISSOR) AS identidade 
    FROM APL_REDESIM.TAB_SOLICITACAO@dl_cent
    WHERE TCC_CODEMISSOR IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_EXIGENCIA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_EXIGENCIA" ("ID", "ID_DOCUMENTOS_COMPLEMENTARES", "DESCRICAO_EXIGENCIA", "ROTULO") AS 
  (
    SELECT DISTINCT 
    TED_CODEXIGENCIA AS ID, 
    TED_TDC_ID AS ID_documentos_complementares,
    CASE TED_CODEXIGENCIA 
    WHEN 1  THEN 'Outros'
    WHEN 2  THEN 'Faltou assinatura de no m�nimo um dos s�cios.'
    WHEN 3  THEN 'Aus�ncia do regime de casamento.'
    WHEN 4  THEN 'Verificada pend�ncias na vistoria.'
    WHEN 5  THEN 'Verificar as assinaturas digitais.'
    WHEN 6  THEN 'Recomposi��o do quadro geral de funcion�rios.'
    WHEN 7  THEN 'taxa extra de servi�os.'
    WHEN 8  THEN 'Fluxo de informa��es constante ao longo do tempo.'
    WHEN 9  THEN 'Verificar a seguran�a das informa��es.'
    WHEN 10 THEN 'Compartilhamento de informa��es para o crescimento da empresa.'
    WHEN 11 THEN 'Arquivos e licita��es documentais'
    WHEN 12 THEN 'Compartilhamento de informa��es para melhor comunica��o.'
    WHEN 13 THEN 'Demonstra��os dos indices financeiros para obter melhoeres resultados.'
    WHEN 14 THEN 'melhores �ndices financeiros.'
    WHEN 15 THEN 'informa��es essenciais para obter suporte.'
    WHEN 16 THEN 'documentos para arquivar e posterior an�lise dos dados.'
    WHEN 17 THEN 'documentos e licita��es para an�lise.'
    WHEN 18 THEN 'Taxas concedidas para pagamento.'
    WHEN 19 THEN 'arquivos e licita��es complementares.'
    WHEN 20 THEN 'informa��es para suporte.'
    WHEN 21 THEN 'taxa minima para pagamento'
    WHEN 22 THEN 'documentos comprovantes de licita��es.'
    WHEN 23 THEN 'informa��es sobre suporte'
    WHEN 24 THEN 'registros arquivados para posterior an�lise.'
    WHEN 25 THEN 'Vistoria realizada com pend�ncias.'
    WHEN 26 THEN 'leis complementares ao estatuto'
    WHEN 27 THEN 'licita��es de segunda inst�ncia'
    WHEN 28 THEN 'Complementa��o das atividades dos arquivos.'
    WHEN 29 THEN 'Homologa��o de documentos'
    WHEN 30 THEN 'entidades cadastradas no banco de dados.'
    WHEN 31 THEN 'arquivos e documentos solicitados para suporte.'
    WHEN 32 THEN 'fluxo de informa��es para suporte.'
    WHEN 33 THEN 'documentos completos para licita��es'
    WHEN 34 THEN 'Arquivos e documentos cadastrados.'
    WHEN 35 THEN 'Homologa��o dos registros financeiros.'
    WHEN 36 THEN 'cadastramento de documentos para homologar.'
    WHEN 37 THEN 'Arquivos e documentos para suporte.'
    WHEN 38 THEN 'Informa��es para atendimento de suporte.'
    WHEN 39 THEN 'Adequa��o dos sistemas de informa��o.'
    WHEN 40 THEN 'Licita��es para arquivar.'
    WHEN 41 THEN 'Arquivos de consultoria'
    WHEN 42 THEN 'Consultar arquivos e documentos homologados.'
    WHEN 43 THEN 'protocolos para abertura de empresas.'
    WHEN 44 THEN 'n�meros de protocolos para abertura de empresas.'
    WHEN 45 THEN 'Demonstra��o dos arquivos e licita��es autenticadas.'
    WHEN 46 THEN 'An�lise dos setores demonstrativos.'
    WHEN 47 THEN 'Necess�rio a apresenta��o do projeto t�cnico simplificado.'
    WHEN 48 THEN 'Apresentar projeto t�cnico simplificado para analise e aprova��o.'
    WHEN 49 THEN 'Autentica��o dos documentos para valida��o.'
    WHEN 50 THEN 'Propostas de demonstra��es v�lidas.'
    WHEN 51 THEN 'Cadastramento de empresas.'
    WHEN 52 THEN 'Registro dos materiais para execu��o dos servi�os.'
    WHEN 53 THEN 'Informa��es para suporte'
    WHEN 54 THEN 'Autoriza��o para facilitar aprendizado.'
    WHEN 55 THEN 'Documentos autenticados para valida��o de seu conte�do.'
    WHEN 56 THEN 'An�lise de documenta��o para licita��o.'
    WHEN 57 THEN 'Unidades de arquivos na fase inicial.'
    WHEN 58 THEN 'O (centro comercial em que funciona sua empresa) est� com o seu Auto de Vistoria do Corpo de Bombeiros vencido, portanto irregular junto ao �rg�o, a emiss�o do auto de conformidade se dar� ap�s a regulariza��o da edifica��o.'
    WHEN 59 THEN 'Sequ�ncia dos fatores para melhor proje��o.'
    WHEN 60 THEN 'Demonstra��o das an�lises financeiras.'
    WHEN 61 THEN 'Cadastramento no banco de dados'
    WHEN 62 THEN 'Elaborar o projeto t�cnico de combate a inc�ndio da edifica��o e protocol�-lo para an�lise no Corpo de Bombeiros com o requerimento disponibilizado no portal.'
    WHEN 63 THEN 'licita��es e autentica��es de documentos'
    WHEN 64 THEN 'documentos cadastrados para seguran�a'
    WHEN 65 THEN 'Empr�timo consignado para grandes empresas'
    WHEN 66 THEN 'Rede integrada de a��es complementares'
    WHEN 67 THEN 'Maior investimento do capital para novas a��es'
    WHEN 68 THEN 'Consigna��o dos empr�stimos e juros'
    WHEN 69 THEN 'An�lise do cadastramento do pessoal'
    WHEN 70 THEN 'An�lise dos departamentos financeiros'
    WHEN 72 THEN 'cadastro no banco de dados'
    WHEN 73 THEN 'An�lise dos processos demonstrativos'
    WHEN 74 THEN 'cadastramento no banco de dados'
    WHEN 75 THEN 'An�lise dos documentos e licita��es'
    WHEN 76 THEN 'An�lise dos crit�rios para arquivamento'
    WHEN 77 THEN 'Indefini��o de atividades transcritas do CNAE.'
    WHEN 78 THEN 'Autentica��o dos documentos para an�lise'
    WHEN 79 THEN 'Cria��o de novas medidas para execu��o de documentos'
    WHEN 80 THEN 'Crit�rios de arquivamento'
    WHEN 81 THEN 'Arquivos constituintes da guarda permanente.'
    WHEN 82 THEN 'Consulta Pr�via definida para suporte.'
    WHEN 83 THEN 'Licita��es pr�vias para arquivar'
    WHEN 84 THEN 'Suporte para comunica��o e informa��o'
    WHEN 85 THEN 'An�lise dos dados e dos resultados'
    WHEN 86 THEN 'An�lises Financeiras Internas'
    WHEN 87 THEN 'An�lise de dados para homologa��o.'
    WHEN 88 THEN 'Sistemas de verifica��o'
    WHEN 89 THEN 'Compartilhamento de informa��es'
    WHEN 90 THEN 'Suporte para informa��es adequadas'
    WHEN 91 THEN 'An�lise dos resultados financeiros'
    WHEN 92 THEN 'Cadastramento de empresas'
    WHEN 93 THEN 'Empresas cadastradas no sistema'
    WHEN 94 THEN 'Resultados das an�lises nos sistemas'
    WHEN 95 THEN 'Declara��o para funcionamento das empresas'
    WHEN 96 THEN 'Consultas Pr�vias'
    WHEN 97 THEN 'Suporte para informa��es do cadastro'
    WHEN 98 THEN 'N�o cumpriu com exig�ncias estabelecidas.'
    WHEN 99 THEN 'Inclus�o dos arquivos para homologa��o'
    WHEN 100    THEN 'Homologa��o de arquivos para visualiza��o'
    WHEN 101    THEN 'cadastro de empresas para consulta pr�via'
    WHEN 102    THEN 'Arquivamento dos dados para posterior an�lise'
    WHEN 103    THEN 'Cadastramento das empresas no sistema'
    WHEN 104    THEN 'Cadastramento de empresas e consulta pr�via'
    WHEN 105    THEN 'Suporte e informa��es'
    WHEN 106    THEN 'Cadastramento no sistema das empresas avaliadas'
    WHEN 107    THEN 'An�lise Financeira dos m�todos'
    WHEN 108    THEN 'Cadastro das empresas para facilitar todo o processo'
    WHEN 109    THEN 'Documentos comprobat�rios para execu��o no sistema'
    WHEN 110    THEN 'Procurar um engenheiro ou arquiteto para elaborar o respectivo projeto obedecendo normas t�cnicas do CBMAP.'
    WHEN 111    THEN 'An�lise dos departamentos em toda rede integrada'
    WHEN 112    THEN 'An�lise para verificar os erros contidos no sistema'
    WHEN 113    THEN 'Cadastramento das Entidades Municipais'
    WHEN 114    THEN 'An�lise dos departamentos e setores empresariais'
    WHEN 115    THEN 'Crit�rios para estruturar a base dos documentos e licita��es'
    WHEN 116    THEN 'Cadastramento das empresas na rede'
    WHEN 117    THEN 'An�lise dos financiamentos e prazos para as empresas'
    WHEN 118    THEN 'Visualiza��o dos documentos para posterior an�lise'
    WHEN 119    THEN 'Cadastramento de todas as Entidades Municipais na rede'
    WHEN 120    THEN 'Documentos comprobat�rios de licenciamento e gest�o'
    WHEN 121    THEN 'Cadastramento dos Munic�pios para realizar abertura do sistema'
    WHEN 122    THEN 'Fiscaliza��o das Entidades Paraestatais'
    WHEN 123    THEN 'An�lise dos padr�es financeiros ao n�vel da empresa'
    WHEN 124    THEN 'Cadastramento das empresas no sistema integrado'
    WHEN 125    THEN 'Instala��o de programas para cadastrar empresas'
    WHEN 126    THEN 'Cadastramento para execu��o das atividades'
    WHEN 127    THEN 'Execu��o das atividades por meio da rede integrada'
    WHEN 128    THEN 'An�lise dos documentos para posterior execu��o'
    WHEN 129    THEN 'Recebimento dos documentos e arquivos para posterior an�lise, autentica��o e cadastramento'
    WHEN 130    THEN 'documentos arquivados no banco de dados'
    WHEN 131    THEN 'Integra��o dos suportes da empresa para melhor comunica��o'
    WHEN 132    THEN 'Solicita��o de declara��es para as empresas'
    WHEN 133    THEN 'Consulta Pr�via para maiores informa��es'
    WHEN 134    THEN 'Cadastramento das empresas na rede integrada'
    WHEN 135    THEN 'Entidade Gestora do Munic�pio'
    WHEN 136    THEN 'Homologa��o dos arquivos do sistema para posterior an�lise'
    WHEN 137    THEN 'Arquivos registrados na Junta Comercial'
    WHEN 138    THEN 'Responsabilidade da Entidade Gestora pela fiscaliza��o das notas fiscais'
    WHEN 139    THEN 'Demonstra��es das an�lises financeiras dos departamentos da empresa'
    WHEN 140    THEN 'An�lise financeira dos resultados obtidos'
    WHEN 141    THEN 'Cadastramento das empresas para posterior suporte das informa��es'
    WHEN 142    THEN 'Homologa��o a an�lise dos arquivos'
    WHEN 143    THEN 'Por se tratar de um estabelecimento que funciona dentro de uma edifica��o, a edifica��o ter� de se regularizar junto ao Corpo de Bombeiros. Caso a edifica��o j� esteja regularizada, favor informar o n�mero de seu processo no Corpo de Bombeiros.'
    WHEN 144    THEN 'Cadastramento das unidades dos arquivos homologados'
    WHEN 145    THEN 'Exig�ncia dos departamentos para obter maior lucro com os investimentos'
    WHEN 146    THEN 'An�lise do quadro quantitativo e dos resultados'
    WHEN 147    THEN 'Resultado das an�lises obtidas'
    WHEN 148    THEN 'Sequencia das opera��es individuais'
    WHEN 149    THEN 'An�lises obtidas em conjunto com os resultados'
    WHEN 150    THEN 'Junta Comercial e notas fiscais eletronicas'
    WHEN 151    THEN 'Homologa��o e demostra��o dos arquivos na rede'
    WHEN 152    THEN 'An�lise dos arquivos obtidos ap�s os resultados do processo'
    WHEN 153    THEN 'Crit�rios estabelecidos para fazer a homologa��o dos arquivos'
    WHEN 154    THEN 'Dados para an�lise documental'
    WHEN 155    THEN 'Consulta Pr�via para identificar documentos para as empresas'
    WHEN 156    THEN 'Suporte adequado para melhoria das informa��es'
    WHEN 157    THEN 'Cadastramento das empresas na Junta Comercial'
    WHEN 158    THEN 'An�lise dos documentos da empresa para consulta pr�via'
    WHEN 159    THEN 'Arquivamento dos documentos para an�lise'
    WHEN 160    THEN 'Processo de homologa��o dos arquivos'
    WHEN 161    THEN 'Rede integrada para maior suporte e informa��es'
    WHEN 162    THEN 'Demonstra��o dos arquivos na rede e homologa��o'
    WHEN 163    THEN 'Cadastramento de empresas para suporte'
    WHEN 164    THEN 'Cadastro da empresa para homologa��o'
    WHEN 165    THEN 'Registro das empresas nas Juntas Comerciais'
    WHEN 166    THEN 'Registro na Junta Comercial para posterior an�lise e suporte'
    WHEN 167    THEN 'Cadastro das empresas na rede'
    WHEN 168    THEN 'Erro no preenchimento do estado civil do s�cio: aus�ncia de especifica��o do regime de casamento, qu'
    WHEN 169    THEN 'Homologa��o dos arquivos na rede'
    WHEN 170    THEN 'An�lise dos resultados para divulga��o'
    WHEN 171    THEN 'Cadastramento das empresas na rede para suporte de informa��es nos Munic�pios'
    WHEN 172    THEN 'An�lise de todo processo para os resultados'
    WHEN 173    THEN 'Dados a serem homologados na rede e passados para suporte'
    WHEN 174    THEN 'O estabelecimento se enquadrou em uma das atividade de alto risco ou respondeu uma das quest�es como SIM.'
    WHEN 175    THEN 'An�lise dos resultados das avalia��es peri�dicas'
    WHEN 176    THEN 'Empresa que emite nota fiscal eletr�nica para os Munic�pios'
    WHEN 177    THEN 'Sistemas publicados na rede para posterior an�lise e homologa��o'
    WHEN 178    THEN 'An�lise dos processos para tomada de decis�o'
    WHEN 179    THEN 'Documenta��o necess�ria para o arquivamento e autentica��o dos pap�is'
    WHEN 180    THEN 'Prazo para entrega dos formul�rios de cadastramento das empresas'
    WHEN 181    THEN 'Demonstra��o dos �ndices financeiros'
    WHEN 182    THEN 'An�lise dos resultados financeiros papa compor o processo'
    WHEN 183    THEN 'Cadastramento dos Munic�pios na rede integrada'
    WHEN 184    THEN 'An�lise dos demonstrativos arquivados para o processo'
    WHEN 185    THEN 'An�lise dos documentos no decorrer do processo'
    WHEN 186    THEN 'Resultado do processo para fazer a homologa��o'
    WHEN 187    THEN 'homologa��o na rede para cadastramento de empresas'
    WHEN 188    THEN 'Deferimento e an�lise dos processos'
    WHEN 189    THEN 'Exig�ncias necess�rias ao funcioanamento da empresa'
    WHEN 190    THEN 'Arquivos homologados na Junta Comercial'
    WHEN 191    THEN 'Sistema de integra��o da rede para cadastramento de empresas'
    WHEN 192    THEN 'Homologa��o de documentos e suporte de informa��es'
    WHEN 193    THEN 'CEP gen�rico utilizado. Favor complementar o endere�o de acordo com a base de endere�o da SEFAZ - GO'
    WHEN 194    THEN 'Sistemas da rede para fazer a homologa��o dos arquivos'
    WHEN 203    THEN 'Departamentos centralizados para adequa��o de todos os setores.'
    WHEN 204    THEN 'Sistemas de compatibiliza��o e departamentaliza��o das �reas.'
    WHEN 205    THEN 'Rede integrada de sistenas.'
    WHEN 206    THEN 'Sistemas baseados em leis pr�prias.'
    WHEN 207    THEN 'Regulariza��o das empresas que fazem parte do sistema.'
    WHEN 208    THEN 'Regulariza��o das Entidades Municipais.'
    WHEN 209    THEN 'Erro no anexo de documentos de s�cia casada, que ainda possuem nome de solteira � no caso das que aderiram o nome do esposo'
    WHEN 210    THEN 'Crit�rios para definir as categorias com base em fichas.'
    WHEN 211    THEN 'Consulta pr�via para realiza��o das atividades da empresa.'
    WHEN 212    THEN 'Rede integrada no sistema para avaliar funcioanamento de empresas.'
    WHEN 213    THEN 'Base de dados para avalia��es e informa��es das empresas.'
    WHEN 214    THEN 'Cadastramento de Entidades Municipais e informa��es de suporte.'
    WHEN 215    THEN 'cadastramento de empresas no sistema e sus posterior abertura.'
    WHEN 216    THEN 'Informa��es no suporte para andamento do processo.'
    WHEN 217    THEN 'Compatibiliza��o de t�cnicas de suporte.'
    WHEN 218    THEN 'Suporte para compor a adequada composi��o da empresa.'
    WHEN 219    THEN 'Sistemas de integra��o e comunica��o na empresa.'
    WHEN 220    THEN 'Consulta pr�via a ser realizada para abertura da empresa.'
    WHEN 221    THEN 'Consultas para legaliza��o e registro de empresas.'
    WHEN 222    THEN 'Crit�rios a serem estabelecidos no sistema.'
    WHEN 224    THEN 'An�lise dos crit�rios estabelicidos pelo sistema.'
    WHEN 225    THEN 'Estabelecimento de regras para compor o suporte de informa��es.'
    WHEN 226    THEN 'An�lise dos resultados financeiros para obten��o de resultados'
    WHEN 227    THEN 'Consulta Pr�via para estabelecer crit�rios'
    WHEN 228    THEN 'Cadastro de empresas na rede integrada para posterior an�lise'
    WHEN 229    THEN 'Favor informar a �rea da edifica��o, caso o endere�o da empresa seja em uma resid�ncia, informar a �rea da resid�ncia. Caso haja um escrit�rio em um c�modo da resid�ncia informar a �rea da resid�ncia e a �rea do c�modo utilizado na edifica��o.'
    WHEN 230    THEN 'An�lise dos resultados e posterior compara��o'
    WHEN 231    THEN 'An�lise do sistema para integra��o na rede'
    WHEN 232    THEN 'Solicita��o do prazo de abertura'
    WHEN 233    THEN 'Andamento do processo na rede'
    WHEN 234    THEN 'Aguardando confirma��o de pagamento'
    WHEN 235    THEN 'Entrega de projeto arquitet�nico na Vigil�ncia Sanit�ria Estadual'
    WHEN 236    THEN 'Anexar RG e CPF do Respons�vel T�cnico'
    WHEN 237    THEN 'Anexar comprovante atualizado de responsabilidade t�cnica farmac�utica.'
    WHEN 238    THEN 'Anexar certificado atualizado de isen��o t�cnica farmac�utica (para postos de Medicamento)'
    WHEN 239    THEN 'Anexar carteira do conselho de classe do respons�vel t�cnico.'
    WHEN 240    THEN 'Outros'
    WHEN 241    THEN 'Anexar RG do Respons�vel Legal'
    WHEN 242    THEN 'Informar e-mail do contribuinte para esta solicita��o.'
    WHEN 243    THEN 'Informar e-mail do contabilista para esta solicita��o.'
    WHEN 244    THEN 'Informar telefone de contato do contribuinte.'
    WHEN 245    THEN 'Informar telefone de contado dos s�cios.'
    WHEN 246    THEN 'Informar telefone de contato do contador.'
    WHEN 247    THEN 'Os e-mails n�o podem ser id�nticos para pessoas diferentes.'
    WHEN 248    THEN 'Pendente de pagamento de taxa.'
    WHEN 249    THEN 'Anexar Termo de Responsabilidade T�cnica do Contabilista autenticado em cart�rio.'
    WHEN 250    THEN 'Formato de telefone do contribuinte incompat�vel.'
    WHEN 251    THEN 'Formato de telefone do contador incompat�vel.'
    WHEN 252    THEN 'Formato de telefone do s�cio incompat�vel.'
    WHEN 253    THEN 'Formato de e-mail do contribuinte incompat�vel.'
    WHEN 254    THEN 'Formato de e-mail do contador incompat�vel.'
    WHEN 255    THEN 'Formato de e-mail do s�cio incompat�vel.'
    WHEN 256    THEN 'Anexar Comprovante de Pagamento de taxa.'
    WHEN 258    THEN 'Sua atividade econ�mica foi classificada como Alto Risco, portanto para a concess�o do Alvar� Provis�rio para este estabelecimento � necess�rio obter previamente a Licen�a: Ambiental e/ou Alvar� Sanit�rio e/ou Habite-se.'
    WHEN 259    THEN 'Anexar comprovante de compra, manuten��o ou recarga do extintor de inc�ndio que o seu empreendimento obrigatoriamente dever� possuir como preventivo;'
    WHEN 260    THEN 'Anexar comprovante de compra da lumin�ria de emerg�ncia; *D�vidas ligue: 3212-1510 DAT (Diretoria de Atividades T�cnicas). Endere�o: Caminho da Boiada Centro, pr�ximo a TERRA ZOO.'
    WHEN 261    THEN 'Retirar fotografia da central de g�s da sua parte frontal e lateral e anex�-las para verifica��o do cumprimento das normas. (Esta fotografia deve possuir os seguintes itens da central: placa de sinaliza��o de proibi��o de provocar chamas e fumar deve possuir extintor de inc�ndio de P� BC);'
    WHEN 262    THEN 'Anexar comprovante de pagamento da TAXA (DARE).'
    WHEN 293    THEN 'Aguardando confirma��o de pagamento. Boleto enviado em anexo, clicar em $.'
    WHEN 294    THEN 'Favor, informar com exatid�o a �rea constru�da da edifica��o e a �rea ocupada pelo estabelecimento comercial.'
    WHEN 295    THEN 'INFORMAR FORNECEDORES'
    WHEN 296    THEN 'PAGAR DUA'
    WHEN 297    THEN 'SOLICITAR CONFER�NCIA'
    WHEN 298    THEN 'APRESENTAR PROJETO DE SEGURAN�A CONTRA INC�NDIO E P�NICO'
    END AS descricao_exigencia,
    CONCAT('EXIG�NCIA-',TED_ID) AS rotulo 
    FROM APL_REDESIM.TAB_EXIGENCIAS_DOCUMENTOS@dl_cent
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_FORMA_ATUACAO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_FORMA_ATUACAO" ("ID", "FORMA_ATUACAO") AS 
  (
    SELECT DISTINCT 
    TFA_FORMAATUACAO as ID,
    CASE TFA_FORMAATUACAO 
        WHEN 1 THEN 'ESTABELECIMENTO_FIXO'
        WHEN 2 THEN 'INTERNET'
        WHEN 3 THEN 'EM_LOCAL_FIXO_FORA_DE_LOJA'
        WHEN 4 THEN 'CORREIO'
        WHEN 5 THEN 'PORTA_A_PORTA_POSTOS_MOVEIS_OU_AMBULANTES'
        WHEN 6 THEN 'TELEVENDAS'
        WHEN 7 THEN 'MAQUINAS_AUTOMATICAS'
        WHEN 8 THEN 'ATIVIDADE_DESENVOLVIDA_FORA_DO_ESTABELECIMENTO'
        ELSE 'OUTROS'
    END AS forma_atuacao
    FROM APL_REDESIM.TAB_FORMA_ATUACAO@dl_cent 
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_NACIONALIDADE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_NACIONALIDADE" ("ID") AS 
  (
    SELECT DISTINCT TSO_NACIONALIDADE as ID 
    FROM APL_REDESIM.TAB_SOCIOS@DL_CENT
    WHERE TSO_NACIONALIDADE IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_NAO_CONTRIBUINTE_ICMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_NAO_CONTRIBUINTE_ICMS" ("CNPJ_CPF", "NOME", "INSCRICAO_ESTADUAL", "FONTE") AS 
  (

    SELECT "CNPJ_CPF","NOME","INSCRICAO_ESTADUAL","FONTE" FROM REDESIM_NAO_CONTRIBUINTE_MAT
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_NATUREZA_LEGAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_NATUREZA_LEGAL" ("ID", "NATUREZA_LEGAL") AS 
  (
    SELECT TNC_COD_NATURALEZA AS ID, 
    REPLACE(UPPER(TNC_NOM_NATURALEZA),' ','_') AS natureza_legal 
    FROM APL_PAR.TAB_NAT_CONTRIBUYENTE@dl_cent
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_PESSOA_EMANCIPADA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_PESSOA_EMANCIPADA" ("ID", "NOME", "MOTIVO_EMANCIPADA") AS 
  (
    SELECT DISTINCT TSO_CPF_CNPJ AS ID, 
    TSO_NOME AS NOME,
    CASE WHEN TSO_MOTIVOEMANCIPACAO IS NULL THEN '' ELSE TSO_MOTIVOEMANCIPACAO END motivo_emancipada 
    FROM APL_REDESIM.TAB_SOCIOS@DL_CENT
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_PORTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_PORTE" ("ID") AS 
  (
    SELECT CASE TGE_COD_TIP_TABLA WHEN 1 THEN 'MICRO_EMPRESA'
      WHEN 2 THEN 'EMPRESA_PEQUENO_PORTE'
      WHEN 3 THEN 'MEI'
      WHEN 4 THEN 'DEMAIS'
    END AS ID 
    FROM APL_PAR.TAB_GENERICA@dl_cent 
    WHERE TGE_TIP_TABLA = 920
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_PROTOCOLO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_PROTOCOLO" ("ID", "IDENTIDADE", "PROTOCOLO_DBE") AS 
  (
    SELECT DISTINCT TCC_PROTOCOLOCPE AS ID, 
    CONCAT('PROTOCOLO-',TCC_PROTOCOLOCPE) AS identidade, 
    TCC_PROTOCOLODBE AS protocolo_dbe 
    FROM APL_REDESIM.TAB_SOLICITACAO@dl_cent
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_QUALIFICACAO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_QUALIFICACAO" ("ID", "CODIGO_QUALIFICACAO", "DESCRICAO_QUALIFICACAO") AS 
  (
    SELECT REPLACE(TRANSLATE (TGE_NOMBRE_DESCRIPCION,
                  '�������������������������������������������������������',
                  'SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy'),' ','_') 
    AS ID, TGE_COD_TIP_TABLA AS codigo_qualificacao, 
    TGE_NOMBRE_DESCRIPCION AS descricao_qualificacao 
    FROM APL_PAR.TAB_GENERICA@dl_cent 
    WHERE TGE_TIP_TABLA = 34
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_REGISTRO_CARTORIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_REGISTRO_CARTORIO" ("ID", "ID_CARTORIO", "IDENTIDADE", "ANO_REGISTRO") AS 
  (
    SELECT DISTINCT
    TSO_REGCARTORIO as ID, 
    TSO_NUMCARTORIO AS ID_cartorio,
    CONCAT('REGISTRO-',TSO_REGCARTORIO) AS identidade, 
    TSO_ANOREGCARTORIO AS ano_registro 
    FROM APL_REDESIM.TAB_SOCIOS@DL_CENT
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_REPRESENTANTE_PF
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_REPRESENTANTE_PF" ("ID", "NOME", "EMAIL", "TELEFONE") AS 
  (   
    SELECT "ID","NOME","EMAIL","TELEFONE" FROM REDESIM_REPRESENTANTE_PF_MAT
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_REPRESENTANTE_PJ
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_REPRESENTANTE_PJ" ("ID", "RAZAO_SOCIAL", "EMAIL", "TELEFONE") AS 
  (
    SELECT ID,NOME AS RAZAO_SOCIAL,EMAIL,TELEFONE FROM REDESIM_REPRESENTANTE_PJ_MAT
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_SOLICITACAO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_SOLICITACAO" ("ID", "IDENTIDADE", "DEFERIMENTO", "INSCRICAO_TRAUF", "GERA_RUC", "ENVOLVE_SEFAZ", "PROTOCOLO_DBE", "DATA_SINCRONIZACAO", "DATA_SOLICITACAO", "DATA_AUTENTICACAO", "ID_ENTIDADE_INTEGRADA_EMISSOR", "ID_PROTOCOLO", "ID_EMPRESA", "ID_STATUS_ENVIO", "ID_TIPO_ATO") AS 
  (
    SELECT TCC_ID AS ID, 
    CONCAT('SOLICITA��O-',TCC_ID) AS identidade,
    CASE TCC_DEFERIMENTOPREF WHEN 0 THEN 'SEM_DEFERIMENTO_PREFEITURA' ELSE 'COM_DEFERIMENTO_PREFEITURA' END as deferimento,
    CASE TCC_INSCRICAOOUTRAUF WHEN 0 THEN 'INSCRICAO_PROPRIA_UF' ELSE 'INSCRICAO_OUTRA_UF' END as inscricao_trauf, 
    CASE TCC_GERARUC WHEN 0 THEN 'NECESSITA_INSCRICAO_ESTADUAL' ELSE 'NAO_NECESSITA_INSCRICAO_ESTADUAL' END as gera_ruc,
    CASE TCC_ENVOLVESEFAZ WHEN 0 THEN 'ENVOLVE_SEFAZ' ELSE 'NAO_ENVOLVE_SEFAZ' END as envolve_sefaz,
    TCC_PROTOCOLODBE AS protocolo_dbe,  
    TCC_DTSINCRONIZA AS data_sincronizacao,
    TCC_DTSOLICITACAO AS data_solicitacao,
    TCC_DTAUTENTICACAO AS data_autenticacao,
    TCC_CODEMISSOR AS ID_entidade_integrada_emissor,
    TCC_PROTOCOLOCPE AS ID_protocolo,
    SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA,
    CASE TCC_STATUSENVIO WHEN 0 THEN 'NAO_PRECISA_ENVIAR' WHEN 1 THEN 'PENDENTE_ENVIO' WHEN 2 THEN 'ENVIADO_COM_SUCESSO' WHEN 3 THEN 'ENVIADO_COM_ERRO' END as ID_status_envio,
    CASE TCC_TIPOATOSEFAZ WHEN 1 THEN 'INSCRICAO' WHEN 2 THEN 'ALTERACAO' WHEN 3 THEN 'BAIXA' END as ID_tipo_ato
    FROM APL_REDESIM.TAB_SOLICITACAO@dl_cent, APL_REDESIM.TAB_EMPRESA@dl_cent
    WHERE TCC_ID = TEM_TCC_ID
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_STATUS_ENVIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_STATUS_ENVIO" ("ID", "CODIGO_STATUS_ENVIO") AS 
  (
    SELECT DISTINCT CASE TCC_STATUSENVIO WHEN 0 THEN 'NAO_PRECISA_ENVIAR'
    WHEN 1 THEN 'PENDENTE_ENVIO'
    WHEN 2 THEN 'ENVIADO_COM_SUCESSO' 
    WHEN 3 THEN 'ENVIADO_COM_ERRO'  
    END as ID, TCC_STATUSENVIO AS codigo_status_envio
    FROM APL_REDESIM.TAB_SOLICITACAO@dl_cent
    WHERE TCC_STATUSENVIO IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TEM_DEPOSITO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TEM_DEPOSITO" ("ID_EMPRESA", "ID_ESTABELECIMENTO") AS 
  (
    SELECT SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA, TEM_CNPJ AS ID_ESTABELECIMENTO 
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent jur, APL_REDESIM.TAB_EMPRESA_ENDERECO@dl_cent, APL_PAR.TAB_GENERICA@dl_cent generica, APL_REDESIM.TAB_SOLICITACAO@dl_cent solicitacao
    WHERE jur.TEM_ID = TEN_TEM_ID AND TEM_ID = solicitacao.TCC_ID AND generica.TGE_COD_TIP_TABLA = 3 AND generica.TGE_TIP_TABLA = 921
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TEM_ESTABELECIMENTO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TEM_ESTABELECIMENTO" ("ID_EMPRESA", "ID_ESTABELECIMENTO") AS 
  (
    SELECT SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA, TEM_CNPJ AS ID_ESTABELECIMENTO 
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent org, APL_REDESIM.TAB_EMPRESA_ENDERECO@dl_cent
    WHERE org.TEM_ID = TEN_TEM_ID
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TEM_FILIAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TEM_FILIAL" ("ID_EMPRESA", "ID_ESTABELECIMENTO") AS 
  (
    SELECT "ID_EMPRESA","ID_ESTABELECIMENTO" FROM REDESIM_TEM_FILIAL_MAT
)
;
--------------------------------------------------------
--  DDL for View REDESIM_TEM_FORMA_ATUACAO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TEM_FORMA_ATUACAO" ("ID_ESTABELECIMENTO", "FORMA_ATUACAO") AS 
  (
    SELECT DISTINCT TEM_CNPJ AS ID_ESTABELECIMENTO, 
    CASE TFA_FORMAATUACAO 
        WHEN 1 THEN 'ESTABELECIMENTO_FIXO'
        WHEN 2 THEN 'INTERNET'
        WHEN 3 THEN 'EM_LOCAL_FIXO_FORA_DE_LOJA'
        WHEN 4 THEN 'CORREIO'
        WHEN 5 THEN 'PORTA_A_PORTA_POSTOS_MOVEIS_OU_AMBULANTES'
        WHEN 6 THEN 'TELEVENDAS'
        WHEN 7 THEN 'MAQUINAS_AUTOMATICAS'
        WHEN 8 THEN 'ATIVIDADE_DESENVOLVIDA_FORA_DO_ESTABELECIMENTO'
        END AS forma_atuacao
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent empresa, 
         APL_REDESIM.TAB_FORMA_ATUACAO@dl_cent forma
    WHERE 
    TEM_ID = forma.TFA_TCC_ID
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TEM_MATRIZ
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TEM_MATRIZ" ("ID_EMPRESA", "ID_ESTABELECIMENTO") AS 
  (
   -- SELECT DISTINCT SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA, TEM_CNPJ AS ID_ESTABELECIMENTO FROM APL_REDESIM.TAB_EMPRESA@dl_cent jur, APL_REDESIM.TAB_EMPRESA_ENDERECO@dl_cent 
   -- WHERE jur.TEM_ID = TEN_TEM_ID AND TEM_CNPJ IN (
   --     SELECT DISTINCT TCC_CNPJMATRIZ FROM APL_REDESIM.TAB_SOLICITACAO@dl_cent solicitacao
   -- )
   SELECT "ID_EMPRESA","ID_ESTABELECIMENTO" FROM REDESIM_TEM_MATRIZ_MAT
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TEM_SOLICITACAO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TEM_SOLICITACAO" ("ID_EMPRESA", "ID_SOLICITACAO") AS 
  (
    SELECT  SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA, TEM_TCC_ID AS ID_SOLICITACAO 
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent empresa, APL_REDESIM.TAB_SOLICITACAO@dl_cent solicitacao
    WHERE solicitacao.TCC_ID = empresa.TEM_TCC_ID
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TEM_TIPO_IMOVEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TEM_TIPO_IMOVEL" ("ID_ESTABELECIMENTO", "ID_TIPO_PROPRIEDADE") AS 
  (
    SELECT DISTINCT TEM_CNPJ AS ID_ESTABELECIMENTO,
    CASE TEN_TIPOIMOVEL  
                WHEN 1 THEN 'PROPRIO'
                WHEN 2 THEN 'CEDIDO'
                WHEN 3 THEN 'ALUGADO'
                WHEN 4 THEN 'COMODATO'
                WHEN 5 THEN 'CONDOMINIO'
                WHEN 6 THEN 'OCUPANTE'
                WHEN 7 THEN 'ESPOLIO'
                WHEN 8 THEN 'PARCERIA'
                WHEN 9 THEN 'ARRENDADO'
                WHEN 10 THEN 'USUFRUTO'
                WHEN 11 THEN 'DOADO'
                ELSE 'OUTRO'
                END as ID_tipo_propriedade      
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent empresa, 
         APL_REDESIM.TAB_EMPRESA_ENDERECO@dl_cent forma
    WHERE 
    TEM_ID = TEN_TEM_ID
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TIPO_ATO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TIPO_ATO" ("ID", "CODIGO_TIPO_ATO") AS 
  (
    SELECT DISTINCT CASE TCC_TIPOATOSEFAZ WHEN 1 THEN 'INSCRICAO' WHEN 2 THEN 'ALTERACAO' WHEN 3 THEN 'BAIXA' END as ID,
     TCC_TIPOATOSEFAZ AS codigo_tipo_ato 
    FROM APL_REDESIM.TAB_SOLICITACAO@dl_cent
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TIPO_CONTRIBUICAO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TIPO_CONTRIBUICAO" ("ID", "CODIGO_TIPO_CONTRIBUINTE") AS 
  (
    SELECT DISTINCT 
                CASE TCC_CTBICMS WHEN 1 THEN 'CONTRIBUINTE_ICMS'
                    ELSE 'NAO_CONTRIBUINTE_DO_ICMS'
                END as ID, 
    TCC_CTBICMS AS codigo_tipo_contribuinte 
    FROM APL_REDESIM.TAB_SOLICITACAO@dl_cent 
    WHERE TCC_CTBICMS IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TIPO_ESTABELECIMENTO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TIPO_ESTABELECIMENTO" ("ID", "TIPO_UNIDADE", "CODIGO_TIPO_ESTABELECIMENTO") AS 
  (
    SELECT DISTINCT 
    CASE TEM_TIPOUNIDADE
        WHEN 1 THEN 'MATRIZ'
        WHEN 2 THEN 'FILIAL'
        WHEN 3 THEN 'DEPOSITO'
        WHEN 4 THEN 'OUTROS'
        WHEN 5 THEN 'PRINCIPAL'
    ELSE 'FILIAL'
    END AS ID,
    CASE TEM_TIPOUNIDADE
        WHEN 0 THEN 'UNIDADE_PRODUTIVA'
        WHEN 1 THEN 'SEDE'
        WHEN 2 THEN 'ESCRITORIO_ADMINISTRATIVO'
        WHEN 3 THEN 'DEPOSITO_FECHADO'
        WHEN 4 THEN 'ALMOXARIFADO'
        WHEN 5 THEN 'OFICINA_DE_REPARACAO'
        WHEN 6 THEN 'GARAGEM'
        WHEN 7 THEN 'UNIDADE_DE_ABASTECIMENTO_DE_COMBUSTIVEL'
        WHEN 8 THEN 'PONTO_DE_EXPOSICAO'
        WHEN 9 THEN 'CENTRO_DE_TREINAMENTO'
        WHEN 10 THEN 'CENTRO_DE_PROCESSAMENTO_DE_DADOS'
        WHEN 14 THEN 'POSTO_DE_COLETA'
    END AS tipo_unidade, 
    TEM_TIPOUNIDADE AS codigo_tipo_estabelecimento
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent
    WHERE TEM_TIPOUNIDADE IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for View REDESIM_TIPO_PROPRIEDADE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "REDESIM_TIPO_PROPRIEDADE" ("ID", "CODIGO_TIPO_IMOVEL") AS 
  (
    SELECT  CASE TEN_TIPOIMOVEL  
                WHEN 1 THEN 'PROPRIO'
                WHEN 2 THEN 'CEDIDO'
                WHEN 3 THEN 'ALUGADO'
                WHEN 4 THEN 'COMODATO'
                WHEN 5 THEN 'CONDOMINIO'
                WHEN 6 THEN 'OCUPANTE'
                WHEN 7 THEN 'ESPOLIO'
                WHEN 8 THEN 'PARCERIA'
                WHEN 9 THEN 'ARRENDADO'
                WHEN 10 THEN 'USUFRUTO'
                WHEN 11 THEN 'DOADO'
                END as ID, 
    TEN_TIPOIMOVEL AS codigo_tipo_imovel 
    FROM APL_REDESIM.TAB_EMPRESA_ENDERECO@dl_cent
    WHERE TEN_TIPOIMOVEL IS NOT NULL
)
WITH READ ONLY
;
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_SOCIEDADE
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_SOCIEDADE" ("ID_EMPRESA", "ID_SOCIEDADE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA, 
    REPLACE(CONCAT(CONCAT(CONCAT(CONCAT(TRANSLATE(TGE_NOMBRE_DESCRIPCION, '�������������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy'),'-'),SUBSTR(TEM_CNPJ,0,8)),'-'),TSO_CPF_CNPJ),' ','_')  AS ID_sociedade
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent, APL_REDESIM.TAB_SOCIOS@DL_CENT, APL_PAR.TAB_GENERICA@dl_cent 
    WHERE TEM_TCC_ID = TSO_TCC_ID
    AND (TSO_SEQTIPQUALIFICACAO = TGE_COD_TIP_TABLA AND (TGE_TIP_TABLA = 34 OR TGE_TIP_TABLA = 432));

  CREATE UNIQUE INDEX "REDESIM_TEM_SOCIEDADE_INDEX2" ON "REDESIM_TEM_SOCIEDADE" ("ID_SOCIEDADE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_TEM_SOCIEDADE_INDEX1" ON "REDESIM_TEM_SOCIEDADE" ("ID_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_SOCIEDADE"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_TEM_SOCIEDADE';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_SITUACAO_CADASTRAL
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_SITUACAO_CADASTRAL" ("ID_ESTABELECIMENTO", "ID_SITUACAO")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TEM_CNPJ AS ID_ESTABELECIMENTO, CONCAT(CONCAT(CONCAT(CONCAT(CASE TEM_SITUACAO WHEN '00' THEN 'ATIVA' 
                    WHEN '02' THEN 'CANCELADA_ART.60_LEI_8934/94'
                    WHEN '03' THEN 'EXTINTA'
                    WHEN '04' THEN 'CONVERTIDA_SOC._CIVIL-SIMPLES'
                    WHEN '06' THEN 'TRANSFERIDA_PARA_OUTRA_UF'
                    WHEN '07' THEN 'FALIDA'
                    WHEN '08' THEN 'CANCELADA'
                    WHEN '09' THEN 'REGISTRO_ATIVO_PROVISORIO'
                    WHEN '10' THEN 'CANCELADA-MEI'
                END,'-'),TEM_CNPJ),'-'), TO_CHAR(TEM_DTCONSTITUICAO,'YYYY_MM_DD')) as ID_situacao 
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent;

  CREATE INDEX "REDESIM_TEM_SITUACAO_CADASTRAL_INDEX2" ON "REDESIM_TEM_SITUACAO_CADASTRAL" ("ID_SITUACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_SITUACAO_CADASTRAL"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_TEM_SITUACAO_CADASTRAL';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_REPRESENTANTE_JURIDICO
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_REPRESENTANTE_JURIDICO" ("CNPJ_CPF", "ID_SOCIEDADE", "ID_REPRESENTANTE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TSO_CPF_CNPJ AS cnpj_cpf, REGEXP_REPLACE(CONCAT(CONCAT(CONCAT(CONCAT(TRANSLATE(TGE_NOMBRE_DESCRIPCION,
     '�������������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy'),'-'),SUBSTR(TEM_CNPJ,0,8)),'-'),TSO_CPF_CNPJ),'\s','_')  AS ID_sociedade,
    TSO_CPF_CNPJ AS ID_representante 
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent, APL_REDESIM.TAB_SOCIOS@DL_CENT, APL_REDESIM.TAB_SOLICITACAO@dl_cent, APL_PAR.TAB_GENERICA@dl_cent
    WHERE TSO_TCC_ID = TEM_TCC_ID AND TEM_TCC_ID = TCC_ID AND TSO_TIPOPESSOA = 2
    AND (TSO_SEQTIPQUALIFICACAO = TGE_COD_TIP_TABLA AND (TGE_TIP_TABLA = 34 OR TGE_TIP_TABLA = 432));

  CREATE UNIQUE INDEX "REDESIM_TEM_REPRESENTANTE_JURIDICO_INDEX2" ON "REDESIM_TEM_REPRESENTANTE_JURIDICO" ("ID_SOCIEDADE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 167 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_TEM_REPRESENTANTE_JURIDICO_INDEX1" ON "REDESIM_TEM_REPRESENTANTE_JURIDICO" ("CNPJ_CPF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_TEM_REPRESENTANTE_JURIDICO_INDEX3" ON "REDESIM_TEM_REPRESENTANTE_JURIDICO" ("ID_REPRESENTANTE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_REPRESENTANTE_JURIDICO"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_TEM_REPRESENTANTE_JURIDICO';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_REPRESENTANTE_FISICO
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_REPRESENTANTE_FISICO" ("CNPJ_CPF", "ID_SOCIEDADE", "ID_REPRESENTANTE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TSO_CPF_CNPJ AS cnpj_cpf, REGEXP_REPLACE(CONCAT(CONCAT(CONCAT(CONCAT(TRANSLATE(TGE_NOMBRE_DESCRIPCION,
     '�������������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy'),'-'),SUBSTR(TEM_CNPJ,0,8)),'-'),TSO_CPF_CNPJ),'\s','_') AS ID_sociedade, 
    TSO_CPF_CNPJ AS ID_representante 
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent, APL_REDESIM.TAB_SOCIOS@DL_CENT, APL_REDESIM.TAB_SOLICITACAO@dl_cent, APL_PAR.TAB_GENERICA@dl_cent
    WHERE TSO_TCC_ID = TEM_TCC_ID AND TEM_TCC_ID = TCC_ID AND TSO_TIPOPESSOA = 1
    AND (TSO_SEQTIPQUALIFICACAO = TGE_COD_TIP_TABLA AND (TGE_TIP_TABLA = 34 OR TGE_TIP_TABLA = 432));

  CREATE INDEX "REDESIM_TEM_REPRESENTANTE_FISICO_INDEX1" ON "REDESIM_TEM_REPRESENTANTE_FISICO" ("CNPJ_CPF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE UNIQUE INDEX "REDESIM_TEM_REPRESENTANTE_FISICO_INDEX2" ON "REDESIM_TEM_REPRESENTANTE_FISICO" ("ID_SOCIEDADE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 167 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_REPRESENTANTE_FISICO"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_TEM_REPRESENTANTE_FISICO';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA" ("ID_ESTABELECIMENTO", "ID_REALIZACAO_ATIVIDADE_ECONOMICA")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TEM_CNPJ AS ID_ESTABELECIMENTO, 
    CONCAT(CONCAT(TEM_CNPJ,'-'),TAC_COD_CNAE) AS ID_realizacao_atividade_economica
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent, APL_REDESIM.TAB_ATIVIDADE_ECONOMICA@dl_cent cnae
    WHERE cnae.TAC_TCC_ID = TEM_TCC_ID;

  CREATE INDEX "REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA_INDEX1" ON "REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA" ("ID_ESTABELECIMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA_INDEX2" ON "REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA" ("ID_REALIZACAO_ATIVIDADE_ECONOMICA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_TEM_REALIZACAO_ATIVIDADE_ECONOMICA';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_MATRIZ_MAT
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_MATRIZ_MAT" ("ID_EMPRESA", "ID_ESTABELECIMENTO")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA, TEM_CNPJ AS ID_ESTABELECIMENTO 
  FROM APL_REDESIM.TAB_EMPRESA@DL_CENT jur, APL_REDESIM.TAB_EMPRESA_ENDERECO@DL_CENT 
    WHERE jur.TEM_ID = TEN_TEM_ID AND TEM_CNPJ IN (
        SELECT DISTINCT TCC_CNPJMATRIZ FROM APL_REDESIM.TAB_SOLICITACAO@DL_CENT solicitacao
    );

  CREATE INDEX "REDESIM_TEM_MATRIZ_MAT_INDEX1" ON "REDESIM_TEM_MATRIZ_MAT" ("ID_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_TEM_MATRIZ_MAT_INDEX2" ON "REDESIM_TEM_MATRIZ_MAT" ("ID_ESTABELECIMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_MATRIZ_MAT"  IS 'snapshot table for snapshot REDESIM_TEM_MATRIZ_MAT';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_FILIAL_MAT
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_FILIAL_MAT" ("ID_EMPRESA", "ID_ESTABELECIMENTO")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA, TEM_CNPJ AS ID_ESTABELECIMENTO FROM APL_REDESIM.TAB_EMPRESA@DL_CENT jur, APL_REDESIM.TAB_SOLICITACAO@DL_CENT
    WHERE jur.TEM_ID = TCC_ID AND TCC_FILIAL = 1;

  CREATE INDEX "REDESIM_TEM_FILIAL_MAT_INDEX1" ON "REDESIM_TEM_FILIAL_MAT" ("ID_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_TEM_FILIAL_MAT_INDEX2" ON "REDESIM_TEM_FILIAL_MAT" ("ID_ESTABELECIMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_FILIAL_MAT"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_TEM_FILIAL_MAT';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_TEM_ATIVIDADE_ECONOMICA
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_TEM_ATIVIDADE_ECONOMICA" ("ID_ESTABELECIMENTO", "ID_ATIVIDADE_ECONOMICA")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TEM_CNPJ AS ID_ESTABELECIMENTO, TAC_COD_CNAE AS ID_atividade_economica  
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent, APL_REDESIM.TAB_ATIVIDADE_ECONOMICA@dl_cent cnae
    WHERE cnae.TAC_TCC_ID = TEM_TCC_ID;

  CREATE INDEX "REDESIM_TEM_ATIVIDADE_ECONOMICA_INDEX1" ON "REDESIM_TEM_ATIVIDADE_ECONOMICA" ("ID_ESTABELECIMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_TEM_ATIVIDADE_ECONOMICA_INDEX2" ON "REDESIM_TEM_ATIVIDADE_ECONOMICA" ("ID_ATIVIDADE_ECONOMICA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_TEM_ATIVIDADE_ECONOMICA"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_TEM_ATIVIDADE_ECONOMICA';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_SOCIOS
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_SOCIOS" ("ID", "ID_QUALIFICACAO", "NOME", "CNPJ_CPF", "TIPO")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"   NO INMEMORY 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TSO_ID||'-'||TSO_CPF_CNPJ AS ID,
    TRANSLATE (TGE_NOMBRE_DESCRIPCION, '����Y��������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS ID_qualificacao, 
    TSO_NOME AS nome, 
    TSO_CPF_CNPJ AS cnpj_cpf,
    CASE WHEN TSO_TIPOPESSOA = 1 THEN 'PF' WHEN TSO_TIPOPESSOA = 2 THEN 'PJ' END AS TIPO
    FROM APL_REDESIM.TAB_SOCIOS@DL_CENT , APL_PAR.TAB_GENERICA@DL_CENT 
    WHERE (TSO_SEQTIPQUALIFICACAO = TGE_COD_TIP_TABLA AND (TGE_TIP_TABLA = 34));

  CREATE UNIQUE INDEX "REDESIM_SOCIOS_INDEX1" ON "REDESIM_SOCIOS" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIOS_INDEX2" ON "REDESIM_SOCIOS" ("ID_QUALIFICACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIOS_INDEX3" ON "REDESIM_SOCIOS" ("NOME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIOS_INDEX5" ON "REDESIM_SOCIOS" ("TIPO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIOS_INDEX4" ON "REDESIM_SOCIOS" ("CNPJ_CPF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_SOCIOS"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_SOCIOS';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_SOCIEDADE_COM_PESSOA_FISICA
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("ID", "DATA_ENTRADA_PARTICIPACAO", "VALOR_PARTICIPACAO", "PERCENTUAL_PARTICIPACAO", "ID_QUALIFICACAO", "DATA_SAIDA_PARTICIPACAO", "ID_SOCIO", "ID_EMPRESA")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT 
    REPLACE(CONCAT(CONCAT(CONCAT(CONCAT(TRANSLATE(TGE_NOMBRE_DESCRIPCION, '����Y��������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy'),'-'),SUBSTR(TEM_CNPJ,0,8)),'-'),TSO_CPF_CNPJ),' ','_') AS ID,
    TSO_DTENTRADASOCIEDADE AS data_entrada_participacao, 
    TSO_VALORPARTICIPACAO AS valor_participacao, TSO_PERCPARTICIPACAO AS percentual_participacao,
    TRANSLATE (TGE_NOMBRE_DESCRIPCION, '����Y��������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS ID_qualificacao,
    TSO_DTSAIDASOCIEDADE AS data_saida_participacao, 
    TSO_CPF_CNPJ ID_SOCIO,
    SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA
    FROM APL_REDESIM.TAB_EMPRESA@DL_CENT, APL_REDESIM.TAB_SOCIOS@DL_CENT , APL_PAR.TAB_GENERICA@DL_CENT 
    WHERE TSO_TCC_ID = TEM_TCC_ID AND TSO_TIPOPESSOA = 1 
    AND (TSO_SEQTIPQUALIFICACAO = TGE_COD_TIP_TABLA AND (TGE_TIP_TABLA = 34 OR TGE_TIP_TABLA = 432));

  CREATE INDEX "REDESIM_SOCIEDADE_COM_PESSOA_FISICA_INDEX2" ON "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("DATA_ENTRADA_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_PESSOA_FISICA_INDEX3" ON "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("VALOR_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_PESSOA_FISICA_INDEX4" ON "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("PERCENTUAL_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_PESSOA_FISICA_INDEX5" ON "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("ID_QUALIFICACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_PESSOA_FISICA_INDEX6" ON "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("DATA_SAIDA_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_PESSOA_FISICA_INDEX7" ON "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("ID_SOCIO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_PESSOA_FISICA_INDEX8" ON "REDESIM_SOCIEDADE_COM_PESSOA_FISICA" ("ID_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_SOCIEDADE_COM_PESSOA_FISICA"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_SOCIEDADE_COM_PESSOA_FISICA';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_SOCIEDADE_COM_HOLDING
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_SOCIEDADE_COM_HOLDING" ("ID", "DATA_ENTRADA_PARTICIPACAO", "VALOR_PARTICIPACAO", "PERCENTUAL_PARTICIPACAO", "ID_QUALIFICACAO", "DATA_SAIDA_PARTICIPACAO", "ID_SOCIO", "ID_EMPRESA")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT 
    CONCAT(CONCAT(CONCAT(CONCAT(TRANSLATE(TGE_NOMBRE_DESCRIPCION, '����Y��������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy'),'-'),SUBSTR(TEM_CNPJ,0,8)),'-'),TSO_CPF_CNPJ) AS ID,
    TSO_DTENTRADASOCIEDADE AS data_entrada_participacao, 
    TSO_VALORPARTICIPACAO AS valor_participacao, TSO_PERCPARTICIPACAO AS percentual_participacao, 
    TRANSLATE (TGE_NOMBRE_DESCRIPCION, '����Y��������������������������������������������������','SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy') AS ID_qualificacao, 
    TSO_DTSAIDASOCIEDADE AS data_saida_participacao, 
    TSO_CPF_CNPJ ID_SOCIO,
    SUBSTR(TEM_CNPJ,0,8) AS ID_EMPRESA
    FROM APL_REDESIM.TAB_EMPRESA@DL_CENT, APL_REDESIM.TAB_SOCIOS@DL_CENT , APL_PAR.TAB_GENERICA@DL_CENT 
    WHERE TSO_TCC_ID = TEM_TCC_ID AND TSO_TIPOPESSOA = 2
    AND (TSO_SEQTIPQUALIFICACAO = TGE_COD_TIP_TABLA AND (TGE_TIP_TABLA = 34 OR TGE_TIP_TABLA = 432));

  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX1" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX2" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("DATA_ENTRADA_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX3" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("VALOR_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX4" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("PERCENTUAL_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX5" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("ID_QUALIFICACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX6" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("DATA_SAIDA_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX7" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("ID_SOCIO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SOCIEDADE_COM_HOLDING_INDEX8" ON "REDESIM_SOCIEDADE_COM_HOLDING" ("ID_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_SOCIEDADE_COM_HOLDING"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_SOCIEDADE_COM_HOLDING';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_SITUACAO_CADASTRAL
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_SITUACAO_CADASTRAL" ("ID", "CODIGO_SITUACAO", "SITUACAO", "DATA_SITUACAO")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT CONCAT(CONCAT(CONCAT(CONCAT(CASE TEM_SITUACAO WHEN '00' THEN 'ATIVA' 
                    WHEN '02' THEN 'CANCELADA_ART.60_LEI_8934/94'
                    WHEN '03' THEN 'EXTINTA'
                    WHEN '04' THEN 'CONVERTIDA_SOC._CIVIL-SIMPLES'
                    WHEN '06' THEN 'TRANSFERIDA_PARA_OUTRA_UF'
                    WHEN '07' THEN 'FALIDA'
                    WHEN '08' THEN 'CANCELADA'
                    WHEN '09' THEN 'REGISTRO_ATIVO_PROVISORIO'
                    WHEN '10' THEN 'CANCELADA-MEI'
                END,'-'),TEM_CNPJ),'-'), TO_CHAR(TEM_DTCONSTITUICAO,'YYYY_MM_DD')) as ID, 
    TEM_SITUACAO as codigo_situacao,
    CASE TEM_SITUACAO WHEN '00' THEN 'ATIVA' 
                    WHEN '02' THEN 'CANCELADA_ART.60_LEI_8934/94'
                    WHEN '03' THEN 'EXTINTA'
                    WHEN '04' THEN 'CONVERTIDA_SOC._CIVIL-SIMPLES'
                    WHEN '06' THEN 'TRANSFERIDA_PARA_OUTRA_UF'
                    WHEN '07' THEN 'FALIDA'
                    WHEN '08' THEN 'CANCELADA'
                    WHEN '09' THEN 'REGISTRO_ATIVO_PROVISORIO'
                    WHEN '10' THEN 'CANCELADA-MEI'
                END AS SITUACAO,
    TO_CHAR(TEM_DTCONSTITUICAO,'YYYY_MM_DD') as data_situacao
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent;

  CREATE INDEX "REDESIM_SITUACAO_CADASTRAL_INDEX2" ON "REDESIM_SITUACAO_CADASTRAL" ("CODIGO_SITUACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SITUACAO_CADASTRAL_INDEX3" ON "REDESIM_SITUACAO_CADASTRAL" ("SITUACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_SITUACAO_CADASTRAL_INDEX4" ON "REDESIM_SITUACAO_CADASTRAL" ("DATA_SITUACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_SITUACAO_CADASTRAL"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_SITUACAO_CADASTRAL';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_REPRESENTANTE_PJ_MAT
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_REPRESENTANTE_PJ_MAT" ("ID", "NOME", "EMAIL", "TELEFONE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"   NO INMEMORY 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT 
        TSO_CPF_CNPJ AS ID,
        TEM_REPLEGALNOME AS nome,
        TEM_REPLEGALEMAIL AS email,
        CONCAT(TEM_REPLEGALDDD, TEM_REPLEGALFONE) AS telefone
    FROM APL_REDESIM.TAB_EMPRESA@DL_CENT, APL_REDESIM.TAB_SOCIOS@DL_CENT 
    WHERE TEM_TCC_ID = TSO_TCC_ID
    AND TSO_TIPOPESSOA = 2
    AND UTL_MATCH.JARO_WINKLER(REGEXP_REPLACE(TEM_REPLEGALNOME,'[^[:alnum:]'' '']', ''),REGEXP_REPLACE(TSO_NOME,'[^[:alnum:]'' '']', '')) > 0.80
    AND
    TSO_ID in 
    (
        SELECT MAX(TSO_ID)
        FROM APL_REDESIM.TAB_SOCIOS@DL_CENT 
        GROUP BY TSO_CPF_CNPJ
    );

  CREATE INDEX "REDESIM_REPRESENTANTE_PJ_MAT_INDEX1" ON "REDESIM_REPRESENTANTE_PJ_MAT" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_REPRESENTANTE_PJ_MAT"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_REPRESENTANTE_PJ_MAT';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_REPRESENTANTE_PF_MAT
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_REPRESENTANTE_PF_MAT" ("ID", "NOME", "EMAIL", "TELEFONE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT 
        TSO_CPF_CNPJ AS ID,
        TEM_REPLEGALNOME AS nome,
        TEM_REPLEGALEMAIL AS email,
        CONCAT(TEM_REPLEGALDDD, TEM_REPLEGALFONE) AS telefone
    FROM APL_REDESIM.TAB_EMPRESA@dl_cent, APL_REDESIM.TAB_SOCIOS@DL_CENT
    WHERE TEM_TCC_ID = TSO_TCC_ID
    AND TSO_TIPOPESSOA = 1
    AND UTL_MATCH.JARO_WINKLER(REGEXP_REPLACE(TEM_REPLEGALNOME,'[^[:alnum:]'' '']', ''),REGEXP_REPLACE(TSO_NOME,'[^[:alnum:]'' '']', '')) > 0.80
    AND
    TSO_ID in 
    (
        SELECT MAX(TSO_ID)
        FROM APL_REDESIM.TAB_SOCIOS@DL_CENT
        GROUP BY TSO_CPF_CNPJ
    );

  CREATE INDEX "REDESIM_REPRESENTANTE_PF_MAT_INDEX1" ON "REDESIM_REPRESENTANTE_PF_MAT" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_REPRESENTANTE_PF_MAT"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_REPRESENTANTE_PF_MAT';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA" ("ID", "DATA_INICIO_ATIVIDADE", "DATA_TERMINO_ATIVIDADE", "ID_ATIVIDADE_ECONOMICA")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_D_UFC_SEM" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TEM_ID||'-'||CONCAT(CONCAT(TEM_CNPJ,'-'),TAC_COD_CNAE) AS ID,  
    TEM_DTINICIOATIVIDADE AS data_inicio_atividade, 
    TEM_DTTERMINOATIVIDADE AS data_termino_atividade,
    TAC_COD_CNAE ID_atividade_economica
    FROM APL_REDESIM.TAB_ATIVIDADE_ECONOMICA@dl_cent cnae, APL_REDESIM.TAB_EMPRESA@dl_cent 
    WHERE TAC_TCC_ID = TEM_TCC_ID;

  CREATE INDEX "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA_INDEX2" ON "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA" ("DATA_INICIO_ATIVIDADE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_D_UFC_SEM" ;
  CREATE INDEX "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA_INDEX3" ON "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA" ("DATA_TERMINO_ATIVIDADE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_D_UFC_SEM" ;
  CREATE INDEX "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA_INDEX4" ON "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA" ("ID_ATIVIDADE_ECONOMICA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_I_UFC_SEM" ;
  CREATE UNIQUE INDEX "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA_INDEX1" ON "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_I_UFC_SEM" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_REALIZACAO_ATIVIDADE_ECONOMICA';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_PESSOA
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_PESSOA" ("ID", "NOME", "IDENTIDADE", "CPF", "ESTADO_CIVIL", "DATA_NASCIMENTO", "SEXO", "ID_MAE", "TIPO_PESSOA", "ID_EMANCIPADO", "ID_DOCUMENTO", "ID_PAI", "ID_REGISTRO_CARTORIO", "ANO_REG_CARTORIO", "NUM_CARTORIO", "ID_NACIONALIDADE", "ID_CIDADE_NATURALIDADE", "ID_UF_NATURALIDADE", "NOME_COMARCA", "REGIME_BENS", "PRAZO_INDETERMINADO", "CARGO_ADMINISTRADOR", "CPF_CNPJ_REPRESENTADO", "FAX", "TELEFONE", "EMAIL", "DDD_TELEFONE", "DDD_FAX", "ID_TIPO_CONTRIBUICAO", "ID_ENDERECO")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT 
    TSO_CPF_CNPJ ID,
    TSO_NOME AS nome, 
    TSO_IDENTIDADE AS identidade, 
    TSO_CPF_CNPJ AS cpf, 
    TSO_ESTADOCIVIL AS estado_civil, 
    TSO_DTNASCIMENTO AS data_nascimento, 
    TSO_SEXO AS sexo, 
    TSO_NOMEMAE AS ID_mae, 
    TSO_TIPOPESSOA AS tipo_pessoa, 
    TSO_EMANCIPADO AS ID_emancipado, 
    CASE TSO_TIPODOCUMENTO 
        WHEN 1 THEN 'RG'
        WHEN 2 THEN 'CARTEIRA_DE_TRABALHO_E_PREVIDENCIA_SOCIAL'
        WHEN 3 THEN 'CERTIFICADO_DE_RESERVISTA'
        WHEN 4 THEN 'PASSAPORTE'
        WHEN 5 THEN 'CARTEIRA_DE_IDENTIDADE_PROFISSIONAL'
        WHEN 6 THEN 'CNH'
        WHEN 7 THEN 'CEDULA_DE_IDENTIDADE_ESTRANGEIRO'
        END AS ID_documento, 
    TSO_NOMEPAI as ID_pai,
    TSO_REGCARTORIO as ID_registro_cartorio,
    TSO_ANOREGCARTORIO as ano_reg_cartorio,
    TSO_NUMCARTORIO as num_cartorio,
    TSO_NACIONALIDADE as ID_nacionalidade,
    TSO_MUNICIPIONATURALIDADE as ID_cidade_naturalidade,
    TSO_UFNATURALIDADE as ID_uf_naturalidade,
    TSO_NOMECOMARCA as nome_comarca,
    TSO_REGIMEBENS as regime_bens, 
    TSO_PRAZOINDETERMINADO as prazo_indeterminado,
    TSO_CARGOADMINISTRADOR as cargo_administrador,
    TSO_CPFCNPJREPRESENTADO as cpf_cnpj_representado,
    TSO_FAX as fax,
    TSO_TELEFONE as telefone, 
    TSO_EMAIL as email,
    TSO_DDDTEL as ddd_telefone,
    CASE WHEN TSO_DDDFAX IS NULL THEN 0 ELSE TSO_DDDFAX END as ddd_fax,
    CASE TCC_CTBICMS WHEN 1 THEN 'CONTRIBUINTE_ICMS'
                    ELSE 'NAO_CONTRIBUINTE_DO_ICMS'
                END as ID_tipo_contribuicao,
    TSO_TCC_ID AS ID_endereco
    FROM APL_REDESIM.TAB_SOCIOS@DL_CENT , APL_REDESIM.TAB_SOLICITACAO@DL_CENT 
    WHERE TSO_TCC_ID = TCC_ID AND TSO_TIPOPESSOA = 1;

   COMMENT ON MATERIALIZED VIEW "REDESIM_PESSOA"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_PESSOA';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_NAO_CONTRIBUINTE_MAT
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_NAO_CONTRIBUINTE_MAT" ("CNPJ_CPF", "NOME", "INSCRICAO_ESTADUAL", "FONTE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"   NO INMEMORY 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT ID AS CNPJ_CPF, CASE WHEN NOME_FANTASIA IS NOT NULL THEN NOME_FANTASIA ELSE RAZAO_SOCIAL END AS NOME,
    INSCRICAO_ESTADUAL AS INSCRICAO_ESTADUAL,
    'REDESIM' AS FONTE
    FROM
    REDESIM_ESTABELECIMENTO est
    WHERE
    ID_tipo_contribuicao = 'NAO_CONTRIBUINTE_DO_ICMS'
    AND ID > 0
    UNION
    SELECT DISTINCT ID AS CNPJ_CPF, NOME,
    0 AS INSCRICAO_ESTADUAL,
    'REDESIM' AS FONTE
    FROM
    REDESIM_PESSOA pessoa
    WHERE
    ID_tipo_contribuicao = 'NAO_CONTRIBUINTE_DO_ICMS'
    AND ID > 0;

  CREATE INDEX "REDESIM_NAO_CONTRIBUINTE_MAT_INDEX1" ON "REDESIM_NAO_CONTRIBUINTE_MAT" ("CNPJ_CPF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_NAO_CONTRIBUINTE_MAT_INDEX2" ON "REDESIM_NAO_CONTRIBUINTE_MAT" ("NOME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_NAO_CONTRIBUINTE_MAT_INDEX3" ON "REDESIM_NAO_CONTRIBUINTE_MAT" ("INSCRICAO_ESTADUAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_NAO_CONTRIBUINTE_MAT_INDEX4" ON "REDESIM_NAO_CONTRIBUINTE_MAT" ("FONTE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_NAO_CONTRIBUINTE_MAT"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_NAO_CONTRIBUINTE_MAT';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_EVENTO
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_EVENTO" ("ID", "ID_SOLICITACAO", "DESCRICAO_EVENTO", "IDENTIFICACAO_EVENTO")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT DISTINCT TEV_EVENTO AS ID, TEV_TCC_ID AS ID_SOLICITACAO,
                CASE TEV_EVENTO  
                WHEN 101 THEN 'Inscri��o de primeiro estabelecimento'
                WHEN 102 THEN 'Inscri��o dos demais estabelecimentos'
                WHEN 103 THEN 'Inscri��o de estabelecimento filial de empresa brasileira no exterior'
                WHEN 105 THEN 'Inscri��o de embaixada/consulado/representa��es do governo no exterior'
                WHEN 106 THEN 'Inscri��o de miss�es dipl./repart. consul./repres. de �rg�os internacionais'
                WHEN 109 THEN 'Inscri��o de incorpora��o imobili�ria (patrim�nio de afeta��o)   '
                WHEN 110 THEN 'Inscri��o de produtor rural (primeiro estabelecimento)   '
                WHEN 111 THEN 'Inscri��o de produtor rural (demais estabelecimentos)'
                WHEN 112 THEN 'Altera��o de Produtor Rural'
                WHEN 115 THEN 'Pedido de baixa de Produtor Rural'
                WHEN 202 THEN 'Altera��o do Representante da Pessoa Jur�dica'
                WHEN 203 THEN 'Exclus�o do t�tulo do estabelecimento (nome de fantasia)'
                WHEN 204 THEN 'Cis�o parcial (espec�fico para a sucedida)'
                WHEN 206 THEN 'Desclassifica��o como estabelecimento unificador'
                WHEN 209 THEN 'Altera��o de endere�o entre munic�pios no mesmo estado'
                WHEN 210 THEN 'Altera��o de endere�o entre estados'
                WHEN 211 THEN 'Altera��o de endere�o no mesmo munic�pio'
                WHEN 214 THEN 'Altera��o de telefone (DDD/telefone)'
                WHEN 215 THEN 'Exclus�o de telefone (DDD/telefone) - Espec�fico para produtor rural'
                WHEN 216 THEN 'Altera��o de fax (DDD/fax)'
                WHEN 217 THEN 'Exclus�o de fax (DDD/fax)'
                WHEN 218 THEN 'Altera��o de correio eletr�nico'
                WHEN 219 THEN 'Exclus�o de correio eletr�nico'
                WHEN 220 THEN 'Altera��o de nome empresarial (firma ou denomina��o)'
                WHEN 221 THEN 'Altera��o do t�tulo do estabelecimento (nome de fantasia)'
                WHEN 222 THEN 'Enquadramento / Reenquadramento / Desenquadramento de Porte de Empresa'
                WHEN 224 THEN 'Altera��o do contabilista respons�vel pela organiza��o cont�bil perante o CRC'
                WHEN 225 THEN 'Altera��o da natureza jur�dica'
                WHEN 230 THEN 'Altera��o da qualifica��o da pessoa f�sica respons�vel perante o CNPJ'
                WHEN 232 THEN 'Altera��o do contabilista ou da empresa de contabilidade'
                WHEN 233 THEN 'Exclus�o do contabilista ou da empresa de contabilidade'
                WHEN 235 THEN 'Altera��o do Administrador de Empresas (fundos/clubes e equiparadas)'
                WHEN 237 THEN 'Indica��o de preposto'
                WHEN 238 THEN 'Substitui��o de preposto'
                WHEN 239 THEN 'Exclus�o de preposto'
                WHEN 240 THEN 'Ren�ncia de preposto'
                WHEN 241 THEN 'Equipara��o, por op��o, a estabelecimento industrial'
                WHEN 242 THEN 'Desist�ncia da equipara��o, por op��o, a estabelecimento industrial'
                WHEN 243 THEN 'Altera��o de endere�o de pessoa jur�dica domiciliada no exterior'
                WHEN 244 THEN 'Altera��o de atividades econ�micas (principal e secund�rias)'
                WHEN 245 THEN '(descontinuado na vers�o 2.0)'
                WHEN 246 THEN 'Indica��o de Estabelecimento Matriz (criado na vers�o 2.0)'
                WHEN 247 THEN 'Altera��o de capital social e/ou Quadro Societ�rio'
                WHEN 248 THEN 'Altera��o do tipo de unidade'
                WHEN 249 THEN 'Altera��o da forma de atua��o'
                WHEN 250 THEN 'Altera��o do v�nculo com o im�vel'
                WHEN 251 THEN 'Altera��o da data de validade da inscri��o'
                WHEN 252 THEN 'Altera��o do NIRF'
                WHEN 253 THEN 'Altera��o do propriet�rio'
                WHEN 254 THEN 'Altera��o do nome empresarial (espec�fico para sociedade em comum de produtor rural)'
                WHEN 256 THEN 'Altera��o da inscri��o estadual anterior'
                WHEN 257 THEN 'Altera��o do n�mero de registro no �rg�o competente (criado na vers�o 2.0)'
                WHEN 258 THEN 'Atualiza��o de dados anteriores do contribuinte (criado na vers�o 2.0)'
                WHEN 260 THEN 'Altera��o / Inclus�o de Ente Federativo Respons�vel'
                WHEN 262 THEN 'Altera��o da Depend�ncia Or�ament�ria'
                WHEN 403 THEN 'In�cio de liquida��o'
                WHEN 405 THEN 'Decreta��o de fal�ncia'
                WHEN 406 THEN 'Reabilita��o de fal�ncia'
                WHEN 407 THEN 'Esp�lio de empres�rio/empresa individual imobili�ria'
                WHEN 408 THEN 'T�rmino de liquida��o'
                WHEN 410 THEN 'In�cio de interven��o em institui��o financeira'
                WHEN 411 THEN 'T�rmino de interven��o em institui��o financeira'
                WHEN 412 THEN 'Interrup��o tempor�ria de atividades'
                WHEN 413 THEN 'Rein�cio das atividades interrompidas temporariamente'
                WHEN 414 THEN 'Restabelecimento de matriz (Reativa��o)'
                WHEN 415 THEN 'Restabelecimento de filial'
                WHEN 517 THEN 'Pedido de baixa'
                WHEN 550 THEN 'Documento do Corpo de Bombeiros'
                WHEN 601 THEN 'Inscri��o no Estado'
                WHEN 602 THEN 'Inscri��o de substituto tribut�rio no Estado'
                WHEN 603 THEN 'Reativa��o da inscri��o no Estado'
                WHEN 604 THEN 'Pedido de baixa exclusivamente no Estado'
                WHEN 605 THEN 'Altera��o do endere�o de correspond�ncia'
                WHEN 606 THEN 'Inscri��o no Estado para estabelecimento que est� localizado em outro Estado, exceto Subst. Trib.'
                WHEN 607 THEN 'Pedido de baixa de substituto tribut�rio'
                WHEN 608 THEN 'Altera��o de substituto tribut�rio no Estado'
                WHEN 609 THEN 'Inscri��o de Gr�fica de outra UF'
                WHEN 610 THEN 'Altera��o de Gr�fica de outra UF'
                WHEN 611 THEN 'Pedido de baixa de Gr�fica de outra UF'
                WHEN 612 THEN 'Inscri��o de Plataformas Continentais/Petrol�feras'
                WHEN 613 THEN 'Altera��o de Plataformas Continentais/Petrol�feras'
                WHEN 614 THEN 'Pedido de baixa de Plataformas Continentais/Petrol�feras'
                WHEN 624 THEN 'Atualiza��o de coordenadas geogr�ficas'
                WHEN 650 THEN 'Certid�o Simplificada'
                WHEN 651 THEN 'Certidao Espec�fica Pessoa F�sica'
                WHEN 652 THEN 'Certid�o Espec�fica Pessoa Jur�dica'
                WHEN 653 THEN 'Certid�o Espec�fica Historico Arquivado  '
                WHEN 654 THEN 'Certid�o Espec�fica a Definir'
                WHEN 655 THEN 'Certid�o Inteiro Teor'
                WHEN 690 THEN 'Procura��o'
                WHEN 691 THEN 'Emancipa��o'
                WHEN 692 THEN 'Rerratifica��o'
                WHEN 693 THEN 'Consolida��o'
                WHEN 694 THEN 'Altera��o de dados do Empres�rio'    
                WHEN 695 THEN 'Altera��o de dados de MEI'   
                WHEN 696 THEN 'Altera��o de Cl�usulas Particulares' 
                WHEN 700 THEN 'Prote��o de Nome Empresarial'    
                WHEN 701 THEN 'Altera��o de Prote��o de Nome Empresarial'       
                WHEN 702 THEN 'Cancelamento de Prote��o de Nome Empresarial'    
                WHEN 703 THEN 'Outros Documentos de Interesse da Empresa/Empres�rio'    
                WHEN 704 THEN 'Registro de Balan�o' 
                WHEN 705 THEN 'Estatuto Social' 
                WHEN 706 THEN 'Carta de Ren�ncia'   
                WHEN 707 THEN 'Revoga��o de Procura��o' 
                WHEN 708 THEN 'ARQUIVAMENTO DE PUBLICA��ES DE ATOS DE SOCIEDADE'    
                WHEN 709 THEN 'ANOTA��O DE PUBLICA��ES DE ATOS DE SOCIEDADE'    
                WHEN 710 THEN 'Licen�a Ambiental Estadual'  
                WHEN 711 THEN 'DELEGA��O DE GER�NCIA'   
                WHEN 712 THEN 'CANCELAMENTO DE DELEGA��O DE GER�NCIA'   
                WHEN 713 THEN 'COMUNICA��O DE EXTRAVIO DE INSTRUMENTO DE ESCRITURA��O'  
                WHEN 714 THEN 'COMUNICA��O DE FUNCIONAMENTO'    
                WHEN 715 THEN 'DELIBERA��O DE DIRETORIA'    
                WHEN 716 THEN 'DELIBERA��O DE GER�NCIA' 
                WHEN 717 THEN 'REGULAMENTO INTERNO DE ARMAZ�M GERAL'    
                WHEN 718 THEN 'DECLARA��ES DE ARMAZ�M GERAL/TRAPICHEIRO'    
                WHEN 719 THEN 'TARIFAS DE ARMAZ�M GERAL/TRAPICHEIRO'    
                WHEN 720 THEN 'NOMEA��O DE GERENTE POR REPRESENTANTE OU ASSISTENTE' 
                WHEN 721 THEN 'DESTITUI��O DE GERENTE POR REPRESENTANTE OU ASSISTENTE'  
                WHEN 722 THEN 'DECLARA��O ANTENUPCIAL'  
                WHEN 723 THEN 'PACTO ANTENUPCIAL'   
                WHEN 724 THEN 'T�TULO DE DOA��O DE BENS CLAUSULADOS DE INCOMUNICABILIDADE OU INALIENABILIDADE'  
                WHEN 725 THEN 'T�TULO DE HERAN�A DE BENS CLAUSULADOS DE INCOMUNICABILIDADE OU INALIENABILIDADE' 
                WHEN 726 THEN 'T�TULO DE LEGADO DE BENS CLAUSULADOS DE INCOMUNICABILIDADE OU INALIENABILIDADE'  
                WHEN 727 THEN 'SENTEN�A DE DECRETA��O OU DE HOMOLOGA��O DE SEPARA��O JUDICIAL'  
                WHEN 728 THEN 'SENTEN�A DE HOMOLOGA��O DO ATO DE RECONCILIA��O' 
                WHEN 729 THEN 'CONTRATO DE ALIENA��O, USUFRUTO OU ARRENDAMENTO DE ESTABELECIMENTO'  
                WHEN 730 THEN 'ATA DE ASSEMBLEIA DOS DEBENTURISTAS' 
                WHEN 731 THEN 'ATA DE ASSEMBLEIA ESPECIAL'
                WHEN 732 THEN 'ATA DE REUNI�O/ASSEMBLEIA DE S�CIOS'
                WHEN 733 THEN 'CARTA DE EXCLUSIVIDADE'
                WHEN 734 THEN 'ARROLAMENTO DE BENS/DIREITOS'
                WHEN 735 THEN 'ANOTA��O DE AJUIZAMENTO DE EXECU��O-CPC ART.615-A'
                WHEN 736 THEN 'CANCELAMENTO DE ANOTA��O DE AJUIZAMENTO DE EXECU��O-CPC ART. 615-A'
                WHEN 737 THEN 'ATA DE ASSEMBLEIA GERAL ORDIN�RIA'
                WHEN 738 THEN 'ATA DE ASSEMBLEIA GERAL EXTRAORDIN�RIA'
                WHEN 739 THEN 'ATA DE ASSEMBLEIA GERAL ORDIN�RIA E EXTRAORDIN�RIA'
                WHEN 740 THEN 'ATA DE REUNI�O DA DIRETORIA'
                WHEN 741 THEN 'ATA DE REUNI�O DO CONSELHO DE ADMINISTRA��O'
                WHEN 742 THEN 'ATA DE REUNI�O DO CONSELHO FISCAL'
                WHEN 750 THEN 'Licen�a Sanit�ria Estadual'
                WHEN 790 THEN 'Solicitar Alvar� de Localiza��o e Funcionamento'
                WHEN 791 THEN 'Solicitar Inscri��o Municipal'   
                WHEN 792 THEN 'Solicitar Inscri��o Estadual'
                WHEN 793 THEN 'Solicitar Documentos do Corpo de Bombeiros Militar'
                WHEN 801 THEN 'Inscri��o no munic�pio'
                WHEN 802 THEN 'Inscri��o municipal vinculada a CNPJ j� cadastrado para outro estabelecimento'
                WHEN 803 THEN 'Inscri��o para estabelecimento sediado em outro munic�pio'
                WHEN 804 THEN 'Pedido de baixa exclusivamente no munic�pio'
                WHEN 805 THEN 'Corre��o do n�mero de inscri��o imobili�ria'
                WHEN 806 THEN 'Altera��o de �rea'
                WHEN 807 THEN 'Desdobramento de atividades econ�micas (principal e secund�rias)'
                WHEN 812 THEN 'Altera��o do endere�o do estabelecimento vinculado'
                WHEN 813 THEN 'Altera��o do telefone do estabelecimento vinculado'
                WHEN 815 THEN 'Pedido de baixa de estabelecimento sediado em outro munic�pio'
                WHEN 880 THEN 'Alvar� de Localiza��o'
                WHEN 881 THEN 'Licen�a Sanit�ria Municipal  '
                WHEN 882 THEN 'Licen�a Ambiental Municipal'
                WHEN 883 THEN 'Baixa Municipal'
                WHEN 1100 THEN 'Renova��o'
                WHEN 1101 THEN 'Licenciamento via portal'
                END AS descricao_evento,
                CONCAT('EVENTO-',TEV_EVENTO) identificacao_evento
                FROM APL_REDESIM.TAB_EVENTO@dl_cent;

  CREATE INDEX "REDESIM_EVENTO_INDEX1" ON "REDESIM_EVENTO" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_EVENTO_INDEX2" ON "REDESIM_EVENTO" ("ID_SOLICITACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_EVENTO_INDEX3" ON "REDESIM_EVENTO" ("DESCRICAO_EVENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_EVENTO_INDEX4" ON "REDESIM_EVENTO" ("IDENTIFICACAO_EVENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_EVENTO"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_EVENTO';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_ESTABELECIMENTO
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_ESTABELECIMENTO" ("ID", "RAZAO_SOCIAL", "NOME_FANTASIA", "AREA", "INSCRICAO_IMOBILIARIA", "NIRF", "INCRA", "METRAGEM", "FAX", "TELEFONE", "SITE", "EMAIL", "FAX_COMPLETO", "TELEFONE_COMPLETO", "ID_TIPO_ESTABELECIMENTO", "INSCRICAO_ESTADUAL", "INSCRICAO_MUNICIPAL", "ID_TIPO_CONTRIBUICAO", "ID_ENDERECO", "ID_TIPO_PROPRIEDADE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"   NO INMEMORY 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT TEM_CNPJ AS ID, 
    empresa.TEM_RAZAOSOCIAL AS razao_social,
    TEM_NOMEFANTASIA as nome_fantasia,
    CASE WHEN TEN_AREAUTILIZADA IS NULL THEN 0 ELSE TEN_AREAUTILIZADA
                END as area,
    CASE WHEN TEN_INSCRICAOIMOBILIARIA IS NULL THEN '' ELSE TEN_INSCRICAOIMOBILIARIA
                    END as inscricao_imobiliaria,
    CASE WHEN TEN_NIRF IS NULL THEN '' ELSE TEN_NIRF
                    END as nirf,
    CASE WHEN TEN_INCRA IS NULL THEN '' ELSE TEN_INCRA
                    END as incra,        
    CASE WHEN TEN_METRAGEM IS NULL THEN 0 ELSE TEN_METRAGEM
                    END as metragem,
    CASE WHEN TEM_FAX IS NULL THEN 0 ELSE TEM_FAX
                    END as fax,
    CASE WHEN TEM_TELEFONE IS NULL THEN 0 ELSE TEM_TELEFONE
                    END as telefone,
    CASE WHEN TEM_SITIO IS NULL THEN '' ELSE TEM_SITIO
                    END as site,
    CASE WHEN TEN_EMAIL IS NULL THEN '' ELSE TEN_EMAIL
                    END as email,
    CONCAT(CONCAT(TEM_DDDFAX,'-'),TEM_FAX) AS fax_completo,
    CONCAT(CONCAT(TEM_DDDTEL,'-'),TEM_TELEFONE) AS telefone_completo,
    CASE TEM_TIPOUNIDADE
        WHEN 1 THEN 'MATRIZ'
        WHEN 2 THEN 'FILIAL'
        WHEN 3 THEN 'DEPOSITO'
        WHEN 4 THEN 'OUTROS'
        WHEN 5 THEN 'PRINCIPAL'
    END AS ID_tipo_estabelecimento,     
    CASE WHEN TCC_RUC IS NULL THEN 0 ELSE TCC_RUC
                END as inscricao_estadual,
    CASE WHEN TEM_INSCRICAOMUNICIPAL IS NULL THEN 0 ELSE TEM_INSCRICAOMUNICIPAL
                END as inscricao_municipal,
    CASE TCC_CTBICMS WHEN 1 THEN 'CONTRIBUINTE_ICMS'
                    ELSE 'NAO_CONTRIBUINTE_DO_ICMS'
                END as ID_tipo_contribuicao,
    TEN_TEM_ID as ID_endereco,
    CASE TEN_TIPOIMOVEL  
                WHEN 1 THEN 'PROPRIO'
                WHEN 2 THEN 'CEDIDO'
                WHEN 3 THEN 'ALUGADO'
                WHEN 4 THEN 'COMODATO'
                WHEN 5 THEN 'CONDOMINIO'
                WHEN 6 THEN 'OCUPANTE'
                WHEN 7 THEN 'ESPOLIO'
                WHEN 8 THEN 'PARCERIA'
                WHEN 9 THEN 'ARRENDADO'
                WHEN 10 THEN 'USUFRUTO'
                WHEN 11 THEN 'DOADO'
                ELSE 'OUTRO'
                END as ID_tipo_propriedade     
    FROM APL_REDESIM.TAB_EMPRESA_ENDERECO@DL_CENT est, APL_REDESIM.TAB_EMPRESA@DL_CENT empresa, APL_REDESIM.TAB_SOLICITACAO@DL_CENT sol
    WHERE empresa.TEM_ID = est.TEN_TEM_ID AND (TEN_TEM_ID, TEM_CNPJ) = ANY ( 
        SELECT MAX(TEM_ID), TEM_CNPJ FROM APL_REDESIM.TAB_EMPRESA@DL_CENT GROUP BY(TEM_CNPJ) 
    ) AND empresa.TEM_TCC_ID = sol.TCC_ID;

  CREATE UNIQUE INDEX "REDESIM_ESTABELECIMENTO_INDEX1" ON "REDESIM_ESTABELECIMENTO" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX10" ON "REDESIM_ESTABELECIMENTO" ("TELEFONE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX11" ON "REDESIM_ESTABELECIMENTO" ("SITE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX12" ON "REDESIM_ESTABELECIMENTO" ("EMAIL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX13" ON "REDESIM_ESTABELECIMENTO" ("FAX_COMPLETO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX14" ON "REDESIM_ESTABELECIMENTO" ("TELEFONE_COMPLETO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX15" ON "REDESIM_ESTABELECIMENTO" ("ID_TIPO_ESTABELECIMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX16" ON "REDESIM_ESTABELECIMENTO" ("INSCRICAO_ESTADUAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX17" ON "REDESIM_ESTABELECIMENTO" ("INSCRICAO_MUNICIPAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX18" ON "REDESIM_ESTABELECIMENTO" ("ID_TIPO_CONTRIBUICAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX19" ON "REDESIM_ESTABELECIMENTO" ("ID_ENDERECO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX2" ON "REDESIM_ESTABELECIMENTO" ("RAZAO_SOCIAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX20" ON "REDESIM_ESTABELECIMENTO" ("ID_TIPO_PROPRIEDADE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX3" ON "REDESIM_ESTABELECIMENTO" ("NOME_FANTASIA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX4" ON "REDESIM_ESTABELECIMENTO" ("AREA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX5" ON "REDESIM_ESTABELECIMENTO" ("INSCRICAO_IMOBILIARIA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX6" ON "REDESIM_ESTABELECIMENTO" ("NIRF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX7" ON "REDESIM_ESTABELECIMENTO" ("INCRA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX8" ON "REDESIM_ESTABELECIMENTO" ("METRAGEM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX9" ON "REDESIM_ESTABELECIMENTO" ("FAX") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ESTABELECIMENTO_INDEX21" ON "REDESIM_ESTABELECIMENTO" ("NOME_FANTASIA", "ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_ESTABELECIMENTO"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_ESTABELECIMENTO';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_CONTADOR
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_CONTADOR" ("ID", "DATA_ENTRADA_PARTICIPACAO", "VALOR_PARTICIPACAO", "PERCENTUAL_PARTICIPACAO", "ID_QUALIFICACAO", "DATA_SAIDA_PARTICIPACAO", "ID_SOCIO", "ID_EMPRESA")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT "ID","DATA_ENTRADA_PARTICIPACAO","VALOR_PARTICIPACAO","PERCENTUAL_PARTICIPACAO","ID_QUALIFICACAO","DATA_SAIDA_PARTICIPACAO","ID_SOCIO","ID_EMPRESA" FROM "REDESIM_SOCIEDADE_COM_PESSOA_FISICA"
    WHERE ID_QUALIFICACAO LIKE '%CONT%';

  CREATE INDEX "REDESIM_CONTADOR_INDEX2" ON "REDESIM_CONTADOR" ("DATA_ENTRADA_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_CONTADOR_INDEX1" ON "REDESIM_CONTADOR" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_CONTADOR_INDEX3" ON "REDESIM_CONTADOR" ("VALOR_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_CONTADOR_INDEX4" ON "REDESIM_CONTADOR" ("PERCENTUAL_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_CONTADOR_INDEX5" ON "REDESIM_CONTADOR" ("ID_QUALIFICACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_CONTADOR_INDEX6" ON "REDESIM_CONTADOR" ("DATA_SAIDA_PARTICIPACAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_CONTADOR_INDEX7" ON "REDESIM_CONTADOR" ("ID_SOCIO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_CONTADOR_INDEX8" ON "REDESIM_CONTADOR" ("ID_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_CONTADOR"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_CONTADOR';
--------------------------------------------------------
--  DDL for Materialized View REDESIM_ARQUIVO
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "REDESIM_ARQUIVO" ("ID", "HASH", "DATA_ARQUIVO", "DATA_RECEPCAO", "DATA_DESMEMBRAMENTO", "DATA_PROCESSAMENTO", "VERSAO", "CATEGORIA", "IDENTIDADE", "PROTOCOLO_DBE", "INSCRICAO", "ID_PROTOCOLO", "ID_EMPRESA")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT SYSDATE + 1/24
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT TAR_ID AS ID,
    CASE WHEN TAR_HASH IS NULL THEN '' ELSE TAR_HASH END as hash, 
    CASE WHEN TAR_DTARQUIVO IS NULL THEN TO_DATE('01/01/00', 'MM/DD/YY') ELSE TAR_DTARQUIVO END as data_arquivo, 
    CASE WHEN TAR_DTRECEPCAO IS NULL THEN TO_DATE('01/01/00', 'MM/DD/YY') ELSE TAR_DTRECEPCAO END as data_recepcao, 
    CASE WHEN TAR_DTDESMEMBRAMENTO IS NULL THEN TO_DATE('01/01/00', 'MM/DD/YY') ELSE TAR_DTDESMEMBRAMENTO END as data_desmembramento, 
    CASE WHEN TAR_DTPROCESSAMENTO IS NULL THEN TO_DATE('01/01/00', 'MM/DD/YY') ELSE TAR_DTPROCESSAMENTO END as data_processamento, 
    CASE WHEN TAR_VERSAO IS NULL THEN '' ELSE TAR_VERSAO END as versao, 
    CASE WHEN TAR_CATEGORIA IS NULL THEN '' ELSE TAR_CATEGORIA END as categoria,
    CASE WHEN TAR_NOMEARQUIVO IS NULL THEN '' ELSE TAR_NOMEARQUIVO END as identidade,
    CASE WHEN TAR_PROTOCOLO IS NULL THEN '' ELSE TAR_PROTOCOLO END as protocolo_dbe,
    CASE WHEN TAR_INSCRICAO IS NULL THEN 0 ELSE TAR_INSCRICAO END as inscricao,  
    CASE WHEN TCC_PROTOCOLOCPE IS NULL THEN '' ELSE TCC_PROTOCOLOCPE END AS ID_protocolo,
    TEM_CNPJ as ID_EMPRESA 
    FROM APL_REDESIM.TAB_ARQUIVO@DL_CENT , APL_REDESIM.TAB_SOLICITACAO@dl_cent, APL_REDESIM.TAB_EMPRESA@dl_cent 
    WHERE TAR_ID = TCC_ID
    AND TAR_ID = TEM_ID;

  CREATE UNIQUE INDEX "REDESIM_ARQUIVO_INDEX1" ON "REDESIM_ARQUIVO" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX10" ON "REDESIM_ARQUIVO" ("PROTOCOLO_DBE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX11" ON "REDESIM_ARQUIVO" ("INSCRICAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX12" ON "REDESIM_ARQUIVO" ("ID_PROTOCOLO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX13" ON "REDESIM_ARQUIVO" ("ID_EMPRESA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX2" ON "REDESIM_ARQUIVO" ("HASH") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX3" ON "REDESIM_ARQUIVO" ("DATA_ARQUIVO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX4" ON "REDESIM_ARQUIVO" ("DATA_RECEPCAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX5" ON "REDESIM_ARQUIVO" ("DATA_DESMEMBRAMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX6" ON "REDESIM_ARQUIVO" ("DATA_PROCESSAMENTO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX7" ON "REDESIM_ARQUIVO" ("VERSAO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX8" ON "REDESIM_ARQUIVO" ("CATEGORIA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  CREATE INDEX "REDESIM_ARQUIVO_INDEX9" ON "REDESIM_ARQUIVO" ("IDENTIDADE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON MATERIALIZED VIEW "REDESIM_ARQUIVO"  IS 'snapshot table for snapshot UFC_SEM.REDESIM_ARQUIVO';
