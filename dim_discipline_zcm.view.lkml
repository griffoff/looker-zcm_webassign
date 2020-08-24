
include: "//webassign/dim_textbook.view.lkml"
include: "//webassign/dim_discipline.view.lkml"

view: dim_discipline_zcm {
sql_table_name: WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_DISCIPLINE ;;
view_label: "Course Topic"

dimension: dim_discipline_id {hidden:yes}
dimension: sub_discipline_id {hidden:yes}
dimension: discipline_id {hidden:yes}
dimension: discipline_name {}
dimension: sub_discipline_name {}
}
