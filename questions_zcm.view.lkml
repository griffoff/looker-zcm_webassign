include: "//webassign/questions.view.lkml"

view: questions_zcm {
  extends: [questions]


################################# Question Types #################################

#   dimension: stats_question_types {
#     type: string
#     label: "Stats Question Types (Master)"
#     view_label: " Chip's Additions"
#      group_label: "Question Types"
#     description: "Breaks out the different Stats Question Types (i.e. JMP, LAB, SIP, DS, CHDS, & CQ)"
#     sql:     CASE WHEN (${TABLE}.code} LIKE '%.JMP.%' AND ${TABLE}.code LIKE '%.Lab.%') THEN 'JMP Lab'
#                 WHEN ${TABLE}.code LIKE '%.JMP.%' THEN 'JMP'
#                 WHEN ${TABLE}.code LIKE '%.Lab.%' THEN 'LAB'
#                 WHEN ${TABLE}.code LIKE '%.SIP.%' THEN 'SIP'
#                 WHEN ${TABLE}.code LIKE '%.DS.%'  THEN 'DS'
#                 WHEN ${TABLE}.code LIKE '%.CHDS.%' THEN 'CHDS'
#                 WHEN ${TABLE}.code LIKE '%.CQ.%' THEN 'CQ'
#                 ELSE 'Other Question Types'
#                 END;;
#   }

  }
