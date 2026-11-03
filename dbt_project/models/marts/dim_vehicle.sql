-- dimension vehicule, type 1 : on garde juste l'etat actuel, pas d'historique
select
    vehicle_id,
    driver_id,
    make,
    model,
    plate_number,
    vehicle_type
from {{ ref('stg_vehicles') }}
