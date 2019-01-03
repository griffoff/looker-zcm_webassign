include: "_zcm_all_registrations.view.lkml"
include: "_redesign_multiview_fields.view.lkml"
include: "zcm_redesign_personas.model.lkml"
include: "dim_textbook_zcm.view.lkml"
include: "/webassign/dim_textbook.view.lkml"
##################################################################################################################################################################
############### THIS VIEW IS AT THE SCHOOL-AY-TOPIC LEVEL. IT IS THE BROADEST VIEW OF LIFETIME USAGE AT THE SCHOOL, ACADEMIC YEAR, & TOPIC     ###################
############### LEVELS AND IS INTENDED AS A BASE TABLE FOR THE MODEL. THE VALUES FROM THIS TABLE ALLOW US TO LOOK AT LIFETIME USAGE, ONE SMALL ###################
############### PART IN ASSESSING PERSONAS. SUBSEQUENT TABLES JOINED TO THIS ONE WILL BE USED FOR THE PRIMARY FOR ANALYSIS. 'LIFETIME USAGE'   ###################
############### IS DEFINED BY DEFAULT TO ALL ACADEMIC YEARS WITH DATA. THERE IS AN OPTIONAL PARAMETER ALLOWING THE USER TO REDEFINE THIS TIME  ###################
############### FRAME INDEPENDENTLY OF THE "FOCUSED" RANGE WHICH IS USED FOR THE MAJORITY OF THE METRICS FOR FLAGGING PERSONAL. ALL DIMENSIONS ###################
############### (EXCEPT ANY NEW ONES DERIVED HERE) WILL BE HIDDEN FROM VIEW AS THEY ARE INTENDED SOLEY FOR.                                    ###################
##################################################################################################################################################################



view: _zcm_all_registrations {
  view_label: "          Lifetime Registrations"
  derived_table: {
    sql:
SELECT
          DISTINCT -- r.fact_registration_id,
            r.dim_school_id as dim_school_id    -- Pulling from registrations not school to insure that only institutions with registrations are pulled in
          , s.school_id as school_id
          , time.special_ay_year as special_ay_year
          , time.ay_value as ay_value
          , d.dim_discipline_id as dim_discipline_id
          , d.sub_discipline_name
          , COALESCE(sum(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id),0) as lifetime_redesign_reg
          , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_redesign_reg
          , COALESCE(sum(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, d.dim_discipline_id),0) as annual_topic_redesign_reg
          , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id),0) as lifetime_course_count
          , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_course_count
          , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, d.dim_discipline_id),0) as annual_topic_course_count
          , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id),0) as lifetime_section_count
          , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_section_count
          , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, d.dim_discipline_id),0) as annual_topic_section_count
          , COALESCE(COUNT(DISTINCT d.dim_discipline_id) OVER (PARTITION BY s.dim_school_id),0) as lifetime_topic_count
          , COALESCE(COUNT(DISTINCT d.dim_discipline_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_topic_count
FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION  AS r
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL  AS s ON r.DIM_SCHOOL_ID = s.DIM_SCHOOL_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SECTION AS sec on r.DIM_SECTION_ID = sec.DIM_SECTION_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK  AS t ON r.DIM_TEXTBOOK_ID = t.DIM_TEXTBOOK_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE  AS d ON t.DIM_DISCIPLINE_ID = d.DIM_DISCIPLINE_ID
    INNER JOIN ${dim_time_zcm.SQL_TABLE_NAME} AS time ON r.DIM_TIME_ID = time.DIM_TIME_ID
      WHERE ((UPPER(s.COUNTRY_NAME ) = UPPER('United States')))
      AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
      AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX', 'OPENINTRO')))
      AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS', 'PRECALCULUS', 'FINITE MATH AND APPLIED CALCULUS'))
      OR ((UPPER(t.name) LIKE '%ALG%' OR UPPER(t.name) like '%TRIG%') AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%'))
      AND (time.ay_value >= -{% parameter lifetime_ay %})
--      AND (r.registrations = 1)
          ;;
  }


###############################################
######## KEYS AND IDENTIFIERS (HIDDEN) ########
###############################################



dimension: pk {
  hidden: no
  primary_key: yes
  sql: nullif(hash(${dim_school_id},'|',${special_ay_year},'|',${dim_discipline_id}),0) ;;
}
      dimension: ay_value  {
        label: "Academic Year Relative Value"
        description: "Assigns a numeric value to the academic year with 0 as the current ongoing year, -1 as the prior (complete) year, -2 as two years ago. Used in calculations and code as a relative reference that changes as time passes "
        hidden: yes
      }
    dimension: dim_school_id {
      hidden: yes
      group_label: "School"
      }
    dimension: dim_discipline_id  {
      hidden: yes
      group_label: "Discipline"
    }



###############################################
########## FIELDS IN VIEW IN EXPLORE ##########
###############################################

parameter: lifetime_ay {
  default_value: "25"
  label: " Select Lifetime Academic Years"
  description: "For Lifetime metrics, select how many Academic Years back you want included in the query (Not including the current academic year).
                Ex: selecting '3' would include the current ongoing academic year plus the prior 3"
  view_label: "           Parameters & Filters"
}


dimension: school_id {
    label: "       School ID"
    hidden: no
  }

dimension: special_ay_year  {
  label: "      Academic Year"
  hidden: no
  }

dimension: sub_discipline_name  {
  label: "     Sub-Discipline Name"
}



###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


############## LIFETIME AGGREGATES ##################

  dimension: lifetime_course_count {
    type: number
    label: "   Lifetime Courses"
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Lifetime Aggregations"
  }
  dimension: lifetime_section_count {
    type: number
    label: "   Lifetime Sections"
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Lifetime Aggregations"
}
  dimension: lifetime_topic_count {
    type: number
    label: "  Lifetime Topics Taught"
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Lifetime Aggregations"
  }
  dimension: lifetime_redesign_reg  {
    type: number
    label: "Lifetime Registrations"
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Lifetime Aggregations"
  }




  measure: avg_lifetime_course_count {
    type: average
    label: "    Average Lifetime Courses"
    group_label: "    Lifetime Averages"
    sql: ${lifetime_course_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_lifetime_section_count {
    type: average
    label: "   Average Lifetime Sections"
    group_label: "    Lifetime Averages"
    sql: ${lifetime_section_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_lifetime_topic_count {
    type: average
    label: "  Average Lifetime Topics Taught"
    group_label: "    Lifetime Averages"
    sql: ${lifetime_topic_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_lifetime_redesign_reg {
    type: average
    label: " Average Lifetime Registrations"
    group_label: "    Lifetime Averages"
    sql: ${lifetime_redesign_reg} ;;
    value_format_name: decimal_1
  }

############## ANNUAL AGGREGATES ####################

  dimension: annual_course_count {
    type: number
    label: "    Annual Courses"
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "  Annual Aggregations"
  }
  dimension: annual_section_count {
    type: number
    label: "   Annual Sections"
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "  Annual Aggregations"
  }
  dimension: annual_topic_count {
    type: number
    label: "  Annual Topics Taught"
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "  Annual Aggregations"
    drill_fields: [topic_drill*]
  }
  dimension: annual_redesign_reg  {
    type: number
    label: " Annual Registrations"
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "  Annual Aggregations"
  }


  measure: avg_annual_course_count {
    type: average
    label: "    Average Annual Courses"
    group_label: "   Annual Averages"
    sql: ${annual_course_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_annual_section_count {
    type: average
    label: "   Average Annual Sections"
    group_label: "   Annual Averages"
    sql: ${annual_section_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_annual_topic_count {
    type: average
    label: "  Average Annual Topics Taught"
    group_label: "   Annual Averages"
    sql: ${annual_topic_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_annual_redesign_reg {
    type: average
    label: " Average Annual Registrations"
    group_label: "   Annual Averages"
    sql: ${annual_redesign_reg} ;;
    value_format_name: decimal_1
  }




############# ANNUAL TOPIC AGGREGATES ##############

  dimension: annual_topic_course_count {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year."
    label: "   Annual Topic Courses"
    group_label: " Annual Topic Aggregations"
  }
  dimension: annual_topic_section_count {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year."
    label: "  Annual Topic Sections"
    group_label: " Annual Topic Aggregations"
  }
  dimension: annual_topic_redesign_reg  {
    type: number
    label: " Annual Topic Registrations"
    description: "Measures aggregated at the institution level and broken out by course topic and academic year."
    group_label: " Annual Topic Aggregations"
  }


  measure: avg_annual_topic_course_count {
    type: average_distinct
    label: "   Average Annual Courses by Topic"
    group_label: " Annual Topic Averages"
    sql: ${annual_topic_course_count} ;;
    sql_distinct_key: ${pk} ;;
    value_format_name: decimal_1
  }
  measure: avg_annual_topic_section_count {
    type: average_distinct
    label: "  Average Annual Topic Sections"
    group_label: " Annual Topic Averages"
    sql: ${annual_topic_section_count} ;;
    sql_distinct_key: ${pk} ;;
    value_format_name: decimal_1
  }
  measure: avg_annual_topic_redesign_reg {
    type: average_distinct
    label: " Average Annual Topic Registrations"
    group_label: " Annual Topic Averages"
    sql: ${annual_topic_redesign_reg} ;;
    sql_distinct_key: ${pk} ;;
    value_format_name: decimal_1
  }



measure: count {
  label: "# Distinct Schools"
    type: count_distinct
    sql: ${dim_school_id} ;;
  }

  measure: number_topics {
    type: count_distinct
    sql: ${dim_discipline_id} ;;
  }

  measure: number_academic_years{
    type: count_distinct
    sql: ${special_ay_year} ;;
  }

  measure: lifetime_registrations {
    type: sum_distinct
    label: "# Registrations"
    sql: ${TABLE}.annual_topic_redesign_reg ;;
    sql_distinct_key: ${pk} ;;
  }

#   measure: average_lifetime_registrations {
#     type:
#     label: "Average Registrations"
#     sql: ${TABLE}.annual_topic_redesign_reg ;;
# #    sql_distinct_key: ${pk} ;;
#     value_format_name: decimal_1
#   }


############################################################################
########################### HIDDEN FIELDS ##################################
############################################################################

  dimension: ay_start_year {
    hidden: yes
    type: number
    sql: left(${special_ay_year},4) ;;
  }

  dimension: ay_end_year {
    hidden: yes
    type: number
    sql: right(${special_ay_year},4) ;;
  }


measure: all_reg_pk_count {
  type: count
  hidden: no
}

  set: topic_drill {
    fields: [dim_school.name, sub_discipline_name,  special_ay_year, dim_section_zcm.course_count, dim_section.section_count, fact_registration.user_registrations]
  }



}
