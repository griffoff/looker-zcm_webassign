include: "_zcm_lifetime_registrations.view.lkml"
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



view: _zcm_lifetime_registrations {
  derived_table: {
    sql:
SELECT
              DISTINCT r.fact_registration_id as fact_registration_id
            , s.dim_school_id as dim_school_id
            , s.school_id as school_id
            , time.special_ay_year as special_ay_year
            , time.ay_value as ay_value
            , d.dim_discipline_id as dim_discipline_id
            , d.sub_discipline_name as sub_discipline_name
            , topic.topic
            , sec.course_id as course_id
            , sec.course_instructor_id as course_instructor_id
            , sec.dim_section_id as dim_section_id
            , sec.section_instructor_id as section_instructor_id
            , COALESCE(sum(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id),0) as school_registrations
            , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_redesign_reg
            , COALESCE(sum(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, topic.topic),0) as annual_school_topic_registrations
            , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id),0) as school_courses
            , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_school_courses
            , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, topic.topic),0) as annual_school_topic_courses
            , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id),0) as school_sections
            , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_school_sections
            , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, topic.topic),0) as annual_school_topic_sections
            , COALESCE(COUNT(DISTINCT topic.topic) OVER (PARTITION BY s.dim_school_id),0) as school_topics
            , COALESCE(COUNT(DISTINCT topic.topic) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_school_topics
FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION  AS r
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL  AS s ON r.DIM_SCHOOL_ID = s.DIM_SCHOOL_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SECTION AS sec on r.DIM_SECTION_ID = sec.DIM_SECTION_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK  AS t ON r.DIM_TEXTBOOK_ID = t.DIM_TEXTBOOK_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE  AS d ON t.DIM_DISCIPLINE_ID = d.DIM_DISCIPLINE_ID
    INNER JOIN ${dim_time_zcm.SQL_TABLE_NAME} AS time ON r.DIM_TIME_ID = time.DIM_TIME_ID
    INNER JOIN ${_zcm_topic_filter.SQL_TABLE_NAME} AS topic ON r.fact_registration_id = topic.fact_registration_id
      WHERE ((UPPER(s.COUNTRY_NAME ) = UPPER('United States')))
      AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
      AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX', 'OPENINTRO')))
      AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS', 'PRECALCULUS', 'FINITE MATH AND APPLIED CALCULUS'))
      OR ((UPPER(t.name) LIKE '%ALG%' OR UPPER(t.name) like '%TRIG%') AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%'))
      AND (time.ay_value >= -{% parameter lifetime_ay %})
          ;;
  }


###############################################
######## KEYS AND IDENTIFIERS (HIDDEN) ########
###############################################

dimension: pk1_fact_registration_id {
  primary_key: yes
  hidden: yes
  sql: ${TABLE}.fact_registration_id ;;
}

dimension: fk2_ay_key {
  description: "Key for school/academic year level"
  hidden: yes
  primary_key: no
  sql: nullif(hash(${dim_school_id},'|',${special_ay_year}),0) ;;
}

dimension: fk3_topic_key {
  description: "Key for school/academic year/sub_discipline level"
  hidden: yes
  primary_key: no
  sql: nullif(hash(${dim_school_id},'|',${special_ay_year},'|',${topic}),0) ;;
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
  label: "   Lifetime Academic Years Included"
  description: "For Lifetime metrics, select how many Academic Years back you want included in the query (Not including the current academic year).
                Ex: selecting '3' would include the current ongoing academic year plus the prior 3"
  view_label: "           Parameters & Filters"
}


dimension: school_id {
    label: "          School ID"
    hidden: no
    group_label: "           Lifetime Dimensions"
  }

dimension: special_ay_year  {
  label: "        Academic Year"
  hidden: no
  group_label: "           Lifetime Dimensions"
  }

dimension: sub_discipline_name  {
  label: "     Sub-Discipline Name"
  group_label: "           Lifetime Dimensions"
}

dimension: topic {
  label: "     Course Topic"
  description: "Similar to Sub-Discipline, but extracts and groups courses using Algebra and Trig products out of Dev Math and into their own topic category"
  group_label: "           Lifetime Dimensions"
  }

###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


############## LIFETIME AGGREGATES ##################

  dimension: school_courses {
    type: number
    label: "                                  Lifetime Courses"  #34
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Course Aggregations"
  }

  dimension: school_sections {
    type: number
    label: "                                 Lifetime Sections" #31
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Course Aggregations"
  }

  dimension: school_topics {
    type: number
    label: "                            Lifetime Topics"  #28
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "   Topic Aggregations"
  }

  dimension: school_registrations  {
    type: number
    label: "                          Lifetime Registrations"  #26
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "  Registration Aggregations"
  }




  measure: avg_school_courses {
    type: average
    label: "    Average Lifetime Courses"
    group_label: "    Lifetime Averages"
    sql: ${school_courses} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_school_sections {
    type: average
    label: "   Average Lifetime Sections"
    group_label: "    Lifetime Averages"
    sql: ${school_sections} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_school_topics {
    type: average
    label: "  Average Lifetime Topics Taught"
    group_label: "    Lifetime Averages"
    sql: ${school_topics} ;;
    value_format_name: decimal_1
    hidden: yes
 }

  measure: avg_school_registrations {
    type: average
    label: " Average Lifetime Registrations"
    group_label: "    Lifetime Averages"
    sql: ${school_registrations} ;;
    value_format_name: decimal_1
    hidden: yes
  }

############## ANNUAL AGGREGATES ####################

  dimension: annual_school_courses {
    type: number
    label: "                                 Lifetime An Courses" #33
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Course Aggregations"
  }

  dimension: annual_school_sections {
    type: number
    label: "                              Lifetime An Sections"  #30
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "    Course Aggregations"
  }

  dimension: annual_school_topics {
    type: number
    label: "                           Lifetime An Topics"  #27
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "   Topic Aggregations"
    drill_fields: [topic_drill*]
  }

  dimension: annual_redesign_reg  {
    type: number
    label: "                         Lifetime An Registrations" #25
    description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: "  Registration Aggregations"
  }


  measure: avg_annual_school_courses {
    type: average
    label: "    Average An Courses"
    group_label: "   Annual Averages"
    sql: ${annual_school_courses} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_annual_school_sections {
    type: average
    label: "   Average An Sections"
    group_label: "   Annual Averages"
    sql: ${annual_school_sections} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_annual_school_topics {
    type: average
    label: "  Average An Topics Taught"
    group_label: "   Annual Averages"
    sql: ${annual_school_topics} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_annual_redesign_reg {
    type: average
    label: " Average An Registrations"
    group_label: "   Annual Averages"
    sql: ${annual_redesign_reg} ;;
    value_format_name: decimal_1
    hidden: yes
  }




############# ANNUAL TOPIC AGGREGATES ##############

  dimension: annual_school_topic_courses {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year."
    label: "                                 Lifetime An Tp Courses" #32
    group_label: "    Course Aggregations"
  }

  dimension: annual_school_topic_sections {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year."
    label: "                             Lifetime An Tp Sections" #29
    group_label: "    Course Aggregations"
  }

  dimension: annual_school_topic_registrations  {
    type: number
    label: "                        Lifetime An Tp Registrations"  #24
    description: "Measures aggregated at the institution level and broken out by course topic and academic year."
    group_label: "  Registration Aggregations"
  }


  measure: avg_annual_school_topic_courses {
    type: average_distinct
    label: "   Average An Courses by Topic"
    group_label: " Annual Topic Averages"
    sql: ${annual_school_topic_courses} ;;
    sql_distinct_key: ${fk3_topic_key} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_annual_school_topic_sections {
    type: average_distinct
    label: "  Average An Topic Sections"
    group_label: " Annual Topic Averages"
    sql: ${annual_school_topic_sections} ;;
    sql_distinct_key: ${fk3_topic_key} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_annual_school_topic_registrations {
    type: average_distinct
    label: " Average An Topic Registrations"
    group_label: " Annual Topic Averages"
    sql: ${annual_school_topic_registrations} ;;
    sql_distinct_key: ${fk3_topic_key} ;;
    value_format_name: decimal_1
    hidden: yes
  }



measure: count {
  label: "# Distinct Schools"
    type: count_distinct
    sql: ${dim_school_id} ;;
  }

  measure: number_topics {
    type: count_distinct
    sql: ${topic} ;;
  }

  measure: number_academic_years{
    type: count_distinct
    sql: ${special_ay_year} ;;
  }

  measure: lifetime_registrations {
    type: sum_distinct
    label: "# Lifetime Registrations"
    sql: ${TABLE}.annual_school_topic_registrations ;;
    sql_distinct_key: ${fk3_topic_key} ;;
  }

#   measure: average_lifetime_registrations {
#     type:
#     label: "Average Registrations"
#     sql: ${TABLE}.annual_school_topic_registrations ;;
# #    sql_distinct_key: ${fk3_topic_key} ;;
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


measure: lifetime_pk_count {
  type: count
  filters:{
    field: pk1_fact_registration_id
    value: "NOT NULL"
    }
  hidden: no
}

  set: topic_drill {
    fields: [dim_school.name, sub_discipline_name,  special_ay_year, dim_section_zcm.course_count, dim_section.section_count, fact_registration.user_registrations]
  }



}
