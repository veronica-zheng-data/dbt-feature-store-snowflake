In the Snowflake version, we need to create columns with uppercase in the first time. Otherwise, those columns cannot be used later.

```
.
├── README.md
├── analysis
├── data
│   ├── customers.csv
│   ├── orders.csv
│   ├── payments.csv
│   └── schema.yml
├── dbt_project.yml
├── macros
│   ├── custom_schema.sql
│   ├── feature_store_master_func.sql
│   └── pivot_table_func.sql
├── models
│   ├── feature_store
│   │   ├── group_customers.sql
│   │   ├── group_orders.sql
│   │   └── group_payments.sql
│   └── meta_data
│       ├── feature_store_master.sql
│       ├── feature_store_metadata.sql
│       └── schema.yml
├── packages.yml
├── snapshots
└── tests
```