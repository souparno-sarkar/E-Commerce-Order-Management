-- Reporting queries for E-Commerce Order Management System

-- 1. Total revenue (successful payments) in a date range
-- Params: :start_date, :end_date
SELECT DATE(p.created_at) AS day, SUM(p.amount) AS revenue
FROM payments p
WHERE p.payment_status = 'SUCCESS' AND p.created_at BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY DATE(p.created_at)
ORDER BY day;

-- 2. Top selling products (by quantity) in last 30 days
SELECT oi.product_id, pr.name, SUM(oi.quantity) AS total_qty
FROM order_items oi
JOIN products pr ON pr.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY oi.product_id
ORDER BY total_qty DESC
LIMIT 10;

-- 3. User order history with payment statuses
SELECT o.order_id, o.user_id, u.full_name, o.total_amount, o.status AS order_status,
       p.payment_status, p.payment_method, p.amount AS paid_amount, o.created_at
FROM orders o
LEFT JOIN users u ON u.user_id = o.user_id
LEFT JOIN payments p ON p.order_id = o.order_id
WHERE o.user_id = 1
ORDER BY o.created_at DESC;

-- 4. Pending payments (orders marked PENDING but no successful payment)
SELECT o.order_id, o.user_id, o.total_amount, o.created_at
FROM orders o
LEFT JOIN payments p ON p.order_id = o.order_id AND p.payment_status = 'SUCCESS'
WHERE p.payment_id IS NULL AND o.status = 'PENDING';

-- 5. Average order value (AOV)
SELECT AVG(total_amount) AS average_order_value FROM orders WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 6. Inventory low-stock alert (stock <= threshold)
SELECT product_id, name, stock FROM products WHERE stock <= 10 ORDER BY stock ASC;

-- 7. Sales by product with revenue
SELECT pr.product_id, pr.name, SUM(oi.quantity) AS qty_sold, SUM(oi.unit_price * oi.quantity) AS revenue
FROM order_items oi
JOIN products pr ON pr.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.created_at >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
GROUP BY pr.product_id
ORDER BY revenue DESC;

-- End of reports.sql
