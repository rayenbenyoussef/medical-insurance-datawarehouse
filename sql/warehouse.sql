create table patient_dim (
   id_patient      number primary key,
   age             number,
   age_range       varchar2(20),
   sex             varchar2(10),
   children_number number
);

create table time_dim (
   id_time   number primary key,
   full_date date,
   year      number,
   month     number,
   day       number,
   season    varchar2(20)
);

create table smoker_dim (
   id_smoker number primary key,
   is_smoker varchar2(5)
);
create table region_dim (
   id_region   number primary key,
   region_name varchar2(20)
);
create table bmi_dim (
   id_bmi    number primary key,
   bmi       number(5,2) not null,
   bmi_range varchar2(30)
);
create table charges_fact (
   id_fact       number primary key,
   id_patient    number,
   id_intakedate number,
   id_bmi        number,
   id_region     number,
   id_smoker     number,
   charges       number(10,2),
   constraint fk_patient foreign key ( id_patient )
      references patient_dim ( id_patient ),
   constraint fk_time foreign key ( id_intakedate )
      references time_dim ( id_time ),
   constraint fk_bmi foreign key ( id_bmi )
      references bmi_dim ( id_bmi ),
   constraint fk_region foreign key ( id_region )
      references region_dim ( id_region ),
   constraint fk_smoker foreign key ( id_smoker )
      references smoker_dim ( id_smoker )
);

create sequence patient_seq start with 1 increment by 1 nocycle;
create sequence time_seq start with 1 increment by 1 nocycle;
create sequence smoker_seq start with 1 increment by 1 nocycle;
create sequence region_seq start with 1 increment by 1 nocycle;
create sequence bmi_seq start with 1 increment by 1 nocycle;
create sequence fact_seq start with 1 increment by 1 nocycle;

create function get_age_group (
   age patient_dim.age%type
) return varchar2 is
begin
   if age < 18 then
      return 'Teenager';
   elsif age < 26 then
      return 'Adult';
   elsif age < 61 then
      return 'Middle-aged';
   else
      return 'Elderly';
   end if;
end;

create function get_season (
   month number
) return varchar2 is
begin
   if month in ( 12,
                 1,
                 2 ) then
      return 'Winter';
   elsif month in ( 3,
                    4,
                    5 ) then
      return 'Spring';
   elsif month in ( 6,
                    7,
                    8 ) then
      return 'Summer';
   else
      return 'Autumn';
   end if;
end;

create function get_bmi_range (
   bmi bmi_dim.bmi%type
) return varchar2 is
begin
   if bmi < 18.5 then
      return 'Underweight';
   elsif bmi < 26 then
      return 'Normal';
   elsif bmi < 30 then
      return 'Overweight';
   else
      return 'Obese';
   end if;
end;