include: "/webassign/user_sso_guid.view.lkml"
view: user_sso_guid_zcm {
  extends: [user_sso_guid]



################## Minor Adjustments (Not New) #######################

  dimension: userid {
    primary_key:  yes
    }

  measure: count {
    label: "# of Users"
  }

 }
