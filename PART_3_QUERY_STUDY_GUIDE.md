# Part 3 SQL query study guide

This guide accompanies `PART_3_SIMPLE_SQLPLUS_QUERIES.sql`. The file contains 20 reporting queries and five safe data-manipulation commands.

## Basic retrieval

- `SELECT` reads data from a table.
- Selecting named columns keeps output easier to read than `SELECT *`.
- `WHERE` filters individual rows.
- `ORDER BY` sorts the result. `ASC` means ascending and `DESC` means descending.
- `DISTINCT` removes repeated values from the displayed result.

## Conditions

- `AND` requires every connected condition to be true.
- `OR` requires at least one connected condition to be true.
- `IN` checks a value against a list.
- `BETWEEN` checks an inclusive range, so both boundary values are included.
- `LIKE 'L%'` finds text beginning with `L`. The percent sign represents any number of characters.

## Calculations and summaries

- `Capacity - Occupied_Space` calculates available space.
- `ROUND(number, 2)` keeps two decimal places.
- `CASE` creates labels from conditions.
- `COUNT` counts rows.
- `SUM` adds values.
- `AVG` calculates the mean.
- `MIN` and `MAX` return the smallest and largest values.
- `GROUP BY` creates a separate summary for each group.
- `HAVING` filters grouped results. `WHERE` filters rows before grouping.

## Joins and subqueries

- An inner `JOIN` returns rows with matching key values in both tables.
- `Inventory.Product_ID` connects inventory to `Warehouse_Product.Product_ID`.
- `Inventory.Location_ID` connects inventory to `Storage_Location.Location_ID`.
- A `LEFT JOIN` keeps every row from the table on the left, even when no related row exists.
- A subquery is a query inside another query. Query 19 calculates average quantity first and then finds quantities above that average.

## Data manipulation and transaction control

- `INSERT` adds a row.
- `UPDATE` changes existing rows.
- `DELETE` removes matching rows.
- `SAVEPOINT` marks a point inside the current transaction.
- `ROLLBACK TO savepoint_name` cancels changes made after that savepoint.
- `COMMIT` permanently saves the current transaction.

The demonstration inserts employee 99, updates product 10, and deletes employee 10. The rollback cancels all three changes so the project data remains unchanged.

## Five useful viva answers

1. The project uses primary keys to identify rows uniquely.
2. Foreign keys maintain relationships between warehouse, zone, location, product, inventory, and movement data.
3. The available-space equation is `Capacity - Occupied_Space`.
4. `WHERE` filters rows, while `HAVING` filters grouped results.
5. The rollback demonstration proves that uncommitted changes can be cancelled safely.
