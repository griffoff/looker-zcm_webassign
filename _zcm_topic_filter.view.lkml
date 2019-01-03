view: _zcm_topic_filter {
  derived_table: {
    sql:
        SELECT
                DISTINCT fact_registration_id
              , r.dim_section_id
              , r.course_id
              , r.dim_school_id
              , r.dim_textbook_id
              , t.dim_discipline_id
              , d.discipline_name
              , d.sub_discipline_name
              , t.name
              , CASE WHEN UPPER(d.sub_discipline_name) = 'LIBERAL ARTS MATHEMATICS' THEN 'Liberal Arts Mathematics'
                     WHEN UPPER(d.sub_discipline_name) = 'COLLEGE ALGEBRA' THEN 'College Algebra'
                     WHEN UPPER(d.sub_discipline_name) = 'INTRODUCTORY STATISTICS' THEN 'Introductory Statistics'
                     WHEN UPPER(d.sub_discipline_name) = 'PRECALCULUS' THEN 'Precalculus'
                     WHEN UPPER(d.sub_discipline_name) = 'FINITE MATH AND APPLIED CALCULUS' THEN 'Finite Math and Applied Calculus'
                     ELSE (
                              CASE WHEN (UPPER(t.name) LIKE '%ALG%' AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%') THEN 'Algebra/Trig'
                              WHEN (UPPER(t.name) LIKE '%TRIG%' AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%') THEN 'Algebra/Trig'
                              ELSE NULL END)
                     END as topic
              , count(*) as cnt
        FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION AS r
        LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK AS t ON r.dim_textbook_id = t.dim_textbook_id
        LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE AS d ON t.dim_discipline_id = d.dim_discipline_id
        LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL AS s ON r.dim_school_id = s.dim_school_id
          WHERE UPPER(d.discipline_name) IN ('MATHEMATICS', 'STATISTICS')
          AND UPPER(s.type) IN ('UNIVERSITY', 'COMMUNITY COLLEGE')
          AND UPPER(s.country_name) = 'UNITED STATES'
          AND topic is not null
        GROUP BY 1,2,3,4,5,6,7,8,9
              ;;
  }

#   dimension: pk {
#     primary_key: yes
#     hidden: yes
#     sql: hash(${dim_section_id}, ${dim_textbook_id}) ;;
#   }

  dimension: fact_registration_id {
    primary_key: yes
  }

  dimension:  dim_section_id      {}
  dimension: course_id            {}
  dimension: dim_school_id        {}
  dimension:  dim_textbook_id     {}
  dimension:  dim_discipline_id   {}
  dimension:  discipline_name     {}
  dimension:  sub_discipline_name {}
  dimension:  name                {}
  dimension:  topic               {}
  dimension:  cnt                 {}


 measure: count_sections {
    type: count_distinct
    label: "# Sections"
    sql: ${TABLE}.dim_section_id ;;
  }

  measure: count_courses {
    type: count_distinct
    label: "# Courses"
    sql: ${TABLE}.course_id ;;
  }

  measure: count_schools {
    type: count_distinct
    label: "# Schools"
    sql: ${TABLE}.dim_school_id ;;
  }

  measure: count {
    type: count
  }
}
