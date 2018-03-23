include: "/webassign/dim_question.view.lkml"

view: dim_question_zcm {
  extends: [dim_question]


######################################################################################################################################################
######################################################### Minor Adjustments (Not New Fields) #########################################################
######################################################################################################################################################

  measure: taq_num_students {
    description: "The # of student responses used to estimate the average time"
  }

  dimension: textbookid {
    sql: ${TABLE}.TEXTBOOK_ID ;;
  }




#######################################################################################################################################################
#########################################################      New Fields Added by Chip     ###########################################################
########################################################################################################################################################

  dimension: question_group_name {
    type: string
    group_label: "  Chip's Additions"
    sql: CASE
               WHEN ${dim_question_group_key_id}='6'  THEN 'Ungrouped'
               WHEN ${dim_question_group_key_id}='5'  THEN 'Conceptual Questions'
               WHEN ${dim_question_group_key_id}='12' THEN 'Exercises'
               WHEN ${dim_question_group_key_id}='14' THEN 'Test Bank'
               WHEN ${dim_question_group_key_id}='15' THEN 'Active Examples'
               WHEN ${dim_question_group_key_id}='16' THEN 'Appendix?'
               WHEN ${dim_question_group_key_id}='18' THEN 'True/False'
               WHEN ${dim_question_group_key_id}='23' THEN 'Extra Problem'
               WHEN ${dim_question_group_key_id}='32' THEN 'Tools for Enriching Calculus'
               WHEN ${dim_question_group_key_id}='38' THEN 'Step by Step'
               WHEN ${dim_question_group_key_id}='46' THEN 'Extra Problem'
               WHEN ${dim_question_group_key_id}='47' THEN 'Appendix Extra Problem'
               WHEN ${dim_question_group_key_id}='52' THEN 'Just In Time'
               WHEN ${dim_question_group_key_id}='55' THEN 'Video Examples'
               WHEN ${dim_question_group_key_id}='56' THEN 'Tools for Enriching Calculus (Appendix)'
               WHEN ${dim_question_group_key_id}='61' THEN 'True/False Extra Problem'
          ELSE 'Unknown' END
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
  }

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

  parameter: qdiff_bucket_size {
    default_value: "10"
    view_label: " Chip's Additions"
    type: number
  }

  dimension: qdiff_difficulty_index_bucket {
    label: "Difficulty Index Bucket"
    description: "Tiers for the Qdiff Difficulty Index (Question Difficulty)"
    view_label:  " Chip's Additions"
    sql: truncate((${qdiff_difficulty_index} - mod(${qdiff_difficulty_index}, {% parameter qdiff_bucket_size %})))||' - '||truncate((${qdiff_difficulty_index}-mod(${qdiff_difficulty_index}, {% parameter qdiff_bucket_size %})+{% parameter qdiff_bucket_size %}));;
    order_by_field: qdiff_dynamic_sort_field
  }

  dimension: qdiff_dynamic_sort_field {
    type: number
    hidden: yes
    sql: ${qdiff_difficulty_index} - mod(${qdiff_difficulty_index}, {% parameter qdiff_bucket_size %}) ;;
  }

  dimension: q_avg_time_bucket {
    label: "Avg Question Time Bucket"
    description: "Buckets Avg Question time into groups"
    type: tier
    view_label: " Chip's Additions"
    tiers: [20,40,60,80,100,120,140,150]
    style: integer
    sql: ${TABLE}.taq_avg_time ;;
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

    parameter: dynamic_dimension_picker {
      view_label: " Chip's Additions"
      label: "Dimension Picker"
      description: "Select the dimension you wish to use in the dashboard element"
      default_value: "QDiff Difficulty Index Bucket"
      allowed_value: {label: "QDiff Difficulty Index Bucket" value: "QDiff Difficulty Index Bucket"}
      allowed_value: {label:  "Question Features" value: "Question Features"}
      allowed_value: {label:  "Assignment Type" value: "Assignment Type"}
      allowed_value: {label:  "Avg Question Time Bucket" value: "Avg Question Time Bucket"}
    }

    dimension: dynamic_dimension_pivot {
      label: "Dynamic Dimension (Pivot)"
      label_from_parameter: dynamic_dimension_picker_pivot
      view_label: " Chip's Additions"
      group_label: "Dynamic Dimensions"
      sql: CASE WHEN {% parameter dynamic_dimension_picker_pivot %} = 'QDiff Difficulty Index Bucket' THEN ${dim_question.qdiff_difficulty_index_bucket}
              WHEN {% parameter dynamic_dimension_picker_pivot %} = 'QDiff Difficulty Index Bucket' THEN ${dim_question.qdiff_difficulty_index_bucket}
              WHEN {% parameter dynamic_dimension_picker_pivot %} = 'Question Features' THEN ${zcm_question_help_features.features}
              WHEN {% parameter dynamic_dimension_picker_pivot %} = 'Avg Question Time Bucket' THEN ${dim_question.q_avg_time_bucket}
              ELSE NULL
              END ;;
  #              WHEN {% parameter dynamic_dimension_picker %} = 'Assignment Type' THEN ${sectionslessonstype_bucket}
  #             WHEN {% parameter dynamic_dimension_picker_pivot %} = 'Assignment Type' THEN ${sectionslessonstype_bucket}
      }



      parameter: dynamic_dimension_picker_pivot {
        view_label: " Chip's Additions"
        label: "Dimension Picker (Pivot)"
        description: "Select the dimension you wish to use in the dashboard element"
        default_value: "Question Features"
        allowed_value: {label: "QDiff Difficulty Index Bucket" value: "QDiff Difficulty Index Bucket"}
        allowed_value: {label:  "Question Features" value: "Question Features"}
        allowed_value: {label:  "Assignment Type" value: "Assignment Type"}
        allowed_value: {label:  "Avg Question Time Bucket" value: "Avg Question Time Bucket"}

      }

      measure: avg_deployments_per_question {
        label: "Avg # Times Question Deployed"
        description: "The average number of section lessons (assignments) for each master question"
        type: number
        view_label: " Chip's Additions"
        sql: ${dim_deployment.count}/nullif(${count}, 0) ;;
        value_format_name: decimal_1
      }



}
