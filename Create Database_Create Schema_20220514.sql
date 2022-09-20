Create Database Grocery_OLTP
Create Database Grocery_Warehouse
Create database Grocery_Control

use [Grocery_Staging]
GO
Create schema Grocery_OLTP

Create Schema HR

Use [Grocery_Warehouse]
Go
Create schema  EDW

-- Staging Table
use [Grocery_Staging]
---ProductID, ProductNumber, Product, UnitPrice, Department----
Create Table Grocery_OLTP.Product 
( 
 ProductID int,
 productName nvarchar(50),
 ProductNumber nvarchar(50),
 UnitPrice float, 
 DepartmentName nvarchar(50),
 LoadDate datetime default getdate(),
 constraint grocery_product_pk primary key(productid)
)


-- -- Product Warehouse---
use [Grocery_Warehouse]
Create Table EDW.dimProduct 
( 
 Product_sk int identity(1,1),
 ProductID int,
 productName nvarchar(50),
 ProductNumber nvarchar(50),
 UnitPrice float, 
 DepartmentName nvarchar(50),
 StartDate  datetime,
 EndDate  datetime, 
 constraint EDW_dimproduct_sk primary key(product_Sk)
)

USE [Grocery_OLTP]
select p.ProductID, p.ProductNumber,p.Product,p.UnitPrice, d.Department, getdate() as Loaddate  from product p
inner join Department d on p.DepartmentID=d.DepartmentID

USE [Grocery_Staging]
select * from Grocery_OLTP.Product

TRUNCATE TABLE Grocery_OLTP.Product

delete from Grocery_OLTP.Product

USE[Grocery_Control]
Go
create schema Control

Drop table Control.Environment

Create table control.Environment
(
	EnvironmentID_pK int identity(1,1),
	Environment nvarchar(50), --(Staging, EDW)
	constraint EnvironmentID_sK primary key (EnvironmentID_pK)
)

insert into control.Environment (Environment) 
values('OLTP'),('Stagging'),('EDW')
select * from Control.Environment

Create table control.packageType
(
  PackageTypeID_Pk int identity(1,1),
  PackageType nvarchar(50),  ---(dimension, fact)
  constraint PackageTypeID_sk primary key (PackageTypeID_Pk) 
)


insert into Control.packagetype(PackageType)
values('Dimension'),('Fact')
select * from Control.packagetype

Drop table Control.Frequency
Create table Control.Frequency
(
	FrequencyID_pk int identity(1,1),
	Frequency nvarchar(50), ---(day,weekend, EOD or 1st day of month,year)
	constraint FrequencyID_sk primary key (FrequencyID_pk)
)

insert into Control.Frequency(Frequency)
values('day'),('weekend'),( 'EODMonthWeekend'),('Year')
select * from Control.Frequency

Drop table Control.package;
create table Control.package

(
	 PackageId_Pk int  identity(1,1),
     Packagename   nvarchar(50),  ---Stgproduct
     SequenceNo int,  
     EnvironmentID_Pk int ,   -- Staging, EDW     stagin
     PackageTypeID_pk    int, --- Dimension, Fact  
     RunStartDate  datetime,
     RunEndDate  datetime,
	 FrequenceID_pk int,
     Active bit,   	 
    LastRunDate datetime,
	constraint  PackageId_sk Primary key(PackageId_Pk),
	constraint  Package_EnvironmentID_fk foreign key (EnvironmentID_Pk) references Control.environment(EnvironmentID_pk),
	constraint  Package_PackageTypeID_fk foreign key (PackageTypeID_pk) references Control.PackageType(PackageTypeID_pk),
	constraint  Package_FrequencyID_fk foreign key (FrequenceID_pk) references Control.Frequency(FrequencyID_pk)
)

select * from Control.package

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgProduct.dtsx',100,1,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgLocation.dtsx',100,1,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgEmployee.dtsx',300,1,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgPromotion.dtsx',400,1,1,GETDATE(),null,1,1)


	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgCustomer.dtsx',500,1,1,GETDATE(),null,1,1)

	use [Grocery_Control]
	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgPOSChannel.dtsx',600,1,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgVendor.dtsx',700,1,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgSalesTransPrev.dtsx',750,1,2,GETDATE(),GETDATE(),1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgSalesTrans.dtsx',800,1,2,GETDATE(),null,1,1)
	
	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgPurchaseTransPrev.dtsx',850,1,2,GETDATE(),GETDATE(),1,1)
	
	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgPurchaseTrans.dtsx',900,1,2,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgOvertimeTransPrev.dtsx',950,1,2,GETDATE(),GETDATE(),1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('stgOvertimeTrans.dtsx',1000,1,2,GETDATE(),null,1,1)


	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('DimProduct.dtsx',2000,2,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('DimLocation.dtsx',2100,2,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('DimEmployee.dtsx',2200,2,1,GETDATE(),null,1,1)


	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('DimPromotion.dtsx',2300,2,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('DimCustomer.dtsx',2400,2,1,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('DimChannel.dtsx',2500,2,1,GETDATE(),null,1,1)

	
	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('DimVendor.dtsx',2600,2,1,GETDATE(),null,1,1)



	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('factSalesAnalysis.dtsx',3000,2,2,GETDATE(),null,1,1)

	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('factPurchaseAnalysis.dtsx',3100,2,2,GETDATE(),null,1,1)
	
	insert into control.Package(Packagename,SequenceNo,EnvironmentID_Pk,PackageTypeID_pk,RunStartDate,RunEndDate,FrequenceID_pk,Active)
	values('OvertimeAnalysis.dtsx',3200,2,2,GETDATE(),null,1,1)

	select * from control.Package order by 1 desc
	select * from control.Frequency
	--select * from control.metrics
	select * from control.PackageType
	select * from control.environment

Drop table Control.Anomalies
Create table Control.Anomalies
	(
		AnomaliesID bigint identity(1,1),
		PackageID int,
		SourceDim nvarchar(255),
		SourceID int,
		Rundate Datetime,
		constraint AnomaliesId_pk primary key (AnomaliesID),
		constraint Anomaliespackage_fk foreign key(PackageID) references Control.Package(PackageID_pk)
	)

	select * from Control.Anomalies

Create table Control.Metrics
	(
		 MetricsID_pk bigint identity(1,1),
		 PackageID_pk int,
		 SgtSourceCount int,
		 SgtDestCount int,
		 PreCount int,
		 CurrentCount int,
		 postCount int,
		 Type1Count int,
		 Type2Count int,
		 RunDate datetime,
		 constraint MetricsID_sk primary key (MetricsID_pk),
		 Constraint Metrics_packageID_fk foreign key(PackageID_pk) References Control.Package(PackageID_pk)

	)

ALTER AUTHORIZATION ON DATABASE::[Grocery_Control] TO [sa]
ALTER AUTHORIZATION ON DATABASE::Grocery_Control TO sa

use [Grocery_WareHouse]
Create Table EDW.dimProduct 
( 
 Product_sk int identity(1,1),
 ProductID int,
 productName nvarchar(50),
 ProductNumber nvarchar(50),
 UnitPrice float, 
 DepartmentName nvarchar(50),
 StartDate  datetime,
 EndDate  datetime, 
 constraint EDW_dimproduct_sk primary key(product_Sk)
)

use [Grocery_WareHouse]

create Table EDW.dimLocation 
(
    Location_Sk int identity(1,1),
	StoreID int,
	StoreName nvarchar(50),
	StreetAddress nvarchar(50),
	CityName nvarchar(50),
	State nvarchar(50),
	StartDate datetime,
	constraint EDW_dimLocation_Sk  primary key(Location_Sk)
)

USE [Grocery_OLTP]
select s.StoreID, s.StoreName,s.StreetAddress,c.CityName, st.State,getdate() as Loaddate  from Store s
inner join City  c on c.CityID=s.CityID
inner join State st on st.StateID=c.StateID

Use [Grocery_Control]
Select * from control.package where packageID_PK in (1,2)
Select * from control.metrics

--SCD == Slow Changing Dimension
DATES			OLTP			STAGING			EDW		Precount	PostCount	Precount(edw)	PostCount(edw)	Type1Count(SCD)		Type2count(SCD)
15/04/2022		40				40			  0+50=50		  0			  40		0					40		
16/04/2022		100				100			 50+100=150		  50		  100		50					150
17/04/2022		30				30			150+30=180		 100		  30		150					180
18/04/2022		60				60			180+60=240			 30			  60	180					240


		
		 SgtSourceCount 
		 SgtDestCount 
		 PreCount 
		 CurrentCount 
		 postCount 
		 Type1Count 
		 Type2Count 

USE [Grocery_OLTP]
Select Count(*) as SgtSourceCount from product

select Count(*) as SgtSourceCount  from product p
inner join Department d on p.DepartmentID=d.DepartmentID


USE [Grocery_Staging]
Select Count(*) as SgtDestCount from Grocery_OLTP.product

select Count(*) as SgtSourceCount  from product p
inner join Department d on p.DepartmentID=d.DepartmentID



Declare @PackageId int = 1
declare @SourceCount int =?
declare @DestCount int =?
insert into control.Metrics(PackageID_pk,	SgtSourceCount,		SgtDestCount ,	Rundate)
					Select	@packageId ,	@Sourcecount,		@DestCount,		getdate()

update control.Package set LastRunDate=GetDate() where PackageID_pk=@PackageId

declare @PackageId int = ?
declare @PreCount int = ?
declare @CurrentCount int =? 
declare @postCount int =?
declare @Type1Count int=?
declare @Type2Count int=?
insert into control.Metrics( PackageId_pk,	PreCount ,	 CurrentCount ,	 postCount , Type1Count ,	 Type2Count , Rundate)
					  select @PackageId,	@PreCount,	@Currentcount,	 @PostCount, @Type1count,	@Type2Count,	getDate()

update control.Package set LastRunDate=GetDate() where PackageID_pk=@PackageId

-----  Location Staging ---

use [Grocery_OLTP]
select s.StoreID, s.StoreName,s.StreetAddress,c.CityName, st.State,getdate() as Loaddate  from Store s
inner join City  c on c.CityID=s.CityID
inner join State st on st.StateID=c.StateID

use [Grocery_OLTP]
select count(*) as SgtSourceCount  from Store s
inner join City  c on c.CityID=s.CityID
inner join State st on st.StateID=c.StateID


use [Grocery_Staging]

select * from grocery_OLTP.[Location] 
create Table grocery_OLTP.[Location] 
(
	StoreID int,
	StoreName nvarchar(50),
	StreetAddress nvarchar(50),
	CityName nvarchar(50),
	State nvarchar(50),
	LoadDate datetime default getdate(),
	constraint grocery_Location_pk  primary key(StoreID)
)

USE[Grocery_Staging]

Select count(*) from Grocery_OLTP.Location

--- Employee  Staging 
USE [Grocery_OLTP]
select  e.EmployeeID,e.EmployeeNo, Upper(e.LastName)+', '+e.FirstName as Employee, m.MaritalStatus, Dob as DateofBirth,
getdate() as loaddate from Employee e 
inner join MaritalStatus m on e.MaritalStatus=m.MaritalStatusID


select  count(*) as StgSourceCount from Employee e 
inner join MaritalStatus m on e.MaritalStatus=m.MaritalStatusID

 Use [Grocery_Staging]

 -----  EmployeeID,   EmployeeNo, Employee, MaritalStatus, Loaddate

 Truncate table  Grocery_OLTP.Employee
 Create table Grocery_OLTP.Employee
 (
   EmployeeID int,
   EmployeeNo nvarchar(50),
   Employee nvarchar(255),
   MaritalStatus nvarchar(50),
   DateofBirth date,
   Loaddate datetime default getdate(),
   constraint Grocery_employee_pk primary key (EmployeeID)
 )

 Select * from Grocery_OLTP.Employee 
 use [Grocery_Control]
 select * from [Control].[Metrics]

 select * from [Control].[package]

 use [Grocery_Staging]

 ------ promotion staging-----
use [Grocery OLTP]

select p.PromotionID,p.StartDate as PromotionStartDate ,p.EndDate as promotionEnddate, p.DiscountPercent,pt.Promotion,
getdate() as LoadDate
from Promotion p 
inner join PromotionType pt on pt.PromotionTypeID=p.PromotionTypeID
 

 select  count(*) as stgSourceCount  from Promotion p 
inner join PromotionType pt on pt.PromotionTypeID=p.PromotionTypeID


  Create Table  Grocery_OLTP.Promotion
 (
   PromotionID int,
   PromotionStartDate date,
   promotionEnddate date,
   DiscountPercent float,
   Promotion nvarchar(50),
   LoadDate datetime default getdate(),
   constraint Grocery_Promotion_pk primary key(PromotionID)
 )

 use [Grocery_Staging]

  select c.CustomerID, Upper(c.LastName)+', '+c.FirstName as Customer,c.CustomerAddress, ct.CityName,s.State,Getdate() as LoadDate
 from customer c
 inner join City ct on c.CityID=ct.CityID
 inner join state s on ct.StateID=s.StateID



 select count(*) as stgSourceCount
 from customer c
 inner join City ct on c.CityID=ct.CityID
 inner join state s on ct.StateID=s.StateID

 create Table Grocery_OLTP.Customer
 (
 CustomerID int,
 Customer nvarchar(255),
 CustomerAddress nvarchar(255),
 CityName nvarchar(255),
 State nvarchar(255),
 LoadDate datetime default Getdate(),
 constraint Grocery_Customer_pk primary key(CustomerID)
 )




 
 ---- POS Staging-------
 use [Grocery OLTP]
 select p.ChannelID,p.ChannelNo,p.DeviceModel,p.InstallationDate,p.SerialNo  from POSChannel p 

 select Count(*) as stgSourceCount  from POSChannel p 


  create table Grocery_OLTP.POSChannel
 (
  ChannelID int,
  ChannelNo nvarchar(50),
  DeviceModel nvarchar(50),
  SerialNo nvarchar(50),
  InstallationDate date,
  LoadDate datetime default Getdate(),
 Constraint Grocery_PosChannel_pk  primary key (ChannelID)
)


 ---- Vendor OLTP -----
 use [Grocery OLTP]
 select   v.VendorID,v.VendorNo,Upper(v.LastName) +', '+v.FirstName as Vendor,v.RegistrationNo,v.VendorAddress,c.CityName,s.State, GetDate() as LoadDate
 from Vendor v 
 inner join City c on c.CityID=v.CityID
 inner join State s on s.StateID=c.StateID

 select count(*) as stgSourceCount from Vendor v 
 inner join City c on c.CityID=v.CityID
 inner join State s on s.StateID=c.StateID



 CREATE TABLE Grocery_OLTP.Vendor
 (
   VendorID int ,
   VendorNo nvarchar(50),
   Vendor nvarchar(255),
   RegistrationNo nvarchar(50),
   VendorAddress  nvarchar(50),
   CityName nvarchar(50),
   State nvarchar(50),
   LoadDate datetime default GetDate(),
   Constraint Grocery_Vendor_Pk primary key(VendorID) 
 )

 Create table Grocery_OLTP.SalesTransaction
( 
	TransactionID int,
	TransactionNO nvarchar(50) ,
	TransDate datetime ,
	OrderDate datetime ,
	DeliveryDate datetime,
	ChannelID int,
	CustomerID int ,
	EmployeeID int,
	ProductID int,
	StoreID int,
	PromotionID int,
	Quantity float ,
	TaxAmount float ,
	LineAmount  float ,
	LineDiscountAmount float,
	LoadDate datetime default getdate(),
	Constraint Grocery_SalesTrans_Pk primary key(TransactionID)
)


Create table Grocery_OLTP.PurchaseTransaction
( 
	TransactionID int,
	TransactionNO nvarchar(50) ,
	TransDate datetime ,
	OrderDate datetime ,
	DeliveryDate datetime,
	Shipdate datetime,
	VendorID int,	
	EmployeeID int,
	ProductID int,
	StoreID int,	
	Quantity float ,
	TaxAmount float ,
	LineAmount  float ,
	DayDifferential int,
	LoadDate datetime default getdate(),
	Constraint Grocery_PurchaseTrans_Pk primary key(TransactionID)
)


Create Table Grocery_OLTP.Overtime 
( 
 OvertimeId bigint,
 EmployeeNo nvarchar(50),
 FirstName nvarchar(50),
 LastName nvarchar(50),
 StartOvertime datetime,
 EndOvertime datetime, 
 LoadDate datetime,
 constraint Grocery_Overtime_Pk primary key(OvertimeId)
 )

 use [Grocery_OLTP]
 select count(*) as StgSourceCount from [dbo].[SalesTransaction] -- total count of all data

-- count datas from day 1 to day n-2 where n is current date
select count(*) as StgSourceCount from [dbo].[SalesTransaction] where cast(TransDate as Date) < cast(dateadd(d,-1,getdate()) as Date)-- comparing '2022-05-06' with '2022-05-06'

select TransactionID,TransactionNO,TransDate ,OrderDate,DeliveryDate,ChannelID,CustomerID,EmployeeID,
	ProductID,StoreID,PromotionID,Quantity,TaxAmount ,LineAmount ,LineDiscountAmount,
	getdate() as LoadDate from SalesTransaction
	where cast(TransDate as Date) < cast(dateadd(d,-1,getdate()) as Date)

-- count datas for  n-1 day where n is current date
select count(*) as StgSourceCount from [dbo].[SalesTransaction] where cast(TransDate as Date) = cast(dateadd(d,-1,getdate()) as Date)

select TransactionID,TransactionNO,TransDate ,OrderDate,DeliveryDate,ChannelID,CustomerID,EmployeeID,
	ProductID,StoreID,PromotionID,Quantity,TaxAmount ,LineAmount ,LineDiscountAmount,
	getdate() as LoadDate from SalesTransaction
	where cast(TransDate as Date) = cast(dateadd(d,-1,getdate()) as Date)
[Grocery_OLTP].[SalesTransaction]

--1032187 - 1032232 == 45
--select count(*) as StgSourceCount from [dbo].[SalesTransaction] where TransDate = cast(dateadd(d,-1,getdate()) as Date) -- comparing '2022-05-06 hh:mm:ss:ss' with '2022-05-06'

select * from [Grocery_OLTP].[SalesTransaction]
select Max(TransDate), Min(TransDate) from [Grocery_OLTP].[SalesTransaction]

-- count datas for  n-1 day where n is current date (PurchaseTrans
select count(*) as StgSourceCount  from [dbo].[PurchaseTransaction] where cast(TransDate as Date) = cast(dateadd(d,-1,getdate()) as Date)

select TransactionID,TransactionNO,TransDate,OrderDate,DeliveryDate,ShipDate,VendorID,
EmployeeID,ProductID,StoreID,Quantity,TaxAmount,LineAmount, DATEDIFF(d, OrderDate, DeliveryDate) as DayDifferential,
Getdate() as LoadDate from PurchaseTransaction
	where cast(TransDate as Date) = cast(dateadd(d,-1,getdate()) as Date)

-- count datas for  n-1 day where n is current date (PurchaseTrans
select count(*) as StgSourceCount  from [dbo].[PurchaseTransaction] where cast(TransDate as Date) < cast(dateadd(d,-1,getdate()) as Date)

select TransactionID,TransactionNO,TransDate,OrderDate,DeliveryDate,ShipDate,VendorID,
EmployeeID,ProductID,StoreID,Quantity,TaxAmount,LineAmount, DATEDIFF(d, OrderDate, DeliveryDate) as DayDifferential,
Getdate() as LoadDate from PurchaseTransaction
	where cast(TransDate as Date) < cast(dateadd(d,-1,getdate()) as Date)

	select * from [Grocery_OLTP].[PurchaseTransaction]
select Max(TransDate), Min(TransDate) from [Grocery_OLTP].[PurchaseTransaction]


Create Table OvertimeDump2 
( 
 OvertimeId bigint,
 EmployeeNo nvarchar(50),
 FirstName nvarchar(50),
 LastName nvarchar(50),
 StartOvertime datetime,
 EndOvertime datetime, 
 LoadDate datetime 
 )

 select OvertimeId, count(*) from  OvertimeDump2
 group by OvertimeId 
 Having count(*)>1

 select * from [Grocery_OLTP].[Overtime]

 select p.PackageId_Pk, p.Packagename,p.SequenceNo from control.Package p 
	 Where p.EnvironmentID_Pk=1 and  cast(RunStartDate as date)<=cast(GETDATE() as date)
	 and (RunEndDate is null  or cast(RunEndDate as date)>=cast(GETDATE() as date))
	 Order By SequenceNo asc