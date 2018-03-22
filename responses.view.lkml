view: responses {
  sql_table_name: WA2ANALYTICS.RESPONSES ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: attemptnumber {
    type: number
    sql: ${TABLE}.ATTEMPTNUMBER ;;
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

  dimension: iscorrect {
    type: number
    sql: ${TABLE}.ISCORRECT ;;
  }

  dimension: overridescore {
    type: number
    sql: ${TABLE}.OVERRIDESCORE ;;
  }

  dimension: pointsscored {
    type: number
    sql: ${TABLE}.POINTSSCORED ;;
  }

  dimension: questionid {
    type: number
    value_format_name: id
    sql: ${TABLE}.QUESTIONID ;;
  }

  dimension: sectionslessonsid {
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}.SECTIONSLESSONSID ;;
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

  dimension: userid {
    type: number
    value_format_name: id
    sql: ${TABLE}.USERID ;;
  }

  measure: count {
    type: count
    drill_fields: [id, sectionslessons.id, sectionslessons.lessonname]
  }
}
