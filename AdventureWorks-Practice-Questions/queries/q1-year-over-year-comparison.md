# Challenge 1:  Fiscal Quarter Sales Comparison (Year-Over-Year)

## Difficulty: Intermediate

An executive needs a report showing sales performance by fiscal quarter for each salesperson. The report should compare sales for the same fiscal quarters of 2013 and 2014.

**Example:**

If a salesperson made $1,000 in Fiscal Year 2014, Quarter 2, and $900 in Fiscal Year 2013, Quarter 2, this indicates an 11.1% growth for that quarter.

**Key Points:**

- The fiscal year for Adventure Works starts in July and ends in June, i.e., if `OrderDate` is between July 1, 2013, and June 30, 2014, it falls in Fiscal Year 2014.
- Revenue excludes tax and freight charges.
- Use the `OrderDate` column for date-based calculations.
- Only consider in-store orders (exclude online orders).
- Your output should include:

  - Salesperson’s last name (`LastName`)
  - Salesperson ID (`SalesPersonID`)
  - Fiscal year (`FY`)
  - Fiscal quarter (`FQ`)
  - Sales for the fiscal quarter (`FQSalesCurrent`)
  - Sales for the same quarter in the previous fiscal year (`FQSalesPrevious`)
  - Change in revenue i.e. absolute difference (`RevenueChange`)
  - Percent change in revenue (`%RevenueChange`)

**Hints**

**Tables to explore:**

  - `Sales.SalesOrderHeader` (for OrderDate and sales details)
  - `Sales.SalesPerson` (for salesperson information)
  - `Person.Person` (for LastName of salespeople)

**Useful columns:**

- `OrderDate` (to determine fiscal year and quarter)
- `SalesPersonID` (to identify the salesperson)
- `SubTotal` (for sales revenue, excluding tax and freight)
- `SalesPersonID` in SalesOrderHeader joins with SalesPerson


# Solution 1: Unified Table Approach

```sql
-- create temporary table for fiscal sales
drop table if exists fiscal_data;
create temp table fiscal_data as
select
	salespersonid,
	extract(year from orderdate + interval '6 months') as "FY",
	extract(quarter from orderdate + interval '6 months') as "FQ",
	sum(subtotal) as "FQSales"
from sales.salesorderheader
where onlineorderflag = false
group by
	salespersonid,
	extract(year from orderdate + interval '6 months'),
	extract(quarter from orderdate + interval '6 months');


-- uncomment to check the temporary table
-- select * from fiscal_data order by fqsales desc;


-- self-join the temporary table with other tables
select
	t3.lastname as "LastName",
	t1."FY",
	t1."FQ",
	t1."FQSales" as "FQSales14",
	t2."FQSales" as "FQSales13",
	t1."FQSales" - t2."FQSales" as "RevenueChange",
	round(((t1."FQSales" - t2."FQSales")/t2."FQSales" * 100), 4) as "%RevenueChange"
from fiscal_data t1
left join fiscal_data t2
	on t1.salespersonid = t2.salespersonid
	and t1."FY" - 1 = t2."FY"
	and t1."FQ" = t2."FQ"
inner join person.person t3
	on t1.salespersonid = t3.businessentityid
where t1."FY" = 2014
order by t3.lastname;
```


# Solution 1 Breakdown

In this solution, all data is first consolidated into a single temporary table (`fiscal_data`), which is then self-joined to perform year-over-year comparisons.

**Step 1: Create a temporary table**

- A temporary table (`fiscal_data`) is created to store fiscal year (`FY`), fiscal quarter (`FQ`), and sales (`FQSales`) for each salesperson.
- The `orderdate` is adjusted with a 6-month interval to align with the fiscal year (July–June).
- Sales data is grouped by salesperson, fiscal year, and fiscal quarter, and online orders are excluded.

**Step 2: Where the magic happens**
- The required columns to be displayed are defined in the query, specifying which table to get them from
- `t1`, which will be used as current fiscal year of 2014, is the temporary table `fiscal_data` created in step 1 and it is self-joined to produce `t2`, which will be used as the 2013 fiscal year.
- `t3` is from the `person.person` table where we get the `LastName` of each sales person involved
- The revenue difference and percentage change are also calculated for each salesperson for the specified fiscal quarter using relevant data from `t1` and `t2`
- For the self join, a `LEFT JOIN` is used to ensure that rows from `t1` (fiscal year 2014) are included even if there is no matching record in `t2` (fiscal year 2013)
- The conditions for this join also ensure that records are matched for the same fiscal quarter but one year apart (`t1."FY" - 1 = t2."FY"` and `t1."FQ" = t2."FQ"`).
- An `INNER JOIN` is the applied to ensure that only salespeople with valid data in the `person.person` table are included
- A filter is also applied to ensure that the analysis focuses on fiscal year 2014, as the base year, while at the same time pulling in comparative data for fiscal year 2013 
- The results are then sorted alphabetically by the salesperson’s last name

# Solution 2: Year-Specific Segmentation Approach


```sql
with 
	sales_performance_14 as (
		select
			salespersonid,
			extract(year from orderdate + interval '6 months') as "FY",
			extract(quarter from orderdate + interval '6 months') as "FQ",
			sum(subtotal) as "FQSalesCurrent"
		from sales.salesorderheader
		where extract(year from orderdate + interval '6 months') = 2014
		group by 
			salespersonid,
			extract(year from orderdate + interval '6 months'),
			extract(quarter from orderdate + interval '6 months')
	),
	sales_performance_13 as (
		select
			salespersonid,
			extract(year from orderdate + interval '6 months') as "FY",
			extract(quarter from orderdate + interval '6 months') as "FQ",
			sum(subtotal) as "FQSalesPrevious"
		from sales.salesorderheader
		where extract(year from orderdate + interval '6 months') = 2013
		group by 
			salespersonid,
			extract(year from orderdate + interval '6 months'),
			extract(quarter from orderdate + interval '6 months')
	)
select 
	t3.lastname,
	t1."FY",
	t1."FQ",
	t1."FQSalesCurrent",
	t2."FQSalesPrevious",
	t1."FQSalesCurrent" - t2."FQSalesPrevious" as "RevenueChange",
	round((t1."FQSalesCurrent" - t2."FQSalesPrevious")/t2."FQSalesPrevious" * 100, 4) as "%RevenueChange"
from sales_performance_14 as t1
left join sales_performance_13 as t2
	on t1.salespersonid = t2.salespersonid
	and t1."FQ" = t2."FQ"
inner join person.person as t3
	on t1.salespersonid = t3.businessentityid
order by t3.lastname;
```

# Solution 2 Breakdown

In this solution, data for each fiscal year is segregated into distinct datasets (`sales_performance_14` and `sales_performance_13`) before being joined and analyzed

**Step 1: Define the Common Table Expressions (CTEs)**  
- Two CTEs are created to store sales performance data for fiscal years 2014 (`sales_performance_14`) and 2013 (`sales_performance_13`)
- In both of these CTEs:
   - The fiscal year (`FY`), fiscal quarter (`FQ`), and sales (`FQSalesCurrent`) are extracted
   - The `orderdate` is adjusted with a 6-month interval to align with the fiscal year (July–June).
   - Data is grouped by salesperson, fiscal year, and fiscal quarter. 
	 
- The difference is that, for `sales_performance_14` CTE, only data for the fiscal year 2014 is included while `sales_performance_13` CTE contains sales data for fiscal year 2013.

**Step 2: Where the magic happens**
- Just like in Solution 1 (Step 2), this step retrieves the required columns to display, specifying which CTE or table to get them from.
- `t1` is derived from the `sales_performance_14` CTE while `t2` is derived from the `sales_performance_13` CTE
- `t3` is from the `person.person` table and is used to retrieve the `LastName` of each salesperson involved.
- A `LEFT JOIN` is then used to combine `t1` with `t2` to ensure that rows from `t1` are included even if there’s no matching record in `t2`.
- Here, the join conditions for the `LEFT JOIN` one ensures that there matches of rows for the same salesperson and that the same fiscal quarter is being compared across years.
- Similar to Solution 1 (Step 2), an `INNER JOIN` is used to combine the result with `person.person` (`t3`) to retrieve the salesperson’s last name to ensure that only salespeople with valid data in `person.person` are included.
- The results are then sorted alphabetically by the salesperson’s last name.


## **Weighing the Two Approaches**

While in the solutions I tried to use temporary table and CTEs, I could have only focused on only one for either case. However, you can make your preference based on this table:

| **Criteria**            | **Temporary Tables**                              | **CTEs**                                   |
|--------------------------|--------------------------------------------------|-------------------------------------------|
| **Performance**          | Faster for large datasets due to precomputed data. | Slower for large datasets, recomputes each time. |
| **Readability**          | Slightly harder to follow due to intermediate steps of creating and dropping tables. | Clearer and more modular query structure. |
| **Flexibility**          | Data can be reused and debugged easily.           | Suitable for one-time computations only.   |
| **Resource Usage**       | Consumes memory until dropped.                    | Uses memory only during execution.         |
| **Use Case**             | Ideal for iterative analysis and large datasets.  | Best for lightweight queries and one-time reports. |

