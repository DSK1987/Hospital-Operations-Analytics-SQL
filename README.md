# Hospital-Operations-Analytics-SQL
Hospital Operations Analytics System (SQL)--  A relational healthcare database developed using MySQL to model hospital operations, patient management, admissions, treatments, staff allocation, and operational KPI reporting.

Hospital Operations Analytics System (SQL)
Project Overview

This project simulates a hospital management and operational analytics database using MySQL. The database models real-world healthcare entities including patients, doctors, departments, admissions, treatments, appointments, staff, wards, and bed occupancy.

The project demonstrates database design, relational modelling, SQL querying, healthcare KPI reporting, and operational analytics commonly used in hospital management and healthcare data analysis.

Technologies Used
MySQL Workbench
SQL
Relational Database Design
Entity Relationship Diagram (ERD)
Database Structure
Core Tables
Patients
Doctors
Departments
Appointments
Diagnoses
Admissions
Treatments
Staff
Wards
Bed Occupancy
Treatment Audit
Views
Patient Summary
Key Features
Patient Management

Store and manage patient demographic information.

Doctor and Department Management

Track doctors, specialties, and departmental assignments.

Appointment Scheduling

Manage patient appointments and appointment status.

Clinical Diagnoses

Record and analyse patient diagnoses.

Admissions Analytics

Monitor patient admissions and calculate average length of stay.

Treatment Management

Track treatments and associated healthcare costs.

Bed Occupancy Analytics

Monitor ward capacity and occupancy rates.

Hospital KPI Dashboard

Generate executive-level operational metrics.

Example Analytics Queries
Total Appointments by Doctor

SELECT
d.doctor_name,
COUNT(a.appointment_id) AS total_appointments
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name;

Average Length of Stay
SELECT
AVG(DATEDIFF(discharge_date, admission_date))
AS average_stay_days
FROM admissions;

Revenue by Department
SELECT
dep.department_name,
SUM(t.cost) AS total_revenue
FROM treatments t
JOIN doctors d
ON t.doctor_id = d.doctor_id
JOIN departments dep
ON d.department_id = dep.department_id
GROUP BY dep.department_name;

Skills Demonstrated
SQL Querying
Relational Database Design
Primary and Foreign Keys
Joins
Aggregate Functions
Views
Common Table Expressions (CTEs)
Healthcare Data Modelling
Hospital KPI Reporting
Operational Analytics
ERD

Include the exported ERD diagram here.

Author

Shahbaz Durrani

MSc Health Data Science and Statistics

University of Plymouth
