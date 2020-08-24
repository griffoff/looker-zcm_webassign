include: "//webassign/*.model.lkml"
include: "dim_assignment_zcm.view.lkml"


view: zcm_cross_view_fields {
  view_label: " Chip's Additions (New)"

  parameter: cohort_type_picker {
    label: "Cohort Type Picker"
    description: "Select the dimension you wish the data to be cut by for analysis"
    default_value: "Institution Type"
    allowed_value: {label: "Institution Type" value: "Institution Type"}
    allowed_value: {label:  "Assignment Type" value: "Assignment Type"}
  }

  dimension: cohort_type {
    label_from_parameter: cohort_type_picker
    group_label: "Cohort Analysis"
    description: "A dynamic field selected by the 'Cohort Type Picker' filter for dashboard analysis"
    sql: CASE WHEN {% parameter cohort_type_picker %} = 'Institution Type' THEN ${dim_school.type}
                      WHEN {% parameter cohort_type_picker %} = 'Assignment Type' THEN ${dim_assignment.category_bucket}
                      ELSE NULL
                      END  ;;
        #--              WHEN {% parameter dynamic_dimension_picker %} = 'Assignment Type' THEN ${sectionslessonstype_bucket}
    }

  parameter: metric_selector {
    type: string
    default_value: "num_questions"
    allowed_value: {label: "# Distinct Questions Used"  value: "num_questions"}
    allowed_value: {label: "# Takes"                    value: "num_takes"}
    allowed_value: {label: "# Submissions"              value: "num_submissions"}
    allowed_value: {label: "Average Attempts"           value: "avg_attempts"}
    allowed_value: {label: "Average Attempt Time"       value: "avg_attempt_time"}
    allowed_value: {label: "# Users w/ Responses"     value: "num_users"}
  }

  measure: metric {
    label_from_parameter: metric_selector
    type: number
#     value_format: "$0.0,\"K\""
    sql:
    CASE
      WHEN {% parameter metric_selector %} = 'num_questions'      THEN ${responses.response_question_count}
      WHEN {% parameter metric_selector %} = 'num_takes'          THEN ${responses.count}
      WHEN {% parameter metric_selector %} = 'num_submissions'    THEN ${responses.response_submission_count}
      WHEN {% parameter metric_selector %} = 'avg_attempts'       THEN ${responses.avg_attemptnumber}
      WHEN {% parameter metric_selector %} = 'avg_attempt_time'   THEN ${responses.avg_attempt_time}
      WHEN {% parameter metric_selector %} = 'num_users'          THEN ${responses.user_count}
      ELSE NULL
    END ;;
  }
}
