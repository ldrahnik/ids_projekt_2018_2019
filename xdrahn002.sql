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
  pozice VARCHAR2(255) NOT NULL 
);

CREATE TABLE zakaznik(
  id NUMBER NOT NULL,
  jmeno VARCHAR2(255) NOT NULL,
  prijmeni VARCHAR2(255) NOT NULL,
  adresa VARCHAR2(255) NOT NULL,
  cislo_bankovniho_uctu VARCHAR2(255) NOT NULL UNIQUE,
  telefonni_cislo VARCHAR2(255) NOT NULL UNIQUE
);

CREATE TABLE objednavka(
  id NUMBER NOT NULL,
  cena NUMBER NOT NULL,
  zpusob_platby VARCHAR2(25) NOT NULL,
  datum_vytvoreni DATE NOT NULL,
  datum_dodani DATE NOT NULL,
  zpusob_dodani VARCHAR2(255) NOT NULL,
  je_zaplacena NUMBER NOT NULL,
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

ALTER TABLE zamestnanec ADD CONSTRAINT PK_zamestnanec PRIMARY KEY (id);
ALTER TABLE zakaznik ADD CONSTRAINT PK_zakaznik PRIMARY KEY (id);
ALTER TABLE objednavka ADD CONSTRAINT PK_objednavka PRIMARY KEY (id);
ALTER TABLE surovina ADD CONSTRAINT PK_surovina PRIMARY KEY (id);
ALTER TABLE pecivo ADD CONSTRAINT PK_pecivo PRIMARY KEY (id);
ALTER TABLE sklad ADD CONSTRAINT PK_sklad PRIMARY KEY (id);

ALTER TABLE sklad ADD CONSTRAINT FK_surovina FOREIGN KEY(id_surovina) REFERENCES surovina;
ALTER TABLE pecivo ADD CONSTRAINT FK_objednavka FOREIGN KEY(id_objednavka) REFERENCES objednavka;
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

INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('1', 'Petr', 'Rychlý', 'U Mostu 5, Brno', '43-12345678/2100', 'ředitel');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('2', 'Honza', 'Veselý', 'U Nádraží 19, Blansko', '27-12345678/2100', 'vrátný');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('3', 'Helena', 'Šťastná', 'Husova 55, Třebíč', '10-12345678/2100', 'pekařka');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('4', 'Světlana', 'Bystrá', 'Masarykova 2, Brno', '11-12345678/2111', 'pekař');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('5', 'David', 'Chytrý', 'Majerova 22, Náměšť nad Oslavou', '11-12345678/2110', 'řidič');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('6', 'Honza', 'Brzobohatý', 'Rosického 212, Brno', '13-12345678/2110', 'řidič');
INSERT INTO zamestnanec (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, pozice) VALUES('7', 'Pavel', 'Skladný', 'Opletalova 665, Šumperk', '14-12345678/2110', 'skladník');

INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES('1', 'Lukáš', 'Merlin', 'Božetěchova 1, Brno', '01-12345678/0100', '+420 566 654 444');
INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES('2', 'Iva', 'Fiv', 'Opařany 210', '02-12345678/0100', '+420 555 333 333');
INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES('3', 'Čestmír', 'Mirumilovný', 'V Polích, Olomouc', '11-12345678/2110', '+420 666 433');
INSERT INTO zakaznik (id, jmeno, prijmeni, adresa, cislo_bankovniho_uctu, telefonni_cislo) VALUES('4', 'Kudrna', 'Josef', 'K.H. Borovského, Brno', '11-12345678/2111', '+410 123 456 789');

INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec) VALUES('1', '500', 'převod', '21/FEB/2018', '24/FEB/2018', 'odvoz', '0', '1', '1');
INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec) VALUES('2', '250', 'převod', '21/FEB/2018', '24/FEB/2018', 'odvoz', '1', '4', '4');
INSERT INTO objednavka (id, cena, zpusob_platby, datum_vytvoreni, datum_dodani, zpusob_dodani, je_zaplacena, id_zakaznik, id_zamestnanec) VALUES('3', '5000', 'převod', '21/FEB/2018', '24/FEB/2018', 'odvoz', '0', '3', '5');

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

-- Spočítá potřebný počet surovin pro všechny druhy pečiva; seřazeno dle počtu (5. dotaz, s GROUP BY)
SELECT
  pecivo.nazev,
  COUNT(mnozstvi.id_pecivo)
FROM
  pecivo,
  mnozstvi
WHERE
  mnozstvi.id_pecivo (+)= pecivo.id
GROUP BY
  pecivo.nazev;
  
-- Vypíše všechny suroviny, které nejsou na sklade VŮBEC; seřazeno dle názvu (6. dotaz, s EXISTS)
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