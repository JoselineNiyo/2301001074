-- 2301001074_Joseline
-- SMART HOME AUTOMATION SYSTEM 
/* Description of my project: A smart home automation system involves using a database to store, manage,
 and organize data related to smart devices, users, and their  connections  within the home.
 The database acts as the central hub for storing information about devices (lights, sensors, security cameras),
 users (favorites, access rights), and rooms (device relations, settings).*/
 show databases;
create database Smart_Home_Automation_System;
use Smart_Home_Automation_System;
show tables;
CREATE TABLE User (
    UserID INT PRIMARY KEY,          
    Name VARCHAR(100) NOT NULL,       
    Role VARCHAR(50) NOT NULL,        
    Preferences TEXT                
);
CREATE TABLE Device (
    DeviceID INT PRIMARY KEY,        
    DeviceType VARCHAR(50) NOT NULL,  
    Status BOOLEAN NOT NULL,          
    Settings TEXT,                    
    RoomID INT,                       
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID) 
);

CREATE TABLE Room (
    RoomID INT PRIMARY KEY,       
    RoomName VARCHAR(50) NOT NULL   
);
CREATE TABLE User_Device (
    UserID INT,                   
    DeviceID INT,                     
    PRIMARY KEY (UserID, DeviceID),   
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (DeviceID) REFERENCES Device(DeviceID)
);
-- 2301001074_Joseline
-- insert into user table
INSERT INTO User (UserID, Name, Role, Preferences)
VALUES
 (1, 'Aliane', 'Admin', 'Temp: 22°C, Light: 75%'),
 (2, 'Josiane', 'Guest', 'Temp: 20°C, Light: 50%'),
 (3, 'James', 'Admin', 'Temp: 18°C, Light: 100%');
 select* from User;
-- insert into device table
INSERT INTO Device (DeviceID, DeviceType, Status, Settings, RoomID)
VALUES 
(101, 'Light', TRUE, 'Brightness: 75%', 1),
(102, 'Thermostat', FALSE, 'Temperature: 22°C', 2),
(103, 'Camera', TRUE, 'Resolution: 1080p', 3);
select* from Device;
-- insert into room table
INSERT INTO Room (RoomID, RoomName)
VALUES 
(1, 'Living Room'),
(2, 'Bedroom'),
(3, 'Kitchen');
select* from Room;
-- 2301001074_Joseline
-- Insert into user-device mappings
INSERT INTO User_Device (UserID, DeviceID)
VALUES 
(1, 101),
(2, 102),
(3, 103);
select* from User_Device;
-- insert a new user
INSERT INTO User (UserID, Name, Role, Preferences)
VALUES (4, 'Aline', 'Admin', 'Temp: 20°C, Light: 60%');
-- select 
SELECT * FROM User;
-- Update
UPDATE User
SET Preferences = 'Temp: 22°C, Light: 75%'
WHERE UserID = 1;
-- 2301001074_Joseline
-- Delete a user
DELETE FROM User
WHERE User = 1;
show tables;
-- Count
SELECT COUNT(*) AS TotalUsers FROM User;
-- AVG
SELECT AVG(DeviceCount) AS AvgDevicesPerUser
FROM (
    SELECT UserID, COUNT(DeviceID) AS DeviceCount
    FROM User_Device
    GROUP BY UserID) AS UserDeviceCount;
-- insert a new device 
INSERT INTO Device (DeviceID, DeviceType, Status, Settings, RoomID)
VALUES (104, 'Smart Lock', TRUE, 'Security: Enabled', 4);
-- read
SELECT * FROM Device;
-- 2301001074_Joseline
-- update
UPDATE Device
SET Status = FALSE
WHERE DeviceID = 101;
-- delete a device
DELETE FROM Device
WHERE DeviceID = 101;
-- Count the number of devices per room
SELECT RoomID, COUNT(*) AS DeviceCount
FROM Device
GROUP BY RoomID;
-- Average status of devices in each room
SELECT RoomID, AVG(CASE WHEN Status = TRUE THEN 1 ELSE 0 END) AS AvgDeviceStatus
FROM Device
GROUP BY RoomID;
-- Total number of devices across all rooms
SELECT SUM(DeviceCount) AS TotalDevices
FROM (
    SELECT COUNT(*) AS DeviceCount
    FROM Device
    GROUP BY RoomID
) AS DeviceRoomCount;
-- Insert a new room
INSERT INTO Room (RoomID, RoomName)
VALUES (4, 'Office');
-- 2301001074_Joseline
-- get all rooms
SELECT * FROM Room;
-- update the room name
UPDATE Room
SET RoomName = 'Kitchen'
WHERE RoomID = 1;
-- delete a room
DELETE FROM Room
WHERE RoomID = 1;
-- count the number of rooms
SELECT COUNT(*) AS TotalRooms FROM Room;
-- Average number of device per room
SELECT AVG(DeviceCount) AS AvgDevicesPerRoom
    FROM (
    SELECT RoomID, COUNT(*) AS DeviceCount
    FROM Device
    GROUP BY RoomID) AS RoomDeviceCount; 
    -- Sum of all devices across rooms
    SELECT SUM(DeviceCount) AS TotalDevicesInRooms
    FROM (
    SELECT RoomID, COUNT(*) AS DeviceCount
    FROM Device
    GROUP BY RoomID) AS RoomDeviceCount;
    -- Map a user to  device
    INSERT INTO User_Device (UserID, DeviceID)
     VALUES (1, 101);  
-- Get all user-device mappings
SELECT * FROM User_Device;
-- Update user-device mapping
UPDATE User_Device
SET DeviceID = 102
WHERE UserID = 1 AND DeviceID = 101;
-- Delete a user-device mapping
DELETE FROM User_Device
WHERE UserID = 1 AND DeviceID = 101;
SELECT * FROM User_Device;
-- Count the number of devices controlled by each user
SELECT UserID, COUNT(DeviceID) AS DeviceCount
FROM User_Device
GROUP BY UserID;
-- 2301001074_Joseline
-- Average number of devices controlled by each user
SELECT AVG(DeviceCount) AS AvgDevicesPerUser
     FROM (
    SELECT UserID, COUNT(DeviceID) AS DeviceCount
    FROM User_Device
    GROUP BY UserID) AS UserDeviceCount;
-- Sum of all devices controlled by users
SELECT SUM(DeviceCount) AS TotalDevicesControlled
    FROM (
    SELECT UserID, COUNT(DeviceID) AS DeviceCount
    FROM User_Device
    GROUP BY UserID) AS UserDeviceCount;
    show tables;
    select* from Room;
    -- 2301001074_Joseline
    -- views
    -- Show all users with their preferences
CREATE VIEW UserPreferences AS
SELECT UserID, Name, Preferences
FROM User;
-- 2301001074_Joseline
-- Show all devices with their status and room
CREATE VIEW DeviceStatus AS
SELECT Device.DeviceID, Device.DeviceType, Device.Status, Room.RoomName
FROM Device
INNER JOIN Room ON Device.RoomID = Room.RoomID;

-- Show all devices controlled by each user
CREATE VIEW UserDeviceControl AS
SELECT User.Name AS UserName, Device.DeviceType AS DeviceName
FROM User_Device
INNER JOIN User ON User_Device.UserID = User.UserID
INNER JOIN Device ON User_Device.DeviceID = Device.DeviceID;
-- 2301001074_Joseline
-- Show the number of devices in each room
CREATE VIEW RoomDeviceCount AS
SELECT Room.RoomName, COUNT(Device.DeviceID) AS DeviceCount
FROM Room
LEFT JOIN Device ON Room.RoomID = Device.RoomID
GROUP BY Room.RoomName;
-- 2301001074_Joseline
-- Show user details with the number of devices they control
CREATE VIEW UserDeviceCount AS
SELECT User.Name AS UserName, COUNT(Device.DeviceID) AS DevicesControlled
FROM User_Device
INNER JOIN User ON User_Device.UserID = User.UserID
INNER JOIN Device ON User_Device.DeviceID = Device.DeviceID
GROUP BY User.Name;

-- Show all devices and their corresponding room
CREATE VIEW DeviceRoomDetails AS
SELECT Device.DeviceID, Device.DeviceType, Room.RoomName
FROM Device
INNER JOIN Room ON Device.RoomID = Room.RoomID;
-- 2301001074_Joseline
-- Stored procedure
-- This stored procedure will allow the addition of a new user to the User table.
DELIMITER $$

CREATE PROCEDURE AddNewUser(
    IN UserID INT,
    IN Name VARCHAR(100),
    IN Role VARCHAR(50),
    IN Preferences TEXT
)
BEGIN
    INSERT INTO User (UserID, Name, Role, Preferences)
    VALUES (UserID, Name,Role,Preferences);
END $$
DELIMITER ;
CALL AddNewUser(5,'John', 'Guest', 'Temp: 24°C, Light: 50%');
-- This stored procedure will allow you to update the settings of a device based on its deviceID.
DELIMITER $$

CREATE PROCEDURE UpdateDeviceSettings(
    IN DeviceID INT,
    IN NewSettings TEXT
)
BEGIN
    UPDATE Device
    SET Settings = NewSettings
    WHERE DeviceID = DeviceID;
END $$
DELIMITER ;
CALL UpdateDeviceSettings(101, 'Brightness: 80%');
-- 2301001074_Joseline
-- This stored procedure allows mapping a user to a device by inserting the mapping into the User_Device table.
DELIMITER $$

CREATE PROCEDURE AssignDeviceToUser(
    IN UserID INT,
    IN DeviceID INT
)
BEGIN
    INSERT INTO User_Device (UserID, DeviceID)
    VALUES (UserID,DeviceID);
END $$
DELIMITER ;
CALL AssignDeviceToUser(2, 103);
-- 2301001074_Joseline
-- This stored procedure will change the status of a device based on the device ID.
DELIMITER $$

CREATE PROCEDURE ChangeDeviceStatus(
    IN DeviceID INT,
    IN NewStatus BOOLEAN
)
BEGIN
    UPDATE Device
    SET Status = NewStatus
    WHERE DeviceID = DeviceID;
END $$

DELIMITER ;
CALL ChangeDeviceStatus(102, TRUE);

-- 2301001074_Joseline
-- This stored procedure will return the number of devices controlled by a specific user.
DELIMITER $$

CREATE PROCEDURE GetUserDeviceCount(
    IN UserID INT
)
BEGIN
    SELECT COUNT(DeviceID) AS DeviceCount
    FROM User_Device
    WHERE UserID = UserID;
END $$

DELIMITER ;
CALL GetUserDeviceCount(3);

-- This stored procedure will return all devices within a specific room.
DELIMITER $$

CREATE PROCEDURE GetDevicesInRoom(
    IN RoomID INT
)
BEGIN
    SELECT Device.DeviceID, Device.DeviceType, Device.Status
    FROM Device
    WHERE Device.RoomID = RoomID;
END $$
DELIMITER ;
CALL GetDevicesInRoom(2);
-- 2301001074_Joseline
-- Trigger for User Table: After Insert
DELIMITER $$
CREATE TRIGGER AfterUserInsert
AFTER INSERT ON User
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('INSERT', 'User', NEW.UserID, NOW());
END $$
DELIMITER ;
--  Trigger for User Table: After Update
DELIMITER $$

CREATE TRIGGER AfterUserUpdate
AFTER UPDATE ON User
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('UPDATE', 'User', NEW.UserID, NOW());
END $$

DELIMITER ;
-- Trigger for User Table: After Delete
DELIMITER $$

CREATE TRIGGER AfterUserDelete
AFTER DELETE ON User
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('DELETE', 'User', OLD.UserID, NOW());
END $$

DELIMITER ;
-- Trigger for Device Table: After Insert
DELIMITER $$

CREATE TRIGGER AfterDeviceInsert
AFTER INSERT ON Device
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('INSERT', 'Device', NEW.DeviceID, NOW());
END $$

DELIMITER ;
-- Trigger for Device Table: After Update
DELIMITER $$

CREATE TRIGGER AfterDeviceUpdate
AFTER UPDATE ON Device
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('UPDATE', 'Device', NEW.DeviceID, NOW());
END $$

DELIMITER ;
-- Trigger for Device Table: After Delete
DELIMITER $$
-- 2301001074_Joseline
CREATE TRIGGER AfterDeviceDelete
AFTER DELETE ON Device
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('DELETE', 'Device', OLD.DeviceID, NOW());
END $$

DELIMITER ;
-- Trigger for Room Table: After Insert
DELIMITER $$

CREATE TRIGGER AfterRoomInsert
AFTER INSERT ON Room
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('INSERT', 'Room', NEW.RoomID, NOW());
END $$

DELIMITER ;
-- Trigger for Room Table: After Update
DELIMITER $$

CREATE TRIGGER AfterRoomUpdate
AFTER UPDATE ON Room
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('UPDATE', 'Room', NEW.RoomID, NOW());
END $$

DELIMITER ;
-- Trigger for Room Table: After Delete
DELIMITER $$

CREATE TRIGGER AfterRoomDelete
AFTER DELETE ON Room
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('DELETE', 'Room', OLD.RoomID, NOW());
END $$
DELIMITER ;
-- Trigger for User_Device Table: After Insert
DELIMITER $$

CREATE TRIGGER AfterUserDeviceInsert
AFTER INSERT ON User_Device
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('INSERT', 'User_Device', CONCAT(NEW.UserID, '-', NEW.DeviceID), NOW());
END $$

DELIMITER ;
-- Trigger for User_Device Table: After Update
DELIMITER $$
-- 2301001074_Joseline
CREATE TRIGGER AfterUserDeviceUpdate
AFTER UPDATE ON User_Device
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('UPDATE', 'User_Device', CONCAT(OLD.UserID, '-', OLD.DeviceID), NOW());
END $$
DELIMITER ;

-- Trigger for User_Device Table: After Delete
DELIMITER $$

CREATE TRIGGER AfterUserDeviceDelete
AFTER DELETE ON User_Device
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (Action, TableAffected, RecordID, ActionTime)
    VALUES ('DELETE', 'User_Device', CONCAT(OLD.UserID, '-', OLD.DeviceID), NOW());
END $$

DELIMITER ;
-- 2301001074_Joseline
-- Audit Log Table to store the action logs
CREATE TABLE AuditLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Action VARCHAR(50),
    TableAffected VARCHAR(50),
    RecordID VARCHAR(50),
    ActionTime DATETIME
);





















