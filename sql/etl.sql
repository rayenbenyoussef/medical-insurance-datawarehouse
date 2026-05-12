create or replace procedure load_tables is
   cursor c_insurance is
   select *
     from insurance;
   id_patient number;
   id_time    number;
   id_smoker  number;
   id_region  number;
   id_bmi     number;
   id_fact    number;
begin
   for c in c_insurance loop
      select patient_seq.nextval
        into id_patient
        from dual;
      select time_seq.nextval
        into id_time
        from dual;
      select smoker_seq.nextval
        into id_smoker
        from dual;
      select region_seq.nextval
        into id_region
        from dual;
      select bmi_seq.nextval
        into id_bmi
        from dual;
      select fact_seq.nextval
        into id_fact
        from dual;

      insert into patient_dim values ( id_patient,
                                       c.age,
                                       get_age_group(c.age),
                                       c.sex,
                                       c.children );
      insert into time_dim values ( id_time,
                                    date '2025-01-01' + trunc(dbms_random.value(
                                       0,
                                       1200
                                    )),
                                    extract(month from date '2025-01-01' + trunc(dbms_random.value(
                                       0,
                                       1200
                                    ))),
                                    extract(day from date '2025-01-01' + trunc(dbms_random.value(
                                       0,
                                       1200
                                    ))),
                                    extract(year from date '2025-01-01' + trunc(dbms_random.value(
                                       0,
                                       1200
                                    ))),
                                    get_season(extract(month from date '2025-01-01' + trunc(dbms_random.value(
                                       0,
                                       1200
                                    )))) );
      insert into smoker_dim values ( id_smoker,
                                      c.smoker );
      insert into region_dim values ( id_region,
                                      c.region );
      insert into bmi_dim values ( id_bmi,
                                   c.bmi,
                                   get_bmi_range(c.bmi) );
      insert into charges_fact values ( id_fact,
                                        id_patient,
                                        id_time,
                                        id_bmi,
                                        id_region,
                                        id_smoker,
                                        c.charges );

   end loop;
end;