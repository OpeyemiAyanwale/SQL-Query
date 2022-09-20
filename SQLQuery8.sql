Use Grocery_Staging
Go
create schema Grocery_OLTP

create table Grocery_OLTP.Overtime
(
	OvertimeID bigint,
	EmployeeID nvarchar(50),
	firstName nvarchar(50),
	lastName nvarchar(50),
	StartOvertime datetime,
	EndOvertime datetime,
	LoadDate datetime,
	Constraint grocery_Overtime_PK primary key(OvertimeId)
)



Use Grocery_WareHouse
Go
create schema EDW

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
