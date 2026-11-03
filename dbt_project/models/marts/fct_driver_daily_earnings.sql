with daily as (
    select
        driver_id,
        requested_at::date as ride_date,
        sum(fare_amount)   as daily_earnings
    from {{ ref('fact_rides') }}
    group by 1, 2
)

select
    driver_id,
    ride_date,
    daily_earnings,
    sum(daily_earnings) over (
        partition by driver_id order by ride_date
    ) as cumulative_earnings,
    rank() over (
        partition by ride_date order by daily_earnings desc
    ) as daily_rank
from daily
