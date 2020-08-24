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
              , t.publisher_name
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
              , CASE WHEN topic IN ('Introductory Statistics', 'College Algebra', 'Liberal Arts Mathematics') THEN 'Core Gateway Topics' ELSE 'Other Redesign Topics' END AS topic_group
              , CASE WHEN UPPER(t.publisher_name) = 'CENGAGE LEARNING' THEN 'Internal'
                      WHEN UPPER(t.publisher_name) = 'OPENSTAX' THEN 'OER'
                      WHEN UPPER(t.publisher_name) = 'OPEN EDUCATIONAL RESOURCES' THEN 'OER'
                      WHEN UPPER(t.publisher_name) = 'OPENINTRO' THEN 'OER'
                      ELSE t.publisher_name
                END as publisher_group
        FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION AS r
        LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK AS t ON r.dim_textbook_id = t.dim_textbook_id
        LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE AS d ON t.dim_discipline_id = d.dim_discipline_id
        LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL AS s ON r.dim_school_id = s.dim_school_id
          WHERE UPPER(d.sub_discipline_name) IN ('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS', 'PRECALCULUS', 'FINITE MATH AND APPLIED CALCULUS')
          AND topic is not null
          AND {% condition fact_registration.publisher_group_filter %} publisher_group {% endcondition %}
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

  filter: publisher_group_filter {
    hidden: yes
    type: string
    view_label: "           Parameters & Filters"
    default_value: "Internal, OER"
    suggest_dimension: _zcm_topic_filter.publisher_group
  }


  dimension:  dim_section_id      {hidden:yes}
  dimension: course_id            {hidden:yes}
  dimension: dim_school_id        {hidden:yes}
  dimension:  dim_textbook_id     {hidden:yes}
  dimension:  dim_discipline_id   {hidden:yes}
  dimension:  discipline_name     {hidden:yes}
  dimension:  sub_discipline_name {hidden:yes}
  dimension:  name                {hidden:yes}
  dimension:  topic               {
    drill_fields: [dim_section.course_instructor_name, dim_time.special_ay_year, dim_section.course_id, dim_section.section_id, publisher_name, dim_textbook.author, dim_textbook.code]
  }
  dimension: topic_group          {
    drill_fields: [topic]
  }
  dimension: publisher_group      {
    drill_fields: [publisher_name]
  }
  dimension:  cnt                 {}
  dimension: publisher_name       {}


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
