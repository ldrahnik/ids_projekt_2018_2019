DROP TABLE zamestnanec CASCADE CONSTRAINTS;
DROP TABLE zakaznik CASCADE CONSTRAINTS;
DROP TABLE objednavka CASCADE CONSTRAINTS;
DROP TABLE surovina CASCADE CONSTRAINTS;
DROP TABLE pecivo CASCADE CONSTRAINTS;
DROP TABLE mnozstvi CASCADE CONSTRAINTS;
DROP TABLE sklad CASCADE CONSTRAINTS;

CREATE TABLE zamestnanec(
  id NUMBER NOT NULL,
  jmeno VARCHAR2(255) NOT NULL,
  prijmeni VARCHAR2(255) NOT NULL,
  adresa VARCHAR2(255) NOT NULL,
  cislo_bankovniho_uctu VARCHAR2(255) NOT NULL UNIQUE,
  /* v současnosti se používají jen první čtyři pozice sedmimístného kódu banky */
  CHECK (cislo_bankovniho_uctu LIKE '______-__________/____'),
  pozice VARCHAR2(255) NOT NULL 
);

CREATE TABLE zakaznik(
  id NUMBER NOT NULL,
  jmeno VARCHAR2(255) NOT NULL,
  prijmeni VARCHAR2(255) NOT NULL,
  adresa VARCHAR2(255) NOT NULL,
  cislo_bankovniho_uctu VARCHAR2(255) NOT NULL UNIQUE,
  telefonni_cislo VARCHAR2(255) NOT NULL UNIQUE,
  /* v současnosti se používají jen první čtyři pozice sedmimístného kódu banky */
  CHECK (cislo_bankovniho_uctu LIKE '______-__________/____')
);

CREATE TABLE objednavka(
  id NUMBER NOT NULL,
  cena NUMBER NOT NULL,
  zpusob_platby VARCHAR2(25) NOT NULL,
  datum_vytvoreni DATE NOT NULL,
  datum_dodani DATE NOT NULL,
  zpusob_dodani VARCHAR2(255) NOT NULL,
  je_zaplacena NUMBER NOT NULL,
  je_poslana_upominka NUMBER NOT NULL,
  id_zakaznik NUMBER NOT NULL,
  id_zamestnanec NUMBER NOT NULL
);

CREATE TABLE surovina(
  id NUMBER NOT NULL,
  nazev VARCHAR2(255) NOT NULL UNIQUE,
  jednotka VARCHAR2(255) NOT NULL
);

CREATE TABLE pecivo(
  id NUMBER NOT NULL,
  nazev VARCHAR2(255) NOT NULL UNIQUE,
  cena NUMBER NOT NULL,
  id_objednavka NUMBER NOT NULL
);

CREATE TABLE mnozstvi(
  mnozstvi NUMBER NOT NULL,
  id_surovina NUMBER NOT NULL,
  id_pecivo NUMBER NOT NULL
);
 
CREATE TABLE sklad(
  id NUMBER NOT NULL,
  pocet NUMBER NOT NULL,
  id_surovina NUMBER NOT NULL
);

 -- Sequence pro - Trigger pro automatické generování hodnot primárního klíče tabulky zakaznik ze sekvence (id začíná na 101 pouze z demonstrativních důvodů)
 DROP SEQUENCE ZAKAZNIK_SEQ;
 CREATE SEQUENCE ZAKAZNIK_SEQ
  START WITH 101
  INCREMENT BY 1;
  
-- Trigger pro automatické generování hodnot primárního klíče tabulky zakaznik ze sekvence
 CREATE OR REPLACE TRIGGER NASTAV_ZAKAZNIK_ID
  BEFORE INSERT ON zakaznik
  FOR EACH ROW
 BEGIN
   :new.id := ZAKAZNIK_SEQ.nextval;
 END NASTAV_ZAKAZNIK_ID;
 /

ALTER TABLE zamestnanec ADD CONSTRAINT PK_zamestnanec PRIMARY KEY (id);
ALTER TABLE zakaznik ADD CONSTRAINT PK_zakaznik PRIMARY KEY (id);
ALTER TABLE objednavka ADD CONSTRAINT PK_objednavka PRIMARY KEY (id);
ALTER TABLE surovina ADD CONSTRAINT PK_surovina PRIMARY KEY (id);
ALTER TABLE pecivo ADD CONSTRAINT PK_pecivo PRIMARY KEY (id);
ALTER TABLE sklad ADD CONSTRAINT PK_sklad PRIMARY KEY (id);

ALTER TABLE sklad ADD CONSTRAINT FK_surovina FOREIGN KEY(id_surovina) REFERENCES surovina;
ALTER TABLE pecivo ADD CONSTRAINT FK_objednavka FOREIGN KEY(id_objednavka) REFERENCES objednavka ON DELETE CASCADE;
ALTER TABLE objednavka ADD CONSTRAINT FK_zakaznik FOREIGN KEY(id_zakaznik) REFERENCES zakaznik;
ALTER TABLE objednavka ADD CONSTRAINT FK_zamestnanec FOREIGN KEY(id_zamestnanec) REFERENCES zamestnanec;

INSERT INTO surovina (id, nazev, jednotka) VALUES('1', 'mouka hladká', 'Kg');
INSERT INTO surovina (id, nazev, jednotka) VALUES('2', 'mouka hrubá', 'Kg');
INSERT INTO surovina (id, nazev, jednotka) VALUES('3', 'mléko', 'Litr');
INSERT INTO surovina (id, nazev, jednotka) VALUES('4', 'neidentifikovatelné cosi co není na skladě', 'Bez jednotky');
INSERT INTO surovina (id, nazev, jednotka) VALUES('5', 'identifikovatelné cosi co není na skladě', 'Bez jednotky');

INSERT INTO sklad (id, pocet, id_surovina) VALUES('1', '43', '1');
INSERT INTO sklad (id, pocet, id_surovina) VALUES('2', '54', '2');
INSERT INTO sklad (id, pocet, id_surovina) VALUES('3', '330', '3');
INSERT INTO sklad (id, pocet, id_surovina) VALUES('4', '0', '5');

INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('1', 'Petr', 'Rychlý', 'U Mostu 5, Brno', '000043-0123456789/2100', 'ředitel');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('2', 'Honza', 'Veselý', 'U Nádraží 19, Blansko', '000027-0123456789/2100', 'vrátný');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('3', 'Helena', 'Šťastná', 'Husova 55, Třebíč', '000010-0123456789/2100', 'pekařka');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('4', 'Světlana', 'Bystrá', 'Masarykova 2, Brno', '000011-0123456789/2111', 'pekař');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('5', 'David', 'Chytrý', 'Majerova 22, Náměšť nad Oslavou', '000011-0123456789/2110', 'řidič');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('6', 'Honza', 'Brzobohatý', 'Rosického 212, Brno', '000013-0123456789/2110', 'řidič');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('7', 'Pavel', 'Skladný', 'Opletalova 665, Šumperk', '000014-0123456789/2110', 'skladník');

INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES(NULL, 'Lukáš', 'Merlin', 'Božetěchova 1, Brno', '000001-0123456789/0100', '+420 566 654 444');
INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES(NULL, 'Iva', 'Fiv', 'Opařany 210', '000002-0123456789/0100', '+420 555 333 333');
INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES(NULL, 'Čestmír', 'Mirumilovný', 'V Polích, Olomouc', '000011-0123456789/2110', '+420 666 433');
INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES(NULL, 'Kudrna', 'Josef', 'K.H. Borovského, Brno', '000011-0123456789/2111', '+410 123 456 789');

INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec, je_poslana_upominka) VALUES('1', '500', 'převod', '21/JAN/2018', '24/FEB/2018', 'odvoz', '0', '101', '1', '1');
INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec, je_poslana_upominka) VALUES('2', '250', 'převod', '21/JAN/2018', '24/FEB/2018', 'odvoz', '1', '104', '4', '1');
INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec, je_poslana_upominka) VALUES('3', '5000', 'převod', '21/JAN/2018', '24/FEB/2018', 'odvoz', '0', '103', '5', '1');

INSERT INTO pecivo (id, nazev, cena, id_objednavka) VALUES('1', 'rohlik', '3', '2');
INSERT INTO pecivo (id, nazev, cena, id_objednavka) VALUES('2', 'chleba', '22', '1');
INSERT INTO pecivo (id, nazev, cena, id_objednavka) VALUES('3', 'zapečený rohlík se šunkou', '14', '3');

INSERT INTO mnozstvi (mnozstvi, id_surovina, id_pecivo) VALUES('22', '2', '2');
INSERT INTO mnozstvi (mnozstvi, id_surovina, id_pecivo) VALUES('23', '1', '2');
INSERT INTO mnozstvi (mnozstvi, id_surovina, id_pecivo) VALUES('50', '3', '1');
INSERT INTO mnozstvi (mnozstvi, id_surovina, id_pecivo) VALUES('12', '2', '3');

-- Vypíše suroviny ve skladě a jejich počet kilogramů (1. dotaz, se spojením 2 tabulek)
SELECT
  surovina.nazev,
  sklad.pocet
FROM
  surovina,
  sklad
WHERE
  surovina.id = sklad.id_surovina;
  
-- Vypíše všechny suroviny potřebné pro konkrétní pečivo a jejich množství, při více surovinách potřebných pro jedno pečivo se potřebné suroviny zobrazí na více řádků (2. dotaz, se spojením 3 tabulek)
SELECT
  pecivo.nazev,
  surovina.nazev,
  mnozstvi.mnozstvi
FROM
  mnozstvi,
  pecivo,
  surovina
WHERE
  mnozstvi.id_pecivo (+)= pecivo.id
AND
  surovina.id = mnozstvi.id_surovina;
  
-- Vypíše všechny objednávky včetně ceny, způsobu platby, zda je zaplacena, jména a přijmení objednávajícího a zaměstnance uvedeného u objednávky (3. dotaz, se spojením 3 tabulek)
SELECT
  objednavka.cena,
  objednavka.zpusob_platby,
  objednavka.je_zaplacena,
  zakaznik.jmeno,
  zakaznik.prijmeni,
  zamestnanec.jmeno,
  zamestnanec.prijmeni
FROM
  objednavka,
  zakaznik,
  zamestnanec
WHERE
  zakaznik.id (+)= objednavka.id_zakaznik
AND
  zamestnanec.id = objednavka.id_zamestnanec;
  
-- Vypíše všechny objednavatele (jméno, přijmení) a k nim připojí celkový počet objednávek a celkovou cenu objednávek; seřazeno dle ceny objednávky (4. dotaz, s GROUP BY)
SELECT
  zakaznik.jmeno,
  zakaznik.prijmeni,
  COUNT(objednavka.id),
  SUM(objednavka.cena)
FROM
  objednavka,
  zakaznik
WHERE
  zakaznik.id = objednavka.id_zakaznik
GROUP BY
  zakaznik.prijmeni, zakaznik.jmeno, objednavka.id_zakaznik
ORDER BY
  SUM(objednavka.cena) DESC;

-- Spočítá potřebný počet surovin pro všechny druhy pečiva; seřazeno sestupně dle počtu (5. dotaz, s GROUP BY)
SELECT
  pecivo.nazev,
  COUNT(mnozstvi.id_pecivo)
FROM
  pecivo,
  mnozstvi
WHERE
  mnozstvi.id_pecivo (+)= pecivo.id
GROUP BY
  pecivo.nazev
ORDER BY
  COUNT(mnozstvi.id_pecivo) DESC;
  
-- Vypíše všechny suroviny, které nejsou na skladě VŮBEC; seřazeno dle názvu (6. dotaz, s EXISTS)
SELECT
  surovina.nazev
FROM
  surovina
WHERE NOT EXISTS
  (SELECT sklad.id_surovina FROM sklad WHERE sklad.id_surovina = surovina.id AND sklad.pocet > '0')
ORDER BY
  surovina.nazev;
  
-- Vypíše jméno a přijmení všech zaměstnanců u kterých došlo ke shodě s bankovním učtem u některého zákazníka a zároven některou jeho objednávku vyřizovali (7. dotaz, s IN, s vnořeným SELECT) 
SELECT
  zamestnanec.jmeno,
  zamestnanec.prijmeni
FROM
  zamestnanec
WHERE zamestnanec.id IN (
  (SELECT zamestnanec.id
  FROM zakaznik, objednavka
  WHERE zakaznik.cislo_bankovniho_uctu = zamestnanec.cislo_bankovniho_uctu AND objednavka.id_zakaznik = zakaznik.id ));
  
-- Trigger, který při zavolání upraví ceny pečiva
CREATE OR REPLACE TRIGGER uprav_ceny_peciva
BEFORE 
UPDATE OF cena
ON pecivo 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  /* Pečivo nad 10Kč zdražíme o 50% ceny */
  IF (:new.cena>10) THEN :new.cena:=:new.cena * 1.5; END IF; 
  /* Pečivo pod 10Kč zdražíme všechno na 10Kč */
  IF (:new.cena<10) THEN :new.cena:=10; END IF;
END;
/

-- Trigger, který při zavolání upraví ceny pečiva - upravíme cenu chleba na 50Kč, trigger nám upravování hodnoty odchytne a změní na 1.5-násobek
UPDATE
  pecivo
SET 
  pecivo.cena = 50
WHERE
  pecivo.id = 2;
 
-- Trigger, který při zavolání upraví ceny pečiva - vypíšeme ceny pečiva a cenu chleba zkontrolujeme (75Kč) 
SELECT
  pecivo.nazev,
  pecivo.cena
FROM
  pecivo
ORDER BY
  pecivo.nazev;
  
-- Trigger, který při vložení nové objednávky zkontroluje zda neexistují podobné nedokončené
CREATE OR REPLACE TRIGGER zkontroluj_podobne_nedokoncene_objednavky
BEFORE 
INSERT
ON objednavka
FOR EACH ROW
DECLARE 
    pocet_podobnych_objednavek number;
    
    -- Cursor - dotaz kdy byly poslední nezaplacené podobné objednávky vytvořené
    CURSOR nezaplacene_podobne_objednavky_kurzor IS
        SELECT objednavka.datum_vytvoreni
        FROM objednavka 
        WHERE objednavka.cena =: NEW.cena AND objednavka.id_zakaznik =: NEW.id_zakaznik AND objednavka.je_zaplacena = 0;
    
    -- Duplikovaná objednávka odhalena 
    duplikovana_objednavka EXCEPTION;
    
    posledni_objednavka_datum_vytvoreni nezaplacene_podobne_objednavky_kurzor%ROWTYPE;
BEGIN
    pocet_podobnych_objednavek := 0;

    SELECT COUNT(objednavka.id)
    INTO pocet_podobnych_objednavek
    FROM objednavka 
    WHERE objednavka.cena =: NEW.cena AND objednavka.id_zakaznik =: NEW.id_zakaznik AND objednavka.je_zaplacena = 0;
    
    IF pocet_podobnych_objednavek > 0 THEN  
        BEGIN
        OPEN nezaplacene_podobne_objednavky_kurzor;
   
        LOOP
           -- Můžeme si vypsat datum vytvoření každé podobné objednávky
           FETCH nezaplacene_podobne_objednavky_kurzor INTO posledni_objednavka_datum_vytvoreni;
           EXIT WHEN nezaplacene_podobne_objednavky_kurzor%NOTFOUND;  
           
           -- Vyhodíme výjimku, stačí nám najít jedinou podobnou
           RAISE duplikovana_objednavka;   
       END LOOP;
    
        EXCEPTION   
            -- Reakce na výjimku při nalezení podobné
            WHEN duplikovana_objednavka THEN
                DBMS_OUTPUT.PUT_LINE('Duplikovaná objednávka s velkou pravděpodobností odhalena'); 
    
        CLOSE nezaplacene_podobne_objednavky_kurzor; 
        END;
    END IF;

END;
/

-- Otestujeme trigger, mělo by dojít k vyhození erroru (jedna podobná nezaplacená objednávka totiž již existuje)
INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec, je_poslana_upominka) VALUES('4', '5000', 'převod', '22/FEB/2018', '24/FEB/2018', 'odvoz', '0', '103', '5', '1');

-- Procedura, která se stará o pročištění objednávek - tedy smazání objednávek starších než 1 měsíc a zároven nezaplacených a zároven kde již byla poslána varovná upomínka
CREATE OR REPLACE PROCEDURE odstran_stare_objednavky AS
   BEGIN
      DELETE 
      FROM objednavka
      WHERE objednavka.datum_vytvoreni <= ADD_MONTHS(TRUNC(SYSDATE), -1) AND objednavka.je_zaplacena = 0 AND objednavka.je_poslana_upominka = 1;
   END;
/

-- Spustíme proceduru
BEGIN
    odstran_stare_objednavky;
END;
/

-- Zkontrolujeme proceduru, zda došlo ke smazání 2 objednávek (bylo nutné přidat ON DELETE CASCADE, aby jsme smazali záznamy, které odkazují na záznam, který chceme smazat)
SELECT
  COUNT(objednavka.id)
FROM
  objednavka
WHERE
  objednavka.datum_vytvoreni <= ADD_MONTHS(TRUNC(SYSDATE), -1) AND objednavka.je_zaplacena = 0;
  
-- Vložíme objednávku pro otestování následující procedury
INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec, je_poslana_upominka) VALUES('5', '40', 'převod', '21/JAN/2018', '24/FEB/2018', 'odvoz', '0', '103', '5', '0');
  
-- Procedura, která se stará o spočítání objednávek, které jsou starší než 14 dní a nebyla ještě zaslána upomínka
CREATE OR REPLACE PROCEDURE spocitej_stare_objednavky_pro_upominku AS
    objednavky_pocet NUMBER;
BEGIN
   SELECT
      count(objednavka.id)
   INTO
      objednavky_pocet
   FROM 
      objednavka
   WHERE
      objednavka.datum_vytvoreni <= TRUNC(SYSDATE) - 14 AND objednavka.je_zaplacena = 0 AND objednavka.je_poslana_upominka = 0;
   DBMS_OUTPUT.PUT_LINE('Počet nalezených objednávek kde je potřeba doposlat upozornění: ' || objednavky_pocet); 
END;
/

-- Spustíme proceduru
BEGIN
    spocitej_stare_objednavky_pro_upominku;
END;
/

-- Zkontrolujeme proceduru
SELECT
  COUNT(objednavka.id)
FROM
  objednavka
WHERE
  objednavka.datum_vytvoreni <= TRUNC(SYSDATE) - 14 AND objednavka.je_zaplacena = 0 AND objednavka.je_poslana_upominka = 0;
  
-- Přistupová práva
GRANT ALL ON zamestnanec TO xdrahn00;
GRANT ALL ON zakaznik TO xdrahn00;
GRANT ALL ON objednavka TO xdrahn00;
GRANT ALL ON surovina TO xdrahn00;
GRANT ALL ON pecivo TO xdrahn00;
GRANT ALL ON sklad TO xdrahn00;