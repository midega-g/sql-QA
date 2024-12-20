-- create temporary table for fiscal sales
drop table if exists fiscal_data;
create temp table fiscal_data as
select
	salespersonid,
	extract(year from orderdate + interval '6 months') as FY,
	extract(quarter from orderdate + interval '6 months') as FQ,
	sum(subtotal) as FQSales
from sales.salesorderheader
where onlineorderflag = false
group by
	salespersonid,
	extract(year from orderdate + interval '6 months'),
	extract(quarter from orderdate + interval '6 months');

-- check the temporary table
select * from fiscal_data order by fqsales desc;


-- create temporary table 
drop table if exists year_year_comp;

-- self-join the temporary table with other tables
create temp table year_year_comp as
select
	p.lastname,
	t1.salespersonid,
	t1.FY,
	t1.FQ,
	t1.FQSales,
	t2.FQSales as FQSalesPrevious,
	t1.FQSales - t2.FQSales as Change,
	round(((t1.FQSales - t2.FQSales)/t2.FQSales * 100), 1) as PerctanageChange
from fiscal_data t1
left join fiscal_data t2
	on t1.salespersonid = t2.salespersonid
	and t1.FY - 1 = t2.FY
	and t1.FQ = t2.FQ
inner join person.person p
	on t1.salespersonid = p.businessentityid
where t1.FY = 2014
order by salespersonid;

-- check the temporary (final) table
select * from year_year_comp;
	












	
