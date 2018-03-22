view: attemptsbyquestion {
  sql_table_name: WA2ANALYTICS.ATTEMPTSBYQUESTION ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: attemptnum {
    type: number
    sql: ${TABLE}.ATTEMPTNUM ;;
  }

  dimension_group: createdat {
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
    sql: ${TABLE}.CREATEDAT ;;
  }

  dimension: percentcorrect {
    type: number
    sql: ${TABLE}.PERCENTCORRECT ;;
  }

  dimension: questionid {
    type: number
    value_format_name: id
    sql: ${TABLE}.QUESTIONID ;;
  }

  dimension: sectionid {
    type: number
    value_format_name: id
    sql: ${TABLE}.SECTIONID ;;
  }

  dimension: sectionslessonid {
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}.SECTIONSLESSONID ;;
  }

  dimension_group: updatedat {
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
    sql: ${TABLE}.UPDATEDAT ;;
  }

  measure: count {
    type: count
    drill_fields: [id, sectionslessons.id, sectionslessons.lessonname]
  }
}
