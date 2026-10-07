PRAGMA foreign_keys = ON;

-- Завдання 1
SELECT cars.brand, cars.model, cars.year, sales.sale_date, sales.price
FROM sales
JOIN cars ON sales.car_id = cars.id
WHERE cars.year >= 2020
ORDER BY sales.sale_date;


-- Завдання 2
SELECT cars.brand, cars.model, clients.last_name, sales.sale_date
FROM sales
JOIN cars ON sales.car_id = cars.id
JOIN clients ON sales.client_id = clients.id
ORDER BY sales.sale_date;

-- Завдання 3
SELECT cars.brand, cars.model, cars.year
FROM cars
LEFT JOIN sales ON sales.car_id = cars.id
WHERE sales.id IS NULL;


-- Завдання 4a
SELECT COUNT(*) FROM cars, clients;

SELECT COUNT(*) FROM cars;


-- Завдання 4c
SELECT COUNT(*) FROM clients;

