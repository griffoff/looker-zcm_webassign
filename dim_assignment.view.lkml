view: dim_assignment {
  sql_table_name: WA2ANALYTICS.DIM_ASSIGNMENT ;;

  dimension: dim_assignment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_ASSIGNMENT_ID ;;
  }

  dimension: assignment_id {
    type: number
    sql: ${TABLE}.ASSIGNMENT_ID ;;
  }

  dimension: author {
    type: number
    sql: ${TABLE}.AUTHOR ;;
  }

  dimension: author_name {
    type: string
    sql: ${TABLE}.AUTHOR_NAME ;;
  }

  dimension: author_school {
    type: number
    sql: ${TABLE}.AUTHOR_SCHOOL ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.CODE ;;
  }

  dimension: date_from {
    type: string
    sql: ${TABLE}.DATE_FROM ;;
  }

  dimension: date_to {
    type: string
    sql: ${TABLE}.DATE_TO ;;
  }

  dimension: delivery_method {
    type: string
    sql: ${TABLE}.DELIVERY_METHOD ;;
  }

  dimension: deprecated {
    type: string
    sql: ${TABLE}.DEPRECATED ;;
  }

  dimension: dim_assignment_feedback_id_after {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_ASSIGNMENT_FEEDBACK_ID_AFTER ;;
  }

  dimension: dim_assignment_feedback_id_before {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_ASSIGNMENT_FEEDBACK_ID_BEFORE ;;
  }

  dimension: dim_time_id_first_save_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_FIRST_SAVE_ET ;;
  }

  dimension: dim_time_id_last_save_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_LAST_SAVE_ET ;;
  }

  dimension: feedback_after {
    type: string
    sql: ${TABLE}.FEEDBACK_AFTER ;;
  }

  dimension: feedback_before {
    type: string
    sql: ${TABLE}.FEEDBACK_BEFORE ;;
  }

  dimension_group: first_save_et {
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
    sql: ${TABLE}.FIRST_SAVE_ET ;;
  }

  dimension: grade_which {
    type: string
    sql: ${TABLE}.GRADE_WHICH ;;
  }

  dimension_group: last_save_et {
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
    sql: ${TABLE}.LAST_SAVE_ET ;;
  }

  dimension: locked {
    type: string
    sql: ${TABLE}.LOCKED ;;
  }

  dimension: manual {
    type: string
    sql: ${TABLE}.MANUAL ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }

  dimension: no_sigfigs {
    type: string
    sql: ${TABLE}.NO_SIGFIGS ;;
  }

  dimension: pool {
    type: string
    sql: ${TABLE}.POOL ;;
  }

  dimension: psp {
    type: string
    sql: ${TABLE}.PSP ;;
  }

  dimension: randomise_order {
    type: string
    sql: ${TABLE}.RANDOMISE_ORDER ;;
  }

  dimension: randomization {
    type: string
    sql: ${TABLE}.RANDOMIZATION ;;
  }

  dimension: sigfigs_tolerance_override {
    type: string
    sql: ${TABLE}.SIGFIGS_TOLERANCE_OVERRIDE ;;
  }

  dimension: smw_mode {
    type: string
    sql: ${TABLE}.SMW_MODE ;;
  }

  dimension: smw_value {
    type: number
    sql: ${TABLE}.SMW_VALUE ;;
  }

  dimension: submission {
    type: string
    sql: ${TABLE}.SUBMISSION ;;
  }

  dimension: submissions {
    type: number
    sql: ${TABLE}.SUBMISSIONS ;;
  }

  dimension: template_id {
    type: number
    sql: ${TABLE}.TEMPLATE_ID ;;
  }

  dimension: template_name {
    type: string
    sql: ${TABLE}.TEMPLATE_NAME ;;
  }

  dimension: trashed {
    type: string
    sql: ${TABLE}.TRASHED ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [dim_assignment_id, name, author_name, template_name, dim_deployment.count]
  }
}
