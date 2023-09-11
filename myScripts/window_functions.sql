-- window functions
/* challenge 1: get a list of sales people and rank the car models they've sold the most of. */

with added_row_number as (
select *,
    row_number() over (partition by employeeId order by model_cnt desc) as cnt_rank
from (
select sls_mdl.employeeId,
    sls_mdl.model,
    count(*) as model_cnt
from (
select sls.salesId,
    sls.inventoryId,
    sls.employeeId,
    inv_mdl.model
from sales sls
inner join (
    select inv.inventoryId,
        mdl.model
    from inventory inv
    inner join model mdl
    on inv.modelId = mdl.modelId
) as inv_mdl
on sls.inventoryId = inv_mdl.inventoryId
) as sls_mdl
group by sls_mdl.employeeId, sls_mdl.model
)
)
select 
    emp.employeeId,
    emp.firstName,
    emp.lastName,
    added_row_number.model,
    added_row_number.model_cnt,
    added_row_number.cnt_rank
from added_row_number
left join employee emp
on added_row_number.employeeId = emp.employeeId;


select emp.employeeId,
    emp.firstName,
    emp.lastName,
    mdl.model,
    count(model) as numberSold,
    rank() over (partition by emp.employeeId order by count(model) desc) as rank
from sales sls
inner join employee emp
on sls.employeeId = emp.employeeId
inner join inventory inv
on sls.inventoryId = inv.inventoryId
inner join model mdl
on inv.modelId = mdl.modelId
group by emp.employeeId, mdl.model


/* challenge 2: generate a sales report showing total sales per month and an annual running total. */
with sale_per_month (soldYear, soldMonth, salesAmount) as (
    select strftime('%Y', soldDate) as soldYear,
        strftime('%m', soldDate) as soldMonth,
        sum(salesAmount) as salesAmount
    from sales
    group by soldYear, soldMonth
)
select soldYear,
    soldMonth,
    salesAmount,
    sum(salesAmount) over (
        partition by soldYear 
        order by soldMonth) as annualRunningTotal
from sale_per_month;


/* challenge 3: create a report showing the number of cars sold this month and last month. */
with soldCount_per_month (soldMonth, soldCount) as (
    select strftime('%Y-%m', soldDate) as soldMonth,
        count(salesId) as soldCount
    from sales
    group by soldMonth
)
select soldMonth,
    soldCount as soldThisMonth,
    lag(soldCount, 1, 0) over (order by soldMonth) as soldLastMonth
from soldCount_per_month;