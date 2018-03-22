connection: "snowflake_webassign"

# include all the views
include: "*.view"
include: "/webassign/*.view.lkml"

# include all the dashboards
include: "*.dashboard"

include: "/webassign/*.model.lkml"

datagroup: zcm_webassign_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: zcm_webassign_default_datagroup
