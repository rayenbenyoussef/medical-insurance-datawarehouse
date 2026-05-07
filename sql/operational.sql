
create table insurance (
   age      number,
   gender      varchar2(10),
   bmi      number(5,2),
   children number,
   smoker   varchar2(5),
   region   varchar2(20),
   charges  number(10,2)
)

ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY insurance_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
    )
    LOCATION ('insurance.csv')
)
REJECT LIMIT UNLIMITED;
