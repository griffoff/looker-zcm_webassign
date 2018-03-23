view: topquestions_zcm {
  view_label: " Chip's Additions - Ranking"
  derived_table: {
    sql_trigger_value: select count(*) from WA2ANALYTICS.SECTIONSLESSONS ;;
    sql:
       WITH y AS (
    SELECT
          DISTINCT dq.dim_question_id
        , sl.id
        , dt.dim_textbook_id
        , dd.discipline_id
        , dd.sub_discipline_id
        , dq.dim_textbook_id||'-'||dq.chapter AS text_chapter
        , count(distinct sl.id) OVER (PARTITION BY dq.dim_question_id) AS question_slcount
        , count(distinct sl.id) OVER (PARTITION BY dt.dim_textbook_id) AS textbook_slcount
    FROM ${responses.SQL_TABLE_NAME} r
    LEFT JOIN WA2ANALYTICS.DIM_QUESTION dq ON dq.QUESTION_ID = r.QUESTIONID
    LEFT JOIN WA2ANALYTICS.DIM_TEXTBOOK dt ON dq.DIM_TEXTBOOK_ID = dt.DIM_TEXTBOOK_ID
    LEFT JOIN WA2ANALYTICS.DIM_DISCIPLINE dd ON dt.DIM_DISCIPLINE_ID = dd.DIM_DISCIPLINE_ID
    LEFT JOIN WA2ANALYTICS.SECTIONSLESSONS sl ON r.SECTIONSLESSONSID = sl.ID
    WHERE sl.id IS NOT NULL
    ORDER BY 1
    )
    , x AS (
        SELECT
        DISTINCT dim_question_id
        , question_slcount
        , textbook_slcount
        , DENSE_RANK() OVER (PARTITION BY text_chapter ORDER BY  question_slcount DESC ) AS questionsbychapterrank
        , DENSE_RANK() OVER (PARTITION BY dim_textbook_id ORDER BY question_slcount  DESC ) AS questionsbytextranking
        , DENSE_RANK() OVER (PARTITION BY sub_discipline_id ORDER BY question_slcount  DESC ) AS questionsbysubdisciplineranking
        , DENSE_RANK() OVER (PARTITION BY discipline_id ORDER BY question_slcount  DESC ) AS questionsbydisciplineranking
        , DENSE_RANK() OVER (PARTITION BY sub_discipline_id  ORDER BY textbook_slcount  DESC ) AS textbookbysubdisciplineranking
        , DENSE_RANK() OVER (PARTITION BY discipline_id ORDER BY textbook_slcount  DESC ) AS textbookbydisciplineranking
    FROM y
    )
    SELECT *
         , {% parameter n_item_rank %} as rank
         , {% parameter n_item_rank_2 %} as rank_2
    FROM x
    WHERE rank <= {% parameter n_items %}
    AND rank_2 <= {% parameter n_items_2 %}
    ORDER BY rank DESC
    ;;
  }

  parameter: n_items {
    label: "    Top n"
    description: "Choose the number of items you would like to include in your 'Top n' (Top 10, Top 100?) "
    type: number
    default_value: "10000000000"
  }

  parameter: n_items_2 {
    label: "    Top x"
    description: "Choose the number of items you would like to include in your 'Top n' (Top 10, Top 100?) "
    type: number
    default_value: "10000000000"
  }

  parameter: n_item_rank {
    label: "  Rank Top n..."
    default_value: "x.questionsbytextranking"
    type: unquoted
    allowed_value: {label: "Questions by Chapter" value: "x.questionsbychapterrank"}
    allowed_value: {label: "Questions by Textbook" value: "x.questionsbytextranking"}
    allowed_value: {label: "Questions by Sub-Discipline" value: "x.questionsbysubdisciplineranking"}
    allowed_value: {label: "Questions by Discipline" value: "x.questionsbydisciplineranking"}
    allowed_value: {label: "Textbook by Sub-Discipline" value: "x.textbookbysubdisciplineranking"}
    allowed_value: {label: "Textook by Discipline" value: "x.textbookbydisciplineranking"}
  }

  parameter: n_item_rank_2 {
    label: "  Rank Top x..."
    default_value: "x.questionsbytextranking"
    type: unquoted
    allowed_value: {label: "Questions by Chapter" value: "x.questionsbychapterrank"}
    allowed_value: {label: "Questions by Textbook" value: "x.questionsbytextranking"}
    allowed_value: {label: "Questions by Sub-Discipline" value: "x.questionsbysubdisciplineranking"}
    allowed_value: {label: "Questions by Discipline" value: "x.questionsbydisciplineranking"}
    allowed_value: {label: "Textbook by Sub-Discipline" value: "x.textbookbysubdisciplineranking"}
    allowed_value: {label: "Textook by Discipline" value: "x.textbookbydisciplineranking"}
  }


  dimension: dim_question_id {hidden: no  primary_key:yes  group_label: "  Top N Questions"}
  dimension: questionsbychapterrank {type: number hidden: no group_label: "  Top N Questions"}
  dimension: questionsbytextranking {type: number hidden: no group_label: "  Top N Questions"}
  dimension: questionsbysubdisciplineranking {type: number hidden: no group_label: "  Top N Questions"}
  dimension: questionsbydisciplineranking {type: number hidden: no group_label: "  Top N Questions"}
  dimension: textbookbysubdisciplineranking {type: number hidden: no group_label: "  Top N Questions"}
  dimension: textbookbydisciplineranking {type: number hidden: no group_label: "  Top N Questions"}
  dimension: question_slcount {type: number hidden: no group_label: "  Top N Questions"}
  dimension: textbook_slcount {type: number hidden: no group_label: "  Top N Questions"}
  dimension: rank { type: number group_label: "  Top N Questions" }
  dimension: rank_2 {type: number group_label: "  Top N Questions"}
  dimension: rank_group {
    type: tier
    label: "Ranking Tiers"
    group_label: "  Top N Questions"
    tiers:[25, 50, 75, 100, 125, 150, 175, 200, 225, 250]
    style: integer
    sql: ${rank} ;;
  }

  dimension: rank_group_2 {
    type: tier
    label: "Ranking Tiers (2)"
    group_label: "  Top N Questions"
    tiers:[10,20,30,40,50,60,70,80,90,100]
    style: integer
    sql: ${rank_2} ;;
  }

#  measure: count {type:count}
}
