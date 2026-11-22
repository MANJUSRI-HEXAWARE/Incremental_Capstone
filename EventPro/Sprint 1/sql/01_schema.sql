IF DB_ID('EventProDB') IS NULL
    CREATE DATABASE EventProDB;
GO

USE EventProDB;
GO

-- Remove old tables so this script can be re-run safely.
-- Order matters: children (that hold foreign keys) are dropped before parents.
DROP TABLE IF EXISTS VendorBooking;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Vendor;
DROP TABLE IF EXISTS Attendee;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Venue;
GO

CREATE TABLE Venue (
    VenueID    INT IDENTITY(1,1) CONSTRAINT PK_Venue PRIMARY KEY,
    VenueName  NVARCHAR(100) NOT NULL,
    City       NVARCHAR(50)  NOT NULL,
    Capacity   INT NOT NULL CONSTRAINT CK_Venue_Capacity CHECK (Capacity > 0)
);

CREATE TABLE Event (
    EventID     INT IDENTITY(1,1) CONSTRAINT PK_Event PRIMARY KEY,
    EventName   NVARCHAR(150) NOT NULL,
    VenueID     INT NOT NULL CONSTRAINT FK_Event_Venue REFERENCES Venue(VenueID),
    EventDate   DATETIME2 NOT NULL,
    TicketsSold INT NOT NULL CONSTRAINT DF_Event_TicketsSold DEFAULT 0,
    Status      NVARCHAR(20) NOT NULL CONSTRAINT DF_Event_Status DEFAULT 'Scheduled'
);

CREATE TABLE Attendee (
    AttendeeID INT IDENTITY(1,1) CONSTRAINT PK_Attendee PRIMARY KEY,
    FirstName  NVARCHAR(50)  NOT NULL,
    LastName   NVARCHAR(50)  NOT NULL,
    Email      NVARCHAR(100) NOT NULL CONSTRAINT UQ_Attendee_Email UNIQUE
);

CREATE TABLE Ticket (
    TicketID     INT IDENTITY(1,1) CONSTRAINT PK_Ticket PRIMARY KEY,
    EventID      INT NOT NULL CONSTRAINT FK_Ticket_Event    REFERENCES Event(EventID),
    AttendeeID   INT NOT NULL CONSTRAINT FK_Ticket_Attendee REFERENCES Attendee(AttendeeID),
    TicketType   NVARCHAR(30) NOT NULL,
    Price        DECIMAL(10,2) NOT NULL CONSTRAINT CK_Ticket_Price CHECK (Price >= 0),
    PurchaseDate DATETIME2 NOT NULL
);

CREATE TABLE Vendor (
    VendorID    INT IDENTITY(1,1) CONSTRAINT PK_Vendor PRIMARY KEY,
    VendorName  NVARCHAR(100) NOT NULL,
    ServiceType NVARCHAR(50)  NOT NULL
);

CREATE TABLE VendorBooking (
    BookingID   INT IDENTITY(1,1) CONSTRAINT PK_VendorBooking PRIMARY KEY,
    EventID     INT NOT NULL CONSTRAINT FK_VB_Event  REFERENCES Event(EventID),
    VendorID    INT NOT NULL CONSTRAINT FK_VB_Vendor REFERENCES Vendor(VendorID),
    BookingDate DATE NOT NULL,
    Cost        DECIMAL(10,2) NOT NULL
);
GO

-- Show the tables that now exist (expect 6 rows)
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
