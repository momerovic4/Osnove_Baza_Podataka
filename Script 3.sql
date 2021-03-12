--Tutorijal 3
--Z1:
SELECT sysdate "DATE", USER
FROM dual;

--Z2
SELECT e.employee_id AS sifra,
       e.first_name || ' ' || e.last_name AS naziv,
       e.salary AS plata,
       (e.salary * 1.25) AS "Plata uvecana za 25%"
FROM employees e;

--Z3
SELECT e.employee_id AS sifra,
       e.first_name || ' ' || e.last_name AS naziv,
       e.salary AS plata,
       (e.salary * 1.25) AS "Plata uvecana za 25%",
       lpad(To_Char(Mod(e.salary,100)), 2, '0') AS "ostatak plate"
FROM employees e;

--Z4
SELECT e.first_name || ' ' || e.last_name AS naziv,
       e.hire_date AS "datum saposljenja",
       To_Char(next_day(Add_Months(e.hire_date,6),'MON'),'DAY-MONTH,YYYY')
FROM employees e;

--Z5
SELECT e.first_name || ' ' || e.last_name AS naziv,
      d.department_name AS "naziv odjela",
      r.region_name AS "kontinent",
      Abs(Round(Months_Between(e.hire_date,SYSDATE))) AS "Koliko dugo je zaposlen"
FROM employees e, departments d, regions r, locations l, countries c
WHERE e.department_id = d.department_id AND
      d.location_id = l.location_id AND
      l.country_id = c.country_id AND
      c.region_id = r.region_id;

--Z6
SELECT e.first_name || ' ' || e.last_name AS naziv,
       e.salary AS plata,
       ((e.salary + e.salary*Nvl(e.commission_pct,0))*4.5) AS "Plata koju bi zelio"
FROM employees e
WHERE e.department_id IN (10,30,50);

--z7
SELECT e.first_name || ' ' || e.last_name AS naziv,
       LPad(e.salary,50,'$') AS "plata"
FROM employees e;

--8
SELECT Lower(substr(first_name,1,1)) || upper(substr(first_name || ' ' || last_name,2)),
       Length(first_name || '' || last_name) AS "Duzina naziva"
FROM employees
WHERE first_name LIKE 'A%' OR
      first_name LIKE 'J%' OR
      first_name LIKE 'M%' OR
      first_name LIKE 'S%';

--9
SELECT first_name || ' ' || last_name AS "naziv zaposlenog",
       To_Char(hire_date, 'dd.mm.yyyy') AS "datum zaposljenja",
       TO_CHAR(hire_date, 'DAY') AS dan
FROM employees
order BY mod(to_char(hire_date, 'D') + 5, 7);

--10
SELECT e.first_name || ' ' || e.last_name AS "naziv zaposlenog",
       l.city AS "naziv grada",
       decode(e.commission_pct,
              NULL,'ne prima dodatak na platu'
                  ,e.commission_pct)
FROM employees e, locations l,departments d
WHERE e.department_id = d.department_id AND l.location_id = d.location_id;

--11
SELECT e.first_name || ' ' || e.last_name AS "naziv zaposlenog",
       e.salary AS plata,
       SubStr('***********************',1,(Round(e.salary,-3)/1000))
FROM employees e;

--12
SELECT e.first_name || ' ' || e.last_name AS "naziv zaposlenog",
       Decode(j.job_title,
          'President', 'A',
          'Manager', 'B',
          'Analyst', 'C',
          'Sales Manager', 'D',
          'Programmer', 'E',
          'X') AS "Stepen posla"
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

--Tutorijal4
--10
SELECT j.job_title "Posao",
        Decode(e.department_id,
          '10', Sum(e.salary), 0) "Odjel 10",
        Decode(e.department_id,
          '30', Sum(e.salary), 0) "Odjel 30",
        Decode(e.department_id,
          '50', Sum(e.salary), 0) "Odjel 50",
        Decode(e.department_id,
          '90', Sum(e.salary), 0) "Odjel 90",
        Decode(e.department_id,
             '10', Sum(e.salary),
             '30', Sum(e.salary),
             '50', Sum(e.salary),
             '90', Sum(e.salary),
             0
        ) "Ukupno"
FROM employees e, jobs j
WHERE e.job_id = j.job_id
GROUP BY j.job_title, e.department_id;

--primjer 5tut
SELECT e.employee_id "sifra",
       e.first_name || ' ' || e.last_name AS "naziv",
       e.salary "plata",
       Nvl(To_Char(e.salary + e.salary*e.commission_pct),'Nema dodatka na platu') "dodatak"
FROM employees e
WHERE (SELECT Avg(e2.salary)
        FROM employees e2
        WHERE e2.employee_id IN (SELECT DISTINCT e3.manager_id FROM employees e3) AND
        e.department_id = e2.department_id)
        >
        (SELECT Avg(e4.salary)
            FROM employees e4
            WHERE e4.department_id <> e.department_id);

--kako je zapravo na tutu
SELECT e.employee_id "šifra",
e.last_name || ' ' || e.first_name "naziv",
e.salary plata
FROM employees e
WHERE e.salary > ALL (SELECT t.salary
                      FROM employees t
                      WHERE t.department_id IN (60,90))
      AND e.department_id NOT IN (60,90);

--ovako na tutu
SELECT e.employee_id "šifra",
e.last_name || ' ' || e.first_name "naziv",
e.salary "plata",
nvl(to_char((SELECT t.salary * (1 + t.commission_pct)
 FROM employees t
 WHERE e.employee_id = t.employee_id)),
 'Nema dodatka na platu') "dodatak"
FROM employees e
WHERE e.salary > ALL (SELECT t.salary
 FROM employees t
 WHERE t.department_id IN (60,90))
 and e.department_id NOT IN (60,90);

--prijer
SELECT e.first_name || ' ' || e.last_name AS "Naziv",
       d.department_name AS "Naziv odjela",
       j.job_title AS "naziv posla",
       l.city AS "grad",
       e.salary AS "Plata"
FROM employees e, departments d, jobs j, locations l
WHERE e.job_id = j.job_id AND e.department_id = d.department_id AND d.location_id = l.location_id AND
      e.department_id IN (10,30,50,60,90)
      AND EXISTS(
        SELECT *
        FROM employees e2,locations l2,departments d2, countries c, regions r
        WHERE e2.department_id = d2.department_id AND d2.location_id = l2.location_id
        AND r.region_id = c.region_id AND l2.country_id = c.country_id
        AND d2.department_id IN (10,30,50,60,90)
        AND Lower(To_Char(SubStr(r.region_name,1,7))) LIKE '%america%'
      );

--ovako oni
SELECT e.last_name || e.first_name naziv,
 d.department_name odjel,
 l.city grad,
 j.job_title posao,
 e.salary plata
FROM employees e, departments d, jobs j, locations l
WHERE e.department_id = d.department_id
 and e.job_id = j.job_id
 and d.location_id = l.location_id
 and EXISTS (SELECT e1.employee_id, d1.department_id,
 l1.location_id, c1.country_id,
 r1.region_id
 FROM employees e1,departments d1,
 locations l1,countries c1,
 regions r1
 WHERE e1.department_id = d1.department_id
 and d1.location_id = l1.location_id
 and l1.country_id = c1.country_id
 and c1.region_id = r1.region_id
 and d1.department_id IN (10,30,50,60,90)
 and lower(substr(r1.region_name,1,7)) =
 'america')
 and d.department_id IN (10,30,50,60,90);