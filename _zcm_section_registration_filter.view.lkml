view: _zcm_section_registration_filter {

  derived_table: {
    sql:
      SELECT
         DISTINCT r.dim_section_id
       , COALESCE(SUM(r.REGISTRATIONS),0) as section_regs
  FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION as  r
  GROUP BY 1
  HAVING section_regs >= {% parameter section_registration_threshold %}
  ;;
  }


  parameter: section_registration_threshold {
    type: number
    label: "Min # Section Registrations"
    description: "select the minimum number of registrations required in a section to include in query. Default >=  5"
    default_value: "5"
    view_label: "           Parameters & Filters"
  }

  dimension: dim_section_id {
    hidden: yes
    primary_key: yes
  }

  dimension: section_regs {
    type: number
    hidden: yes
  }

  }




# WITH sec as (
#   SELECT
#          DISTINCT r.dim_section_id
#        , COALESCE(SUM(r.REGISTRATIONS),0) as section_regs
#   FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION as  r
#   GROUP BY 1
# )
# , inst AS (
#  SELECT
#           DISTINCT r.course_instructor_id
#         , time.special_ay_year
#         , COALESCE(SUM(r.REGISTRATIONS),0) AS inst_ay_regs
#   FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION as  r
#   LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.dim_time as time on r.dim_time_id = time.dim_time_id
#   GROUP BY 1,2
# )
#   SELECT
#           DISTINCT r.dim_section_id
#         , r.course_instructor_id
#         , time.special_ay_year
#         , sec.section_regs
#         , inst.inst_ay_regs
#      FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.fact_registration AS r
#      INNER JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.dim_time as time on r.dim_time_id = time.dim_time_id
#      INNER JOIN sec ON r.dim_section_id = sec.dim_section_id
#      INNER JOIN inst ON r.COURSE_INSTRUCTOR_ID = inst.course_instructor_id AND time.special_ay_year = inst.special_ay_year
#        WHERE sec.section_regs >= {% parameter section_registration_threshold %}
#        AND inst.inst_ay_regs >= {% parameter section_registration_threshold %}
#
# dimension: pk3_course_section_ay_key {
#   primary_key: yes
#   hidden: yes
#   sql: nullif(hash(${dim_section_id},'|',${course_instructor_id},'|',${special_ay_year}),0) ;;
# }
