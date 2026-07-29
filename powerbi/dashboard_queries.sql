-- Power BI dashboard queries (SQLite)
-- These queries are read-only and use the existing schema as-is.

-- KPI: Total Patients
SELECT COUNT(*) AS TotalPatients
FROM Patients;

-- KPI: Total Doctors
SELECT COUNT(*) AS TotalDoctors
FROM Doctors;

-- KPI: Total Appointments
SELECT COUNT(*) AS TotalAppointments
FROM Appointments;

-- KPI: Total Revenue (sum of invoice totals)
SELECT COALESCE(SUM(TotalCharge), 0) AS TotalRevenue
FROM Invoices;

-- Line Chart: Revenue by Month
SELECT
  substr(IssuedAt, 1, 7) AS RevenueMonth,
  COALESCE(SUM(TotalCharge), 0) AS Revenue
FROM Invoices
GROUP BY RevenueMonth
ORDER BY RevenueMonth;

-- Bar Chart: Department-wise Revenue (Doctor specialization)
SELECT
  d.Specialization AS Department,
  COALESCE(SUM(i.TotalCharge), 0) AS Revenue
FROM Invoices i
JOIN Appointments a ON a.AppointmentID = i.AppointmentID
JOIN Doctors d ON d.DoctorID = a.DoctorID
GROUP BY d.Specialization
ORDER BY Revenue DESC;

-- Column Chart: Appointments by Department (Doctor specialization)
SELECT
  d.Specialization AS Department,
  COUNT(*) AS Appointments
FROM Appointments a
JOIN Doctors d ON d.DoctorID = a.DoctorID
GROUP BY d.Specialization
ORDER BY Appointments DESC;

-- Bar Chart: Appointments by Doctor
SELECT
  d.DoctorName AS Doctor,
  d.Specialization AS Department,
  COUNT(*) AS Appointments
FROM Appointments a
JOIN Doctors d ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.DoctorName, d.Specialization
ORDER BY Appointments DESC;

-- Pie Chart: Insurance Plan Distribution (primary coverage)
SELECT
  ip.PayerName,
  ip.PlanName,
  ip.PlanType,
  COUNT(*) AS PrimaryMembers
FROM PatientCoverage pc
JOIN InsurancePlans ip ON ip.InsuranceID = pc.InsuranceID
WHERE pc.IsPrimary = 1
GROUP BY ip.InsuranceID, ip.PayerName, ip.PlanName, ip.PlanType
ORDER BY PrimaryMembers DESC;

-- Bar Chart: Top 10 Procedures (by volume) + optional revenue from invoice line items
SELECT
  mp.ProcedureName,
  mp.ProcedureFamily,
  COUNT(*) AS ProcedureCount,
  COALESCE(SUM(ili.Amount), 0) AS BilledAmount
FROM MedicalProcedures mp
LEFT JOIN InvoiceLineItems ili ON ili.ProcedureRecordID = mp.ProcedureRecordID
GROUP BY mp.ProcedureName, mp.ProcedureFamily
ORDER BY ProcedureCount DESC, BilledAmount DESC
LIMIT 10;

-- Bar Chart: Top 10 Medications (by prescription volume)
SELECT
  m.MedicationName AS Medication,
  m.Category,
  COUNT(*) AS PrescriptionCount
FROM Prescriptions pr
JOIN Medications m ON m.MedicationID = pr.MedicationID
GROUP BY m.MedicationID, m.MedicationName, m.Category
ORDER BY PrescriptionCount DESC
LIMIT 10;

-- Histogram-style table: Patient Age Distribution (as of a fixed reference date)
-- Update the reference date if you want a different “as of” date.
WITH PatientAges AS (
  SELECT
    PatientID,
    CAST((julianday('2026-04-09') - julianday(DateOfBirth)) / 365.25 AS INT) AS Age
  FROM Patients
  WHERE DateOfBirth IS NOT NULL AND DateOfBirth <> ''
),
AgeBands AS (
  SELECT
    CASE
      WHEN Age < 18 THEN '0-17'
      WHEN Age BETWEEN 18 AND 34 THEN '18-34'
      WHEN Age BETWEEN 35 AND 49 THEN '35-49'
      WHEN Age BETWEEN 50 AND 64 THEN '50-64'
      ELSE '65+'
    END AS AgeBand
  FROM PatientAges
)
SELECT
  AgeBand,
  COUNT(*) AS Patients
FROM AgeBands
GROUP BY AgeBand
ORDER BY
  CASE AgeBand
    WHEN '0-17' THEN 1
    WHEN '18-34' THEN 2
    WHEN '35-49' THEN 3
    WHEN '50-64' THEN 4
    ELSE 5
  END;

-- Donut/Pie: Appointment Status Distribution
SELECT
  AppointmentStatus,
  COUNT(*) AS Appointments
FROM Appointments
GROUP BY AppointmentStatus
ORDER BY Appointments DESC;

-- Area Chart: Monthly Appointment Trend
SELECT
  substr(AppointmentDate, 1, 7) AS AppointmentMonth,
  COUNT(*) AS Appointments
FROM Appointments
GROUP BY AppointmentMonth
ORDER BY AppointmentMonth;

-- Table: Recent Appointments (for a table visual)
SELECT
  a.AppointmentDate,
  a.AppointmentTime,
  a.VisitType,
  a.AppointmentStatus,
  p.FirstName || ' ' || p.LastName AS PatientName,
  d.DoctorName,
  d.Specialization AS Department,
  f.FacilityName
FROM Appointments a
JOIN Patients p ON p.PatientID = a.PatientID
JOIN Doctors d ON d.DoctorID = a.DoctorID
JOIN Facilities f ON f.FacilityID = a.FacilityID
ORDER BY a.AppointmentDate DESC, a.AppointmentTime DESC
LIMIT 25;

-- Table: Top Revenue Patients
SELECT
  p.PatientID,
  p.FirstName || ' ' || p.LastName AS PatientName,
  COALESCE(SUM(i.TotalCharge), 0) AS TotalRevenue,
  COUNT(DISTINCT i.InvoiceID) AS InvoiceCount
FROM Patients p
LEFT JOIN Invoices i ON i.PatientID = p.PatientID
GROUP BY p.PatientID, PatientName
ORDER BY TotalRevenue DESC
LIMIT 10;
