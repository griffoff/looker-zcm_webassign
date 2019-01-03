

include: "/webassign/*.model.lkml"
include: "/webassign/webassign.dims.model.lkml"
include: "/webassign/*.view.lkml"
include: "/webassign/questions.view.lkml"
include: "/zcm_webassign/dim_section_zcm.view.lkml"
include: "/zcm_webassign/dim_school_zcm.view.lkml"
# include: "/zcm_webassign/*.view.lkml"

explore: dim_section_zcm {
  from: dim_section_zcm

join: dim_textbook {
  relationship: many_to_one
  sql_on: ${dim_section_zcm.dim_textbook_id} = ${dim_textbook.dim_textbook_id} ;;
}

join: dim_school_zcm {
  type: left_outer
  relationship: many_to_one
  sql_on: ${dim_section_zcm.school_id} = ${dim_school_zcm.school_id} ;;
}

join: dim_faculty {
  relationship: many_to_one
  sql_on: ${dim_section_zcm.course_instructor_id}=${dim_faculty.dim_faculty_id} ;;
}

   join: dim_discipline {
     from: dim_discipline
     view_label: "Discipline - Textbook"
      type: left_outer
      relationship: many_to_one
     sql_on: ${dim_textbook.dim_discipline_id} = ${dim_discipline.dim_discipline_id} ;;
   }
}
