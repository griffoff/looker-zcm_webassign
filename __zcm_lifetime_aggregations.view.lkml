include: "__zcm_lifetime_view.view.lkml"

view: __zcm_lifetime_aggregations {
  derived_table: {
    sql:
WITH crs as (
SELECT
      DISTINCT dim_school_id
      , count(distinct course_id) as school_courses
FROM ${__zcm_lifetime_view.SQL_TABLE_NAME}
GROUP BY 1
)
SELECT
              lv.*
            , crs.school_courses
--            , COALESCE(sum(REGISTRATIONS) OVER (PARTITION BY dim_school_id),0) as school_registrations
 --           , COALESCE(SUM(REGISTRATIONS) OVER (PARTITION BY dim_section_id),0) as section_registrations
            , COUNT(DISTINCT lv.course_id) OVER (PARTITION BY lv.dim_school_id) as school_courses_wf
 --           , COUNT(DISTINCT dim_section_id) OVER (PARTITION BY dim_school_id) as school_sections
 --           , COUNT(DISTINCT topic) OVER (PARTITION BY dim_school_id) as school_topics
 --           , COUNT(DISTINCT special_ay_year) OVER (PARTITION BY dim_school_id) as school_ays
 --           , COUNT(DISTINCT course_id) OVER (PARTITION BY course_instructor_id) as lifetime_crs_instructor_courses
 --           , COUNT(DISTINCT dim_section_id) OVER (PARTITION BY course_instructor_id) as lifetime_crs_instructor_sections
 --           , COUNT(DISTINCT special_ay_year) OVER (PARTITION BY course_instructor_id) as lifetime_crs_instructor_ays
 --           , COUNT(DISTINCT topic) OVER (PARTITION BY course_instructor_id) as lifetime_crs_instructor_topics
 --           , COUNT(DISTINCT section_instructor_id) OVER (PARTITION BY course_instructor_id) as lifetime_crs_instructor_sect_instructors
FROM ${__zcm_lifetime_view.SQL_TABLE_NAME} as lv
LEFT JOIN crs on lv.dim_school_id = crs.dim_school_id
;;
  }

 ###############################################
 ########### ENTITY COUNTS #####################
 ###############################################

   measure: course_instructor_count {
     label: "# Course Instructors"
     type: count_distinct
     sql: ${course_instructor_id} ;;
   }

   measure: section_instructor_count {
     label: "# Section Instructors"
     type: count_distinct
     sql: ${section_instructor_id} ;;
   }

   measure: course_id_count {
     label: "# Courses"
     type: count_distinct
     sql: ${course_id} ;;
   }

   measure: dim_section_id_count {
     label: "# Sections"
     type: count_distinct
     sql: ${dim_section_id} ;;
   }

   measure: school_count {
    label: "# Schools"
     type: count_distinct
     sql: ${dim_school_id} ;;
   }


###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


#################################### SCHOOL LEVEL AGGREGATES ##########################################

   dimension: school_courses {
     type: number
     label: "                                  # School Courses"  #34
     description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
     group_label: " Pre-Aggregated Dimensions - School"
     view_label: "     Lifetime View"
     drill_fields: [school_id, course_id]
   }

  dimension: school_courses_wf {
    type: number
    label: "                                  # School Courses WF"  #34
    description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
    group_label: " Pre-Aggregated Dimensions - School"
    view_label: "     Lifetime View"
    drill_fields: [school_id, course_id]
  }

   dimension: school_sections {
     type: number
     label: "                                 # School Sections" #31
     description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
     group_label: " Pre-Aggregated Dimensions - School"
     view_label: "     Lifetime View"
     drill_fields: [dim_school_id, dim_school.name, dim_section_id, section_registrations ]
   }

   dimension: school_topics {
     type: number
     label: "                            # School Course Topics"  #28
     description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
     group_label: " Pre-Aggregated Dimensions - School"
     view_label: "     Lifetime View"
   }

   dimension: school_registrations  {
     type: number
     label: "                          # School Registrations"  #26
     description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
     group_label: " Pre-Aggregated Dimensions - School"
     view_label: "     Lifetime View"
   }

   dimension: school_ays             {
     type: number
     label: "                          # School Academic Years"  #26
     description: "Rolled up measures aggregated at the institution level across all available years and for all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
     group_label: " Pre-Aggregated Dimensions - School"
     view_label: "     Lifetime View"
   }




 #################################### COURSE INSTRUCTOR LEVEL AGGREGATES ##########################################

   dimension: lifetime_crs_instructor_courses         {
     type: number
     label: "# Instr. Courses"
     group_label: "Pre-Aggregated Dimensions - Instructor"
     view_label: "     Lifetime View"
   }

   dimension: lifetime_crs_instructor_sections         {
     type: number
     label: "# Instr. Sections"
     group_label: "Pre-Aggregated Dimensions - Instructor"
     view_label: "     Lifetime View"
     }

   dimension: lifetime_crs_instructor_ays              {
     type: number
     label: "# Instr. Academic Years"
     group_label: "Pre-Aggregated Dimensions - Instructor"
     view_label: "     Lifetime View"
     }

   dimension: lifetime_crs_instructor_topics           {
     type: number
     label: "# Instr. Course Topics"
     group_label: "Pre-Aggregated Dimensions - Instructor"
     view_label: "     Lifetime View"
     }

   dimension: lifetime_crs_instructor_sect_instructors {
     type: number
     label: "# Section Instrs. Managed"
     description: "The number of distinct section instructors teaching in a course instructor's courses"
     group_label: "Pre-Aggregated Dimensions - Instructor"
     view_label: "     Lifetime View"
     }

 ############################# END PRE-AGGREGATED DIMENSIONS


# ###############################################
# ########  TO BE REMOVED FROM MODEL  ###########
# ###############################################
#

   dimension: section_registrations {
     hidden: yes
  }
#
#   measure: distinct_courses {
#     label: "# Distinct Courses"
#     type: number
#     sql: count(DISTINCT ${course_id}) ;;
#     drill_fields: [school_id, course_id]
#   }
#
#   measure: distinct_course_topics {
#     label: "# Distinct Course Topics"
#     type: number
#     sql: count(DISTINCT ${topic}) ;;
#     drill_fields: [school_id, course_id, topic]
#   }
#
# ###############################################
# ######## KEYS AND IDENTIFIERS (HIDDEN) ########
# ###############################################

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

  dimension: fk3_course_section_ay_key {
    hidden: yes
    sql: nullif(hash(${dim_section_id},'|',${course_instructor_id},'|',${special_ay_year}),0) ;;
  }

  dimension: fact_registration_id {hidden: yes}
  dimension: dim_school_id { hidden: yes }
  dimension: dim_discipline_id  {hidden: yes}
  dimension: school_id {hidden: yes}
  dimension: course_id {hidden: yes}
  dimension: dim_section_id {hidden: yes}
  dimension: section_id {hidden: yes}
  dimension: ay_value {hidden: yes}
  dimension: special_ay_year  {hidden:yes}
  dimension: topic {hidden: yes }
  dimension: course_instructor_id {hidden: yes}
  dimension: crs_instructor_name {hidden: yes}
  dimension: ay_start_year {hidden: yes  }
  dimension: ay_end_year {hidden: yes  }
  dimension: section_instructor_id {hidden:yes}
  set: topic_drill {
    fields: [dim_school.name, fact_registration.sub_discipline_name,  special_ay_year, dim_section_zcm.course_count, dim_section.section_count, fact_registration.user_registrations]
  }

# #   measure: avg_school_courses {
# #     type: average
# #     label: "    Average Lifetime Courses"
# #     group_label: "    Lifetime Averages"
# #     sql: ${school_courses} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #   measure: avg_school_sections {
# #     type: average
# #     label: "   Average Lifetime Sections"
# #     group_label: "    Lifetime Averages"
# #     sql: ${school_sections} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #   measure: avg_school_topics {
# #     type: average
# #     label: "  Average Lifetime Topics Taught"
# #     group_label: "    Lifetime Averages"
# #     sql: ${school_topics} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #  }
# #
# #   measure: avg_school_registrations {
# #     type: average
# #     label: " Average Lifetime Registrations"
# #     group_label: "    Lifetime Averages"
# #     sql: ${school_registrations} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
#
# ############## ANNUAL AGGREGATES ####################
#
# #   dimension: annual_school_courses {
# #     type: number
# #     label: "                                 Lifetime An Courses" #33
# #     description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
# #     group_label: "    Course Aggregations"
# #   }
# #
# #   dimension: annual_school_sections {
# #     type: number
# #     label: "                              Lifetime An Sections"  #30
# #     description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
# #     group_label: "    Course Aggregations"
# #   }
# #
# #   dimension: annual_school_topics {
# #     type: number
# #     label: "                           Lifetime An Topics"  #27
# #     description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
# #     group_label: "   Topic Aggregations"
# #     drill_fields: [topic_drill*]
# #   }
# #
# #   dimension: annual_redesign_reg  {
# #     type: number
# #     label: "                         Lifetime An Registrations" #25
# #     description: "Measures aggregated at the institution level and broken out by academic year. Includes all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
# #     group_label: "  Registration Aggregations"
# #   }
# #
# #
# #   measure: avg_annual_school_courses {
# #     type: average
# #     label: "    Average An Courses"
# #     group_label: "   Annual Averages"
# #     sql: ${annual_school_courses} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #   measure: avg_annual_school_sections {
# #     type: average
# #     label: "   Average An Sections"
# #     group_label: "   Annual Averages"
# #     sql: ${annual_school_sections} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #   measure: avg_annual_school_topics {
# #     type: average
# #     label: "  Average An Topics Taught"
# #     group_label: "   Annual Averages"
# #     sql: ${annual_school_topics} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #   measure: avg_annual_redesign_reg {
# #     type: average
# #     label: " Average An Registrations"
# #     group_label: "   Annual Averages"
# #     sql: ${annual_redesign_reg} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
#
#
#
#
# # ############# ANNUAL TOPIC AGGREGATES ##############
# #
# #   dimension: annual_school_topic_courses {
# #     type: number
# #     description: "Measures aggregated at the institution level and broken out by course topic and academic year."
# #     label: "                                 Lifetime An Tp Courses" #32
# #     group_label: "    Course Aggregations"
# #   }
# #
# #   dimension: annual_school_topic_sections {
# #     type: number
# #     description: "Measures aggregated at the institution level and broken out by course topic and academic year."
# #     label: "                             Lifetime An Tp Sections" #29
# #     group_label: "    Course Aggregations"
# #   }
# #
# #   dimension: annual_school_topic_registrations  {
# #     type: number
# #     label: "                        Lifetime An Tp Registrations"  #24
# #     description: "Measures aggregated at the institution level and broken out by course topic and academic year."
# #     group_label: "  Registration Aggregations"
# #   }
# #
# #
# #   measure: avg_annual_school_topic_courses {
# #     type: average_distinct
# #     label: "   Average An Courses by Topic"
# #     group_label: " Annual Topic Averages"
# #     sql: ${annual_school_topic_courses} ;;
# #     sql_distinct_key: ${fk3_topic_key} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #   measure: avg_annual_school_topic_sections {
# #     type: average_distinct
# #     label: "  Average An Topic Sections"
# #     group_label: " Annual Topic Averages"
# #     sql: ${annual_school_topic_sections} ;;
# #     sql_distinct_key: ${fk3_topic_key} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #   measure: avg_annual_school_topic_registrations {
# #     type: average_distinct
# #     label: " Average An Topic Registrations"
# #     group_label: " Annual Topic Averages"
# #     sql: ${annual_school_topic_registrations} ;;
# #     sql_distinct_key: ${fk3_topic_key} ;;
# #     value_format_name: decimal_1
# #     hidden: yes
# #   }
# #
# #
# #
# # measure: count {
# #   label: "# Distinct Schools"
# #     type: count_distinct
# #     sql: ${dim_school_id} ;;
# #   }
# #
# #   measure: number_topics {
# #     type: count_distinct
# #     sql: ${topic} ;;
# #   }
# #
# #   measure: number_academic_years{
# #     type: count_distinct
# #     sql: ${special_ay_year} ;;
# #   }
# #
# #   measure: lifetime_registrations {
# #     type: sum
# #     label: "# Lifetime Registrations"
# #     sql: ${TABLE}.registrations ;;
# #   }
#
# #   measure: average_lifetime_registrations {
# #     type:
# #     label: "Average Registrations"
# #     sql: ${TABLE}.annual_school_topic_registrations ;;
# # #    sql_distinct_key: ${fk3_topic_key} ;;
# #     value_format_name: decimal_1
# #  }
#
#
# ############################################################################
# ########################### HIDDEN FIELDS ##################################
# ############################################################################
#


 }
