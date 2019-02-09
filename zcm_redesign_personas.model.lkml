include: "//webassign/*.view.lkml"
include: "*.view.lkml"
include: "redesign_test.explore.lkml"


# explore: zcm_coreq_redesign_base {
#   extends: [fact_registration]
#   from: __zcm_lifetime_view
#   label: "Co-Requisite Activations Base"
#   case_sensitive: no
# # extension: required


# #  always_join: [_zcm_school_filter, _zcm_topic_filter, _zcm_section_registration_filter, _zcm_instructor_filter]  ### These views act as filters and must always be joined in a query
#
# #   always_filter: {
# #     filters:{
# #       field: _zcm_topic_filter.publisher_group_filter                                                             ### Only include those using internal & OER publishers for the target topics
# #       value: "Internal, OER"
# #       }
# #   }
#                                                                                                                   ### Only Include schools that are University & Community Colleges in the US
# #   sql_always_where: ${dim_school.type} IN ('University', 'Community College')
# #                      AND ${dim_school.country_name} = 'United States'
# #                      AND ${_zcm_topic_filter.topic} IS NOT NULL;;
#
#
# ##################################################################
# ##################### ALTERNATIVE VIEWS ##########################
# ##################################################################
#
# join: __zcm_coregateway_view {
#   type: left_outer                                                                                                ### Add Core Gateway View which is used by _zcm_school_filter include only the schools that meet
#   relationship: one_to_one                                                                                        ### Core Gateway Annual Registration threshold. Includes less course topics
#   view_label: " Core Gateway View"##### Assuming one to one since pks are all unique
#   sql_on: ${fact_registration.pk1_fact_registration_id} = ${__zcm_coregateway_view.pk1_fact_registration_id} ;;
# }
#
#   join: __zcm_targeted_view {                                                                             ### Add view targeting narrow time period for all potential co-req course topics
#     type: left_outer
#     relationship: one_to_one
#     view_label: "    Targeted View"
#     sql_on: ${fact_registration.pk1_fact_registration_id} = ${__zcm_targeted_view.pk1_fact_registration_id}   ;;
#   }
#
#
# ##################################################################
# ########################### FILTERS ##############################                                                ### All filter tables inner join and are included in the always filter section at the top
# ##################################################################
#
#   join: _zcm_school_filter {                                                                                      ### Only accepts schools that meet the ACCGR Threshold for the targeted years
#     from: _zcm_school_filter
#     type: inner
#     relationship: many_to_one
#     sql_on: ${fact_registration.dim_school_id} = ${_zcm_school_filter.dim_school_id} ;;
#   }
#
#   join: _zcm_topic_filter {                                                                                       ### Better defines Course topics & groups publishers into "Internal", "OER", and other publishers names
#     from: _zcm_topic_filter                                                                                       ### Filters for the 5 topics needed and default publisher = Internal & OER
#     type: inner
#     relationship: one_to_one
#     view_label: "Discipline"
#     fields: [_zcm_topic_filter.topic, _zcm_topic_filter.topic_group, _zcm_topic_filter.publisher_group_filter]
#     sql_on: ${fact_registration.fact_registration_id} = ${_zcm_topic_filter.fact_registration_id} ;;
#   }
#
#   join: _zcm_section_registration_filter {                                                                        ### Filters out sections that have less than 5 registrations
#     from: _zcm_section_registration_filter
#     type: inner
#     relationship: many_to_one
#     sql_on: ${fact_registration.dim_section_id} = ${_zcm_section_registration_filter.dim_section_id} ;;
#   }
#
#   join: _zcm_instructor_filter {                                                                                  ### Filters out Course Instructors that have less than 10 registrations annually
#     from: _zcm_instructor_filter
#     type:  inner
#     relationship: many_to_one
#     sql_on: ${fact_registration.course_instructor_id} = ${_zcm_instructor_filter.course_instructor_id}
#       AND ${fact_registration.ay_value} = ${_zcm_instructor_filter.ay_value};;
#   }
#
# }
#
#
#
#
#
#
# explore: zcm_coreq_redesign_registrations {
#   extends: [zcm_coreq_redesign_base]
#    from: __zcm_lifetime_view
#
#   label: "Co-Requisite Activations"
#   case_sensitive: no
#
#   join: __zcm_lifetime_aggregations {
#     view_label: "     Lifetime View"
#     type: left_outer
#     relationship: one_to_one
#     sql_on:  ${fact_registration.pk1_fact_registration_id} = ${__zcm_lifetime_aggregations.pk1_fact_registration_id} ;;
#   }
#
# ###################### VIEWS TO BE REMOVED OR REDEFINED ##################################
#
#   join: dim_axscode {
#     fields: []
#   }
#   join: dim_payment_method {
#     fields: []
#   }
#   join: dim_faculty {
#     fields: []
#   }
#   join: dim_product_family {
#     fields:[]
#   }
#   join: dim_section {
#     from: dim_section_zcm
#   }
#
#   join: dim_time {
#     from: dim_time_zcm
#     type: inner
#     relationship: many_to_one
#     sql_on: ${fact_registration.dim_time_id} = ${dim_time.dim_time_id} ;;
#     fields: [dim_time.ay_end_year, dim_time.ay_start_year,dim_time.special_ay_year, dim_time.ay_value, dim_time.timedate, dim_time.cdate]
#   }
#
#   join: dim_textbook {
#     from: dim_textbook_zcm
#     relationship: many_to_one
#     type: left_outer
#     sql_on: ${fact_registration.dim_textbook_id} = ${dim_textbook.dim_textbook_id} ;;
#   }
#
#   join: dim_school {
#     from: dim_school_zcm
#   }
#
#   join:   _redesign_multiview_fields {
#     from: _redesign_multiview_fields
#     relationship: one_to_one
#     sql:   ;;
# #  fields: [_redesign_multiview_fields.date_range_ay, _redesign_multiview_fields.accgr_threshold, _redesign_multiview_fields.lifetime_ay_included_db_title, _redesign_multiview_fields.targeted_ay_included_db_title]
#   }
#
#
# #------- SPECIAL DEFINITIONS FOR EXISTING WEBASSIGN VIEWS --------#
#
#   join: _zcm_consec_ay {
#     view_label: "Lifetime Consecutive AYs w/ Registrations"
#     type: left_outer
#     relationship: many_to_one
#     sql_on: ${fact_registration.dim_school_id} = ${_zcm_consec_ay.dim_school_id} ;;
#   }
#
#}

explore: zcm_coreq_redesign_personas {
  extends: [fact_registration]
  from: __zcm_lifetime_view
  label: "Co-Requisite Redesign Personas"
  case_sensitive: no

##################################################################
##################### ALTERNATIVE VIEWS ##########################
##################################################################

  join: __zcm_targeted_view {                                                                             ### Add view targeting narrow time period for all potential co-req course topics
    type: left_outer
    relationship: one_to_one
    view_label: "    Targeted View"
    sql_on: ${fact_registration.pk1_fact_registration_id} = ${__zcm_targeted_view.pk1_fact_registration_id}   ;;
  }

join: __zcm_coregateway_view {
  type: left_outer                                                                                                ### Add Core Gateway View which is used by _zcm_school_filter include only the schools that meet
  relationship: one_to_one                                                                                        ### Core Gateway Annual Registration threshold. Includes less course topics
  view_label: " Core Gateway View"##### Assuming one to one since pks are all unique
  sql_on: ${fact_registration.pk1_fact_registration_id} = ${__zcm_coregateway_view.pk1_fact_registration_id} ;;
}

#################################################################
##################### INSTRUCTOR RANKINGS #######################
#################################################################

join: _zcm_targeted_instructor_ranking {
  type: left_outer
  relationship: many_to_one
  view_label: "     Targeted View"
  sql_on: ${__zcm_targeted_view.dim_school_id}=${_zcm_targeted_instructor_ranking.dim_school_id} AND ${__zcm_targeted_view.course_instructor_id}=${_zcm_targeted_instructor_ranking.course_instructor_id};;
}

#################################################################
######################## FILTER TABLES ##########################
#################################################################

   join: _zcm_topic_filter {                                                                                       ### Better defines Course topics & groups publishers into "Internal", "OER", and other publishers names
     from: _zcm_topic_filter                                                                                       ### Filters for the 5 topics needed and default publisher = Internal & OER
     type: inner
     relationship: one_to_one
     view_label: "Course Topic"
     fields: [_zcm_topic_filter.topic, _zcm_topic_filter.topic_group, _zcm_topic_filter.publisher_group_filter]
     sql_on: ${fact_registration.fact_registration_id} = ${_zcm_topic_filter.fact_registration_id} ;;
}



#################################################################
########### VIEWS TO BE REMOVED OR REDEFINED ####################
#################################################################

  join: dim_axscode {fields: []}
  join: dim_payment_method {fields: []}
  join: dim_faculty {fields: []}
  join: dim_product_family {fields:[]}
  join: dim_section {from: dim_section_zcm}

  join: dim_discipline {
    from: dim_discipline_zcm
  }

  join: dim_time {
    from: dim_time_zcm
    type: inner
    relationship: many_to_one
    sql_on: ${fact_registration.dim_time_id} = ${dim_time.dim_time_id} ;;
    fields: [dim_time.ay_end_year, dim_time.ay_start_year,dim_time.special_ay_year, dim_time.ay_value, dim_time.timedate, dim_time.cdate]
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
}
