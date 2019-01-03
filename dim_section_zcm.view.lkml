include: "/webassign/dim_section.view.lkml"
#include: "/webassign/dim_deployment.view.lkml"
view: dim_section_zcm {
    extends: [dim_section]

  measure: course_count {
    type: count_distinct
    sql: ${course_id} ;;
    drill_fields: [detail*]
  }

  }
