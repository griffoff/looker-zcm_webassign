include: "/webassign/dim_assignment.view.lkml"

view: dim_assignment_zcm {
  extends: [dim_assignment]



  dimension: category_bucket {
    type: string
    group_label: "  Chip's Additions"
    sql: CASE
            WHEN (lower(${category}) = 'exam'
                    OR lower(${category})= 'final exam'
                    OR lower(${category}) LIKE '%mid term%'
                ) THEN 'Exam'
            WHEN (lower(${category}) LIKE '%homework%'
                    OR lower(${category}) LIKE '%assigned%'
                    OR lower(${category}) LIKE '% hw%'
                ) THEN 'Homework'
            WHEN lower(${category}) = 'in_class' THEN 'In Class'
            WHEN lower(${category}) = 'quiz' THEN 'Quiz'
            WHEN lower(${category}) = 'lab' THEN 'Lab'
            WHEN lower(${category}) = 'test' THEN 'Test'
            WHEN (lower(${category}) LIKE '%practice%'
                    OR lower(${category}) LIKE '%optional%'
                    OR lower(${category}) LIKE '%prep%'
                    OR lower(${category}) LIKE '%review%'
                    OR lower(${category}) LIKE '%familiar%'
                    OR lower(${category}) LIKE '%ungraded%'
                    OR lower(${category}) LIKE '%not graded%'
                    OR lower(${category}) LIKE '%preperation%'
                    OR lower(${category}) LIKE '%tutorial%'
                    OR lower(${category}) LIKE '%pre%'
                ) THEN 'Practice'
            WHEN (lower(${category}) LIKE '%extra%'
                    OR lower(${category}) LIKE '%bonus%'
                ) THEN 'Extra Credit'
            ELSE 'Other'
          END
 ;;
  }

  dimension: author_name {
    hidden: no
    }

  dimension: pool {
    description: "Group of similar questions that are randomly selected to fill the spot of one question for an assignment"
  }

  dimension: smw_mode {
    description: "'Show My Work' requires students to show work. value = optimal, disabled, required"
  }

  dimension: smw_value {
    description: "'Show My Work' requires students to show work. value = optimal, disabled, required"
  }


}
