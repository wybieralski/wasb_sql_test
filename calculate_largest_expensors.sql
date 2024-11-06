USE memory.default;

WITH EmployeeExpenses AS (
    SELECT
        employee_id,
        SUM(unit_price * quantity) AS total_expensed_amount
    FROM
        memory.default.EXPENSE
    GROUP BY
        employee_id
    HAVING
        SUM(unit_price * quantity) > 1000
)
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.manager_id,
    m.first_name || ' ' || m.last_name AS manager_name,
    ee.total_expensed_amount
FROM
    memory.default.EMPLOYEE e
    JOIN EmployeeExpenses ee ON e.employee_id = ee.employee_id
    LEFT JOIN memory.default.EMPLOYEE m ON e.manager_id = m.employee_id
ORDER BY
    ee.total_expensed_amount DESC;