-- depends_on: {{ ref('feature_store_metadata') }}
{{
    config(
        materialized='table'
    )
}}

{{pivot_table_func("customers")}}

/*
-- exmaple of "custmoers" table
WITH f1 AS (

  SELECT
    entity_key_id,
    VALUE
  FROM
    {{ ref('feature_store_master') }}
  WHERE
    feature_id = 'f00002'
),
f2 AS (
  SELECT
    entity_key_id,
    VALUE
  FROM
    {{ ref('feature_store_master') }}
  WHERE
    feature_id = 'f00003'
)
SELECT
  m.entity_key_id,
  m.logic_time,
  f1.value AS "FIRST_NAME",
  f2.value AS "LAST_NAME",
  m.processed_time
FROM
  {{ ref('feature_store_master') }}
  m
  LEFT JOIN f1
  ON m.entity_key_id = f1.entity_key_id
  LEFT JOIN f2
  ON m.entity_key_id = f2.entity_key_id
WHERE
  entity_id = 'customers'
*/  