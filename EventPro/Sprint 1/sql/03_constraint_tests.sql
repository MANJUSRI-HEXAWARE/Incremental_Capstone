USE EventProDB;
GO

SET NOCOUNT ON;
SET XACT_ABORT OFF;

BEGIN TRAN;

PRINT '=== 1. CHECK: Venue.Capacity > 0 ===';

BEGIN TRY
    INSERT INTO Venue (VenueName, City, Capacity)
    VALUES ('Test Venue', 'Chennai', 100);

    PRINT 'PASS: valid capacity (100) accepted';
END TRY
BEGIN CATCH
    PRINT 'FAIL: valid capacity rejected - ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    INSERT INTO Venue (VenueName, City, Capacity)
    VALUES ('Bad Venue', 'Chennai', 0);

    PRINT 'FAIL: capacity 0 was accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: capacity 0 rejected';
END CATCH


PRINT '=== 2. UNIQUE: Attendee.Email ===';

BEGIN TRY
    INSERT INTO Attendee (FirstName, LastName, Email)
    VALUES ('Test', 'User', 'test.user@example.com');

    PRINT 'PASS: new email accepted';
END TRY
BEGIN CATCH
    PRINT 'FAIL: new email rejected - ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    INSERT INTO Attendee (FirstName, LastName, Email)
    VALUES ('Dup', 'User', 'aarav.sharma@example.com');

    PRINT 'FAIL: duplicate email accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: duplicate email rejected';
END CATCH


PRINT '=== 3. CHECK: Ticket.Price >= 0 (also proves valid Ticket.EventID and Ticket.AttendeeID) ===';

BEGIN TRY
    INSERT INTO Ticket (EventID, AttendeeID, TicketType, Price, PurchaseDate)
    VALUES (1, 1, 'GeneralAdmission', 0.00, SYSDATETIME());

    PRINT 'PASS: price 0.00 accepted';
END TRY
BEGIN CATCH
    PRINT 'FAIL: price 0.00 rejected - ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    INSERT INTO Ticket (EventID, AttendeeID, TicketType, Price, PurchaseDate)
    VALUES (1, 1, 'GeneralAdmission', -5.00, SYSDATETIME());

    PRINT 'FAIL: negative price accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: negative price rejected';
END CATCH


PRINT '=== 4. DEFAULT: Event.TicketsSold = 0 and Event.Status = Scheduled ===';

INSERT INTO Event (EventName, VenueID, EventDate)
VALUES ('Default Test Event', 1, '2027-06-01 10:00');

IF EXISTS (
    SELECT 1
    FROM Event
    WHERE EventName = 'Default Test Event'
      AND TicketsSold = 0
      AND Status = 'Scheduled'
)
    PRINT 'PASS: defaults applied (TicketsSold = 0, Status = Scheduled)';
ELSE
    PRINT 'FAIL: defaults not applied';


PRINT '=== 5. FOREIGN KEY: Event.VenueID -> Venue ===';

BEGIN TRY
    INSERT INTO Event (EventName, VenueID, EventDate)
    VALUES ('FK Valid Event', 1, '2027-07-01');

    PRINT 'PASS: valid VenueID accepted';
END TRY
BEGIN CATCH
    PRINT 'FAIL: valid VenueID rejected - ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    INSERT INTO Event (EventName, VenueID, EventDate)
    VALUES ('FK Invalid Event', 999, '2027-07-01');

    PRINT 'FAIL: invalid VenueID accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: invalid VenueID (999) rejected';
END CATCH


PRINT '=== 6. FOREIGN KEY: Ticket.EventID -> Event (valid case = test 3) ===';

BEGIN TRY
    INSERT INTO Ticket (EventID, AttendeeID, TicketType, Price, PurchaseDate)
    VALUES (999, 1, 'GeneralAdmission', 50, SYSDATETIME());

    PRINT 'FAIL: invalid EventID accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: invalid EventID (999) rejected';
END CATCH


PRINT '=== 7. FOREIGN KEY: Ticket.AttendeeID -> Attendee (valid case = test 3) ===';

BEGIN TRY
    INSERT INTO Ticket (EventID, AttendeeID, TicketType, Price, PurchaseDate)
    VALUES (1, 999, 'GeneralAdmission', 50, SYSDATETIME());

    PRINT 'FAIL: invalid AttendeeID accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: invalid AttendeeID (999) rejected';
END CATCH


PRINT '=== 8. FOREIGN KEY: VendorBooking.EventID and VendorBooking.VendorID ===';

BEGIN TRY
    INSERT INTO VendorBooking (EventID, VendorID, BookingDate, Cost)
    VALUES (1, 1, '2027-01-01', 1000);

    PRINT 'PASS: valid EventID + VendorID accepted';
END TRY
BEGIN CATCH
    PRINT 'FAIL: valid booking rejected - ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    INSERT INTO VendorBooking (EventID, VendorID, BookingDate, Cost)
    VALUES (999, 1, '2027-01-02', 1000);

    PRINT 'FAIL: invalid EventID accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: invalid EventID (999) rejected';
END CATCH

BEGIN TRY
    INSERT INTO VendorBooking (EventID, VendorID, BookingDate, Cost)
    VALUES (1, 999, '2027-01-03', 1000);

    PRINT 'FAIL: invalid VendorID accepted';
END TRY
BEGIN CATCH
    PRINT 'PASS: invalid VendorID (999) rejected';
END CATCH


-- Undo all test records
ROLLBACK TRAN;

PRINT '=== All test rows rolled back ===';

-- Verify original sample data is unchanged
SELECT
    (SELECT COUNT(*) FROM Venue) AS VenueRows,
    (SELECT COUNT(*) FROM Ticket) AS TicketRows;

GO
