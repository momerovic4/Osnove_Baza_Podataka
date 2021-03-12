ALTER SESSION SET CURRENT_SCHEMA = erd

--1
SELECT k.naziv AS Kontinent, Nvl(d.naziv, 'Nema drzave') AS Drzava, Nvl(g.naziv, 'Nema grada') AS Grad
FROM Kontinent k, Drzava d, grad g
WHERE k.kontinent_id = d.kontinent_id(+) AND d.drzava_id = g.drzava_id(+)

--2
SELECT DISTINCT p.naziv AS "naziv"
FROM pravno_lice p, ugovor_za_pravno_lice up
WHERE EXTRACT(YEAR FROM datum_potpisivanja) BETWEEN '2015' AND '2017'
AND up.pravno_lice_id = p.pravno_lice_id

--3
SELECT d.naziv AS Drazava, p.naziv AS Proizvod, k.kolicina_proizvoda AS Kolicina_proizvoda
FROM drzava d, proizvod p, kolicina k, lokacija l, grad g, skladiste s
WHERE g.drzava_id = d.drzava_id AND l.grad_id=g.grad_id AND s.lokacija_id = l.lokacija_id
AND s.skladiste_id = k.skladiste_id AND k.proizvod_id = p.proizvod_id
AND k.kolicina_proizvoda > 50 -;

--4
SELECT DISTINCT p.naziv, p.broj_mjeseci_garancije * 18772
FROM proizvod p, popust po, narudzba_proizvoda np
WHERE p.proizvod_id = np.proizvod_id AND po.popust_id = np.popust_id
AND po.postotak > 0
AND MOD(p.broj_mjeseci_garancije,3) = 0

--5
SELECT fl.ime || ' ' || fl.prezime AS "ime i prezime", o.naziv AS "Naziv odjela"
FROM fizicko_lice fl, odjel o, uposlenik u, kupac k
WHERE o.sef_id <> u.uposlenik_id AND fl.fizicko_lice_id = k.kupac_id
AND fl.fizicko_lice_id = u.uposlenik_id AND u.odjel_id = o.odjel_id

--6
SELECT n.narudzba_id AS Narudzba_id, p.cijena AS Cijena, nvl(pos.postotak,0) AS postotak
FROM NARUDZBA_PROIZVODA n, PROIZVOD p, POPUST pos
WHERE n.PROIZVOD_ID=p.PROIZVOD_ID AND n.POPUST_ID = pos.POPUST_ID(+) AND p.CIJENA*(nvl(pos.POSTOTAK,0)/100)<200

--7
SELECT k1.naziv "Kategorija", Decode(Nvl(k1.nadkategorija_id, 0), 0, 'Nema kategorije', 1 , 'Komp Oprema', k2.naziv) "Nadkategorija"
FROM kategorija k1, kategorija k2
WHERE k1.nadkategorija_id =  k2.kategorija_id(+)

--8
SSELECT trunc(months_between(To_Date('10.10.2020','dd.mm.yyyy'), upl.datum_potpisivanja) / 12) as Godina
,trunc(mod(months_between(To_Date('10.10.2020','dd.mm.yyyy'), upl.datum_potpisivanja), 12)) as Mjeseci
,trunc(To_Date('10.10.2020','dd.mm.yyyy') - add_months(upl.datum_potpisivanja, trunc(months_between(To_Date('10.10.2020','dd.mm.yyyy'), upl.datum_potpisivanja)))) as Dana
FROM  ugovor_za_pravno_lice upl
WHERE (Months_Between(To_Date('10.01.2020','dd.mm.yyyy'), trunc(upl.datum_potpisivanja)) / 12) >  to_number(SubStr(upl.ugovor_id,0,2))

--9
SELECT f.ime AS ime,  f.prezime AS prezime,
Decode(o.naziv,
  'Management', 'MANAGER',
  'Human resources', 'HUMAN',
  'OTHER') AS odjel
FROM odjel o, uposlenik u, fizicko_lice f
WHERE f.fizicko_lice_id = u.uposlenik_id AND u.odjel_id = o.odjel_id
ORDER BY f.ime ASC , f.prezime DESC

--10
SELECT k.naziv, p1.naziv AS Najskuplji, p2.naziv AS Najjefiniji, t1.max_price + t1.min_price AS ZCijena
FROM  (
  SELECT k.naziv AS Category,  Max(cijena) max_price, Min(cijena) min_price
  FROM kategorija k
  INNER JOIN proizvod p ON  p.kategorija_id=k.kategorija_id
  GROUP BY k.naziv
 ) t1
 INNER JOIN kategorija k ON k.naziv = t1.Category
 INNER JOIN proizvod  p1 ON p1.cijena = t1.max_price
 INNER JOIN proizvod  p2 ON p2.cijena = t1.min_price
 ORDER BY ZCijena ASC
