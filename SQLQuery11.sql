/*ALTER AUTHORIZATION ON DATABASE:: [Grocery_WareHouse] TO [SA]

USE [Grocery]


select top 10 * from PurchaseTransaction

create schema Grocery_OLTP;

select top 5 * from Department
select top 5 * from Product

select top 5 p.productID, p.ProductNumber,p.Product, p.UnitPrice, d.Department 
from Product p
join Department d on p.DepartmentID=d.DepartmentID

select top 5 * from Employee
select top 5 * from MaritalStatus*/

Create Table Grocery_OLTP.Product
(
	productID int, 
	ProductNumber nvarchar(50),
	Product nvarchar(50), 
	UnitPrice float,
	Department nvarchar(50),
	LoadDate datetime default getdate(),
	CONSTRAINT grocery_product_pk primary key (productID)
)

select * from Product
select * from Grocery_OLTP.Product

Create Table EDW.Product
(
	Product_sk int identity(1,1),
	productID int, 
	ProductNumber nvarchar(50),
	Product nvarchar(50), 
	UnitPrice float,
	Department nvarchar(50),
	StartDate date,
	Enddate date,
	LoadDate datetime default getdate(),
	CONSTRAINT grocery_product_pk primary key (productID)
)

select * from Store s
select * from  city c
select * from  state st

select s.StoreID,s.StoreName,s.StreetAddress, c.CityName, st.State, getdate() as loadDate  from Store s
join city c on s.CityID= c.CityID
join state st on c.StateID=st.StateID

create table Grocery_OLTP.Location
(
	StoreId int,
	StoreName nvarchar(50),
	StreetAddress nvarchar(50),
	cityName nvarchar(50),
	State nvarchar(50),
	loadDate date default getdate(),
	constraint  grocery_Location_pk primary key (StoreId)
)

create table EDW.Location
(
	Store_sk int identity(1,1),
	StoreId int,
	StoreName nvarchar(50),
	StreetAddress nvarchar(50),
	cityName nvarchar(50),
	State nvarchar(50),
	StartDate date,
	loadDate date default getdate(),
	constraint  grocery_Location_pk primary key (StoreId)
)


select v.VendorID, v.VendorNo, 
	Upper(v.LastName) + ', '+ left(v.FirstName,1) + '.' as Vendor,
	v.RegistrationNo,v.VendorAddress,c.CityName,s.State, GetDate() as LoadDate
from Vendor v
join city c on v.CityID= c.CityID
join state s on c.StateID=s.StateID

create table Staging.Vendor
(
	VendorID int,
	VendorNo nvarchar(50),
	Vendor nvarchar(255),
	RegistrationNo nvarchar(50),
	VendorAddress nvarchar(80),
	CityName nvarchar(50),
	State nvarchar(50),
	LoadDate date,
	constraint  grocery_Vendor_pk primary key (VendorID)
)

create table EDW.dimVendor
(
	Vendor_sk int identity(1,1),
	VendorID int,
	VendorNo nvarchar(50),
	Vendor nvarchar(255),
	RegistrationNo nvarchar(50),
	VendorAddress nvarchar(80),
	CityName nvarchar(50),
	State nvarchar(50),
	StartDate date,
	Enddate date,
	LoadDate date,
	constraint  grocery_Vendor_pk primary key (Vendor_sk)
)

use [Grocery_OLTP]
select min(TransDate), max(TransDate) from SalesTransaction
select  min(TransDate), max(TransDate) from PurchaseTransaction


Create Table EDW.dimDate
(
	Date_Sk int,   ----20220305
	CDate Date,		-----2022-03-05
	CYaer int,		-----2022
	cQuartar nvarchar(2),		----Q1
	CMonth int,		-------03
	CEngMonthName Nvarchar(20),		--------Mar
	CFrenchMonthName nvarchar(20),	-------Mar
	Cday int,		--------05
	CDayofWeek int,		-----7
	CDayNameofweek nvarchar(20), ------Saturday
	constraint EDW_dimDate_sk primary key(Date_sk)
)


select getdate()
select year(getdate())
select month(getdate())
select datename(month,getdate())
select datename(WEEKDAY,getdate())
select datename(WEEK,getdate())
select DATEPART(week,getdate())
select datepart(quarter,getdate())
select DATEFROMPARTS(2022,05,07)
select datepart(quarter,(select DATEFROMPARTS(2022,05,07)))
select EOMONTH(GETDATE())
select EOMONTH((select DATEFROMPARTS(2020,02,07)))
select day(getdate())
select day(EOMONTH(DATEFROMPARTS(2022,02,07)))

select RIGHT('0' + cast(month(getdate()) as nvarchar),2)
select RIGHT('0' + cast(day(getdate()) as nvarchar),2)
select RIGHT('0' + cast(month(DATEFROMPARTS(2020,10,07)) as nvarchar),2);


/*  year from 2011 to 2022
			Month 1-12
				day 1 to EOMONTH(GETDATE())
					date= year + month + day
				day= day + 1
			month= month + 1
			end Month
		year= year + 1
	End year
*/
/*
Declare @StartYear int = 2011
Declare @EndYear int = 2023
Declare @StartMonth int
Declare @EndMonth int =12
Declare @StartDay int
Declare @endDay int
declare @CQuarter int



WHILE @StartYear<=@EndYear
BEGIN
		select @StartMonth =1
		WHILE @StartMonth<=@EndMonth
		BEGIN
				select @StartDay=1
				select @endDay = Day(EOMONTH(DATEFROMPARTS(@StartYear,@StartMonth,1)))
				--select @CQuarter = cast('Q' + cast(DATEPART(Quarter,@endDay) as nvarchar) as int)
				WHILE @StartDay<=@endDay
				BEGIN
					INSERT INTO #DateGenerate(CYear,CMonth,CDay,CDate,DateSK)
					Select 
						@StartYear as CYear, 
						@StartMonth as CMonth,
						@StartDay as CDay,
						DATEFROMPARTS(@StartYear,@StartMonth,@StartDay)  as CDate,
						cast(cast(@StartYear as nvarchar) + RIGHT('0'+ cast(@StartMonth as nvarchar),2)+ RIGHT('0'+ cast(@StartDay as nvarchar),2) as int)  as DateSK ---- 20110122


						select @StartDay=@StartDay+1
				End -- end of day loop
			select @StartMonth=@StartMonth+1
		END --- end of month loop
	select @StartYear=@StartYear+1
END --end of year loop;


select * from #Dategenerate where DateSK= 20231231

drop table #DateGenerate
create table #DateGenerate 
(
 CYear int, 
 CMonth int,
 CDay int,
 CDate date,
 DateSK int
)
*/

CREATE PROCEDURE EDW.SpGenerateDimDate (@StartYear int, @EndYear int)
AS
--Declare @StartYear int = 2011
--Declare @EndYear int = 2023
Declare @StartMonth int
Declare @EndMonth int =12
Declare @StartDay int
Declare @endDay int
Declare @CQuarter  nvarchar(2)
Declare @CDate Date
Declare @DateSK int
Declare @CEngMonthName nvarchar(20)
Declare @CFrenchMonthName nvarchar(20)
Declare  @CDay int
Declare @CdayOfWeek int
Declare @CDayNameofweek nvarchar(20)
BEGIN
WHILE @StartYear<=@EndYear
BEGIN
		select @StartMonth =1
		WHILE @StartMonth<=@EndMonth
		BEGIN
				select @StartDay=1
				select @endDay = Day(EOMONTH(DATEFROMPARTS(@StartYear,@StartMonth,1)))
				--select @CQuarter = cast('Q' + cast(DATEPART(Quarter,@endDay) as nvarchar) as int)
				WHILE @StartDay<=@endDay
				BEGIN
					select @CDate = DATEFROMPARTS(@StartYear,@StartMonth,@StartDay)
					select @DateSK = cast(cast(@StartYear as nvarchar) + RIGHT('0'+ cast(@StartMonth as nvarchar),2)+ RIGHT('0'+ cast(@StartDay as nvarchar),2) as int)
					Select @StartYear
					select @CQuarter = 'Q' + cast(DATEPART(Quarter,@CDate) as nvarchar)
					select @StartMonth
					select @CEngMonthName = DATENAME(MONTH,@CDate)
					Select CFrenchMonthName = CASE Month(@CDate)
							When 1 then 'Janvier'
							When 2 then 'Fevrier'
							When 3 then 'Mars'
							When 4 then 'Avril'
							When 5 then 'Mai'
							When 6 then 'Auin'
							When 7 then 'Juillet'
							When 8 then 'Aout'
							When 9 then 'Septembre'
							When 10 then 'Octombre'
							When 11 then 'Novembre'
							When 12 then 'Decembre'
							END
                      select @CDay
					  Select @CdayOfWeek
					  select @CDayNameofweek

						INSERT INTO #DimDate(Date_Sk ,CDate ,CYaer ,cQuartar ,CMonth ,CEngMonthName , CFrenchMonthName ,Cday ,CDayofWeek ,	CDayNameofweek )
						 select @DateSK, @CDate, @StartYear, @CQuarter, @StartMonth, @CEngMonthName, @CFrenchMonthName, @CDay, @CdayOfWeek, @CDayNameofweek

						select @StartDay=@StartDay+1
				End -- end of day loop
			select @StartMonth=@StartMonth+1
		END --- end of month loop
	select @StartYear=@StartYear+1
END --end of year loop;
END --end of procedure

EXECUTE EDW.SpGenerateDimDate 2010,2023


Create Table #DimDate
(
	Date_Sk int,   ----20220305
	CDate Date,		-----2022-03-05
	CYaer int,		-----2022
	cQuartar nvarchar(2),		----Q1
	CMonth int,		-------03
	CEngMonthName Nvarchar(20),		--------Mar
	CFrenchMonthName nvarchar(20),	-------Mar
	Cday int,		--------05
	CDayofWeek int,		-----7
	CDayNameofweek nvarchar(20), ------Saturday
	constraint EDW_dimDate_sk primary key(Date_sk)
)

select top 10 * from #DimDate where CFrenchMonthName is not null


CREATE TABLE EDW.DimTime
(
    Time_Sk int identity(1,1),
    HourID int, ----- 0hr - 23hr
    PeriodofDay nvarchar(25),
    Businesshour nvarchar(25),  -- (0-7)---early, (8-17) ---- open, (18-23)----late
    StartDate Datetime,
    constraint EDW_dimTime_SK primary key (Time_Sk)
)

Drop Table EDW.DimTime
CREATE TABLE EDW.DimTime
(
    Time_Sk int identity(1,1),
    HourID int, ----- 0hr - 23hr
    PeriodofDay nvarchar(25),
    Businesshour nvarchar(25),  -- (0-7)---early, (8-17) ---- open, (18-23)----late
    StartDate Datetime,
    constraint EDW_dimTime_SK primary key (Time_Sk)
)

select * from [EDW].[DimTime]
/*
--- 0 - 7 --- Early, 
8- 17 Open -- 
18-- 23--Late  
midnight -0 ,
morning (from 1 am to 11:59 am),
noon (exactly 12:00 ), 
afternoon (from 12:01 pm to 17), 
evening (from 18  to 23)
*/

insert into #DimTime(HourID,PeriodofDay, Businesshour,StartDate)
Values (0,'MidNigt','Early',GETDATE()),
        (1,'Morning','Early',GETDATE()),
        (2,'Morning','Early',GETDATE()),
        (3,'Morning','Early',GETDATE()),
        (4,'Morning','Early',GETDATE()),
        (5,'Morning','Early',GETDATE()),
        (6,'Morning','Early',GETDATE()),
        (7,'Morning','Early',GETDATE()),
        (8,'Morning','Open',GETDATE()),
        (9,'Morning','Open',GETDATE()),
        (10,'Morning','Open',GETDATE()),
        (11,'Morning','Open',GETDATE()),
        (12,'Noon','Open',GETDATE()),
        (13,'Afternoon','Open',GETDATE()),
        (14,'Afternoon','Open',GETDATE()),
        (15,'Afternoon','Open',GETDATE()),
        (16,'Afternoon','Open',GETDATE()),
        (17,'Afternoon','Open',GETDATE()),
        (18,'Evening','late',GETDATE()),
        (19,'Evening','late',GETDATE()),
        (20,'Evening','late',GETDATE()),
        (21,'Evening','late',GETDATE()),
        (22,'Evening','late',GETDATE()),
        (23,'Evening','late',GETDATE())


Declare @StartHour int = 1
Declare @EndHour int = 23

WHILE @StartHour<=@EndHour
BEGIN
    insert into EDW.DimTime(HourID,PeriodofDay, Businesshour,StartDate)

    select @StartHour as HourID,
        CASE 
            When @StartHour=0 Then 'Midnight'
            when @StartHour>0 and @StartHour <12 Then 'Morning'
            When @StartHour =12 Then 'Noon'
            When @StartHour>12 and @StartHour <18 Then 'Afternoon'
            Else 'Evening'
        END as PeriodofDay,
        CASE 
            When @StartHour>=0 and @StartHour<=7 Then 'Early'
            when @StartHour>=8 and @StartHour <18 Then 'open'
            Else 'Late'
        END as Businesshour,
        GetDate() as Startdate

    select @StartHour=@StartHour+1
END


Create DATABASE Grocery_WareHouse

Use Grocery_WareHouse
GO
CREATE SCHEMA Staging
--CREATE SCHEMA EDW

Use [Grocery_WareHouse]
select * from EDW.dimDate where CYear = 2022 and CMonth=05

select * from employee
select * from [Staging].[Product]



use [Grocery_OLTP]
select * from employee
select * from MaritalStatus

Use [Grocery_WareHouse]
Create table Staging.Employee
 (
   EmployeeID int,
   EmployeeNo nvarchar(50),
   Employee nvarchar(255),
   MaritalStatus nvarchar(50),
   DateofBirth date,
   Loaddate datetime default getdate(),
   constraint Grocery_employee_pk primary key (EmployeeID)
 )

 Create Table  Staging.Promotion
 (
   PromotionID int,
   PromotionStartDate date,
   promotionEnddate date,
   DiscountPercent float,
   Promotion nvarchar(50),
   LoadDate datetime default getdate(),
   constraint Grocery_Promotion_pk primary key(PromotionID)
 )

 create Table Staging.Customer
 (
 CustomerID int,
 Customer nvarchar(255),
 CustomerAddress nvarchar(255),
 CityName nvarchar(255),
 State nvarchar(255),
 LoadDate datetime default Getdate(),
 constraint Grocery_Customer_pk primary key(CustomerID)
 )

 create table Staging.POSChannel
 (
  ChannelID int,
  ChannelNo nvarchar(50),
  DeviceModel nvarchar(50),
  SerialNo nvarchar(50),
  InstallationDate date,
  LoadDate datetime default Getdate(),
 Constraint Grocery_PosChannel_pk  primary key (ChannelID)
)

Use[Grocery_WareHouse]
Create table EDW.dimEmployee
 ( 
   Employee_SK int identity(1,1),
   EmployeeID int,
   EmployeeNo nvarchar(50),
   Employee nvarchar(255),
   MaritalStatus nvarchar(50),  
   DateofBirth Date,
   StartDate datetime,
   EndDate  datetime,
   constraint EDW_dimEmployee_Sk  primary key(Employee_SK) 
 )

 Create Table  EDW.dimPromotion
 (
   Promotion_SK int identity(1,1),
   PromotionID int,
   PromotionStartDate date,
   promotionEnddate date,
   DiscountPercent float,
   Promotion nvarchar(50),
   StartDate datetime, 
   constraint EDW_Promotion_sk primary key(Promotion_Sk)
 )

 Create table EDW.dimCustomer 
 (
   Customer_sk int identity(1,1),
  CustomerID int,
  Customer nvarchar(255),
  CustomerAddress nvarchar(255),
  CityName nvarchar(255),
  State nvarchar(255),  
  StartDate Datetime,
  Constraint EdW_dimCustomer_Sk primary key(Customer_Sk)
 )

 create table EDW.dimPOSChannel
 (
  Channel_SK int identity(1,1),
  ChannelID int,
  ChannelNo nvarchar(50),
  DeviceModel nvarchar(50),
  SerialNo nvarchar(50),
  InstallationDate date,
  StartDate datetime ,
  EndDate datetime ,
  Constraint EDW_PosChannel_Sk  primary key (Channel_SK)
)

----- load data from Staging employee to EDW employee
USE [Grocery_WareHouse]
select 
	e.EmployeeID,e.EmployeeNo, e.Employee, e.MaritalStatus,e.DateofBirth, O.StartOvertime, O.EndOvertime,
	getdate() as loaddate 
from Staging.Employee e 
inner join dbo.OvertimeData O on e.EmployeeNo = O.EmployeeNo

Select * from Staging.Employee
Select * from dbo.OvertimeData


/*update  SalesTransaction
set
TransDate=DATEADD(year, 2, transdate),
OrderDate=DATEADD(year, 2, Orderdate),
DeliveryDate=DATEADD(year, 2, Deliverydate)

select MIN([TransDate]),MAX([TransDate]) from SalesTransaction

update  PurchaseTransaction
set
TransDate=DATEADD(year, 2, transdate),
OrderDate=DATEADD(year, 2, Orderdate),
DeliveryDate=DATEADD(year, 2, Deliverydate),
Shipdate=DATEADD(year, 2, ShipDate)

select Min(Transdate), Max(TransDate) from PurchaseTransaction*/

update  OvertimeData
set
[StartOvertime]=DATEADD(year, 2, [StartOvertime]),
[EndOvertime]=DATEADD(year, 2, [EndOvertime])


select MIN([StartOvertime]),MAX([StartOvertime]) from OvertimeData
select MIN([EndOvertime]),MAX([EndOvertime]) from OvertimeData
select * from OvertimeData

USE [Grocery_WareHouse]
Create table Staging.SalesTransaction
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

Create Table EDW.Sales_Analysis
( 
  Sales_Analysis_Sk  bigint identity(1,1),
	TransactionNo nvarchar(50),
	Product_Sk int, 
	Location_Sk int, 
	Employee_Sk int,
	Promotion_sk int,
	TransDate_sk int,
	OrderDate_sk int,
	DeliveryDate_sk int,
	TransTime_sk int,
	OrderTime_sk  int, 
	Customer_Sk  int,
	Channel_Sk int,
	Quantity float ,
	TaxAmount float ,
	LineAmount  float ,
	LineDiscountAmount float,
	LoadDate datetime default getdate(),
   Constraint EDW_Sales_Analysis_sk  primary key(Sales_Analysis_Sk),
   Constraint EDW_Sales_Product_sk foreign key(Product_Sk) References EDW.DimProduct(Product_Sk),
   constraint EDW_Sales_Location_sk foreign key(Location_Sk) References EDW.DimLocation(Location_Sk),
   constraint EDW_Sales_Employee_sk foreign key(Employee_Sk) References EDW.DimEmployee(Employee_Sk),
   constraint EDW_Sales_Promotion_sk foreign key(Promotion_Sk) References EDW.DimPromotion(Promotion_Sk),
   constraint EDW_Sales_Transdate_sk foreign key(TransDate_sk) References EDW.dimDate(Date_sk),
   constraint EDW_Sales_Orderdate_sk foreign key(OrderDate_sk) References EDW.dimDate(Date_sk),
   constraint EDW_Sales_Deliverydate_sk foreign key(DeliveryDate_sk) References EDW.dimDate(Date_sk),
   constraint  EDW_sales_TransTime_sk foreign key(TransTime_sk) References EDW.dimTime(Time_Sk),
   constraint  EDW_sales_OrderTime_sk foreign key(OrderTime_sk) References EDW.dimTime(Time_Sk),   
   constraint EDW_Sales_Customer_sk foreign key(Customer_Sk) References EDW.DimCustomer(Customer_Sk),
   constraint EDW_Sales_Channel_sk foreign key(Channel_Sk) References EDW.dimPosChannel(Channel_Sk)
)

Create table Staging.Purchasetransaction
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

Create table EDW.purchase_Analysis

(
	purchase_analysis_sk bigint identity(1,1),
	TransactionNO nvarchar(50),
	product_sk int,
	Location_sk int,
	Employee_sk int,
	Transdate_sk int,
	orderdate_sk int,
	deliveryDate_sk int,
	Shipdate_sk int,
	vendor_sk int,
	Quantity float,
	TaxAmount float,
	LineAmount float,
	Daydifferentail int,
	Loaddate datetime default getdate(),
	Constraint EDW_Purchase_Analysis_sk  primary key(Purchase_Analysis_Sk),
   Constraint EDW_Purchase_Product_sk foreign key(Product_Sk) References EDW.DimProduct(Product_Sk),
   constraint EDW_Purchase_Location_sk foreign key(Location_Sk) References EDW.DimLocation(Location_Sk),
   constraint EDW_Purchase_Employee_sk foreign key(Employee_Sk) References EDW.DimEmployee(Employee_Sk),   
   constraint EDW_Purchase_Transdate_sk foreign key(TransDate_sk) References EDW.dimDate(Date_sk),
   constraint EDW_Purchase_Orderdate_sk foreign key(OrderDate_sk) References EDW.dimDate(Date_sk),
   constraint EDW_Purchase_Deliverydate_sk foreign key(DeliveryDate_sk) References EDW.dimDate(Date_sk),
   constraint EDW_Purchase_Shipdate_sk foreign key(ShipDate_sk) References EDW.dimDate(Date_sk),
   constraint EDW_Purchase_Vendor_sk foreign key(Vendor_Sk) References EDW.DimVendor(Vendor_Sk)  	
)

Drop table EDW.dimVendor

create table Staging.Overtime
(
	OvertimeID bigint,
	EmployeeNo nvarchar(50),
	firstName nvarchar(50),
	lastName nvarchar(50),
	StartOvertime datetime,
	EndOvertime datetime,
	LoadDate datetime,
	Constraint grocery_Overtime_PK primary key(OvertimeId)
)

select OvertimeID,EmployeeNo,StartOvertime,EndOvertime, DATEDIFF(HOUR, StartOvertime,EndOvertime) as TotalOvertimehour from Staging.Overtime

Create table EDW.HR_Overtime_Analaysis
(
	overtime_sk bigint identity(1,1),
	Employee_sk int,
	OvertimeStartdate_sk int,
	OvertimeStarttime_sk int,
	OvertimeEnddate_sk int,
	OvertimeEndtime_sk int,
	TotalOvertimehour int,
	loadDate datetime default getdate()
	Constraint EDW_HR_Overtime_sk primary key(overtime_sk),
	Constraint EDW_HR_Overtime_Employee_sk Foreign key(Employee_sk) references EDW.DimEmployee(Employee_sk),
	Constraint EDW_HR_Overtime_OvertimeStartdate_sk Foreign key(OvertimeStartdate_sk) references EDW.dimDate(date_sk),
	Constraint EDW_HR_Overtime_OvertimeStarttime_sk Foreign key(OvertimeStarttime_sk) references EDW.dimTime(Time_sk),
	Constraint EDW_HR_Overtime_OvertimeEnddate_sk Foreign key(OvertimeEnddate_sk) references EDW.dimdate(date_sk),
	Constraint EDW_HR_Overtime_OvertimeEndtime_sk Foreign key(OvertimeEndtime_sk) references EDW.DimTime(Time_sk),
)