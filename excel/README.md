# Healthcare Operations Analytics - Excel Dashboard

## Purpose
This Excel workbook serves as a supplementary reporting layer to the Healthcare Operations Analytics Platform. It demonstrates how core operational data can be exported and modeled in Microsoft Excel for ad-hoc exploratory data analysis, reporting, and dashboarding using standard Excel features.

## Sheets Included
The workbook contains the following normalized data sheets populated from the operational database:
- **Patients**: Patient demographics and contact information.
- **Doctors**: Physician details including specialization and facility assignment.
- **Appointments**: Encounter records linking patients, doctors, and facilities.
- **Billing**: Invoice records detailing total charges, insurance coverage, and patient responsibility.
- **Dashboard**: A consolidated view of key performance indicators (KPIs) and operational trends.

## Dashboard Overview
The Dashboard sheet provides a high-level summary of operations using formulas (e.g., `SUM`, `AVERAGE`, `COUNTIF`, `MAX`, `MIN`, `IF`). It highlights key metrics such as Total Patients, Total Doctors, Total Appointments, and Total Revenue. It leverages Conditional Formatting on the billing data to instantly identify high-value invoices, providing quick insights into revenue health. 

## Pivot Tables Used
Pivot table structures are used behind the scenes (in the `ChartData` sheet) to aggregate raw operational data for visualization. They summarize:
- Revenue aggregated by Month.
- Appointment volumes grouped by clinical Department/Specialization.
- Patient volume distributed by Insurance Payer.

## Charts Included
The dashboard visualizes these aggregations using standard Excel Pivot Charts:
- **Monthly Revenue**: A Column Chart tracking financial performance over time.
- **Appointments by Department**: A Bar Chart comparing patient volume across various clinical specialties.
- **Insurance Distribution**: A Pie Chart breaking down the payer mix.
- **Top 5 Departments**: A Column Chart highlighting the highest-demand clinical areas.
