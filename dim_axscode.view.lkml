view: dim_axscode {
  sql_table_name: WA2ANALYTICS.DIM_AXSCODE ;;

  dimension: dim_axscode_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_AXSCODE_ID ;;
  }

  dimension: admin_only {
    type: yesno
    sql: ${TABLE}.ADMIN_ONLY ;;
  }

  dimension: available {
    type: yesno
    sql: ${TABLE}.AVAILABLE ;;
  }

  dimension: axscode_id {
    type: number
    sql: ${TABLE}.AXSCODE_ID ;;
  }

  dimension: axscodedef_id {
    type: number
    sql: ${TABLE}.AXSCODEDEF_ID ;;
  }

  dimension: batch_id {
    type: number
    sql: ${TABLE}.BATCH_ID ;;
  }

  dimension: bookstore {
    type: yesno
    sql: ${TABLE}.BOOKSTORE ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.CODE ;;
  }

  dimension: codedef {
    type: string
    sql: ${TABLE}.CODEDEF ;;
  }

  dimension: created_et {
    type: string
    sql: ${TABLE}.CREATED_ET ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.DESCRIPTION ;;
  }

  dimension: grants_optional {
    type: string
    sql: ${TABLE}.GRANTS_OPTIONAL ;;
  }

  dimension: gross_sales_revenue {
    type: number
    sql: ${TABLE}.GROSS_SALES_REVENUE ;;
  }

  dimension: is_default {
    type: yesno
    sql: ${TABLE}.IS_DEFAULT ;;
  }

  dimension: net_sales_revenue {
    type: number
    sql: ${TABLE}.NET_SALES_REVENUE ;;
  }

  dimension: prefix {
    type: string
    sql: ${TABLE}.PREFIX ;;
  }

  dimension: reusable {
    type: string
    sql: ${TABLE}.REUSABLE ;;
  }

  dimension: reuse_gross {
    type: number
    sql: ${TABLE}.REUSE_GROSS ;;
  }

  dimension: reuse_net {
    type: number
    sql: ${TABLE}.REUSE_NET ;;
  }

  measure: count {
    type: count
    drill_fields: [dim_axscode_id, fact_registration.count]
  }
}
