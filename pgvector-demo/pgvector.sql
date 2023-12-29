-- Oficial docs: https://github.com/pgvector/pgvector
-- Docker Image: ankane/pgvector
-- docker run --name pgvector-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d ankane/pgvector:latest

-- INSTALL THE EXNTENSION
CREATE EXTENSION IF NOT EXISTS vector;

-- Create a table using the vector type
CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3));

-- Insert
INSERT INTO items (embedding) VALUES ('[1,2,3]'), ('[4,5,6]');

-- Update vectors
UPDATE items SET embedding = '[1,2,3]' WHERE id = 1;

-- Upsert example
INSERT INTO items (id, embedding) VALUES (1, '[1,2,3]'), (2, '[4,5,6]')
    ON CONFLICT (id) DO UPDATE SET embedding = EXCLUDED.embedding;

-- Delete vectors
DELETE FROM items WHERE id = 1;

-- OPERATORS ON VECTORS
-- +	element-wise addition	
-- -	element-wise subtraction	
-- *	element-wise multiplication
-- <->	Euclidean distance	
-- <#>	negative inner product	
-- <=>	cosine distance

-- Example usage of operator
SELECT embedding, embedding <-> '[7,8,9]' as l2_example,
    embedding <#> '[7,8,9]' as inner_product_example,
    embedding <=> '[7,8,9]' as cosine_distance_example,
    embedding + '[7,8,9]' as element_wise_addition_example,
    embedding - '[7,8,9]' as element_wise_subtraction_example,
    embedding * '[7,8,9]' as element_wise_multiplication_example
FROM items;

-- Average Vectors 
SELECT AVG(embedding) FROM items; -- AVG([1,2,3], [4,5,6]) = [2.5, 3.5, 4.5] 