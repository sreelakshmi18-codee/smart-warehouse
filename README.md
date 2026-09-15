# Smart Warehouse and Space Optimization

Oracle SQL*Plus DBMS group project covering table creation, sample data, 20 SQL queries, DML/TCL, a view, a stored procedure, a function, an explicit cursor, triggers and inventory auditing.

## Main files

- [`SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql`](SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql) — complete executable Parts 1–8 project.
- [`SMART_WAREHOUSE_PROJECT_GUIDE.md`](SMART_WAREHOUSE_PROJECT_GUIDE.md) — run instructions, section summary and suggested group folder structure.
- [`PART_3_QUERY_STUDY_GUIDE.md`](PART_3_QUERY_STUDY_GUIDE.md) — easy explanations for the 20 important queries and viva preparation.
- [`PART_3_SIMPLE_SQLPLUS_QUERIES_VERIFIED.sql`](PART_3_SIMPLE_SQLPLUS_QUERIES_VERIFIED.sql) — Part 3 as a separate SQL*Plus file.

## Run in SQL*Plus

Use a new or empty Oracle project schema, not `SYS` or `SYSDBA`:

```sql
SHOW USER;
@C:\Users\oschi\Downloads\smart_warehouse\SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql
```

Change the path if the project is stored in another folder. Do not rerun the complete script in a populated schema because the tables and sample primary-key values already exist.

The master script was validated in an isolated Oracle test schema: all sections ran without Oracle, PL/SQL or SQL*Plus errors; all stored objects were valid; and no output-truncation warning remained.

