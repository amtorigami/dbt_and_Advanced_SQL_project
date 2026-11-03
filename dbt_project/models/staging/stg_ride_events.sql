select
    ride_id                     as ride_id,
    driver_id::int              as driver_id,
    pickup_zone_id::int         as pickup_zone_id,
    dropoff_zone_id::int        as dropoff_zone_id,
    distance_km::numeric(6,1)   as distance_km,
    fare_amount::numeric(10,2)  as fare_amount,
    requested_at::timestamp     as requested_at
from {{ source('raw', 'raw_ride_events') }}
where requested_at >= '{{ var("start_date") }}'
