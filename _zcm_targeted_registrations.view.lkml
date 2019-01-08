include: "_zcm_cg_registrations.view.lkml"

##################################################################################################################################################################
############### THIS VIEW IS AT THE SCHOOL-AY-TOPIC LEVEL. IT IS THE BROADEST VIEW OF LIFETIME USAGE AT THE SCHOOL, ACADEMIC YEAR, & TOPIC     ###################
############### LEVELS AND IS INTENDED AS A BASE TABLE FOR THE MODEL. THE VALUES FROM THIS TABLE ALLOW US TO LOOK AT LIFETIME USAGE, ONE SMALL ###################
############### PART IN ASSESSING PERSONAS. SUBSEQUENT TABLES JOINED TO THIS ONE WILL BE USED FOR THE PRIMARY FOR ANALYSIS. 'LIFETIME USAGE'   ###################
############### IS DEFINED BY DEFAULT TO ALL ACADEMIC YEARS WITH DATA. THERE IS AN OPTIONAL PARAMETER ALLOWING THE USER TO REDEFINE THIS TIME  ###################
############### FRAME INDEPENDENTLY OF THE "FOCUSED" RANGE WHICH IS USED FOR THE MAJORITY OF THE METRICS FOR FLAGGING PERSONAL. ALL DIMENSIONS ###################
############### (EXCEPT ANY NEW ONES DERIVED HERE) WILL BE HIDDEN FROM VIEW AS THEY ARE INTENDED SOLEY FOR.                                    ###################
##################################################################################################################################################################

view: _zcm_targeted_registrations {
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
                , topic.topic as topic
                , sec.course_id as course_id
                , sec.course_instructor_id as course_instructor_id
                , sec.dim_section_id as dim_section_id
                , sec.section_instructor_id as section_instructor_id
                , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id),0) as school_registrations
                , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_redesign_reg
                , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, topic.topic),0) as annual_school_topic_registrations
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
          INNER JOIN ${_zcm_topic_filter.SQL_TABLE_NAME} as topic ON r.fact_registration_id = topic.fact_registration_id
            WHERE ((UPPER(s.COUNTRY_NAME ) = UPPER('United States')))
            AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
            AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX', 'OPENINTRO')))
            AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS', 'PRECALCULUS', 'FINITE MATH AND APPLIED CALCULUS'))
            OR ((UPPER(t.name) LIKE '%ALG%' OR UPPER(t.name) like '%TRIG%') AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%'))
            AND (time.ay_value >= -{% parameter _zcm_targeted_registrations.date_range_ay %})
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

  parameter: date_range_ay {
    label: "Select Targeted Academic Years"
    description: "Select how many Academic Years back you want included in the query (Not including the current academic year). Ex: selecting '3' would include the current ongoing academic year plus the prior 3
                  Note, this impacts the targeted redesign aggregates as well as the Core Gateway aggregates. The Core Gateway Threshold Range parameter is strictly for assessing which schools are included in the
                  query. Aggregations for CG and Targeted tables should share the same time period for comparison if larger than the threshold parameter."
    default_value: "3"
    view_label: "           Parameters & Filters"
  }

###############################################
########## FIELDS IN VIEW IN EXPLORE ##########
###############################################



    dimension: school_id {
      label: "          School ID"
      hidden: no
      group_label: "          Targeted Redesign Dimensions"
    }

    dimension: special_ay_year  {
      label: "        Academic Year"
      hidden: no
      group_label: "          Targeted Redesign Dimensions"
    }

    dimension: sub_discipline_name  {
      label: "     Sub-Discipline Name"
      group_label: "          Targeted Redesign Dimensions"
    }

    dimension: topic {
      label: "     Course Topic"
      description: "Similar to Sub-Discipline, but extracts and groups courses using Algebra and Trig products out of Dev Math and into their own topic category"
      group_label: "          Targeted Redesign Dimensions"
      }
  dimension: dim_section_id {hidden: yes}
  dimension: course_instructor_id {hidden: yes}
###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


############## LIFETIME AGGREGATES ##################

    dimension: school_courses {
      type: number
      label: "                       Targeted Courses"  #23
      description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
      group_label: "    Course Aggregations"
    }

    dimension: school_sections {
      type: number
      label: "                    Targeted Sections" #20
      description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
      group_label: "    Course Aggregations"
      sql: zeroifnull(${TABLE}.school_sections) ;;
    }

    dimension: school_topics {
      type: number
      label: "                 Targeted Topics" #17
      description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
      group_label: "   Topic Aggregations"
    }

    dimension: school_registrations  {
      type: number
      label: "               Targeted Registrations" #15
      description: "Rolled up measures aggregated at the institution level. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
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
      label: "                      Targeted An Courses" #22
      description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
      group_label: "    Course Aggregations"
    }
    dimension: annual_school_sections {
      type: number
      label: "                   Targeted An Sections" #19
      description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
      group_label: "    Course Aggregations"
    }
    dimension: annual_school_topics {
      type: number
      label: "                Targeted An Topics"  #16
      description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
      group_label: "   Topic Aggregations"
      drill_fields: [topic_drill*]
    }
    dimension: annual_redesign_reg  {
      type: number
      label: "              Targeted An Registrations" #14
      description: "Measures aggregated at the institution level and broken out by academic year. Includes TARGETED Academic Years (Default = 3 years but can be defined by the 'Select Targeted Academic Years Included' parameter) and all potential redesign sections (identified as teaching with texts that cover the defined redesign course topics)"
      group_label: "  Registration Aggregations"
    }


    measure: avg_annual_school_courses {
      type: average
      label: "    Average Annual Courses"
      group_label: "   Annual Averages"
      sql: ${annual_school_courses} ;;
      value_format_name: decimal_1
      hidden: yes
    }

    measure: avg_annual_school_sections {
      type: average
      label: "   Average Annual Sections"
      group_label: "   Annual Averages"
      sql: ${annual_school_sections} ;;
      value_format_name: decimal_1
      hidden: yes
    }

    measure: avg_annual_school_topics {
      type: average_distinct
      label: "  Average Annual Topics Taught"
      group_label: "   Annual Averages"
      sql_distinct_key: ${dim_school_id}||${special_ay_year} ;;
      sql: ${annual_school_topics} ;;
      value_format_name: decimal_1
      drill_fields: [topic_drill*]
      hidden: yes
    }

    measure: avg_annual_redesign_reg {
      type: average
      label: " Average Annual Registrations"
      group_label: "   Annual Averages"
      sql: ${annual_redesign_reg} ;;
      value_format_name: decimal_1
      hidden: yes
    }




############# ANNUAL TOPIC AGGREGATES ##############

    dimension: annual_school_topic_courses {
      type: number
      description: "Measures aggregated at the institution level and broken out by course topic and academic year."
      label: "                     Targeted An Tp Courses" #21
      group_label: "    Course Aggregations"
    }
    dimension: annual_school_topic_sections {
      type: number
      description: "Measures aggregated at the institution level and broken out by course topic and academic year."
      label: "                  Targeted An Tp Sections" #18
      group_label: "    Course Aggregations"
    }
    dimension: annual_school_topic_registrations  {
      type: number
      label: "             Targeted An Tp Registrations" #13
      description: "Measures aggregated at the institution level and broken out by course topic and academic year."
      group_label: "  Registration Aggregations"
    }


    measure: avg_annual_school_topic_courses {
      type: average
      label: "   Average Annual Courses by Topic"
      group_label: " Annual Topic Averages"
      sql: ${annual_school_topic_courses} ;;
      value_format_name: decimal_1
      hidden: yes
    }

    measure: avg_annual_school_topic_sections {
      type: average
      label: "  Average Annual Topic Sections"
      group_label: " Annual Topic Averages"
      sql: ${annual_school_topic_sections} ;;
      value_format_name: decimal_1
      hidden: yes
    }

    measure: avg_annual_school_topic_registrations {
      type: average
      label: " Average Annual Topic Registrations"
      group_label: " Annual Topic Averages"
      sql: ${annual_school_topic_registrations} ;;
      value_format_name: decimal_1
      hidden: yes
    }


############################ DOUBLE CHECK THESE MEASURES TO SEE IF THEY MAKE SENSE OR WORK CORRECTLY ##############################

    measure: school_count {
      label: "# Distinct Schools"
      type: count_distinct
      sql: ${dim_school_id} ;;
      hidden: yes
    }

    measure: targeted_registrations {
      label: "# Targeted Registrations"
      type: sum_distinct
      sql: ${TABLE}.annual_school_topic_registrations ;;
      sql_distinct_key: ${fk3_topic_key} ;;                       #### CHECK THIS
      hidden: no
    }

  measure: targeted_courses {
    label: "# Targeted Courses"
    type: count_distinct
    sql: ${TABLE}.course_id ;;
  }

  measure: targeted_sections {
    label: "# Targeted Sections"
    type: count_distinct
    sql: ${TABLE}.dim_section_id;;
    drill_fields: [dim_section_id]
#   drill_fields: [section_drill*]
  }



  measure: targeted_topics {
    label: "# Targeted Topics"
    type: count_distinct
    sql: ${TABLE}.topic ;;
    drill_fields: [topic]
  }


  measure: targeted_course_instructors {
    label: "# Targeted Crs Instructors"
    type: count_distinct
    sql: ${TABLE}.annual_school_topic_sections ;;
    drill_fields: [course_instructor_id]
  }



measure: targeted_pk_count {
  type: count
  filters:{
    field: pk1_fact_registration_id
    value: "NOT NULL"
  }
  hidden: yes
}


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

  set: topic_drill {
    fields: [dim_school.name, sub_discipline_name,  special_ay_year, dim_section_zcm.course_count, dim_section.section_count, fact_registration.user_registrations]
  }

  set: section_drill {
    fields: [dim_school.name, sub_discipline_name, special_ay_year, dim_section.course_id, dim_section.course_name, dim_section.course_instructor_name, dim_section.dim_section_id, dim_section.section_instructor_name, dim_section.roster]
  }
  }