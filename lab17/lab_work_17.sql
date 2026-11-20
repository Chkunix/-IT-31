-- ============================================================
-- Практика 17. Імпорт «брудного» CSV: перевірка й експорт
-- Варіант 5. Автосалон, цільова таблиця cars
-- Файл продовжує базу практики 16 (14 авто, найбільший id = 14)
-- CSV: v5_raw_rows.csv (10 записів, роздільник ;)
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Завдання 1. Наївний імпорт без роздільника ----------
CREATE TABLE cars_staging (
    brand  TEXT,
    model  TEXT,
    year   INTEGER,
    price  REAL,
    status TEXT
);

.mode csv
.import --skip 1 v5_raw_rows.csv cars_staging
-- v5_raw_rows.csv:2: expected 5 columns but found 1 - filling the rest with NULL
-- v5_raw_rows.csv:3: expected 5 columns but found 1 - filling the rest with NULL
-- v5_raw_rows.csv:4: expected 5 columns but found 1 - filling the rest with NULL
-- ... той самий текст для рядків 5-10 ...
-- v5_raw_rows.csv:11: expected 5 columns but found 2 - filling the rest with NULL

SELECT COUNT(*) FROM cars_staging;
-- 10

SELECT * FROM cars_staging LIMIT 1;
-- Peugeot;3008;2022;990000.0;в наявності||||

DELETE FROM cars_staging;

-- ---------- Завдання 2. Імпорт із роздільником ; ----------
.mode csv
.separator ";"
.import --skip 1 v5_raw_rows.csv cars_staging
-- попереджень немає

SELECT COUNT(*) FROM cars_staging;
-- 10

-- ---------- Завдання 3. Контроль якості ----------
SELECT SUM(brand = '') AS brand_empty,
       SUM(model = '') AS model_empty,
       SUM(year = '') AS year_empty,
       SUM(price = '') AS price_empty,
       SUM(status = '') AS status_empty
FROM cars_staging;
-- 0 | 0 | 0 | 2 | 0

SELECT price, typeof(price), COUNT(*)
FROM cars_staging
GROUP BY price, typeof(price);
-- порожня ціна: text, 2 рядки; решта цін: real

SELECT typeof(year), COUNT(*) FROM cars_staging GROUP BY typeof(year);
-- integer | 10

SELECT brand, model, year, price, status, COUNT(*) AS cnt
FROM cars_staging
GROUP BY brand, model, year, price, status
HAVING COUNT(*) > 1;
-- Nissan | Qashqai | 2021 | 860000.0 | продано | 2

.schema cars
-- brand, model і status оголошені NOT NULL; year і price можуть бути NULL

-- ---------- Завдання 4. Перенесення ----------
SELECT COUNT(*), MAX(id) FROM cars;
-- 14 | 14

INSERT INTO cars (brand, model, year, price, status)
SELECT DISTINCT brand, model, NULLIF(year, ''), NULLIF(price, ''), status
FROM cars_staging;

SELECT COUNT(*) FROM cars;
-- 23

SELECT id, brand, model
FROM cars
WHERE id > 14 AND price IS NULL
ORDER BY id;
-- 17 | Volvo | XC60
-- 19 | Mercedes-Benz | E 200

DROP TABLE cars_staging;

-- ---------- Завдання 5. Експорт доданих рядків ----------
.headers on
.mode csv
.output cars_export.csv
SELECT id, brand, model, year, price, status
FROM cars
WHERE id > 14
ORDER BY id;
.output stdout
