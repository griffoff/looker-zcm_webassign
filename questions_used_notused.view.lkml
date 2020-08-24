include: "dim_question_zcm.view.lkml"

view: questions_used_notused {


derived_table: {
  persist_for: "100 hours"
  sql: Select
              q.*
            , CASE WHEN r.id IS NULL THEN 'NOT Used'
                ELSE 'Used'
              END AS used_unused_questions
from FT_OLAP_REGISTRATION_REPORTS.dim_question q
      left join wa_app_activity.responses r
      on q.question_ID = r.question_ID ;;


#  datagroup_trigger: responses_datagroup
}

dimension: id {
  type: string
  sql: ${TABLE}.question_id ;;
}

dimension: question_code {
  type: string
  sql: ${TABLE}.question_code ;;
}

dimension: used_unused_questions {
  type: string
  sql: ${TABLE}.used_unused_questions ;;
}

  dimension: question_type_code {
    type: string
    label: "Question Type Code"
    view_label: " Chip's Additions"
    group_label: "Question Types"
    description: "Breaks out the different Stats Question Types (i.e. JMP, LAB, SIP, DS, CHDS, & CQ)"
    sql:     CASE WHEN (UPPER(${question_code}) LIKE '%.JMP.%'   AND upper(${question_code}) LIKE '%.LAB.%') THEN 'JMP Lab'
                  WHEN  UPPER(${question_code}) LIKE '%.JMP.%'   THEN 'JMP'
                  WHEN  UPPER(${question_code}) LIKE '%.LAB.%'   THEN 'LAB'
                  WHEN  UPPER(${question_code}) LIKE '%.SIP.%'   THEN 'SIP'
                  WHEN  UPPER(${question_code}) LIKE '%.DS.%'    THEN 'DS'
                  WHEN  UPPER(${question_code}) LIKE '%.CHDS.%'  THEN 'CHDS'
                  WHEN  UPPER(${question_code}) LIKE '%.CQ.%'    THEN 'CQ'
                  WHEN  UPPER(${question_code}) LIKE '%.CTX.%'   THEN 'ctx'
                  WHEN  UPPER(${question_code}) LIKE '%.TPS.%'   THEN 'TPS'
                  WHEN  UPPER(${question_code}) LIKE '%.BIO.%'   THEN 'bio'
                  WHEN  UPPER(${question_code}) LIKE '% PSG.%'   THEN 'PSG'
                  WHEN  UPPER(${question_code}) LIKE '%.IVV.%'   THEN 'IVV'
                  WHEN  UPPER(${question_code}) LIKE '%.OQ.%'    THEN 'Oq'
                  WHEN  UPPER(${question_code}) LIKE '%.CQ.%'    THEN 'CQ'
                  WHEN  UPPER(${question_code}) LIKE '%.AMT.%'   THEN 'AMT'
                  WHEN  UPPER(${question_code}) LIKE '%.IT.%'    THEN 'IT'
                  WHEN  UPPER(${question_code}) LIKE '%.PLE.%'   THEN 'PLE'
                ELSE 'Other Question Types'
                 END;;
  }

  dimension: question_type_group {
    type: string
    label: "Question Type Group"
    description: "The Discipline + if the question type is new or established"
    view_label: " Chip's Additions"
    group_label: "Question Types"
    sql:     CASE WHEN (UPPER(${question_code}) LIKE '%.JMP.%'   AND upper(${question_code}) LIKE '%.LAB.%') THEN  'Statistics'
    WHEN  UPPER(${question_code}) LIKE '%.JMP.%'   THEN  'Statistics'
    WHEN  UPPER(${question_code}) LIKE '%.LAB.%'   THEN  'Statistics'
    WHEN  UPPER(${question_code}) LIKE '%.SIP.%'   THEN  'Statistics'
    WHEN  UPPER(${question_code}) LIKE '%.DS.%'    THEN  'Statistics'
    WHEN  UPPER(${question_code}) LIKE '%.CHDS.%'  THEN  'Statistics'
    WHEN  (UPPER(${question_code}) LIKE '%.CQ.%'  AND ${dim_discipline.discipline_name} = 'Statistics')  THEN  'Statistics'
    WHEN  (UPPER(${question_code}) LIKE '%.CQ.%'  AND ${dim_discipline.discipline_name} = 'Physics') THEN  'Physics - Established'
    WHEN  UPPER(${question_code}) LIKE '%.CTX.%'   THEN  'Physics - New'
    WHEN  UPPER(${question_code}) LIKE '%.TPS.%'   THEN  'Physics - New'
    WHEN  UPPER(${question_code}) LIKE '%.BIO.%'   THEN  'Physics - New'
    WHEN  UPPER(${question_code}) LIKE '% PSG.%'   THEN  'Physics - New'
    WHEN  UPPER(${question_code}) LIKE '%.IVV.%'   THEN  'Physics - New'
    WHEN  UPPER(${question_code}) LIKE '%.OQ.%'    THEN  'Physics - Established'
    WHEN  UPPER(${question_code}) LIKE '%.CQ.%'    THEN  'Physics - Established'
    WHEN  UPPER(${question_code}) LIKE '%.AMT.%'   THEN  'Physics - Established'
    WHEN  UPPER(${question_code}) LIKE '%.IT.%'    THEN  'Physics - New'
    WHEN  UPPER(${question_code}) LIKE '%.PLE.%'   THEN  'Physics - Established'
    ELSE 'Other'
    END
;;
  }

  dimension: question_types {
    type: string
    label: "Question Type"
    view_label: " Chip's Additions"
    group_label: "Question Types"
    description: "Breaks out the different Stats Question Types (i.e. Concept Questions, Objective Questions, Interactive Video Vignettes, etc.)"
    sql:     CASE
    WHEN (UPPER(${question_code}) LIKE  '%.JMP.%'   AND upper(${question_code}) LIKE '%.LAB.%') THEN 'JMP Simulation (Lab)'
    WHEN  UPPER(${question_code})  LIKE  '%.JMP.%'      THEN 'JMP Simulation'
    WHEN  UPPER(${question_code})  LIKE  '%.LAB.%'      THEN 'Labs'
    WHEN  UPPER(${question_code})  LIKE  '%.SIP.%'      THEN 'Stats in Practice (Video)'
    WHEN  UPPER(${question_code})  LIKE  '%.DS.%'       THEN 'Data Set'
    WHEN  UPPER(${question_code})  LIKE  '%.CHDS.%'     THEN 'Challenge Data Set'
    WHEN  UPPER(${question_code})  LIKE  '%.CQ.%'       THEN 'Conceptual'
    WHEN  UPPER(${question_code})  LIKE  '%.CTX.%'      THEN '*Content-Rich'
    WHEN  UPPER(${question_code})  LIKE  '%.TPS.%'      THEN '*Think-Pair-Share'
    WHEN  UPPER(${question_code})  LIKE  '%.BIO.%'      THEN '*Life Science'
    WHEN  UPPER(${question_code})  LIKE  '%.PSG.%'      THEN '*Passage Problems'
    WHEN  UPPER(${question_code})  LIKE  '%.IVV.%'      THEN '*Interactive Video Vignettes'
    WHEN  UPPER(${question_code})  LIKE  '%.OQ.%'       THEN 'Objective'
    WHEN  UPPER(${question_code})  LIKE  '%.AMT.%'      THEN 'Analysis Model Tutorials'
    WHEN  UPPER(${question_code})  LIKE  '%.IT.%'       THEN '*Integrated Tutorials'
    WHEN  UPPER(${question_code})  LIKE  '%.PLE.%'      THEN 'Prolecture Explorations'
    ELSE 'Other'
    END;;
  }

  dimension: question_types_new_breakout {
    type: string
    label: "Question Type Group (New Breakout)"
    view_label: " Chip's Additions"
    group_label: "Question Types"
    description: "Groups existing question types as well as other question types into a bucket and breaks out the new question types"
    sql:     CASE
                WHEN (UPPER(${question_code}) LIKE  '%.JMP.%'   AND upper(${question_code}) LIKE '%.LAB.%') THEN 'Statistics'
                WHEN  UPPER(${question_code})  LIKE  '%.JMP.%'      THEN 'Statistics'
                WHEN  UPPER(${question_code})  LIKE  '%.LAB.%'      THEN 'Statistics'
                WHEN  UPPER(${question_code})  LIKE  '%.SIP.%'      THEN 'Statistics'
                WHEN  UPPER(${question_code})  LIKE  '%.DS.%'       THEN 'Statistics'
                WHEN  UPPER(${question_code})  LIKE  '%.CHDS.%'     THEN 'Statistics'
                WHEN  (UPPER(${question_code}) LIKE '%.CQ.%'  AND ${dim_discipline.discipline_name} = 'Statistics')  THEN  'Statistics'
                WHEN  (UPPER(${question_code}) LIKE '%.CQ.%'  AND ${dim_discipline.discipline_name} = 'Physics') THEN  'Physics - Established'
                WHEN  UPPER(${question_code})  LIKE  '%.CTX.%'      THEN '*Content-Rich'
                WHEN  UPPER(${question_code})  LIKE  '%.TPS.%'      THEN '*Think-Pair-Share'
                WHEN  UPPER(${question_code})  LIKE  '%.BIO.%'      THEN '*Life Science'
                WHEN  UPPER(${question_code})  LIKE  '%.PSG.%'      THEN '*Passage Problems'
                WHEN  UPPER(${question_code})  LIKE  '%.IVV.%'      THEN '*Interactive Video Vignettes'
                WHEN  UPPER(${question_code})  LIKE  '%.OQ.%'       THEN 'Physics - Established'
                WHEN  UPPER(${question_code})  LIKE  '%.AMT.%'      THEN 'Physics - Established'
                WHEN  UPPER(${question_code})  LIKE  '%.IT.%'       THEN '*Integrated Tutorials'
                WHEN  UPPER(${question_code})  LIKE  '%.PLE.%'      THEN 'Physics - Established'
                ELSE 'Other'
                END;;
  }

measure: count_distinct_id {
  label: "# Distinct Questions"
  type: count_distinct
  sql: ${id} ;;
  value_format_name: decimal_0
}

  measure: count_distinct_used {
    label: "# Used Questions"
    type: number
    sql: count(DISTINCT CASE WHEN ${used_unused_questions} = 'Used' THEN ${id} ELSE null END) ;;
    value_format_name: decimal_0
  }

  measure: count_distinct_unused {
    label: "# Unused Questions"
    type: number
    sql: count(DISTINCT CASE WHEN ${used_unused_questions} = 'NOT Used' THEN ${id} ELSE null END) ;;
    value_format_name: decimal_0
  }



}
