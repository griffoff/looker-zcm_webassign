include: "/webassign/*.view.lkml"
include: "*.view.lkml"
include: "redesign_test.explore.lkml"


explore: zcm_coreq_redesign_registrations {
  extends: [fact_registration]
  from: fact_registration_zcm
  label: "Co-Requisite Activations"
  case_sensitive: no
  always_join: [_zcm_school_filter, _zcm_topic_filter, dim_textbook]                                          ##### Only include schools meeting the CGR Threshold, From the US, University/CC type, internal & OER publishers, and for the target topics
  sql_always_where: {% condition dim_textbook.publisher_group_filter %}
                        ${dim_textbook.publisher_group_three} {% endcondition %}
                    AND ${dim_school.type} IN ('University', 'Community College')
                    AND ${dim_school.country_name} = 'United States'
                     AND ${_zcm_topic_filter.topic} IS NOT NULL
 --                    AND ${_zcm_cg_registrations.pk1_fact_registration_id} IS NOT NULL                      #### Not null on these causes measures to only work at the cg level, but without, dimensions have null values and create multiple  rows
--                     AND ${_zcm_targeted_registrations.pk1_fact_registration_id} IS NOT NULL
                    ;;


#------- PDTs AGGREGATING AT DIFFERENT LEVELS -------#

  join: _zcm_lifetime_registrations {                                                                              ##### Pulls in broadest chunk of data related to the project. Goes back as far as we have data for.
#    from: _zcm_lifetime_registrations                                                                              ##### Can be narrowed with the "Select Lifetime Academic Years Included" parameter
    type: inner                                                                                                     ##### Inner join to restrict data and broadly include ALL topics, school types, country, etc related to project.
    relationship: one_to_one
    view_label: "   Lifetime Registrations"
    sql_on: ${fact_registration.fact_registration_id} = ${_zcm_lifetime_registrations.pk1_fact_registration_id} ;;
#      sql_on:     ${fact_registration.dim_school_id} = ${_zcm_lifetime_registrations.dim_school_id}
#              AND ${dim_time.special_ay_year} = ${_zcm_lifetime_registrations.special_ay_year}
#              AND ${dim_discipline.dim_discipline_id} = ${_zcm_lifetime_registrations.dim_discipline_id};;
  }



  join: _zcm_targeted_registrations {                                                                         ##### Added layer of metrics with broad course topics but restricted to the targeted academic years
    type: left_outer                                                                                          ##### Left Join to all_registrations view to add targeted metrics without further restricting available data
#  from: _zcm_targeted_registrations
   relationship: one_to_one
    view_label: "   Targeted Registrations"##### Assuming one to one since pks are all unique
    sql_on: ${_zcm_lifetime_registrations.pk1_fact_registration_id}
              = ${_zcm_targeted_registrations.pk1_fact_registration_id}   ;;
  }


  join: _zcm_cg_registrations {                                                                               ##### Added layer of Core Gateway Registrations.
#    from: _zcm_cg_registrations
    type: left_outer                                                                                          ##### Left Join to all_registrations view allows to add CG metrics without further restricting data
    relationship: one_to_one
    view_label: "   Core Gateway Registrations"##### Assuming one to one since pks are all unique
    sql_on: ${_zcm_lifetime_registrations.pk1_fact_registration_id}
              = ${_zcm_cg_registrations.pk1_fact_registration_id} ;;
#    sql_on: ${_zcm_lifetime_registrations.pk} = ${_zcm_cg_registrations.pk} ;;
#     sql_on: ${_zcm_lifetime_registrations.dim_school_id} = ${_zcm_cg_registrations.dim_school_id}                ##### Keeping original join for reference incase pk join causes a problem
#              AND ${dim_time.special_ay_year} = ${_zcm_cg_registrations.special_ay_year}
#              AND ${dim_discipline.dim_discipline_id} = ${_zcm_cg_registrations.dim_discipline_id};;
  }


#------  VIEWS FOR FILTERS ------#

  join: _zcm_school_filter {                                                                                  ##### Inner Joins with fact_registration on school ID only. PDT is filtered to only accept schools that meet ACCGR Threshold for the targeted years
    from: _zcm_school_filter
    type: inner
    relationship: many_to_one
    sql_on: ${fact_registration.dim_school_id} = ${_zcm_school_filter.dim_school_id} ;;
  }

  join: _zcm_topic_filter {                                                                                   ##### Not sure if this is the most efficient way to do this. Also have topic filtered on all the different level tables above. Might be redundant
    from: _zcm_topic_filter
    type: left_outer
    relationship: one_to_one
    view_label: "Discipline"
    fields: [_zcm_topic_filter.topic]
    sql_on: ${fact_registration.fact_registration_id} = ${_zcm_topic_filter.fact_registration_id} ;;
  }

  join:   _redesign_multiview_fields {
    from: _redesign_multiview_fields
    relationship: one_to_one
    sql:   ;;
#  fields: [_redesign_multiview_fields.date_range_ay, _redesign_multiview_fields.accgr_threshold, _redesign_multiview_fields.lifetime_ay_included_db_title, _redesign_multiview_fields.targeted_ay_included_db_title]
  }


#------- SPECIAL DEFINITIONS FOR EXISTING WEBASSIGN VIEWS --------#

  join: _zcm_consec_ay {
    view_label: "Lifetime Consecutive AYs w/ Registrations"
    type: left_outer
    relationship: many_to_one
    sql_on: ${_zcm_lifetime_registrations.dim_school_id} = ${_zcm_consec_ay.dim_school_id} ;;
  }

  join: dim_time {
#    required_joins: [zcm_school_redesign_registration]
    from: dim_time_zcm
    type: inner
    relationship: many_to_one
    sql_on: ${fact_registration.dim_time_id} = ${dim_time.dim_time_id} ;;
    fields: [dim_time.ay_end_year, dim_time.ay_start_year,dim_time.special_ay_year, dim_time.ay_value]
  }

  join: dim_textbook {
    from: dim_textbook_zcm
    relationship: many_to_one
    type: left_outer
    sql_on: ${fact_registration.dim_textbook_id} = ${dim_textbook.dim_textbook_id} ;;
  }

  join: dim_school {
    from: dim_school_zcm
  }


#------------- REMOVED FROM FIELD PICKER --------------------------#

  join: dim_axscode {
    fields: []
    }
  join: dim_payment_method {
    fields: []
    }
  join: dim_faculty {
    fields: []
    }
  join: dim_product_family {
    fields:[]
    }
#  join: dim_section {fields:[]}

}








######################################## One Offs ############################################


#explore: _redesign_multiview_fields {}
explore: _zcm_consec_ay {}
#explore: _zcm_cg_registrations {}
explore: _zcm_topic_filter {}


#   join: _redesign_multiview_fields {
#     relationship: one_to_one
#     sql:   ;;
#   fields: [_redesign_multiview_fields.date_range_ay, _redesign_multiview_fields.accgr_threshold, _redesign_multiview_fields.lifetime_ay_included_db_title, _redesign_multiview_fields.targeted_ay_included_db_title]
# }
#}
explore: _zcm_lifetime_registrations {}
