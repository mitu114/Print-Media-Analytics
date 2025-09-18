# QUERIES USED FOR MEDIA ANALYTICS PROJECT

# Q2 Top Performing Cities
# Which cities contributed the highest to net circulation and copies sold in 2024? 
# Are these cities still profitable to operate in?

with cte as (
select ad_category,ad_revenue,marketing_cost
from fact_ad_revenue_cleaned as r
left join fact_digital_pilot as p
on r.ad_category = p.ad_category_id
union
select ad_category,ad_revenue,marketing_cost
from fact_ad_revenue_cleaned as r
right join fact_digital_pilot as p
on r.ad_category = p.ad_category_id)

select city,round(sum(c.ad_revenue-c.marketing_cost),2) as profit
from cte as c
inner join fact_digital_pilot as d
on c.ad_category = d.ad_category_id
inner join dim_city as e
on e.city_id = d.city_id
where (c.ad_revenue-c.marketing_cost) >0
group by city;


# Q3 Print Waste Analysis
# Which cities have the largest gap between copies sold and net circulation, and 
# how has that gap changed over time?

select Month,(`Copies Sold`- Net_Circulation) as gap_sold_and_net_circulation
from fact_print_sales1;

#Q5 City-Level Ad Revenue Performance
#   Which cities generated the most ad revenue, and how does that correlate with their print circulation?

with city_ads as(
select p.city_id,city,ad_revenue
from fact_digital_pilot as p
join fact_ad_revenue_cleaned  as f on p.ad_category_id = f.ad_category
join dim_city as d on d.city_id = p.city_id)

select city,sum(ad_revenue),sum(Net_Circulation)
from city_ads as b
right join fact_print_sales1 as g
on b.city_id = g.City_ID
group by city;

# Q6. Digital Readiness vs. Performance
# Which cities show high digital readiness (based on smartphone, internet, and literacy rates) but had low digital pilot engagement?

with cte as(
select 
    p.city_id,
    c.city,
    r.literacy_rate,
    r.smartphone_penetration,
    r.internet_penetration,
    p.users_reached
from fact_city_readiness as r
left join dim_city as c on r.city_id = c.city_id
left join fact_digital_pilot as p on p.city_id = c.city_id
limit 0, 1000)
select city,round(avg(literacy_rate),2),round(avg(smartphone_penetration),2),round(avg(internet_penetration),2),sum(users_reached)
from cte
group by city
order by city;





