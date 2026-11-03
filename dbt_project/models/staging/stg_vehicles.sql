select
    vehicle_id::int         as vehicle_id,
    driver_id::int          as driver_id,
    make                    as make,
    model                   as model,
    plate_number            as plate_number,
    vehicle_type            as vehicle_type
from {{ source('raw', 'raw_vehicles') }}
