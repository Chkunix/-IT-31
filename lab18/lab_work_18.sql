-- ============================================================
-- Практика 18. Згенеровані стовпці
-- Варіант 5. Автосалон
-- Файл продовжує базу практики 15
-- ============================================================

PRAGMA foreign_keys = ON;

-- STORED на наявну таблицю додати не можна:
-- ALTER TABLE cars ADD COLUMN price_stored REAL
--     GENERATED ALWAYS AS (price * 1.2) STORED;
-- cannot add a STORED column

-- ---------- Завдання 1. Ціна з ПДВ ----------
ALTER TABLE cars ADD COLUMN price_with_vat REAL
    GENERATED ALWAYS AS (ROUND(price * 1.2, 2)) VIRTUAL;

SELECT id, brand, price, price_with_vat FROM cars ORDER BY id;
-- 1 | Toyota | 720000.0 | 864000.0
-- 2 | Volkswagen | 650000.0 | 780000.0
-- 3 | Skoda | 780000.0 | 936000.0
-- 4 | Renault | 580000.0 | 696000.0
-- 5 | Hyundai | 950000.0 | 1140000.0
-- 6 | Ford | 490000.0 | 588000.0

-- ---------- Завдання 2. Прапорець «продано» ----------
ALTER TABLE cars ADD COLUMN is_sold INTEGER
    GENERATED ALWAYS AS (status = 'продано') VIRTUAL;

SELECT id, status, is_sold FROM cars ORDER BY id;
-- 1 | в наявності | 0
-- 2 | продано | 1
-- 3 | продано | 1
-- 4 | в наявності | 0
-- 5 | зарезервовано | 0
-- 6 | продано | 1

-- ---------- Завдання 3. Прямий запис у згенерований стовпець ----------
UPDATE cars SET price_with_vat = 1 WHERE id = 1;
-- cannot UPDATE generated column "price_with_vat"

-- ---------- Завдання 4. Зміна базової колонки ----------
SELECT id, price, price_with_vat FROM cars WHERE id = 1;
-- до: 1 | 720000.0 | 864000.0

UPDATE cars SET price = 800000 WHERE id = 1;

SELECT id, price, price_with_vat FROM cars WHERE id = 1;
-- після: 1 | 800000.0 | 960000.0

-- ---------- Завдання 5. WHERE за згенерованим стовпцем ----------
SELECT id, brand, price_with_vat
FROM cars
WHERE price_with_vat > 900000
ORDER BY id;
-- 1 | Toyota | 960000.0
-- 3 | Skoda | 936000.0
-- 5 | Hyundai | 1140000.0
