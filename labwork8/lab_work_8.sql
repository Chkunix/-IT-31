-- ============================================================
-- Практика 8. Агрегатні функції: COUNT, SUM, AVG, MIN, MAX
-- Варіант 5. Автосалон (cars, clients, sales)
-- Структура таблиць не змінюється, лише запити (+ один UPDATE у Завданні 1)
-- ============================================================
PRAGMA foreign_keys = ON;

-- ---------- Завдання 1. COUNT(*) проти COUNT(колонка) ----------
-- Необов'язкова колонка фактової таблиці: sales.client_id (без NOT NULL).
-- 1а) до змін:
SELECT COUNT(*) AS all_sales, COUNT(client_id) AS sales_with_client FROM sales;
-- результат: 10 | 10  (NULL ніде немає)

-- Числа збіглися -> ставимо NULL в одному рядку:
UPDATE sales SET client_id = NULL WHERE id = 10;

-- 1б) після зміни:
SELECT COUNT(*) AS all_sales, COUNT(client_id) AS sales_with_client FROM sales;
-- результат: 10 | 9

-- ---------- Завдання 2. SUM і AVG ----------
SELECT SUM(price) AS total_revenue, AVG(price) AS avg_sale_price FROM sales;
-- результат: 6775000.0 | 677500.0

-- ---------- Завдання 3. MIN/MAX на ДАТІ і ТЕКСТІ ----------
SELECT MIN(sale_date) AS first_sale, MAX(sale_date) AS last_sale FROM sales;
-- результат: 2026-02-10 | 2026-06-25
SELECT MIN(last_name) AS first_alphabetically, MAX(last_name) AS last_alphabetically FROM clients;
-- результат: Бондаренко | Шевчук

-- ---------- Завдання 4. Кілька агрегатів в одному запиті ----------
SELECT COUNT(*)               AS sales_count,
       COUNT(client_id)       AS sales_with_client,
       SUM(price)             AS total_revenue,
       ROUND(AVG(price), 2)   AS avg_price,
       MIN(price)             AS cheapest_sale,
       MAX(price)             AS priciest_sale
FROM sales;
-- результат: 10 | 9 | 6775000.0 | 677500.0 | 485000.0 | 940000.0

-- ---------- Завдання 5. Агрегат + WHERE (на таблиці-вимірі) ----------
SELECT COUNT(*)             AS sales_count,
       SUM(s.price)         AS total_revenue,
       ROUND(AVG(s.price),2) AS avg_price
FROM sales s
JOIN cars c ON c.id = s.car_id
WHERE c.brand = 'Skoda';
-- результат: 2 | 1555000.0 | 777500.0

-- ---------- Контрольне питання 3: SUM, коли всі значення NULL ----------
-- Рядок id = 10 має client_id = NULL; обмежуємо вибірку тільки ним:
SELECT SUM(client_id) AS sum_all_null, AVG(client_id) AS avg_all_null,
       COUNT(client_id) AS cnt_all_null, COUNT(*) AS cnt_star
FROM sales WHERE id = 10;
-- результат: NULL | NULL | 0 | 1
