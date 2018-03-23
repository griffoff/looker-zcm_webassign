view: dim_discipline {
  sql_table_name: WA2ANALYTICS.DIM_DISCIPLINE ;;

  dimension: dim_discipline_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_DISCIPLINE_ID ;;
  }

  dimension: discipline_id {
    type: number
    sql: ${TABLE}.DISCIPLINE_ID ;;
  }

  dimension: discipline_name {
    type: string
    sql: ${TABLE}.DISCIPLINE_NAME ;;
  }

  dimension: sub_discipline_id {
    type: number
    sql: ${TABLE}.SUB_DISCIPLINE_ID ;;
  }

  dimension: sub_discipline_name {
    type: string
    sql: ${TABLE}.SUB_DISCIPLINE_NAME ;;
  }

  measure: count {
    type: count
    drill_fields: [dim_discipline_id, discipline_name, sub_discipline_name, dim_section.count, dim_textbook.count]
  }
}
