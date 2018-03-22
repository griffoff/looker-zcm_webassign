view: dim_school {
  sql_table_name: WA2ANALYTICS.DIM_SCHOOL ;;

  dimension: dim_school_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DIM_SCHOOL_ID ;;
  }

  dimension: acct_mgr {
    type: number
    sql: ${TABLE}.ACCT_MGR ;;
  }

  dimension: bb_version {
    type: string
    sql: ${TABLE}.BB_VERSION ;;
  }

  dimension: cengage_rep_email {
    type: string
    sql: ${TABLE}.CENGAGE_REP_EMAIL ;;
  }

  dimension: cengage_rep_name {
    type: string
    sql: ${TABLE}.CENGAGE_REP_NAME ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.CITY ;;
  }

  dimension: cl_entity_number {
    type: string
    sql: ${TABLE}.CL_ENTITY_NUMBER ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.CODE ;;
  }

  dimension: continent_id {
    type: number
    sql: ${TABLE}.CONTINENT_ID ;;
  }

  dimension: continent_name {
    type: string
    sql: ${TABLE}.CONTINENT_NAME ;;
  }

  dimension: country_abbr {
    type: string
    sql: ${TABLE}.COUNTRY_ABBR ;;
  }

  dimension: country_id {
    type: number
    sql: ${TABLE}.COUNTRY_ID ;;
  }

  dimension: country_name {
    type: string
    sql: ${TABLE}.COUNTRY_NAME ;;
  }

  dimension_group: created_eastern {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CREATED_EASTERN ;;
  }

  dimension_group: date_from {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.DATE_FROM ;;
  }

  dimension_group: date_to {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.DATE_TO ;;
  }

  dimension: dim_time_id_created {
    type: number
    value_format_name: id
    sql: ${TABLE}.DIM_TIME_ID_CREATED ;;
  }

  dimension: email {
    type: yesno
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: license {
    type: string
    sql: ${TABLE}.LICENSE ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }

  dimension: password_ruleset {
    type: number
    sql: ${TABLE}.PASSWORD_RULESET ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.PHONE ;;
  }

  dimension: price_category {
    type: number
    sql: ${TABLE}.PRICE_CATEGORY ;;
  }

  dimension: price_category_desc {
    type: string
    sql: ${TABLE}.PRICE_CATEGORY_DESC ;;
  }

  dimension: region_id {
    type: number
    sql: ${TABLE}.REGION_ID ;;
  }

  dimension: region_name {
    type: string
    sql: ${TABLE}.REGION_NAME ;;
  }

  dimension: school_id {
    type: number
    sql: ${TABLE}.SCHOOL_ID ;;
  }

  dimension: sf_account_id {
    type: string
    sql: ${TABLE}.SF_ACCOUNT_ID ;;
  }

  dimension: state_abbr {
    type: string
    sql: ${TABLE}.STATE_ABBR ;;
  }

  dimension: state_id {
    type: number
    sql: ${TABLE}.STATE_ID ;;
  }

  dimension: state_name {
    type: string
    sql: ${TABLE}.STATE_NAME ;;
  }

  dimension: territory_id {
    type: number
    sql: ${TABLE}.TERRITORY_ID ;;
  }

  dimension: territory_name {
    type: string
    sql: ${TABLE}.TERRITORY_NAME ;;
  }

  dimension: timezone_id {
    type: number
    sql: ${TABLE}.TIMEZONE_ID ;;
  }

  dimension: timezone_name {
    type: string
    sql: ${TABLE}.TIMEZONE_NAME ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.TYPE ;;
  }

  dimension: use_https {
    type: yesno
    sql: ${TABLE}.USE_HTTPS ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.ZIP ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      dim_school_id,
      name,
      state_name,
      country_name,
      timezone_name,
      territory_name,
      region_name,
      cengage_rep_name,
      continent_name,
      dim_faculty.count,
      fact_registration.count
    ]
  }
}
