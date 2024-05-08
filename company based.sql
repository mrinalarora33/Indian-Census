select * from project..['Payroll_Data']
select * from ['Terminated_Employees']

-- no. of rows in dataset
select count(*) from ['Payroll_Data']
select count(*) from ['Terminated_Employees']

-- dataset for trades and accounting
select* from ['Payroll_Data'] where Occupation in ('trades' , 'accounting')

-- total salary
select sum([Annual_Salary]) as Annual_Salary from ['Payroll_Data']

-- avg consulting time
select occupation,AVG([Consulting_Time_%]) consulting_time from ['Payroll_Data'] group by Occupation

-- avg age
select occupation,round(AVG(Age),0) avg_age from ['Terminated_Employees'] group by Occupation order by avg_age desc

-- avg years of service
select occupation,round(AVG([Years of Service]),0) avg_years_of_service from ['Terminated_Employees'] 
group by Occupation having round(AVG([Years of Service]),0)>20 order by avg_years_of_service desc 

-- top 3 occupation showing highest consulting time

select top 3 occupation,AVG([Consulting_Time_%]) consulting_time from ['Payroll_Data'] 
group by Occupation order by consulting_time desc

-- bottom 3 occupation showing lowest age
select top 3 occupation,round(AVG(Age),0) avg_age from ['Terminated_Employees'] 
group by Occupation order by avg_age asc

-- top and bottom 3 occupation in consulting time
drop table if exists topoccupation
create table topoccupation 
(occupation nvarchar(255),
topoccupation float)
insert into topoccupation

select occupation,round(AVG(Age),0) avg_age from ['Terminated_Employees'] 
group by Occupation order by avg_age desc

select top 3* from topoccupation order by topoccupation desc

drop table if exists bottomoccupation
create table bottomoccupation 
(occupation nvarchar(255),
bottomoccupation float)
insert into bottomoccupation

select occupation,round(AVG(Age),0) avg_age from ['Terminated_Employees'] 
group by Occupation order by avg_age desc

select top 3* from bottomoccupation order by bottomoccupation asc

--union operator
select * from(
select top 3* from topoccupation order by topoccupation desc )a
union
select * from(
select top 3* from bottomoccupation order by bottomoccupation asc)b

-- division startin from letter C
select * from ['Payroll_Data'] where lower(division) like 'c%'
select Division from ['Payroll_Data'] where lower(division) like 'c%'
select distinct Division from ['Payroll_Data'] where lower(division) like 'c%' or lower(division) like 'm%'

-- start with u end with y
select distinct Division from ['Payroll_Data'] where lower(division) like 'u%' and lower(division) like '%y'

-- joining tables
select a.Employee_ID,a.Occupation,a.Gender,b.[Termination Reason] from ['Payroll_Data'] a 
inner join  
['Terminated_Employees'] b on a.Employee_ID=b.Employee_ID

--window fn- output top 3 consulting time from occupation with highest years of service
select a.* from
(select [Consulting_Time %],Occupation,[Years of Service],rank() over(partition by Occupation order by [Years of Service] desc ) rnk  from ['Terminated_Employees'])a
where a.rnk in (1,2,3) order by Occupation