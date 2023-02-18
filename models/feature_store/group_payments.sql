-- depends_on: {{ ref('feature_store_metadata') }}
{{
    config(
        materialized='table'
    )
}}

{{pivot_table_func("payments")}}