create table ProdFacility
(
Contract_Reference nvarchar(100) Primary Key,
Amount float,
Amount_1 float,
Amount_2 float,
Used_Amount float,
Available_Amount float
Foreign Key (Contract_Reference) References QAFacility (Contract_Reference)
)

select * from QAFacility
select * from ProdFacility

select q.Contract_Reference, p.Contract_Reference, q.Amount, p.Amount, (q.Amount - p.Amount) as DiffAmount, q.Amount_1, p.Amount_1,
(q.Amount_1-p.Amount_1) as DiffAmount_1, q.Amount_2, p.Amount_2, (q.Amount_2-p.Amount_2) as DiffAmount_2, q.Used_Amount, p.Used_Amount, 
(q.Used_Amount-p.Used_Amount) as DiffUsedAmount, q.Available_Amount, p.Available_Amount, (q.Available_Amount-p.Available_Amount) as DiffAvailAmount
from QAFacility q Left Join ProdFacility p on q.Contract_Reference = p.Contract_Reference

create table QALoandepo
(
Contract_Reference nvarchar(100) Primary Key,
Nominal float,
Accruals float,
Outstanding float
)

create table ProdLoandepo
(
Contract_Reference nvarchar(100) Primary Key,
Nominal float,
Accruals float,
Outstanding float
Foreign Key (Contract_Reference) References QALoandepo (Contract_Reference)
)

select * from QALoandepo
select * from ProdLoandepo

select q.Contract_Reference, p.Contract_Reference, q.Nominal, p.Nominal, (q.Nominal - p.Nominal) as DiffNominal, 
q.Accruals, p.Accruals, (q.Accruals - p.Accruals) as DiffAccruals, q.Outstanding, p.Outstanding, (q.Outstanding - p.Outstanding)
as DiffOustanding from QALoandepo q Left Join ProdLoandepo p on q.Contract_Reference = p.Contract_Reference


create table RetailExposure
(
Contract_Reference nvarchar(100) Primary Key,
Outstanding float,
Dim8 nvarchar(255),
Accrued_Interests float,
Max_Exposure_Amount float,
Available_Amount float
Foreign Key (Contract_Reference) References QAFacility (Contract_Reference)
)

drop table RetailExposure

select q.Contract_Reference, r.Contract_Reference, q.Outstanding, r.outstanding, (q.Outstanding - r.Outstanding)
as DiffOustanding, q.Accruals, r.accrued_interests, (q.Accruals-r.accrued_interests) as DiffAccrued_Interests
from QALoandepo q Left Join Retail r on q.Contract_Reference=r.Contract_Reference

select * from retail
where Dim8 = '58-4000169284'

select Dim8 from retail where Dim8 = Null


With RetCTE as
(
  select *, Row_Number() over (Partition By Dim8 order By Dim8) as RowNumber 
  from Retail
)
select Dim8, count(Dim8) from RetCTE
where RowNumber > 1

With Result as
(
select Dim8, Row_Number() over (Partition By Dim8 order By Dim8) as RowNumber
from Retail
) 
select Dim8 from Result where Result.RowNumber != 1 group by Dim8 

select q.Contract_Reference, r.CONTRACT_REFERENCE, r.Dim8, q.Amount, r.Max_Exposure_Amount, (q.Amount - r.Max_Exposure_Amount) as DiffMax_Amount, 
q.Available_Amount, r.Available_Amount, (q.Available_Amount-r.Available_Amount) as DiffAvailAmount
from QAFacility q left Join retail r on q.Contract_Reference = r.Dim8

select q.Contract_Reference, r.CONTRACT_REFERENCE, r.Dim8, q.Amount, r.Max_Exposure_Amount, (q.Amount - r.Max_Exposure_Amount) as DiffMax_Amount, 
q.Available_Amount, r.Available_Amount, (q.Available_Amount-r.Available_Amount) as DiffAvailAmount
from QAFacility q right Join retail r on q.Contract_Reference = r.Dim8

select Dim8 from retail

