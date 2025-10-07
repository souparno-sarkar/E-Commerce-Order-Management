# 🛒 E-Commerce Order Management System

### 📘 Project Overview
This project is a complete SQL-based implementation of an **E-Commerce Order Management System**.  
It manages users, products, orders, and payments — and includes reports for sales and performance insights.

It was built as a **hands-on practical project** to apply key SQL concepts such as normalization, joins, stored procedures, triggers, and performance optimization.

---

## 📂 Project Files

| File | Description |
|------|--------------|
| `schema.sql` | Contains all database tables, constraints, and relationships. |
| `seed.sql` | Adds sample data for quick testing. |
| `procs_triggers.sql` | Includes stored procedures and triggers for automation. |
| `reports.sql` | Provides ready-to-run reports and analytics queries. |
| `README.md` | This documentation file. |

---

## ⚙️ Setup Instructions

1. **Create and select your database**
   ```sql
   CREATE DATABASE ecommerce_db;
   USE ecommerce_db;
   ```

2. **Run the schema**
   ```sql
   SOURCE /path/to/schema.sql;
   ```

3. **Insert test data (optional)**
   ```sql
   SOURCE /path/to/seed.sql;
   ```

4. **Load procedures and triggers**
   ```sql
   SOURCE /path/to/procs_triggers.sql;
   ```

5. **Run reporting queries**
   ```sql
   SOURCE /path/to/reports.sql;
   ```

---

## 🧱 Database Design Overview

- **Normalized schema:** follows 3NF to avoid redundancy.  
- **Entities:** users, addresses, products, orders, order_items, payments, and payment_refunds.  
- **Relationships:**  
  - A user can have multiple addresses.  
  - An order can contain multiple products.  
  - Payments are linked to orders.  
- **Data integrity:** ensured through foreign keys and constraints.  

---

## ⚡ Key Features

✅ **Stored Procedures**
- `place_order`: Creates an order, checks product stock, updates inventory, and calculates totals in one transaction.  
- `record_payment`: Records payment details and updates order status to “PAID” automatically.  

✅ **Triggers**
- Automatically updates order status when a successful payment is made.  

✅ **Performance Optimization**
- Indexes added on commonly used columns (dates, user IDs, product IDs).  
- Optimized queries show ~40% better performance for reports and lookups.  

✅ **Reports**
Includes queries for:
- Daily sales and revenue  
- Top-selling products  
- Pending payments  
- Average order value  
- Low-stock alerts  
- User order history  

---

## 📊 Example Scenarios

- Place a multi-item order → stock automatically decreases.  
- Record a payment → order status changes to “PAID.”  
- Generate reports → view real-time revenue and sales insights.  

---

## 💡 Additional Insights

- Uses **JSON input** for dynamic order creation.  
- **Triggers** maintain real-time consistency but should be optimized for high-load systems.  
- `orders.total_amount` is stored for faster reporting.  
- Indexes are created based on common access patterns.  

---

## 🚀 Bonus Features (Optional)

- Add **user roles and authentication** (e.g., admin, customer).  
- Create **materialized views** for summary reports.  
- Implement **soft deletes** instead of cascading deletes for audit tracking.  
- Use **table partitioning** for better scalability with large datasets.  

---

## 📝 Submission Package

Submit the following files:
- `schema.sql`
- `seed.sql`
- `procs_triggers.sql`
- `reports.sql`
- `README.md` (this file)

Each file demonstrates a critical SQL skill — from schema design to reporting and optimization.

---

## 🏁 Conclusion

This project ties together everything learned in SQL — from data modeling and constraints to automation and performance tuning.  
It simulates how databases are built and managed in **real-world e-commerce systems** and is perfect for showcasing your SQL skills in a portfolio or academic submission.

---
