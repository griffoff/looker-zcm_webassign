# If necessary, uncomment the line below to include explore_source.
include: "//webassign/dim_deployment.view.lkml"
 include: "//webassign/webassign.model.lkml"
view: zcm_question_is_used {
  view_label: " Chip's Additions"
  derived_table: {
    sql: SELECT
          dq.DIM_QUESTION_ID  AS DIM_QUESTION_ID
        , dq.question_id as QUESTION_ID
        , dq.dim_textbook_id as dim_textbook_id
        , COUNT(DISTINCT dd.dim_deployment_id ) AS DEPLOYMENTS_COUNT
        , COUNT(DISTINCT ds.dim_section_id) as section_count
        , count(distinct da.dim_assignment_id) as assignment_count
        , count(distinct r.id) as response_count
FROM ${responses.SQL_TABLE_NAME} AS r
LEFT JOIN FT_OLAP_REGISTRATION_REPORTS.DIM_QUESTION  AS dq ON r.QUESTION_ID = dq.QUESTION_ID
LEFT JOIN ${dim_deployment.SQL_TABLE_NAME}  AS dd ON r.deployment_id = dd.DEPLOYMENT_ID
LEFT JOIN ${dim_section.SQL_TABLE_NAME} as ds on dd.section_id = ds.section_id
LEFT JOIN FT_OLAP_REGISTRATION_REPORTS.DIM_ASSIGNMENT da on dd.assignment_id = da.assignment_id
      GROUP BY 1,2,3
      ;;
    sql_trigger_value: SELECT count(*) FROM FT_OLAP_REGISTRATION_REPORTS.DIM_DEPLOYMENT ;;
  }

  dimension: dim_question_id {
    type: number
    primary_key: yes
    hidden: no
    sql: ${TABLE}.DIM_QUESTION_ID ;;
  }
  dimension: question_id {
    type: number
    primary_key: no
    hidden: no
    sql: ${TABLE}.QUESTION_ID ;;
  }

  dimension: dim_textbook_id {}

  dimension: deployments_count {
    type: number
    group_label: " Question is Used"
    label: "# Deployments - Question"
    description: "Counts the number of times a question was deployed in an assignment. Used to identify and filter out questions that are not used"
    hidden: no
    sql: ${TABLE}.DEPLOYMENTS_COUNT ;;
  }

  filter: question_is_used {
    type: string
    group_label: " Question is Used"
    label: "Question is Used?"
    description: "'Used' is defined as a question that has been deployed and has at least 1 response. "
    default_value: "Yes"
    sql: CASE WHEN (${response_count} >= 1 AND ${deployments_count} >=1) THEN 'Yes' ELSE 'No' END;;
  }

  dimension: response_count {
    type: number
    group_label: " Question is Used"
    label: "# Responses - Question"
    description: "Counts the number of responses to a particular question."
    hidden: no
    sql: ${TABLE}.response_count ;;
  }

dimension: section_count {
  type: number
  group_label: " Question is Used"
  label: "# Sections - Question"
  description: "Counts the number of sections a particular question appears in."
  hidden:  no
  sql: ${TABLE}.section_count ;;
  }

dimension: assignment_count {
  type: number
  group_label: " Question is Used"
  label: "# Assignments - Question"
  description: "Counts the number of assignments a question appears in."
  hidden: no
  sql: ${TABLE}.assignment_count ;;
}

measure: count {
  type: count
}


}
