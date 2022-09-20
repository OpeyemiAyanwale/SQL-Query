--Practice 43 : Join Statement
/* Display dataset in PurchaseTransaction with the matching product on product dataset*/

Select t.OrderID, p.ProductName, t.ProductID
From PurchaseTrans t
inner join Product p on t.ProductID=p.ProductID

select distinct ProductID from PurchaseTrans
select ProductID from PurchaseTrans

select distinct ProductID from Product

---select distinct ProductID from PurchaseTrans

--Practice 44
/*Display dataset in PurchaseTransaction with the matching product and special offer dataset*/
Select t.OrderID, p.ProductName, t.ProductID, s.SpecialOffer
From PurchaseTrans t
inner join Product p on t.ProductID=p.ProductID
inner join SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID

--Practice 45
/*Display dataset in PurchaseTransaction with the matching product and special offer on Back to School
dataset*/
Select t.OrderID, p.ProductName, t.ProductID, s.SpecialOffer, s.SpecialOfferID
From PurchaseTrans t
inner join Product p on t.ProductID=p.ProductID
inner join SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID
where s.SpecialOfferID=4


--Practice 47
/*Display dataset in PurchaseTransaction with the matching Product, Category and special offer on Back to
School dataset*/
Select t.OrderID, t.Supplier, t.Address, t.City, t.StateProvince, t.Country, t.OrderQty, s.SpecialOffer, Table_PC.CategoryName
from PurchaseTrans t
inner join
	( 
		select p.ProductID, CategoryName, p.ProductName, p.ProductNumber
		from product p
		inner join ProductCategory pc on p.ProductID=pc.ProductID
		inner join Category c on pc.CategoryID = c.CategoryID 
	) Table_PC on t.ProductID=Table_PC.ProductID
		inner join SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID
where s.SpecialOfferID=4

--Left Joins: Its brings everything on the left
Select t.OrderID, t.Supplier, t.Address, t.City, t.StateProvince, t.Country, t.OrderQty
from PurchaseTrans t
left join Product p on t.ProductID=p.ProductID

--Practice 49
/*
Display dataset in PurchaseTransaction with the matching Product, Category and special offer on Back to
School dataset*/
SELECT t.OrderID, t.Supplier, p.CategoryName, p.ProductName, p.ProductNumber,
s.SpecialOffer, t.Address, t.City, t.StateProvince, t.Country, t.OrderQty
FROM PurchaseTrans t
LEFT JOIN
(
	SELECT pd.ProductID, c.CategoryName, pd.ProductName, pd.ProductNumber
	FROM Product pd
	LEFT JOIN ProductCategory pc on pc.ProductID=pd.ProductID
	LEFT JOIN Category c on c.CategoryID=pc.CategoryID
)	P ON T.ProductID=P.ProductID
LEFT JOIN SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID

--Practice 50
/*Display ALL dataset Product and with the matching in PurchaseTrans dataset*/
SELECT t.OrderID, t.Supplier, p.ProductName, p.ProductNumber, t.Address,
t.City, t.StateProvince, t.Country, t.OrderQty
FROM PurchaseTrans t
RIGHT JOIN Product p ON t.ProductID=p.ProductID

--Practice 51
/*Display ALL dataset Special Offer and with the matching in PurchaseTrans dataset*/
SELECT
t.OrderID, t.Supplier, s.SpecialOffer, t.Address, t.City, t.StateProvince, t.Country, t.OrderQty
FROM PurchaseTrans t
RIGHT JOIN SpecialOffer s on t.SpecialOfferID=s.SpecialOfferID