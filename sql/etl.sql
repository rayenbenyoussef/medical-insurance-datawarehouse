create or replace procedure load_time_dim is
   v_id_time time_dim.id_time%type;
begin
   for rec in (
      select distinct intakedate
        from insurance
   ) loop
      v_id_time := time_seq.nextval;
      insert into time_dim (
         id_time,
         full_date,
         year,
         month,
         day,
         season
      ) values ( v_id_time,
                 rec.intakedate,
                 extract(year from rec.intakedate),
                 extract(month from rec.intakedate),
                 extract(day from rec.intakedate),
                 get_season(extract(month from rec.intakedate)) );
   end loop;
   commit;
end;
/
create or replace procedure load_patient_dim is
   v_id_patient patient_dim.id_patient%type;
begin
   for rec in (
      select distinct age,
                      gender,
                      children
        from insurance
       order by age
   ) loop
      v_id_patient := patient_seq.nextval;
      insert into patient_dim values ( v_id_patient,
                                       rec.age,
                                       get_age_group(rec.age),
                                       rec.gender,
                                       rec.children );
   end loop;
   commit;
end;
/
create or replace procedure load_smoker_dim is
   v_id_smoker smoker_dim.id_smoker%type;
begin
   for rec in (
      select distinct smoker
        from insurance
   ) loop
      v_id_smoker := smoker_seq.nextval;
      insert into smoker_dim values ( v_id_smoker,
                                      rec.smoker );
   end loop;
   commit;
end;
/
create or replace procedure load_region_dim is
   v_id_region region_dim.id_region%type;
begin
   for rec in (
      select distinct region
        from insurance
   ) loop
      v_id_region := region_seq.nextval;
      insert into region_dim values ( v_id_region,
                                      rec.region );
   end loop;
   commit;
end;

create or replace procedure load_bmi_dim is
   v_id_bmi bmi_dim.id_bmi%type;
begin
   for rec in (
      select distinct bmi
        from insurance
       order by bmi
   ) loop
      v_id_bmi := bmi_seq.nextval;
      insert into bmi_dim values ( v_id_bmi,
                                   rec.bmi,
                                   get_bmi_range(rec.bmi) );
   end loop;
   commit;
end;

create or replace procedure load_charges_fact is
   v_id_patient patient_dim.id_patient%type;
   v_id_time    time_dim.id_time%type;
   v_id_bmi     bmi_dim.id_bmi%type;
   v_id_region  region_dim.id_region%type;
   v_id_smoker  smoker_dim.id_smoker%type;
begin
   for rec in (
      select age,
             gender,
             bmi,
             children,
             smoker,
             region,
             charges,
             intakedate
        from insurance
   ) loop
      select id_patient
        into v_id_patient
        from patient_dim
       where age = rec.age
         and gender = rec.gender
         and children = rec.children;
      select id_time
        into v_id_time
        from time_dim
       where full_date = rec.intakedate;
      select id_bmi
        into v_id_bmi
        from bmi_dim
       where bmi = rec.bmi;
      select id_region
        into v_id_region
        from region_dim
       where region_name = rec.region;
      select id_smoker
        into v_id_smoker
        from smoker_dim
       where is_smoker = rec.smoker;
      insert into charges_fact values ( v_id_patient,
                                        v_id_time,
                                        v_id_bmi,
                                        v_id_region,
                                        v_id_smoker,
                                        rec.charges );
   end loop;
   commit;
end;
/
create or replace procedure delete_all_data is
begin
   delete from charges_fact;
   delete from patient_dim;
   delete from time_dim;
   delete from bmi_dim;
   delete from region_dim;
   delete from smoker_dim;
   commit;
end;
/