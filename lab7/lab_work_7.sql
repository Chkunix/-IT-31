PRAGMA foreign_keys = ON;

-- Завдання 1
SELECT cars.brand, cars.model, cars.year, sales.sale_date, sales.price
FROM sales
JOIN cars ON sales.car_id = cars.id
WHERE cars.year >= 2020
ORDER BY sales.sale_date;
-- результат:
-- ('Volkswagen', 'Golf', 2021, '2026-02-10', 650000.0)
-- ('Toyota', 'Corolla', 2022, '2026-03-04', 715000.0)
-- ('Renault', 'Duster', 2020, '2026-03-12', 575000.0)
-- ('Skoda', 'Octavia', 2023, '2026-04-02', 780000.0)
-- ('Hyundai', 'Tucson', 2022, '2026-04-15', 940000.0)
-- ('Toyota', 'Corolla', 2022, '2026-05-06', 720000.0)
-- ('Volkswagen', 'Golf', 2021, '2026-05-21', 645000.0)
-- ('Skoda', 'Octavia', 2023, '2026-06-09', 775000.0)

-- Завдання 2
SELECT cars.brand, cars.model, clients.last_name, sales.sale_date
FROM sales
JOIN cars ON sales.car_id = cars.id
JOIN clients ON sales.client_id = clients.id
ORDER BY sales.sale_date;
-- результат:
-- ('Volkswagen', 'Golf', 'Коваленко', '2026-02-10')
-- ('Toyota', 'Corolla', 'Мельник', '2026-03-04')
-- ('Renault', 'Duster', 'Ткаченко', '2026-03-12')
-- ('Skoda', 'Octavia', 'Шевчук', '2026-04-02')
-- ('Hyundai', 'Tucson', 'Литвин', '2026-04-15')
-- ('Toyota', 'Corolla', 'Литвин', '2026-05-06')
-- ('Volkswagen', 'Golf', 'Шевчук', '2026-05-21')
-- ('Skoda', 'Octavia', 'Коваленко', '2026-06-09')

-- Завдання 3
SELECT cars.brand, cars.model, cars.year
FROM cars
LEFT JOIN sales ON sales.car_id = cars.id
WHERE sales.id IS NULL;
-- результат:
-- ('Kia', 'Rio', 2020)

-- Завдання 4a
SELECT COUNT(*) FROM cars, clients;
-- результат:
-- (42,)

-- Завдання 4b
SELECT COUNT(*) FROM cars;
-- результат:
-- (7,)

-- Завдання 4c
SELECT COUNT(*) FROM clients;
-- результат:
-- (6,)
