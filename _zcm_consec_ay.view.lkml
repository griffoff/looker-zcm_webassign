########################################################################################################################################################
###############  #########################
###############


include: "/webassign/*.model.lkml"
include: "fact_registration_zcm.view.lkml"
include: "/webassign/dim_discipline.view.lkml"

view: _zcm_consec_ay {
#  extends: [fact_registration_zcm]
view_label: " *All Registrations"
derived_table: {
  sql:
  WITH base AS (
      SELECT
          DISTINCT s.dim_school_id as dim_school_id
          , s.school_id as school_id
          , time.special_ay_year as special_ay_year
          , time.ay_value as ay_value
          , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id),0) as school_registrations
          , COALESCE(SUM(r.REGISTRATIONS) OVER (PARTITION BY s.dim_school_id, time.special_ay_year),0) as annual_redesign_reg
          FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION  AS r
          LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL  AS s ON r.DIM_SCHOOL_ID = s.DIM_SCHOOL_ID
          LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK  AS t ON r.DIM_TEXTBOOK_ID = t.DIM_TEXTBOOK_ID
          LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE  AS d ON t.DIM_DISCIPLINE_ID = d.DIM_DISCIPLINE_ID
          INNER JOIN ${dim_time_zcm.SQL_TABLE_NAME} AS time ON r.DIM_TIME_ID = time.DIM_TIME_ID
          WHERE ((UPPER(s.COUNTRY_NAME ) = UPPER('United States')))
          AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
          AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX', 'OPENINTRO')))
          AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS', 'PRECALCULUS', 'FINITE MATH AND APPLIED CALCULUS'))
          OR ((UPPER(t.name) LIKE '%ALG%' OR UPPER(t.name) like '%TRIG%') AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%'))
  )
  , consec_base as (
      SELECT
            DISTINCT dim_school_id
          , school_id
          , special_ay_year
          , ay_value
          , first_value(ay_value) OVER (PARTITION BY dim_school_id ORDER BY ay_value desc) AS firstvalue
          , first_value(ay_value) OVER (PARTITION BY dim_school_id ORDER BY ay_value desc) - ay_value +1 AS firstvalue_vs_ay
          , row_number() OVER (PARTITION BY dim_school_id ORDER BY ay_value desc) AS rn
        FROM base
      ORDER BY 1 desc, 2 desc
  )
  , consec as (
      SELECT
            dim_school_id
          , count(ay_value) AS consecutive_years
      FROM consec_base
        WHERE firstvalue_vs_ay = rn
        AND firstvalue IN (0, -1)
        GROUP BY dim_school_id
        ORDER BY dim_school_id
  )
  , consec_all as (
      SELECT
            dim_school_id
          , count(ay_value) AS consecutive_years
      FROM consec_base
        WHERE firstvalue_vs_ay = rn
        GROUP BY dim_school_id
        ORDER BY dim_school_id
  )
  SELECT
            DISTINCT cb.dim_school_id
          , cb.school_id
          , cb.special_ay_year
          , cb.ay_value
          , cb.firstvalue
          , cb.firstvalue_vs_ay
          , cb.rn
          , zeroifnull(c.consecutive_years) as consec_ongoing
          , zeroifnull(ca.consecutive_years) as consec_past
  FROM consec_base cb
  LEFT JOIN consec as c on cb.dim_school_id = c.dim_school_id
  LEFT JOIN consec_all as ca on cb.dim_school_id = ca.dim_school_id
      ;;
}

dimension: pk {
  primary_key: yes
  hidden: yes
  sql: hash(${dim_school_id},'|',${special_ay_year}) ;;
}
dimension: dim_school_id                    { hidden: yes type: number}
dimension: school_id                        {hidden: yes }
dimension: special_ay_year                  {hidden: yes }
dimension: ay_value                         {hidden: yes type: number}
dimension: firstvalue                       {hidden: yes type: number}
dimension: firstvalue_vs_ay                 {hidden: yes type: number}
dimension: rn                               {hidden: yes type: number}

dimension: consec_ongoing                   {
  label: "# Consecutive AYs (Ongoing)"
  description: "The number of consecutive academic years with enrollments still ongoing."
  hidden: no
  type: number
}

dimension: consec_past                   {
  hidden: no
  label: "# Consecutive AYs (Past)"
  description: "The most recent number of consecutive academic years with enrollments for institutions not currently using in this academic year nor the past full academic year ."
  type: number
}

dimension: consec_dimension                   {
  label: "# Consecutive AYs w/ Enrollments *"
  description: "Counts the most recent period of Academic Years with consecutive enrollments. NOTE: * indicates that they are not current users (the streak does not contain the current AY nor the prior AY)  "
  hidden: no
  type: string
  sql:CASE WHEN ${consec_ongoing} = ${consec_past} THEN cast(${consec_ongoing} as string)
               WHEN ${consec_ongoing} = 0 and ${consec_past} <> 0 THEN concat(cast(${consec_past} as string), '*')
               ELSE 'Error' END
              ;;
}

# measure: avg_consec_ongoing {
#   type: average
#   sql: ${avg_consec_ongoing} ;;
# }
# measure: avg_consec_past {
#   type: average
#   sql: ${avg_consec_past} ;;
# }

measure: num_schools {
  type:  count

}

dimension: school_registrations            {hidden: yes type: number}
dimension: annual_redesign_reg              {hidden: yes type: number}
dimension: annual_redesign_topic_reg        {hidden: yes type: number}

}