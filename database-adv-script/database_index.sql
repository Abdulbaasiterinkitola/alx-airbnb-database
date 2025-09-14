-- DATABASE INDEXES FOR OPTIMIZATION - PostgreSQL

-- User table indexes
CREATE INDEX idx_user_email ON "user"(email);
CREATE INDEX idx_user_role ON "user"(role);
CREATE INDEX idx_user_created_at ON "user"(created_at);

-- Booking table indexes
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_booking_start_date ON booking(start_date);
CREATE INDEX idx_booking_status ON booking(status);

-- Property table indexes
CREATE INDEX idx_property_host_id ON property(host_id);
CREATE INDEX idx_property_location ON property(location);
CREATE INDEX idx_property_price ON property(pricepernight);
CREATE INDEX idx_property_created_at ON property(created_at);

-- Composite indexes for common query patterns
CREATE INDEX idx_booking_user_start_date ON booking(user_id, start_date);
CREATE INDEX idx_booking_property_status_date ON booking(property_id, status, start_date);

-- Performance measurement queries
EXPLAIN ANALYZE
SELECT u.first_name, b.start_date, b.total_price
FROM "user" u
JOIN booking b ON u.user_id = b.user_id
WHERE u.email = 'user@example.com';

EXPLAIN ANALYZE
SELECT name, location, pricepernight
FROM property
WHERE location = 'New York' AND pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight;