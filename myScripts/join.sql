-- check the employee table info
SELECT sql
FROM sqlite_schema
WHERE name = "employee";

/* challenge 1: Retrieve a list of employers, including first and last names,
              and the first and last names of their immediate managers. */
SELECT emp.firstName, 
    emp.lastName, 
    mag.firstName as managerFirstName, 
    mag.lastName as managerLastName
FROM employee emp
INNER JOIN employee mag
on emp.managerId = mag.employeeId;

-- check the sales table info
select sql
from sqlite_schema
where name="sales";

/* challenge 2: get a list of salespeople with zero sales. */
SELECT emp.*
FROM employee emp
LEFT JOIN sales
ON emp.employeeId = sales.employeeId
WHERE emp.title="Sales Person" and sales.salesId IS NULL;

-- check the customer table info
select sql
from sqlite_schema
where name="customer";

/* challenge 3: get a list of all sales and all customers even if
                some of the data has been removed. */
-- sqlite doesn't support full outer join operation

-- customers with sales data
SELECT 
    -- customer.customerId,
    customer.firstName,
    customer.lastName,
    customer.email,
    sales.salesAmount,
    sales.soldDate
FROM customer
INNER JOIN sales
ON customer.customerId = sales.customerId
UNION
-- union customers without sales data
SELECT 
    -- customer.customerId,
    customer.firstName,
    customer.lastName,
    customer.email,
    sales.salesAmount,
    sales.soldDate
FROM customer
LEFT JOIN sales
ON customer.customerId = sales.customerId
WHERE sales.salesId IS NULL
UNION
-- union sales data without customer info
SELECT
    -- customer.customerId,
    customer.firstName,
    customer.lastName,
    customer.email,
    sales.salesAmount,
    sales.soldDate
FROM sales
LEFT JOIN customer
ON sales.customerId = customer.customerId
WHERE customer.customerId IS NULL;

-- union operation includes only unique records while union all operation includes all records.
-- here whether return customer.customerId will affect the number of final returned records.