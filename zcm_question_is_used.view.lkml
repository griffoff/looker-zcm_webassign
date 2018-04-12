# If necessary, uncomment the line below to include explore_source.

# include: "webassign.model.lkml"
view: zcm_question_is_used {
  view_label: " Chip's Additions"
  derived_table: {
    sql: SELECT
        dim_question.DIM_QUESTION_ID  AS DIM_QUESTION_ID,
        dim_question.question_id as QUESTION_ID,
        dim_question.dim_textbook_id as dim_textbook_id,
        COUNT(DISTINCT dim_deployment.dim_deployment_id ) AS DEPLOYMENTS_COUNT,
       count(distinct sectionslessons.id) as sectionslessons_count
FROM ${responses.SQL_TABLE_NAME} AS responses
LEFT JOIN WA2ANALYTICS.DIM_QUESTION  AS dim_question ON responses.QUESTIONID = dim_question.QUESTION_ID
LEFT JOIN WA2ANALYTICS.DIM_DEPLOYMENT  AS dim_deployment ON responses.SECTIONSLESSONSID = dim_deployment.DEPLOYMENT_ID
left join WA2ANALYTICS.SECTIONSLESSONS as sectionslessons on responses.sectionslessonsid = sectionslessons.id
      GROUP BY 1,2,3
      ;;
    sql_trigger_value: SELECT count(*) FROM WA2ANALYTICS.SECTIONSLESSONS ;;
  }

  dimension: dim_question_id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.DIM_QUESTION_ID ;;
  }
  dimension: question_id {
    type: number
    primary_key: no
    hidden: yes
    sql: ${TABLE}.QUESTION_ID ;;
  }
  dimension: deployments_count {
    type: number
    group_label: " Question is Used"
    label: "# Deployments - Question"
    description: "Counts the number of times a question was deployed in an assignment. Used to identify and filter out questions that are not used"
    hidden: yes
    sql: ${TABLE}.DEPLOYMENTS_COUNT ;;
  }

  filter: question_is_used {
    type: string
    group_label: " Question is Used"
    label: "Question is Deployed?"
    description: "Denotes whether or not a question is used in 1 or more section lessons (# ssignments)"
    default_value: "Yes"
    sql: CASE WHEN ${sectionslessons_count} >= 1 THEN 'Yes' ELSE 'No' END;;
  }

  dimension: sectionslessons_count {
    type: number
    group_label: " Question is Used"
    label: "# SectionLesson - Question"
    description: "Counts the number of times a question is in a section lesson. Used to identify and filter questions that are not used"
    hidden: yes
    sql: ${TABLE}.sectionslessons_count ;;
  }

  filter: question_is_used_dep {
    type: string
    default_value: "Yes"
    group_label: " Question is Used"
    label: "Question is Used"
    description: "Denotes whether or not a question is used in 1 or more deployments (# Students w/ question assigned)"
    sql: CASE WHEN ${deployments_count} >= 1 THEN 1 ELSE 0 END;;
  }





}