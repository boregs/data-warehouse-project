/* 
Objetivo do Script:
    Este script cria um novo banco de dados chamado 'data_warehouse' após verificar se ele já existe.
    Se o banco de dados existir, ele é excluído e recriado. Além disso, o script configura cinco
    esquemas dentro do banco de dados: raw_data_layer, staging_layer, intermediate_layer, core_layer
    e data_mart_layer.
*/

/* isso verifica se existe uma database "data_warehouse" antes de criar uma 
   Se sim, ele dropa a database existente (incluindo os dados dela), e cria outra no lugar */
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'data_warehouse')
  BEGIN
    -- Isso força o SQL Server a cortar qualquer comunicação que a database existente pode estar tendo, tirando o alerta de segurança do SQL que poderia parar o drop da database
    ALTER DATABASE data_warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;  
    DROP DATABASE data_warehouse;
  END;
GO
  
-- criando e usando a database
CREATE DATABASE data_warehouse;
GO
  
USE data_warehouse;
GO
-- criando os esquemas

CREATE SCHEMA raw_data_layer;
GO
CREATE SCHEMA staging_layer;
GO
CREATE SCHEMA intermediate_layer;
GO
CREATE SCHEMA core_layer;
GO
CREATE SCHEMA data_mart_layer;
GO
