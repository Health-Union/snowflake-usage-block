connection: "hu_snowflake"

# include all the views
include: "*.view"

# include all the dashboards
include: "account_usage_dashboard.dashboard.lookml"

datagroup: snowflake_usage_block_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

access_grant: can_see_snowflake_usage_data {
  user_attribute: can_see_snowflake_usage_data
  allowed_values: ["yes"]
}

named_value_format: conditional_to_millions {
  value_format: "[>=1000000]0,,\"M\";[>=1000]0,\"K\";0"
}

persist_with: snowflake_usage_block_default_datagroup

explore: login_history {
  required_access_grants: [can_see_snowflake_usage_data]
}

explore: query_history {
  join: databases {
    type: left_outer
    sql_on: ${query_history.database_name} = ${databases.database_name} ;;
    relationship: many_to_one
  }
  required_access_grants: [can_see_snowflake_usage_data]

#   join: schemata {
#     type: left_outer
#     sql_on: ${databases.id} = ${schemata.id} ;;
#     relationship: one_to_many
#   }
}

# explore: schemata {
#   join: databases {
#     type: left_outer
#     sql_on: ${schemata.database_id} = ${databases.id} ;;
#     relationship: many_to_one
#   }
# }

explore: load_history {
  fields: [ALL_FIELDS*,-tables.table_name,-tables.id]
  join: tables {
    sql_on: ${load_history.table_id} = ${tables.id} ;;
    relationship: many_to_one
  }
  required_access_grants: [can_see_snowflake_usage_data]
}

explore: storage_usage {
  required_access_grants: [can_see_snowflake_usage_data]
}

explore: warehouse_metering_history {
  required_access_grants: [can_see_snowflake_usage_data]
}

# explore: columns {}
#
# explore: databases {}
#
# explore: file_formats {}
#
# explore: functions {}
#
# explore: referential_constraints {}
#
# explore: sequences {}
#
# explore: stages {}
#
# explore: table_constraints {}
#
# explore: table_storage_metrics {}
#
# explore: tables {}
#
# explore: views {}
