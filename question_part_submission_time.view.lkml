view: question_part_submission_time {
  sql_table_name: WA2ANALYTICS.QUESTION_PART_SUBMISSION_TIME ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: deployment {
    type: number
    sql: ${TABLE}.DEPLOYMENT ;;
  }

  dimension: duration {
    type: number
    sql: ${TABLE}.DURATION ;;
  }

  dimension: question_id {
    type: number
    sql: ${TABLE}.QUESTION_ID ;;
  }

  dimension: question_part_id {
    type: number
    sql: ${TABLE}.QUESTION_PART_ID ;;
  }

  dimension_group: submit_dt {
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
    sql: ${TABLE}.SUBMIT_DT ;;
  }

  dimension: user {
    type: number
    sql: ${TABLE}."USER" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
