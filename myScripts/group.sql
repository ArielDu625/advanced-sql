select sql
from sqlite_schema
where name="sales";

/* challenge 1: pull a report that totals the number of cars sold by each employee*/
select emp.employeeId,
    emp.firstName,
    emp.lastName,
    count(*) as totalNumOfCarsSold
from employee emp
inner join sales sls
on emp.employeeId=sls.employeeId
group by emp.employeeId
order by totalNumOfCarsSold desc;


/* challenge 2: produce a report that lists the least and most expensive car sold by each employee this year. */
select emp.employeeId,
    emp.firstName,
    emp.lastName,
    min(sls.salesAmount) as leastExpensive,
    max(sls.salesAmount) as mostExpensive
from employee emp
left join sales sls
on emp.employeeId=sls.employeeId
-- where strftime('%Y', sls.soldDate) = "2023"
where sls.soldDate >= date('now', 'start of year')
group by emp.employeeId;


/* challenge 3: get a list of employees who have made more than five sales this year */
select emp.employeeId,
    emp.firstName,
    emp.lastName,
    count(*) as totalNumOfCarsSold
from employee emp
inner join sales sls
on emp.employeeId=sls.employeeId
where sls.soldDate >= date('now', 'start of year')
group by emp.employeeId
having totalNumOfCarsSold > 5
order by totalNumOfCarsSold;