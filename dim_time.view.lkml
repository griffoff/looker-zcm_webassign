view: dim_time {
  sql_table_name: WA2ANALYTICS.DIM_TIME ;;

  dimension: dim_time_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_TIME_ID ;;
  }

  dimension: cdate {
    type: string
    sql: ${TABLE}.CDATE ;;
  }

  dimension: cengage_fiscal_year {
    type: string
    sql: ${TABLE}.CENGAGE_FISCAL_YEAR ;;
  }

  dimension: is_current_school_year {
    type: yesno
    sql: ${TABLE}.IS_CURRENT_SCHOOL_YEAR ;;
  }

  dimension: is_current_school_year_ytd {
    type: yesno
    sql: ${TABLE}.IS_CURRENT_SCHOOL_YEAR_YTD ;;
  }

  dimension: is_current_year {
    type: yesno
    sql: ${TABLE}.IS_CURRENT_YEAR ;;
  }

  dimension: is_previous_school_year {
    type: yesno
    sql: ${TABLE}.IS_PREVIOUS_SCHOOL_YEAR ;;
  }

  dimension: is_previous_school_year_ytd {
    type: yesno
    sql: ${TABLE}.IS_PREVIOUS_SCHOOL_YEAR_YTD ;;
  }

  dimension: is_previous_year {
    type: yesno
    sql: ${TABLE}.IS_PREVIOUS_YEAR ;;
  }

  dimension: special_ay_day {
    type: number
    sql: ${TABLE}.SPECIAL_AY_DAY ;;
  }

  dimension: special_ay_week {
    type: number
    sql: ${TABLE}.SPECIAL_AY_WEEK ;;
  }

  dimension: special_ay_year {
    type: string
    sql: ${TABLE}.SPECIAL_AY_YEAR ;;
  }

  dimension: special_cy_day {
    type: number
    sql: ${TABLE}.SPECIAL_CY_DAY ;;
  }

  dimension: special_cy_week {
    type: number
    sql: ${TABLE}.SPECIAL_CY_WEEK ;;
  }

  dimension: special_cy_year {
    type: number
    sql: ${TABLE}.SPECIAL_CY_YEAR ;;
  }

  dimension: timeacademicyearmonthorder {
    type: number
    sql: ${TABLE}.TIMEACADEMICYEARMONTHORDER ;;
  }

  dimension: timedate {
    type: string
    sql: ${TABLE}.TIMEDATE ;;
  }

  dimension: timedayofmonth {
    type: number
    sql: ${TABLE}.TIMEDAYOFMONTH ;;
  }

  dimension: timedayofschoolyear {
    type: number
    sql: ${TABLE}.TIMEDAYOFSCHOOLYEAR ;;
  }

  dimension: timedayofweek {
    type: number
    sql: ${TABLE}.TIMEDAYOFWEEK ;;
  }

  dimension: timedayofweekdesc {
    type: string
    sql: ${TABLE}.TIMEDAYOFWEEKDESC ;;
  }

  dimension: timedayofweekshortdesc {
    type: string
    sql: ${TABLE}.TIMEDAYOFWEEKSHORTDESC ;;
  }

  dimension: timedayofyear {
    type: number
    sql: ${TABLE}.TIMEDAYOFYEAR ;;
  }

  dimension: timefiscalquarter {
    type: string
    sql: ${TABLE}.TIMEFISCALQUARTER ;;
  }

  dimension: timemonth {
    type: number
    sql: ${TABLE}.TIMEMONTH ;;
  }

  dimension: timemonthdesc {
    type: string
    sql: ${TABLE}.TIMEMONTHDESC ;;
  }

  dimension: timemonthshortdesc {
    type: string
    sql: ${TABLE}.TIMEMONTHSHORTDESC ;;
  }

  dimension: timesalesperiod {
    type: string
    sql: ${TABLE}.TIMESALESPERIOD ;;
  }

  dimension: timesalesperioddesc {
    type: string
    sql: ${TABLE}.TIMESALESPERIODDESC ;;
  }

  dimension: timesalesperiodschoolyear {
    type: string
    sql: ${TABLE}.TIMESALESPERIODSCHOOLYEAR ;;
  }

  dimension: timeschoolquarter {
    type: string
    sql: ${TABLE}.TIMESCHOOLQUARTER ;;
  }

  dimension: timeschoolquarterdesc {
    type: string
    sql: ${TABLE}.TIMESCHOOLQUARTERDESC ;;
  }

  dimension: timeschoolsemester {
    type: string
    sql: ${TABLE}.TIMESCHOOLSEMESTER ;;
  }

  dimension: timeschoolsemesterdesc {
    type: string
    sql: ${TABLE}.TIMESCHOOLSEMESTERDESC ;;
  }

  dimension: timeschoolyear {
    type: string
    sql: ${TABLE}.TIMESCHOOLYEAR ;;
  }

  dimension: timeschoolyearsemester {
    type: string
    sql: ${TABLE}.TIMESCHOOLYEARSEMESTER ;;
  }

  dimension: timeschoolyearsemesterdesc {
    type: string
    sql: ${TABLE}.TIMESCHOOLYEARSEMESTERDESC ;;
  }

  dimension: timeweekofyear {
    type: number
    sql: ${TABLE}.TIMEWEEKOFYEAR ;;
  }

  dimension: timeyear {
    type: number
    sql: ${TABLE}.TIMEYEAR ;;
  }

  measure: count {
    type: count
    drill_fields: [dim_time_id, fact_registration.count]
  }
}
