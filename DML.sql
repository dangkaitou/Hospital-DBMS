-- CREATE a Hospital schema
CREATE SCHEMA Hospital;

-- USE Hospital schema
USE Hospital;

-- ---------------------------------------------------------------------------------------------------------------------

-- CREATE 25 TABLES
CREATE TABLE Insurance_company (
    InsCo_id INT NOT NULL AUTO_INCREMENT,
    InsCo_name VARCHAR(50) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Tel_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (InsCo_id)
);

CREATE TABLE Patient (
    Ssn INT NOT NULL,
    Pat_name VARCHAR(50) NOT NULL,
    Sex VARCHAR(1) NOT NULL,
    DOB DATE NOT NULL,
    Age INT NOT NULL,
    Address VARCHAR(100),
    Tel_no VARCHAR(10),
    Email VARCHAR(50),
    InsCo_id INT,
    Start_date DATE,
    End_date DATE,
    PRIMARY KEY (Ssn),
    FOREIGN KEY (InsCo_id) REFERENCES Insurance_company(InsCo_id) ON DELETE SET NULL
);

CREATE INDEX idx_age
ON Patient (Age);

SHOW INDEX FROM Patient;

ALTER TABLE Patient
DROP INDEX idx_age;

CREATE TABLE Accountant (
    Acct_id INT NOT NULL AUTO_INCREMENT,
    Acct_name VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Tel_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (Acct_id)
);
-- Set up starting value
ALTER TABLE Accountant AUTO_INCREMENT = 130001;

CREATE TABLE Bill (
    Bill_no INT NOT NULL,
    Created_date DATE NOT NULL,
    Service_charge INT NOT NULL,
    Total_fee INT NOT NULL,
    InsCo_id INT,
    Discount INT,
    Ssn INT NOT NULL,
    Pur_date DATE NOT NULL,
    Pur_type VARCHAR(10) NOT NULL,
    Acct_id INT NOT NULL,
    PRIMARY KEY (Bill_no),
    FOREIGN KEY (InsCo_id) REFERENCES Insurance_company(InsCo_id),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE,
    FOREIGN KEY (Acct_id) REFERENCES Accountant(Acct_id)
);

CREATE TABLE Department (
    Dept_id INT NOT NULL AUTO_INCREMENT,
    Dept_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (Dept_id)
);

CREATE TABLE Doctor (
    Doc_id INT NOT NULL AUTO_INCREMENT,
    Doc_name VARCHAR(50) NOT NULL,
    Doc_type VARCHAR(20) NOT NULL,
    Age INT,
    Address VARCHAR(100),
    Tel_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (Doc_id)
);
-- Set up starting value
ALTER TABLE Doctor AUTO_INCREMENT = 110001;

CREATE TABLE Doc_belong (
    Dept_id INT NOT NULL,
    Doc_id INT NOT NULL,
    PRIMARY KEY (Dept_id, Doc_id),
    FOREIGN KEY (Dept_id) REFERENCES Department(Dept_id) ON DELETE CASCADE,
    FOREIGN KEY (Doc_id) REFERENCES Doctor(Doc_id) ON DELETE CASCADE
);

CREATE TABLE Report (
    Re_id INT NOT NULL,
    Category VARCHAR(20),
    Description VARCHAR(100),
    Date DATE NOT NULL,
    Doc_id INT NOT NULL,
    Ssn INT NOT NULL,
    PRIMARY KEY (Re_id),
    FOREIGN KEY (Doc_id) REFERENCES Doctor(Doc_id),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE
);

CREATE TABLE Medicine (
    Mdc_id INT NOT NULL AUTO_INCREMENT,
    Mdc_name VARCHAR(50) NOT NULL,
    Price INT,
    MFG DATE NOT NULL,
    EXP DATE NOT NULL,
    Quantity INT NOT NULL,
    Manufacturer VARCHAR(50),
    PRIMARY KEY (Mdc_id)
);
-- Set up starting value
ALTER TABLE Medicine AUTO_INCREMENT = 10001;

CREATE TABLE Include (
    Re_id INT NOT NULL,
    Mdc_id INT NOT NULL,
    Mdc_quantity INT NOT NULL,
    PRIMARY KEY (Re_id, Mdc_id),
    FOREIGN KEY (Re_id) REFERENCES Report(Re_id) ON DELETE CASCADE,
    FOREIGN KEY (Mdc_id) REFERENCES Medicine(Mdc_id)
);

CREATE TABLE Disease (
    Dis_id INT NOT NULL AUTO_INCREMENT,
    Dis_name VARCHAR(50) NOT NULL,
    Dis_description VARCHAR(100),
    PRIMARY KEY (Dis_id)
);

CREATE TABLE Dis_treatment (
    Dis_id INT NOT NULL,
    Treatment VARCHAR(50),
    PRIMARY KEY (Dis_id, Treatment),
    FOREIGN KEY (Dis_id) REFERENCES Disease(Dis_id) ON DELETE CASCADE
);

CREATE TABLE Cure (
    Mdc_id INT NOT NULL,
    Dis_id INT NOT NULL,
    PRIMARY KEY (Mdc_id, Dis_id),
    FOREIGN KEY (Mdc_id) REFERENCES Medicine(Mdc_id) ON DELETE CASCADE,
    FOREIGN KEY (Dis_id) REFERENCES Disease(Dis_id) ON DELETE CASCADE
);

CREATE TABLE Get_disease (
    Ssn INT NOT NULL,
    Dis_id INT NOT NULL,
    Start DATE,
    End DATE,
    PRIMARY KEY (Ssn, Dis_id),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE,
    FOREIGN KEY (Dis_id) REFERENCES Disease(Dis_id) ON DELETE CASCADE
);

CREATE TABLE Test (
    Test_id INT NOT NULL AUTO_INCREMENT,
    Test_name VARCHAR(50) NOT NULL,
    Test_room_no INT NOT NULL,
    PRIMARY KEY (Test_id)
);

CREATE TABLE Do_test (
    Test_id INT NOT NULL,
    Doc_id INT NOT NULL,
    Ssn INT NOT NULL,
    Date DATE NOT NULL,
    Fee INT,
    PRIMARY KEY (Test_id, Doc_id, Ssn),
    FOREIGN KEY (Test_id) REFERENCES Test(Test_id) ON DELETE CASCADE,
    FOREIGN KEY (Doc_id) REFERENCES Doctor(Doc_id),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE
);

CREATE TABLE Operation (
    Op_id INT NOT NULL AUTO_INCREMENT,
    Op_name VARCHAR(50) NOT NULL,
    Op_room_no INT NOT NULL,
    Duration TIME,
    PRIMARY KEY (Op_id)
);

CREATE TABLE Operate (
    Op_id INT NOT NULL,
    Doc_id INT NOT NULL,
    Ssn INT NOT NULL,
    Start DATETIME NOT NULL,
    End DATETIME,
    Fee INT,
    PRIMARY KEY (Op_id, Doc_id, Ssn),
    FOREIGN KEY (Op_id) REFERENCES Operation(Op_id) ON DELETE CASCADE,
    FOREIGN KEY (Doc_id) REFERENCES Doctor(Doc_id),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE
);

CREATE TABLE Appointment (
    Appt_id INT NOT NULL AUTO_INCREMENT,
    Duration TIME,
    PRIMARY KEY (Appt_id)
);

CREATE TABLE Consult (
    Appt_id INT NOT NULL,
    Doc_id INT NOT NULL,
    Ssn INT NOT NULL,
    Date DATE,
    Fee INT,
    PRIMARY KEY (Date, Doc_id, Ssn),
    FOREIGN KEY (Appt_id) REFERENCES Appointment(Appt_id) ON DELETE CASCADE,
    FOREIGN KEY (Doc_id) REFERENCES Doctor(Doc_id),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE
);

CREATE TABLE Room (
    Room_no INT NOT NULL AUTO_INCREMENT,
    Room_type VARCHAR(20) NOT NULL,
    Room_cost INT,
    Status VARCHAR(100),
    PRIMARY KEY (Room_no)
);

CREATE TABLE Admit (
    Ssn INT NOT NULL,
    Room_no INT NOT NULL,
    Date_number INT NOT NULL,
    Fee INT,
    PRIMARY KEY (Ssn, Room_no),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE,
    FOREIGN KEY (Room_no) REFERENCES Room(Room_no)
);

CREATE TABLE Nurse (
    Nur_id INT NOT NULL AUTO_INCREMENT,
    Nur_name VARCHAR(50) NOT NULL,
    Nur_type VARCHAR(20) NOT NULL,
    Age INT,
    Shift VARCHAR(10),
    PRIMARY KEY (Nur_id)
);
-- Set up starting value
ALTER TABLE Nurse AUTO_INCREMENT = 120001;

CREATE TABLE Nur_belong (
    Dept_id INT NOT NULL,
    Nur_id INT NOT NULL,
    PRIMARY KEY (Dept_id, Nur_id),
    FOREIGN KEY (Dept_id) REFERENCES Department(Dept_id) ON DELETE CASCADE,
    FOREIGN KEY (Nur_id) REFERENCES Nurse(Nur_id) ON DELETE CASCADE
);

CREATE TABLE Care (
    Ssn INT NOT NULL,
    Nur_id INT NOT NULL,
    PRIMARY KEY (Ssn, Nur_id),
    FOREIGN KEY (Ssn) REFERENCES Patient(Ssn) ON DELETE CASCADE,
    FOREIGN KEY (Nur_id) REFERENCES Nurse(Nur_id)
);

-- Show 25 tables in information_schema
SELECT * FROM information_schema.TABLES;

-- ---------------------------------------------------------------------------------------------------------------------

-- INSERT command
INSERT INTO Insurance_company
VALUES (1, 'American Health', '2157 Swain Rd, Eaton, Ohio', 9374562728),
       (2, 'Health Star', '250 Lone Pine Rd, Saint Landry, Louisiana', 3188382464);

INSERT INTO Patient
VALUES (292567083, 'Dare Lucas', 'M', '1980-02-14',	41,	'7416 Ireland Ct, El Paso,Texas',
        9452170294, 'lucas123@gmail.com', 1,	'2020-12-19', '2022-12-18'),
       (415310368, 'Raynor Kylee', 'F', '1982-01-02', 39, '10926 Highwood Way, El Paso, Texas',
        9702197670, 'kylee0201@hotmail.com', NULL, NULL, NULL),
       (575419103, 'Olson Tracy', 'F', '1956-11-25', 65, '730 Field Ave, Taft, Texas',
        NULL, NULL, 2, '2020-11-19',	'2024-11-18'),
       (151191515, 'Olson Kate', 'F', '1995-05-19', 26, '4568 Green Acres Road, Coinjock, North Carolina',
        2522024018, 'katesil@gmail.com', 2, '2020-12-19', '2022-12-18'),
       (414783198, 'John J Keener', 'M', '1961-10-08', 60, '2401 Corbin Branch Road, IOWA CITY, Iowa',
        7123923698, 'johnk@hotmail.com', 1, '2020-11-19', '2024-11-18');

INSERT INTO Accountant
VALUES (130001, 'Stokes Ashlee', 'ashleelee@gmail.com', 6012484710),
       (130002, 'Parisian Helen', 'helen321@hotmail.com', 5805694574);

INSERT INTO Bill
VALUES (61461265, '2021-06-06',	100, 50, 1,	50,	292567083, '2021-06-06', 'cash', 130001),
       (98347142, '2021-06-11',	100, 100, NULL,	0, 415310368, '2021-06-11',	'cheque', 130002),
       (91479336, '2021-08-26',	5000, 100, 2, 4900,	575419103, '2021-08-26', 'cash', 130001),
       (17173171, '2021-09-02', 200, 150, 2, 50, 151191515, '2021-09-02', 'creditcard', 130001),
       (77781785, '2021-09-26', 150, 50, 1, 100, 414783198, '2021-09-26', 'creditcard', 130002),
       (72735717, '2021-10-15', 200, 200, NULL, 0, 415310368, '2021-10-15', 'cheque', 130001);

INSERT INTO Department
VALUES (1, 'cardiology'),
       (2, 'general internal medicine');

INSERT INTO Doctor
VALUES (110001, 'Ziemann Timothy', 'ENT specialist', 28, '303 Valmar, Kemah, Texas', 5753361371),
       (110002,	'White Warren',	'orthopaedic surgeon', 33, '1105 Clover Dr, Burkburnett, Texas', 5805694580),
       (110003,	'Wehner Nico', 'cardiologist', 40, '369 Arnold Dr, Gordonville, Texas',	5809202612);

INSERT INTO Doc_belong
VALUES (2, 110001),
       (2, 110002),
       (1 ,110003);

INSERT INTO Report
VALUES (41614184, 'test', 'Re-examination next 2 weeks', '2021-06-06', 110001, 292567083),
       (86116642, 'consult', 'Just need to use medicine', '2021-06-11',	110001, 415310368),
       (19782716, 'operation', 'Recoverd, re-examine next month', '2021-08-26',	110003, 575419103),
       (73717313, 'test', 'Re-examination next 2 weeks', '2021-09-02', 110002, 151191515),
       (71375531, 'consult', 'Just need to use medicine', '2021-09-26', 110003, 414783198),
       (34666337, 'consult', 'Just need to use medicine', '2021-10-15', 110001, 415310368);

INSERT INTO Medicine
VALUES (10001, 'aspirin', 4, '2020-12-15', '2022-12-15', 200, 'Pfizer'),
       (10002, 'acetaminophen',	5, '2021-01-01', '2023-01-01', 300,	'Johnson & Johnson'),
       (10003, 'tylenol', 3, '2021-03-01', '2023-03-01', 400, 'Pfizer');

INSERT INTO Include
VALUES (86116642, 10001, 10),
       (71375531, 10002, 15),
       (34666337, 10003, 20);

INSERT INTO Disease
VALUES (1, 'Cold and Flu', 'Viruses cause both colds and flu by
increasing inflammation of the membranes in the nose and throat.'),
       (2, 'Headaches',	'Affects a specific point of the head,
often the eye, and is characterized by sharp, piercing pain.');

INSERT INTO Dis_treatment
VALUES (1, 'Drink lots of clear fluids (e.g., water, tea)'),
       (2, 'Ice pack held over the eyes or forehead'),
       (2, 'Sleep, or at least resting in a dark room');

INSERT INTO Cure
VALUES (10001, 2),
       (10002, 2),
       (10003, 1);

INSERT INTO Get_disease
VALUES (415310368, 1, '2021-06-10', '2021-06-15'),
       (414783198, 2, '2021-09-25', '2021-09-30'),
       (415310368, 2, '2021-10-14', '2021-10-18');

INSERT INTO Test
VALUES (1, 'ear checking', 4),
       (2, 'COVID-19', 4);

INSERT INTO Do_test
VALUES (1, 110001, 292567083, '2021-06-06', 100),
       (2, 110002, 151191515, '2021-09-02', 200);

INSERT INTO Operation
VALUES (1, 'heart operation', 3, '11:30:00');

INSERT INTO Operate
VALUES (1, 110003, 575419103, '2021-08-17 08:00:00', '2021-08-17 19:30:00', 5000);

INSERT INTO Appointment
VALUES (1, '00:15:00'),
       (2, '00:30:00'),
       (3, '00:25:00');

INSERT INTO Consult
VALUES (1, 110001, 415310368, '2021-06-11', 10),
       (2, 110003, 414783198, '2021-09-26', 10),
       (3, 110001, 415310368, '2021-10-15', 15);

INSERT INTO Room
VALUES (1, 'recovery', 50, 'available'),
       (2, 'recovery', 100,	'available'),
       (3, 'surgery', NULL,	'used for surgery'),
       (4, 'test', NULL, 'used for test');

INSERT INTO Admit
VALUES (575419103, 2 ,10, 1000);

INSERT INTO Nurse
VALUES (120001, 'Willms Amy', 'cardiac', 40, 'day'),
       (120002,	'Schmitt Erica', 'registered', 30, 'day'),
       (120003,	'Blick Ken', 'registered', 34, 'night');

INSERT INTO Nur_belong
VALUES (1, 120001),
       (2, 120002),
       (2, 120003);

INSERT INTO Care
VALUES (575419103, 120001),
       (575419103, 120003);

-- ---------------------------------------------------------------------------------------------------------------------

-- DELETE command
-- delete a row in Bill table
DELETE FROM Bill
WHERE Bill_no = 72735717;

-- ---------------------------------------------------------------------------------------------------------------------

-- UPDATE command
-- Update Tel_no and Email of Olson Tracy
UPDATE Patient
SET Tel_no = 1561561156, Email = 'tracy@gmail.com'
WHERE Pat_name = 'Olson Tracy';

-- ---------------------------------------------------------------------------------------------------------------------

-- SELECT command (basic to advanced)
-- select all Report table
SELECT *
FROM Report;

-- select MFG and EXP of all Medicine
SELECT Mdc_name, MFG, EXP
FROM Medicine;

-- select which patient's age >= 40
SELECT Ssn, Pat_name, Sex, DOB, Age, Tel_no
FROM Patient
Where Age >= 40;

-- Using Alias when selecting female patients
SELECT P.Ssn, P.Pat_name AS 'Full name', P.Sex AS 'Gender', P.DOB
FROM Patient AS P
WHERE P.Sex = 'F';

-- SELECT ALL is the default SELECT: use this to see the room type
SELECT ALL Room_type
FROM Room;

-- SELECT DISTINCT eliminate duplication: use this to see the room type as above
SELECT DISTINCT Room_type
FROM Room;

-- Patient: search based on Pat_name
SELECT Pat_name, Sex, DOB, Address, Tel_no, Email
FROM Patient
WHERE Pat_name LIKE CONCAT('%', 'Olson', '%');

-- Patient: whose birthdate on November
SELECT Pat_name, Sex, DOB, Address, Tel_no, Email
FROM Patient
WHERE DOB LIKE '_____11___';

-- Aggregate Functions when search based on Date1 -> Date2
SELECT COUNT(Bill_no) AS Total_bill,
       SUM(Total_fee) AS Total_revenue,
       AVG(Total_fee) AS Average_revenue,
       MAX(Total_fee) AS Max_bill_fee,
       MIN(Total_fee) AS Min_bill_fee
FROM Bill, Patient, Accountant
WHERE (Pur_date BETWEEN '2021-08-26' AND '2021-09-26')
  AND Bill.Ssn = Patient.Ssn AND Bill.Acct_id = Accountant.Acct_id;

-- arrange patient descending based on Age >= 30
SELECT *
FROM Patient
Where Age >= 30
ORDER BY Age DESC;

-- Select patients who do not come from Iowa
SELECT *
FROM Patient
WHERE Ssn NOT IN (SELECT Ssn
                  FROM Patient
                  WHERE Address LIKE '%Iowa');

-- Select patients who have insurance, this mean that the value of InsCo_id is not NULL
SELECT *
FROM Patient
WHERE InsCo_id IS NOT NULL;

-- Inner Join: Medicine, Cure, Disease
SELECT Medicine.Mdc_name, Medicine.Manufacturer, Disease.Dis_name
FROM ((Medicine
INNER JOIN Cure ON Medicine.Mdc_id = Cure.Mdc_id)
INNER JOIN Disease ON Cure.Dis_id = Disease.Dis_id);

-- Left Join: Bill, Accountant
SELECT Bill.Bill_no, Bill.Created_date, A.Acct_name
FROM Bill
LEFT JOIN Accountant A ON A.Acct_id = Bill.Acct_id;

-- UNION: Doctor, nurse, accountant as staff
SELECT Doc_id AS 'Staff_id', Doc_name AS 'Staff_name'
FROM Doctor
WHERE Doc_type = 'cardiologist'
UNION
SELECT Nur_id, Nur_name
FROM Nurse
WHERE Shift = 'day'
UNION
SELECT Acct_id, Acct_name
FROM Accountant
WHERE Acct_name = 'Stokes Ashlee';

-- See how many patients are male and female
SELECT Sex AS 'Gender', COUNT(Ssn)
FROM Patient
GROUP BY Sex;

-- Using EXISTS to check are there any doctor belong to cardiology department
-- and is there no nurse belong to general internal medicine department
SELECT Dept_id, Dept_name
FROM Department
WHERE EXISTS(SELECT *
             FROM Doctor, Doc_belong, Department
             WHERE Doctor.Doc_id = Doc_belong.Doc_id
               AND Doc_belong.Dept_id = Department.Dept_id
               AND Dept_name = 'cardiology')
      AND
      NOT EXISTS(SELECT *
                 FROM Nurse, Nur_belong, Department
                 WHERE Nurse.Nur_id = Nur_belong.Nur_id
                   AND Nur_belong.Dept_id = Department.Dept_id
                   AND Dept_name = 'general internal medicine');

-- ---------------------------------------------------------------------------------------------------------------------

-- SELECT
SELECT * FROM Patient;
RENAME TABLE Patient TO New_Patient;
SELECT * FROM New_Patient;
ALTER TABLE New_Patient RENAME Patient;
SELECT * FROM Patient;

-- ---------------------------------------------------------------------------------------------------------------------

-- DROP 25 TABLES
-- Group 1: Tables referring to group 2 tables
DROP TABLE Bill;
DROP TABLE Doc_belong;
DROP TABLE Include;
DROP TABLE Report;
DROP TABLE Dis_treatment;
DROP TABLE Cure;
DROP TABLE Get_disease;
DROP TABLE Do_test;
DROP TABLE Operate;
DROP TABLE Consult;
DROP TABLE Admit;
DROP TABLE Nur_belong;
DROP TABLE Care;
-- Group 2: Tables referred by group 1 tables and referring to group 3 tables
DROP TABLE Patient;
-- Group 3: Tables referred by group 2 tables
DROP TABLE Insurance_company;
DROP TABLE Accountant;
DROP TABLE Department;
DROP TABLE Doctor;
DROP TABLE Medicine;
DROP TABLE Disease;
DROP TABLE Test;
DROP TABLE Operation;
DROP TABLE Appointment;
DROP TABLE Room;
DROP TABLE Nurse;

-- ---------------------------------------------------------------------------------------------------------------------

DROP SCHEMA Hospital;