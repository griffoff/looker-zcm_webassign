view: fact_registration {
  sql_table_name: WA2ANALYTICS.FACT_REGISTRATION ;;

  dimension: fact_registration_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.FACT_REGISTRATION_ID ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.COUNT ;;
  }

  dimension: course_id {
    type: number
    sql: ${TABLE}.COURSE_ID ;;
  }

  dimension: course_instructor_id {
    type: number
    sql: ${TABLE}.COURSE_INSTRUCTOR_ID ;;
  }

  dimension: dim_axscode_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_AXSCODE_ID ;;
  }

  dimension: dim_payment_method_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_PAYMENT_METHOD_ID ;;
  }

  dimension: dim_school_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_SCHOOL_ID ;;
  }

  dimension: dim_section_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_SECTION_ID ;;
  }

  dimension: dim_textbook_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_TEXTBOOK_ID ;;
  }

  dimension: dim_time_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_TIME_ID ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.EVENT_TYPE ;;
  }

  dimension: purchase_type {
    type: string
    sql: ${TABLE}.PURCHASE_TYPE ;;
  }

  dimension: redemption_model {
    type: yesno
    sql: ${TABLE}.REDEMPTION_MODEL ;;
  }

  dimension: registrations {
    type: number
    sql: ${TABLE}.REGISTRATIONS ;;
  }

  dimension: school_id {
    type: number
    sql: ${TABLE}.SCHOOL_ID ;;
  }

  dimension: section_id {
    type: number
    sql: ${TABLE}.SECTION_ID ;;
  }

  dimension: section_instructor_id {
    type: number
    sql: ${TABLE}.SECTION_INSTRUCTOR_ID ;;
  }

  dimension: sso_guid {
    type: string
    sql: ${TABLE}.SSO_GUID ;;
  }

  dimension: token_id {
    type: number
    sql: ${TABLE}.TOKEN_ID ;;
  }

  dimension: upgrades {
    type: number
    sql: ${TABLE}.UPGRADES ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.USER_ID ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}.USERNAME ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      fact_registration_id,
      username,
      dim_payment_method.dim_payment_method_id,
      dim_axscode.dim_axscode_id,
      dim_school.dim_school_id,
      dim_school.name,
      dim_school.state_name,
      dim_school.country_name,
      dim_school.timezone_name,
      dim_school.territory_name,
      dim_school.region_name,
      dim_school.cengage_rep_name,
      dim_school.continent_name,
      dim_textbook.dim_textbook_id,
      dim_textbook.name,
      dim_textbook.publisher_name,
      dim_time.dim_time_id,
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
