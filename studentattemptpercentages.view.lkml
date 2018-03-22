view: studentattemptpercentages {
  sql_table_name: WA2ANALYTICS.STUDENTATTEMPTPERCENTAGES ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: boxnum {
    type: number
    sql: ${TABLE}.BOXNUM ;;
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

  dimension: percentattempted {
    type: number
    sql: ${TABLE}.PERCENTATTEMPTED ;;
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
