view: usersectionslessonsstatistics {
  sql_table_name: WA2ANALYTICS.USERSECTIONSLESSONSSTATISTICS ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: firstattemptpoints {
    type: number
    sql: ${TABLE}.FIRSTATTEMPTPOINTS ;;
  }

  dimension: sectionid {
    type: number
    value_format_name: id
    sql: ${TABLE}.SECTIONID ;;
  }

  dimension: sectionslessonid {
    type: number
    value_format_name: id
    # hidden: yes
    sql: ${TABLE}.SECTIONSLESSONID ;;
  }

  dimension: totalcorrectpoints {
    type: number
    sql: ${TABLE}.TOTALCORRECTPOINTS ;;
  }

  dimension: userid {
    type: number
    value_format_name: id
    sql: ${TABLE}.USERID ;;
  }

  measure: count {
    type: count
    drill_fields: [id, sectionslessons.id, sectionslessons.lessonname]
  }
}
