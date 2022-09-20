Use Essential
Go

Create table Table_Name
(
[AddressID] [int] IDENTITY (1,1) NOT NULL,
[CityID] [int] NULL,
[AddressName] [nvarchar] (255) NULL,
[Postalcode] [nvarchar] (255) NULL,
[Address_PK] [nvarchar] (255) NULL
)

--DROP TABLE Table_Name   
--(for single line comment -- and to remove the comment just take that off)
/* (for multiple comment forward slash and asterik at the beginning and at the back) */

/* Create table Table_Name
(
[AddressID] [int] IDENTITY (1,1) NOT NULL,
[CityID] [int] NULL,
[AddressName] [nvarchar] (255) NULL,
[Postalcode] [nvarchar] (255) NULL,
[Address_PK] [nvarchar] (255) NULL
)*/


--Use Essential
/* Select * from [dbo].[Employee]

Select EmployeeID from [dbo].[Employee]

Select * from [dbo].[PurchaseTrans]

Select TransID, City, AccountNumber from [dbo].[PurchaseTrans]

Select Top(10) TransID, City, AccountNumber from PurchaseTrans

Select *from [dbo].[PurchaseTrans] where city = 'Toronto' and Supplier = 'Pak Jae'

Select *from [dbo].[PurchaseTrans] where CarrierTrackingNumber like 'f%' --('f%' those one that start with f)

Select *from [dbo].[PurchaseTrans] where CarrierTrackingNumber like '%f%' --('%f%' those one that have f)

Select *from [dbo].[PurchaseTrans] where CarrierTrackingNumber like '%f' --('%f' those one that end with f)

Select SUM(ListPrice) as Total from [dbo].[PurchaseTrans] where ListPrice like '%.99'

Select SUM(ListPrice) as Total from [dbo].[PurchaseTrans] */

/* Select * from [dbo].[PurchaseTrans] 
where ListPrice like '%.99' -- or 
where PostalCode is NULL
where PostalCode is not NULL

-- To Order ascending or by descending
order by ListPrice asc
order by ListPrice desc
order by OrderQty desc

-- To see if the table have distinct table/ validate the data
Select Distinct * from [dbo].[PurchaseTrans]
Select * from [dbo].[PurchaseTrans]

Select Distinct OrderID from [dbo].[PurchaseTrans]  --3253
Select OrderID from [dbo].[PurchaseTrans]   --26357

--Comparison Operator =, >, <, >=, <= 
--Logical Operator All, AND, ANY, BETWEEN, EXIST, IN, LIKE, NOT, OR

		First	Second	Result
And		T		 T		  T

OR		F		 T		  T
OR		T		 F		  T
OR		T		 F		  T

= Equal, < Less than, > Greater than, <> Not equal, <= Less than or equal to, >= Greater than or


Select * from [dbo].[PurchaseTrans]
where ListPrice >1097 and ListPrice <=1457
order by ListPrice asc

Select * from [dbo].[PurchaseTrans]
where ListPrice >1097 or ListPrice <=1457
order by ListPrice asc

Select * from [dbo].[PurchaseTrans]
where ListPrice >1097 and ListPrice < 1500
order by ListPrice asc */

-- To create a case statement
Select trans.UnitPrice, trans.Country,
	Case
		When UnitPrice <500.00  then 'low'
		When UnitPrice >2000.00 then 'High'
		else 'Medium'
	End as DerivedColumn
from [dbo].[PurchaseTrans] trans


-- To create a subset dataset
Select ListPrice, UnitPrice, PostalCode, City from [dbo].[PurchaseTrans]
Where city in(select Distinct City from [dbo].[PurchaseTrans])

-- To join record from one table to another table to see which one relate to each other
Select * from PurchaseTrans t
join CustomerShipment c on c.OrderID=t.OrderID

Select t.AccountNumber, c.ProductName, t.ProductID, c.UnitPriceDiscount, t.UnitPrice from PurchaseTrans t
join CustomerShipment c on c.OrderID=t.OrderID

--Comparison Operator

