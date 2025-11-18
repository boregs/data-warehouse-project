/*
===============================================================================
Stored Procedure: Carregar layer raw_data (Fonte -> raw_data_layer)
===============================================================================
Objetivo do Script:
    Esta stored procedure carrega dados no schema 'raw_data_layer' a partir de arquivos CSV externos. 
    Ela executa as seguintes ações:
    - Trunca (limpa) as tabelas bronze antes de carregar os dados.
    - Usa o comando `BULK INSERT` para carregar dados dos arquivos CSV para as tabelas bronze.

Parâmetros:
    Nenhum. 
    Esta stored procedure não aceita parâmetros nem retorna valores.

Exemplo de Uso:
    EXEC raw_data_layer.load_raw_data;
===============================================================================
*/

-- COMANDO QUE DEFINE UM BLOCO DE CODIGO REUTILIZAVEL | UTIL PARA RODAR O MESMO SCRIPT VARIAS VEZES SEM DAR ERRO
CREATE OR ALTER PROCEDURE raw_data_layer.load_raw_data AS 
BEGIN
	
	-- DECLARA VARIAVEIS PARA REGISTRAR O TEMPO QUE LEVA PARA INSERIR OS DADOS NAS TABLELAS | "start_time" SENDO O INICIO E "end_time" O FIM DO PROCESSO
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_load_start_time DATETIME, @batch_load_end_time DATETIME;
	
	-- DIZ PARA O SQL TENTAR RODAR SCRIPT, SE DER ALGUM ERRO NO MEIO DO PROCESSO ELE CAI PARA O "BEGIN CATCH", QUE DEMONSTRA A MENSAGEM DE ERRO
	SET @batch_load_start_time = GETDATE();
	BEGIN TRY
		PRINT '==============================================='
		PRINT 'Carregando layer de dados originais'
		PRINT '==============================================='


		PRINT '==============================================='
		PRINT 'Carregando tabela CRM'
		PRINT '==============================================='


		SET @start_time = GETDATE();
 		PRINT 'Truncando tabela: crm_cust_info'
		-- "DELETA" TODAS AS LINHAS DA COLUNA ANTES DE LOADAR OS DADOS, PREVININDO A DUPLICAÇAO DE DADOS
		TRUNCATE TABLE raw_data_layer.crm_cust_info;

		PRINT 'Inserindo dados na tabela: crm_cust_info'
		/*BULK INSERT É ADICIONAR TODOS OS DADOS DO SOURCE DE UMA VEZ NA TABELA
		DIFERENTE DO INSERT COMUM QUE ADICIONA LINHA POR LINHA*/
		BULK INSERT raw_data_layer.crm_cust_info
		FROM '\datasets\source_crm\cust_info.csv' -- CAMINHO DO ARQUIVO FONTE DOS DADOS | ADICIONE O CAMINHO DO SEU COMPUTADOR
		WITH (
			FIRSTROW = 2, -- DIZ PARA A DATABASE QUE A PRIMEIRA LINHA É A SEGUNDA | CONSIDEIRANDO QUE A PRIMEIRA LINHA SERIA O NOME DAS COLUNAS NO ARQUIVO FONTE
			FIELDTERMINATOR = ',' -- DIZ PARA A DATABASE QUAL O SEPARADOR DE DADOS DO ARQUIVO, NESSE CASO A ','
		);
		SET @end_time = GETDATE();
		PRINT '>> Duracao de carregamento de dados:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------'

		SET @start_time = GETDATE();
		PRINT 'Truncando tabela: prd_info'
		TRUNCATE TABLE raw_data_layer.prd_info;

		PRINT 'Inserindo dados na tabela: prd_info'
		BULK INSERT raw_data_layer.prd_info
		FROM '\datasets\source_crm\prd_info.csv' -- CAMINHO DO ARQUIVO FONTE DOS DADOS | ADICIONE O CAMINHO DO SEU COMPUTADOR
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' 
		);

		-- PRINTA A DIFERENÇA DE TEMPO ENTRE O INICIO DA OPERACAO E O FIM DA OPERACAO
		SET @end_time = GETDATE();
		PRINT '>> Duracao de carregamento de dados:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------'

		SET @start_time = GETDATE();
		PRINT 'Truncando tabela: sales_details'
		TRUNCATE TABLE raw_data_layer.sales_details;

		PRINT 'Inserindo dados na tabela: sales_details'
		BULK INSERT raw_data_layer.sales_details
		FROM '\datasets\source_crm\sales_details.csv' -- CAMINHO DO ARQUIVO FONTE DOS DADOS | ADICIONE O CAMINHO DO SEU COMPUTADOR
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',' 
		);

		SET @end_time = GETDATE();
		PRINT '>> Duracao de carregamento de dados:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '==============================================='
		PRINT 'Carregando tabela ERP'
		PRINT '==============================================='

		SET @start_time = GETDATE();
		PRINT 'Truncando tabela: cust_az12'
		TRUNCATE TABLE raw_data_layer.cust_az12;

		PRINT 'Inserindo dados na tabela: cust_az12'
		BULK INSERT raw_data_layer.cust_az12
		FROM '\datasets\source_erp\CUST_AZ12.csv' -- CAMINHO DO ARQUIVO FONTE DOS DADOS | ADICIONE O CAMINHO DO SEU COMPUTADOR
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',' 
		);
		SET @end_time = GETDATE();
		PRINT '>> Duracao de carregamento de dados:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------'

		SET @start_time = GETDATE();
		PRINT 'Truncando tabela: loc_a101'
		TRUNCATE TABLE raw_data_layer.loc_a101;

		PRINT 'Inserindo dados na tabela: loc_a101'
		BULK INSERT raw_data_layer.loc_a101
		FROM '\datasets\source_erp\LOC_A101.csv' -- CAMINHO DO ARQUIVO FONTE DOS DADOS | ADICIONE O CAMINHO DO SEU COMPUTADOR
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' 
		);

		SET @end_time = GETDATE();
		PRINT '>> Duracao de carregamento de dados:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------'

		SET @start_time = GETDATE();
		PRINT 'Truncando tabela: px_cat_g1v2'
		TRUNCATE TABLE raw_data_layer.px_cat_g1v2;

		PRINT 'Inserindo dados na tabela: px_cat_g1v2'
		BULK INSERT raw_data_layer.px_cat_g1v2
		FROM '\datasets\source_erp\PX_CAT_G1V2.csv' -- CAMINHO DO ARQUIVO FONTE DOS DADOS | ADICIONE O CAMINHO DO SEU COMPUTADOR
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',' 
		);
		SET @end_time = GETDATE();
		PRINT '>> Duracao de carregamento de dados:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


		SET @batch_load_end_time = GETDATE();
		PRINT '==============================================='
		PRINT 'CARREGAMENTO DO LAYER COMPLETO'
		PRINT '	>> Tempo de carregamento do layer inteiro:' + CAST(DATEDIFF(second, @batch_load_start_time, @batch_load_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==============================================='
	END TRY
	BEGIN CATCH
		PRINT '==============================================='
		PRINT 'ERRO AO CARREGAR A CAMADA'
		PRINT 'MENSAGEM DE ERRO' + ERROR_MESSAGE();
		PRINT 'CODIGO DE ERRO' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT '==============================================='
	END CATCH
END
