-- ======================================================
-- EventProDB : sample data (Sprint 1)
-- Run AFTER 01_schema.sql
-- ======================================================
USE EventProDB;
GO

-- 10 Venues  (Venue 10 is deliberately tiny so it shows up in the "near capacity" report)
INSERT INTO Venue (VenueName, City, Capacity) VALUES
('Skyline Arena',            'Chennai',    5000),
('Marina Convention Centre', 'Chennai',    3000),
('Orchid Hall',              'Bengaluru',  1200),
('Tech Park Auditorium',     'Bengaluru',   800),
('Gateway Grounds',          'Mumbai',    10000),
('Harbour Pavilion',         'Mumbai',     2500),
('Capital Expo Hall',        'Delhi',      6000),
('Heritage Amphitheatre',    'Hyderabad',  4000),
('Lakeview Gardens',         'Kochi',      1500),
('Community Hall',           'Coimbatore',   22);

-- 12 Events (TicketsSold and Status use their DEFAULTs unless Status is given)
INSERT INTO Event (EventName, VenueID, EventDate, Status) VALUES
('Rock Nation Live',          1, '2026-03-15 19:00', 'Completed'),
('Tech Summit 2026',          2, '2026-04-20 09:00', 'Completed'),
('Spring Food Festival',      3, '2026-05-10 11:00', 'Completed'),
('Jazz Under The Stars',      4, '2026-06-18 20:00', 'Completed'),
('Startup Expo',              5, '2026-08-05 10:00', 'Completed'),
('Classical Night',           6, '2026-09-12 18:30', 'Completed'),
('Winter Music Fest',         7, '2026-12-05 17:00', 'Scheduled'),
('Cultural Carnival',         8, '2026-12-20 16:00', 'Scheduled'),
('New Year Gala',             9, '2026-12-31 21:00', 'Scheduled'),
('Local Art Showcase',       10, '2027-01-15 15:00', 'Scheduled'),
('Monsoon Beats Festival',    1, '2026-10-10 18:00', 'Cancelled'),
('Developer Conference 2027', 2, '2027-02-18 09:00', 'Scheduled');

-- 15 Attendees
INSERT INTO Attendee (FirstName, LastName, Email) VALUES
('Aarav',     'Sharma',    'aarav.sharma@example.com'),
('Diya',      'Patel',     'diya.patel@example.com'),
('Rohan',     'Iyer',      'rohan.iyer@example.com'),
('Ananya',    'Reddy',     'ananya.reddy@example.com'),
('Karthik',   'Nair',      'karthik.nair@example.com'),
('Meera',     'Menon',     'meera.menon@example.com'),
('Vikram',    'Singh',     'vikram.singh@example.com'),
('Priya',     'Krishnan',  'priya.krishnan@example.com'),
('Arjun',     'Das',       'arjun.das@example.com'),
('Sneha',     'Joshi',     'sneha.joshi@example.com'),
('Rahul',     'Verma',     'rahul.verma@example.com'),
('Kavya',     'Rao',       'kavya.rao@example.com'),
('Siddharth', 'Gupta',     'siddharth.gupta@example.com'),
('Lakshmi',   'Narayanan', 'lakshmi.narayanan@example.com'),
('Ishaan',    'Kapoor',    'ishaan.kapoor@example.com');

-- 10 Vendors
INSERT INTO Vendor (VendorName, ServiceType) VALUES
('Spice Route Catering',  'Catering'),
('BrightBeam Lighting',   'Lighting'),
('SoundWave Audio',       'Sound'),
('SecureGuard Services',  'Security'),
('StageCraft Builders',   'Staging'),
('CleanSweep Crew',       'Housekeeping'),
('SnapMoments Studio',    'Photography'),
('GreenRoom Decor',       'Decor'),
('FleetMove Transport',   'Transport'),
('FirstAid Medical Team', 'Medical');

-- 12 Vendor bookings.
-- BookingDate = the date the vendor is booked to work (= the event's date).
-- The double-booking rule compares this date. Every vendor appears at most once per date.
-- Event 5 (Startup Expo) has a very expensive vendor, so it will LOSE money in the report.
INSERT INTO VendorBooking (EventID, VendorID, BookingDate, Cost) VALUES
(1,  1,  '2026-03-15', 12000.00),
(1,  3,  '2026-03-15',  9000.00),
(2,  2,  '2026-04-20',  8000.00),
(3,  1,  '2026-05-10', 15000.00),
(4,  3,  '2026-06-18', 10000.00),
(5,  5,  '2026-08-05', 60000.00),
(6,  7,  '2026-09-12',  6000.00),
(7,  4,  '2026-12-05',  9000.00),
(8,  8,  '2026-12-20',  7000.00),
(9,  9,  '2026-12-31',  5000.00),
(10, 6,  '2027-01-15',  2500.00),
(12, 10, '2027-02-18',  4000.00);

-- 240 Tickets, generated with a loop (20 tickets for each of the 12 events)
DECLARE @i      INT = 1;                      -- loop counter
DECLARE @ev     INT;                          -- event for this ticket
DECLARE @vip    BIT;                          -- 1 = VIP ticket
DECLARE @evDate DATETIME2;                    -- date of that event
DECLARE @base   DATETIME2;                    -- date we count back from
DECLARE @cutoff DATETIME2 = '2026-11-20';     -- "today" for the sample data

WHILE @i <= 240
BEGIN
    SET @ev  = (@i % 12) + 1;                          -- % = remainder, gives events 1..12 in turn
    SET @vip = CASE WHEN @i % 5 = 0 THEN 1 ELSE 0 END; -- every 5th ticket is VIP

    SELECT @evDate = EventDate FROM Event WHERE EventID = @ev;
    -- tickets are bought before the event, and never after "today"
    SET @base = CASE WHEN @evDate > @cutoff THEN @cutoff ELSE @evDate END;

    INSERT INTO Ticket (EventID, AttendeeID, TicketType, Price, PurchaseDate)
    VALUES (
        @ev,
        (@i % 15) + 1,                                              -- attendee 1..15 in turn
        CASE WHEN @vip = 1 THEN 'VIP' ELSE 'GeneralAdmission' END,
        CASE WHEN @vip = 1 THEN 3000.00 + @ev * 250                 -- VIP price
                           ELSE 1000.00 + @ev * 100 END,            -- general price
        DATEADD(DAY, -((@i % 30) + 1), @base)                       -- 1..30 days before @base
    );

    SET @i = @i + 1;
END;
GO

-- Make Event.TicketsSold match the tickets actually inserted
UPDATE e
SET e.TicketsSold = (SELECT COUNT(*) FROM Ticket t WHERE t.EventID = e.EventID)
FROM Event e;
GO

-- CHECK 1: row count per table
SELECT 'Venue' AS TableName, COUNT(*) AS TotalRows FROM Venue
UNION ALL SELECT 'Event',         COUNT(*) FROM Event
UNION ALL SELECT 'Attendee',      COUNT(*) FROM Attendee
UNION ALL SELECT 'Ticket',        COUNT(*) FROM Ticket
UNION ALL SELECT 'Vendor',        COUNT(*) FROM Vendor
UNION ALL SELECT 'VendorBooking', COUNT(*) FROM VendorBooking;

-- CHECK 2: tickets sold vs venue capacity (must never exceed 100%)
SELECT e.EventID, e.EventName, e.Status, e.TicketsSold, v.Capacity,
       CAST(100.0 * e.TicketsSold / v.Capacity AS DECIMAL(5,1)) AS PercentFull
FROM Event e
JOIN Venue v ON v.VenueID = e.VenueID
ORDER BY e.EventID;