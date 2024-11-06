USE memory.default;

-- DROP TABLE memory.default.INVOICE;

CREATE TABLE memory.default.INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8,2),
    due_date DATE
);

-- DROP TABLE memory.default.SUPPLIER;


CREATE TABLE memory.default.SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

INSERT INTO memory.default.SUPPLIER (supplier_id, name) VALUES
(1, 'Catering Plus'),
(2, 'Dave''s Discos'),
(3, 'Entertainment tonight'),
(4, 'Ice Ice Baby'),
(5, 'Party Animals');

INSERT INTO memory.default.INVOICE (supplier_id, invoice_amount, due_date) VALUES
(1, 2000.00, DATE '2025-01-31'),
(1, 1500.00, DATE '2025-02-28'),
(2, 500.00, DATE '2024-12-31'),
(3, 6000.00, DATE '2025-02-28'),
(4, 4000.00, DATE '2025-04-30'),
(5, 6000.00, DATE '2025-02-28');