

with flu_shot_2022 as
(
select patient, min(date) as earliest_flu_shot_2022
from immunizations
where code = '5302'
	and date between '2022-01-01 00:00' and '2022-12-31 23:59'
group by patient
), active_patients as
(
	select distinct patient
	from encounters  e
	join patients as p
		on e.patient = p.id
	where start between '2020-01-01 00:00' and '2022-12-31 23:59'
		and p.deathdate is null
		and extract(month from age('2022-12-31',p.birthdate)) >=6
)
select pat.birthdate
      ,pat.race
	  ,pat.county
	  ,pat.id
	  ,pat.first
	  ,pat.last
	  ,pat.gender
	  ,extract(YEAR FROM age('12-31-2022', birthdate)) as age
	  ,flu.earliest_flu_shot_2022
	  ,flu.patient
	  ,case when flu.patient is not null then 1 
	   else 0
	   end as flu_shot_2022
from patients p
left join flu_shot_2022 as flu
	on p.id = flu.patient
where p.id in(select patient from active_patients)
	