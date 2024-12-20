
drop table if exists promo_effect;
create temp table promo_effect as
select
	t1.salesorderid,
	t4.Name as ShipmentState,
	t1.orderdate,
	t1.subtotal as HistoricalSubtotal,
	t1.freight as HistoricalFreight,
	case
		when t1.subtotal >= 1700 and t1.subtotal < 2000
			then 'Increase order to $2000 and pay $0.22 freight'
		when t1.subtotal >= 2000
			then 'No order change but pay $0.22 freight'
		else 'No order change and pay historical freight'
	end as PromotionEffect,
	case
		when t1.subtotal >= 1700 and t1.subtotal < 2000
			then 2000 - t1.subtotal
		else 0
	end as OrderGain,
	case
		when t1.subtotal >= 1700 
			then 0.22
		else t1.freight
	end - t1.freight as FreightLoss,
	case
		when t1.subtotal >= 1700 and t1.subtotal < 2000
			then 2000 - t1.subtotal
		else 0
	end 
	+
	case
		when t1.subtotal >= 1700 
			then 0.22
		else t1.freight
	end - t1.freight as "PromoNetGain/Loss"
from sales.salesorderheader as t1
inner join person.businessentityaddress as t2
	on t1.shiptoaddressid = t2.businessentityid
inner join person.address as t3
	on t2.businessentityid = t3.addressid
inner join person.stateprovince as t4
	on t3.addressid = t4.stateprovinceid
where
	t4.name = 'California'
	and 
	extract(year from orderdate + interval '6 months') = 2014;


select
	promotioneffect,
	sum(ordergain) as ordergain,
	sum(freightloss) as freightloss,
	sum("PromoNetGain/Loss")
from promo_effect
group by promotioneffect;
	

--  select * from sales.salesorderheader;
-- select * from person.businessentityaddress;
--  select * from person.address;
--  select * from person.stateprovince;
-- select * from promo_effect;
-- drop table if exists promo_effect;

