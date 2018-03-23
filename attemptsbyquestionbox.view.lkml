view: attemptsbyquestionbox {
  sql_table_name: WA2ANALYTICS.ATTEMPTSBYQUESTIONBOX ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: attemptnumber {
    type: number
    sql: ${TABLE}.ATTEMPTNUMBER ;;
  }

  dimension: avgpercentcorrect {
    type: number
    sql: ${TABLE}.AVGPERCENTCORRECT ;;
  }

  dimension: boxnumber {
    type: number
    sql: ${TABLE}.BOXNUMBER ;;
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
