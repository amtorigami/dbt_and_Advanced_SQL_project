select
    r.ride_id,
    r.driver_id,               
    r.pickup_zone_id,
    r.dropoff_zone_id,
    r.distance_km,
    r.fare_amount,
    r.requested_at,
    v.vehicle_id,
    v.vehicle_type,
    d.rating                              as driver_rating,
    {{ rating_bracket('d.rating') }}      as rating_bracket
from {{ ref('stg_ride_events') }} r
left join {{ ref('driver_snapshot') }} d
       on r.driver_id = d.driver_id
      and d.dbt_valid_to is null         
left join {{ ref('stg_vehicles') }} v
       on r.driver_id = v.driver_id       
