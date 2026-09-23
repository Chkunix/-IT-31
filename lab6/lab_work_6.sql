PRAGMA foreign_keys = ON;

UPDATE sales SET payment_method = 'кредит' WHERE id = 1;

UPDATE cars SET status = 'продано' WHERE id = 5;

SELECT COUNT(*) FROM sales;

DELETE FROM sales WHERE id = 10;

SELECT COUNT(*) FROM sales;

DELETE FROM clients WHERE id = 3;

SELECT * FROM sales WHERE client_id IS NULL;
