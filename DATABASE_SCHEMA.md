# StockiFy Database Schema

## Overview
This database schema uses `user_id` directly for all user-related data. There is **no `business_id`** - everything is tied to individual users.

## Database Configuration
- **Database Name**: `u161640253_stockify`
- **Host**: `localhost`
- **Username**: `u161640253_stockify`
- **Password**: `Stockify2025`
- **Charset**: `utf8mb4`

## Tables

### 1. `users`
Stores user accounts.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `email` | varchar(255) | Unique email address |
| `password_hash` | text | Hashed password (bcrypt/Argon2id) |
| `full_name` | varchar(255) | User's full name |
| `created_at` | timestamp | Account creation time |
| `updated_at` | timestamp | Last update time |

**Indexes**: `PRIMARY KEY (id)`, `UNIQUE KEY (email)`

---

### 2. `sessions`
Stores active user sessions/tokens.

| Column | Type | Description |
|--------|------|-------------|
| `id` | varchar(36) | UUID v4 session ID |
| `user_id` | bigint(20) UNSIGNED | Foreign key to `users.id` |
| `token` | varchar(64) | 64-character session token |
| `ip_address` | varchar(45) | User's IP address |
| `user_agent` | text | Browser/user agent string |
| `expires_at` | datetime | Token expiration (7 days) |
| `created_at` | timestamp | Session creation time |

**Indexes**: `PRIMARY KEY (id)`, `UNIQUE KEY (token)`, `KEY (user_id)`, `KEY (expires_at)`

**Foreign Keys**: `user_id` → `users.id` (CASCADE DELETE)

---

### 3. `login_attempts`
Tracks failed login attempts for rate limiting.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `email` | varchar(255) | Email used in attempt |
| `ip_address` | varchar(45) | IP address of attempt |
| `attempted_at` | timestamp | Time of attempt |

**Indexes**: `PRIMARY KEY (id)`, `KEY (email)`, `KEY (ip_address)`, `KEY (attempted_at)`

---

### 4. `products`
Stores product inventory.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `user_id` | bigint(20) UNSIGNED | Foreign key to `users.id` |
| `sku` | varchar(255) | Stock Keeping Unit |
| `barcode` | varchar(255) | Unique barcode (UNIQUE) |
| `name` | varchar(255) | Product name |
| `description` | text | Product description |
| `image_url` | text | Product image URL |
| `cost_price` | decimal(10,2) | Cost price |
| `selling_price` | decimal(10,2) | Selling price |
| `stock_quantity` | int(11) | Current stock quantity |
| `low_stock_threshold` | int(11) | Low stock alert threshold |
| `expiry_date` | date | Product expiry date |
| `is_deleted` | tinyint(1) | Soft delete flag |
| `last_updated_at` | timestamp | Last update time |

**Indexes**: `PRIMARY KEY (id)`, `UNIQUE KEY (barcode)`, `KEY (user_id)`

**Foreign Keys**: `user_id` → `users.id` (CASCADE DELETE)

---

### 5. `orders`
Stores sales orders.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `user_id` | bigint(20) UNSIGNED | Foreign key to `users.id` |
| `order_number` | varchar(255) | Unique order number |
| `total_amount` | decimal(10,2) | Total order amount |
| `status` | enum('completed','refunded') | Order status |
| `payment_method` | enum('cash','card') | Payment method |
| `created_at` | timestamp | Order creation time |

**Indexes**: `PRIMARY KEY (id)`, `UNIQUE KEY (order_number)`, `KEY (user_id)`

**Foreign Keys**: `user_id` → `users.id` (CASCADE DELETE)

---

### 6. `order_items`
Stores order line items.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `order_id` | bigint(20) UNSIGNED | Foreign key to `orders.id` |
| `product_id` | bigint(20) UNSIGNED | Foreign key to `products.id` (nullable) |
| `product_name` | varchar(255) | Product name (snapshot) |
| `product_sku` | varchar(255) | Product SKU (snapshot) |
| `quantity` | int(11) | Quantity ordered |
| `unit_price` | decimal(10,2) | Price per unit |
| `subtotal` | decimal(10,2) | Line total |
| `created_at` | timestamp | Item creation time |

**Indexes**: `PRIMARY KEY (id)`, `KEY (order_id)`, `KEY (product_id)`

**Foreign Keys**: 
- `order_id` → `orders.id` (CASCADE DELETE)
- `product_id` → `products.id` (SET NULL on delete)

---

### 7. `plans`
Stores subscription plans.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `name` | varchar(100) | Plan name |
| `price` | decimal(10,2) | Plan price |
| `interval` | enum('month','year') | Billing interval |

**Indexes**: `PRIMARY KEY (id)`

**Sample Data**:
- Starter: 0.00 DZD/month
- Growth: 2500.00 DZD/month
- Unlimited: 30000.00 DZD/year

---

### 8. `plan_limits`
Stores plan feature limits.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `plan_id` | bigint(20) UNSIGNED | Foreign key to `plans.id` |
| `limit_key` | enum('max_products','max_orders') | Limit type |
| `limit_value` | int(11) | Limit value |

**Indexes**: `PRIMARY KEY (id)`, `UNIQUE KEY (plan_id, limit_key)`

**Foreign Keys**: `plan_id` → `plans.id` (CASCADE DELETE)

---

### 9. `subscriptions`
Stores user subscriptions.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `user_id` | bigint(20) UNSIGNED | Foreign key to `users.id` |
| `plan_id` | bigint(20) UNSIGNED | Foreign key to `plans.id` |
| `status` | enum('active','canceled','past_due') | Subscription status |
| `current_period_end` | datetime | Current period end date |
| `payment_method_last4` | varchar(10) | Last 4 digits of payment method |
| `created_at` | timestamp | Subscription creation time |

**Indexes**: `PRIMARY KEY (id)`, `KEY (user_id)`, `KEY (plan_id)`

**Foreign Keys**: 
- `user_id` → `users.id` (CASCADE DELETE)
- `plan_id` → `plans.id`

---

### 10. `invoices`
Stores billing invoices.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `subscription_id` | bigint(20) UNSIGNED | Foreign key to `subscriptions.id` |
| `amount` | decimal(10,2) | Invoice amount |
| `status` | enum('paid','failed') | Payment status |
| `pdf_url` | text | Invoice PDF URL |
| `created_at` | timestamp | Invoice creation time |

**Indexes**: `PRIMARY KEY (id)`, `KEY (subscription_id)`

**Foreign Keys**: `subscription_id` → `subscriptions.id` (CASCADE DELETE)

---

### 11. `notifications`
Stores user notifications.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `user_id` | bigint(20) UNSIGNED | Foreign key to `users.id` |
| `type` | enum('low_stock','expiry','system') | Notification type |
| `title` | varchar(255) | Notification title |
| `message` | text | Notification message |
| `is_read` | tinyint(1) | Read status (0/1) |
| `created_at` | timestamp | Notification creation time |

**Indexes**: `PRIMARY KEY (id)`, `KEY (user_id)`

**Foreign Keys**: `user_id` → `users.id` (CASCADE DELETE)

---

### 12. `activity_logs`
Stores user activity logs.

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint(20) UNSIGNED | Primary key, auto-increment |
| `user_id` | bigint(20) UNSIGNED | Foreign key to `users.id` |
| `action` | varchar(255) | Action performed |
| `details` | text | Action details (JSON) |
| `created_at` | timestamp | Log creation time |

**Indexes**: `PRIMARY KEY (id)`, `KEY (user_id)`

**Foreign Keys**: `user_id` → `users.id` (SET NULL on delete)

---

## Relationships

```
users (1) ──< (many) sessions
users (1) ──< (many) products
users (1) ──< (many) orders
users (1) ──< (many) subscriptions
users (1) ──< (many) notifications
users (1) ──< (many) activity_logs

orders (1) ──< (many) order_items
products (1) ──< (many) order_items

plans (1) ──< (many) plan_limits
plans (1) ──< (many) subscriptions

subscriptions (1) ──< (many) invoices
```

---

## Sample Data

### Default User
- **Email**: `admin@stockify.com`
- **Password**: `admin123`
- **Password Hash**: `$2y$10$yYZCtieUTPszEyPCBdvth.eAtG20qWi.nH3cw97TSusChpG3mR1bO`

### Plans
1. **Starter**: Free, 50 products, 100 orders/month
2. **Growth**: 2500 DZD/month, 1000 products, 5000 orders/month
3. **Unlimited**: 30000 DZD/year, 10000 products, 50000 orders/month

---

## Installation

1. Import the SQL file:
   ```bash
   mysql -u u161640253_stockify -p u161640253_stockify < stockify_database_schema.sql
   ```

2. Or via phpMyAdmin:
   - Select database `u161640253_stockify`
   - Go to "Import" tab
   - Upload `stockify_database_schema.sql`
   - Click "Go"

---

## Notes

- All tables use `utf8mb4` charset for full Unicode support
- Foreign keys use appropriate CASCADE/SET NULL rules
- `barcode` in `products` is UNIQUE globally (not per user)
- `order_items` stores product snapshots (name, SKU) for historical accuracy
- Soft delete is used for products (`is_deleted` flag)
- Sessions expire after 7 days

