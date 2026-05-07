# medical-insurance-datawarehouse

# Transformation Matrix

| Target Field | Target Table | Source Field | Source Table | Transformation Rule |
|---|---|---|---|---|
| Id_time | TIME_DIM | -- | -- | Generated sequence: `SEQ_TIME.NEXTVAL` |
| Full_date | TIME_DIM | -- | -- | Random dates: `DATE '2025-01-01' + TRUNC(DBMS_RANDOM.VALUE(0,1200))` |
| month | TIME_DIM | Full_date | TIME_DIM | `EXTRACT(MONTH FROM full_date)` |
| day | TIME_DIM | Full_date | TIME_DIM | `EXTRACT(DAY FROM full_date)` |
| year | TIME_DIM | Full_date | TIME_DIM | `EXTRACT(YEAR FROM full_date)` |
| season | TIME_DIM | month | TIME_DIM | `CASE WHEN month IN (12,1,2) THEN 'Winter' WHEN month IN (3,4,5) THEN 'Spring' WHEN month IN (6,7,8) THEN 'Summer' ELSE 'Autumn' END` |
| Id_patient | PATIENT_DIM | -- | -- | Generated sequence: `SEQ_PAT.NEXTVAL` |
| age | PATIENT_DIM | age | insurance | Direct Copy |
| age_range | PATIENT_DIM | age | insurance | `CASE WHEN age < 18 THEN 'Teenager' WHEN age < 26 THEN 'Adult' WHEN age < 61 THEN 'Middle-aged' ELSE 'Elderly' END` |
| gender | PATIENT_DIM | gender | insurance | Direct Copy |
| Children_number | PATIENT_DIM | children | insurance | Direct Copy |
| id_smoker | SMOKER_DIM | -- | -- | Generated sequence: `SEQ_SMK.NEXTVAL` |
| isSmoker | SMOKER_DIM | smoker | insurance | Direct Copy |
| id_region | REGION_DIM | None | None | Generated sequence: `SEQ_REG.NEXTVAL` |
| region_name | REGION_DIM | region | insurance | Direct Copy |
| Id_bmi | BMI_DIM | -- | -- | Generated sequence: `SEQ_BMI.NEXTVAL` |
| bmi | BMI_DIM | bmi | insurance | Direct Copy |
| Bmi_range | BMI_DIM | bmi | insurance | `CASE WHEN bmi < 18.5 THEN 'Underweight' WHEN bmi < 25 THEN 'Normal' WHEN bmi < 30 THEN 'Overweight' ELSE 'Obesity' END` |
| Id_fact | CHARGES_FACT | -- | -- | Generated sequence: `SEQ_FACT.NEXTVAL` |
| Id_patient | CHARGES_FACT | Id_patient | PATIENT_DIM | Direct Copy |
| Id_intakeDate | CHARGES_FACT | Id_time | TIME_DIM | Direct Copy |
| id_bmi | CHARGES_FACT | Id_bmi | BMI_DIM | Direct Copy |
| Id_region | CHARGES_FACT | Id_region | REGION_DIM | Direct Copy |
| Id_smoker | CHARGES_FACT | Id_smoker | SMOKER_DIM | Direct Copy |
| charges | CHARGES_FACT | charges | insurance | Direct Copy |

```
