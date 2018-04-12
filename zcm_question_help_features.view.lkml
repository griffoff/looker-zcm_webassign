# The purpose of this table is primarially to improve visualizations.
#
# Why it is needed:        In dim_question, each help feature has its own yesno field, which is fine when you are looking at individual questions or the usage of specific help feature in isolation. However, there are many instances
#                          where a comparative analysis of the features represented in a visualization are ideal. I unsuccessfully tried to create a field in dim_question using a CASE statement, but the CASE statement stops at the first true statement.
#
# Example Use Cases:       Are certain help features favored and assigned more frequently? Does average student score improve after feature 'x' is added to a question and how does it size up with questions that added feature 'y'?
#                          Do students tend to gravitate more to questions with a specific help feature in practice assignments? Etc.
#
# Intended functionality:  To create a table that contains all of the various question help features into one field.  Since a question can have 0 or many different help features available, dim_question_id will not be unique.
#
# Query Rationale:         The purpose of the first CTE of the query is to replace the yesno value of the existing fields in dim_question with the name of the feature when the value = 'Yes' and to make null all values ="No"
#                          The 2nd CTE creates a new column 'features' in the select statement which is defined from a select statement for each help feature that is unioned under the single 'features' label.
#                          In order to be able to count the distinct number of questions with a given help feature, the where statement removes all questions where there is a null value for a given feature
#
# Join to Model:           Left Joins to dim_question on dim_question_id with a one_to_many relationship

view: zcm_question_help_features {
  view_label: " Chip's Additions"
  derived_table: {
    sql_trigger_value: select count(*) from WA2ANALYTICS.DIM_QUESTION ;;
    sql: WITH x AS (
        SELECT
              q.dim_question_id AS dim_question_id
            , q.question_id AS question_id
            , CASE WHEN q.has_feedback='Yes' THEN 'Feedback' ELSE NULL END AS feedback
            , CASE WHEN q.has_solution='Yes' THEN 'Solution' ELSE NULL  END AS solution
            , CASE WHEN q.has_image='Yes' THEN 'Image' ELSE NULL END AS image
            , CASE WHEN q.has_tutorial='Yes' THEN 'Tutorial' ELSE NULL END AS tutorial
            , CASE WHEN q.has_tutorial_popup='Yes' THEN 'Tutorial Popup' ELSE NULL END AS tutorial_popup
            , CASE WHEN q.has_marvin='Yes' THEN 'Marvin' ELSE NULL END AS marvin
            , CASE WHEN q.has_watch_it='Yes' THEN 'Watch It' ELSE NULL END AS watch_it
            , CASE WHEN q.has_practice_it='Yes' THEN 'Practice It' ELSE NULL END AS practice_it
            , CASE WHEN q.has_master_it='Yes' THEN 'Master It' ELSE NULL END AS master_it
            , CASE WHEN q.has_standalone_master_it='Yes' THEN 'Standalone Master It' ELSE NULL END AS standalone_master_it
            , CASE WHEN q.has_read_it='Yes' THEN 'Read It' ELSE NULL END AS read_it
            , CASE WHEN q.has_grading_statement='Yes' THEN 'Grading Statement' ELSE NULL END AS grading_statement
            , CASE WHEN q.has_ebook_section='Yes' THEN 'Ebook' ELSE NULL END AS ebook_section
            , CASE WHEN q.has_pad='Yes' THEN 'Pad' ELSE NULL END AS pad
        FROM WA2ANALYTICS.DIM_QUESTION q
      )
      SELECT dim_question_id, question_id, features
      FROM (
            SELECT dim_question_id, question_id, feedback AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, solution AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, image AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, tutorial AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, tutorial_popup AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, marvin AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, watch_it AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, practice_it AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, master_it AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, standalone_master_it AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, read_it AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, grading_statement AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, ebook_section AS features   FROM x UNION ALL
            SELECT dim_question_id, question_id, pad AS features   FROM x
      )
      WHERE features IS NOT NULL
      ORDER BY 1,2,3;;
  }
  dimension: dim_question_id {
    label: "dim_question_id (Features)"
    group_label: "Question Features"
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.dim_question_id ;;
  }

  dimension: question_id {
    label: "question_id (Features)"
    group_label: "Question Features"
    hidden: yes
    type: string
    sql: ${TABLE}.question_id ;;
  }

  dimension: features {
    type: string
    label: "Question Features"
    group_label: "Question Features"
    sql: ${TABLE}.features ;;
  }

  measure: count_questions {
    type: count
    label: "question count"
  }










}
