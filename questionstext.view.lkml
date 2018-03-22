view: questionstext {
  sql_table_name: WA2ANALYTICS.QUESTIONSTEXT ;;

  dimension: answer {
    type: string
    sql: ${TABLE}.ANSWER ;;
  }

  dimension: question {
    type: string
    sql: ${TABLE}.QUESTION ;;
  }

  dimension: questionid {
    type: number
    value_format_name: id
    sql: ${TABLE}.QUESTIONID ;;
  }

  dimension: solution {
    type: string
    sql: ${TABLE}.SOLUTION ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
