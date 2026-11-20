-- ============================================================
-- Практика 15. Індекси та EXPLAIN QUERY PLAN
-- Варіант 5. Автосалон
-- Файл продовжує базу практики 14
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Завдання 1. План до індексу ----------
EXPLAIN QUERY PLAN
SELECT * FROM sales WHERE client_id = 2;
-- SCAN sales

-- ---------- Завдання 2. Індекс на зовнішньому ключі ----------
CREATE INDEX idx_sales_client ON sales(client_id);

EXPLAIN QUERY PLAN
SELECT * FROM sales WHERE client_id = 2;
-- SEARCH sales USING INDEX idx_sales_client (client_id=?)

-- ---------- Завдання 3. Композитний індекс ----------
EXPLAIN QUERY PLAN
SELECT * FROM sales WHERE client_id = 2 AND payment_method = 'кредит';
-- SEARCH sales USING INDEX idx_sales_client (client_id=?)

CREATE INDEX idx_sales_client_payment ON sales(client_id, payment_method);

EXPLAIN QUERY PLAN
SELECT * FROM sales WHERE client_id = 2 AND payment_method = 'кредит';
-- SEARCH sales USING INDEX idx_sales_client_payment (client_id=? AND payment_method=?)

-- ---------- Завдання 4. Індекс і ORDER BY ----------
EXPLAIN QUERY PLAN
SELECT * FROM sales ORDER BY sale_date;
-- SCAN sales
-- USE TEMP B-TREE FOR ORDER BY

CREATE INDEX idx_sales_date ON sales(sale_date);

EXPLAIN QUERY PLAN
SELECT * FROM sales ORDER BY sale_date;
-- SCAN sales USING INDEX idx_sales_date

-- ---------- Завдання 5. DROP INDEX ----------
DROP INDEX idx_sales_date;

EXPLAIN QUERY PLAN
SELECT * FROM sales ORDER BY sale_date;
-- SCAN sales
-- USE TEMP B-TREE FOR ORDER BY

SELECT name FROM sqlite_master WHERE type = 'index' ORDER BY name;
-- idx_sales_client
-- idx_sales_client_payment
