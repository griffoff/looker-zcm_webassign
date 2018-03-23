view: dim_question {
  sql_table_name: WA2ANALYTICS.DIM_QUESTION ;;

  dimension: dim_question_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_QUESTION_ID ;;
  }

  dimension: author_user_id {
    type: number
    sql: ${TABLE}.AUTHOR_USER_ID ;;
  }

  dimension: chapter {
    type: string
    sql: ${TABLE}.CHAPTER ;;
  }

  dimension: comment {
    type: string
    sql: ${TABLE}.COMMENT ;;
  }

  dimension_group: created_et {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CREATED_ET ;;
  }

  dimension_group: date_from {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.DATE_FROM ;;
  }

  dimension_group: date_to {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.DATE_TO ;;
  }

  dimension: dim_faculty_id_author {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_FACULTY_ID_AUTHOR ;;
  }

  dimension: dim_question_group_key_id {
    type: number
    sql: ${TABLE}.DIM_QUESTION_GROUP_KEY_ID ;;
  }

  dimension: dim_question_mode_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_QUESTION_MODE_ID ;;
  }

  dimension: dim_textbook_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DIM_TEXTBOOK_ID ;;
  }

  dimension: dim_time_id_created_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_CREATED_ET ;;
  }

  dimension: dim_time_id_last_modified_et {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_LAST_MODIFIED_ET ;;
  }

  dimension: distinct_modes {
    type: string
    sql: ${TABLE}.DISTINCT_MODES ;;
  }

  dimension: has_ebook_section {
    type: yesno
    sql: ${TABLE}.HAS_EBOOK_SECTION ;;
  }

  dimension: has_feedback {
    type: yesno
    sql: ${TABLE}.HAS_FEEDBACK ;;
  }

  dimension: has_grading_statement {
    type: yesno
    sql: ${TABLE}.HAS_GRADING_STATEMENT ;;
  }

  dimension: has_image {
    type: yesno
    sql: ${TABLE}.HAS_IMAGE ;;
  }

  dimension: has_marvin {
    type: yesno
    sql: ${TABLE}.HAS_MARVIN ;;
  }

  dimension: has_master_it {
    type: yesno
    sql: ${TABLE}.HAS_MASTER_IT ;;
  }

  dimension: has_pad {
    type: yesno
    sql: ${TABLE}.HAS_PAD ;;
  }

  dimension: has_practice_it {
    type: yesno
    sql: ${TABLE}.HAS_PRACTICE_IT ;;
  }

  dimension: has_read_it {
    type: yesno
    sql: ${TABLE}.HAS_READ_IT ;;
  }

  dimension: has_solution {
    type: yesno
    sql: ${TABLE}.HAS_SOLUTION ;;
  }

  dimension: has_standalone_master_it {
    type: yesno
    sql: ${TABLE}.HAS_STANDALONE_MASTER_IT ;;
  }

  dimension: has_tutorial {
    type: yesno
    sql: ${TABLE}.HAS_TUTORIAL ;;
  }

  dimension: has_tutorial_popup {
    type: yesno
    sql: ${TABLE}.HAS_TUTORIAL_POPUP ;;
  }

  dimension: has_watch_it {
    type: yesno
    sql: ${TABLE}.HAS_WATCH_IT ;;
  }

  dimension: is_included_in_psp_quiz {
    type: yesno
    sql: ${TABLE}.IS_INCLUDED_IN_PSP_QUIZ ;;
  }

  dimension: is_locked_scheduled {
    type: yesno
    sql: ${TABLE}.IS_LOCKED_SCHEDULED ;;
  }

  dimension: is_randomized {
    type: yesno
    sql: ${TABLE}.IS_RANDOMIZED ;;
  }

  dimension: is_trashed {
    type: yesno
    sql: ${TABLE}.IS_TRASHED ;;
  }

  dimension: is_useable {
    type: yesno
    sql: ${TABLE}.IS_USEABLE ;;
  }

  dimension: is_webassign_author {
    type: yesno
    sql: ${TABLE}.IS_WEBASSIGN_AUTHOR ;;
  }

  dimension: keywords {
    type: string
    sql: ${TABLE}.KEYWORDS ;;
  }

  dimension_group: last_modified_et {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.LAST_MODIFIED_ET ;;
  }

  dimension: level {
    type: string
    sql: ${TABLE}.LEVEL ;;
  }

  dimension: num_boxes {
    type: number
    sql: ${TABLE}.NUM_BOXES ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.ORIGIN ;;
  }

  dimension: permissions {
    type: string
    sql: ${TABLE}.PERMISSIONS ;;
  }

  dimension: qdiff_difficulty_index {
    type: number
    sql: ${TABLE}.QDIFF_DIFFICULTY_INDEX ;;
  }

  dimension: qdiff_num_attempts {
    type: number
    sql: ${TABLE}.QDIFF_NUM_ATTEMPTS ;;
  }

  dimension: qdiff_pct_correct_additional {
    type: number
    sql: ${TABLE}.QDIFF_PCT_CORRECT_ADDITIONAL ;;
  }

  dimension: qdiff_pct_correct_attempt_1 {
    type: number
    sql: ${TABLE}.QDIFF_PCT_CORRECT_ATTEMPT_1 ;;
  }

  dimension: qdiff_pct_correct_attempt_2 {
    type: number
    sql: ${TABLE}.QDIFF_PCT_CORRECT_ATTEMPT_2 ;;
  }

  dimension: qdiff_pct_correct_attempt_3 {
    type: number
    sql: ${TABLE}.QDIFF_PCT_CORRECT_ATTEMPT_3 ;;
  }

  dimension: qdiff_pct_correct_attempt_4 {
    type: number
    sql: ${TABLE}.QDIFF_PCT_CORRECT_ATTEMPT_4 ;;
  }

  dimension: qdiff_pct_correct_attempt_5 {
    type: number
    sql: ${TABLE}.QDIFF_PCT_CORRECT_ATTEMPT_5 ;;
  }

  dimension: question_code {
    type: string
    sql: ${TABLE}.QUESTION_CODE ;;
  }

  dimension: question_id {
    type: number
    sql: ${TABLE}.QUESTION_ID ;;
  }

  dimension: question_mode {
    type: string
    sql: ${TABLE}.QUESTION_MODE ;;
  }

  dimension: req_flash {
    type: yesno
    sql: ${TABLE}.REQ_FLASH ;;
  }

  dimension: req_java {
    type: yesno
    sql: ${TABLE}.REQ_JAVA ;;
  }

  dimension: req_question_part_submission {
    type: yesno
    sql: ${TABLE}.REQ_QUESTION_PART_SUBMISSION ;;
  }

  dimension: taq_avg_time {
    type: number
    sql: ${TABLE}.TAQ_AVG_TIME ;;
  }

  dimension: taq_med_time {
    type: number
    sql: ${TABLE}.TAQ_MED_TIME ;;
  }

  dimension: taq_num_students {
    type: number
    sql: ${TABLE}.TAQ_NUM_STUDENTS ;;
  }

  dimension: textbook_id {
    type: number
    sql: ${TABLE}.TEXTBOOK_ID ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [dim_question_id, dim_textbook.dim_textbook_id, dim_textbook.name, dim_textbook.publisher_name, dim_question_mode.dim_question_mode_id]
  }
}
