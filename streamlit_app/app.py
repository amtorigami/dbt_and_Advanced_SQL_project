import pathlib

import pandas as pd
import psycopg2
import streamlit as st
import yaml

st.set_page_config(page_title="InDrive Analytics", layout="wide")


@st.cache_resource
def connexion():
    profils = yaml.safe_load(open(pathlib.Path.home() / ".dbt" / "profiles.yml"))
    p = profils["indrive_analytics"]
    cfg = p["outputs"][p.get("target", "dev")]
    conn = psycopg2.connect(
        host=cfg["host"],
        port=cfg["port"],
        user=cfg["user"],
        password=cfg.get("pass") or cfg.get("password"),
        dbname=cfg.get("dbname") or cfg.get("database"),
    )
    conn.autocommit = True
    return conn


@st.cache_data
def requete(sql):
    with connexion().cursor() as cur:
        cur.execute(sql)
        colonnes = [c.name for c in cur.description]
        return pd.DataFrame(cur.fetchall(), columns=colonnes)


st.title("InDrive Analytics")

kpi = requete("""
    select count(*) as courses,
           sum(fare_amount)::float as gains,
           count(distinct driver_id) as chauffeurs
    from dbt_dev.fact_rides
""").iloc[0]
c1, c2, c3 = st.columns(3)
c1.metric("Courses", int(kpi["courses"]))
c2.metric("Gains totaux", f"{kpi['gains']:,.0f}")
c3.metric("Chauffeurs", int(kpi["chauffeurs"]))

gains = requete("""
    select d.driver_name as chauffeur,
           f.ride_date,
           f.daily_earnings::float as gains_jour,
           f.cumulative_earnings::float as cumul,
           f.daily_rank
    from dbt_dev.fct_driver_daily_earnings f
    join dbt_dev.stg_drivers d using (driver_id)
""")

st.subheader("Cumul des gains par chauffeur")
cumul = gains.pivot(index="ride_date", columns="chauffeur", values="cumul").ffill()
st.line_chart(cumul)

st.subheader("Classement d'un jour")
jour = st.selectbox("Date", sorted(gains["ride_date"].unique()))
top = gains[gains["ride_date"] == jour].sort_values("daily_rank")
st.dataframe(
    top[["daily_rank", "chauffeur", "gains_jour"]],
    hide_index=True,
    use_container_width=True,
)

g1, g2 = st.columns(2)

zones = requete("""
    select z.zone_name as zone, sum(f.fare_amount)::float as gains
    from dbt_dev.fact_rides f
    join dbt_dev.dim_zone z on f.pickup_zone_id = z.zone_id
    group by 1
    order by 2 desc
""")
g1.subheader("Gains par zone de départ")
g1.bar_chart(zones.set_index("zone"))

tranches = requete("""
    select rating_bracket as tranche, count(*) as courses
    from dbt_dev.fact_rides
    group by 1
""")
g2.subheader("Courses par tranche de note")
g2.bar_chart(tranches.set_index("tranche"))
