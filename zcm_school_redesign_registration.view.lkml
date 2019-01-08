
include: "/webassign/*.model.lkml"
  include: "fact_registration_zcm.view.lkml"
  include: "/webassign/dim_discipline.view.lkml"

view: zcm_school_redesign_registration {
#  extends: [fact_registration_zcm]
  view_label: " All Redesign Aggregates"
  derived_table: {
    sql:
        SELECT
            DISTINCT s.dim_school_id as dim_school_id
          , s.school_id as school_id
          , time.special_ay_year as special_ay_year
          , time.ay_value as ay_value
          , d.dim_discipline_id
          , d.sub_discipline_name
          , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id),0) as school_registrations
          , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_redesign_reg
          , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year, d.dim_discipline_id),0) as annual_redesign_topic_reg
    FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION  AS r
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL  AS s ON r.DIM_SCHOOL_ID = s.DIM_SCHOOL_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK  AS t ON r.DIM_TEXTBOOK_ID = t.DIM_TEXTBOOK_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE  AS d ON t.DIM_DISCIPLINE_ID = d.DIM_DISCIPLINE_ID
    INNER JOIN ${dim_time_zcm.SQL_TABLE_NAME} AS time ON r.DIM_TIME_ID = time.DIM_TIME_ID
    WHERE ((UPPER(s.COUNTRY_NAME ) = UPPER('United States')))
      AND (time.ay_value >= -{% parameter  _redesign_multiview_fields.date_range_ay %} )
      AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
      AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX')))
      AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS', 'PRECALCULUS', 'FINITE MATH AND APPLIED CALCULUS'))
          OR ((UPPER(t.name) LIKE '%ALG%' OR UPPER(t.name) like '%TRIG%') AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%'))
--    GROUP BY 1,2,3,4
        ;;
  }

  dimension: pk {
    primary_key: yes
    sql: hash(${dim_school_id},'|',${ay_value},'|',${dim_discipline_id}) ;;
  }

  dimension: dim_school_id                             {type: number hidden: yes }
  dimension: school_id                                 {type: number hidden: yes }
  dimension: special_ay_year                           {type: string hidden: yes }
  dimension: ay_value                   {type: number hidden: yes }
  dimension: dim_discipline_id                         {type: number hidden: yes }
  dimension: sub_discipline_name                       {type: string hidden: no view_label: "    Lvl 1 Aggregations: School/Topic/Academic Year"}
  dimension: annual_redesign_topic_reg       {type: number hidden: no view_label: "    Lvl 1 Aggregations: School/Topic/Academic Year" group_label: "Registration Counts"}
  dimension: annual_redesign_reg      {type: number hidden: no view_label: "   Lvl 2 Aggregations: School/Academic Year"  group_label: "Registration Counts"}
  dimension: school_registrations           {type: number hidden: no view_label: "  Lvl 3 Aggregations: School" group_label: "Registration Counts"}


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
  }