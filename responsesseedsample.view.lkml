view: responsesseedsample {
  sql_table_name: WA2ANALYTICS.RESPONSESSEEDSAMPLE ;;

  dimension: attemptnumber {
    type: number
    sql: ${TABLE}.ATTEMPTNUMBER ;;
  }

  dimension: boxnum {
    type: number
    sql: ${TABLE}.BOXNUM ;;
  }

  dimension: questionid {
    type: number
    value_format_name: id
    sql: ${TABLE}.QUESTIONID ;;
  }

  dimension: response {
    type: string
    sql: ${TABLE}.RESPONSE ;;
  }

  dimension: sectionslessonsid {
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}.SECTIONSLESSONSID ;;
  }

  dimension: seed {
    type: number
    sql: ${TABLE}.SEED ;;
  }

  dimension: userid {
    type: number
    value_format_name: id
    sql: ${TABLE}.USERID ;;
  }

  measure: count {
    type: count
    drill_fields: [sectionslessons.id, sectionslessons.lessonname]
  }
}
