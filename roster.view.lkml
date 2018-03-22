view: roster {
  sql_table_name: WA2ANALYTICS.ROSTER ;;

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension_group: dropdate {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.DROPDATE ;;
  }

  dimension: nickname {
    type: string
    sql: ${TABLE}.NICKNAME ;;
  }

  dimension_group: payment_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.PAYMENT_SYNCED ;;
  }

  dimension: section {
    type: number
    sql: ${TABLE}.SECTION ;;
  }

  dimension_group: synced_to_cengage {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.SYNCED_TO_CENGAGE ;;
  }

  dimension: user {
    type: number
    sql: ${TABLE}."USER" ;;
  }

  measure: count {
    type: count
    drill_fields: [nickname]
  }
}
