-- DATABASE INDEXES FOR OPTIMIZATION - PostgreSQL

-- High-usage columns identified for indexing:
-- User table: user_id (PK), email (login), role (filtering)
-- Booking table: user_id (JOIN), property_id (JOIN), start_date (filtering/ordering), status (filtering)
-- Property table: property_id (PK), host_id (JOIN), location (filtering), pricepernight (ordering)

-- USER TABLE INDEXES

-- Index on email for login queries and user lookups
CREATE INDEX idx_user_email ON "user"(email);

-- Index on role for filtering users by role
CREATE INDEX idx_user_role ON "user"(role);

-- Index on created_at for chronological queries
CREATE INDEX idx_user_created_at ON "user"(created_at);

-- BOOKING TABLE INDEXES

-- Index on user_id for JOIN operations with user table
CREATE INDEX idx_booking_user_id ON booking(user_id);

-- Index on property_id for JOIN operations with property table
CREATE INDEX idx_booking_property_id ON booking(property_id);

-- Index on start_date for date range queries and ordering
CREATE INDEX idx_booking_start_date ON booking(start_date);

-- Index on status for filtering bookings by status
CREATE INDEX idx_booking_status ON booking(status);

-- Composite index for common query patterns (user bookings by date)
CREATE INDEX idx_booking_user_start_date ON booking(user_id, start_date);

-- Composite index for property bookings by status and date
CREATE INDEX idx_booking_property_status_date ON booking(property_id, status, start_date);

-- PROPERTY TABLE INDEXES

-- Index on host_id for JOIN operations with user table
CREATE INDEX idx_property_host_id ON property(host_id);

-- Index on location for location-based searches
CREATE INDEX idx_property_location ON property(location);

-- Index on pricepernight for price-based queries and ordering
CREATE INDEX idx_property_price ON property(pricepernight);

-- Index on created_at for chronological queries
CREATE INDEX idx_property_created_at ON property(created_at);

-- REVIEW TABLE INDEXES (if exists)

-- Index on property_id for property review queries
CREATE INDEX idx_review_property_id ON review(property_id);

-- Index on user_id for user review queries
CREATE INDEX idx_review_user_id ON review(user_id);

-- Index on rating for rating-based queries
CREATE INDEX idx_review_rating ON review(rating);

-- Composite index for property reviews with rating
CREATE INDEX idx_review_property_rating ON review(property_id, rating);

-- PAYMENT TABLE INDEXES (if exists)

-- Index on booking_id for payment-booking relationships
CREATE INDEX idx_payment_booking_id ON payment(booking_id);

-- Index on payment_date for temporal queries
CREATE INDEX idx_payment_date ON payment(payment_date);

-- Index on payment_method for filtering by payment type
CREATE INDEX idx_payment_method ON payment(payment_method);