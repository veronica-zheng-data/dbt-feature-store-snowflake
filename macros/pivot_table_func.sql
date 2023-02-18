{% macro pivot_table_func(raw_table_name) -%}

/*Note: Line 5, added t.FEATURE_TYPE, this is passed along as feature[2] in the list of freatures*/
{%- call statement(name='unique_feature', fetch_result=True) -%}
    SELECT DISTINCT m.FEATURE_ID, upper(t.feature_name), t.FEATURE_TYPE FROM {{ ref('feature_store_master') }} m
    LEFT JOIN {{ ref('feature_store_metadata') }} t ON m.FEATURE_ID = t.FEATURE_ID
    WHERE m.ENTITY_ID = upper('{{raw_table_name}}')
{%- endcall -%}

{%- set features = load_result('unique_feature')['data'] -%}

/*Note: feature[2] contains the type for VALUE, casts value as feature[2]. Currently no error checking*/
WITH {% for feature in features %}
    {{feature[0]}} AS (
    SELECT ENTITY_KEY_ID, CAST(VALUE AS {{feature[2]}}) AS "{{feature[1]}}" FROM {{ ref('feature_store_master') }}
    WHERE feature_id = '{{feature[0]}}')
    {% if not loop.last %}
        ,
    {% endif %}
{% endfor %}

SELECT
m.ENTITY_KEY_ID
{% for feature in features %}
, {{feature[0]}}.{{feature[1]}}
{% endfor %}
,m.CTL_LOGIC_TIME, m.CTL_PROCESSED_TIME,m.CTL_VALID_TO 
,{{dbt_utils.surrogate_key(['m.ENTITY_KEY_ID','m.ENTITY_ID','m.FEATURE_ID'] )}} as "FEATURE_HASH_ID"
FROM
{{ ref('feature_store_master') }} m
{% for feature in features %}
LEFT JOIN {{feature[0]}} ON m.ENTITY_KEY_ID = {{feature[0]}}.ENTITY_KEY_ID
{% endfor %}
WHERE  ENTITY_ID = upper('{{raw_table_name}}')


{%- endmacro %}
