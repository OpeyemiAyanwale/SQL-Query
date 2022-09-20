--Select * from PurchaseTrans;

Select AccountNumber, Supplier from PurchaseTrans

where country = 'Canada' 

Select * from PurchaseTrans
where Country = 'Canada' and City = 'burnaby' and UnitPrice > 100.00

Select * from PurchaseTrans
where country = 'Canada'  and CarrierTrackingNumber like '48%'



Select p.OrderID, p.ProductID, p.UnitPrice * p.OrderQty as PurchaseAmount, p.SpecialOfferID,
CASE SpecialOfferID
	When 1 THEN 'Black Friday'
	When 2 THEN 'Hallow day promotion'
	When 3 THEN 'Winter Offer'
	When 4 THEN 'Back to School'
	When 5 THEN 'Christmas Offer'
	When 6 THEN 'Liberty Anniversary'
	When 7 THEN 'Summer Sales'
	When 8 THEN 'Canada 150th years'
	When 9 THEN 'Winter Offer'
	When 13 THEN 'Civil Holiday'
	When 14 THEN 'Good Friday'
	else 'other offer'
END
SpecialOffer
from PurchaseTrans p
order by SpecialOfferID

select * from SpecialOffer



--Select distinct SpecialOfferID
 --from PurchaseTrans
 --order by SpecialOffeID 


 Select p.OrderID, p.ProductID, p.UnitPrice * p.OrderQty as PurchaseAmount, p.Country,
CASE Country
	When 'Canada' Then
		CASE
			When UnitPrice*OrderQty < 500.00 Then'low'
			When UnitPrice*OrderQty >= 500.00 and UnitPrice*OrderQty < 1000.00 Then 'Medium'
			else 'High'
		End
	When 'United States' Then
		CASE
			When UnitPrice*OrderQty < 600.00 Then'low'
			When UnitPrice*OrderQty >= 500.00 and UnitPrice*OrderQty < 1000.00 Then 'Medium'
			else 'High'
		End
	When 'France' Then
		CASE
			When UnitPrice*OrderQty < 300.00 Then'low'
			When UnitPrice*OrderQty >= 300.00 and UnitPrice*OrderQty < 1000.00 Then 'Medium'
			else 'High'
		End
END
KPI
from PurchaseTrans p
where OrderID = 69464 



Select count(*) as TotalCount from PurchaseTrans

Select count(Employee) as TotalCountofExployeeOccurence from PurchaseTrans

Select count(distinct Employee) as TotalCountof UniqueEmployee from PurchaseTrans



Select count(Employee) as TotalCountofExployeeOccurence from PurchaseTrans


Select count(distinct Employee) as TotalCountof UniqueEmployee from PurchaseTrans