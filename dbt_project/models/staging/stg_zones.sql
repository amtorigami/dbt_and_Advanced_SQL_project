select
    zone_id::int            as zone_id,
    zone_name               as zone_name,
    city                    as city
from {{ source('raw', 'raw_zones') }}
