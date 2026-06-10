use Supply_Chain_Inventory_db;

select * from categories;
select * from suppliers;
select * from products;
select * from warehouses;
select * from inventory;
select * from purchase_orders_items;
select * from sales_orders_items;
select * from shipments;
select * from returns;

-- 1. Total Revenue
SELECT
    SUM(soi.quantity * p.selling_price) AS Total_Revenue
FROM sales_orders_items soi
JOIN products p
ON soi.product_id = p.product_id;

-- 2. Total Orders
SELECT COUNT(DISTINCT soi_id) AS Total_Orders
FROM sales_orders_items;

-- 3. Revenue by Category
SELECT
    c.category_name,
    SUM(soi.quantity * p.selling_price) AS Total_Revenue
FROM sales_orders_items soi
JOIN products p ON soi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Total_Revenue DESC;

-- 4. Top 5 Best Selling Products
SELECT
    p.product_name,
    SUM(soi.quantity) AS Units_Sold
FROM sales_orders_items soi
JOIN products p ON soi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Units_Sold DESC
LIMIT 5;

-- 5. Shipment Status Analysis
SELECT
    shipment_status,
    COUNT(*) AS Total_Shipments
FROM shipments
GROUP BY shipment_status;

-- 6. Low Stock Products
SELECT
    p.product_name,
    i.available_stock,
    i.reorder_level
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.available_stock < i.reorder_level;

-- 7. Returns Analysis
SELECT
    reason,
    COUNT(*) AS Return_Count
FROM returns
GROUP BY reason
ORDER BY Return_Count DESC;

-- 8. Supplier Performance
SELECT
    s.supplier_name,
    COUNT(poi.poi_id) AS Total_Orders
FROM purchase_orders_items poi
JOIN suppliers s ON poi.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY Total_Orders DESC;

-- 9. Category-wise Order Distribution
SELECT
    c.category_name,
    COUNT(*) AS Order_Count
FROM sales_orders_items soi
JOIN products p ON soi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Order_Count DESC;
