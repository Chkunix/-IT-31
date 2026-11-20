-- ============================================================
-- Практика 14. Створення та відкат транзакцій у SQLite
-- Варіант 5. Автосалон
-- Той самий файл .db, що в Практиках 4-13
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Завдання 1. Атомарна пара INSERT + UPDATE ----------
BEGIN;
INSERT INTO sales (car_id, client_id, sale_date, price, payment_method)
VALUES (3, 2, '2026-11-19', 790000, 'готівка');
UPDATE cars SET status = 'продано' WHERE id = 3;
COMMIT;

SELECT id, brand, model, status FROM cars WHERE id = 3;
-- 3 | Skoda | Octavia | продано

SELECT id, car_id, client_id, sale_date, price, payment_method
FROM sales WHERE sale_date = '2026-11-19';
-- 11 | 3 | 2 | 2026-11-19 | 790000.0 | готівка

-- ---------- Завдання 2. Свідомий ROLLBACK ----------
BEGIN;
INSERT INTO sales (car_id, client_id, sale_date, price, payment_method)
VALUES (4, 1, '2026-11-19', 560000, 'кредит');
UPDATE cars SET status = 'продано' WHERE id = 4;
ROLLBACK;

SELECT COUNT(*) FROM sales;
-- 11

SELECT id, status FROM cars WHERE id = 4;
-- 4 | в наявності

SELECT COUNT(*) FROM sales WHERE car_id = 4 AND sale_date = '2026-11-19';
-- 0

-- ---------- Завдання 3. Проміжний стан усередині транзакції ----------
BEGIN;
UPDATE cars SET status = 'зарезервовано' WHERE id = 4;
SELECT id, status FROM cars WHERE id = 4;
-- 4 | зарезервовано
ROLLBACK;

SELECT id, status FROM cars WHERE id = 4;
-- 4 | в наявності

-- ---------- Завдання 4. Помилка всередині транзакції, потім ROLLBACK ----------
BEGIN;
INSERT INTO sales (car_id, client_id, sale_date, price, payment_method)
VALUES (4, 5, '2026-11-20', 570000, 'готівка');
INSERT INTO sales (id, car_id, client_id, sale_date, price)
VALUES (1, 4, 5, '2026-11-20', 570000);
-- Runtime error: UNIQUE constraint failed: sales.id

SELECT id, sale_date, price FROM sales WHERE sale_date = '2026-11-20';
-- 12 | 2026-11-20 | 570000.0

ROLLBACK;

SELECT COUNT(*) FROM sales WHERE sale_date = '2026-11-20';
-- 0

-- ---------- Завдання 5. Та сама помилка, але COMMIT ----------
BEGIN;
INSERT INTO sales (car_id, client_id, sale_date, price, payment_method)
VALUES (4, 5, '2026-11-21', 571000, 'готівка');
INSERT INTO sales (id, car_id, client_id, sale_date, price)
VALUES (1, 4, 5, '2026-11-21', 571000);
-- Runtime error: UNIQUE constraint failed: sales.id
COMMIT;

SELECT id, car_id, client_id, sale_date, price
FROM sales WHERE sale_date = '2026-11-21';
-- 12 | 4 | 5 | 2026-11-21 | 571000.0

SELECT COUNT(*) FROM sales;
-- 12
