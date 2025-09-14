-- TABLE PARTITIONING - PostgreSQL

-- Step 1: Create partitioned booking table based on start_date
CREATE TABLE booking_partitioned (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);

-- Step 2: Create partitions for different date ranges
-- Partition for bookings in 2023
CREATE TABLE booking_2023 PARTITION OF booking_partitioned
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for bookings in 2024
CREATE TABLE booking_2024 PARTITION OF booking_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for bookings in 2025
CREATE TABLE booking_2025 PARTITION OF booking_partitioned
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Partition for future bookings (2026 and beyond)
CREATE TABLE booking_future PARTITION OF booking_partitioned
FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- Step 3: Create indexes on partitioned table
CREATE INDEX idx_booking_part_user_id ON booking_partitioned (user_id);
CREATE INDEX idx_booking_part_property_id ON booking_partitioned (property_id);
CREATE INDEX idx_booking_part_status ON booking_partitioned (status);
CREATE INDEX idx_booking_part_start_date ON booking_partitioned (start_date);

-- Step 4: Migrate data from original booking table (if exists)
-- INSERT INTO booking_partitioned 
-- SELECT * FROM booking;

-- Step 5: Performance test queries

-- Query 1: Fetch bookings by date range (should use partition pruning)
EXPLAIN ANALYZE
SELECT 
    booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    total_price,
    status
FROM booking_partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Query 2: Fetch recent bookings (last 30 days)
EXPLAIN ANALYZE
SELECT 
    booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    total_price,
    status
FROM booking_partitioned
WHERE start_date >= CURRENT_DATE - INTERVAL '30 days';

-- Query 3: Fetch bookings for specific user in date range
EXPLAIN ANALYZE
SELECT 
    booking_id,
    property_id,
    start_date,
    end_date,
    total_price,
    status
FROM booking_partitioned
WHERE user_id = '123e4567-e89b-12d3-a456-426614174000'
AND start_date BETWEEN '2024-06-01' AND '2024-08-31';

-- Query 4: Count bookings by year (partition-wise aggregation)
EXPLAIN ANALYZE
SELECT 
    EXTRACT(YEAR FROM start_date) as booking_year,
    COUNT(*) as total_bookings,
    SUM(total_price) as total_revenue
FROM booking_partitioned
GROUP BY EXTRACT(YEAR FROM start_date)
ORDER BY booking_year;

-- Step 6: Create additional partitions as needed
-- This can be automated with a stored procedure for monthly partitions

-- Example: Create monthly partitions for 2024
CREATE TABLE booking_2024_q1 PARTITION OF booking_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE booking_2024_q2 PARTITION OF booking_partitioned  
FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE booking_2024_q3 PARTITION OF booking_partitioned
FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE booking_2024_q4 PARTITION OF booking_partitioned
FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Step 7: Drop the yearly 2024 partition and keep quarterly ones
-- ALTER TABLE booking_partitioned DETACH PARTITION booking_2024;