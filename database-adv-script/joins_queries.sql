--INNER JOIN
SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role
FROM 
    Booking b
INNER JOIN 
    User u ON b.user_id = u.user_id
ORDER BY 
    b.created_at DESC;

--LEFT JOIN
SELECT 
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location,
    p.pricepernight,
    host.first_name AS host_first_name,
    host.last_name AS host_last_name,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date,
    guest.first_name AS reviewer_first_name,
    guest.last_name AS reviewer_last_name
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
LEFT JOIN 
    User host ON p.host_id = host.user_id
LEFT JOIN 
    User guest ON r.user_id = guest.user_id
ORDER BY 
    p.property_id, r.created_at DESC;

-- FULL OUTER JOIN
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    u.created_at AS user_registration_date,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_date
FROM 
    User u
FULL OUTER JOIN 
    Booking b ON u.user_id = b.user_id
ORDER BY 
    u.user_id, b.created_at DESC;