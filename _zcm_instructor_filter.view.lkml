
#################### THIS VIEW IS NEEDED TO LIMIT THE INSTRUCTORS AVAILABLE IN ALL LEVELS TO ONLY THOSE THAT  HAVE REGISTRATIONS >= SECTION REGISTRATION THRESHOLD FOR 1 OF THE LAST 2 YEARS#######################




view: _zcm_instructor_filter {
  derived_table: {
    sql:
     SELECT
          DISTINCT r.course_instructor_id
        , time.ay_value
        , COALESCE(SUM(r.REGISTRATIONS),0) AS inst_ay_regs
  FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION as  r
  LEFT JOIN ${dim_time_zcm.SQL_TABLE_NAME} as time on r.dim_time_id = time.dim_time_id
  WHERE time.ay_value >= -{% parameter _zcm_school_filter.core_gateway_threshold_range %}
  GROUP BY 1,2
  HAVING inst_ay_regs >= {% parameter annual_instructor_registration_threshold %};;
  }

 dimension: pk2_inst_ay_key {
   primary_key: yes
  hidden: yes
  sql: nullif(hash(${course_instructor_id},'|',${ay_value}),0) ;;
 }



  parameter: annual_instructor_registration_threshold {
    type: number
    label: "Min Instructor Annual Registrations"
    description: "select the minimum number of registrations an instructor must have in an academic year to be included in the query. Default >=  10"
    default_value: "10"
    view_label: "           Parameters & Filters"
  }

  dimension: inst_ay_regs {
    type: number
    hidden: yes
  }

  dimension: course_instructor_id {
    hidden: yes
  }



  dimension: ay_value {
    hidden: yes
  }





}
