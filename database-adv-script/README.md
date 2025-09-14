# SQL Joins Queries - PostgreSQL

This directory contains SQL queries demonstrating different types of joins for the ALX Airbnb Database project using PostgreSQL.

## Files

- `joins_queries.sql` - Contains the three required JOIN queries
- `README.md` - This documentation file

## Queries Included

### 1. INNER JOIN
Retrieves all bookings and the respective users who made those bookings.

### 2. LEFT JOIN  
Retrieves all properties and their reviews, including properties that have no reviews.

### 3. FULL OUTER JOIN
Retrieves all users and all bookings, even if the user has no booking or a booking is not linked to a user.

## Usage

Execute the queries in PostgreSQL:

```bash
psql -U your_username -d your_database -f joins_queries.sql
```

## Database Tables

The queries assume the following PostgreSQL tables:
- `"user"` (user is a reserved keyword in PostgreSQL, so it's quoted)
- `booking`
- `property` 
- `review`

## Notes

- PostgreSQL natively supports FULL OUTER JOIN (unlike MySQL)
- The `"user"` table name is quoted because `user` is a reserved keyword in PostgreSQL
- All queries are ordered for consistent output

# Subqueries - PostgreSQL

This directory contains SQL queries demonstrating both correlated and non-correlated subqueries for the ALX Airbnb Database project using PostgreSQL.

## Files

- `subqueries.sql` - Contains the two required subquery examples
- `README.md` - This documentation file

## Queries Included

### 1. Non-correlated Subquery
Finds all properties where the average rating is greater than 4.0 using a subquery.

**Query Type:** Non-correlated (subquery executes once independently)

### 2. Correlated Subquery
Finds users who have made more than 3 bookings.

**Query Type:** Correlated (subquery executes for each row in the outer query)

## Usage

Execute the queries in PostgreSQL:

```bash
psql -U your_username -d your_database -f subqueries.sql
```

## Database Tables

The queries use the following PostgreSQL tables:
- `"user"` 
- `booking`
- `property` 
- `review`

## Subquery Types Explained

- **Non-correlated subquery**: The inner query can run independently of the outer query
- **Correlated subquery**: The inner query references columns from the outer query and executes once for each row