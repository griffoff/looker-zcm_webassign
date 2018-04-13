
connection: "snowflake_webassign"

# include the model and all the views from webassign project, all the views from the zcm_webassign project, & dashboards
 include: "/webassign/*.model.lkml"
include: "/webassign/*.view.lkml"
include: "*.view.lkml"
include: "*.dashboard"



datagroup: zcm_webassign_default_datagroup {
   sql_trigger: select count(*) from wa_app_activity.RESPONSES;;
  #max_cache_age: "1 hour"
}
persist_with: zcm_webassign_default_datagroup

explore: responses_zcm {
  extends: [responses]
  view_name: responses
  label: "Student Take Analysis - ZCM"


  join: dim_assignment {
    from: dim_assignment_zcm
    view_label: "Assignments"
  }

  join: dim_question {
    from: dim_question_zcm
    view_label: "Question"
  }


join: zcm_question_is_used {
  sql_on: ${dim_question.dim_question_id}=${zcm_question_is_used.dim_question_id} ;;
  relationship: one_to_one
  }

join: zcm_question_help_features {
    sql_on: ${dim_question.dim_question_id} = ${zcm_question_help_features.dim_question_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: zcm_topquestions {
    sql_on: ${dim_question.dim_question_id} = ${zcm_topquestions.dim_question_id} ;;
    relationship: one_to_one
  }






#   join: sectionslessons {
#     sql_on: ${responses.sectionslessonsid} = ${sectionslessons.id} ;;
#     relationship: many_to_one
#   }





















###############################################################################################################################################

# explore: responses_zcm {
#   from: responses
#   label: "Student Take Analysis - ZCM"
#
#   join: dim_assignment_zcm {
#     sql_on: ${dim_assignment_zcm.dim_assignment_id} =${dim_deployment.dim_assignment_id};;
#     relationship: one_to_many
#   }
#
#   join: dim_deployment {
#     sql_on: ${responses_zcm.deployment_id} = ${dim_deployment.deployment_id};;
#     view_label: "Deployments"
#   }

  # join: dim_question {
#   from: dim_question_zcm
#   view_label: "Question"
# }






################ Hold (changes showing in my webassign branch that I'm not sure are different than production) Delete! #########################33

#   join: dim_discipline {
#     sql_on: ${dim_textbook.dim_discipline_id} = ${dim_discipline.dim_discipline_id};;
#     relationship: many_to_one
#   }
#
#   join: dim_deployment {
#     sql_on: ${responses.sectionslessonsid} = ${dim_deployment.deployment_id};;
#     relationship: many_to_one
#   }
#
#   join: dim_assignment {
#     sql_on: ${dim_deployment.dim_assignment_id}=${dim_assignment.dim_assignment_id} ;;
#     relationship: many_to_one
#   }





# join: attemptsbyquestion {
#   from: attemptsbyquestion_zcm
#   view_name: attemptsbyquestion
}

# explore: attemptsbyquestion_zcm {
#   extends: [attemptsbyquestion]
#   view_name: attemptsbyquestion
# }
