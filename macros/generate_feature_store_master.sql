{% macro generate_feature_store_master(raw_table_name, pk, logic_time) -%}

{%- call statement(name='get_columns', fetch_result=True) -%}
    SELECT
        column_name
    FROM
        information_schema.columns
    WHERE table_schema = 'RAW_DATA'
    AND table_name = '{{raw_table_name}}'
    AND column_name != '{{pk}}'
{%- endcall -%}

{%- set columns = load_result('get_columns')['data'] -%}
{%- set raw_table = ['{{raw_table_name}}'] -%}

{% if execute %}
{% for column in columns %}
        SELECT 
        '{{raw_table_name}}' AS "ENTITY_ID", 
        {{pk}} AS "ENTITY_KEY_ID", 
        '{{column[0]}}' AS "FEATURE_NAME", 
        CAST({{column[0]}} AS varchar(255))AS "VALUE", 
        '{{logic_time}}' AS "CTL_LOGIC_TIME", 
        current_timestamp() AS "CTL_PROCESSED_TIME",
        '31-12-9999' AS "CTL_VALID_TO"
        FROM raw_data.{{raw_table_name}}
        {# FROM {{ ref('raw_table[1]') }} #}
        {% if not loop.last %}
            UNION
        {% endif %}
{% endfor %}
{% endif %}

{%- endmacro %}