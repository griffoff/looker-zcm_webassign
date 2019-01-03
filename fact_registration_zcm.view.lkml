include: "/webassign/fact_registration.view.lkml"


view: fact_registration_zcm {
  extends: [fact_registration]


dimension: dim_time_id {}


  measure: user_registrations {
    label: "Total # of Registrations"
    description: "Total number of Registrations (Activations) - (sum of registrations)"
# Commented out below for reference, do not unhide in order to maintain consistency with original project
#     type: sum
#     sql: ${registrations} ;;
#     drill_fields: [detail*]
  }

  measure: distinct_user_registrations {
    label: "# Users with Registrations"
    description: "Total # of users Registrations (Activations) -  (distinct sum of registrations partitioned by user_id & event_type) (event_type = purchase or refund)"
    hidden: yes
# Commented out below for reference, do not unhide in order to maintain consistency with original project
#     type: sum_distinct
#     sql_distinct_key: ${user_id}||${event_type} ;;
#     sql: ${registrations} ;;
#     drill_fields: [detail*]
  }

  dimension: registrations {
    sql: ${TABLE}.registrations ;;
  }



}
