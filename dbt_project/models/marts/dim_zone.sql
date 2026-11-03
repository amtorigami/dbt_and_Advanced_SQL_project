-- dimension zone, type 1 : un nom de quartier ne change quasiment jamais
select
    zone_id,
    zone_name,
    city
from {{ ref('stg_zones') }}
