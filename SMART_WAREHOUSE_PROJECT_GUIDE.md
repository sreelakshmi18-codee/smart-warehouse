# Smart Warehouse and Space Optimization

This folder contains the complete Oracle SQL*Plus database project used by the group. The main reference file is:

- `SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql`

It contains every project section in the correct order, from creating the tables through triggers.

## Project sections

| Part | Topic | Main purpose |
|---|---|---|
| 1 | Table creation | Creates the seven normalized project tables with keys and constraints. |
| 2 | Data insertion | Inserts warehouses, zones, storage locations, products, inventory, movements and employees. |
| 3 | SQL and DML/TCL | Demonstrates 20 important queries plus `INSERT`, `UPDATE`, `DELETE`, `SAVEPOINT`, `ROLLBACK` and `COMMIT`. |
| 4 | View | Creates a reusable report for highly utilized locations. |
| 5 | Procedure | Adds inventory only when sufficient space is available. |
| 6 | Function | Returns the utilization percentage of a location. |
| 7 | Cursor | Reads and prints locations with at least 40% utilization. |
| 8 | Triggers | Prevents capacity overflow and records inserted inventory in an audit table. |

## How to run the complete project

Use a new or empty Oracle project account. Do not run the creation script as `SYS` or `SYSDBA`.

From SQL*Plus:

```sql
SHOW USER;
@C:\Users\oschi\Downloads\smart_warehouse\SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql
```

The file contains SQL*Plus display settings, so the output is narrow enough for readable screenshots. If a classmate stores the file elsewhere, they should replace the path with their own location.

## Important warning

Do not run the complete script again in a populated schema. Oracle will reject duplicate tables and primary-key values. The commented reset commands at the bottom are included only for students who deliberately want to delete and rebuild their own project schema.

## How to study the queries

The 20 queries in Part 3 are intentionally simple and cover concepts normally expected in a DBMS viva:

- selecting and filtering rows;
- sorting and removing duplicates;
- `AND`, `OR`, `IN`, `BETWEEN` and `LIKE`;
- arithmetic expressions and `CASE`;
- aggregate functions;
- `GROUP BY` and `HAVING`;
- inner joins and a left join;
- a subquery;
- basic data and transaction-control commands.

Read the comment immediately above each command. It identifies the feature being demonstrated. The separate `PART_3_QUERY_STUDY_GUIDE.md` file provides a longer explanation of the 20 queries.

## Files useful to the group

- `SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql` — complete Parts 1–8 source code.
- `SMART_WAREHOUSE_PROJECT_GUIDE.md` — this project guide for GitHub.
- `PART_3_QUERY_STUDY_GUIDE.md` — explanations and viva preparation for Part 3.
- `PART_3_SIMPLE_SQLPLUS_QUERIES_VERIFIED.sql` — Part 3 by itself.
- `sqlplus_demo_evidence.sql` — reruns safe demonstrations after the database exists.

## Suggested GitHub layout

```text
smart_warehouse/
|-- README.md
|-- SMART_WAREHOUSE_COMPLETE_SQLPLUS.sql
|-- SMART_WAREHOUSE_PROJECT_GUIDE.md
|-- PART_3_QUERY_STUDY_GUIDE.md
|-- diagrams/
|   |-- er_before_normalization.png
|   `-- er_after_normalization.png
`-- screenshots/
    |-- part_01/
    |-- part_02/
    |-- part_03/
    |-- part_04/
    |-- part_05/
    |-- part_06/
    |-- part_07/
    `-- part_08/
```

When the project is uploaded to GitHub, this guide can be renamed to `README.md` if the group does not already have one.

