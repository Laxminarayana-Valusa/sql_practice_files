 -- top 25% campaigns that have highest ROI 
WITH Campaign_ROI AS (
    SELECT
        campaign_id,
        campaign_name,
        ROUND(((revenue_generated - investment) / investment) * 100) AS ROI
    FROM
        marketing_spend
),
Top_25_Percent AS (
  select *,
      Percent_Rank() over(order by ROI desc) as percentile_rank
   FROM
        Campaign_ROI
)
select
    campaign_id,
    campaign_name,
    ROI
from 
  Top_25_Percent
where
  percentile_rank <=0.25
order by
  ROI desc,
  campaign_id desc;
