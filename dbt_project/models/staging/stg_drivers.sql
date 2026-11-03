select
    driver_id::int          as driver_id,
    driver_name             as driver_name,
    phone                   as phone_number,
    city                    as city,
    rating::numeric(3,2)    as rating,
    joined_date::date       as joined_date
from {{ source('raw', 'raw_drivers') }}
