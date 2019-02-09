view: _zcm_targeted_instructor_ranking {
  derived_table: {
    sql:
    WITH state_weight AS (
  SELECT
      DISTINCT state_abbr
    , CASE WHEN state_abbr IN ('CA', ' CO', ' GA', ' HI', ' IN', ' KY', ' MN', ' NC', ' OH', ' OK', ' TN', ' TX', ' VA', ' WV', ' MT') THEN 0.75 ELSE 1 END AS state_mandate_weight
    , CASE WHEN state_abbr IN ('CA', ' CO', ' GA', ' HI', ' IN', ' KY', ' MN', ' NC', ' OH', ' OK', ' TN', ' TX', ' VA', ' WV', ' MT') THEN 'Yes' ELSE 'No' END AS state_mandate
  FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.dim_school
)
,  ranks as (
    SELECT
      DISTINCT tr.dim_school_id
    , s.STATE_ABBR
    , tr.course_instructor_id
    , tr.crs_instructor_registrations
    , tr.crs_instructor_courses
    , tr.crs_instructor_sections
    , tr.crs_instructor_ays
    , tr.crs_instructor_topics
    , dense_rank() OVER (PARTITION BY tr.dim_school_id ORDER BY tr.crs_instructor_registrations desc) AS instructor_school_registration_rank
    , dense_rank() OVER (PARTITION BY tr.dim_school_id ORDER BY tr.crs_instructor_courses desc) AS instructor_school_course_rank
    , dense_rank() OVER (PARTITION BY tr.dim_school_id ORDER BY tr.crs_instructor_sections desc) AS instructor_school_section_rank
    , dense_rank() OVER (PARTITION BY tr.dim_school_id ORDER BY tr.crs_instructor_ays desc) AS instructor_school_ay_rank
    , dense_rank() OVER (PARTITION BY tr.dim_school_id ORDER BY tr.crs_instructor_topics desc) AS instructor_school_topic_rank
    , dense_rank() OVER (ORDER BY tr.crs_instructor_registrations desc) AS instructor_registration_rank
    , dense_rank() OVER (ORDER BY tr.crs_instructor_courses desc) AS instructor_course_rank
    , dense_rank() OVER (ORDER BY tr.crs_instructor_sections desc) AS instructor_sect_rank
    , dense_rank() OVER (ORDER BY tr.crs_instructor_ays desc) AS instructor_ay_rank
    , dense_rank() OVER (ORDER BY tr.crs_instructor_topics desc) AS instructor_topic_rank
FROM ${__zcm_targeted_view.SQL_TABLE_NAME} AS tr
LEFT JOIN WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.dim_school s ON tr.dim_school_id = s.dim_school_id
)
, unweighted AS (
SELECT
          *
        , dense_rank() OVER (PARTITION BY dim_school_id ORDER BY (instructor_school_registration_rank+instructor_school_section_rank+instructor_school_ay_rank+instructor_school_topic_rank)/4) as instructor_school_ranking_rank
        , dense_rank() OVER (ORDER BY (instructor_registration_rank+instructor_sect_rank+instructor_ay_rank+instructor_topic_rank)/4) as instructor_ranking_rank
FROM ranks
)
, weight_applied AS (
SELECT
    u.*
    , sw.state_mandate
    , u.instructor_ranking_rank * sw.state_mandate_weight AS weighted_instructor_multiplier
FROM unweighted AS u
LEFT JOIN state_weight AS sw ON u.state_abbr = sw.state_abbr
)
SELECT
    *
  , dense_rank() OVER (ORDER BY weighted_instructor_multiplier) AS weighted_instructor_rank
FROM weight_applied
;;
  }
  dimension: pk2_instructor_school_key {
    primary_key: yes
    sql: nullif(hash(${course_instructor_id},'|',${dim_school_id}),0) ;;
    hidden: yes
  }

  dimension: course_instructor_id  {
    type: number
    hidden: yes}

  dimension: dim_school_id {
    type: number
    hidden: yes
    }

#   dimension: state_mandate {
#     type: string
#     label: "State Mandated Coreq Redesign (Y/N)"
#     description: "Denotes if the state the school is in is known to have implemented a corequisite redesign state mandate"
#     view_label: "School"
#   }


  dimension: weighted_instructor_multiplier {
    type: number
    label: "                                ** Inst Ranking Before * Multiplier"
    hidden: yes
  }

#################################################################################################
################################### INSTRUCTOR SCHOOL RANKINGS ##################################
#################################################################################################


  dimension: instructor_school_registration_rank {
    type: number
    label: "Instructor School Registration Rank"
    description: "Ranks Instructors at the school level with the most active instructor ranked as 1"
    group_label: "   Instructor School Rankings"
    }

  dimension: instructor_school_course_rank {
    type: number
    label: "Instructor School Courses Rank"
    description: "Ranks Instructors at the school level with the most active instructor ranked as 1"
    group_label: "   Instructor School Rankings"
    }

  dimension: instructor_school_section_rank {
    type: number
    label: "Instructor School Sections Rank"
    description: "Ranks Instructors at the school level with the most active instructor ranked as 1"
    group_label: "   Instructor School Rankings"
    }

  dimension: instructor_school_ay_rank {
    type: number
    label: "Instructor School AYs Rank"
    description: "Ranks Instructors at the school level with the most active instructor ranked as 1"
    group_label: "   Instructor School Rankings"
    }

  dimension: instructor_school_topic_rank {
    type: number
    label: "Instructor School Topics Rank"
    description: "Ranks Instructors at the school level with the most active instructor ranked as 1"
    group_label: "   Instructor School Rankings"
    }

  dimension: instructor_school_ranking_rank {
    type: number
    label: "Overall Instructor School Rank"
    description: "Ranks Instructors at the school level with the most active instructor ranked as 1"
    group_label: "   Instructor School Rankings"
  }

  measure: ranking_average {
    type: number
    label: "Instructor School Ranking Average"
    group_label: "   Instructor School Rankings"
    sql: (${instructor_school_registration_rank}+${instructor_school_section_rank}+${instructor_school_ay_rank}+${instructor_school_topic_rank})/4 ;;
    value_format_name: decimal_1
  }

 ##################################################################################################
 ############################ STATE WEIGHTED INSTRUCTOR RANKINGS ##################################
 ##################################################################################################

    dimension: instructor_registration_rank     {
      type: number
      label: "Instructor Registration Rank"
      description: "Ranks Instructors out of all instructors in query. Weighted ranking takes the average overall ranking and doubles the value if school is located in a state with a redesign mandate.
      This value is then ranked among all other instructors regardless of if there is a state mandate"
      group_label: "   Instructor Rankings"
    }

    dimension: instructor_course_rank           {
      type: number
      label: "Instructor Course Rank"
      description: "Ranks Instructors out of all instructors in query. Weighted ranking takes the average overall ranking and doubles the value if school is located in a state with a redesign mandate.
      This value is then ranked among all other instructors regardless of if there is a state mandate"
      group_label: "   Instructor Rankings"
    }

    dimension: instructor_sect_rank             {
      type: number
      label: "Instructor Section Rank"
      description: "Ranks Instructors out of all instructors in query. Weighted ranking takes the average overall ranking and doubles the value if school is located in a state with a redesign mandate.
      This value is then ranked among all other instructors regardless of if there is a state mandate"
      group_label: "   Instructor Rankings"
    }

    dimension: instructor_ay_rank               {
      type: number
      label: "Instructor # AYs Rank"
      description: "Ranks Instructors out of all instructors in query. Weighted ranking takes the average overall ranking and doubles the value if school is located in a state with a redesign mandate.
      This value is then ranked among all other instructors regardless of if there is a state mandate"
      group_label: "   Instructor Rankings"
    }

    dimension: instructor_topic_rank            {
      type: number
      label: "Instructor Topics Rank"
      description: "Ranks Instructors out of all instructors in query. Weighted ranking takes the average overall ranking and doubles the value if school is located in a state with a redesign mandate.
      This value is then ranked among all other instructors regardless of if there is a state mandate"
      group_label: "   Instructor Rankings"
    }

    dimension: instructor_ranking_rank {
      type: number
      label: "Overall Instructor Rank"
      description: "Ranks Instructors out of all instructors in query. Weighted ranking takes the average overall ranking and doubles the value if school is located in a state with a redesign mandate.
      This value is then ranked among all other instructors regardless of if there is a state mandate"
      group_label: "   Instructor Rankings"
    }

    dimension: weighted_instructor_rank {
      type: number
      label: "Overall Instructor Rank (Weighted)"
      description: "Ranks Instructors out of all instructors in query. Weighted ranking takes the average overall ranking and doubles the value if school is located in a state with a redesign mandate.
      This value is then ranked among all other instructors regardless of if there is a state mandate"
      group_label: "   Instructor Rankings"
    }

}
