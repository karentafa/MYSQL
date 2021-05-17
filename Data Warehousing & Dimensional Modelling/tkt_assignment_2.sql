 /*
 STRATEGIC
 */
 
#1 . Total revenue per month for April, May, and June in 2005.

#BRYAN assisted me with this code so i got an idea of what to do 
SELECT
    dim_date.MonthName,
    SUM(purchase_fact.DAILY_REVENUE)
             AS 'TOTAL_REVENUE'
FROM dim_date
        JOIN purchase_fact
        ON dim_date.SALEDATE = purchase_fact.SALEDATE
WHERE
    dim_date.MonthName IN ('April' , 'May', 'June')
        AND dim_date.Year = '2005'
GROUP BY dim_date.MonthName , dim_date.Year;


 #2 . Total purchase count per month for April, May, and June in 2005.  Return the month name and the month's total purchase count.
 
 SELECT
    dim_date.MonthName,
    SUM(purchase_fact.DAILY_QUANTITY)
             AS 'Total Purchase Count'
FROM dim_date
        JOIN purchase_fact
        ON dim_date.SALEDATE = purchase_fact.SALEDATE
WHERE
    dim_date.MonthName IN ('April' , 'May', 'June')
        AND dim_date.Year = '2005'
GROUP BY dim_date.MonthName , dim_date.Year;

#3 . Total profit per month for April, May, and June in 2005. Return the month name and the month's total profit.
 
 SELECT
    dim_date.MonthName,
    SUM(purchase_fact.DAILY_PROFIT)
             AS 'Total Profit'
FROM dim_date
        JOIN purchase_fact
        ON dim_date.SALEDATE = purchase_fact.SALEDATE
WHERE
    dim_date.MonthName IN ('April' , 'May', 'June')
        AND dim_date.Year = '2005'
GROUP BY dim_date.MonthName , dim_date.Year;
 
  /*
 OPERATIONAL
 */
 
 #1. Average revenue per transaction from April 1, 2005 to April 30, 2005 for stores in Texas.  Return the date and the average revenue per transaction for the date.
 
  SELECT
    dim_date.SALEDATE,
    SUM(purchase_fact.AVERAGE_DAILY_REVENUE)
             AS 'AVERAGE REVENUE'
FROM dim_date
        JOIN purchase_fact
			ON dim_date.SALEDATE = purchase_fact.SALEDATE
        JOIN store_dim
			ON purchase_fact.STORE = store_dim.STORE
WHERE
    dim_date.MonthName = 'April'
        AND dim_date.Year = '2005'
        AND store_dim.STATE = 'TX'
GROUP BY dim_date.SALEDATE, dim_date.Year;
 
 #2 . Daily purchase count for a given department from April 7, 2005 to April 14, 2005. Return the date and the date's purchase count.  You can test the query with any of the departments.
 
   SELECT
    dim_date.SALEDATE,
    SUM(purchase_fact.DAILY_QUANTITY)
             AS 'Purchase Count for DEPT 6505 '
FROM dim_date
        JOIN purchase_fact
			ON dim_date.SALEDATE = purchase_fact.SALEDATE
        JOIN sku_dim
			ON purchase_fact.SKU = sku_dim.SKU
WHERE
    dim_date.SALEDATE between '2005-04-07' AND '2005-04-14' 
    AND sku_dim.DEPT= 6505
GROUP BY dim_date.SALEDATE;
 
 #3 The 5 lowest performing stores for April 1, 2005 to April 30, 2005 based on purchase revenue. Return the store ID and the store's total revenue for the entire date range.
 
    SELECT
    store_dim.STORE,
    SUM(purchase_fact.DAILY_REVENUE)
             AS 'Total_Revenue'
FROM dim_date
        JOIN purchase_fact
			ON dim_date.SALEDATE = purchase_fact.SALEDATE
        JOIN store_dim
			ON purchase_fact.STORE = store_dim.STORE
WHERE
    dim_date.MonthName = 'April'
GROUP BY store_dim.STORE
ORDER BY Total_Revenue ASC
LIMIT 5; 

 
  /*
 ANALYTICAL
 */
 
 #1 Top 10 SKUs based on quantity sold for May 7, 2005 to May 14, 2005. Return the SKU and the quantity sold for the SKU.
 
     SELECT
    purchase_fact.SKU,
    SUM(purchase_fact.DAILY_QUANTITY)
             AS 'Quantity_Sold'
FROM dim_date
        JOIN purchase_fact
			ON dim_date.SALEDATE = purchase_fact.SALEDATE
        JOIN sku_dim
			ON purchase_fact.SKU = sku_dim.SKU
WHERE
    dim_date.SALEDATE between '2005-05-07' AND '2005-05-14' 
GROUP BY purchase_fact.SKU
ORDER BY  Quantity_Sold DESC
LIMIT 10; 

 
 
 #2. Top 3 department and city combinations based on revenue for December 1, 2004 to December 31, 2004. Return the department and city and the revenue for the department and city combination
 
    SELECT sku_dim.DEPT, store_dim.CITY,
    SUM(purchase_fact.DAILY_REVENUE)
             AS 'Total_Revenue'
FROM dim_date
        JOIN purchase_fact
			ON dim_date.SALEDATE = purchase_fact.SALEDATE
        JOIN sku_dim
			ON purchase_fact.SKU = sku_dim.SKU
		JOIN store_dim
			ON purchase_fact.STORE = store_dim.STORE
WHERE
    dim_date.SALEDATE between '2004-12-01' AND '2004-12-31' 
GROUP BY sku_dim.DEPT, store_dim.CITY
ORDER BY  Total_Revenue DESC
LIMIT 3; 
 
 
 #3. The number of returned items (STYPE = 'R') for each day of the week for June 2005. Return the day of the week name, i.e. Monday, Thursday, etc. and its returned items total.
 
      SELECT
    dim_date.DayOfWeek,
    SUM(returns_fact.return_quantity)
             AS 'Quantity_Returned'
FROM dim_date
        JOIN returns_fact
			ON dim_date.SALEDATE = returns_fact.SALEDATE
WHERE
    dim_date.MonthName = 'June' AND dim_date.Year = 2005
GROUP BY dim_date.DayOfWeek;

 
 