#######################################################################################################################################################################################################
################################ NOTE DATE RANGES FOR CORE GATEWAY AND TARGETED REDESIGN COURSES ARE THE SAME. THE PARAMETER IS LOCATED IN THE TARGETED VIEW      #####################################
################################ THIS IS DIFFERENT FROM THE CORE_GATEWAY_THRESHOLD_RANGE PARAMETER IN _ZCM_SCHOOL_FILTER VIEW WHICH NEEDS TO BE MORE RESTRICTIVE  #####################################
#######################################################################################################################################################################################################

include: "/webassign/*.model.lkml"
include: "fact_registration_zcm.view.lkml"
include: "/webassign/dim_discipline.view.lkml"
include: "_redesign_multiview_fields.view.lkml"
include: "_zcm_targeted_registrations.view.lkml"



view: _zcm_cg_registrations {
view_label: "   Core Gateway Registrations"
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
            , r.registrations as registrations
            , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id),0) as lifetime_cg_reg
            , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_cg_reg
            , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, topic.topic),0) as annual_topic_cg_reg
            , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id),0) as school_courses
            , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_school_courses
            , COALESCE(COUNT(DISTINCT sec.course_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, topic.topic),0) as annual_school_topic_courses
            , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id),0) as school_sections
            , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_school_sections
            , COALESCE(COUNT(DISTINCT sec.dim_section_id) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, topic.topic),0) as annual_school_topic_sections
            , COALESCE(COUNT(DISTINCT topic.topic) OVER (PARTITION BY s.dim_school_id),0) as school_topics
            , COALESCE(COUNT(DISTINCT topic.topic) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_school_topics
            , COALESCE(COUNT(DISTINCT sec.course_instructor_id) OVER (PARTITION BY s.dim_school_id),0) AS course_instructors
            , COALESCE(SUM(r.REGISTRATIONS),0) AS cg_registrations_sum
--            , COUNT(DISTINCT time.special_ay_year) as num_cg_ays
--            , COUNT(DISTINCT topic.topic) as num_cg_topics
--            , COUNT(DISTINCT sec.course_id) as num_cg_courses
--            , COUNT(DISTINCT sec.course_instructor_id) as num_cg_crs_instructors
--            , COUNT(DISTINCT sec.dim_section_id) as num_cg_sections
--            , COUNT(DISTINCT sec.section_instructor_id) as num_cg_sect_instructors
    FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION  AS r
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL  AS s ON r.DIM_SCHOOL_ID = s.DIM_SCHOOL_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SECTION AS sec on r.DIM_SECTION_ID = sec.DIM_SECTION_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK  AS t ON r.DIM_TEXTBOOK_ID = t.DIM_TEXTBOOK_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE  AS d ON t.DIM_DISCIPLINE_ID = d.DIM_DISCIPLINE_ID
    INNER JOIN ${dim_time_zcm.SQL_TABLE_NAME} AS time ON r.DIM_TIME_ID = time.DIM_TIME_ID
    INNER JOIN ${_zcm_topic_filter.SQL_TABLE_NAME} as topic on r.fact_registration_id = topic.fact_registration_id
        WHERE ((UPPER(s.COUNTRY_NAME ) = UPPER('United States')))
        AND (time.ay_value >= -{% parameter _zcm_targeted_registrations.date_range_ay %} )
        AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
        AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX')))
        AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN ('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS')))
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
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

dimension: fk4_section_key {
  description: "Key for Institution/academic year/course sub-discipline level"
  hidden: yes
  primary_key: no
  sql: nullif(hash(${dim_school_id},'|',${special_ay_year},'|',${topic},'|',${dim_section_id}),0) ;;
}

dimension: dim_section_id {hidden: yes}
dimension: course_instructor_id { hidden: yes}
dimension: dim_school_id {hidden: yes}



  dimension: dim_discipline_id  { hidden: yes}

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



###############################################
########## FIELDS IN VIEW IN EXPLORE ##########
###############################################



  parameter: accgr_threshold {
    label: "Set the ACCGR Threshold"
    description: "Set the Annual Combined Core Gateway Course Registration Threshold. This is the enrollments threshold to include institutions and is the sum of Registrations for Core Gateway Courses (Liberal Arts Math, College Algebra, and Intro Stats) for an academic year. The default is >= 1,000 registrations in an academic year"
    default_value: "1000"
    type: number
    view_label: "           Parameters & Filters"
  }

          dimension: meets_accgr_threshold {
            label: "> ACCGR Threshold?"
            description: "Indicates whether or not a school met the Annual Combined Core Gateway Registration (AC-CGR) threshold for a given academic year."
            type: yesno
            view_label: "           Parameters & Filters"
            sql:
                           zeroifnull(${TABLE}.annual_cg_reg) >= {% parameter accgr_threshold %};;
            hidden: yes
          }




dimension: school_id {
  label: "         School ID"
  group_label: "        Core Gateway Dimensions"
  }

dimension: special_ay_year {
  label: "        Academic Year"
  group_label: "        Core Gateway Dimensions"
  }

dimension: ay_value {
    type: number
    hidden: no
    group_label: "        Core Gateway Dimensions"
  }

dimension: sub_discipline_name {
  label: "       Sub-Discipline Name"
  group_label: "        Core Gateway Dimensions"
  hidden: no
  }

dimension: topic {
  label: "       Course Topic"
  description: "Similar to Sub-Discipline, but extracts and groups courses using Algebra and Trig products out of Dev Math and into their own topic category"
  group_label: "        Core Gateway Dimensions"
  }


###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


############## LIFETIME AGGREGATES ##################

  dimension: school_courses {
    type: number
    label: "            C. Gateway Courses" #12
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
    group_label: "    Course Aggregations"
    hidden: no
  }

  dimension: school_sections {
    type: number
    label: "         C. Gateway Sections" #9
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
    group_label: "    Course Aggregations"
    hidden: no
    sql: zeroifnull(${TABLE}.school_sections) ;;
  }

  dimension: school_topics {
    type: number
    label: "      C. Gateway Topics"  #6
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
    group_label: "   Topic Aggregations"
    hidden: no
  }

  dimension: lifetime_cg_reg {
    type: number
    label: "    C. Gateway Registrations" #4
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
    group_label: "  Registration Aggregations"
    hidden: no
  }


  measure: avg_school_courses {
    type: average
    label: "    Average C. Gateway Courses"
    group_label: "    Lifetime Averages"
    sql: ${school_courses} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_school_sections {
    type: average
    label: "   Average C. Gateway Sections"
    group_label: "    Lifetime Averages"
    sql: ${school_sections} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_school_topics {
    type: average
    label: "  Average C. Gateway Topics Taught"
    group_label: "    Lifetime Averages"
    sql: ${school_topics} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_lifetime_cg_reg {
    type: average
    label: " Average C. Gateway Registrations"
    group_label: "    Lifetime Averages"
    sql: ${lifetime_cg_reg} ;;
    value_format_name: decimal_1
    hidden: yes
  }


############## ANNUAL AGGREGATES ####################

  dimension: annual_school_courses {
    type: number
    label: "           C. Gateway An Courses" #11
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "    Course Aggregations"
  }
  dimension: annual_school_sections {
    type: number
    label: "        C. Gateway An Sections" #8
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "    Course Aggregations"
  }
  dimension: annual_school_topics {
    type: number
    label: "     C. Gateway An Topics" #5
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "   Topic Aggregations"
    drill_fields: [topic_drill*]
  }
  dimension: annual_cg_reg  {
    type: number
    label: "   C. Gateway An Registrations" #3
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "  Registration Aggregations"
    sql: zeroifnull(${TABLE}.annual_cg_reg) ;;
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
    type: average
    label: "  Average Annual Topics Taught"
    group_label: "   Annual Averages"
    sql: ${annual_school_topics} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_annual_cg_reg {
    type: average
    label: " Average Annual Registrations"
    group_label: "   Annual Averages"
    sql: ${annual_cg_reg} ;;
    value_format_name: decimal_1
    hidden: yes
  }


############# ANNUAL TOPIC AGGREGATES ##############

  dimension: annual_school_topic_courses {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    label: "          C. Gateway An Tp Courses" #10
    group_label: "    Course Aggregations"
  }
  dimension: annual_school_topic_sections {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    label: "       C. Gateway An Tp Sections" #7
    group_label: "    Course Aggregations"
  }
  dimension: annual_topic_cg_reg  {
    type: number
    label: "  C. Gateway An Tp Registrations" #2
    description: "Measures aggregated at the institution level and broken out by course topic and academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
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

  measure: avg_annual_topic_cg_reg {
    type: average
    label: " Average Annual Topic Registrations"
    group_label: " Annual Topic Averages"
    sql: ${annual_topic_cg_reg} ;;
    value_format_name: decimal_1
    hidden: yes
  }


############################################################################
########################## OTHER FIELDS ####################################
############################################################################



  measure: num_ay_over_threshold_s       {
    type: number
    label: "# AYs Over CG Threshold"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. Number of AY's (2015-present) where registrations for Core Gateway Courses were greater than the Annual Combined Enrollment threshold (default = 1,000 registrations)"
    sql: count(DISTINCT CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${special_ay_year} ELSE NULL END) ;;
    }

  measure: most_recent_ay_over_threshold {
    type: string
    label: "Recent AY Over CG Threshold"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. Most recent AY where combined annual registrations for core gateway courses were greater than threshold (default = 1,000)"
    sql: max(CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${special_ay_year} ELSE NULL END) ;;
    hidden: no
    }

  measure: most_recent_ay_over_threshold_value {
    type: number
    label: "Recent AY Over CG Threshold (Value)"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. Most recent AY where combined annual registrations for core gateway courses were greater than threshold (default = 1,000)"
    sql: max(CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${ay_value} ELSE NULL END) ;;
    hidden: yes
  }

  measure: first_ay_over_threshold       {
    type: string
    label: "First AY Over CG Threshold"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. First AY where combined annual registrations for core gateway courses were greater than threshold (default = 1,000)"
    sql: min(CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${special_ay_year} ELSE NULL END)  ;;
    hidden: no
    }

  measure: first_ay_over_threshold_value       {
    type: number
    label: "First AY Over CG Threshold (Value)"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. First AY where combined annual registrations for core gateway courses were greater than threshold (default = 1,000)"
    sql: min(CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${ay_value} ELSE NULL END)  ;;
    hidden: yes
  }


  measure: total_combined_cgr {
    type: sum_distinct
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    sql_distinct_key: ${fk3_topic_key} ;;
    sql: ${annual_cg_reg} ;;
  }




#############################################################################################################################################
########################                           Counts & Sums                                   ##########################################
#############################################################################################################################################



  measure: num_cg_ays  {
    #     group_label: "Count Sums"
    label: "# CG Academic Yrs."
    type: count_distinct
    sql: ${TABLE}.special_ay_year ;;
  }

  measure: num_cg_topics  {
    #     group_label: "Count Sums"
    label: "# CG Topics  Taught"
    type: count_distinct
    sql: ${TABLE}.topic ;;
  }

  measure: num_cg_courses  {
    #     group_label: "Count Sums"
    label: "# CG Courses"
    type: count_distinct
    sql: ${TABLE}.course_id ;;
  }

  measure: num_cg_crs_instructors  {
    #     group_label: "Count Sums"
    label: "# CG Course Instructors"
    type: count_distinct
    sql: ${TABLE}.course_instructor_id ;;
  }

  measure: num_cg_sections  {
    #     group_label: "Count Sums"
    label: "# CG Sections"
    type: count_distinct
    sql: ${TABLE}.dim_section_id ;;
  }

  measure: num_cg_sect_instructors  {
    #     group_label: "Count Sums"
    label: "# CG Section Instructors"
    type: count_distinct
    sql: ${TABLE}.section_instructor_id ;;
  }

  measure: num_cg_registrations {
    type: sum
    label: "# CG Registrations"
    sql: ${TABLE}.registrations ;;
  }



#############################################################################################################################################
########################                           OTHER AGGREGATES                                ##########################################
#############################################################################################################################################






  set: topic_drill {
    fields: [dim_school.name, sub_discipline_name,  special_ay_year, dim_section_zcm.course_count, dim_section.section_count, fact_registration.user_registrations]
  }
  set: section_drill {
    fields: [dim_school.name, sub_discipline_name, special_ay_year, dim_section.course_id, dim_section.course_name, dim_section.course_instructor_name, dim_section.dim_section_id, dim_section.section_instructor_name, dim_section.roster]
}
}
