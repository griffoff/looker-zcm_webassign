include: "/webassign/dim_time.view.lkml"

view: dim_time_zcm {
  extends: [dim_time]
  label: "Dim Time"
  derived_table: {
    sql:
  with x as (
   select
            distinct t.special_ay_year
            , dense_rank() over (ORDER BY t.special_ay_year desc) as special_ay_order
    from WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION f
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.dim_time t on f.dim_time_id = t.dim_time_id
)
select
          dt.*
        , x.special_ay_order
        , -(x.special_ay_order -1) as ay_value
from WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TIME dt
left join x on dt.special_ay_year = x.special_ay_year
;;
  }

# dimension: dim_time_id {}

  dimension: special_ay_order {
    type: number
    hidden: yes
  }

  dimension: ay_value {
    type: number
    label: "Special AY Year Order"
    description: "Current AY =0, prior year = -1, 2 years ago = -2, etc"
#    sql: -(${special_ay_order} - 1) ;;
    sql: ${TABLE}.ay_value  ;;
  }




  dimension: ay_start_year {
    type: number
    sql: left(${special_ay_year},4) ;;
  }

  dimension: ay_end_year {
    type: number
    sql: right(${special_ay_year},4) ;;
  }


}
