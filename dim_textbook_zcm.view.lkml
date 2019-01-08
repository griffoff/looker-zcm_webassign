include: "/webassign/dim_textbook.view.lkml"


view: dim_textbook_zcm {
  extends: [dim_textbook]
  derived_table: {
    sql: SELECT *  FROM WEBASSIGN.FT_OLAP_REGISTRATION_REPORTS.DIM_TEXTBOOK  ;;
  }


  dimension: publisher_group_one {
    type: string
    label: "Publisher Group (Lvl 1)"
    description: "Groups publisher into 2 categories: Internal/OER (includes OpenStax & OpenIntro), and External"
    sql:
          CASE WHEN UPPER(${publisher_name}) = 'CENGAGE LEARNING' THEN 'Internal/OER'
               WHEN UPPER(${publisher_name}) = 'OPENSTAX' THEN 'Internal/OER'
               WHEN UPPER(${publisher_name}) = 'OPEN EDUCATIONAL RESOURCES' THEN 'Internal/OER'
               WHEN UPPER(${publisher_name}) = 'OPENINTRO' THEN 'Internal/OER'
               ELSE 'External'
          END
              ;;
  }

  dimension: publisher_group_two {
    type: string
    label: "Publisher Group (Lvl 2)"
    description: "Groups publisher into 3 categories: Internal (Cengage), OER (includes Open Educational Resources, OpenStax, & OpenIntro), and External"
    sql:
          CASE WHEN UPPER(${publisher_name}) = 'CENGAGE LEARNING' THEN 'Internal'
               WHEN UPPER(${publisher_name}) = 'OPENSTAX' THEN 'OER'
               WHEN UPPER(${publisher_name}) = 'OPEN EDUCATIONAL RESOURCES' THEN 'OER'
               WHEN UPPER(${publisher_name}) = 'OPENINTRO' THEN 'OER'
               ELSE 'External'
          END
              ;;
  }

  dimension: publisher_group_three {
    type: string
    label: "Publisher Group (Lvl 3)"
    description: "Groups Cengage and OER (including OpenStax & OpenIntro) into 'Internal/OER' and all other publishers seperately"
    sql:
          CASE WHEN UPPER(${publisher_name}) = 'CENGAGE LEARNING' THEN 'Internal'
               WHEN UPPER(${publisher_name}) = 'OPENSTAX' THEN 'OER'
               WHEN UPPER(${publisher_name}) = 'OPEN EDUCATIONAL RESOURCES' THEN 'OER'
               WHEN UPPER(${publisher_name}) = 'OPENINTRO' THEN 'OER'
               ELSE ${publisher_name}
          END
              ;;
  }

  filter: publisher_group_filter {   #### Note, Cant use a peramater for this as parameters only allow you to select one item
    type: string
    view_label: "           Parameters & Filters"
    default_value: "Internal, OER"
    suggestions: [
      "Internal"
      , "OER"
      , "Macmillan Learning"
      , "Pearson Education"
      , "Jones and Bartlett Learning"
      , "McGraw-Hill Education"
      , "Mathematical Association of America"
      , "John Wiley & Sons"
      , "Custom Labs"
      , "SAGE Publications"
      , "Bedford, Freeman, & Worth"
      , "Self Published Works"
      , "Kendall Hunt"
      , "WebAssign"
    ]
  }







 }
