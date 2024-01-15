/*
Solving Challenges of (Top Five Things To Know In Advanced SQL( Course
*/


--- #1 SubQuery Challenge
--- List the following columns where in stoch value is less than the total average stock value
SELECT ProdCategory, ProdNumber, ProdName, [In Stock]
FROM Red30Tech..Inventory$
WHERE [In Stock] < (SELECT AVG([In Stock]) FROM Red30Tech..Inventory$)


	
--- #2 Solving This previous using CTE 
WITH AvgStock(AvgInStockValue) AS (
	SELECT AVG([In Stock]) FROM Red30Tech..Inventory$ 
)
SELECT ProdCategory, ProdNumber, ProdName,[In Stock]
FROM Red30Tech..Inventory$,AvgStock
WHERE [In Stock] < AvgInStockValue


	
---	#3 ROW_NUMBER()
--- Return the first 3 orders with the highest order total amount for each poduct category 
--- For Boehm Inc. Customer
WITH HighestOrderTotals
AS (
select OrderNum, OrderDate, CustName, ProdCategory, [Order Total],
ROW_NUMBER() OVER (PARTITION BY ProdCategory ORDER BY [Order Total] DESC) AS RowNum
FROM Red30Tech..OnlineRetailSales$
WHERE CustName='Boehm Inc.'
)
SELECT * 
FROM HighestOrderTotals
WHERE RowNum <= 3;



--- #4 LAG() AND LEAD()
--- List the quantities of the Last five order dates For Drones product category
SELECT *,  
		LAG(Quantity, 1) OVER (ORDER BY OrderDate DESC) AS LastDateQuantity_1,
		LAG(Quantity, 2) OVER (ORDER BY OrderDate DESC) AS LastDateQuantity_2,
		LAG(Quantity, 3) OVER (ORDER BY OrderDate DESC) AS LastDateQuantity_3,
		LAG(Quantity, 4) OVER (ORDER BY OrderDate DESC) AS LastDateQuantity_4,
		LAG(Quantity, 5) OVER (ORDER BY OrderDate DESC) AS LastDateQuantity_5
FROM  (
		SELECT OrderDate, SUM(Quantity) AS Quantity
		FROM Red30Tech..OnlineRetailSales$
		WHERE ProdCategory='Drones'
		GROUP BY OrderDate		
		) AS QuantityPerDay



--- #5 RANK() AND DENSE_RANK()
--- Rank first 3 Attendees in each state 
WITH FirstAttendes AS(
		SELECT [Registration Date], Email, State,
			DENSE_RANK() OVER (PARTITION BY State ORDER BY [Registration Date] ) AS DesneRank
		FROM Red30Tech..ConventionAttendees$
)
SELECT * 
FROM FirstAttendes
WHERE DesneRank <= 3
