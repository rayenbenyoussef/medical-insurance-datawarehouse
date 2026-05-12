CREATE OR REPLACE DIRECTORY insurance_dir AS '/home/oracle/data';
grant read,write on directory insurance_dir to SYS;

CREATE TABLE insurance (
   age      NUMBER,
   gender   VARCHAR2(10),
   bmi      NUMBER(5,2),
   children NUMBER,
   smoker   VARCHAR2(5),
   region   VARCHAR2(20),
   charges  NUMBER(10,2),
   intakeDate DATE
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY insurance_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        (
            age,
            gender,
            bmi,
            children,
            smoker,
            region,
            charges,
            intakeDate DATE 'YYYY-MM-DD'
        )
    )
    LOCATION ('insurance.csv')
)
REJECT LIMIT UNLIMITED;