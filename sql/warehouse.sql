create table PATIENT_DIM(
    id_patient number primary key,
    age number,
    age_range varchar2(20),
    gender varchar2(10),
    children_number number
);

create table TIME_DIM(
    id_time number primary key,
    full_date date,
    year number,
    month number,
    day number,
    season varchar2(20)
);

create table SMOKER_DIM(
    id_smoker number primary key,
    is_smoker varchar2(5)
);
create table REGION_DIM(
    id_region number primary key,
    region_name varchar2(20)
);
create table BMI_DIM(
    id_bmi number primary key,
    BMI number(5,2) Not null,
    bmi_range varchar2(30)
);
create table CHARGES_FACT(
    id_fact number primary key,
    id_patient number,
    id_intakeDate number,
    id_bmi number,
    id_region number,
    id_smoker number,
    charges number(10,2),
    CONSTRAINT fk_patient FOREIGN KEY (id_patient) REFERENCES PATIENT_DIM(id_patient),
    CONSTRAINT fk_time FOREIGN KEY (id_intakeDate) REFERENCES TIME_DIM(id_time),
    CONSTRAINT fk_bmi FOREIGN KEY (id_bmi) REFERENCES BMI_DIM(id_bmi),
    CONSTRAINT fk_region FOREIGN KEY (id_region) REFERENCES REGION_DIM(id_region),
    CONSTRAINT fk_smoker FOREIGN KEY (id_smoker) REFERENCES SMOKER_DIM(id_smoker)
);

create sequence patient_seq start with 1 increment by 1 NOCYCLE;
create sequence time_seq start with 1 increment by 1 NOCYCLE;
create sequence smoker_seq start with 1 increment by 1 NOCYCLE;
create sequence region_seq start with 1 increment by 1 NOCYCLE;
create sequence bmi_seq start with 1 increment by 1 NOCYCLE;
create sequence fact_seq start with 1 increment by 1 NOCYCLE;

create or replace TRIGGER trg_bmi
BEFORE INSERT or UPDATE ON BMI_DIM 
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.id_bmi := bmi_seq.NEXTVAL;
    END IF;
    if :NEW.BMI <18.5 then
        :NEW.bmi_range := 'Underweight';
    elsif :NEW.BMI <26 then
        :NEW.bmi_range := 'Normal';
    elsif :NEW.BMI <30 then
        :NEW.bmi_range := 'Overweight';
    else
        :NEW.bmi_range := 'Obese';
    end if;
end;

create or replace TRIGGER trg_patient
before INSERT OR UPDATE ON PATIENT_DIM
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.id_patient := patient_seq.NEXTVAL;
    END IF;
    CASE 
        WHEN age <18 THEN :NEW.age_range:='Teenager';
        WHEN age <26 THEN :NEW.age_range:='adult';
        WHEN age < 61 THEN :NEW.age_range:='Middle-aged';
        ELSE :NEW.age_range:='Elderly' ;
    END CASE;
END;

create or replace TRIGGER trg_time
before INSERT OR UPDATE ON TIME_DIM
FOR EACH ROW
BEGIN 
    IF INSERTING THEN
        :NEW.id_time := time_seq.NEXTVAL;
    END IF;
    :NEW.month :=extract(month from :NEW.full_date);
    :NEW.day :=extract(day from :NEW.full_date);
    :NEW.year :=extract(year from :NEW.full_date);
    CASE 
        WHEN :NEW.month IN (12,1,2) THEN :NEW.season :='Winter';
        WHEN :NEW.month IN (3,4,5) THEN :NEW.season :='Spring';
        WHEN :NEW.month IN (6,7,8) THEN :NEW.season :='Summer';
        ELSE :NEW.season :='Autumn' ;
    END CASE;
END;

create or replace TRIGGER trg_smoker
before INSERT OR UPDATE ON SMOKER_DIM
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.id_smoker := smoker_seq.NEXTVAL;
    END IF;
END;

create or replace TRIGGER trg_region
before INSERT OR UPDATE ON REGION_DIM
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.id_region := region_seq.NEXTVAL;
    END IF;
END;

create or replace TRIGGER trg_fact
before INSERT OR UPDATE ON CHARGES_FACT
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.id_fact := fact_seq.NEXTVAL;
    END IF;
END;

