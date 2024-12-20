drop table if exists sales_running_totals;
create temp table sales_running_totals as
select
	row_number() 
		over(
			partition by extract(year from orderdate + interval '6 months')
			order by orderdate
		) as "OrderNumber",
	salesorderid,
	extract(year from orderdate + interval '6 months') as "FY",
	orderdate::DATE as "OrderDate",
	subtotal,
	sum(subtotal) 
		over(
			partition by extract(year from orderdate + interval '6 months')
			order by orderdate
			rows unbounded preceding
		) as "RunningTotal"
from sales.salesorderheader;

select distinct on ("FY") *
from sales_running_totals
where 
	"RunningTotal" > 10000000
	and "FY" in (2012, 2013, 2014)
order by
	"FY", "OrderNumber";





-- select * from sales.salesorderheader limit 10;
-- select * from sales_running_totals limit 10;
-- drop table if exists sales_running_totals;

