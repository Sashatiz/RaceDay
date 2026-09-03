-- =============================================
-- RaceDay Database
-- PROG6212 Programming 2B - Part 1
-- =============================================

-- Create Database
IF DB_ID('RaceDay') IS NULL
BEGIN
    CREATE DATABASE RaceDay;
END
GO
USE RaceDay;
GO

-- =============================================
-- DROP TABLES IF THEY ALREADY EXIST
-- =============================================

DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Enrolments;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Roles;
GO

-- =============================================
-- 1. ROLES
-- =============================================

CREATE TABLE Roles
(
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);
GO

-- =============================================
-- 2. USERS
-- =============================================

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleID)
        REFERENCES Roles(RoleID)
);
GO

-- =============================================
-- 3. EVENTS
-- =============================================

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName VARCHAR(150) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    Location VARCHAR(150) NOT NULL,
    EventType VARCHAR(20) NOT NULL,
    EventDate DATE NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Events_Users
        FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID),

    CONSTRAINT CK_Events_EventType
        CHECK (EventType IN ('Run', 'Walk', 'Cycle')),

    CONSTRAINT CK_Events_Distance
        CHECK (Distance > 0)
);
GO

-- =============================================
-- 4. CATEGORIES
-- =============================================

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    Description VARCHAR(250) NOT NULL,

    CONSTRAINT FK_Categories_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
);
GO

-- =============================================
-- 5. ENROLMENTS
-- =============================================

CREATE TABLE Enrolments
(
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Status VARCHAR(30) NOT NULL DEFAULT 'Confirmed',

    CONSTRAINT FK_Enrolments_Participant
        FOREIGN KEY (ParticipantID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Enrolments_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT FK_Enrolments_Category
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT CK_Enrolments_Status
        CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled'))
);
GO

-- =============================================
-- 6. RESULTS
-- =============================================

CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NOT NULL,
    FinishPosition INT NOT NULL,
    RecordedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Results_Enrolments
        FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolments(EnrolmentID),

    CONSTRAINT CK_Results_Position
        CHECK (FinishPosition > 0)
);
GO

-- =============================================
-- INSERT ROLES
-- =============================================

INSERT INTO Roles (RoleName)
VALUES
('Organiser'),
('Participant');
GO

-- =============================================
-- INSERT USERS
-- 2 Organisers
-- 2 Participants
-- =============================================

INSERT INTO Users
    (RoleID, FullName, Email, PasswordHash, PhoneNumber)
VALUES
(1, 'Hancy Tizora ', 'htizora@gmail.com',
 'HASHED_PASSWORD_1', '0725668282'),

(1, 'Linda Mashave', 'lindmash81@icloud.com',
 'HASHED_PASSWORD_2', '0604129326'),

(2, 'Sasha Tizora', 'sashatizzy@gmail.com',
 'HASHED_PASSWORD_3', '0839951521'),

(2, 'Ayanda Mugura', 'ayandamugura@icloud.com',
 'HASHED_PASSWORD_4', '0825436295');
GO

-- =============================================
-- INSERT EVENTS
-- 3 EVENTS
-- =============================================

INSERT INTO Events
    (OrganiserID, EventName, Description, Location,
     EventType, EventDate, Distance)
VALUES
(1,
 'Polokwane City Run',
 'A community road running event through Polokwane.',
 'Polokwane,Limpopo',
 'Run',
 '2026-09-20',
 10.00),

(1,
 'Johannesburg City Walk',
 'Move with impact, walking event through Johannesburg',
 'Johannesburg, Gauteng',
 'Walk',
 '2026-10-15',
 5.00),

(2,
 'Cape Town Cycle Challenge',
 'A competitive cycling event through Cape Town.',
 'Cape Town, Western Cape',
 'Cycle',
 '2026-11-02',
 42.00);
GO

-- =============================================
-- INSERT CATEGORIES
-- Categories for each event
-- =============================================

INSERT INTO Categories
    (EventID, CategoryName, Description)
VALUES
(1, 'Under 20', 'Participants younger than 20 years.'),
(1, 'Senior', 'Adult participants aged 20 to 39.'),
(1, 'Masters', 'Participants aged 40 years and above.'),

(2, 'Junior Walk', 'Participants under 20 years.'),
(2, 'Senior Walk', 'Adult recreational walkers.'),

(3, 'Open Cycling', 'Open competitive cycling category.'),
(3, 'Masters Cycling', 'Cyclists aged 40 years and above.');
GO

-- =============================================
-- INSERT ENROLMENTS
-- Sample Participant enrolments
-- =============================================

INSERT INTO Enrolments
    (ParticipantID, EventID, CategoryID, Status)
VALUES
(3, 1, 2, 'Confirmed'),
(4, 1, 1, 'Confirmed'),
(3, 2, 5, 'Confirmed'),
(4, 3, 6, 'Confirmed');
GO

-- =============================================
-- INSERT RESULTS
-- Sample completed results
-- =============================================

INSERT INTO Results
    (EnrolmentID, FinishTime, FinishPosition)
VALUES
(1, '01:02:35', 47),
(2, '01:15:20', 89);
GO

-- =============================================
-- VERIFY DATA
-- =============================================

SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM Enrolments;
SELECT * FROM Results;
GO