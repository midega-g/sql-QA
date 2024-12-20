
select
	trim(to_char(orderdate, 'Month')) as "MonthName",
	sum(subtotal) as "Revenue",
	count(*) as "Orders",
	round((sum(subtotal) / count(*)), 4) as "RevenuePerOrder"
from sales.salesorderheader
where 
	extract(year from orderdate + interval '6 months') = 2014
	and onlineorderflag = false
group by 
	trim(to_char(orderdate, 'Month'))
order by 
	"RevenuePerOrder" DESC;

	


select
	to_char(orderdate, 'Dy') as "DayOfWeek",
	sum(subtotal) as "Revenue",
	count(*) as "Orders",
	round(sum(subtotal) / count(*), 4) as "RevenuePerOrder"
from sales.salesorderheader
where
	extract(year from orderdate + interval '6 months') = 2014
	and onlineorderflag = false
group by 
	to_char(orderdate, 'Dy')
order by 
	"RevenuePerOrder" DESC;
	

-- select * from sales.salesorderheader limit 10;


