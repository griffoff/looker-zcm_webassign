view: dim_section {
  sql_table_name: WA2ANALYTICS.DIM_SECTION ;;

  dimension: dim_section_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_SECTION_ID ;;
  }

  dimension: bb_version {
    type: string
    sql: ${TABLE}.BB_VERSION ;;
  }

  dimension: bill_institution_comments {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_COMMENTS ;;
  }

  dimension: bill_institution_contact_email {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_CONTACT_EMAIL ;;
  }

  dimension: bill_institution_contact_name {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_CONTACT_NAME ;;
  }

  dimension: bill_institution_contact_phone {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_CONTACT_PHONE ;;
  }

  dimension_group: bill_institution_invoice {
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
    sql: ${TABLE}.BILL_INSTITUTION_INVOICE_DATE ;;
  }

  dimension: bill_institution_invoice_number {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_INVOICE_NUMBER ;;
  }

  dimension: bill_institution_method {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_METHOD ;;
  }

  dimension: bill_institution_option {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_OPTION ;;
  }

  dimension: bill_institution_po_num {
    type: string
    sql: ${TABLE}.BILL_INSTITUTION_PO_NUM ;;
  }

  dimension: billing {
    type: string
    sql: ${TABLE}.BILLING ;;
  }

  dimension: class_key {
    type: string
    sql: ${TABLE}.CLASS_KEY ;;
  }

  dimension: course_description {
    type: string
    sql: ${TABLE}.COURSE_DESCRIPTION ;;
  }

  dimension: course_id {
    type: number
    sql: ${TABLE}.COURSE_ID ;;
  }

  dimension: course_instructor_email {
    type: string
    sql: ${TABLE}.COURSE_INSTRUCTOR_EMAIL ;;
  }

  dimension: course_instructor_id {
    type: number
    sql: ${TABLE}.COURSE_INSTRUCTOR_ID ;;
  }

  dimension: course_instructor_name {
    type: string
    sql: ${TABLE}.COURSE_INSTRUCTOR_NAME ;;
  }

  dimension: course_instructor_sf_id {
    type: string
    sql: ${TABLE}.COURSE_INSTRUCTOR_SF_ID ;;
  }

  dimension: course_instructor_username {
    type: string
    sql: ${TABLE}.COURSE_INSTRUCTOR_USERNAME ;;
  }

  dimension: course_name {
    type: string
    sql: ${TABLE}.COURSE_NAME ;;
  }

  dimension_group: created_eastern {
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
    sql: ${TABLE}.CREATED_EASTERN ;;
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

  dimension: deployments {
    type: number
    sql: ${TABLE}.DEPLOYMENTS ;;
  }

  dimension: dim_discipline_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_DISCIPLINE_ID ;;
  }

  dimension: dim_textbook_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_TEXTBOOK_ID ;;
  }

  dimension: dim_time_id_created {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_CREATED ;;
  }

  dimension: dim_time_id_ends {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_ENDS ;;
  }

  dimension: dim_time_id_leeway {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_LEEWAY ;;
  }

  dimension: dim_time_id_starts {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_STARTS ;;
  }

  dimension_group: ends_eastern {
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
    sql: ${TABLE}.ENDS_EASTERN ;;
  }

  dimension: gb_configured {
    type: yesno
    sql: ${TABLE}.GB_CONFIGURED ;;
  }

  dimension: gb_has_data {
    type: yesno
    sql: ${TABLE}.GB_HAS_DATA ;;
  }

  dimension: granted_ebook {
    type: string
    sql: ${TABLE}.GRANTED_EBOOK ;;
  }

  dimension: has_invoice {
    type: yesno
    sql: ${TABLE}.HAS_INVOICE ;;
  }

  dimension_group: leeway_eastern {
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
    sql: ${TABLE}.LEEWAY_EASTERN ;;
  }

  dimension: meets {
    type: string
    sql: ${TABLE}.MEETS ;;
  }

  dimension: psp_enabled {
    type: string
    sql: ${TABLE}.PSP_ENABLED ;;
  }

  dimension: psp_mode {
    type: string
    sql: ${TABLE}.PSP_MODE ;;
  }

  dimension: psp_students_attempting_quiz {
    type: number
    sql: ${TABLE}.PSP_STUDENTS_ATTEMPTING_QUIZ ;;
  }

  dimension: psp_students_attempting_test {
    type: number
    sql: ${TABLE}.PSP_STUDENTS_ATTEMPTING_TEST ;;
  }

  dimension: registrations {
    type: number
    sql: ${TABLE}.REGISTRATIONS ;;
  }

  dimension: roster {
    type: number
    sql: ${TABLE}.ROSTER ;;
  }

  dimension: school_id {
    type: number
    sql: ${TABLE}.SCHOOL_ID ;;
  }

  dimension: section_id {
    type: number
    sql: ${TABLE}.SECTION_ID ;;
  }

  dimension: section_instructor_email {
    type: string
    sql: ${TABLE}.SECTION_INSTRUCTOR_EMAIL ;;
  }

  dimension: section_instructor_id {
    type: number
    sql: ${TABLE}.SECTION_INSTRUCTOR_ID ;;
  }

  dimension: section_instructor_name {
    type: string
    sql: ${TABLE}.SECTION_INSTRUCTOR_NAME ;;
  }

  dimension: section_instructor_sf_id {
    type: string
    sql: ${TABLE}.SECTION_INSTRUCTOR_SF_ID ;;
  }

  dimension: section_instructor_username {
    type: string
    sql: ${TABLE}.SECTION_INSTRUCTOR_USERNAME ;;
  }

  dimension: section_name {
    type: string
    sql: ${TABLE}.SECTION_NAME ;;
  }

  dimension_group: starts_eastern {
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
    sql: ${TABLE}.STARTS_EASTERN ;;
  }

  dimension: term {
    type: string
    sql: ${TABLE}.TERM ;;
  }

  dimension: term_description {
    type: string
    sql: ${TABLE}.TERM_DESCRIPTION ;;
  }

  dimension: trashed {
    type: yesno
    sql: ${TABLE}.TRASHED ;;
  }

  dimension: using_open_resources {
    type: yesno
    sql: ${TABLE}.USING_OPEN_RESOURCES ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  dimension: year {
    type: string
    sql: ${TABLE}.YEAR ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      dim_section_id,
      course_name,
      course_instructor_name,
      course_instructor_username,
      section_name,
      section_instructor_name,
      section_instructor_username,
      bill_institution_contact_name,
      dim_discipline.dim_discipline_id,
      dim_discipline.discipline_name,
      dim_discipline.sub_discipline_name,
      dim_textbook.dim_textbook_id,
      dim_textbook.name,
      dim_textbook.publisher_name,
      dim_deployment.count,
      fact_registration.count
    ]
  }
}
