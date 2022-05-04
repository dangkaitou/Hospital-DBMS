-- QUERY FOR WEB
-- Patient: search based on Pat_name
DELIMITER //
CREATE PROCEDURE search_Pat_name(IN pat_name VARCHAR(50))
BEGIN
SELECT Pat_name, Sex, DOB, Address, Tel_no, Email
FROM Patient
WHERE Pat_name LIKE CONCAT('%', pat_name, '%');
END //
DELIMITER ;

-- Count patient when search based on Pat_name
DELIMITER //
CREATE PROCEDURE count_patient_Pat_name(IN pat_name VARCHAR(50))
BEGIN
SELECT COUNT(Ssn)
FROM Patient
WHERE Pat_name LIKE CONCAT('%', pat_name, '%');
END //
DELIMITER ;

-- Patient: all + insurance company name
DELIMITER //
CREATE PROCEDURE patient_InsCo_name(IN s VARCHAR(50))
BEGIN
SELECT Patient.Ssn, Patient.Pat_name, Patient.Sex, Patient.DOB, Patient.Age, Patient.Address, Patient.Tel_no, Patient.Email, Insurance_company.InsCo_name, Patient.Start_date, Patient.End_date
FROM Patient, Insurance_company
WHERE Pat_name LIKE CONCAT('%', s, '%') AND Patient.InsCo_id = Insurance_company.InsCo_id;
END //
DELIMITER ;

-- Patient: search based on DOB
DELIMITER //
CREATE PROCEDURE search_patient_DOB(IN birth DATE)
BEGIN
SELECT Pat_name, Sex, DOB, Address, Tel_no, Email
FROM Patient
WHERE DOB = birth;
END //
DELIMITER ;

-- Doctor: search based on Doc_name
DELIMITER //
CREATE PROCEDURE search_doctor_Doc_name(IN name VARCHAR(50))
BEGIN
SELECT Doc_name, Dept_name, Doc_type, Age, Tel_no
FROM Doctor, Department, Doc_belong
WHERE Doc_name = name AND Doctor.Doc_id = Doc_belong.Doc_id AND Doc_belong.Dept_id = Department.Dept_id;
END //
DELIMITER ;


-- Doctor: search based on Dept_name
DELIMITER //
CREATE PROCEDURE search_doctor_Dept_name(IN dept VARCHAR(50))
BEGIN
SELECT Doc_name, Dept_name, Doc_type, Age, Tel_no
FROM Doctor, Department, Doc_belong
WHERE Dept_name = dept AND Department.Dept_id = Doc_belong.Dept_id AND Doc_belong.Doc_id = Doctor.Doc_id;
END //
DELIMITER ;

-- Medicine: show all
DELIMITER //
CREATE PROCEDURE show_all_medicine()
BEGIN
SELECT Medicine.Mdc_id, Mdc_name, Dis_name, Price, MFG, EXP, Quantity, Manufacturer
FROM Medicine, Disease, Cure
WHERE Mdc_name LIKE '%' AND Medicine.Mdc_id = Cure.Mdc_id AND Cure.Dis_id = Disease.Dis_id;
END //
DELIMITER ;

-- Record: search based on Pat_name
DELIMITER //
CREATE PROCEDURE search_record_Pat_name(IN name VARCHAR(50))
BEGIN
SELECT Report.Re_id, Pat_name, Doc_name, Category, Description, Date
FROM Report, Doctor, Patient
WHERE Pat_name = name AND Report.Ssn = Patient.Ssn AND Report.Doc_id = Doctor.Doc_id;
END //
DELIMITER ;


-- Record: search based on Date1 -> Date2
DELIMITER //
CREATE PROCEDURE search_record_date1_date2(IN Date1 DATE, IN Date2 DATE)
BEGIN
SELECT Report.Re_id, Pat_name, Doc_name, Category, Description, Date
FROM Report, Doctor, Patient
WHERE (Date BETWEEN Date1 AND Date2) AND Report.Ssn = Patient.Ssn AND Report.Doc_id = Doctor.Doc_id;
END //
DELIMITER ;


-- Bill: search based on Date1 -> Date2
DELIMITER //
CREATE PROCEDURE search_bill_date1_date2(IN Date1 DATE, IN Date2 DATE)
BEGIN
SELECT Bill_no, Created_date, Pur_date, Service_charge, Discount, Total_fee, Pur_type, Pat_name, Patient.Tel_no, Acct_name, Accountant.Tel_no
FROM Bill, Patient, Accountant
WHERE (Pur_date BETWEEN Date1 AND Date2) AND Bill.Ssn = Patient.Ssn AND Bill.Acct_id = Accountant.Acct_id;
END //
DELIMITER ;


-- Aggregate Functions when search based on Date1 -> Date2
DELIMITER //
CREATE PROCEDURE aggregate_bill_date1_date2(IN Date1 DATE, IN Date2 DATE)
BEGIN
SELECT COUNT(Bill_no) AS Total_bill,
       SUM(Total_fee) AS Total_revenue,
       AVG(Total_fee) AS Average_revenue,
       MAX(Total_fee) AS Max_bill_fee,
       MIN(Total_fee) AS Min_bill_fee
FROM Bill, Patient, Accountant
WHERE (Pur_date BETWEEN Date1 AND Date2)
  AND Bill.Ssn = Patient.Ssn AND Bill.Acct_id = Accountant.Acct_id;
END //
DELIMITER ;