#################### THIS VIEW IS NEEDED TO LIMIT THE SCHOOLS AVAILABLE IN ALL LEVELS TO ONLY THOSE THAT MEET THE CORE GATEWAY COMBINED ANNUAL REGISTRATION THRESHOLD #######################

include: "_zcm_cg_registrations.view.lkml"
include: "/webassign/*.model.lkml"
include: "fact_registration_zcm.view.lkml"
include: "/webassign/dim_discipline.view.lkml"
include: "/zcm_webassign/redesign_test.explore.lkml"
include: "_redesign_multiview_fields.view.lkml"

view: _zcm_school_filter {
  derived_table: {
    explore_source: _zcm_cg_registrations {
      filters: {
        field: _zcm_cg_registrations.meets_accgr_threshold
        value: "Yes"
      }
      column: dim_school_id {
#        field: _zcm_cg_registrations.dim_school_id
    }

  }

}

dimension: dim_school_id {
  hidden: yes
}
}
