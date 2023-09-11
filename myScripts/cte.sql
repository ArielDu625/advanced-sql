-- common table expression(CTE)

 /* challenge 1 : create a report showing the total sales per year. */
 with sales_cte (soldYear, salesAmount) as (
 select strftime('%Y', soldDate) as soldYear,
    salesAmount
from sales
)
select soldYear, 
    -- sum(salesAmount) as totalSales
    format("$%.2f", sum(salesAmount)) as totalSales
from sales_cte
group by soldYear
order by soldYear;


--  CASE statement

/* challenge 2: create a report that shows the amount of sales per employee for each month in 2021. */
select emp.employeeId,
    emp.firstName,
    emp.lastName,
    SUM(CASE 
        when strftime('%m', sls.soldDate) = '01' then sls.salesAmount 
    END) as JanSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '02' then sls.salesAmount 
    END) as FebSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '03' then sls.salesAmount 
    END) as MarSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '04' then sls.salesAmount 
    END) as AprSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '05' then sls.salesAmount 
    END) as MaySales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '06' then sls.salesAmount 
    END) as JunSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '07' then sls.salesAmount 
    END) as JulSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '08' then sls.salesAmount 
    END) as AugSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '09' then sls.salesAmount 
    END) as SepSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '10' then sls.salesAmount 
    END) as OctSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '11' then sls.salesAmount 
    END) as NovSales,
    SUM(CASE
        when strftime('%m', sls.soldDate) = '12' then sls.salesAmount 
    END) as DecSales
from sales sls
inner join employee emp
on sls.employeeId = emp.employeeId
where strftime('%Y', sls.soldDate) = '2021'
group by emp.employeeId, emp.firstName, emp.lastName
order by emp.employeeId;


select * 
from model
limit 10;

-- subquery
/*Find all sales where the car purchased was electric. */
select sls.*
    -- sls.salesId,
    -- sls.inventoryId,
    -- sls.employeeId,
    -- sls.salesAmount,
    -- sls.soldDate,
    -- a.EngineType
from sales sls
inner join(
    select inventory.inventoryId,
        model.modelId,
        model.EngineType
    from inventory
    inner join model
    on inventory.modelId = model.modelId
) as a
on sls.inventoryId = a.inventoryId
where a.engineType = "Electric";