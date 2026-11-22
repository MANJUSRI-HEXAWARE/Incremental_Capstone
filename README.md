# EventPro – Event Management Platform 

## Overview

EventPro is a Python-based, console-driven Event Management Platform designed to simplify and streamline event operations. It provides a centralized solution for managing events, venues, attendees, ticket bookings, and vendor services through an interactive menu-driven interface.

## Key Features

- Event and venue management
- Attendee registration and management
- Ticket booking and inventory tracking
- Vendor management and booking schedules
- Refund processing for cancelled events
- Event revenue and profitability reports
- Data validation and error handling

## Technologies Used

- **Programming Language:** Python 3.13
- **Database:** Microsoft SQL Server
- **Database Management:** SQL Server Management Studio (SSMS)
- **Database Connectivity:** pyodbc
- **Testing:** pytest
- **IDE:** Visual Studio Code

## Sprint-wise Development

The project follows an incremental development approach across four sprints.

### Sprint 1 – Database Design and Implementation
- Designed the Entity Relationship Diagram (ERD).
- Created the EventProDB database with six relational tables.
- Implemented primary keys, foreign keys, and database constraints.
- Inserted sample records, including 240 ticket records.
- Validated database constraints using positive and negative test cases.

### Sprint 2 – Entity Classes and Object-Oriented Programming
- Developed Python entity classes for the database entities.
- Implemented encapsulation, inheritance, abstraction, and polymorphism.
- Created ticket types using a ticket class hierarchy.
- Implemented entity-level validation and business rules.
- Demonstrated object-oriented functionality.

### Sprint 3 – Business Logic and Service Layer
- Developed service interfaces and implementations.
- Implemented core event, venue, attendee, ticket, and vendor operations.
- Created custom exception classes for business rule violations.
- Implemented refund processing and report generation.
- Addressed concurrency scenarios, including ticket inventory and vendor booking conflicts.

### Sprint 4 – Database Integration and Application Development
- Established Python connectivity with SQL Server.
- Implemented database-backed service operations.
- Developed a menu-driven console application.
- Integrated application modules and business functionalities.
- Performed unit testing and integration testing.
- Prepared project documentation and final deliverables.

## Project Objective

To develop a reliable and structured event management solution that improves operational efficiency, maintains data consistency, prevents booking conflicts, and supports effective event planning and financial analysis.

---

**Project Type:** Incremental Capstone Project
