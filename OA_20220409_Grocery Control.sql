Create Database Grocery_Control
Create Database Grocery_OLTP2

Use[Grocery_Staging]
Create Schema Grocery_OLTP2
Create Schema HR

Use [Grocery_WareHouse]
Create Schema EDW

--Staging Table--
Use[Grocery_Staging]
Create Table Grocery_OLTP2.Product
(
	productID int, 
	ProductNumber nvarchar(50),
	Product nvarchar(50), 
	UnitPrice float,
	Department nvarchar(50),
	LoadDate datetime default getdate(),
	CONSTRAINT grocery_product_pk primary key (productID)
)


--Product Warehouse--
Use[Grocery_WareHouse]
Create Table EDW.dimProduct
(
	Product_sk int identity(1,1),
	productID int, 
	ProductNumber nvarchar(50),
	Product nvarchar(50), 
	UnitPrice float,
	Department nvarchar(50),
	StartDate date,
	EndDatae date,
	LoadDate datetime default getdate(),
	CONSTRAINT EDW_dimproduct_pk primary key (productID)
)

Use [Grocery_OLTP2]
select p.productID, p.ProductNumber, p.Product, p.UnitPrice, d.Department, getdate() as Loaddate from product p
inner join Department d on p.DepartmentID=d.DepartmentID

TRUNCATE Table Grocery_OLTP2.product
delete from Grocery_OLTP2.product




Use[Grocery_Control]
Go
Create Schema Control

Drop Table Control.Environment
Create table Control.Environment
(
	EnvironmentID_pk int identity(1,1),
	Environment nvarchar(50), --(OLTP, Staging, EDW)
	constraint EnvironmentID_sk primary key (EnvironmentID_pk)
)

insert into control.Environment(Environment) values ('OLTP'), ('Staging'),('EDW')
select * from Control.Environment



Create table control.PackageType
(
	PackageTypeID_pk int identity(1,1),
	PackageType nvarchar(50), --(dimension, fact)
	constraint PackageTypeID_sk  primary key (PackageTypeID_pk ), 
)

insert into control.PackageType(PackageType) values ('Dimension'), ('Fact')
select * from Control.PackageType


Create table Control.Frequency
(
	FrequencyID_pk int identity(1,1),
	Frequency nvarchar(50),  ---(day, weekend,1st day of month, year)
	constraint FrequencyID_sk   primary key (FrequencyID_pk  )
)

insert into Control.Frequency(Frequency) values ('Day'), ('Weekend'), ('EndofMonth'), ('Year')
select * from Control.Frequency


Drop table Control.Package
Create table Control.Package
(
	Packageid_pk int identity(1,1),
	Packagename nvarchar(50), --(dimension, fact)
	SequenceNo int,
	EnvironmentID_pk int, ---staging, EDW
	PackageTypeID_pk int, ---Dimension, fact
	RunStartDay datetime,
	RunEndDate datetime,
	FrequencyID_pk int,
	Active bit,
	LastRunDate datetime,
	constraint PackageID_sk  primary key (PackageID_pk ), 
	constraint Package_EnvironmentID_fk foreign key (EnvironmentID_pk) references Control.environment(EnvironmentID_pk), 
	constraint Package_PackageTypeID_fk  foreign key (PackageTypeID_pk ) references Control.packageType(PackageTypeID_pk),
	constraint Package_FrequencyID_fk   foreign key (FrequencyID_pk  ) references Control.frequency(FrequencyID_pk) 
)

insert into Control.Package(Packagename, SequenceNo, EnvironmentID_pk, PackageTypeID_pk, RunStartDay, RunEndDate, FrequencyID_pk, Active ) 
values ('StgProduct.dtsx', 100, 1, 1, GETDATE(), null, 1, 1)
select * from Control.Package


select * from Grocery_staging.Grocery_OLTP2.Product
--- There is no data when i excute the select statement above



select * from control.Package order by 1 desc  --I only have 1 column
select * from control.Frequency
select * from control.PackageType
select * from control.Environment
--select * from control.Metrics--


Create table Control.Anomalies
(
	AnomaliesID bigint identity(1,1),
	PackageID int,
	SourceDim nvarchar(255),
	SourceID int,
	RunDate Datetime,
	Constraint AnomaliesID_pk primary key(AnomaliesID),
	Constraint Anomaliespackage_fk foreign key(PackageID) references Control.Package(PackageID_Pk)

)


Create table Control.Matrics
(
	MatricsID bigint identity(1,1),
	PackageID_pk int,
	StgSourceCount int,
	StgDestCount int,
	PreCount int,
	CurrentCount int,
	PostCount int,
	Type1Count int,
	Type2Count int,
	RunDate datetime,
	Constraint MatricsID_sk primary key(MatricsID),
	Constraint MatricsPackageID_fk foreign key(PackageID_pk) references control.Package(PackageID_pk) 
)

ALTER AUTHORIZATION ON DATABASE::[Grocery_Control] TO [SA]


------16/04/2022---------
Use [Grocery_Control]
select * from control.Package where PackageTypeID_pk = 1
select * from Control.Matrics

-----SCS == Slow Changing Dimension
DATES		OLTP  STAGING	  EDW		Precount  Postcount  Precount(edw)  PostCount(edw)  Type1Count(SCD)  Type2count(SCD)
15/04/2022	40		40		0+50=50		   0		40			0				40
16/04/2022	100	   100     50+100=150     50       100         50              
17/04/2022	30      30
18/04/2022	60      60



Use [Grocery_OLTP2]
Select Count(*) as StgSourceCount from Product

Use [Grocery_Staging]
Select Count(*) as StgSourceCount from Grocery_OLTP2.Product

Use [Grocery_OLTP2]
Select Count(*) as StgSourceCount from Product p
inner join Department d on p.DepartmentID=d.DepartmentID

Use [Grocery_Control]
declare @PackageId int =?
declare @SourceCount int =?
declare @DestCount int =?
insert into control.Matrics (PackageID_pk, StgSourceCount, StgDestCount, RunDate)
					Select	@PackageId,	@SourceCount, @DestCount,	getDate()

update control.Package set LastRunDate=GetDate() where PackageID_pk=@PackageId


declare @PackageId int = ?
declare @PreCount int = ?
declare @CurrentCount int = ?
declare @PostCount int = ?
declare @Type1Count int = ?
declare @Type2Count int = ?
insert into control.Matrics (PackageID_pk, PreCount, CurrentCount, PostCount, Type1Count, Type2Count, RunDate)
					select @PackageID,		@PreCount,	@CurrentCount, @PostCount,  @Type1Count, @Type2Count, getDate()

update control.Package set LastRunDate=GetDate() where PackageID_pk=@PackageID


Use [Grocery_Staging]
Select count (*) From Grocery_OLTP2.Location



