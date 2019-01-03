include: "/webassign/dim_school.view.lkml"

view: dim_school_zcm {
  extends: [dim_school]

  measure: count {
    type: count
    drill_fields: [redesign_detail*]
  }

  set: redesign_detail {
    fields: [
      name
      , zcm_school_redesign_registration.lifetime_redesign_reg
      , _zcm_cg_registrations.num_ay_over_threshold_s
      , _zcm_cg_registrations.most_recent_ay_over_threshold
      , _zcm_cg_registrations.total_combined_cgr
      , dim_section.course_count
      , dim_section.count
      , dim_section.course_instructor_count
      , dim_section.sect_instructor_count
      ]
  }

  dimension: state_abbr {
    label: "State Abbr."
    map_layer_name: us_states
    sql: ${TABLE}.state_abbr ;;
  }

  }
