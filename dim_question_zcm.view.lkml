include: "/webassign/dim_question.view.lkml"

view: dim_question_zcm {
  extends: [dim_question]

# dimension: dim_question_id {}
#
# dimension: question_id {}

######################################################################################################################################################
######################################################### Minor Adjustments (Not New Fields) #########################################################
######################################################################################################################################################

#   measure: taq_num_students {
#     description: "The # of student responses used to estimate the average time"
#   }

  dimension: textbookid {
    sql: ${TABLE}.TEXTBOOK_ID ;;
  }


  measure: count_questions {
    drill_fields: [questions*]
  }


  set: questions {
    fields: [question_id, question_code]
  }








########################################################################################################################################################
#########################################################      New Fields Added by Chip      ###########################################################
########################################################################################################################################################

  dimension: question_group_name {
    type: string
    group_label: "  Chip's Additions"
    hidden: yes
    sql:
              CASE
               WHEN ${dim_question_group_key_id} = '2' THEN 'Unknown'
               WHEN ${dim_question_group_key_id} = '3' THEN 'End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '4' THEN 'Simulation'
               WHEN ${dim_question_group_key_id} = '5' THEN 'Concept Question'
               WHEN ${dim_question_group_key_id} = '6' THEN 'Unknown'
               WHEN ${dim_question_group_key_id} = '7' THEN 'Concept Question; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '8' THEN 'Mult Choice Concept With Feedback'
               WHEN ${dim_question_group_key_id} = '9' THEN 'Reading Question'
               WHEN ${dim_question_group_key_id} = '10' THEN 'Pre Lab'
               WHEN ${dim_question_group_key_id} = '11' THEN 'Ch. Test'
               WHEN ${dim_question_group_key_id} = '12' THEN 'End of Ch. Exercise; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '13' THEN 'Quick Prep'
               WHEN ${dim_question_group_key_id} = '14' THEN 'Test Bank'
               WHEN ${dim_question_group_key_id} = '15' THEN 'Active Example'
               WHEN ${dim_question_group_key_id} = '16' THEN 'Animation Question'
               WHEN ${dim_question_group_key_id} = '17' THEN 'Test Bank; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '18' THEN 'True False'
               WHEN ${dim_question_group_key_id} = '19' THEN 'Animation Question; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '20' THEN 'Test Bank; Mult Choice Concept With Feedback'
               WHEN ${dim_question_group_key_id} = '21' THEN 'Test Bank; True False'
               WHEN ${dim_question_group_key_id} = '22' THEN 'Quick Quiz'
               WHEN ${dim_question_group_key_id} = '23' THEN 'Extra Problem'
               WHEN ${dim_question_group_key_id} = '24' THEN 'Animation Question; End of Ch. Exercise; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '25' THEN 'Post Lab'
               WHEN ${dim_question_group_key_id} = '26' THEN 'In Lab'
               WHEN ${dim_question_group_key_id} = '27' THEN 'Concept Question; Mult Choice Concept With Feedback'
               WHEN ${dim_question_group_key_id} = '28' THEN 'Active Figure; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '29' THEN 'Mult Choice Concept With Feedback; End of Ch. Exercise; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '30' THEN 'Active Figure'
               WHEN ${dim_question_group_key_id} = '31' THEN 'Extra Problem; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '32' THEN 'Tools For Enriching Calculus'
               WHEN ${dim_question_group_key_id} = '33' THEN 'Tools For Enriching Calculus; Quick Prep'
               WHEN ${dim_question_group_key_id} = '34' THEN 'Quick Prep; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '35' THEN 'Mult Choice Concept With Feedback; Quick Prep'
               WHEN ${dim_question_group_key_id} = '36' THEN 'Concept Question; Animation Question'
               WHEN ${dim_question_group_key_id} = '37' THEN 'Concept Question; End of Ch. Exercise; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '38' THEN 'Step By Step'
               WHEN ${dim_question_group_key_id} = '39' THEN 'Ch. Test; End of Ch. Exercise; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '40' THEN 'Focus On Modeling'
               WHEN ${dim_question_group_key_id} = '41' THEN 'Extra Problem; Reading Question'
               WHEN ${dim_question_group_key_id} = '42' THEN 'Cengage Master It'
               WHEN ${dim_question_group_key_id} = '43' THEN 'Objective Question'
               WHEN ${dim_question_group_key_id} = '44' THEN 'Step By Step; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '45' THEN 'Ch. Test; Extra Problem'
               WHEN ${dim_question_group_key_id} = '46' THEN 'Extra Problem; End of Ch. Exercise; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '47' THEN 'Extra Problem; Animation Question'
               WHEN ${dim_question_group_key_id} = '48' THEN 'Step By Step; Extra Problem'
               WHEN ${dim_question_group_key_id} = '49' THEN 'Ch. Test; Cengage Master It'
               WHEN ${dim_question_group_key_id} = '50' THEN 'Extra Problem; In Lab'
               WHEN ${dim_question_group_key_id} = '51' THEN 'Extra Problem; Cengage Master It'
               WHEN ${dim_question_group_key_id} = '52' THEN 'Just In Time'
               WHEN ${dim_question_group_key_id} = '53' THEN 'Active Figure; Extra Problem'
               WHEN ${dim_question_group_key_id} = '54' THEN 'Focus On Modeling; Extra Problem'
               WHEN ${dim_question_group_key_id} = '55' THEN 'Video Example'
               WHEN ${dim_question_group_key_id} = '56' THEN 'Tools For Enriching Calculus; Animation Question'
               WHEN ${dim_question_group_key_id} = '57' THEN 'Animation Question; Pre Lab'
               WHEN ${dim_question_group_key_id} = '58' THEN 'Animation Question; Post Lab'
               WHEN ${dim_question_group_key_id} = '59' THEN 'Extra Problem; Animation Question; Pre Lab'
               WHEN ${dim_question_group_key_id} = '60' THEN 'Extra Problem; Pre Lab'
               WHEN ${dim_question_group_key_id} = '61' THEN 'Extra Problem; True False'
               WHEN ${dim_question_group_key_id} = '62' THEN 'Extra Problem; Concept Question'
               WHEN ${dim_question_group_key_id} = '63' THEN 'Extra Problem; Post Lab'
               WHEN ${dim_question_group_key_id} = '64' THEN 'Active Example; Extra Problem'
               WHEN ${dim_question_group_key_id} = '65' THEN 'Animation Question; Video Example'
               WHEN ${dim_question_group_key_id} = '66' THEN 'End of Ch. Exercise; Video Example; End of Ch. Problem'
               WHEN ${dim_question_group_key_id} = '67' THEN 'Extra Problem; Quick Prep'
               WHEN ${dim_question_group_key_id} = '68' THEN 'Animation Question; Quick Prep'
               WHEN ${dim_question_group_key_id} = '69' THEN 'Ch. Test; Animation Question'
               WHEN ${dim_question_group_key_id} = '70' THEN 'Test Bank; Extra Problem'
     ELSE 'Unknown'
     END
 ;;
  }



  dimension: chapter_order {
    type: string
    sql: CASE WHEN ${chapter}= '1' THEN '01'
              WHEN ${chapter}= '2' THEN '02'
              WHEN ${chapter}= '3' THEN '03'
              WHEN ${chapter}= '4' THEN '04'
              WHEN ${chapter}= '5' THEN '05'
              WHEN ${chapter}= '6' THEN '06'
              WHEN ${chapter}= '7' THEN '07'
              WHEN ${chapter}= '8' THEN '08'
              WHEN ${chapter}= '9' THEN '09'
              ELSE ${chapter} END;;
              hidden: no
              label: "Chapter Order"
              view_label: "Question"
  }

################################# Question Types #################################


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


# Would like to create a dynamic field that checks the first created date of a question type and marks it as new based on either being new to the current edition or within a defined timeframe
#   dimension: recent_question_type {
#     type: string
#
#     label: "Question Type Recency"
#     description: "Denotes whether or not the question type has been recently added. Recency is defined by the user with the filter"
#     sql: ;;
#   }

  parameter: dynamic_question_type_granularity_picker {
    view_label: " Chip's Additions (New)"
    label: "Question Type Granularity"
    description: "Select if you want to look at question type bucketed into new, established, & other groups or at the question type level"
    default_value: "Question Type"
    allowed_value: {label: "Question Type" value: "Question Type"}
    allowed_value: {label:  "Question Type Group" value: "Question Type Group"}
  }

  dimension: dynamic_question_type_lvl {
    label_from_parameter: dynamic_question_type_granularity_picker
    view_label: " Chip's Additions (New)"
    group_label: "Dynamic Question Type Level"
    sql: CASE WHEN {% parameter dynamic_question_type_granularity_picker %} = 'Question Type' THEN ${question_types}
                      WHEN {% parameter dynamic_question_type_granularity_picker %} = 'Question Type Group' THEN ${question_type_group}
                      ELSE NULL
                      END  ;;
        #--              WHEN {% parameter dynamic_dimension_picker %} = 'Assignment Type' THEN ${sectionslessonstype_bucket}
    }



















  measure: earliest_created_date {
    label: "Earliest Created Date (Question)"
    type: date
    view_label: " Chip's Additions"
    sql: min(${created_et_raw}) ;;
    convert_tz: no
  }

  measure: question_author_count {
    type: count_distinct
    view_label: " Chip's Additions"
    sql: ${TABLE}.author_user_id ;;
  }


############################# Question Help Features #############################


  dimension: question_features {
    type: string
    label: "Question Feature List"
    group_label: "Question Features"
    view_label: " Chip's Additions"
    description: "Lists all of the question features that are present for each question List Agg'"
    sql:      CASE WHEN ${has_feedback}='Yes' THEN 'Feedback, ' else '' END||
              CASE WHEN ${has_grading_statement}='Yes' THEN 'Grading Statement, ' else '' END||
              CASE WHEN ${has_image}='Yes' THEN 'Image, ' else '' END||
              CASE WHEN ${has_marvin}='Yes' THEN 'Marvin, ' else ''END||
              CASE WHEN ${has_master_it}='Yes' THEN 'Master-It, ' else '' END||
              CASE WHEN ${has_practice_it}='Yes' THEN 'Practice It, ' else '' END||
              CASE WHEN ${has_read_it}='Yes' THEN 'Read It, ' else '' END||
              CASE WHEN ${has_solution}='Yes' THEN 'Solution, ' else '' END||
              CASE WHEN ${has_standalone_master_it}='Yes' THEN 'Standalone Master It, ' else '' END||
              CASE WHEN ${has_tutorial}='Yes' THEN 'Tutorial, ' else '' END||
              CASE WHEN ${has_tutorial_popup}='Yes' THEN 'Tutorial-Popup, ' else '' END||
              CASE WHEN ${has_watch_it}='Yes' THEN 'Watch It'
              ELSE '' END ;;
  }







  measure: ebook_section_count{
    label: "# Questions - Ebook"
    description: "Distinct count of master questions with the 'Ebook Section' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_ebook_section}='Yes' THEN ${dim_question_id} end;;
  }

  measure: feedback_count{
    label: "# Questions - Feedback"
    description: "Distinct count of master questions with the 'Feedback' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_feedback}='Yes' THEN ${dim_question_id} end;;
  }

  measure: grading_statement_count{
    label: "# Questions - Grading STMT"
    description: "# of Questions with the 'Grading Statement' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_grading_statement}='Yes' THEN ${dim_question_id} end;;
  }

  measure: image_count{
    label: "# Questions - Image"
    description: "Distinct count of master questions with the 'Image' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_image}='Yes' THEN ${dim_question_id} end;;
  }

  measure: marvin_count{
    label: "# Questions - Marvin"
    description: "Distinct count of master questions with the 'Marvin' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_marvin}='Yes' THEN ${dim_question_id} end;;
  }

  measure: master_it_count{
    label: "# Questions - Master It"
    description: "Distinct count of master questions with the 'Master It' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_master_it}='Yes' THEN ${dim_question_id} end;;
  }

  measure: pad_count{
    label: "# Questions - Pad"
    description: "Distinct count of master questions with the 'Pad' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_pad}='Yes' THEN ${dim_question_id} end;;
  }

  measure: practice_it_count{
    label: "# Questions - Practice It"
    description: "Distinct count of master questions with the 'Practice It' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_practice_it}='Yes' THEN ${dim_question_id} end;;
  }

  measure: read_it_count{
    label: "# Questions - Read It"
    description: "Distinct count of master questions with the 'Read It' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_read_it}='Yes' THEN ${dim_question_id} end;;
  }

  measure: solution_count{
    label: "# Questions - Solution"
    description: "Distinct count of master questions with the 'Solution' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_solution}='Yes' THEN ${dim_question_id} end;;
  }

  measure: standalone_master_it_count{
    label: "# Questions - SA Master It"
    description: "# of Questions with the 'Standalone Master It' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_standalone_master_it}='Yes' THEN ${dim_question_id} end;;
  }

  measure: tutorial_count{
    label: "# Questions - Tutorial"
    description: "Distinct count of master questions with the 'Tutorial' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_tutorial}='Yes' THEN ${dim_question_id} end;;
  }

  measure: tutorial_popup_count{
    label: "# Questions - Tutorial Popup"
    description: "Distinct count of master questions with the 'Tutorial Popup' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_tutorial_popup}='Yes' THEN ${dim_question_id} end;;
  }

  measure: watch_it_count{
    label: "# Questions - Watch It"
    description: "Distinct count of master questions with the 'Watch It' feature"
    type: count_distinct
    view_label: " Chip's Additions"
    group_label: "dim_question - Master Question Counts"
    sql: case when ${has_watch_it}='Yes' THEN ${dim_question_id} end;;
  }





######################## Question Difficulty Fields #########################


  parameter: qdiff_bucket_size {
    default_value: "10"
    view_label: " Chip's Additions"
    type: number
  }

  dimension: qdiff_difficulty_index_bucket {
    label: "Difficulty Index Bucket"
    view_label: " Chip's Additions"
    description: "Tiers for the Qdiff Difficulty Index (Question Difficulty)"
    sql: truncate((${qdiff_difficulty_index} - mod(${qdiff_difficulty_index}, {% parameter qdiff_bucket_size %})))||' - '||truncate((${qdiff_difficulty_index}-mod(${qdiff_difficulty_index}, {% parameter qdiff_bucket_size %})+{% parameter qdiff_bucket_size %}));;
    order_by_field: qdiff_dynamic_sort_field
  }

  dimension: qdiff_dynamic_sort_field {
    type: number
    view_label: " Chip's Additions"
    hidden: yes
    sql: ${qdiff_difficulty_index} - mod(${qdiff_difficulty_index}, {% parameter qdiff_bucket_size %}) ;;
  }

  measure: avg_qdiff_difficulty_index {
    label: "Avg. Qdiff Index"
    group_label: "Question Difficulty"
    type: average_distinct
    sql_distinct_key: ${dim_question_id} ;;
    sql: ${TABLE}.QDIFF_DIFFICULTY_INDEX ;;
    value_format_name: decimal_2
  }


######################## Avg. Question Time Fields  ##########################

  dimension: q_avg_time_bucket {
    label: "Avg Question Time Bucket"
    description: "Buckets Avg Question time into groups"
    type: tier

    tiers: [20,40,60,80,100,120,140,150]
    style: integer
    sql: ${TABLE}.taq_avg_time ;;
  }





##################### Dynamic Fields for Dashboards ##########################


  parameter: dynamic_dimension_picker {
    view_label: " Chip's Additions"
    label: "Dimension Picker"
    description: "Select the dimension you wish to use in the dashboard element"
    default_value: "QDiff Difficulty Index Bucket"
    allowed_value: {label: "QDiff Difficulty Index Bucket" value: "QDiff Difficulty Index Bucket"}
#    allowed_value: {label:  "Question Features" value: "Question Features"}
    allowed_value: {label:  "Assignment Type" value: "Assignment Type"}
    allowed_value: {label:  "Avg Question Time Bucket" value: "Avg Question Time Bucket"}
  }

          dimension: dynamic_dimension {
            label_from_parameter: dynamic_dimension_picker
            view_label: " Chip's Additions"
            group_label: "Dynamic Dimensions"
            sql: CASE WHEN {% parameter dynamic_dimension_picker %} = 'QDiff Difficulty Index Bucket' THEN ${dim_question.qdiff_difficulty_index_bucket}
                      WHEN {% parameter dynamic_dimension_picker %} = 'Avg Question Time Bucket' THEN ${dim_question.q_avg_time_bucket}
                      ELSE NULL
                      END  ;;
        #--              WHEN {% parameter dynamic_dimension_picker %} = 'Assignment Type' THEN ${sectionslessonstype_bucket}
            }





  parameter: dynamic_dimension_picker_pivot {
    view_label: " Chip's Additions"
    label: "Dimension Picker (Pivot)"
    description: "Select the dimension you wish to use in the dashboard element"
    default_value: "Question Features"
    allowed_value: {label: "QDiff Difficulty Index Bucket" value: "QDiff Difficulty Index Bucket"}
#    allowed_value: {label:  "Question Features" value: "Question Features"}
#    allowed_value: {label:  "Assignment Type" value: "Assignment Type"}
    allowed_value: {label:  "Avg Question Time Bucket" value: "Avg Question Time Bucket"}
  }

            dimension: dynamic_dimension_pivot {
              label: "Dynamic Dimension (Pivot)"
              label_from_parameter: dynamic_dimension_picker_pivot
              view_label: " Chip's Additions"
              group_label: "Dynamic Dimensions"
              sql: CASE WHEN {% parameter dynamic_dimension_picker_pivot %} = 'QDiff Difficulty Index Bucket' THEN ${dim_question.qdiff_difficulty_index_bucket}
                      WHEN {% parameter dynamic_dimension_picker_pivot %} = 'Avg Question Time Bucket' THEN ${dim_question.q_avg_time_bucket}
                      ELSE NULL
                      END ;;
          #              WHEN {% parameter dynamic_dimension_picker %} = 'Assignment Type' THEN ${sectionslessonstype_bucket}
          #             WHEN {% parameter dynamic_dimension_picker_pivot %} = 'Assignment Type' THEN ${sectionslessonstype_bucket}
          #             WHEN {% parameter dynamic_dimension_picker_pivot %} = 'Question Features' THEN ${zcm_question_help_features.features}
              }





  measure: avg_deployments_per_question {
    label: "Avg # Times Deployed"
    description: "The average number of users each master question was deployed to"
    type: number
    view_label: " Chip's Additions"
    sql: ${dim_deployment.count}/nullif(${count}, 0) ;;
    value_format_name: decimal_1
   }

###################################################################################################################################################################
########################################### WAITING TO SEE IF SECTIONSLESSONS TABLE WILL BE INCLUDED IN MODEL #####################################################
###################################################################################################################################################################

  #   measure: avg_sectionslessons_per_question {
#     label: "Avg # Times in Section Lesson"
#     description: "The average number of section lessons (assignments) for each master question"
#     type: number
#
#     sql: ${sectionslessons.count}/nullif(${count}, 0) ;;
#     value_format_name: decimal_1
#   }






}
