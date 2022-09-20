select top 10 * from PurchaseTrans
select top 10 * from Product
select top 10 * from SpecialOffer
select top 10 * from Category
select top 10 * from ProductCategory


/*Use CTE to Display Purchase Transaction dataset with product naem, category and special offer */
--join PurchaseTrans with product on ProductId we can get product name
--join PurchaseTrans with SpecialOffer on SpecialOfferID we can get SpecialOffer
--Join PurchaseTrans with ProductCategory on ProductID and join ProductCategory with category on categoryID we can get Category name

/*With Trans_Sales_CTE (ProductName, CategoryName, SpecialOffer)
AS
(
	Select C.CategoryID, t.ProductID, p.ProductName, c.CategoryName, s.SpecialOffer
	From PurchaseTrans t
	Inner join Product p on t.ProductID=p.ProductID
	Inner join SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID
	Inner join ProductCategory pc on t.ProductID=pc.ProductID
	Inner join Category c on pc.CategoryID=c.CategoryID
	where t.ProductID=66
	Group by C.CategoryID, t.ProductID, p.ProductName, c.CategoryName, s.SpecialOffer


With Trans_Sales_CTE (CategoryID, ProductID, ProductName, CategoryName, SpecialOffer, PurchaseAmount)
AS
(
	Select C.CategoryID, t.ProductID, p.ProductName, c.CategoryName, s.SpecialOffer, Sum(OrderQty*UnitPrice) as PurchaseAmount
	From PurchaseTrans t
	Inner join Product p on t.ProductID=p.ProductID
	Inner join SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID
	Inner join ProductCategory pc on t.ProductID=pc.ProductID
	Inner join Category c on pc.CategoryID=c.CategoryID
	Group By C.CategoryID, t.ProductID, p.ProductName, c.CategoryName, s.SpecialOffer
)
select CategoryID, ProductName, CategoryName, SpecialOffer, PurchaseAmount from Trans_Sales_CTE */


With Trans_Sales_CTE (CategoryID, ProductID, ProductName, CategoryName, SpecialOffer, PurchaseAmount)
AS
(
	Select C.CategoryID, t.ProductID, p.ProductName, c.CategoryName, s.SpecialOffer, Sum(OrderQty*UnitPrice) as PurchaseAmount
	From PurchaseTrans t
	Inner join Product p on t.ProductID=p.ProductID
	Inner join SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID
	Inner join ProductCategory pc on t.ProductID=pc.ProductID
	Inner join Category c on pc.CategoryID=c.CategoryID
	Group By C.CategoryID, t.ProductID, p.ProductName, c.CategoryName, s.SpecialOffer
)
select CategoryID, ProductName, CategoryName, SpecialOffer, PurchaseAmount from Trans_Sales_CTE


/*Generate unique row number by transaction ID order by TransID in Ascending order */
Select ROW_NUMBER()
	OVER(Partition by OrderID ORDER BY TransID asc) as RowNumber, OrderID, City
from PurchaseTrans

/*Rank of Purchase amount with gaps in ranking */
Select RANK()
	OVER(Partition by City ORDER BY OrderQty*UnitPrice) as RankNumber, OrderID, City, OrderQty*UnitPrice PurchaseAmount
from PurchaseTrans;

Select ROW_NUMBER()
	OVER(Partition by City ORDER BY OrderQty*UnitPrice) as RowNumber, 
	RANK()
	OVER(Partition by City ORDER BY OrderQty*UnitPrice) as RowNumber,
	DENSE_RANK()
	OVER(Partition by City ORDER BY OrderQty*UnitPrice) as RankNumber, OrderID, City, OrderQty*UnitPrice PurchaseAmount
from PurchaseTrans;


Select ROW_NUMBER() OVER(ORDER BY ORDERID) as Record_number, 
	DENSE_RANK() OVER(ORDER BY OrderQty*UnitPrice) as Purchase_Dense_Rank, OrderID, Employee, OrderQty*UnitPrice PurchaseAmount
	From PurchaseTrans
	Order By Record_number, Purchase_Dense_Rank
	
/* Distribute the purchase amount into 4 buckets */
--USING Partition
Select NTILE(4) OVER (PARTITION BY Country ORDER BY SUM(OrderQty*UnitPrice)) Bucket, Country, SUM(OrderQty*UnitPrice) Purchasetrans
from PurchaseTrans
Group By Country

--WITHOUT Partition
Select NTILE(4) OVER (ORDER BY SUM(OrderQty*UnitPrice)) Bucket, Country, SUM(OrderQty*UnitPrice) Purchasetrans
from PurchaseTrans
Group By Country


/* Distribute the purchase amount into 5 buckets per country */
Select NTILE(5) OVER (PARTITION BY Country ORDER BY SUM(OrderQty*UnitPrice)) Bucket, Country, StateProvince, SUM(OrderQty*UnitPrice)) Bucket, Country, StateProvince, SUM(OrderQty*UnitPrice) Purchasetrans
From PurchaseTrans
Group By Country, StateProvince;

--Practise 115
/* Calculate the cumulatve distribution of purchase amount by United kingdom, France, Canada and United State */
select Country, SUM(OrderQty*UnitPrice) PurchaseAmount, CUME_DIST() Over (ORDER BY Sum(OrderQty*UnitPrice)) as Distribution01
from PurchaseTrans
Group BY Country

--Practise 116
/* Calculate the cumulatve distribution of purchase amount by United kingdom, France, Canada and United State
are the potential suppliers countries of ML Mountain Mandlebars product*/
select Country, SUM(OrderQty*UnitPrice) PurchaseAmount, CUME_DIST() Over (ORDER BY Sum(OrderQty*UnitPrice)) as Distribution01
from PurchaseTrans t
Inner Join Product p on t.ProductID=p.ProductID
WHERE p.ProductID=1
Group BY Country, ProductName

--Practise 120
/*Display the first value of product in category within a country  */
SELECT Country, CategoryName, p.ProductName, SUM(OrderQty*UnitPrice) PurchaseAmount,
 FIRST_VALUE(ProductName) OVER(PARTITION by Country order by SUM(OrderQty*UnitPrice)) category
 from PurchaseTrans t
 Join Product p on t.ProductID=p.ProductID
 Join ProductCategory pc on t.ProductID=Pc.ProductID
 Join Category c on pc.CategoryID=c.CategoryID
 Group by Country, CategoryName, P.ProductName

 --Practise 122
 /*Display the last value of product in category within a country */
 SELECT Country, CategoryName, p.ProductName, SUM(OrderQty*UnitPrice) PurchaseAmount,
 LAST_VALUE(ProductName) OVER(PARTITION by Country order by SUM(OrderQty*UnitPrice)) category
 from PurchaseTrans t
 Join Product p on t.ProductID=p.ProductID
 Join ProductCategory pc on t.ProductID=Pc.ProductID
 Join Category c on pc.CategoryID=c.CategoryID
 Group by Country, CategoryName, P.ProductName

 /*Using CTE and LAG function to display the previous purchase amount year and country */
 With PurchaseAmount_CTE  (Year, Country, PurchaseAmount, Previous_PurchaseAmount)
As
(
 select Year(OrderDate) as Year, Country, SUM(OrderQty*UnitPrice) as PurchaseAmount,
 LAG(SUM(OrderQty*unitPrice),1) OVER(PARTITION BY country Order By year(Orderdate)) as Previous_PurchaseAmount
 from PurchaseTrans
 Group By Country, Year(OrderDate)
)
 select Year, Country, PurchaseAmount as Current_PurchaseAmount, Previous_PurchaseAmount, (PurchaseAmount-Previous_PurchaseAmount) as different,
 FORMAT((PurchaseAmount-Previous_PurchaseAmount)/Previous_purchaseAmount, 'p') as Percentage_different
 from PurchaseAmount_CTE

 /*Using CTE and LEAD function to display the previous purchase amount year and country */
With PurchaseAmount_CTE  (Year, Country, PurchaseAmount, Previous_PurchaseAmount)
As
(
 select Year(OrderDate) as Year, Country, SUM(OrderQty*UnitPrice) as PurchaseAmount,
 LEAD(SUM(OrderQty*unitPrice),1) OVER(PARTITION BY country Order By year(Orderdate)) as Previous_PurchaseAmount
 from PurchaseTrans
 Group By Country, Year(OrderDate)
)
 select Year, Country, PurchaseAmount as Current_PurchaseAmount, Previous_PurchaseAmount, (PurchaseAmount-Previous_PurchaseAmount) as different,
 FORMAT((PurchaseAmount-Previous_PurchaseAmount)/Previous_purchaseAmount, 'p') as Percentage_different
 from PurchaseAmount_CTE

 --DATA DEFINITION LANGUAGE--
 --Create table test (Id bigint)
 --declare @Id bigint

 --select * from test2

-- declare @Id float(13) =1234.433 ;
 --create table test2 (Id bigint,
 --Amount float (2))

 --sytax for creating table

CREATE TABLE ##test_table
(
	ID bigint not null,
	Amount float null,
	Name nvarchar(5) null	
)

CREATE TABLE test_table3
(
	ID bigint not null,
	Amount float null,
	Name nvarchar(5) null
)

Declare @test1 TABLE
(
	ID bigint not null,
	Amount float null,
	Name nvarchar(5) null
)

select distinct Unitprice from PurchaseTrans
Select * from Product where ProductID=1

Declare @name varchar(10) = 'John';
Declare @amount float(4) = 3.89;

select @name as Name, @Amount as Amount
