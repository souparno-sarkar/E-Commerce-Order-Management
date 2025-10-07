-- Stored Procedures, Functions, and Triggers

DELIMITER $$

-- Procedure: place_order
-- Inserts an order with items inside a transaction, decrements stock, and returns order_id
CREATE PROCEDURE place_order(
    IN p_user_id INT,
    IN p_address_id INT,
    IN p_items JSON, -- JSON array: [{ "product_id":1, "quantity":2 }, ...]
    OUT p_order_id INT
)
BEGIN
    DECLARE v_total DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_prod_id INT;
    DECLARE v_qty INT;
    DECLARE v_unit_price DECIMAL(10,2);
    DECLARE i INT DEFAULT 0;
    DECLARE arr_len INT;

    -- Start transaction
    START TRANSACTION;

    SET arr_len = JSON_LENGTH(p_items);
    IF arr_len IS NULL OR arr_len = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No items provided';
    END IF;

    -- compute total and check stock
    WHILE i < arr_len DO
        SET v_prod_id = JSON_EXTRACT(p_items, CONCAT('$[', i, '].product_id'));
        SET v_qty = JSON_EXTRACT(p_items, CONCAT('$[', i, '].quantity'));
        SELECT price, stock INTO v_unit_price, @stock FROM products WHERE product_id = v_prod_id FOR UPDATE;
        IF @stock IS NULL THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = CONCAT('Product not found: ', v_prod_id);
        END IF;
        IF @stock < v_qty THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = CONCAT('Insufficient stock for product ', v_prod_id);
        END IF;
        SET v_total = v_total + (v_unit_price * v_qty);
        SET i = i + 1;
    END WHILE;

    -- Insert order
    INSERT INTO orders (user_id, address_id, total_amount, status) VALUES (p_user_id, p_address_id, v_total, 'PENDING');
    SET p_order_id = LAST_INSERT_ID();

    -- Insert items and decrement stock
    SET i = 0;
    WHILE i < arr_len DO
        SET v_prod_id = JSON_EXTRACT(p_items, CONCAT('$[', i, '].product_id'));
        SET v_qty = JSON_EXTRACT(p_items, CONCAT('$[', i, '].quantity'));
        SELECT price INTO v_unit_price FROM products WHERE product_id = v_prod_id;
        INSERT INTO order_items (order_id, product_id, unit_price, quantity) VALUES (p_order_id, v_prod_id, v_unit_price, v_qty);
        -- decrement stock
        UPDATE products SET stock = stock - v_qty WHERE product_id = v_prod_id;
        SET i = i + 1;
    END WHILE;

    COMMIT;
END$$

-- Procedure: record_payment
-- Inserts a payment and, if successful, marks the order as PAID
CREATE PROCEDURE record_payment(
    IN p_order_id INT,
    IN p_method VARCHAR(20),
    IN p_amount DECIMAL(12,2),
    IN p_txn_ref VARCHAR(255),
    IN p_status VARCHAR(20)
)
BEGIN
    START TRANSACTION;
    INSERT INTO payments (order_id, payment_method, amount, payment_status, transaction_reference)
    VALUES (p_order_id, p_method, p_amount, p_status, p_txn_ref);
    IF p_status = 'SUCCESS' THEN
        UPDATE orders SET status = 'PAID', updated_at = NOW() WHERE order_id = p_order_id;
    END IF;
    COMMIT;
END$$

-- Trigger: after payment inserted, if payment is SUCCESS ensure order is PAID
CREATE TRIGGER trg_payments_after_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'SUCCESS' THEN
        UPDATE orders SET status = 'PAID', updated_at = NOW() WHERE order_id = NEW.order_id;
    END IF;
END$$

DELIMITER ;

-- End of procs_triggers.sql
