include: "//webassign/dim_section.view.lkml"
#include: "/webassign/dim_deployment.view.lkml"
view: dim_section_zcm {
    extends: [dim_section]

  measure: course_count {
    type: count_distinct
    sql: ${course_id} ;;
    drill_fields: [detail*]
  }


  dimension: course_instructor_name {
    hidden: no
    description: "Hidden in favor of 'Crs Instructor Name', which is the max() version and avoids multiple names for one id"
    sql: ${TABLE}.course_instructor_name ;;
  }



  dimension: section_instructor_name {
    drill_fields: [_zcm_topic_filter.topic, _zcm_topic_filter.topic_group, course_id, section_id, section_instructor_name, section_instructor_email, dim_time.special_ay_year]
  }

  dimension: course_id {
    drill_fields: [section_id, course_instructor_name]
  }
  dimension: dim_section_id {
    hidden: no
  }


  }
