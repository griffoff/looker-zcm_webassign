

include: "/webassign/*.model.lkml"
include: "fact_registration_zcm.view.lkml"
include: "/webassign/dim_discipline.view.lkml"
include: "_redesign_multiview_fields.view.lkml"


view: _zcm_cg_registrations {
#  extends: [fact_registration_zcm]
view_label: "   Core Gateway Registrations"
  derived_table: {
    sql:
    SELECT
            DISTINCT  s.dim_school_id as dim_school_id
          , s.school_id as school_id
          , time.special_ay_year as special_ay_year
          , time.ay_value as ay_value
          , d.dim_discipline_id as dim_discipline_id
          , d.sub_discipline_name as sub_discipline_name
          , coalesce(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id),0) as lifetime_cg_reg
          , coalesce(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_cg_reg
          , coalesce(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, d.dim_discipline_id),0) as annual_topic_cg_reg
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
      AND (time.ay_value >= -{% parameter date_range_ay %} )
      AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
      AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX')))
      AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN ('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS')))
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

  dimension: dim_school_id {hidden: yes}
  dimension: ay_value {hidden: yes}
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

  parameter: date_range_ay {
    label: "Select Targeted Academic Years"
    description: "Select how many Academic Years back you want included in the query (Not including the current academic year). Ex: selecting '3' would include the current ongoing academic year plus the prior 3"
    default_value: "3"
    view_label: "           Parameters & Filters"
  }

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




dimension: school_id {label: "         School ID" }
dimension: special_ay_year {label: "        Academic Year"}
dimension: sub_discipline_name {label: "       Sub-Discipline Name"}


###############################################
######### PRE-AGGREGATED DIMENSIONS ###########
###############################################


############## LIFETIME AGGREGATES ##################

  dimension: lifetime_course_count {
    type: number
    label: "   Lifetime Courses"
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
    group_label: "    Lifetime Aggregations"
  }
  dimension: lifetime_section_count {
    type: number
    label: "   Lifetime Sections"
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
    group_label: "    Lifetime Aggregations"
  }
  dimension: lifetime_topic_count {
    type: number
    label: "  Lifetime Topics Taught"
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
    group_label: "    Lifetime Aggregations"
  }
  dimension: lifetime_cg_reg {
    type: number
    label: "Lifetime Registrations"
    description: "Rolled up measures aggregated at the institution level for the 3 Core Gateway (CG) Courses for TARGETED Academic Years (can be set with the 'Select Targeted Academic Years' parameter. default = 3)"
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
  measure: avg_lifetime_cg_reg {
    type: average
    label: " Average Lifetime Registrations"
    group_label: "    Lifetime Averages"
    sql: ${lifetime_cg_reg} ;;
    value_format_name: decimal_1
  }


############## ANNUAL AGGREGATES ####################

  dimension: annual_course_count {
    type: number
    label: "    Annual Courses"
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "  Annual Aggregations"
  }
  dimension: annual_section_count {
    type: number
    label: "   Annual Sections"
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "  Annual Aggregations"
  }
  dimension: annual_topic_count {
    type: number
    label: "  Annual Topics Taught"
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "  Annual Aggregations"
    drill_fields: [topic_drill*]
  }
  dimension: annual_cg_reg  {
    type: number
    label: " Annual Registrations"
    description: "Measures aggregated at the institution level and broken out by academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: "  Annual Aggregations"
    sql: zeroifnull(${TABLE}.annual_cg_reg) ;;
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
  measure: avg_annual_cg_reg {
    type: average
    label: " Average Annual Registrations"
    group_label: "   Annual Averages"
    sql: ${annual_cg_reg} ;;
    value_format_name: decimal_1
  }


############# ANNUAL TOPIC AGGREGATES ##############

  dimension: annual_topic_course_count {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    label: "   Annual Topic Courses"
    group_label: " Annual Topic Aggregations"
  }
  dimension: annual_topic_section_count {
    type: number
    description: "Measures aggregated at the institution level and broken out by course topic and academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    label: "  Annual Topic Sections"
    group_label: " Annual Topic Aggregations"
  }
  dimension: annual_topic_cg_reg  {
    type: number
    label: " Annual Topic Registrations"
    description: "Measures aggregated at the institution level and broken out by course topic and academic year for the 3 Core Gateway (CG) Courses and the Targeted Academic Years"
    group_label: " Annual Topic Aggregations"
  }






  measure: avg_annual_topic_course_count {
    type: average
    label: "   Average Annual Courses by Topic"
    group_label: " Annual Topic Averages"
    sql: ${annual_topic_course_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_annual_topic_section_count {
    type: average
    label: "  Average Annual Topic Sections"
    group_label: " Annual Topic Averages"
    sql: ${annual_topic_section_count} ;;
    value_format_name: decimal_1
  }
  measure: avg_annual_topic_cg_reg {
    type: average
    label: " Average Annual Topic Registrations"
    group_label: " Annual Topic Averages"
    sql: ${annual_topic_cg_reg} ;;
    value_format_name: decimal_1
  }


############################################################################
########################## OTHER FIELDS ####################################
############################################################################

  measure: core_gateway_registrations {
    label: "# Registrations"
    type: sum_distinct
    sql: ${TABLE}.annual_topic_cg_reg ;;
    sql_distinct_key: ${pk} ;;
  }

  measure: core_gateway_courses {
    label: "# Courses"
    type: sum_distinct
    sql: ${TABLE}.annual_topic_course_count ;;
    sql_distinct_key: ${pk} ;;
  }

  measure: core_gateway_sections {
    label: "# Sections"
    type: sum_distinct
    sql: ${TABLE}.annual_topic_section_count ;;
    sql_distinct_key: ${pk} ;;
    drill_fields: [dim_section.dim_section_id]
#   drill_fields: [section_drill*]
  }

  measure: num_ay_over_threshold_s       {
    type: number
    label: "# AYs Over Threshold"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. Number of AY's (2015-present) where registrations for Core Gateway Courses were greater than the Annual Combined Enrollment threshold (default = 1,000 registrations)"
    sql: count(DISTINCT CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${special_ay_year} ELSE NULL END) ;;
    }

  measure: most_recent_ay_over_threshold {
    type: string
    label: "Recent AY Over Threshold"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. Most recent AY where combined annual registrations for core gateway courses were greater than threshold (default = 1,000)"
    sql: max(CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${special_ay_year} ELSE NULL END) ;;
    hidden: no
    }

  measure: most_recent_ay_over_threshold_value {
    type: number
    label: "Recent AY Over Threshold (Value)"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. Most recent AY where combined annual registrations for core gateway courses were greater than threshold (default = 1,000)"
    sql: max(CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${ay_value} ELSE NULL END) ;;
    hidden: yes
  }

  measure: first_ay_over_threshold       {
    type: string
    label: "First AY Over Threshold"
    #     view_label: " School & Academic Year Aggregations"
    group_label: "Core Gateway Courses"
    description: "School/AY Level. First AY where combined annual registrations for core gateway courses were greater than threshold (default = 1,000)"
    sql: min(CASE WHEN ${meets_accgr_threshold} = 'Yes' THEN ${special_ay_year} ELSE NULL END)  ;;
    hidden: no
    }

  measure: first_ay_over_threshold_value       {
    type: number
    label: "First AY Over Threshold (Value)"
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
    sql_distinct_key: ${pk} ;;
    sql: ${annual_cg_reg} ;;
  }

#############################################################################################################################################
########################                           OTHER AGGREGATES                                ##########################################
#############################################################################################################################################








measure: num_schools {
  type: count_distinct
  sql: ${dim_school_id} ;;
}

measure: cg_pk_count {
  type: count
}


  set: topic_drill {
    fields: [dim_school.name, sub_discipline_name,  special_ay_year, dim_section_zcm.course_count, dim_section.section_count, fact_registration.user_registrations]
  }
  set: section_drill {
    fields: [dim_school.name, sub_discipline_name, special_ay_year, dim_section.course_id, dim_section.course_name, dim_section.course_instructor_name, dim_section.dim_section_id, dim_section.section_instructor_name, dim_section.roster]
}
}