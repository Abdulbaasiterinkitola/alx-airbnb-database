# Index Performance Analysis

## High-Usage Columns Identified

### User Table
- **user_id**: Primary key, used in JOINs
- **email**: Used in WHERE clauses for login and user lookups
- **role**: Used in WHERE clauses for filtering users by type
- **created_at**: Used in ORDER BY for chronological queries

### Booking Table
- **user_id**: Foreign key, used in JOINs with user table
- **property_id**: Foreign key, used in JOINs with property table
- **start_date**: Used in WHERE clauses for date filtering and ORDER BY
- **status**: Used in WHERE clauses for filtering booking status
- **created_at**: Used in ORDER BY for chronological queries

### Property Table
- **property_id**: Primary key, used in JOINs
- **host_id**: Foreign key, used in JOINs with user table
- **location**: Used in WHERE clauses for location-based searches
- **pricepernight**: Used in WHERE clauses for price filtering and ORDER BY
- **created_at**: Used in ORDER BY for chronological queries

## Created Indexes

### Single Column Indexes
```sql
-- User table
CREATE INDEX idx_user_email ON "user"(email);
CREATE INDEX idx_user_role ON "user"(role);
CREATE INDEX idx_user_created_at ON "user"(created_at);

-- Booking table
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_booking_start_date ON booking(start_date);
CREATE INDEX idx_booking_status ON booking(status);

-- Property table
CREATE INDEX idx_property_host_id ON property(host_id);
CREATE INDEX idx_property_location ON property(location);
CREATE INDEX idx_property_price ON property(pricepernight);
CREATE INDEX idx_property_created_at ON property(created_at);
```

### Composite Indexes
```sql
-- For common query patterns
CREATE INDEX idx_booking_user_start_date ON booking(user_id, start_date);
CREATE INDEX idx_booking_property_status_date ON booking(property_id, status, start_date);
CREATE INDEX idx_review_property_rating ON review(property_id, rating);
```

## Performance Testing

### Before Adding Indexes

**Test Query 1: Find user bookings**
```sql
EXPLAIN ANALYZE
SELECT u.first_name, b.start_date, b.total_price
FROM "user" u
JOIN booking b ON u.user_id = b.user_id
WHERE u.email = 'user@example.com';
```

**Expected Result (Before):**
```
Nested Loop (cost=0.00..X rows=Y) (actual time=Z..W rows=N loops=1)
  -> Seq Scan on "user" u (cost=0.00..X rows=1) (actual time=Y..Z rows=1)
       Filter: (email = 'user@example.com'::text)
  -> Seq Scan on booking b (cost=0.00..X rows=Y) (actual time=Z..W rows=N)
       Filter: (user_id = u.user_id)
Planning Time: X ms
Execution Time: Y ms
```

**Test Query 2: Find properties by location and price**
```sql
EXPLAIN ANALYZE
SELECT name, location, pricepernight
FROM property
WHERE location = 'New York' AND pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight;
```

**Expected Result (Before):**
```
Sort (cost=X..Y rows=Z) (actual time=W..V rows=N loops=1)
  Sort Key: pricepernight
  -> Seq Scan on property (cost=0.00..X rows=Y) (actual time=Z..W rows=N)
       Filter: ((location = 'New York'::text) AND (pricepernight >= 100) AND (pricepernight <= 300))
Planning Time: X ms
Execution Time: Y ms
```

### After Adding Indexes

**Test Query 1: Find user bookings (After Indexes)**
```sql
EXPLAIN ANALYZE
SELECT u.first_name, b.start_date, b.total_price
FROM "user" u
JOIN booking b ON u.user_id = b.user_id
WHERE u.email = 'user@example.com';
```

**Expected Result (After):**
```
Nested Loop (cost=0.29..X rows=Y) (actual time=Z..W rows=N loops=1)
  -> Index Scan using idx_user_email on "user" u (cost=0.29..X rows=1) (actual time=Y..Z rows=1)
       Index Cond: (email = 'user@example.com'::text)
  -> Index Scan using idx_booking_user_id on booking b (cost=0.29..X rows=Y) (actual time=Z..W rows=N)
       Index Cond: (user_id = u.user_id)
Planning Time: X ms
Execution Time: Y ms (IMPROVED)
```

**Test Query 2: Find properties by location and price (After Indexes)**
```sql
EXPLAIN ANALYZE
SELECT name, location, pricepernight
FROM property
WHERE location = 'New York' AND pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight;
```

**Expected Result (After):**
```
Index Scan using idx_property_price on property (cost=0.29..X rows=Y) (actual time=Z..W rows=N loops=1)
  Index Cond: ((pricepernight >= 100) AND (pricepernight <= 300))
  Filter: (location = 'New York'::text)
Planning Time: X ms
Execution Time: Y ms (IMPROVED)
```

## Performance Improvements Expected

### Query Types That Benefit Most

1. **JOIN Operations**: Indexes on foreign keys dramatically improve JOIN performance
2. **WHERE Clause Filtering**: Indexes on frequently filtered columns reduce scan time
3. **ORDER BY Operations**: Indexes on sorting columns eliminate sort operations
4. **Range Queries**: B-tree indexes excel at range operations (BETWEEN, >, <)

### Measurable Improvements

- **Execution Time**: Typically 10-100x faster for indexed queries
- **I/O Operations**: Significant reduction in disk reads
- **CPU Usage**: Lower CPU consumption for query processing
- **Concurrency**: Better performance under high concurrent load

## Monitoring Index Usage

### Check Index Usage Statistics
```sql
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;
```

### Identify Unused Indexes
```sql
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0 AND schemaname = 'public';
```

## Best Practices Applied

1. **Primary Keys**: Automatically indexed
2. **Foreign Keys**: Manual indexes created for JOIN performance
3. **Frequently Filtered Columns**: Single-column indexes
4. **Composite Queries**: Multi-column indexes for common patterns
5. **Avoid Over-Indexing**: Only created indexes for high-usage scenarios

## Maintenance Considerations

- **Index Size**: Monitor index storage overhead
- **Write Performance**: Indexes slow INSERT/UPDATE operations
- **Maintenance**: Regular REINDEX operations for optimal performance
- **Statistics**: Keep table statistics updated with ANALYZE