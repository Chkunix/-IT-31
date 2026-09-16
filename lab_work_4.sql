-- ============================================================
-- Практика 4. Додавання записів, встановлення ключів і зв'язків
-- Варіант 5. Автосалон
-- Таблиці: cars (вимір 1, з Практики 1), clients (вимір 2),
--          sales (фактова таблиця з двома FOREIGN KEY)
-- ============================================================

-- ---------- Завдання 1. Увімкнення перевірки ключів ----------
PRAGMA foreign_keys = ON;

-- ---------- Таблиця-вимір 1 (з Практики 1 / v5_prerequisites.sql) ----------
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS cars;

CREATE TABLE cars (
    id     INTEGER PRIMARY KEY,
    brand  TEXT NOT NULL,
    model  TEXT NOT NULL,
    year   INTEGER,
    price  REAL,
    status TEXT NOT NULL DEFAULT 'в наявності'
);

INSERT INTO cars (brand, model, year, price, status) VALUES
    ('Toyota',     'Corolla', 2022, 720000, 'в наявності'),
    ('Volkswagen', 'Golf',    2021, 650000, 'продано'),
    ('Skoda',      'Octavia', 2023, 780000, 'в наявності'),
    ('Renault',    'Duster',  2020, 580000, 'в наявності'),
    ('Hyundai',    'Tucson',  2022, 950000, 'зарезервовано'),
    ('Ford',       'Focus',   2019, 490000, 'продано');

-- ---------- Завдання 1. Таблиця-вимір 2: clients ----------
CREATE TABLE clients (
    id         INTEGER PRIMARY KEY,
    last_name  TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone      TEXT,
    city       TEXT
);

-- ---------- Завдання 2. Фактова таблиця sales з двома FK ----------
CREATE TABLE sales (
    id             INTEGER PRIMARY KEY,
    car_id         INTEGER NOT NULL,
    client_id      INTEGER,
    sale_date      TEXT NOT NULL,
    price          REAL NOT NULL,
    payment_method TEXT NOT NULL DEFAULT 'готівка',
    FOREIGN KEY (car_id)    REFERENCES cars (id)    ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE SET NULL
);

-- ---------- Завдання 3. Заповнення пов'язаними даними ----------
INSERT INTO clients (last_name, first_name, phone, city) VALUES
    ('Коваленко', 'Андрій',  '+380671234567', 'Київ'),
    ('Мельник',   'Оксана',  '+380502345678', 'Львів'),
    ('Бондаренко','Сергій',  '+380633456789', 'Одеса'),
    ('Шевчук',    'Ірина',   '+380964567890', 'Київ'),
    ('Ткаченко',  'Дмитро',  '+380685678901', 'Харків'),
    ('Литвин',    'Наталія', '+380736789012', 'Вінниця');

INSERT INTO sales (car_id, client_id, sale_date, price, payment_method) VALUES
    (2, 1, '2026-02-10', 650000, 'готівка'),
    (6, 3, '2026-02-18', 485000, 'кредит'),
    (1, 2, '2026-03-04', 715000, 'безготівковий'),
    (4, 5, '2026-03-12', 575000, 'кредит'),
    (3, 4, '2026-04-02', 780000, 'безготівковий'),
    (5, 6, '2026-04-15', 940000, 'лізинг'),
    (1, 6, '2026-05-06', 720000, 'готівка'),
    (2, 4, '2026-05-21', 645000, 'кредит'),
    (3, 1, '2026-06-09', 775000, 'безготівковий'),
    (6, 2, '2026-06-25', 490000, 'готівка');

-- ---------- Завдання 4. Навмисна помилка зовнішнього ключа ----------
-- Наступний рядок МАЄ завершитися помилкою:
-- Error: FOREIGN KEY constraint failed
-- INSERT INTO sales (car_id, client_id, sale_date, price)
-- VALUES (9999, 1, '2026-07-01', 600000);

-- ---------- Перевірка ----------
-- SELECT c.brand, c.model, cl.last_name, s.sale_date, s.price
-- FROM sales s
-- JOIN cars c    ON c.id  = s.car_id
-- JOIN clients cl ON cl.id = s.client_id;
