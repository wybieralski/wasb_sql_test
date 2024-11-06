USE memory.default;

WITH RECURSIVE Hierarchy (employee_id, manager_id, path) AS (
    SELECT
        employee_id,
        manager_id,
        ARRAY[CAST(employee_id AS VARCHAR)] AS path
    FROM
        memory.default.EMPLOYEE

    UNION ALL


    SELECT
        h.employee_id,
        m.manager_id,
        h.path || CAST(m.employee_id AS VARCHAR)
    FROM
        Hierarchy h
        JOIN memory.default.EMPLOYEE m ON h.manager_id = m.employee_id
    WHERE
        NOT contains(h.path, CAST(m.employee_id AS VARCHAR))
)
SELECT
    employee_id,
    array_join(path, ' -> ') AS cycle
FROM
    Hierarchy
WHERE
    contains(path, CAST(manager_id AS VARCHAR));