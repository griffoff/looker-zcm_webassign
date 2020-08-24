include: "//webassign/dim_school.view.lkml"

view: dim_school_zcm {
  extends: [dim_school]

  measure: count {
    type: count
    drill_fields: [redesign_detail*]
  }

  set: redesign_detail {
    fields: [
      name
      , zcm_school_redesign_registration.school_registrations
      , __zcm_coregateway_view.num_ay_over_threshold_s
      , __zcm_coregateway_view.most_recent_ay_over_threshold
      , __zcm_coregateway_view.total_combined_cgr
      , dim_section.course_count
      , dim_section.count
      , dim_section.course_instructor_count
      , dim_section.sect_instructor_count
      ]
  }

  dimension: name {
    label: "School Name"
    drill_fields: [_zcm_topic_filter.topic, dim_section.course_instructor_name, dim_time.special_ay_year]
  }

  dimension: state_abbr {
    label: "State Abbr."
    map_layer_name: us_states
    sql: ${TABLE}.state_abbr ;;
    drill_fields: [name, city]
  }

  parameter: state_mandate_instructor_weight {
    view_label: "           Parameters & Filters"
    default_value: "0.667"
    allowed_value: {
      label: "Equal"
      value: "1"
    }
    allowed_value: {
      label: "1.5"
      value: "0.667"
    }
    allowed_value: {
      label: "2X"
      value: "0.5"
    }
    allowed_value: {
      label: "3X"
      value: "0.334"
    }

  }

  dimension: state_mandate_weight {
    label: "State Mandated Weight Multiplier"
    description: "Denotes if the state the school is in is known to have implemented a corequisite redesign state mandate"
    view_label: "School"
    sql:  CASE WHEN ${state_abbr} IN ('CA', ' CO', ' GA', ' HI', ' IN', ' KY', ' MN', ' NC', ' OH', ' OK', ' TN', ' TX', ' VA', ' WV', ' MT') THEN {% parameter state_mandate_instructor_weight %}
            ELSE 1
            END
    ;;
  }

  dimension: state_mandate {
    type: string
    label: "State Mandated Coreq Redesign (Y/N)"
    description: "Denotes if the state the school is in is known to have implemented a corequisite redesign state mandate"
    view_label: "School"
    sql:
          CASE WHEN ${state_abbr} IN ('CA', ' CO', ' GA', ' HI', ' IN', ' KY', ' MN', ' NC', ' OH', ' OK', ' TN', ' TX', ' VA', ' WV', ' MT') THEN 'Yes'
            ELSE 'No'
            END ;;
  }

dimension: code                     {hidden:yes}
dimension: continent_id                   {hidden:yes}
dimension: continent_name                    {hidden:yes}
dimension: country_abbr                     {hidden:yes}
dimension: country_id                     {hidden:yes}
dimension_group: created_eastern                     {hidden:yes}
dimension_group: date_from                     {hidden:yes}
dimension: dim_time_id_created                     {hidden:yes}
dimension: license                     {hidden:yes}
dimension: password_ruleset                     {hidden:yes}
dimension: price_category                    {hidden:yes}
dimension: region_id                    {hidden:yes}
dimension: bb_version                 {hidden:yes}
dimension_group: date_to                {hidden:yes}
dimension: school_price_category_code                  {hidden:yes}
dimension:   sf_account_id               {hidden:yes}
dimension:  state_id                {hidden:yes}
dimension: territory_id                 {hidden:yes}
dimension: timezone_id                  {hidden:yes}
dimension:  timezone_name                {hidden:yes}
dimension:  use_https                {hidden:yes}
  dimension:  email              {hidden:yes}
dimension: territory_name {hidden:yes}
  dimension: version {hidden:yes}
  }
