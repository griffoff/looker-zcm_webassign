view: dim_question_mode {
  sql_table_name: WA2ANALYTICS.DIM_QUESTION_MODE ;;

  dimension: dim_question_mode_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_QUESTION_MODE_ID ;;
  }

  dimension: hashcode {
    type: number
    sql: ${TABLE}.HASHCODE ;;
  }

  dimension: is_algebraic {
    type: string
    sql: ${TABLE}.IS_ALGEBRAIC ;;
  }

  dimension: is_essay {
    type: string
    sql: ${TABLE}.IS_ESSAY ;;
  }

  dimension: is_file_upload {
    type: string
    sql: ${TABLE}.IS_FILE_UPLOAD ;;
  }

  dimension: is_fill_in_the_blank {
    type: string
    sql: ${TABLE}.IS_FILL_IN_THE_BLANK ;;
  }

  dimension: is_graphing {
    type: string
    sql: ${TABLE}.IS_GRAPHING ;;
  }

  dimension: is_image_map {
    type: string
    sql: ${TABLE}.IS_IMAGE_MAP ;;
  }

  dimension: is_java {
    type: string
    sql: ${TABLE}.IS_JAVA ;;
  }

  dimension: is_matching {
    type: string
    sql: ${TABLE}.IS_MATCHING ;;
  }

  dimension: is_multiple_choice {
    type: string
    sql: ${TABLE}.IS_MULTIPLE_CHOICE ;;
  }

  dimension: is_multiple_select {
    type: string
    sql: ${TABLE}.IS_MULTIPLE_SELECT ;;
  }

  dimension: is_number_line {
    type: string
    sql: ${TABLE}.IS_NUMBER_LINE ;;
  }

  dimension: is_numerical {
    type: string
    sql: ${TABLE}.IS_NUMERICAL ;;
  }

  dimension: is_pencil_pad {
    type: string
    sql: ${TABLE}.IS_PENCIL_PAD ;;
  }

  dimension: is_poll {
    type: string
    sql: ${TABLE}.IS_POLL ;;
  }

  dimension: is_symbolic {
    type: string
    sql: ${TABLE}.IS_SYMBOLIC ;;
  }

  measure: count {
    type: count
    drill_fields: [dim_question_mode_id, dim_question.count]
  }
}
