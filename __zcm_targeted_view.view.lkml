include: "__zcm_coregateway_view.view.lkml"

##################################################################################################################################################################
############### THIS VIEW IS AT THE SCHOOL-AY-TOPIC LEVEL. IT IS THE BROADEST VIEW OF TargetedUSAGE AT THE SCHOOL, ACADEMIC YEAR, & TOPIC     ###################
############### LEVELS AND IS INTENDED AS A BASE TABLE FOR THE MODEL. THE VALUES FROM THIS TABLE ALLOW US TO LOOK AT TargetedUSAGE, ONE SMALL ###################
############### PART IN ASSESSING PERSONAS. SUBSEQUENT TABLES JOINED TO THIS ONE WILL BE USED FOR THE PRIMARY FOR ANALYSIS. 'TargetedUSAGE'   ###################
############### IS DEFINED BY DEFAULT TO ALL ACADEMIC YEARS WITH DATA. THERE IS AN OPTIONAL PARAMETER ALLOWING THE USER TO REDEFINE THIS TIME  ###################
############### FRAME INDEPENDENTLY OF THE "FOCUSED" RANGE WHICH IS USED FOR THE MAJORITY OF THE METRICS FOR FLAGGING PERSONAL. ALL DIMENSIONS ###################
############### (EXCEPT ANY NEW ONES DERIVED HERE) WILL BE HIDDEN FROM VIEW AS THEY ARE INTENDED SOLEY FOR.                                    ###################
##################################################################################################################################################################

view: __zcm_targeted_view {
    derived_table: {
      sql:
wITH targeted_base as (
SELECT
              DISTINCT FACT_REGISTRATION_ID
            , DIM_TIME_ID
            , DIM_SECTION_ID
            , SSO_GUID
            , SCHOOL_ID
            , SECTION_ID
            , DIM_TEXTBOOK_ID
            , COURSE_ID
            , REGISTRATIONS
            , COUNT
            , COURSE_INSTRUCTOR_ID
            , DIM_SCHOOL_ID
            , USER_ID
            , SECTION_INSTRUCTOR_ID
            , USERNAME
            , special_ay_year as special_ay_year
            , ay_value as ay_value
            , dim_discipline_id as dim_discipline_id
            , sub_discipline_name as sub_discipline_name
            , topic
            , crs_instructor_name as crs_instructor_name
FROM ${__zcm_lifetime_view.SQL_TABLE_NAME}
WHERE (ay_value >= -{% parameter __zcm_targeted_view.date_range_ay %})
)
SELECT
              *
            , COALESCE(sum(REGISTRATIONS) OVER (PARTITION BY dim_school_id),0) as school_registrations
            , COALESCE(SUM(REGISTRATIONS) OVER (PARTITION BY dim_section_id),0) as section_registrations
            , COUNT(DISTINCT course_id) OVER (PARTITION BY dim_school_id) as school_courses
            , COUNT(DISTINCT dim_section_id) OVER (PARTITION BY dim_school_id) as school_sections
            , COUNT(DISTINCT topic) OVER (PARTITION BY dim_school_id) as school_topics
            , COUNT(DISTINCT special_ay_year) OVER (PARTITION BY dim_school_id) as school_ays
            , COUNT(DISTINCT course_id) OVER (PARTITION BY course_instructor_id) as crs_instructor_courses
            , COUNT(DISTINCT dim_section_id) OVER (PARTITION BY course_instructor_id) as crs_instructor_sections
            , COUNT(DISTINCT special_ay_year) OVER (PARTITION BY course_instructor_id) as crs_instructor_ays
            , COUNT(DISTINCT topic) OVER (PARTITION BY course_instructor_id) as crs_instructor_topics
            , COUNT(DISTINCT section_instructor_id) OVER (PARTITION BY course_instructor_id) as crs_instructor_sect_instructors
            , COALESCE(sum(REGISTRATIONS) OVER (PARTITION BY course_instructor_id),0) as crs_instructor_registrations
FROM targeted_base
;;
    }


###############################################
########## FIELDS IN VIEW IN EXPLORE ##########
###############################################

  dimension: dim_school_id {
    label: "              Dim School ID"
    hidden: no
#     group_label: "           Targeted Dimensions"
    view_label: "     Targeted View"
  }

  dimension: special_ay_year  {
    label: "            Academic Year"
    hidden: no
#    group_label: "           Targeted Dimensions"
    view_label: "     Targeted View"
  }


  dimension: topic {
    label: "         Course Topic"
    description: "Similar to Sub-Discipline, but extracts and groups courses using Algebra and Trig products out of Dev Math and into their own topic category"
#    group_label: "           Targeted Dimensions"
    view_label: "     Targeted View"
  }

  dimension: course_instructor_id {
    label: "     Course Instructor ID"
    #   group_label: "           Targeted Dimensions"
    view_label: "     Targeted View"
    drill_fields: [_zcm_topic_filter.topic, course_id, _zcm_topic_filter.topic_group, dim_section.course_instructor_name, dim_section.course_instructor_email
      ,  section_id, dim_section.section_instructor_name, dim_section.section_instructor_email, dim_time.special_ay_year]
  }


  dimension: crs_instructor_name {
    label: "     Course Instructor Name"
#    group_label: "           Targeted Dimensions"
    view_label: "     Targeted View"
    drill_fields: [_zcm_topic_filter.topic, course_id, _zcm_topic_filter.topic_group, dim_section.course_instructor_name, dim_section.course_instructor_email
      ,  section_id, dim_section.section_instructor_name, dim_section.section_instructor_email, dim_time.special_ay_year]
  }


  dimension: fact_registration_id   {hidden: yes sql: ${TABLE}.FACT_REGISTRATION_ID;; primary_key: no}
  dimension: dim_time_id            {hidden: yes sql: ${TABLE}.DIM_TIME_ID;;}
  dimension: dim_section_id         {hidden: yes sql: ${TABLE}.DIM_SECTION_ID;;}
  dimension: sso_guid               {hidden: yes sql: ${TABLE}.SSO_GUID;;}
  dimension: school_id              {hidden: yes sql: ${TABLE}.SCHOOL_ID            ;; view_label: "     Targeted View"}
  dimension: section_id             {hidden: yes sql: ${TABLE}.SECTION_ID           ;;}
  dimension: dim_textbook_id        {hidden: yes sql: ${TABLE}.DIM_TEXTBOOK_ID      ;;}
  dimension: course_id              {hidden: yes sql: ${TABLE}.COURSE_ID            ;;}
  dimension: registrations          {hidden: yes sql: ${TABLE}.REGISTRATIONS        ;;}
  dimension: count                  {hidden: yes sql: ${TABLE}.COUNT                ;;}
  dimension: user_id                {hidden: yes sql: ${TABLE}.USER_ID              ;;}
  dimension: section_instructor_id  {hidden: yes sql: ${TABLE}.SECTION_INSTRUCTOR_ID;;}
  dimension: username               {hidden: yes sql: ${TABLE}.USERNAME             ;;}



###############################################
######## KEYS AND IDENTIFIERS (HIDDEN) ########
###############################################

  dimension: pk1_fact_registration_id {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.fact_registration_id ;;
  }

  dimension: fk2_ay_key {
    description: "Key for institution/academic year level"
    hidden: yes
    primary_key: no
    sql: nullif(hash(${dim_school_id},'|',${special_ay_year}),0) ;;
  }

  dimension: fk3_topic_key {
    description: "Key for Institution/academic year/course sub-discipline level"
    hidden: yes
    primary_key: no
    sql: nullif(hash(${dim_school_id},'|',${special_ay_year},'|',${topic}),0) ;;
  }

  dimension: fk2_instructor_school_key {
    description: "Key for Institution/Instructor to join with instructor ranking table"
    hidden: yes
    primary_key: no
    sql: nullif(hash(${course_instructor_id},'|',${dim_school_id}),0) ;;
  }

  dimension: fk3_course_section_ay_key {
    hidden: yes
    sql: nullif(hash(${dim_section_id},'|',${course_instructor_id},'|',${special_ay_year}),0) ;;
  }

    dimension: ay_value  {
      label: "Academic Year Relative Value"
      description: "Assigns a numeric value to the academic year with 0 as the current ongoing year, -1 as the prior (complete) year, -2 as two years ago. Used in calculations and code as a relative reference that changes as time passes "
      hidden: yes
    }
#     dimension: dim_school_id {
#       hidden: yes
#       group_label: "School"
#     }
    dimension: dim_discipline_id  {
      hidden: yes
      group_label: "Discipline"
    }

  parameter: date_range_ay {
    label: "Targeted Academic Year Range"
    description: "Select how many Academic Years back you want included in the query (Not including the current academic year). Ex: selecting '3' would include the current ongoing academic year plus the prior 3
                  Note, this impacts the targeted redesign aggregates as well as the Core Gateway aggregates. The Core Gateway Threshold Range parameter is strictly for assessing which schools are included in the
                  query. Aggregations for CG and Targeted tables should share the same time period for comparison if larger than the threshold parameter."
    default_value: "3"
    view_label: "           Parameters & Filters"
  }


###############################################
########### ENTITY COUNTS #####################
###############################################
  measure: school_count {
    label: "                # Schools"
    view_label: "     Targeted View"
    type: count_distinct
    sql: ${dim_school_id} ;;
  }
  measure: course_id_count {
    label: "          # Courses"
    view_label: "     Targeted View"
    type: count_distinct
    sql: ${course_id} ;;
  }

  measure: dim_section_id_count {
    label: "         # Sections"
    view_label: "     Targeted View"
    type: count_distinct
    sql: ${dim_section_id} ;;
  }
  measure: ay_count {
    label: "      # Academic Years"
    view_label: "     Targeted View"
    type: count_distinct
    sql: ${ay_value} ;;
  }
  measure: topic_count {
    label: "       # Course Topics"
    view_label: "     Targeted View"
    type: count_distinct
    sql: ${topic} ;;
  }
  measure: course_instructor_count {
    label: "    # Course Instructors"
    view_label: "     Targeted View"
    type: count_distinct
    sql: ${course_instructor_id} ;;
  }
  measure: section_instructor_count {
    label: " # Section Instructors"
    view_label: "     Targeted View"
    type: count_distinct
    sql: ${section_instructor_id} ;;
  }




###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


#################################### SCHOOL LEVEL AGGREGATES ##########################################

  dimension: school_courses {
    type: number
    label: "                                  # School Courses"  #34
    description: "Rolled up measures aggregated at the institution level for all potential redesign course topics targeting more recent academic years (can be tweaked with the 'Select Targeted Academic Years' parameter)"
    group_label: "     Pre-Aggregated Dimensions - School"
    view_label: "     Targeted View"
    drill_fields: [school_id, course_id]
  }

  dimension: school_sections {
    type: number
    label: "                                 # School Sections" #31
    description: "Rolled up measures aggregated at the institution level for all potential redesign course topics targeting more recent academic years (can be tweaked with the 'Select Targeted Academic Years' parameter)"
    group_label: "     Pre-Aggregated Dimensions - School"
    view_label: "     Targeted View"
    drill_fields: [dim_school_id, dim_school.name, dim_section_id, dim_time_id, dim_time.timedate ]
  }

  dimension: school_topics {
    type: number
    label: "                            # School Course Topics"  #28
    description: "Rolled up measures aggregated at the institution level for all potential redesign course topics targeting more recent academic years (can be tweaked with the 'Select Targeted Academic Years' parameter)"
    group_label: "     Pre-Aggregated Dimensions - School"
    view_label: "     Targeted View"
  }

  dimension: school_registrations  {
    type: number
    label: "                          # School Registrations"  #26
    description: "Rolled up measures aggregated at the institution level for all potential redesign course topics targeting more recent academic years (can be tweaked with the 'Select Targeted Academic Years' parameter)"
    group_label: "     Pre-Aggregated Dimensions - School"
    view_label: "     Targeted View"
  }

  dimension: school_ays             {
    type: number
    label: "                          # School Academic Years"  #26
    description: "Rolled up measures aggregated at the institution level for all potential redesign course topics targeting more recent academic years (can be tweaked with the 'Select Targeted Academic Years' parameter)"
    group_label: "     Pre-Aggregated Dimensions - School"
    view_label: "     Targeted View"
  }




#################################### COURSE INSTRUCTOR LEVEL AGGREGATES ##########################################

  dimension: crs_instructor_courses         {
    type: number
    label: "          # Instructor Courses"
    group_label: "    Pre-Aggregated Dimensions - Instructor"
    view_label: "     Targeted View"
  }

  dimension: crs_instructor_sections         {
    type: number
    label: "       # Instructor Sections"
    group_label: "    Pre-Aggregated Dimensions - Instructor"
    view_label: "     Targeted View"
  }

  dimension: crs_instructor_ays              {
    type: number
    label: "     # Instructor Academic Yrs"
    group_label: "    Pre-Aggregated Dimensions - Instructor"
    view_label: "     Targeted View"
  }

  dimension: crs_instructor_topics           {
    type: number
    label: "      # Instructor Course Topics"
    group_label: "    Pre-Aggregated Dimensions - Instructor"
    view_label: "     Targeted View"
  }

  dimension: crs_instructor_registrations {
    type: number
    label: "     # Instructor Registrations"
    group_label: "    Pre-Aggregated Dimensions - Instructor"
    view_label: "     Targeted View"
  }

  dimension: crs_instructor_sect_instructors {
    type: number
    label: "# Section Instructors Managed"
    description: "The number of distinct section instructors teaching in a course instructor's courses"
    group_label: "    Pre-Aggregated Dimensions - Instructor"
    view_label: "     Targeted View"
  }


############################# END PRE-AGGREGATED DIMENSIONS #####################################


# ###############################################
# ########### ENTITY COUNTS #####################
# ###############################################
#
#   measure: course_instructor_count {
#     label: "# Course Instructors"
#     type: count_distinct
#     sql: ${course_instructor_id} ;;
#   }
#
#   measure: section_instructor_count {
#     label: "# Section Instructors"
#     type: count_distinct
#     sql: ${section_instructor_id} ;;
#   }
#
#   measure: course_id_count {
#     label: "# Courses"
#     type: count_distinct
#     sql: ${course_id} ;;
#   }
#
#   measure: dim_section_id_count {
#     label: "# Sections"
#     type: count_distinct
#     sql: ${dim_section_id} ;;
#   }
#
#   measure: school_count {
#     type: count_distinct
#     sql: ${dim_school_id} ;;
#   }

###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


############## TargetedAGGREGATES ##################

#     dimension: school_courses {
#       type: number
#       label: "                       Targeted Courses"  #23
#       description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "    Course Aggregations"
#     }
#
#     dimension: school_sections {
#       type: number
#       label: "                    Targeted Sections" #20
#       description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "    Course Aggregations"
#       sql: zeroifnull(${TABLE}.school_sections) ;;
#     }
#
#     dimension: school_topics {
#       type: number
#       label: "                 Targeted Topics" #17
#       description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "   Topic Aggregations"
#     }
#
#     dimension: school_registrations  {
#       type: number
#       label: "               Targeted Registrations" #15
#       description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "  Registration Aggregations"
#     }
#
#
#
#   dimension: tar_crs_instructor_courses          {type: number group_label: "   Instructor Aggregates" label: "Crs Inst - # Courses"        sql: zeroifnull(${TABLE}.tar_crs_instructor_courses)  ;;   }
#   dimension: tar_crs_instructor_sections         {type: number group_label: "   Instructor Aggregates" label: "Crs Inst - # Sections"       sql: zeroifnull(${TABLE}.tar_crs_instructor_sections)  ;;   }
#   dimension: tar_crs_instructor_ays              {type: number group_label: "   Instructor Aggregates" label: "Crs Inst - # AYs"            sql: zeroifnull(${TABLE}.tar_crs_instructor_ays)  ;;   }
#   dimension: tar_crs_instructor_topics           {type: number group_label: "   Instructor Aggregates" label: "Crs Inst - # Topics Taught"  sql: zeroifnull(${TABLE}.tar_crs_instructor_topics)  ;;   }
#   dimension: tar_crs_instructor_registrations    {type: number group_label: "   Instructor Aggregates" label: "Crs Inst - # Registrations"  sql: zeroifnull(${TABLE}.tar_crs_instructor_registrations)  ;;   }
#   dimension: tar_crs_instructor_sect_instructors {type: number group_label: "   Instructor Aggregates" label: "Crs Inst - # Sec Inst"       sql: zeroifnull(${TABLE}.tar_crs_instructor_sect_instructors)  ;;
#     description: "The number of distinct section instructors teaching in a course instructor's courses"}
#   dimension: annual_tar_crs_instructor_registrations {type: number group_label: "   Instructor Aggregates" label: "Annual Crs Inst - # Sec Inst"       sql: zeroifnull(${TABLE}.annual_tar_crs_instructor_registrations)  ;;
#     description: "Hide me, to be used only for instructor filter"}
#
#     measure: avg_school_courses {
#       type: average
#       label: "    Average TargetedCourses"
#       group_label: "    TargetedAverages"
#       sql: ${school_courses} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#     measure: avg_school_sections {
#       type: average
#       label: "   Average TargetedSections"
#       group_label: "    TargetedAverages"
#       sql: ${school_sections} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#     measure: avg_school_topics {
#       type: average
#       label: "  Average TargetedTopics Taught"
#       group_label: "    TargetedAverages"
#       sql: ${school_topics} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#     measure: avg_school_registrations {
#       type: average
#       label: " Average TargetedRegistrations"
#       group_label: "    TargetedAverages"
#       sql: ${school_registrations} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
# ############## ANNUAL AGGREGATES ####################
#
#     dimension: annual_school_courses {
#       type: number
#       label: "                      Targeted An Courses" #22
#       description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "    Course Aggregations"
#     }
#     dimension: annual_school_sections {
#       type: number
#       label: "                   Targeted An Sections" #19
#       description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "    Course Aggregations"
#     }
#     dimension: annual_school_topics {
#       type: number
#       label: "                Targeted An Topics"  #16
#       description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "   Topic Aggregations"
#       drill_fields: [topic_drill*]
#     }
#     dimension: annual_redesign_reg  {
#       type: number
#       label: "              Targeted An Registrations" #14
#       description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
#       group_label: "  Registration Aggregations"
#     }
#
#
#     measure: avg_annual_school_courses {
#       type: average
#       label: "    Average Annual Courses"
#       group_label: "   Annual Averages"
#       sql: ${annual_school_courses} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#     measure: avg_annual_school_sections {
#       type: average
#       label: "   Average Annual Sections"
#       group_label: "   Annual Averages"
#       sql: ${annual_school_sections} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#     measure: avg_annual_school_topics {
#       type: average_distinct
#       label: "  Average Annual Topics Taught"
#       group_label: "   Annual Averages"
#       sql_distinct_key: ${dim_school_id}||${special_ay_year} ;;
#       sql: ${annual_school_topics} ;;
#       value_format_name: decimal_1
#       drill_fields: [topic_drill*]
#       hidden: yes
#     }
#
#     measure: avg_annual_redesign_reg {
#       type: average
#       label: " Average Annual Registrations"
#       group_label: "   Annual Averages"
#       sql: ${annual_redesign_reg} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#
#
#
# ############# ANNUAL TOPIC AGGREGATES ##############
#
#     dimension: annual_school_topic_courses {
#       type: number
#       description: "Measures aggregated at the institution level and broken out by course topic and academic year."
#       label: "                     Targeted An Tp Courses" #21
#       group_label: "    Course Aggregations"
#     }
#     dimension: annual_school_topic_sections {
#       type: number
#       description: "Measures aggregated at the institution level and broken out by course topic and academic year."
#       label: "                  Targeted An Tp Sections" #18
#       group_label: "    Course Aggregations"
#     }
#     dimension: annual_school_topic_registrations  {
#       type: number
#       label: "             Targeted An Tp Registrations" #13
#       description: "Measures aggregated at the institution level and broken out by course topic and academic year."
#       group_label: "  Registration Aggregations"
#     }
#
#
#     measure: avg_annual_school_topic_courses {
#       type: average
#       label: "   Average Annual Courses by Topic"
#       group_label: " Annual Topic Averages"
#       sql: ${annual_school_topic_courses} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#     measure: avg_annual_school_topic_sections {
#       type: average
#       label: "  Average Annual Topic Sections"
#       group_label: " Annual Topic Averages"
#       sql: ${annual_school_topic_sections} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#     measure: avg_annual_school_topic_registrations {
#       type: average
#       label: " Average Annual Topic Registrations"
#       group_label: " Annual Topic Averages"
#       sql: ${annual_school_topic_registrations} ;;
#       value_format_name: decimal_1
#       hidden: yes
#     }
#
#
#
#
#
#
#
#
#
#   dimension:tar_registrations_sum {
#     type: number
#     sql: zeroifnull(${TABLE}.tar_registrations_sum) ;;
#   }
#
#
#
#
#
# #############################################################################################################################################
# ########################                           Count Sums                                      ##########################################
# #############################################################################################################################################
#
#
#   measure: num_tar_ays  {
#     label: "# Targeted Academic Yrs."
#     type: count_distinct
#     sql: ${TABLE}.special_ay_year ;;
#     drill_fields: [institution_drill*,special_ay_year, num_tar_registrations, num_tar_sections]
#     link: {label: "# Sections & Registrations by AY" url: "{{link}}&pivots=__zcm_targeted_view.special_ay_year"}
#   }
#
#   measure: num_tar_topics  {
#     label: "# Targeted Topics  Taught"
#     type: count_distinct
#     sql: ${TABLE}.topic ;;
#     drill_fields: [institution_drill*, topic, num_tar_registrations, num_tar_sections]
#     link: {label: "# Sections & Registrations by AY" url: "{{link}}&pivots=__zcm_targeted_view.topic"}
#   }
#
#   measure: num_tar_courses  {
#     label: "# Targeted Courses"
#     type: count_distinct
#     sql: ${TABLE}.course_id ;;
#     drill_fields: [institution_drill*, course_id, special_ay_year, dim_section_id, num_tar_registrations]
#     link: {label: "Sections" url: "{{link}}"}
#   }
#
#   measure: num_tar_crs_instructors  {
#     label: "# Targeted Course Instructors"
#     type: count_distinct
#     sql: ${TABLE}.course_instructor_id ;;
#     drill_fields: [institution_drill*, course_id, dim_section.course_name, dim_section.course_instructor_name, num_tar_registrations]
#   }
#
#   measure: num_tar_sections  {
#     label: "# Targeted Sections"
#     type: count_distinct
#     sql: ${TABLE}.dim_section_id ;;
#     drill_fields: [institution_drill*, dim_section_id, dim_section.course_instructor_name, dim_section.section_instructor_name, num_tar_registrations]
#   }
#
#   measure: num_tar_sect_instructors  {
#     label: "# Targeted Section Instructors"
#     type: count_distinct
#     sql: ${TABLE}.section_instructor_id ;;
#   }
#
#   measure: num_tar_registrations {
#     type: sum
#     label: "# Targeted Registrations"
#     sql: zeroifnull(${TABLE}.registrations) ;;
#   }
#
#
#
# ############################################################################
# ########################### HIDDEN FIELDS ##################################
# ############################################################################
#
#     dimension: ay_start_year {
#       hidden: yes
#       type: number
#       sql: left(${special_ay_year},4) ;;
#     }
#
#     dimension: ay_end_year {
#       hidden: yes
#       type: number
#       sql: right(${special_ay_year},4) ;;
#     }

  set: institution_drill {
    fields: [dim_school.dim_school_id, dim_school.cl_entity_number, dim_school.name, dim_school.state_abbr]
    }
  set: topic_drill {
    fields: [topic]
  }
  set: year_drill {
    fields: [special_ay_year]
  }
  set: section_drill {
    fields: [dim_school.name, topic, special_ay_year, dim_section.course_id, dim_section.course_name, dim_section.course_instructor_name, dim_section.dim_section_id, dim_section.section_instructor_name, dim_section.roster]
  }
  }
