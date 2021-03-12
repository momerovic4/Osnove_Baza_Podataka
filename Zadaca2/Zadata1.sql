----------------------------------------------------------------------------------------------------------------------7
--Zadatak1
-----------------------------------------------------------------------------------------------------------------------
ALTER SESSION SET CURRENT_SCHEMA = erd;
--1. Zadatak:
select distinct p.NAZIV as ResNaziv from PRAVNO_LICE p
where exists(select * from FIZICKO_LICE fl,LOKACIJA l where
            fl.LOKACIJA_ID = l.LOKACIJA_ID and p.LOKACIJA_ID = fl.LOKACIJA_ID);
--1. Rezultat: 207
SELECT Sum(Length(ResNaziv)*3) FROM
(select distinct p.NAZIV as ResNaziv from PRAVNO_LICE p
where exists(select * from FIZICKO_LICE fl,LOKACIJA l where
            fl.LOKACIJA_ID = l.LOKACIJA_ID and p.LOKACIJA_ID = fl.LOKACIJA_ID));

SELECT Sum(Length(ResNaziv)*7) FROM
(select distinct p.NAZIV as ResNaziv from PRAVNO_LICE p
where exists(select * from FIZICKO_LICE fl,LOKACIJA l where
            fl.LOKACIJA_ID = l.LOKACIJA_ID and p.LOKACIJA_ID = fl.LOKACIJA_ID));
-----------------------------------------------------------------------------------------------------------
--2. Zadatak
select distinct pl.NAZIV as ResNaziv, TO_CHAR(upl.DATUM_POTPISIVANJA, 'dd.MM.yyyy') as "Datum Potpisivanja"
from PRAVNO_LICE pl, UGOVOR_ZA_PRAVNO_LICE upl
where pl.PRAVNO_LICE_ID = upl.PRAVNO_LICE_ID
and upl.DATUM_POTPISIVANJA > (select min(f.DATUM_KUPOPRODAJE) from FAKTURA f, PROIZVOD p, NARUDZBA_PROIZVODA np
                              where f.FAKTURA_ID = np.FAKTURA_ID
                                and p.PROIZVOD_ID = np.PROIZVOD_ID
                                and p.BROJ_MJESECI_GARANCIJE is not null);
--2. Rezultat: 402
SELECT Sum(Length(ResNaziv)*3 + Length("Datum Potpisivanja")*3) FROM
(select distinct pl.NAZIV as ResNaziv, TO_CHAR(upl.DATUM_POTPISIVANJA, 'dd.MM.yyyy') as "Datum Potpisivanja"
from PRAVNO_LICE pl, UGOVOR_ZA_PRAVNO_LICE upl
where pl.PRAVNO_LICE_ID = upl.PRAVNO_LICE_ID
and upl.DATUM_POTPISIVANJA > (select min(f.DATUM_KUPOPRODAJE) from FAKTURA f, PROIZVOD p, NARUDZBA_PROIZVODA np
                              where f.FAKTURA_ID = np.FAKTURA_ID
                                and p.PROIZVOD_ID = np.PROIZVOD_ID
                                and p.BROJ_MJESECI_GARANCIJE is not null));

SELECT Sum(Length(ResNaziv)*7 + Length("Datum Potpisivanja")*7) FROM
(select distinct pl.NAZIV as ResNaziv, TO_CHAR(upl.DATUM_POTPISIVANJA, 'dd.MM.yyyy') as "Datum Potpisivanja"
from PRAVNO_LICE pl, UGOVOR_ZA_PRAVNO_LICE upl
where pl.PRAVNO_LICE_ID = upl.PRAVNO_LICE_ID
and upl.DATUM_POTPISIVANJA > (select min(f.DATUM_KUPOPRODAJE) from FAKTURA f, PROIZVOD p, NARUDZBA_PROIZVODA np
                              where f.FAKTURA_ID = np.FAKTURA_ID
                                and p.PROIZVOD_ID = np.PROIZVOD_ID
                                and p.BROJ_MJESECI_GARANCIJE is not null));
------------------------------------------------------------------------------------------------------------------
--3. Zadatak:
select * from KATEGORIJA;

select p.NAZIV from PROIZVOD p
where p.KATEGORIJA_ID = any (select p2.KATEGORIJA_ID from PROIZVOD p2, KOLICINA k
                            where p2.PROIZVOD_ID = k.PROIZVOD_ID
                            and k.KOLICINA_PROIZVODA = (select max(k2.KOLICINA_PROIZVODA) from KOLICINA k2));
--3. Rezultat: 51
SELECT Sum(Length(naziv)*3) FROM
(select p.NAZIV from PROIZVOD p
where p.KATEGORIJA_ID = any (select p2.KATEGORIJA_ID from PROIZVOD p2, KOLICINA k
                            where p2.PROIZVOD_ID = k.PROIZVOD_ID
                            and k.KOLICINA_PROIZVODA = (select max(k2.KOLICINA_PROIZVODA) from KOLICINA k2)));

SELECT Sum(Length(naziv)*7) FROM
(select p.NAZIV from PROIZVOD p
where p.KATEGORIJA_ID = any (select p2.KATEGORIJA_ID from PROIZVOD p2, KOLICINA k
                            where p2.PROIZVOD_ID = k.PROIZVOD_ID
                            and k.KOLICINA_PROIZVODA = (select max(k2.KOLICINA_PROIZVODA) from KOLICINA k2)));
---------------------------------------------------------------------------------------------------------------------
--4. Zadatak:
select p.NAZIV, pl.NAZIV from PROIZVOD p, PROIZVODJAC pr,PRAVNO_LICE pl
where pl.PRAVNO_LICE_ID = pr.PROIZVODJAC_ID and pr.PROIZVODJAC_ID = p.PROIZVODJAC_ID
and exists(select 'x' from PROIZVOD p2
            where pr.PROIZVODJAC_ID = p2.PROIZVODJAC_ID
            and p2.CIJENA > (select avg(p3.CIJENA) from PROIZVOD p3));
--4. Rezultat: 504
SELECT Sum(Length("Proizvod")*3 + Length("Proizvodjac")*3) FROM
(select p.NAZIV as "Proizvod", pl.NAZIV as "Proizvodjac" from PROIZVOD p, PROIZVODJAC pr,PRAVNO_LICE pl
where pl.PRAVNO_LICE_ID = pr.PROIZVODJAC_ID and pr.PROIZVODJAC_ID = p.PROIZVODJAC_ID
and exists(select 'x' from PROIZVOD p2
            where pr.PROIZVODJAC_ID = p2.PROIZVODJAC_ID
            and p2.CIJENA > (select avg(p3.CIJENA) from PROIZVOD p3)));

SELECT Sum(Length("Proizvod")*7 + Length("Proizvodjac")*7) FROM
(select p.NAZIV as "Proizvod", pl.NAZIV as "Proizvodjac" from PROIZVOD p, PROIZVODJAC pr,PRAVNO_LICE pl
where pl.PRAVNO_LICE_ID = pr.PROIZVODJAC_ID and pr.PROIZVODJAC_ID = p.PROIZVODJAC_ID
and exists(select 'x' from PROIZVOD p2
            where pr.PROIZVODJAC_ID = p2.PROIZVODJAC_ID
            and p2.CIJENA > (select avg(p3.CIJENA) from PROIZVOD p3)));
---------------------------------------------------------------------------------------------------------------
--5. Zadatak:
select fl.IME || ' ' ||fl.PREZIME as "Ime i prezime", sum(nvl(f.IZNOS,0)) as "iznos" from FIZICKO_LICE fl, KUPAC k, UPOSLENIK u, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and u.UPOSLENIK_ID = fl.FIZICKO_LICE_ID
and f.KUPAC_ID = k.KUPAC_ID
having sum(f.IZNOS) > (select round(avg(sum(f2.IZNOS)),2) from FAKTURA f2, KUPAC k2, FIZICKO_LICE fl2
                                where f2.KUPAC_ID = k2.KUPAC_ID and k2.KUPAC_ID = fl2.FIZICKO_LICE_ID
                                group by fl2.IME, fl2.PREZIME)
group by fl.IME, fl.PREZIME
order by fl.IME, fl.PREZIME;
--5. Rezultat: 6897
SELECT Sum(Length("Ime i prezime")*3 + "iznos"*3) FROM
(select fl.IME || ' ' ||fl.PREZIME as "Ime i prezime", sum(nvl(f.IZNOS,0)) as "iznos" from FIZICKO_LICE fl, KUPAC k, UPOSLENIK u, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and u.UPOSLENIK_ID = fl.FIZICKO_LICE_ID
and f.KUPAC_ID = k.KUPAC_ID
having sum(f.IZNOS) > (select round(avg(sum(f2.IZNOS)),2) from FAKTURA f2, KUPAC k2, FIZICKO_LICE fl2
                                where f2.KUPAC_ID = k2.KUPAC_ID and k2.KUPAC_ID = fl2.FIZICKO_LICE_ID
                                group by fl2.IME, fl2.PREZIME)
group by fl.IME, fl.PREZIME
order by fl.IME, fl.PREZIME);

SELECT Sum(Length("Ime i prezime")*7 + "iznos"*7) FROM
(select fl.IME || ' ' ||fl.PREZIME as "Ime i prezime", sum(nvl(f.IZNOS,0)) as "iznos" from FIZICKO_LICE fl, KUPAC k, UPOSLENIK u, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and u.UPOSLENIK_ID = fl.FIZICKO_LICE_ID
and f.KUPAC_ID = k.KUPAC_ID
having sum(f.IZNOS) > (select round(avg(sum(f2.IZNOS)),2) from FAKTURA f2, KUPAC k2, FIZICKO_LICE fl2
                                where f2.KUPAC_ID = k2.KUPAC_ID and k2.KUPAC_ID = fl2.FIZICKO_LICE_ID
                                group by fl2.IME, fl2.PREZIME)
group by fl.IME, fl.PREZIME
order by fl.IME, fl.PREZIME);
------------------------------------------------------------------------------------------------------------------
--6. Zadatak:
select pl.NAZIV as "naziv"
from PRAVNO_LICE pl, KURIRSKA_SLUZBA kur, ISPORUKA isp, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po
where kur.KURIRSKA_SLUZBA_ID = pl.PRAVNO_LICE_ID
and kur.KURIRSKA_SLUZBA_ID = isp.KURIRSKA_SLUZBA_ID
and isp.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and po.POSTOTAK is not null
having sum(np.KOLICINA_JEDNOG_PROIZVODA) in (select max(sum(np2.KOLICINA_JEDNOG_PROIZVODA))
                                            from PRAVNO_LICE pl2, KURIRSKA_SLUZBA kur2, ISPORUKA is2, FAKTURA f2, NARUDZBA_PROIZVODA np2, POPUST po2
                                            where kur2.KURIRSKA_SLUZBA_ID = pl2.PRAVNO_LICE_ID
                                            and kur2.KURIRSKA_SLUZBA_ID = is2.KURIRSKA_SLUZBA_ID
                                            and is2.ISPORUKA_ID = f2.ISPORUKA_ID
                                            and f2.FAKTURA_ID = np2.FAKTURA_ID
                                            and np2.POPUST_ID = po2.POPUST_ID
                                            and po2.POSTOTAK is not null
                                            group by kur2.KURIRSKA_SLUZBA_ID)
group by pl.NAZIV;
--6. Rezultat: 18
SELECT Sum(Length("naziv")*3) FROM
(select pl.NAZIV as "naziv"
from PRAVNO_LICE pl, KURIRSKA_SLUZBA kur, ISPORUKA isp, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po
where kur.KURIRSKA_SLUZBA_ID = pl.PRAVNO_LICE_ID
and kur.KURIRSKA_SLUZBA_ID = isp.KURIRSKA_SLUZBA_ID
and isp.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and po.POSTOTAK is not null
having sum(np.KOLICINA_JEDNOG_PROIZVODA) in (select max(sum(np2.KOLICINA_JEDNOG_PROIZVODA))
                                            from PRAVNO_LICE pl2, KURIRSKA_SLUZBA kur2, ISPORUKA is2, FAKTURA f2, NARUDZBA_PROIZVODA np2, POPUST po2
                                            where kur2.KURIRSKA_SLUZBA_ID = pl2.PRAVNO_LICE_ID
                                            and kur2.KURIRSKA_SLUZBA_ID = is2.KURIRSKA_SLUZBA_ID
                                            and is2.ISPORUKA_ID = f2.ISPORUKA_ID
                                            and f2.FAKTURA_ID = np2.FAKTURA_ID
                                            and np2.POPUST_ID = po2.POPUST_ID
                                            and po2.POSTOTAK is not null
                                            group by kur2.KURIRSKA_SLUZBA_ID)
group by pl.NAZIV);

SELECT Sum(Length("naziv")*7) FROM
(select pl.NAZIV as "naziv"
from PRAVNO_LICE pl, KURIRSKA_SLUZBA kur, ISPORUKA isp, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po
where kur.KURIRSKA_SLUZBA_ID = pl.PRAVNO_LICE_ID
and kur.KURIRSKA_SLUZBA_ID = isp.KURIRSKA_SLUZBA_ID
and isp.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and po.POSTOTAK is not null
having sum(np.KOLICINA_JEDNOG_PROIZVODA) in (select max(sum(np2.KOLICINA_JEDNOG_PROIZVODA))
                                            from PRAVNO_LICE pl2, KURIRSKA_SLUZBA kur2, ISPORUKA is2, FAKTURA f2, NARUDZBA_PROIZVODA np2, POPUST po2
                                            where kur2.KURIRSKA_SLUZBA_ID = pl2.PRAVNO_LICE_ID
                                            and kur2.KURIRSKA_SLUZBA_ID = is2.KURIRSKA_SLUZBA_ID
                                            and is2.ISPORUKA_ID = f2.ISPORUKA_ID
                                            and f2.FAKTURA_ID = np2.FAKTURA_ID
                                            and np2.POPUST_ID = po2.POPUST_ID
                                            and po2.POSTOTAK is not null
                                            group by kur2.KURIRSKA_SLUZBA_ID)
group by pl.NAZIV);
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--7. Zadatak:
select distinct fl.IME || ' ' || fl.PREZIME as "Kupac", sum(pomocna.Usteda) as "Usteda"
from(select (po2.POSTOTAK/100 * p2.CIJENA * np2.KOLICINA_JEDNOG_PROIZVODA) Usteda, np2.FAKTURA_ID faktura_id
    from POPUST po2, PROIZVOD p2, NARUDZBA_PROIZVODA np2
    where np2.POPUST_ID = po2.POPUST_ID and np2.PROIZVOD_ID = p2.PROIZVOD_ID) pomocna,
FIZICKO_LICE fl, KUPAC k, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and k.KUPAC_ID = f.KUPAC_ID
and f.FAKTURA_ID = pomocna.faktura_id
group by fl.IME || ' ' || fl.PREZIME;
--7. Rezultat 17709
SELECT Sum(Length("Kupac")*3 + Round("Usteda")*3) FROM
(select distinct fl.IME || ' ' || fl.PREZIME as "Kupac", sum(pomocna.Usteda) as "Usteda"
from(select (po2.POSTOTAK/100 * p2.CIJENA * np2.KOLICINA_JEDNOG_PROIZVODA) Usteda, np2.FAKTURA_ID faktura_id
    from POPUST po2, PROIZVOD p2, NARUDZBA_PROIZVODA np2
    where np2.POPUST_ID = po2.POPUST_ID and np2.PROIZVOD_ID = p2.PROIZVOD_ID) pomocna,
FIZICKO_LICE fl, KUPAC k, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and k.KUPAC_ID = f.KUPAC_ID
and f.FAKTURA_ID = pomocna.faktura_id
group by fl.IME || ' ' || fl.PREZIME);

SELECT Sum(Length("Kupac")*7 + Round("Usteda")*7) FROM
(select distinct fl.IME || ' ' || fl.PREZIME as "Kupac", sum(pomocna.Usteda) as "Usteda"
from(select (po2.POSTOTAK/100 * p2.CIJENA * np2.KOLICINA_JEDNOG_PROIZVODA) Usteda, np2.FAKTURA_ID faktura_id
    from POPUST po2, PROIZVOD p2, NARUDZBA_PROIZVODA np2
    where np2.POPUST_ID = po2.POPUST_ID and np2.PROIZVOD_ID = p2.PROIZVOD_ID) pomocna,
FIZICKO_LICE fl, KUPAC k, FAKTURA f
where fl.FIZICKO_LICE_ID = k.KUPAC_ID
and k.KUPAC_ID = f.KUPAC_ID
and f.FAKTURA_ID = pomocna.faktura_id
group by fl.IME || ' ' || fl.PREZIME);
------------------------------------------------------------------------------------------------------------------
--8. Zadata:
select distinct i.ISPORUKA_ID as "idisporuke", i.KURIRSKA_SLUZBA_ID as "idkurirske"
from ISPORUKA i, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po, PROIZVOD p
where i.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and np.PROIZVOD_ID = p.PROIZVOD_ID
and po.POPUST_ID is not null
and p.BROJ_MJESECI_GARANCIJE > 0;
--8. Rezultat: 243
 SELECT Sum(idisporuke*3 + idkurirske*3) FROM
(select distinct i.ISPORUKA_ID idisporuke, i.KURIRSKA_SLUZBA_ID idkurirske
from ISPORUKA i, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po, PROIZVOD p
where i.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and np.PROIZVOD_ID = p.PROIZVOD_ID
and po.POPUST_ID is not null
and p.BROJ_MJESECI_GARANCIJE > 0);

SELECT Sum(idisporuke*7 + idkurirske*7) FROM
(select distinct i.ISPORUKA_ID idisporuke, i.KURIRSKA_SLUZBA_ID idkurirske
from ISPORUKA i, FAKTURA f, NARUDZBA_PROIZVODA np, POPUST po, PROIZVOD p
where i.ISPORUKA_ID = f.ISPORUKA_ID
and f.FAKTURA_ID = np.FAKTURA_ID
and np.POPUST_ID = po.POPUST_ID
and np.PROIZVOD_ID = p.PROIZVOD_ID
and po.POPUST_ID is not null
and p.BROJ_MJESECI_GARANCIJE > 0);
-------------------------------------------------------------------------------------------------------------------
--9. Zadatak:
select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA > (select round(avg(max(p2.CIJENA)),2)
                  from PROIZVOD p2
                  group by p2.KATEGORIJA_ID);
--9. Rezultat: 9210
 SELECT Sum(Length(naziv)*3 + cijena*3) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA > (select round(avg(max(p2.CIJENA)),2)
                  from PROIZVOD p2
                  group by p2.KATEGORIJA_ID));

SELECT Sum(Length(naziv)*7 + cijena*7) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA > (select round(avg(max(p2.CIJENA)),2)
                  from PROIZVOD p2
                  group by p2.KATEGORIJA_ID));
-------------------------------------------------------------------------------------------------------------------
--10. Zadatak:
select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA < all (select avg(p2.CIJENA)
                  from PROIZVOD p2, KATEGORIJA k
                  where p.KATEGORIJA_ID <> k.NADKATEGORIJA_ID
                  and k.KATEGORIJA_ID = p2.KATEGORIJA_ID
                  group by p2.KATEGORIJA_ID);
--10. Rezultat: 2448
SELECT Sum(Length(naziv)*3 + Round(cijena)*3) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA < all (select avg(p2.CIJENA)
                  from PROIZVOD p2, KATEGORIJA k
                  where p.KATEGORIJA_ID <> k.NADKATEGORIJA_ID
                  and k.KATEGORIJA_ID = p2.KATEGORIJA_ID
                  group by p2.KATEGORIJA_ID));


SELECT Sum(Length(naziv)*7 + Round(cijena)*7) FROM
(select p.NAZIV, p.CIJENA
from PROIZVOD p
where p.CIJENA < all (select avg(p2.CIJENA)
                  from PROIZVOD p2, KATEGORIJA k
                  where p.KATEGORIJA_ID <> k.NADKATEGORIJA_ID
                  and k.KATEGORIJA_ID = p2.KATEGORIJA_ID
                  group by p2.KATEGORIJA_ID));
----------------------------------------------------------------------------------------------------------------------
--Zadatak2
----------------------------------------------------------------------------------------------------------------------
ALTER SESSION SET CURRENT_SCHEMA = mo18772;

CREATE table TabelaA(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number constraint cbcheck check(CijeliBroj not between 5 and 15),
                     RealniBroj number constraint rbcheck check (RealniBroj > 5),
                     constraint pktaba primary key (id)
                    );
Create table TabelaB(id number, Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number constraint unqcb unique,
                     RealniBroj number,
                     FKTabelaA number constraint nnullb NOT NULL,
                     constraint fktabelaa FOREIGN KEY (FKTabelaA) references TabelaA(id),
                     constraint pktabb primary key (id)
                    );
Create table TabelaC(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number,
                     RealniBroj number,
                     FKTabelaB number,
                     constraint FkCnst FOREIGN KEY (FKTabelaB) references TabelaB(id)
                    );

insert into TABELAA values (1,'tekst',null,null,6.2);
insert into TABELAA values (2,null,null,3,5.26);
insert into TABELAA values (3,'tekst',null,1,null);
insert into TABELAA values (4,null,null,null,null);
insert into TABELAA values (5,'tekst',null,16,6.78);

insert into TABELAb values (1,null,null,1,null,1);
insert into TABELAb values (2,null,null,3,null,1);
insert into TABELAb values (3,null,null,6,null,2);
insert into TABELAb values (4,null,null,11,null,2);
insert into TABELAb values (5,null,null,22,null,3);

insert into TABELAc values (1,'yes',null,33,null,4);
insert into TABELAc values (2,'no',null,33,null,2);
insert into TABELAc values (3,'no',null,55,null,1);

--Moze se izvrsiti
INSERT INTO TabelaA (id,naziv,datum,cijeliBroj,realniBroj) VALUES (6,'tekst',null,null,6.20);
--Cijeli broj unique
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (6,null,null,1,null,1);
--Moze se izvrsiti
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (7,null,null,123,null,6);
--moze se izvrsiti
INSERT INTO TabelaC (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaB) VALUES (4,'NO',null,55,null,null);
--Moze se izvrsiti
Update TabelaA set naziv = 'tekst' Where naziv is null and cijeliBroj is not null;
--jer je foreign key za drugu tabelu C
Drop table TabelaB;
--jer je foreign key za drugu tabelu B
delete from TabelaA where realniBroj is null;
--moze
Delete from TabelaA where id = 5;
--moze
Update TabelaB set fktabelaA = 4 where fktabelaA = 2;
--moze
Alter Table tabelaA add Constraint cst Check (naziv like 'tekst');

--Rezultati za provjeru su.
Select Sum(id) From TabelaA;
--Rezultat 16
Select Sum(id) From TabelaB;
--Rezultat 22
Select Sum(id) From TabelaC;
--Rezultat 10

-----------------------------------------------------------------------------------------------------------------------
--Zadatak 3
-----------------------------------------------------------------------------------------------------------------------

Drop table TabelaC;
drop table TabelaB;
Drop table TabelaA;

CREATE table TabelaA(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number constraint cbcheck check(CijeliBroj not between 5 and 15),
                     RealniBroj number constraint rbcheck check (RealniBroj > 5),
                     constraint pktaba primary key (id)
                    );
Create table TabelaB(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number constraint unqcb unique,
                     RealniBroj number,
                     FKTabelaA number constraint nnullb NOT NULL,
                     constraint fktabelaa FOREIGN KEY (FKTabelaA) references TabelaA(id),
                     constraint pktabb primary key (id)
                    );
Create table TabelaC(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number,
                     RealniBroj number,
                     FKTabelaB number,
                     constraint FkCnst FOREIGN KEY (FKTabelaB) references TabelaB(id)
                    );

insert into TABELAA values (1,'tekst',null,null,6.2);
insert into TABELAA values (2,null,null,3,5.26);
insert into TABELAA values (3,'tekst',null,1,null);
insert into TABELAA values (4,null,null,null,null);
insert into TABELAA values (5,'tekst',null,16,6.78);

insert into TABELAb values (1,null,null,1,null,1);
insert into TABELAb values (2,null,null,3,null,1);
insert into TABELAb values (3,null,null,6,null,2);
insert into TABELAb values (4,null,null,11,null,2);
insert into TABELAb values (5,null,null,22,null,3);

insert into TABELAc values (1,'yes',null,33,null,4);
insert into TABELAc values (2,'no',null,33,null,2);
insert into TABELAc values (3,'no',null,55,null,1);

create sequence seq1
start with 1
increment by 1;

create sequence seq2
start with 1
increment by 1;

CREATE table TabelaABekap(id number(4),
                     Naziv varchar2(25),
                     Datum DATE,
                     CijeliBroj number(4) constraint cbcheckb check(CijeliBroj not between 5 and 15),
                     RealniBroj number(4,2) constraint rbcheckb check (RealniBroj > 5),
                     cijeliBrojB integer,
                     sekvenca integer,
                     constraint pktabab primary key (id)
                    );

create or replace trigger triger1
after insert on TabelaB
for each row
declare
    nalaziSe integer := 0;
begin
    select count(*) into nalaziSe from TABELAABEKAP where id = :new.FKTabelaA;
    if(nalaziSe = 0)
    then
        --ne nalazi se
        insert into TABELAABEKAP(id, Naziv, Datum, CijeliBroj, RealniBroj)
        (select * from TABELAA where id = :new.FKTabelaA);
        update TabelaABekap set cijeliBrojB = :new.CijeliBroj ,sekvenca = seq1.nextval
        where id = :new.FKTabelaA;
    else
        --nalazi se
        update TabelaABekap set cijeliBrojB = :new.CijeliBroj ,sekvenca = seq1.nextval
        where id = :new.FKTabelaA;
    end if;
end;


INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (6,null,null,2,null,1);
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (7,null,null,5,null,1);

select * from TabelaABekap;

--Triger2
CREATE TABLE TabelaBCheck(sekvenca INTEGER PRIMARY
KEY);

create or replace trigger triger2
after delete on TABELAB
for each row
begin
    insert into TABELABCHECK(sekvenca) values (seq2.nextval);
end;

create or replace procedure proca( broj in number)
is
    sumaBrojeva number;
    zadnjiid number;
    brojac number := 0;
begin
    select sum(CijeliBroj) into sumaBrojeva from TabelaA;
    while(brojac < sumaBrojeva)
    loop
        select max(ROWNUM) into zadnjiid from TabelaC;
        insert into TabelaC (id,naziv,cijeliBroj) values (zadnjiid,'no',broj);
    end loop;
end;

select * from TabelaB;
drop table tabelaA;
call proca(2);

select * from MO18772.TabelaC;

-----------------------------------------------------------------------------------------------------------------------
--Zadatak3
-----------------------------------------------------------------------------------------------------------------------
alter session set current_schema = MO18772;

Drop table TabelaC;
Drop table TabelaB;
DROP table TabelaA;

CREATE table TabelaA(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     cijeliBroj number constraint cbcheck check(cijeliBroj not between 5 and 15),
                     realniBroj number constraint rbcheck check (realniBroj > 5),
                     constraint pktaba primary key (id)
                    );
Create table TabelaB(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     cijeliBroj number constraint unqcb unique,
                     realniBroj number,
                     FkTabelaA number constraint nnullb NOT NULL,
                     constraint FkCnstr FOREIGN KEY (FkTabelaA) references TabelaA(id),
                     constraint pktabb primary key (id)
                    );
drop table TabelaC;
Create table TabelaC(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     cijeliBroj number,
                     realniBroj number,
                     FkTabelaB number,
                     constraint FkCnst FOREIGN KEY (FkTabelaB) references TabelaB(id)
                    );

insert into TABELAA values (1,'tekst',null,null,6.2);
insert into TABELAA values (2,null,null,3,5.26);
insert into TABELAA values (3,'tekst',null,1,null);
insert into TABELAA values (4,null,null,null,null);
insert into TABELAA values (5,'tekst',null,16,6.78);

insert into TABELAb values (1,null,null,1,null,1);
insert into TABELAb values (2,null,null,3,null,1);
insert into TABELAb values (3,null,null,6,null,2);
insert into TABELAb values (4,null,null,11,null,2);
insert into TABELAb values (5,null,null,22,null,3);

insert into TABELAc values (1,'yes',null,33,null,4);
insert into TABELAc values (2,'no',null,33,null,2);
insert into TABELAc values (3,'no',null,55,null,1);

drop sequence seq1;
create sequence seq1
start with 0
increment by 1
minvalue 0;
drop sequence seq2;
create sequence seq2
start with 0
increment by 1
minvalue 0;

drop table TabelaABekap;
CREATE table TabelaABekap(id number,
                     Naziv varchar2(25),
                     Datum DATE,
                     cijeliBroj number constraint cbcheckb check(cijeliBroj not between 5 and 15),
                     realniBroj number constraint rbcheckb check (realniBroj > 5),
                     cijeliBrojB integer,
                     sekvenca integer,
                     constraint pktabab primary key (id)
                    );

create or replace trigger triger1
after insert on TabelaB
for each row
declare
    nalaziSe integer := 0;
begin
    select count(*) into nalaziSe from TabelaABekap where id = :new.FkTabelaA;
    if(nalaziSe = 0)
    then
        --ne nalazi se
        insert into TabelaABekap(id, Naziv, Datum, cijeliBroj, realniBroj)
        (select * from TabelaA where id = :new.FkTabelaA);
        update TabelaABekap set cijeliBrojB = :new.CijeliBroj ,sekvenca = seq1.nextval
        where id = :new.FkTabelaA;
    else
        --nalazi se
        update TabelaABekap set cijeliBrojB = (cijeliBrojB + :new.cijeliBroj) ,sekvenca = seq1.nextval
        where id = :new.FkTabelaA;
    end if;
end;

--Triger2
drop table TabelaBCheck;
CREATE TABLE TabelaBCheck(sekvenca INTEGER PRIMARY
KEY);

create or replace trigger triger2
after delete on TabelaB
begin
    insert into TabelaBCheck(sekvenca) values (seq2.nextval);
end;

create or replace procedure proca( broj in number)
is
    sumaBrojeva number;
    zadnjiid number;
    brojac number := 0;
begin
    select sum(cijeliBroj) into sumaBrojeva from TabelaA;
    while(brojac < sumaBrojeva)
    loop
        select max(ROWNUM)+1 into zadnjiid from TabelaC;
        insert into TabelaC (id,naziv,cijeliBroj) values (zadnjiid,'no',broj);
        brojac:=brojac+1;
    end loop;
end proca;


INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (6,null,null,2,null,1);
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (7,null,null,4,null,2);
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (8,null,null,8,null,1);
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (9,null,null,5,null,3);
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (10,null,null,7,null,3);
INSERT INTO TabelaB (id,naziv,datum,cijeliBroj,realniBroj,FkTabelaA) VALUES (11,null,null,9,null,5);
Delete From TabelaB where id not in (select FkTabelaB from TabelaC);
Alter TABLE tabelaC drop constraint FkCnst;
Delete from TabelaB where 1=1;
call proca(1);

Select SUM(id*3 + cijeliBrojB*3) from TabelaABekap; --138
Select Sum(id*3 + cijeliBroj*3) from TabelaC; --1251
Select Sum(MOD(sekvenca,10)*3) from TabelaBCheck; --9

alter session set current_schema = ERD;

select distinct fl.ime || ' ' || fl.PREZIME as "ime i prezime", svi.suma as "ukupan iznos"
from FIZICKO_LICE fl, FAKTURA f, KUPAC k, (select sum(nvl(f2.IZNOS,0)) suma, fl2.FIZICKO_LICE_ID id from FAKTURA f2,FIZICKO_LICE fl2, KUPAC k2
         where fl2.FIZICKO_LICE_ID = k2.KUPAC_ID and k2.KUPAC_ID = f2.KUPAC_ID(+)
    group by fl2.FIZICKO_LICE_ID
    order by 1 desc) svi
where fl.FIZICKO_LICE_ID = k.KUPAC_ID and k.KUPAC_ID = svi.id
and fl.FIZICKO_LICE_ID;

select sum(f2.IZNOS) from FAKTURA f2
         group by f2.IZNOS;

select sum(nvl(f2.IZNOS,0)) from FAKTURA f2,FIZICKO_LICE fl2, KUPAC k2
         where fl2.FIZICKO_LICE_ID = k2.KUPAC_ID and k2.KUPAC_ID = f2.KUPAC_ID(+)
    group by fl2.FIZICKO_LICE_ID
    order by 1 desc;

select count(*) from FAKTURA f3,FIZICKO_LICE fl3, KUPAC k3, (select sum(nvl(f2.IZNOS,0)) suma from FAKTURA f2,FIZICKO_LICE fl2, KUPAC k2
         where fl2.FIZICKO_LICE_ID = k2.KUPAC_ID and k2.KUPAC_ID = f2.KUPAC_ID(+)
    group by fl2.FIZICKO_LICE_ID
    order by 1 desc) svi
where fl3.FIZICKO_LICE_ID = k3.KUPAC_ID and k3.KUPAC_ID = f3.KUPAC_ID(+)
having sum(nvl(f3.IZNOS,0)) > svi.suma;


select decode(svi.iznos,0,null,svi.iznos) from (select sum(nvl(f2.IZNOS,0)) as iznos from FAKTURA f2,FIZICKO_LICE fl2, KUPAC k2
         where fl2.FIZICKO_LICE_ID = k2.KUPAC_ID and k2.KUPAC_ID = f2.KUPAC_ID(+)
    group by fl2.FIZICKO_LICE_ID
    order by 1 desc) svi
where ROWNUM in (1,2,3) or (svi.iznos = 0);

select distinct fl.ime || ' ' || fl.PREZIME as "ime i prezime", svi.iznos as "ukupan iznos"
from FIZICKO_LICE fl, FAKTURA f, KUPAC k,
     (select decode(svii.iznos2,0,null,svii.iznos2) as iznos, svii.kid as kid
        from (select sum(nvl(f2.IZNOS,0)) as iznos2, k2.KUPAC_ID as kid
        from FAKTURA f2,FIZICKO_LICE fl2, KUPAC k2
         where fl2.FIZICKO_LICE_ID = k2.KUPAC_ID and k2.KUPAC_ID = f2.KUPAC_ID(+)
    group by fl2.FIZICKO_LICE_ID
    order by 1 desc) svii
    where ROWNUM in (1,2,3) or (svii.iznos2 = 0)) svi
where svi.kid = k.KUPAC_ID and fl.FIZICKO_LICE_ID = k.KUPAC_ID and k.KUPAC_ID = f.KUPAC_ID(+)
order by 1 asc;

create or replace view dvogled
as
(select distinct pl.naziv, pl.PRAVNO_LICE_ID
    from PRAVNO_LICE pl, PROIZVODJAC pr, PROIZVOD p, NARUDZBA_PROIZVODA np, KOLICINA k,
        (select svi.broj as broj, svi.proizvodjacId as proId from
            (select count(p.PROIZVOD_ID) as broj, p.PROIZVODJAC_ID as proizvodjacId from PROIZVOD p, PROIZVODJAC pr
            where p.PROIZVODJAC_ID = pr.PROIZVODJAC_ID
            group by p.PROIZVODJAC_ID
            order by 1 desc) svi
            where ROWNUM < 4) top3,
        (select sum(np.KOLICINA_JEDNOG_PROIZVODA) as suma, p.PROIZVOD_ID as pid from NARUDZBA_PROIZVODA np, PROIZVOD p
        where p.PROIZVOD_ID = np.PROIZVOD_ID group by p.PROIZVOD_ID) kolicine,
        (select sum(nvl(k.KOLICINA_PROIZVODA,0)) as suma, p.PROIZVOD_ID as pid from SKLADISTE s, KOLICINA k , PROIZVOD p
        where p.PROIZVOD_ID = k.PROIZVOD_ID(+) and s.SKLADISTE_ID = k.SKLADISTE_ID
        group by p.PROIZVOD_ID) ukupnakolicina
    where pl.PRAVNO_LICE_ID = pr.PROIZVODJAC_ID
    and pr.PROIZVODJAC_ID = p.PROIZVODJAC_ID(+)
    and np.PROIZVOD_ID(+) = p.PROIZVOD_ID
    and k.PROIZVOD_ID(+) = p.PROIZVOD_ID
    and pr.PROIZVODJAC_ID in (top3.proId)
    and kolicine.suma > ukupnakolicina.suma
    and kolicine.pid = ukupnakolicina.pid
    and p.PROIZVOD_ID = kolicine.pid
);

select * from (select count(p.PROIZVOD_ID), p.PROIZVODJAC_ID as proizvodjacId from PROIZVOD p, PROIZVODJAC pr
where p.PROIZVODJAC_ID = pr.PROIZVODJAC_ID
group by p.PROIZVODJAC_ID
order by 1 desc) top3
where ROWNUM < 4;

select sum(np.KOLICINA_JEDNOG_PROIZVODA), p.PROIZVOD_ID from NARUDZBA_PROIZVODA np, PROIZVOD p
where p.PROIZVOD_ID = np.PROIZVOD_ID
group by p.PROIZVOD_ID;

select sum(nvl(k.KOLICINA_PROIZVODA,0)), p.PROIZVOD_ID from SKLADISTE s, KOLICINA k , PROIZVOD p
where p.PROIZVOD_ID = k.PROIZVOD_ID(+) and s.SKLADISTE_ID = k.SKLADISTE_ID
group by p.PROIZVOD_ID;

select * from KOLICINA;


alter session set current_schema = mo18772;

create table LICA (
    lid int primary key,
    tipLica char(1),
    naziv char(100),
    adresa char(50),
    mjesto char(20),
    nadredjenoLice int,
    datumUnosa date,
    constraint fk_lica foreign key (nadredjenoLice) references LICA
);

drop table pdv;
create table PDV (
    pdv real primary key ,
    naziv char(50),
    procenti number(3,2)
);

create table pdv_promjene (
    pdv int primary key,
    datumPromjene date,
    naziv char(50),
    procenti number(3,2),
    constraint fk_pdv foreign key (pdv) references pdv
);

create table vrste (
    vid int primary key,
    naziv varchar(50),
    datumFormiranja date,
    status char(10)
);

create table artikli (
    aid int primary key,
    naziv char(50),
    vrsta int,
    pdv number,
    aUnio int,
    aOdobrio int,
    datumNabavke date,
    cijenaZaProdaju number(9,2),
    datumProizvodnje date,
    datumPrveKorekcije date,
    constraint fk_1 foreign key (vrsta) references vrste,
    constraint fk_2 foreign key (pdv) references pdv,
    constraint fk_3 foreign key (aUnio) references lica,
    constraint fk_4 foreign key (aOdobrio) references lica
);

create table firme (
    fid int primary key,
    maticniBroj integer,
    odgovornoLice int,
    datumProvjere date,
    constraint fk_bla foreign key (odgovornoLice) references lica
);

create table fakture (
    id int primary key,
    datumUnosa date,
    firma int,
    kupac int,
    odobrio int,
    zaprimio int,
    formirao int,
    fVrijednost number,
    constraint fk_5 foreign key (firma) references firme,
    constraint fk_6 foreign key (kupac) references lica,
    constraint fk_7 foreign key (odobrio) references lica,
    constraint fk_8 foreign key (zaprimio) references LICA,
    constraint fk_9 foreign key (formirao) references LICA
);

create table stavke (
    faktura int,
    stavka int,
    artikal int,
    cijena number(2,2),
    kolicina number,
    pdv number,
    constraint fk_10 foreign key (faktura) references fakture,
    constraint fk11 foreign key (artikal) references artikli,
    constraint fk_12 foreign key (pdv) references pdv
    );

CREATE OR REPLACE TRIGGER trigotrigic
BEFORE UPDATE ON STAVKE
FOR EACH ROW
DECLARE
    pdvArtikla INTEGER := 0;
    cijenaZaProdaju real := 0;
BEGIN
    --a)
    select a.pdv into pdvArtikla from ARTIKLI a where a.CIJENAZAPRODAJU = (select max(a2.cijenazaprodaju) from artikli a2);
    IF (:old.pdv < :new.pdv)
        THEN
            :new.pdv := pdvArtikla;

    END IF;
    --b)
    IF(:new.cijena < 0)
        THEN
            RAISE_APPLICATION_ERROR(-200003, 'Cijena ne moze biti negativna');
    end if;
    --c)
    SELECT a.cijenaZaProdaju INTO cijenaZaProdaju FROM ARTIKLI a
    WHERE :old.artikal = a.aid;
    IF(:new.cijena < cijenaZaProdaju)
        THEN
        :new.cijena := cijenaZaProdaju;
    end if;
    UPDATE FAKTURE f
        SET f.fVrijednost = :new.kolicina * :new.cijena
    WHERE f.id = :new.faktura;
end;

CREATE OR REPLACE PROCEDURE proca(nazivFirme in varchar2, nazivNadredjenog out varchar2, ukupnoFirmi out number)
AS
provjera integer := 0;
BEGIN
        --c)
        SELECT COUNT(*) INTO provjera FROM LICA WHERE LICA.naziv = nazivFirme AND LICA.tipLica = 'P';
        IF(provjera = 0)
        THEN
            RAISE_APPLICATION_ERROR(-200001, 'Greska');
        end if;
        --a)
        SELECT l2.nadredjenoLice INTO nazivNadredjenog FROM LICA l1, LICA l2, FIRME f
        WHERE l1.lid = f.odgovornoLice
          AND l2.lid = f.fid
          AND l2.NAZIV = nazivFirme
          AND l1.lid = l2.nadredjenoLice
          AND 1 = (SELECT COUNT(*) FROM FIRME f2
                   WHERE f2.odgovornoLice = l1.lid);
        --b)
        SELECT COUNT(*) INTO ukupnoFirmi FROM FIRME f, LICA l1, LICA l2
        WHERE l1.lid = f.odgovornoLice
          AND l2.lid = f.fid
          AND l1.lid = l2.nadredjenoLice
          AND 1 <> (SELECT COUNT(*) FROM FIRME f2
                   WHERE f2.odgovornoLice = l1.lid);
END proca;

CREATE OR REPLACE PROCEDURE procedura(nazivFirme in varchar2, nazivNad out varchar2, ukupanbroj out number, ukupnoFirmi out number)
AS
test integer := 0;
BEGIN
          --c)
          SELECT COUNT(*) INTO test FROM LICA WHERE LICA.naziv = nazivFirme AND LICA.tipLica = 'P';
          IF(test = 0)
          THEN
             select distinct count(*) into ukupanbroj from LICA l where LICA.tipLica = 'F';
          end if;
        --a)
        SELECT l2.nadredjenoLice INTO nazivNad FROM LICA l1, LICA l2, FIRME f
        WHERE l1.lid = f.odgovornoLice
          AND l2.NAZIV = nazivFirme
          AND l1.lid = l2.nadredjenoLice
          AND l2.lid = f.fid
          AND 1 = (SELECT COUNT(*) FROM FIRME f2 WHERE l1.lid = f2.odgovornoLice);
        --b)
        SELECT COUNT(*) INTO ukupnoFirmi FROM FIRME f, LICA l1, LICA l2
        WHERE f.odgovornoLice = l1.lid
          AND f.fid = l2.lid
          AND l2.nadredjenoLice = l1.lid
          AND 1 <> (SELECT COUNT(*) FROM FIRME f2 WHERE l1.lid = f2.odgovornoLice);
END procedura;

Select distinct l.naziv,l1.naziv
from lica l,lica l1
where l.lid=zaposleni.id
  and (l1.nadredjenoLice=any(select l.lid from lice)
  or l1.nadredjenoLice<>all(select l.id from lice l))
  and l1.tipLica='P-pravno' and l.tipLica='F-fizicko'

select l1.naziv, l2.naziv from lica l1, lica l2, zaposleni z, trgovine t
where t.tid = l2.lid and z.zid = l1.lid
and t.odgovornoLice = z.zid(+);



CREATE table Uposlenici(uposleniciID number,
                     ime_prezime varchar2(25),
                     datum_rodjenja DATE,
                     kontakt number,
                     constraint pk_uposlenici primary key (uposleniciID)
                    );
Create table Autorizacija(autorizacijaID number,
                     Datum DATE,
                     uposleniciID number,
                     constraint aut_fk FOREIGN KEY (uposleniciID) references Uposlenici(uposleniciID),
                     constraint pk_autoriz primary key (autorizacijaID)
                    );


select * from ROBA r, dual
where TRUNC(r.vrijeme_dostave_u_skladiste) = trunc(sysdate);

select TRUNC(sysdate) from DUAL;

select p.FirstName , p.LastName
from Person p, EmailAddress em
where p.BusinessEntityId = e.BusinessEntityId
and p.PersonType = 'male'
and to_char(em.modifyDate , 'YYYY') = '2020'
and to_char(em.modifyDate , 'MM') = '02';

create or replace view pogled

CREATE VIEW pogled (ime, prezime) AS
    SELECT p.FirstName , p.LastName
    from Person p, EmailAddress em
    where p.BusinessEntityId = e.BusinessEntityId
    and p.PersonType = 'male'
    and to_char(em.modifyDate , 'YYYY') = '2020'
    and to_char(em.modifyDate , 'MM') = '02';

select s.ime, s.prezime, count (s.*) as "Broj studenata"
from STUDENT s
where 2 < (select count(s2.*) from student s2 where s.ime = s2.ime)
group by s.ime;

select p.FirstName , p.LastName, p.Title , nvl(ard.AdressLine2,ard.AdressLine1)
from person p,BusinessEntity be,BusinessEntityAdress bea, Adress adr
where p.BusinessEntityId = be.BusinessEntityId and be.BusinessEntityId = bea.BusinessEntityId
and bea.AdressId = adr.AdressId
and ((adr.AdressLine1 is not null and adr.AdressLine2 is not null ) or ((lower(substr(to_char(adr.postalCode),1,1))) in ('1','2','3','4')));