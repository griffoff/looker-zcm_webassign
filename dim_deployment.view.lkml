view: dim_deployment {
  sql_table_name: WA2ANALYTICS.DIM_DEPLOYMENT ;;

  dimension: dim_deployment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_DEPLOYMENT_ID ;;
  }

  dimension: assignment_id {
    type: number
    sql: ${TABLE}.ASSIGNMENT_ID ;;
  }

  dimension: automated_extensions {
    type: string
    sql: ${TABLE}.AUTOMATED_EXTENSIONS ;;
  }

  dimension: available {
    type: string
    sql: ${TABLE}.AVAILABLE ;;
  }

  dimension_group: begins_et {
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
    sql: ${TABLE}.BEGINS_ET ;;
  }

  dimension_group: date_from {
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
    sql: ${TABLE}.DATE_FROM ;;
  }

  dimension_group: date_to {
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
    sql: ${TABLE}.DATE_TO ;;
  }

  dimension: deployment_id {
    type: number
    sql: ${TABLE}.DEPLOYMENT_ID ;;
  }

  dimension: dim_assignment_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_ASSIGNMENT_ID ;;
  }

  dimension: dim_section_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_SECTION_ID ;;
  }

  dimension: dim_time_id_begins_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_BEGINS_ET ;;
  }

  dimension: dim_time_id_due_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_DUE_ET ;;
  }

  dimension: dim_time_id_ends_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_ENDS_ET ;;
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

  dimension: dim_time_id_user_deleted_at_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_USER_DELETED_AT_ET ;;
  }

  dimension_group: due_et {
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
    sql: ${TABLE}.DUE_ET ;;
  }

  dimension_group: ends_et {
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
    sql: ${TABLE}.ENDS_ET ;;
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

  dimension: ip_restricted {
    type: string
    sql: ${TABLE}.IP_RESTRICTED ;;
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

  dimension: lockdown_browser {
    type: string
    sql: ${TABLE}.LOCKDOWN_BROWSER ;;
  }

  dimension: logloc {
    type: string
    sql: ${TABLE}.LOGLOC ;;
  }

  dimension: password_protected {
    type: string
    sql: ${TABLE}.PASSWORD_PROTECTED ;;
  }

  dimension: psp {
    type: string
    sql: ${TABLE}.PSP ;;
  }

  dimension: section_id {
    type: number
    sql: ${TABLE}.SECTION_ID ;;
  }

  dimension: securexam_browser {
    type: string
    sql: ${TABLE}.SECUREXAM_BROWSER ;;
  }

  dimension: timed_active {
    type: string
    sql: ${TABLE}.TIMED_ACTIVE ;;
  }

  dimension_group: user_deleted_at_et {
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
    sql: ${TABLE}.USER_DELETED_AT_ET ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      dim_deployment_id,
      dim_assignment.dim_assignment_id,
      dim_assignment.name,
      dim_assignment.author_name,
      dim_assignment.template_name,
      dim_section.dim_section_id,
      dim_section.course_name,
      dim_section.course_instructor_name,
      dim_section.course_instructor_username,
      dim_section.section_name,
      dim_section.section_instructor_name,
      dim_section.section_instructor_username,
      dim_section.bill_institution_contact_name
    ]
  }
}
