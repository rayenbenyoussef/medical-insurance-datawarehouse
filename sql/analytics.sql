/*As your manager, 
I want a report showing the total insurance charges broken down by year, 
then by season within each year, 
then by BMI range within each season. 
I also want subtotals per year, 
subtotals per year+season, 
and a grand total at the end.*/

select t.year,
       t.season,
       b.bmi_range,
       sum(charges)
  from charges_fact f,
       time_dim t,
       bmi_dim b
 where f.id_intakedate = t.id_time
   and f.id_bmi = b.id_bmi
 group by rollup(t.year,
                 t.season,
                 b.bmi_range);


/*Now I want a more complete analysis. 
Show me the total charges by region and smoker status, 
but I want ALL possible combinations of subtotals — by region alone, 
by smoker status alone, 
by both together, and the grand total.*/

select R.region_name,S.is_smoker ,sum(F.charges) as total_charges
  from charges_fact F, region_dim R, smoker_dim S
  where F.id_region = R.id_region
   and F.id_smoker = S.id_smoker
   group by CUBE(R.region_name, S.is_smoker);


/*Same query as before with CUBE on region and smoker status, 
but the NULL values in the result are confusing my team. 
They can't tell if a NULL means it's a subtotal row or if the data is actually missing. 
Add columns to clearly identify which rows are subtotals.*/

select decode (grouping(R.region_name),1,'multi Regions',R.region_name) as region,
decode (grouping(S.is_smoker),1,'multi Smokers',S.is_smoker)as smoker ,sum(F.charges) as total_charges
         
  from charges_fact F, region_dim R, smoker_dim S
  where F.id_region = R.id_region
   and F.id_smoker = S.id_smoker
   group by CUBE(R.region_name, S.is_smoker);


/*I want the same CUBE query on region and smoker, 
but instead of two separate GROUPING columns, 
give me one single column that identifies the aggregation level of each row.*/

select R.region_name,S.is_smoker ,sum(F.charges) as total_charges,GROUPING_ID(R.region_name, S.is_smoker) as grouping_id
  from charges_fact F, region_dim R, smoker_dim S
  where F.id_region = R.id_region
   and F.id_smoker = S.id_smoker
   group by CUBE(R.region_name, S.is_smoker);