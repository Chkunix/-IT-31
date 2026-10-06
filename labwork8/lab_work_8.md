# Практика 8. Агрегатні функції: COUNT, SUM, AVG, MIN, MAX

**Варіант 5 — Автосалон.** Таблиці: `cars`, `clients`, `sales` (фактова). Структура не змінювалась; єдина зміна даних — один `UPDATE` у Завданні 1.

## Завдання 1. COUNT(*) проти COUNT(колонка)

Необов'язкова колонка фактової таблиці — `sales.client_id` (немає `NOT NULL`; за правилом `ON DELETE SET NULL` вона стає `NULL`, коли клієнт просить видалити свої дані).

```sql
SELECT COUNT(*) AS all_sales, COUNT(client_id) AS sales_with_client FROM sales;
```

| стан | COUNT(*) | COUNT(client_id) |
|---|---|---|
| до змін | 10 | 10 |
| після `UPDATE` | 10 | 9 |

Спочатку числа збіглися (10 і 10): у поточній базі `client_id` ніде не `NULL`. Тому виконано
`UPDATE sales SET client_id = NULL WHERE id = 10;` і підрахунок повторено: `COUNT(*)` лишився 10 (рядок існує), а `COUNT(client_id)` став 9 (рядок із `NULL` пропущено).

## Завдання 2. SUM і AVG

```sql
SELECT SUM(price) AS total_revenue, AVG(price) AS avg_sale_price FROM sales;
```

Результат: **6 775 000** і **677 500**. Перше число — сумарна виручка автосалону від усіх 10 продажів; друге — середня ціна одного продажу (6 775 000 / 10). Це фактичні ціни продажу з `sales.price`, а не каталожні ціни з `cars`.

## Завдання 3. MIN/MAX на даті й тексті

```sql
SELECT MIN(sale_date) AS first_sale, MAX(sale_date) AS last_sale FROM sales;
SELECT MIN(last_name) AS first_alphabetically, MAX(last_name) AS last_alphabetically FROM clients;
```

- Дати: **2026-02-10** і **2026-06-25**. У SQLite дата — це `TEXT` у форматі `РРРР-ММ-ДД`, а рядки порівнюються посимвольно зліва направо. Оскільки рік іде першим, потім місяць, потім день, лексикографічний порядок збігається з хронологічним, тому найменший рядок — найраніша дата.
- Прізвища: **Бондаренко** і **Шевчук**. Текст порівнюється посимвольно за кодами символів (за замовчуванням порівняння `BINARY`), тобто «за алфавітом»: `Б` йде раніше за всі інші перші літери (`К, Л, М, Т, Ш`). Усі прізвища починаються з великої літери, тому регістр не спотворює результат.

## Завдання 4. Кілька агрегатів в одному запиті

```sql
SELECT COUNT(*) AS sales_count, COUNT(client_id) AS sales_with_client,
       SUM(price) AS total_revenue, ROUND(AVG(price), 2) AS avg_price,
       MIN(price) AS cheapest_sale, MAX(price) AS priciest_sale
FROM sales;
```

| sales_count | sales_with_client | total_revenue | avg_price | cheapest_sale | priciest_sale |
|---|---|---|---|---|---|
| 10 | 9 | 6 775 000 | 677 500 | 485 000 | 940 000 |

Це один підсумковий «звіт» на весь набір даних: один рядок, шість показників.

## Завдання 5. Агрегат + WHERE

```sql
SELECT COUNT(*) AS sales_count, SUM(s.price) AS total_revenue, ROUND(AVG(s.price),2) AS avg_price
FROM sales s JOIN cars c ON c.id = s.car_id
WHERE c.brand = 'Skoda';
```

Результат: **2 | 1 555 000 | 777 500** (замість 10 | 6 775 000 | 677 500). `WHERE` прибрав із розрахунку всі продажі, де автомобіль не Skoda, тож агрегати рахуються лише за двома продажами Octavia (780 000 + 775 000), ще до того, як функції їх побачили.

## Контрольні питання

**1. Чому `COUNT(*)` і `COUNT(колонка)` можуть відрізнятися, а `COUNT(*)` і `COUNT(id)` практично ніколи?**
`COUNT(*)` рахує рядки, а `COUNT(колонка)` — лише ті рядки, де значення колонки не `NULL`. Первинний ключ не може бути `NULL`, тому `COUNT(id)` пропускає нуль рядків і дорівнює `COUNT(*)`. (У SQLite для `INTEGER PRIMARY KEY` це гарантовано, оскільки `id` — псевдонім `rowid`.)

**2. Знаменник AVG при 5 рядках, один із яких `NULL`: 5 чи 4?**
Чотири. `AVG` = `SUM` / `COUNT(колонка)`: `NULL` не потрапляє ні в суму, ні в кількість. Перевірено на базі: після `UPDATE` `SUM(client_id) = 32`, `COUNT(client_id) = 9`, `AVG(client_id) = 3.5556` (32/9), а не 3.2 (32/10).

**3. Що поверне `SUM(колонка)`, якщо всі значення `NULL`?**
Не 0 і не помилку, а **`NULL`**. Перевірка на базі: єдиний рядок з `client_id IS NULL` — `id = 10`:
```sql
SELECT SUM(client_id), AVG(client_id), COUNT(client_id), COUNT(*) FROM sales WHERE id = 10;
```
Результат: `NULL | NULL | 0 | 1`. Тобто `SUM` і `AVG` над порожньою (з погляду значень) множиною дають `NULL` («немає даних»), а `COUNT(колонка)` — 0. Якщо потрібен нуль, пишуть `COALESCE(SUM(client_id), 0)`.
