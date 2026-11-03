{% snapshot driver_snapshot %}

{{ config(
    target_schema='snapshots',
    unique_key='driver_id',
    strategy='check',
    check_cols=['rating']
) }}

-- a chaque dbt snapshot, dbt compare la note actuelle a celle deja stockee
select * from {{ ref('stg_drivers') }}

{% endsnapshot %}
