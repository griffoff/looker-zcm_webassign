include: "/webassign/responses.view.lkml"

view: responses_zcm {
  extends: [responses]


  measure: avg_attemptnumber {
    description: "Average number of attempts made per question box."
    }

  measure: response_question_answered_count {
    label: "# Unique questions answered (Total)"
    type: count_distinct
    sql: ${question_user_key}  ;;
    drill_fields: [questions*]
  }

  measure: response_question_incorrect_count {
    label: "# Unique questions answered incorrectly"
    type: count_distinct
    sql: case when ${iscorrect}=false then ${question_user_key} end ;;
  }

  measure: response_question_count {
    drill_fields: [questions*]
    }


set: questions {
  fields: [updatedat_date , questionid, boxnum, userid, question_user_key]
}

 }
