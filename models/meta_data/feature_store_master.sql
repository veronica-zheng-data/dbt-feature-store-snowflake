-- depends_on: {{ ref('customers') }}
-- depends_on: {{ ref('orders') }}
-- depends_on: {{ ref('payments') }}

{{
    config(
        materialized = 'table'
    )
}}

WITH feature AS(

    SELECT
        feature_name,
        feature_id
    FROM
        {{ ref('feature_store_metadata') }}
),
temp AS (
        {{ generate_feature_store_master(
            "CUSTOMERS",
            "ID",
            "2020-06-21"
        ) }}
    UNION
        {{ generate_feature_store_master(
            "ORDERS",
            "ID",
            "2020-06-20"
        ) }}
    UNION
        {{ generate_feature_store_master(
            "PAYMENTS",
            "ID",
            "2020-06-22"
        ) }}    
)
SELECT
    t.entity_id,
    t.entity_key_id,
    f.feature_id,
    t.value,
    t.ctl_logic_time,
    t.ctl_processed_time,
    t.ctl_valid_to
FROM
    temp t
    LEFT JOIN feature f
    ON lower(t.feature_name) = f.feature_name

/*
WITH feature AS(

    SELECT
        feature_name,
        feature_id
    FROM
        {{ ref('feature_store_metadata') }}
),

customers AS(
    SELECT
        'customers' AS "ENTITY_ID",
        id AS "ENTITY_KEY_ID",
        'first_name' AS "FEATURE_NAME",
        first_name AS "VALUE",
        '2021-06-07' AS "LOGIC_TIME",
        CAST(getdate() AS DATE) AS "PROCESSED_TIME"
    FROM
        {{ ref('customers') }}
    UNION
    SELECT
        'customers' AS "ENTITY_ID",
        id AS "ENTITY_KEY_ID",
        'last_name' AS "FEATURE_NAME",
        last_name AS "VALUE",
        '2021-06-07' AS "LOGIC_TIME",
        CAST(getdate() AS DATE) AS "PROCESSED_TIME"
    FROM
        {{ ref('customers') }}
)
SELECT
    c.entity_id,
    c.entity_key_id,
    f.feature_id,
    c.value,
    c.logic_time,
    c.processed_time
FROM
    customers c
    LEFT JOIN feature f
    ON c.feature_name = f.feature_name
*/