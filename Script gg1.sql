CREATE TABLE zaposleni AS SELECT * FROM eployees;

TRUNCATE TABLE zaposleni;

DROP SEQUENCE sekv_za_plate;

CREATE SEQUENCE sekv_za_plate
START WITH 20
MaxValue 100
INCREMENT BY 10
CYCLE
CACHE 10;

SELECT * FROM zaposleni;

INSERT INTO zaposleni VALUES(1,'hare','daddy','hdaddy@etf.unsa.ba','669',SYSDATE,1,20000,0.1,1,1);

DROP TRIGGER  zap_visina_plate_trig;

CREATE TRIGGER zap_visina_plate_trig
BEFORE INSERT ON zaposleni
FOR EACH ROW
DECLARE const number;
BEGIN
  IF((:new.salary *(1+ :new.commission_pct)) > 10000)
  THEN
    --EXECUTE IMMEDIATE 'create SEQUENCE sekv_za_plate start with 20 increment by 10';   TREBA SKONATI NACIN KAKO DA RESTARTUJEM SEKVENCU UNUTAR TRIGERA ALI RADI I OVAKO!
    WHILE ((:new.salary *(1+:new.commission_pct)) > 10000)
        LOOP
            SELECT :new.salary*((100-sekv_za_plate.NEXTVAL)/100)
            INTO :new.salary
            FROM dual;
        END LOOP;
    WHILE (sekv_za_plate.CURRVAL <> 100)
        LOOP
            SELECT sekv_za_plate.NEXTVAL INTO const FROM dual;
        END LOOP;
  elsIF((:new.salary *(1+ :new.commission_pct )) < 2000)
  THEN
    --EXECUTE IMMEDIATE 'DROP SEQUENCE sekv_za_plate; CREATE SEQUENCE sekv_za_plate START WITH 20 INCREMENT BY 10 NOCACHE NOCYCLE;';
    WHILE ((:new.salary*(1+:new.commission_pct)) < 2000)
        LOOP
            SELECT :new.salary *((100+sekv_za_plate.NEXTVAL)/100)
            INTO :new.salary
            FROM dual;
        END LOOP;
    WHILE (sekv_za_plate.CURRVAL <> 100)
        LOOP
          SELECT sekv_za_plate.NEXTVAL INTO const FROM dual;
        END LOOP;
  END IF;
END;