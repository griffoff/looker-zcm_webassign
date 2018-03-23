view: sectionslessons {
  sql_table_name: WA2ANALYTICS.SECTIONSLESSONS ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension_group: createdat {
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
    sql: ${TABLE}.CREATEDAT ;;
  }

  dimension_group: duedate {
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
    sql: ${TABLE}.DUEDATE ;;
  }

  dimension: lessonid {
    type: number
    value_format_name: id
    sql: ${TABLE}.LESSONID ;;
  }

  dimension: lessonname {
    type: string
    sql: ${TABLE}.LESSONNAME ;;
  }

  dimension: scoreadjustment {
    type: number
    sql: ${TABLE}.SCOREADJUSTMENT ;;
  }

  dimension: sectionid {
    type: number
    value_format_name: id
    sql: ${TABLE}.SECTIONID ;;
  }

  dimension: showscoreafterdue {
    type: yesno
    sql: ${TABLE}.SHOWSCOREAFTERDUE ;;
  }

  dimension: showscorebeforedue {
    type: yesno
    sql: ${TABLE}.SHOWSCOREBEFOREDUE ;;
  }

  dimension_group: startdate {
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
    sql: ${TABLE}.STARTDATE ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.TYPE ;;
  }

  dimension_group: updatedat {
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
    sql: ${TABLE}.UPDATEDAT ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      lessonname,
      attemptsbyquestion.count,
      attemptsbyquestionbox.count,
      responses.count,
      responsesseedsample.count,
      studentattemptpercentages.count,
      usersectionslessonsstatistics.count
    ]
  }
}
