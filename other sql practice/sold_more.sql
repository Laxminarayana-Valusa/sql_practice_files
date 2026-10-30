SELECT 
  date_sold,
  ABS(sum(case when product = 'Cake' then amount_sold else 0 end)-
      sum(case when product = 'Pie' then amount_sold else 0 end)) as difference,
  case 
    when sum(case when product = 'Cake' then amount_sold else 0 end) >
         sum(case when product = 'Pie' then amount_sold else 0 end)
    then 'Cake'
    else 'Pie'
  end as sold_more
FROM desserts
group by date_sold
order by date_sold
;