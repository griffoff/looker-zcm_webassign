view: dim_payment_method {
  sql_table_name: WA2ANALYTICS.DIM_PAYMENT_METHOD ;;

  dimension: dim_payment_method_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_PAYMENT_METHOD_ID ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.DESCRIPTION ;;
  }

  dimension: redemption_model {
    type: yesno
    sql: ${TABLE}.REDEMPTION_MODEL ;;
  }

  measure: count {
    type: count
    drill_fields: [dim_payment_method_id, fact_registration.count]
  }
}
