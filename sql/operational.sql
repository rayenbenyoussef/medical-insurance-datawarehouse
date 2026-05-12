create or replace directory insurance_dir as 'F:\code\medical-insurance-datawarehouse\data';

grant read,write on directory insurance_dir to rayen;

create table insurance (
   age      number,
   gender   varchar2(10),
   bmi      number(5,2),
   children number,
   smoker   varchar2(5),
   region   varchar2(20),
   charges  number(10,2)
)
organization external ( type oracle_loader
   default directory insurance_dir access parameters (
      records
      delimited by newline
      skip 1
      fields terminated by ',' optionally enclosed by '"'
   ) location ( 'insurance.csv' )
) reject limit unlimited;