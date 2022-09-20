--05/02/2022 --

use Essential;

/*SELECT COUNT(*) FROM PurchaseTrans

SELECT COUNT(*) as TotalCount FROM PurchaseTrans

SELECT COUNT() as TotalCount FROM Employee

SELECT COUNT(distinct LastName) as TotalEmp FROM Employee

SELECT COUNT(distinct t.Employee) as TotalCount FROM PurchaseTrans t

SELECT avg(distinct OrderQty) as AvgOrder FROM PurchaseTrans
SELECT avg(OrderQty) as AvgOrder FROM PurchaseTrans

SELECT COUNT(distinct OrderQty) as AvgOrder FROM PurchaseTrans
SELECT COUNT(OrderQty) as AvgOrder FROM PurchaseTrans

SELECT SUM(distinct OrderQty) as AvgOrder FROM PurchaseTrans
SELECT SUM(OrderQty) as AvgOrder FROM PurchaseTrans


SELECT MAX(distinct OrderQty) as MaximumUniqueOrderQty FROM PurchaseTrans
SELECT MAX(OrderQty) as MaximumOrderQty FROM PurchaseTrans

SELECT MIN(distinct OrderQty) as MinimumOrderQty FROM PurchaseTrans
SELECT MIN(OrderQty) as MinimumOrderQty FROM PurchaseTrans

SELECT MAX(Supplier) as MaximumOrderQty FROM PurchaseTrans
SELECT MIN(Supplier) as MinimumOrderQty FROM PurchaseTrans
*/

--GROUP BY FUNCTION
SELECT Country, OrderQty FROM PurchaseTrans
GROUP BY Country, OrderQty

--Using an aggregate function
SELECT Country, sum (OrderQty) as SumOfOrderQty FROM PurchaseTrans
GROUP BY Country

SELECT Country, count (OrderQty) as SumOfOrderQty FROM PurchaseTrans
GROUP BY Country

/* Return the grouping sets, rollup of subtotal and total quantity by Country and class of PurchaseTrans dataset */
SELECT Country,Class,SUM(OrderQty) as SumOfOrderQty 
FROM PurchaseTrans
GROUP BY GROUPING SETS(ROLLUP(Country, Class)) ORDER BY Country

SELECT Country,SUM(Distinct OrderQty) as SumOfOrderQty FROM PurchaseTrans GROUP BY Country
SELECT Country,SUM(Distinct OrderQty) as SumOfOrderQty FROM PurchaseTrans GROUP BY Country HAVING SUM(Distinct OrderQty)>100

/* Return the SUM of DINSTICT order quantity value, count of order quantity, Having Sum of Distinct order quantity multiples by quantity 
greater than 10, Group By Country in the PurchaseTrans*/
SELECT Country,SUM(Distinct OrderQty) as SumOfOrderQty, COUNT(*) as CountofOrderQty, COUNT(DISTINCT OrderQty * UnitPrice) as OU FROM PurchaseTrans 
GROUP BY Country HAVING COUNT(Distinct OrderQty * UnitPrice)>10

/* Return the SUM of DINSTICT order quantity value, count of order quantity and sum of order quantity multiples by unit price,
Having Count of Distinct order quantity multiples by quantity greater than 10 AND sum of order quantity multiplies by unit price
greater than 2000 GROUP BY Country in the PurchaseTrans dataset*/

SELECT Country, SUM(DISTINCT OrderQty) as SumOrderQty, COUNT(OrderQty) as CountOrderQty, SUM(OrderQty*UnitPrice) as SumOrderPrice 
FROM  PurchaseTrans
GROUP BY Country 
Having COUNT(Distinct OrderQty*OrderQty)>10 AND SUM(OrderQty*UnitPrice)>2000


Select OrderQty, UnitPriceDiscount, Employee, Color, Class, Country From PurchaseTrans

-- Grouping by Country and class
SELECT Country, Class, SUM(DISTINCT OrderQty) as SumOrderQty, COUNT(OrderQty) as CountOrderQty, SUM(OrderQty*UnitPrice) as SumOrderPrice 
FROM  PurchaseTrans
GROUP BY Country, Class 
Having COUNT(Distinct OrderQty*OrderQty)>10 AND SUM(OrderQty*UnitPrice)>2000


/*Return the SUM of DISTINCT order quantity value, count of order quantity, Having Sum of Distinct order quantity multiples by
quantity greater than 10, GROUP BY Country in the PurchaseTrans dataset*/

SELECT Country, SUM(DISTINCT OrderQty) as SumofUniqueOrderQty, COUNT(OrderQty) as CountofOrderQty FROM PurchaseTrans
GROUP BY Country 
HAVING SUM(DISTINCT OrderQty*UnitPrice)> 10


/*Return the SUM of DISTINCT order quantity value, count of order quantity and sum of order quantity multiplies by unit price,
Having Count of Distinct order quantity multiples by quantity greater than 10 AND sum of order quantity multiples by unit price
greater than 2000 GROUP BY Country in the PurchaseTrans dataset*/

SELECT Country, SUM(DISTINCT OrderQty) AS SUMofUniqueOrderQty, COUNT(OrderQty) as CountofOrderQty, SUM(OrderQty* UnitPrice) as PurchaseAmount
FROM PurchaseTrans
GROUP BY Country 
HAVING COUNT(DISTINCT OrderQty*UnitPrice)>10 AND SUM(OrderQty*UnitPrice)> 2000

--Using ORDER BY Function
/*SELECT Country, SUM(DISTINCT OrderQty) AS SUMofUniqueOrderQty, COUNT(OrderQty) as CountofOrderQty, SUM(OrderQty* UnitPrice) as PurchaseAmount
FROM PurchaseTrans
GROUP BY Country 
HAVING COUNT(DISTINCT OrderQty*UnitPrice)>10 AND SUM(OrderQty*UnitPrice)> 2000
ORDER BY Country

SELECT Country, SUM(DISTINCT OrderQty) AS SUMofUniqueOrderQty, COUNT(OrderQty) as CountofOrderQty, SUM(OrderQty* UnitPrice) as PurchaseAmount
FROM PurchaseTrans
GROUP BY Country 
HAVING COUNT(DISTINCT OrderQty*UnitPrice)>10 AND SUM(OrderQty*UnitPrice)> 2000
ORDER BY Country desc
*/

--Introduction to Data Manipulation Language Uncorrelated Sub Query using NOT IN

Select Productid From Product
where ProductID <10

Select * From PurchaseTrans
where ProductID IN (Select Productid From Product where ProductID <10)

/*Display dataset in PurchaseTransaction of productid in product dataset with productid less than 10*/
Select TransID, OrderID, AccountNumber, Supplier, Address, City, OrderQty*UnitPrice as PurchaseAmount
From PurchaseTrans
where ProductID IN (Select Productid From Product where ProductID <10)

/*Display dataset in PurchaseTransaction of productid NOT IN product dataset with productid less than
10*/
Select TransID, OrderID, ProductId AccountNumber, Supplier, Address, City, OrderQty*UnitPrice as PurchaseAmount
From PurchaseTrans
where ProductID NOT IN (Select ProductId From Product where ProductID <10)

/*Display dataset in PurchaseTransaction and derives ProductName in product dataset using ProductID as
Correlated column*/
Select TransID, OrderID, ProductId, (select ProductName from Product where PurchaseTrans.ProductID=Product.ProductID) as ProductName, AccountNumber, Supplier, Address, City, OrderQty*UnitPrice as PurchaseAmount
From PurchaseTrans

-- JOIN FUNCTION --
Select TransID, OrderID, PurchaseTrans.ProductId, Product.ProductName, AccountNumber, Supplier, Address, City, OrderQty*UnitPrice as PurchaseAmount
From PurchaseTrans
JOIN Product on PurchaseTrans.ProductID=Product.ProductID

----Exists and NOT Exists
/*Display dataset in PurchaseTransaction and derives ProductName in product dataset Where the Special
OfferId exists in SpecialOffer dataset*/
Select TransID, OrderID, AccountNumber, Supplier, Address, City, OrderQty*UnitPrice as PurchaseAmount,
(select ProductName from Product where PurchaseTrans.ProductID=Product.ProductID) as ProductName
From PurchaseTrans
where exists (select 1 from SpecialOffer where PurchaseTrans.SpecialOfferID=SpecialOffer.SpecialOfferID)

Select TransID, OrderID, AccountNumber, Supplier, Address, City, OrderQty*UnitPrice as PurchaseAmount,
(select ProductName from Product where PurchaseTrans.ProductID=Product.ProductID) as ProductName
From PurchaseTrans
where NOT exists (select 1 from SpecialOffer where PurchaseTrans.SpecialOfferID=SpecialOffer.SpecialOfferID)


/*Practice 40 Display dataset in PurchaseTransaction dataset Where ProductID is greater that ALL the product in the
sub query dataset*/
Select TransID, OrderID, ProductId, AccountNumber, Supplier, Address, City, OrderQty*UnitPrice as PurchaseAmount
From PurchaseTrans
where ProductID > ALL (select ProductID from Product where ProductID <10)

Assissgment 16 create statement--
Create table Store(
StoreID int not Null,
StoreLocation nvarchar null,
CityID nvarchar null,
)

Create table Customer(
CustomerID nvarchar(5) not null,
LastName nvarchar(15) null,
FirstName
CreatedDate
CreatedBy
ModifiedDate
ModifiedBy
)




