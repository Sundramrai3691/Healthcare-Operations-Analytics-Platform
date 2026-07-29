# Power BI (Optional)

This folder contains an optional Microsoft Power BI layer that connects directly to the project’s existing SQLite database and reuses the same tables and reporting logic already present in the repository. The backend, APIs, and database schema remain unchanged.

## What You Get

- A beginner-friendly Power BI setup that reads from the generated SQLite database file
- A set of ready-to-use SQL queries for common visuals in [dashboard_queries.sql](file:///c:/Users/HP/healthcare-operations-analytics/powerbi/dashboard_queries.sql)

## Database File to Use

The app generates the SQLite database at:

- `runtime/healthcare_demo.db`

If you do not see the file yet, run the app once to generate it:

```bash
python3 app.py
```

## Connect Power BI Desktop to SQLite

Power BI Desktop does not always include a built-in SQLite connector. The most common approach is to use an SQLite ODBC driver.

1. Install an SQLite ODBC driver (any standard SQLite ODBC driver is fine).
2. Open Power BI Desktop → Get Data.
3. Choose **ODBC** (or **More…** → search for ODBC).
4. Select your SQLite ODBC driver / DSN and point it to:
   - `runtime/healthcare_demo.db`
5. Choose **Import** (recommended for this project) and proceed.

## Import Tables

In Navigator, load the core tables used by the visuals:

- `Patients`
- `Doctors`
- `Facilities`
- `Appointments`
- `InsurancePlans`
- `PatientCoverage`
- `MedicalProcedures`
- `Medications`
- `Prescriptions`
- `LabResults`
- `Invoices`
- `InvoiceLineItems`

You can also import a subset if you only need the dashboard visuals.

## Use dashboard_queries.sql

There are two common ways to use [dashboard_queries.sql](file:///c:/Users/HP/healthcare-operations-analytics/powerbi/dashboard_queries.sql):

- **Option A (Recommended):** In Power BI Desktop, use **Get Data → ODBC → Advanced options → SQL statement** and paste one query at a time to create a dedicated visual table.
- **Option B:** Import the base tables, then recreate the visuals using Power BI’s model relationships and measures (minimal or no DAX is needed for most charts here).

## Suggested Relationships (Model View)

These relationships match the current schema and keep the model simple:

- `Appointments[PatientID]` → `Patients[PatientID]` (Many-to-one)
- `Appointments[DoctorID]` → `Doctors[DoctorID]` (Many-to-one)
- `Appointments[FacilityID]` → `Facilities[FacilityID]` (Many-to-one)
- `Doctors[FacilityID]` → `Facilities[FacilityID]` (Many-to-one)
- `Invoices[AppointmentID]` → `Appointments[AppointmentID]` (Many-to-one)
- `Invoices[PatientID]` → `Patients[PatientID]` (Many-to-one)
- `Invoices[InsuranceID]` → `InsurancePlans[InsuranceID]` (Many-to-one)
- `Invoices[FacilityID]` → `Facilities[FacilityID]` (Many-to-one)
- `InvoiceLineItems[InvoiceID]` → `Invoices[InvoiceID]` (Many-to-one)
- `MedicalProcedures[AppointmentID]` → `Appointments[AppointmentID]` (Many-to-one)
- `Prescriptions[PatientID]` → `Patients[PatientID]` (Many-to-one)
- `Prescriptions[MedicationID]` → `Medications[MedicationID]` (Many-to-one)
- `LabResults[PatientID]` → `Patients[PatientID]` (Many-to-one)
- `PatientCoverage[PatientID]` → `Patients[PatientID]` (Many-to-one)
- `PatientCoverage[InsuranceID]` → `InsurancePlans[InsuranceID]` (Many-to-one)

## Dashboard Design (Single Page)

Build a single Power BI page with these visuals using the queries in `dashboard_queries.sql`:

- Top KPI Cards: Total Patients, Total Doctors, Total Appointments, Total Revenue
- Charts: Revenue by Month (Line), Department-wise Revenue (Bar), Appointments by Department (Column), Insurance Distribution (Pie), Top Procedures (Bar), Top Medications (Bar), Appointment Trend (Area)
- Tables: Recent Appointments, Top Revenue Patients
- Slicers: Department, Doctor, Insurance Plan, Date

## Refresh Notes

- If you regenerate the SQLite database (for example, by rerunning the app), refresh Power BI to pick up changes.
- The database file is stored under `runtime/`, so ensure the file path remains the same for Power BI refresh to work smoothly.
