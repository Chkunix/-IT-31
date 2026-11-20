-- ============================================================
-- Практика 16. Імпорт даних із CSV у SQLite
-- Варіант 5. Автосалон, цільова таблиця cars
-- Файл продовжує базу практики 15
-- CSV: v5_new_rows.csv (8 рядків, без колонки id)
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Завдання 1. Підрахунок до імпорту ----------
SELECT COUNT(*) FROM cars;
-- 6

-- ---------- Завдання 2. Проміжна таблиця й імпорт ----------
CREATE TABLE cars_staging (
    brand  TEXT,
    model  TEXT,
    year   INTEGER,
    price  REAL,
    status TEXT
);

.mode csv
.import --skip 1 v5_new_rows.csv cars_staging

SELECT COUNT(*) FROM cars_staging;
-- 8

SELECT brand, model, year, price, status FROM cars_staging;
-- Toyota|RAV4|2023|1150000.0|в наявності
-- Skoda|Kodiaq|2022|1050000.0|в наявності
-- Volkswagen|Tiguan|2023|1280000.0|продано
-- Renault|Megane|2021|680000.0|в наявності
-- Hyundai|Elantra|2022|820000.0|продано
-- Kia|Ceed|2023|790000.0|в наявності
-- Ford|Kuga|2021|870000.0|в наявності
-- Mazda|3|2022|830000.0|продано

-- ---------- Завдання 3. Перенесення і видалення проміжної таблиці ----------
INSERT INTO cars (brand, model, year, price, status)
SELECT brand, model, year, price, status FROM cars_staging;

DROP TABLE cars_staging;

SELECT COUNT(*) FROM cars;
-- 14

-- ---------- Завдання 4. Нові рядки і їхні id ----------
SELECT id, brand, model
FROM cars
WHERE model IN ('RAV4', 'Kodiaq', 'Tiguan', 'Megane', 'Elantra', 'Ceed', 'Kuga', '3')
ORDER BY id;
-- 7|Toyota|RAV4
-- 8|Skoda|Kodiaq
-- 9|Volkswagen|Tiguan
-- 10|Renault|Megane
-- 11|Hyundai|Elantra
-- 12|Kia|Ceed
-- 13|Ford|Kuga
-- 14|Mazda|3

-- ---------- Завдання 5. Прямий імпорт в окремій копії бази ----------
-- sqlite3 direct_import_test.db
-- .mode csv
-- .import --skip 1 v5_new_rows.csv cars
--
-- v5_new_rows.csv:2: expected 6 columns but found 5 - filling the rest with NULL
-- v5_new_rows.csv:2: INSERT failed: datatype mismatch
-- (те саме для рядків 3-9 файлу)
--
-- SELECT COUNT(*) FROM cars;
-- 6
