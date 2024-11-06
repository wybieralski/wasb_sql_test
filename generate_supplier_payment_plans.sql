USE memory.default;

-- STEPS I TOOK - thought process:
--       1. Count the number of 'payments' (instalments) for each supplier.
--       2. Divide all invoices into payments
--       3. Aggregate payments per supplier for each month
--       4. Set payment_date (last day of each consecutive month until payment month)
--       5. Join with SUPPLIER table to get supplier names.
--       6. Optimise code using CTE to improve readability and reusability

-- Get data about invoices
WITH invoice_data AS (
    SELECT
        supplier_id,
        invoice_amount,
        due_date,
        date_diff('month', current_date, due_date) AS months_until_due,
        current_date
    FROM memory.default.INVOICE
), -- Generate payment schedule
     payment_schedule AS (
         SELECT
             supplier_id,
             invoice_amount / months_until_due AS monthly_payment,
             last_day_of_month(date_add('month', month_index - 1, current_date)) AS payment_date
         FROM invoice_data
                  CROSS JOIN UNNEST(sequence(1, months_until_due)) AS t(month_index)
     ), -- Aggregate monthly payments for each supplier
     monthly_totals AS (
         SELECT
             supplier_id,
             payment_date,
             SUM(monthly_payment) AS total_monthly_payment,
             SUM(SUM(monthly_payment)) OVER (PARTITION BY supplier_id) AS total_amount
         FROM payment_schedule
         GROUP BY supplier_id, payment_date
     )

-- Generate balance_outstanding (left to pay after each payment) and join table SUPPLIERS to get supplier names
SELECT
    monthly_totals.supplier_id,
    suppliers.name AS supplier_name,
    monthly_totals.total_monthly_payment AS payment_amount,
    GREATEST(monthly_totals.total_amount - SUM(monthly_totals.total_monthly_payment) OVER (
        PARTITION BY monthly_totals.supplier_id
        ORDER BY monthly_totals.payment_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 0) AS balance_outstanding,
    monthly_totals.payment_date
FROM monthly_totals
         JOIN memory.default.SUPPLIER AS suppliers ON monthly_totals.supplier_id = suppliers.supplier_id
ORDER BY monthly_totals.supplier_id, monthly_totals.payment_date;
