-- Seed data for E-Commerce Order Management System
-- Minimal test data for demonstration

-- Users
INSERT INTO users (email, password_hash, full_name, phone)
VALUES
('alice@example.com', 'hash_alice', 'Alice Cooper', '+911234567890'),
('bob@example.com', 'hash_bob', 'Bob Marley', '+911234567891');

-- Addresses
INSERT INTO addresses (user_id, label, street, city, state, postal_code, country)
VALUES
(1, 'Home', '123 Main St', 'Kolkata', 'West Bengal', '700001', 'India'),
(2, 'Office', '456 Market Rd', 'Mumbai', 'Maharashtra', '400001', 'India');

-- Products
INSERT INTO products (sku, name, description, price, stock)
VALUES
('SKU-001', 'Wireless Mouse', 'Ergonomic wireless mouse', 599.00, 150),
('SKU-002', 'Mechanical Keyboard', 'Compact mechanical keyboard', 2499.00, 75),
('SKU-003', 'USB-C Charger', 'Fast charger 45W', 1299.00, 200);

-- Orders
INSERT INTO orders (user_id, address_id, total_amount, status)
VALUES
(1, 1, 1198.00, 'PENDING'),
(2, 2, 2499.00, 'PENDING');

-- Order items
INSERT INTO order_items (order_id, product_id, unit_price, quantity)
VALUES
(1, 1, 599.00, 2),
(2, 2, 2499.00, 1);

-- Payments
INSERT INTO payments (order_id, payment_method, amount, payment_status, transaction_reference)
VALUES
(1, 'CARD', 1198.00, 'SUCCESS', 'TXN1001'),
(2, 'UPI', 2499.00, 'INITIATED', 'TXN1002');

-- End of seed.sql
