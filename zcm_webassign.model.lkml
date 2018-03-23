connection: "snowflake_webassign"

# include the model and all the views from webassign project, all the views from the zcm_webassign project, & dashboards
include: "/webassign/*.model.lkml"
include: "/webassign/*.view.lkml"
include: "*.view.lkml"
include: "*.dashboard"


datagroup: zcm_webassign_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
persist_with: zcm_webassign_default_datagroup



explore: responses_zcm {
  extends: [responses]
  view_name: responses

join: dim_assignment {
  from: dim_assignment_zcm
  view_label: "Assignments"
  }

join: dim_question {
  from: dim_question_zcm
  view_label: "Question"
}

join: question_is_used_zcm {
  sql_on: ${dim_question.dim_question_id}=${question_is_used_zcm.dim_question_id} ;;
  relationship: one_to_one
  }

join: question_help_features_zcm {
    sql_on: ${dim_question.dim_question_id} = ${question_help_features_zcm.dim_question_id} ;;
    relationship: one_to_many
  }

  join: topquestions_zcm {
    sql_on: ${dim_question.dim_question_id} = ${topquestions_zcm.dim_question_id} ;;
    relationship: one_to_one
  }





# join: attemptsbyquestion {
#   from: attemptsbyquestion_zcm
#   view_name: attemptsbyquestion
}

# explore: attemptsbyquestion_zcm {
#   extends: [attemptsbyquestion]
#   view_name: attemptsbyquestion
# }
