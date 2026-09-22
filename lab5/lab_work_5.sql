PRAGMA foreign_keys = OFF;
PRAGMA legacy_alter_table = ON;
BEGIN TRANSACTION;
ALTER TABLE cars RENAME TO cars_old;
CREATE TABLE cars (
    id     INTEGER PRIMARY KEY,
    brand  TEXT NOT NULL,
    model  TEXT NOT NULL,
    year   INTEGER,
    price  REAL NOT NULL,
    status TEXT NOT NULL DEFAULT 'в наявності'
);
INSERT INTO cars SELECT * FROM cars_old;
DROP TABLE cars_old;
COMMIT;
PRAGMA legacy_alter_table = OFF;
PRAGMA foreign_keys = ON;

PRAGMA foreign_keys = OFF;
PRAGMA legacy_alter_table = ON;
BEGIN TRANSACTION;
ALTER TABLE clients RENAME TO clients_old;
CREATE TABLE clients (
    id         INTEGER PRIMARY KEY,
    last_name  TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone      TEXT UNIQUE,
    city       TEXT
);
INSERT INTO clients SELECT * FROM clients_old;
DROP TABLE clients_old;
COMMIT;
PRAGMA legacy_alter_table = OFF;
PRAGMA foreign_keys = ON;

PRAGMA foreign_keys = OFF;
PRAGMA legacy_alter_table = ON;
BEGIN TRANSACTION;
ALTER TABLE cars RENAME TO cars_old;
CREATE TABLE cars (
    id     INTEGER PRIMARY KEY,
    brand  TEXT NOT NULL,
    model  TEXT NOT NULL,
    year   INTEGER,
    price  REAL NOT NULL CHECK (price > 0),
    status TEXT NOT NULL DEFAULT 'в наявності'
);
INSERT INTO cars SELECT * FROM cars_old;
DROP TABLE cars_old;
COMMIT;
PRAGMA legacy_alter_table = OFF;
PRAGMA foreign_keys = ON;

PRAGMA foreign_keys = OFF;
PRAGMA legacy_alter_table = ON;
BEGIN TRANSACTION;
ALTER TABLE clients RENAME TO clients_old;
CREATE TABLE clients (
    id         INTEGER PRIMARY KEY,
    last_name  TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone      TEXT UNIQUE,
    city       TEXT DEFAULT 'Київ'
);
INSERT INTO clients SELECT * FROM clients_old;
DROP TABLE clients_old;
COMMIT;
PRAGMA legacy_alter_table = OFF;
PRAGMA foreign_keys = ON;

UPDATE cars SET price = -100000 WHERE id = 1;
