include: "//webassign/student_insights.model.lkml"
include: "//webassign/datascience_course_filter.view.lkml"

view: sections_zcm {
  extends: [datascience_course_filter]
}
