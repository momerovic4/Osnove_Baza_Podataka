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

drop table TabelaC;
drop table TabelaB;
drop table TabelaA;
drop table TabelaABekap;
drop table TabelaBCheck;

select * from TabelaABekap;
select * from TABELABCHECK;
select * from TabelaA;

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