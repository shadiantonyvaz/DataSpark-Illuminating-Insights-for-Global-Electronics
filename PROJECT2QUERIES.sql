-- 1. Total Sales by Product
-- Description: Calculates the total quantity sold and total sales revenue for each product.
SELECT p.`Product Name`, 
       SUM(s.Quantity) AS TotalQuantitySold, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.`Product Name`;


-- 2. Average Sales Quantity per Store
-- Description: Computes the average quantity sold per store.
SELECT s.StoreKey, 
       AVG(s.Quantity) AS AverageQuantitySold
FROM Sales s
GROUP BY s.StoreKey;

-- 3. Top 5 Products by Total Sales
-- Description: Retrieves the top 5 products based on total sales revenue.
SELECT p.`Product Name`, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.`Product Name`
ORDER BY TotalSales DESC
LIMIT 5;

-- 4. Customer Purchase Frequency
-- Description: Calculates how many times each customer made a purchase.
SELECT c.CustomerKey, 
       c.Name, 
       COUNT(s.`Order Number`) AS PurchaseCount
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.CustomerKey, c.Name;

-- 5. Sales by Country
-- Description: Computes total sales revenue by country.
SELECT c.Country, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalSales
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY c.Country;

-- 6. Products with the Highest Unit Cost
-- Description: Lists products with the highest unit cost.
SELECT `Product Name`, 
       `Unit Cost USD`
FROM Products
ORDER BY `Unit Cost USD` DESC
LIMIT 10;

-- 7. Sales Trends Over Time
-- Description: Examines total sales per year.
SELECT EXTRACT(YEAR FROM CAST(s.`Order Date` AS DATE)) AS Year, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY EXTRACT(YEAR FROM CAST(s.`Order Date` AS DATE))
ORDER BY Year;



-- 8. Customer Distribution by Continent
-- Description: Shows the number of customers in each continent.
SELECT c.Continent, 
       COUNT(c.CustomerKey) AS NumberOfCustomers
FROM Customers c
GROUP BY c.Continent;


-- 9. Average Exchange Rate per Currency
-- Description: Calculates the average exchange rate for each currency.
SELECT e.Currency, 
       AVG(e.Exchange) AS AverageExchangeRate
FROM ExchangeRates e
GROUP BY e.Currency;

-- 10. Stores with Most Recent Opening Date
-- Description: Finds the stores with the most recent opening dates.
SELECT StoreKey, 
       MAX(CAST(`Open Date` AS DATE)) AS MostRecentOpenDate
FROM Stores
GROUP BY StoreKey;


-- 11. Products Sold in the Last 30 Days
-- Description: Finds products that were sold in the last 30 days.
SELECT DISTINCT p.`Product Name`
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
WHERE CAST(s.`Order Date` AS DATE) >= CURRENT_DATE - INTERVAL 30 DAY;

-- 12. Orders with Delivery Delays
-- Description: Identifies orders where delivery was delayed by more than 7 days.
SELECT s.`Order Number`, 
       DATEDIFF(CAST(s.`Delivery Date` AS DATE), CAST(s.`Order Date` AS DATE)) AS DaysDelayed
FROM Sales s
WHERE DATEDIFF(CAST(s.`Delivery Date` AS DATE), CAST(s.`Order Date` AS DATE)) > 7;


-- 13. Products Not Sold in the Last Year
-- Description: Lists products that were not sold in the last year.
SELECT p.`Product Name`
FROM Products p
LEFT JOIN Sales s ON p.ProductKey = s.ProductKey
WHERE s.ProductKey IS NULL OR CAST(s.`Order Date` AS DATE) < CURRENT_DATE - INTERVAL 1 YEAR
GROUP BY p.`Product Name`;


-- 14. Sales Performance by Store
-- Description: Compares sales performance across different stores.
SELECT s.StoreKey, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalSales, 
       COUNT(DISTINCT s.`Order Number`) AS NumberOfOrders
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY s.StoreKey
ORDER BY TotalSales DESC;


-- 15. Customer Orders and Total Spend
-- Description: Shows the total amount spent by each customer.
SELECT c.CustomerKey, 
       c.Name, 
       SUM(s.Quantity * p.`Unit Price USD`) AS TotalSpent
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY c.CustomerKey, c.Name
ORDER BY TotalSpent DESC;