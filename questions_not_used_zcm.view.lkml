
  include: "//webassign/questions_not_used.view.lkml"

  view: questions_not_used_zcm {
    extends: [questions_not_used]


    dimension: stats_question_types {
      type: string
      label: "Stats Question Types (Not Used)"
      view_label: " Chip's Additions"
      group_label: "Question Types"
      description: "Breaks out the different Stats Question Types (i.e. JMP, LAB, SIP, DS, CHDS, & CQ)"
      sql:     CASE WHEN (${question_code} LIKE '%.JMP.%' AND ${question_code} LIKE '%.Lab.%') THEN 'JMP Lab'
                WHEN ${question_code} LIKE '%.JMP.%' THEN 'JMP'
                WHEN ${question_code} LIKE '%.Lab.%' THEN 'LAB'
                WHEN ${question_code} LIKE '%.SIP.%' THEN 'SIP'
                WHEN ${question_code} LIKE '%.DS.%'  THEN 'DS'
                WHEN ${question_code} LIKE '%.CHDS.%' THEN 'CHDS'
                WHEN ${question_code} LIKE '%.CQ.%' THEN 'CQ'
                ELSE 'Other Question Types'
                END;;
    }


    }
