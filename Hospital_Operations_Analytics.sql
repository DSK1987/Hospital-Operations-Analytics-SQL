CREATE DATABASE healthcare_db;
USE healthcare_db;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    city VARCHAR(50)
);
SHOW TABLES;
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50)
);
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100),
    speciality VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);
SHOW TABLES;
INSERT INTO departments (department_name)
VALUES
('Cardiology'),
('Neurology'),
('Oncology'),
('Dentistry'),
('Emergency Medicine');

SELECT * FROM doctors;
INSERT INTO patients
(first_name, last_name, gender, date_of_birth, city)
VALUES
('John', 'Smith', 'Male', '1985-03-15', 'London'),
('Emma', 'Johnson', 'Female', '1992-07-22', 'Manchester'),
('Michael', 'Brown', 'Male', '1978-11-10', 'Birmingham'),
('Sophia', 'Davis', 'Female', '2000-05-08', 'Leeds'),
('Daniel', 'Wilson', 'Male', '1968-09-30', 'Liverpool');
SELECT * FROM patients;
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
);
INSERT INTO appointments
(patient_id, doctor_id, appointment_date, status)
VALUES
(1,1,'2025-01-10','Completed'),
(2,2,'2025-01-12','Completed'),
(3,3,'2025-01-15','Completed'),
(4,4,'2025-01-18','Scheduled'),
(5,5,'2025-01-20','Completed'),
(1,4,'2025-02-01','Scheduled');
SELECT * FROM appointments;
SELECT
d.doctor_name,
COUNT(a.appointment_id) AS total_appointments
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name;
CREATE TABLE diagnoses (
    diagnosis_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    diagnosis_name VARCHAR(100),
    diagnosis_date DATE,
    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
);
INSERT INTO diagnoses
(patient_id, diagnosis_name, diagnosis_date)
VALUES
(1,'Hypertension','2025-01-10'),
(2,'Migraine','2025-01-12'),
(3,'Lung Cancer','2025-01-15'),
(4,'Dental Caries','2025-01-18'),
(5,'Heart Disease','2025-01-20'),
(1,'Dental Caries','2025-02-01');
SELECT * FROM diagnoses;
SELECT
diagnosis_name,
COUNT(*) AS frequency
FROM diagnoses
GROUP BY diagnosis_name
ORDER BY frequency DESC;
SELECT
p.first_name,
p.last_name,
COUNT(d.diagnosis_id) AS total_diagnoses
FROM patients p
JOIN diagnoses d
ON p.patient_id = d.patient_id
GROUP BY p.patient_id;
CREATE TABLE admissions (
    admission_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
);
INSERT INTO admissions
(patient_id, admission_date, discharge_date)
VALUES
(1,'2025-01-10','2025-01-15'),
(2,'2025-01-12','2025-01-14'),
(3,'2025-01-15','2025-01-25'),
(5,'2025-01-20','2025-01-28');
SELECT * FROM admissions;
SELECT
AVG(DATEDIFF(discharge_date, admission_date))
AS average_stay_days
FROM admissions;

SELECT
p.first_name,
p.last_name,
DATEDIFF(a.discharge_date,a.admission_date)
AS stay_days
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
ORDER BY stay_days DESC;

SELECT
p.first_name,
p.last_name,
d.diagnosis_name,
doc.doctor_name
FROM patients p
JOIN diagnoses d
ON p.patient_id = d.patient_id
JOIN appointments a
ON p.patient_id = a.patient_id
JOIN doctors doc
ON a.doctor_id = doc.doctor_id;

CREATE VIEW patient_summary AS
SELECT
p.patient_id,
p.first_name,
p.last_name,
d.diagnosis_name,
doc.doctor_name
FROM patients p
JOIN diagnoses d
ON p.patient_id = d.patient_id
JOIN appointments a
ON p.patient_id = a.patient_id
JOIN doctors doc
ON a.doctor_id = doc.doctor_id;

SELECT * FROM patient_summary;

CREATE TABLE treatments (
    treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    treatment_name VARCHAR(100),
    treatment_date DATE,
    cost DECIMAL(10,2),
    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
);
INSERT INTO treatments
(patient_id, doctor_id, treatment_name, treatment_date, cost)
VALUES
(1,1,'Blood Pressure Assessment','2025-01-10',120.00),
(2,2,'Neurological Examination','2025-01-12',250.00),
(3,3,'Cancer Screening','2025-01-15',500.00),
(4,4,'Dental Filling','2025-01-18',180.00),
(5,5,'Emergency Assessment','2025-01-20',300.00);

SELECT * FROM treatments;

CREATE TABLE staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_name VARCHAR(100),
    role VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

INSERT INTO staff
(staff_name, role, department_id)
VALUES
('Alice Green','Nurse',1),
('James White','Nurse',2),
('Robert Black','Pharmacist',3),
('Linda Brown','Healthcare Assistant',4),
('Karen Taylor','Nurse',5);

SELECT * FROM staff;

CREATE TABLE wards (
    ward_id INT PRIMARY KEY AUTO_INCREMENT,
    ward_name VARCHAR(100),
    bed_capacity INT
);

INSERT INTO wards
(ward_name, bed_capacity)
VALUES
('Cardiology Ward',20),
('Neurology Ward',15),
('Oncology Ward',18),
('General Medicine Ward',30);

SELECT * FROM wards;

SELECT
dep.department_name,
SUM(t.cost) AS total_revenue
FROM treatments t
JOIN doctors d
ON t.doctor_id = d.doctor_id
JOIN departments dep
ON d.department_id = dep.department_id
GROUP BY dep.department_name
ORDER BY total_revenue DESC;

SELECT
dep.department_name,
COUNT(s.staff_id) AS total_staff
FROM departments dep
LEFT JOIN staff s
ON dep.department_id = s.department_id
GROUP BY dep.department_name;


CREATE VIEW hospital_management_dashboard AS
SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    dep.department_name,
    doc.doctor_name,
    d.diagnosis_name,
    t.treatment_name,
    t.cost
FROM patients p
JOIN diagnoses d
    ON p.patient_id = d.patient_id
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN doctors doc
    ON a.doctor_id = doc.doctor_id
JOIN departments dep
    ON doc.department_id = dep.department_id
LEFT JOIN treatments t
    ON p.patient_id = t.patient_id;


SELECT * FROM hospital_management_dashboard;

SELECT 'Total Patients' AS KPI, COUNT(*) AS Value
FROM patients

UNION

SELECT 'Total Doctors', COUNT(*)
FROM doctors

UNION

SELECT 'Total Admissions', COUNT(*)
FROM admissions

UNION

SELECT 'Total Treatments', COUNT(*)
FROM treatments;

SELECT
    dep.department_name,
    COUNT(DISTINCT a.patient_id) AS patients_seen,
    COUNT(DISTINCT d.doctor_id) AS doctors,
    SUM(t.cost) AS revenue
FROM departments dep
LEFT JOIN doctors d
    ON dep.department_id = d.department_id
LEFT JOIN appointments a
    ON d.doctor_id = a.doctor_id
LEFT JOIN treatments t
    ON d.doctor_id = t.doctor_id
GROUP BY dep.department_name;

DELIMITER $$

CREATE PROCEDURE GetDepartmentRevenue()
BEGIN
    SELECT
        dep.department_name,
        COALESCE(SUM(t.cost),0) AS total_revenue
    FROM departments dep
    LEFT JOIN doctors d
        ON dep.department_id = d.department_id
    LEFT JOIN treatments t
        ON d.doctor_id = t.doctor_id
    GROUP BY dep.department_name
    ORDER BY total_revenue DESC;
END $$

DELIMITER ;

CALL GetDepartmentRevenue();

CREATE TABLE treatment_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    treatment_name VARCHAR(100),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER $$

CREATE TRIGGER trg_treatment_insert
AFTER INSERT ON treatments
FOR EACH ROW
BEGIN
    INSERT INTO treatment_audit(treatment_name)
    VALUES (NEW.treatment_name);
END $$

DELIMITER ;

INSERT INTO treatments
(patient_id,doctor_id,treatment_name,treatment_date,cost)
VALUES
(1,1,'Follow-up Consultation','2025-02-10',80.00);

SELECT * FROM treatment_audit;


SELECT
    dep.department_name,
    SUM(t.cost) AS revenue,

    RANK() OVER(
        ORDER BY SUM(t.cost) DESC
    ) AS revenue_rank

FROM departments dep
JOIN doctors d
    ON dep.department_id = d.department_id
JOIN treatments t
    ON d.doctor_id = t.doctor_id

GROUP BY dep.department_name;

WITH DepartmentRevenue AS
(
    SELECT
        dep.department_name,
        SUM(t.cost) AS revenue
    FROM departments dep
    JOIN doctors d
        ON dep.department_id=d.department_id
    JOIN treatments t
        ON d.doctor_id=t.doctor_id
    GROUP BY dep.department_name
)

SELECT *
FROM DepartmentRevenue
WHERE revenue > 200;

USE healthcare_db;

CREATE TABLE bed_occupancy (
    occupancy_id INT PRIMARY KEY AUTO_INCREMENT,
    ward_id INT,
    patient_id INT,
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (ward_id) REFERENCES wards(ward_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

INSERT INTO bed_occupancy
(ward_id, patient_id, admission_date, discharge_date)
VALUES
(1,1,'2025-01-10','2025-01-15'),
(1,2,'2025-01-12','2025-01-14'),
(2,3,'2025-01-15','2025-01-25'),
(3,4,'2025-01-20','2025-01-28'),
(2,5,'2025-02-01','2025-02-10');

SELECT * FROM bed_occupancy;


SELECT
    w.ward_name,
    w.bed_capacity,
    COUNT(b.occupancy_id) AS occupied_beds
FROM wards w
LEFT JOIN bed_occupancy b
ON w.ward_id = b.ward_id
GROUP BY w.ward_name, w.bed_capacity;


SELECT
    w.ward_name,
    w.bed_capacity,
    COUNT(b.occupancy_id) AS occupied_beds,
    ROUND(
        COUNT(b.occupancy_id) * 100.0 /
        w.bed_capacity,
        2
    ) AS occupancy_percentage
FROM wards w
LEFT JOIN bed_occupancy b
ON w.ward_id = b.ward_id
GROUP BY w.ward_name, w.bed_capacity;


SELECT
    w.ward_name,
    COUNT(b.occupancy_id) AS occupied_beds
FROM wards w
JOIN bed_occupancy b
ON w.ward_id = b.ward_id
GROUP BY w.ward_name
ORDER BY occupied_beds DESC;


SELECT 'Total Patients' AS KPI, COUNT(*) AS Value
FROM patients

UNION

SELECT 'Total Doctors', COUNT(*)
FROM doctors

UNION

SELECT 'Total Appointments', COUNT(*)
FROM appointments

UNION

SELECT 'Total Admissions', COUNT(*)
FROM admissions

UNION

SELECT 'Total Treatments', COUNT(*)
FROM treatments;



SELECT * FROM patient_summary;
SELECT
dep.department_name,
SUM(t.cost) AS total_revenue
FROM treatments t
JOIN doctors d
ON t.doctor_id = d.doctor_id
JOIN departments dep
ON d.department_id = dep.department_id
GROUP BY dep.department_name
ORDER BY total_revenue DESC;

SELECT
w.ward_name,
w.bed_capacity,
COUNT(b.occupancy_id) AS occupied_beds,
ROUND(
COUNT(b.occupancy_id) * 100.0 /
w.bed_capacity,
2
) AS occupancy_percentage
FROM wards w
LEFT JOIN bed_occupancy b
ON w.ward_id = b.ward_id
GROUP BY w.ward_name,w.bed_capacity;

SELECT 'Total Patients' AS KPI, COUNT(*) AS Value
FROM patients

UNION

SELECT 'Total Doctors', COUNT(*)
FROM doctors

UNION

SELECT 'Total Appointments', COUNT(*)
FROM appointments

UNION

SELECT 'Total Admissions', COUNT(*)
FROM admissions

UNION

SELECT 'Total Treatments', COUNT(*)
FROM treatments;
