# SQL for Validation

Put your documentation here! Your text is rendered with [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown).

Check the number of schools by CGR enrollment tiers (CLICK EDIT TO SEE CODE FORMATTED CORRECTLY) :
<br>

with all_rr as ( --all_rr = ALL Redesign Registrations - All Courses Combined
    SELECT
            DISTINCT s.dim_school_id
          , s.school_id
          , time.special_ay_year as special_ay_year
          , D.sub_discipline_name
          , count(DISTINCT D.sub_discipline_name) OVER (PARTITION BY s.dim_school_id) AS num_topics_taught_institution
          , COALESCE(SUM(r.REGISTRATIONS ), 0) AS all_r_registrations
    FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.FACT_REGISTRATION  AS r
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_SCHOOL  AS s ON r.DIM_SCHOOL_ID = s.DIM_SCHOOL_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK  AS t ON r.DIM_TEXTBOOK_ID = t.DIM_TEXTBOOK_ID
    LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE  AS d ON t.DIM_DISCIPLINE_ID = d.DIM_DISCIPLINE_ID
    INNER JOIN webassign.FT_OLAP_REGISTRATION_REPORTS.dim_time AS time ON r.DIM_TIME_ID = time.DIM_TIME_ID
    WHERE ((UPPER(s.COUNTRY_NAME ) = UPPER('United States')))
      AND (time.SPECIAL_AY_YEAR IN ('2015-2016', '2016-2017', '2017-2018', '2018-2019') )
      AND ((UPPER(s.TYPE ) IN('UNIVERSITY', 'COMMUNITY COLLEGE')))
      AND ((UPPER(t.PUBLISHER_NAME ) IN('CENGAGE LEARNING', 'OPEN EDUCATIONAL RESOURCES', 'OPENSTAX')))
      AND ((UPPER(d.SUB_DISCIPLINE_NAME ) IN('LIBERAL ARTS MATHEMATICS', 'COLLEGE ALGEBRA', 'INTRODUCTORY STATISTICS', 'PRECALCULUS', 'FINITE MATH AND APPLIED CALCULUS'))
          OR ((UPPER(t.name) LIKE '%ALG%' OR UPPER(t.name) like '%TRIG%') AND UPPER(t.name) NOT LIKE '%ADVANCED%' AND UPPER(t.name) NOT LIKE '%LINEAR%'))
    GROUP BY 1,2,3,4
)
, cgr_topic_ay_value AS ( -- creates column with registrations summed only on core gateway course topics to be summed in CTE following
SELECT
      *
    , CASE
        WHEN upper(sub_discipline_name) IN ('INTRODUCTORY STATISTICS', 'COLLEGE ALGEBRA', 'LIBERAL ARTS MATHEMATICS')
            THEN coalesce(sum(all_r_registrations) OVER (PARTITION BY dim_school_id, special_ay_year, sub_discipline_name),0)
            ELSE 0 END AS CGR_topic_value
FROM all_rr
WHERE num_topics_taught_institution >3
)
, cgr_ay AS ( -- Sums CG registrations by AY & institution
SELECT
    *
    , coalesce(sum(cgr_topic_value) OVER (PARTITION BY dim_school_id, special_ay_year),0) AS CGR_ay
FROM cgr_topic_ay_value
)
SELECT --- buckets CG registrations by academic year and performs a count of institutions
     CASE  WHEN cgr_ay < 100 THEN '<100'
        WHEN cgr_ay BETWEEN 100 AND 300 THEN '100-300'
        WHEN cgr_ay BETWEEN 300 AND 500 THEN '301-500'
        WHEN cgr_ay BETWEEN 500 AND 700 THEN '501-700'
        WHEN cgr_ay BETWEEN 700 AND 800 THEN '701-800'
        WHEN cgr_ay BETWEEN 800 AND 900 THEN '801-900'
        WHEN cgr_ay BETWEEN 900 AND 1000 THEN '901-1000'
        WHEN cgr_ay >=1000 THEN '1000+'
        ELSE 'ERROR'
      END AS reg_tiers
      , sum(count(DISTINCT dim_school_id)) OVER () AS num_schools_included
    , count(DISTINCT DIM_SCHOOL_ID) AS num_schools
FROM cgr_ay
GROUP BY 1
ORDER BY 1 desc
;
