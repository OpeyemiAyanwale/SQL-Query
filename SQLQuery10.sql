create table Staging.Overtime
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

select OvertimeID, EmployeeNo, StartOvertime, EndOvertime, DATEDIFF(HOUR, StartOvertime, EndOvertime) as TotalOvertimehour from Staging.Overtime


