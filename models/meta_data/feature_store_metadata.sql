{{
    config(
        materialized = 'incremental',
        unique_key = 'feature_id'
    )
}}

-- customers
WITH customers AS (

    SELECT
        CAST('f00002' AS VARCHAR(30)) AS "FEATURE_ID",
        CAST('first_name' AS VARCHAR(30)) AS "FEATURE_NAME",
        CAST('1.0' AS VARCHAR(30)) AS "FEATURE_VERSION",
        CAST('Jin' AS VARCHAR(30)) AS "FEATURE_OWNER",
        CAST('customers' AS VARCHAR(30)) AS "FEATURE_GROUP",
        CAST('varchar' AS VARCHAR(30)) AS "FEATURE_TYPE",
        CAST('customer first name' AS VARCHAR(30)) AS "FEATURE_DESCRIPTION",
        CAST('' AS VARCHAR(30)) AS "FEATURE_TAGS",
        CAST(getdate() AS TIMESTAMP) AS "PROCESSED_TIME"
    UNION
    SELECT
        'f00001',
        'id',
        '1.0',
        'Jin',
        'customers',
        'varchar',
        'unique customer id',
        '',
        getdate()
    UNION
    SELECT
        'f00003',
        'last_name',
        '1.0',
        'Jin',
        'customers',
        'varchar',
        'customer last name',
        '',
        getdate()
    UNION
    SELECT
        'f00004',
        'email',
        '1.0',
        'Jin',
        'customers',
        'varchar',
        'customer email address',
        '',
        getdate()
),

-- orders
orders AS (
    SELECT
        'f00005',
        'id',
        '1.0',
        'Jin',
        'orders',
        'int',
        'unique orders id',
        '',
        getdate()
    UNION
    SELECT
        'f00006',
        'user_id',
        '1.0',
        'Jin',
        'orders',
        'int',
        'unique user id',
        '',
        getdate()
    UNION
    SELECT
        'f00007',
        'order_date',
        '1.0',
        'Jin',
        'orders',
        'varchar',
        'orders date',
        '',
        getdate()
    UNION
    SELECT
        'f00008',
        'status',
        '1.0',
        'Jin',
        'orders',
        'varchar',
        'orders status complete or not',
        '',
        getdate()
),

-- payments
payments AS (
    SELECT
        'f00009',
        'id',
        '1.0',
        'Jin',
        'payments',
        'varchar',
        'unique payment id',
        '',
        getdate()
    UNION  
    SELECT
        'f00010',
        'order_id',
        '1.0',
        'Jin',
        'payments' ,
        'varchar',
        'multiple payment id can be associated to one order id',
        '',
        getdate()
    UNION        
    SELECT
        'f00011',
        'payment_method',
        '1.0',
        'Jin',
        'payments',
        'varchar',
        'payment methods',
        '',
        getdate()
    UNION
    SELECT
        'f00012',
        'amount',
        '1.0',
        'Jin',
        'payments',
        'float',
        'amount of money',
        '',
        getdate()
) 

-- all
SELECT
    *
FROM
    customers
UNION
SELECT
    *
FROM
    orders
UNION
SELECT
    *
FROM
    payments
