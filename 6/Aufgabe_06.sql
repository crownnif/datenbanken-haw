-- Aufgaben 6 - Datenbanken
-- Tom Hert, Finn Kronjaeger
-- Gruppe 04
-- Version 1.0.0
-- Dienstag, 14.06.2022

DROP TABLE KRANKENKASSE CASCADE CONSTRAINTS;
DROP TABLE PATIENT CASCADE CONSTRAINTS;
DROP TABLE ZIMMER CASCADE CONSTRAINTS;
DROP TABLE ZIMMERART CASCADE CONSTRAINTS;
DROP TABLE Aufenthalt CASCADE CONSTRAINTS;
DROP TABLE FALLPAUSCHALENK CASCADE CONSTRAINTS;
DROP TABLE STATION CASCADE CONSTRAINTS;
DROP TABLE PERSONAL CASCADE CONSTRAINTS;
DROP TABLE Zimmerbelegung CASCADE CONSTRAINTS;

CREATE TABLE KRANKENKASSE (
    KUERZEL    VARCHAR(10) PRIMARY KEY,
    NAME       VARCHAR(255),
    ANSCHRIFT  VARCHAR(255),
    GESETZLICH INTEGER
        CONSTRAINT GESETZLICH CHECK ( GESETZLICH BETWEEN 0 AND 1 )
);

CREATE TABLE PATIENT (
    PATIENTENNR          INTEGER
        GENERATED ALWAYS AS IDENTITY,
    GEBURTSDATUM         DATE,
    NAME                 VARCHAR(255),
    VORNAME              VARCHAR(255),
    ANSCHRIFT            VARCHAR(255),
    VERSICHERTENNR       INTEGER UNIQUE,
    KRANKENKASSENKUERZEL VARCHAR(10) NOT NULL,
    CONSTRAINT PATIENT_KASSEFK FOREIGN KEY ( KRANKENKASSENKUERZEL )
        REFERENCES KRANKENKASSE ( KUERZEL ),
    PRIMARY KEY ( PATIENTENNR )
);

CREATE TABLE FALLPAUSCHALENK (
    BEZEICHNUNG              VARCHAR(255) ,
    DRG                      VARCHAR(255) PRIMARY KEY,
    MVD                        DECIMAL(10)
);

CREATE TABLE BEHANDLUNG (
    TYP                       VARCHAR(255),
    KOSTEN                    DECIMAL(10, 2),
    NAME                      VARCHAR(50),
    DRG VARCHAR(255) NOT NULL,
    ABGERECHNETAM             DATE,
    STARTDATUM                DATE NOT NULL,
    PATIENTENNR               INTEGER,
    CONSTRAINT FALLPAUSCHALENKFK FOREIGN KEY ( DRG )
        REFERENCES FALLPAUSCHALENK ( DRG ),
    CONSTRAINT PATIENTENNRBEHANDLUNGFK FOREIGN KEY ( PATIENTENNR )
        REFERENCES PATIENT ( PATIENTENNR ),
    PRIMARY KEY ( NAME,
                  STARTDATUM,
                  PATIENTENNR )
);

CREATE TABLE STATION (
    BEZEICHNUNG VARCHAR(20) UNIQUE,
    STATIONSNR  VARCHAR(6) PRIMARY KEY
);

CREATE TABLE PERSONAL (
    NAME                 VARCHAR(40),
    VORNAME              VARCHAR(20),
    PERSONALNR           VARCHAR(10) PRIMARY KEY,
    GEBURTSDATUM         DATE,
    ARBEITETINSTATIONSNR VARCHAR(6) NOT NULL,
    LEITETSTATIONSNR     VARCHAR(6),
    CONSTRAINT ARBEITETINSTATIONFK FOREIGN KEY ( ARBEITETINSTATIONSNR )
        REFERENCES STATION ( STATIONSNR )
);

CREATE TABLE ZIMMERART (
    BEZEICHNUNG     VARCHAR(255),
    KURZBEZEICHNUNG VARCHAR(255) PRIMARY KEY,
    KOSTENPROTAG    DECIMAL(10, 2)
);

CREATE TABLE ZIMMER (
    ZIMMERNR              VARCHAR(4) PRIMARY KEY,
    BETTENANZAHL          INTEGER
        CONSTRAINT BETTENANZAHL CHECK ( BETTENANZAHL BETWEEN 1 AND 8 ),
    BEMERKUNG             VARCHAR(255),
    STATIONSNR            VARCHAR(6) NOT NULL,
    ZIMMERKURZBEZEICHNUNG VARCHAR(255) NOT NULL,
    CONSTRAINT STATIONSNRZIMMERFK FOREIGN KEY ( STATIONSNR )
        REFERENCES STATION ( STATIONSNR ),
    CONSTRAINT ZIMMERKURZBEZEICHNUNGFK FOREIGN KEY ( ZIMMERKURZBEZEICHNUNG )
        REFERENCES ZIMMERART ( KURZBEZEICHNUNG )
);

CREATE TABLE VERWEILTIN (
    VON    DATE NOT NULL,
    BIS    DATE,
    PATIENTENNR INTEGER NOT NULL,
    ZIMMERNR    VARCHAR(4) NOT NULL,
    CONSTRAINT PATIENTENNRVERWEILTFK FOREIGN KEY ( PATIENTENNR )
        REFERENCES PATIENT ( PATIENTENNR ),
    CONSTRAINT ZIMMERNRVERWEILTFK FOREIGN KEY ( ZIMMERNR )
        REFERENCES ZIMMER ( ZIMMERNR ),
    PRIMARY KEY ( PATIENTENNR,
                  ZIMMERNR,
                  VON )
);

ALTER TABLE PERSONAL
    ADD CONSTRAINT LEITERFK FOREIGN KEY ( LEITETSTATIONSNR )
        REFERENCES STATION ( STATIONSNR );

INSERT into FALLPAUSCHALENK (DRG, BEZEICHNUNG, MVD)
    values ('A01A', 'Lebertransplantation mit Beatmung > 179 Stunden oder kombinierter Dünndarmtransplantation', 48.4);

INSERT into FALLPAUSCHALENK (DRG, BEZEICHNUNG, MVD)
    values ('A01B', 'Lebertransplantation ohne kombinierte Dünndarmtranspl. mit Beatmung > 59 und < 180 Std. od. mit Transplantatabstoßung od. mit komb. Nierentranspl. od. m. kombinierter Pankreastranspl. od. Alter < 6 J. oder od. m. intensivm. Komplexbeh. > 980 / 828 / - P.', 30.5);

INSERT into FALLPAUSCHALENK (DRG, BEZEICHNUNG, MVD)
    values ('A01C', 'Lebertransplantation ohne kombinierte Dünndarmtransplantation, ohne Beatmung > 59 Stunden, ohne Transplantatabstoßung, ohne komb. Nierentranspl., ohne kombinierte Pankreastranspl., Alter > 5 Jahre, ohne intensivmed. Komplexbehandlung > 980 / 828 / - P.', 22.9 );

INSERT into FALLPAUSCHALENK (DRG, BEZEICHNUNG, MVD)
    values ('A02Z', 'Transplantation von Niere und Pankreas', 24);

INSERT into FALLPAUSCHALENK (DRG, BEZEICHNUNG, MVD)
    values ('A03A', 'Lungentransplantation mit Beatmung > 179 Stunden', 49.8);


INSERT into KRANKENKASSE (KUERZEL, NAME, ANSCHRIFT, GESETZLICH)
    values ('GH', 'Gesundheit Hamburg', 'Ort', 1);

INSERT into KRANKENKASSE (KUERZEL, NAME, ANSCHRIFT, GESETZLICH)
    values ('DKV', 'Deutsche Krankenversicherung AG', 'DKV Straße, 12345 Krankenkassenland', 0);

INSERT into KRANKENKASSE (KUERZEL, NAME, ANSCHRIFT, GESETZLICH)
    values ('TK', 'Die Techniker', 'Technikerstraße, 54321 bla', 1);

INSERT into KRANKENKASSE (KUERZEL, NAME, ANSCHRIFT, GESETZLICH)
    values ('BEK', 'Barmer', 'Barmer', 1);

INSERT into KRANKENKASSE (KUERZEL, NAME, ANSCHRIFT, GESETZLICH)
    values ('BKK', 'Betriebskrankenkasse', 'Betriebsstraße 6, 23456 Betrieb', 1);


INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('Friedrich', 'Bob', 'GH', 1, 'Bobstraße 3, Hamburg', TO_DATE('2003/07/09', 'yyyy/mm/dd'));

INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('Gunthilde', 'Edeltraudt', 'TK', 5656, 'Edelstraße 6', TO_DATE('456/07/09', 'yyyy/mm/dd'));

INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('Friedrich', 'Bobba', 'GH', 2, 'Bobstraße 3, Hamburg', TO_DATE('2003/07/29', 'yyyy/mm/dd'));

INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('Kronä', 'Finn', 'BEK', 3 , 'Finnstraße 69', TO_DATE('2003/09/12', 'yyyy/mm/dd'));

INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('Hert', 'Tom', 'DKV', 545 , 'Tomstraße 3', TO_DATE('2010/07/09', 'yyyy/mm/dd'));
    
INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('Mustermensch', 'Menschi', 'DKV', 98 , 'Menschstraße 7', TO_DATE('2010/07/09', 'yyyy/mm/dd'));
    
INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('dfsfdsjoi', 'fdojf', 'DKV', 64 , 'Straße 1', TO_DATE('2010/07/09', 'yyyy/mm/dd'));
    
INSERT into PATIENT (NAME, VORNAME, KRANKENKASSENKUERZEL, VERSICHERTENNR, ANSCHRIFT, GEBURTSDATUM)
    values ('Nachname', 'Name', 'DKV', 123 , 'Straßenname 3', TO_DATE('2010/07/09', 'yyyy/mm/dd'));


INSERT into BEHANDLUNG (TYP, KOSTEN, NAME, DRG, ABGERECHNETAM, STARTDATUM, PATIENTENNR )
    values ('Intensiv', 3.50, 'CPR', 'A01A' , TO_DATE('2003/07/09', 'yyyy/mm/dd'), TO_DATE('2002/07/09', 'yyyy/mm/dd'), 1);

INSERT into BEHANDLUNG (TYP, KOSTEN, NAME, DRG, STARTDATUM, PATIENTENNR )
    values ('Leicht', 39878787.50, 'Nierentransplantation', 'A02Z' , TO_DATE('2002/06/12', 'yyyy/mm/dd'), 2);

INSERT into BEHANDLUNG (TYP, KOSTEN, NAME, DRG, ABGERECHNETAM, STARTDATUM, PATIENTENNR )
    values ('Kosmetisch', 0.50, 'Schönheits-OP: Dritter Arm', 'A01B' , TO_DATE('2034/07/09', 'yyyy/mm/dd'), TO_DATE('2008/04/09', 'yyyy/mm/dd'), 3);

INSERT into BEHANDLUNG (TYP, KOSTEN, NAME, DRG, STARTDATUM, PATIENTENNR )
    values ('Kosmetisch', 563.50, 'Entfernung der Augen', 'A01C', TO_DATE('2023/07/09', 'yyyy/mm/dd'), 4);

INSERT into BEHANDLUNG (TYP, KOSTEN, NAME, DRG, ABGERECHNETAM, STARTDATUM, PATIENTENNR )
    values ('Intensiv', 3.50, 'Gehirnfaltenstraffung', 'A03A' , TO_DATE('2053/07/09', 'yyyy/mm/dd'), TO_DATE('2042/07/09', 'yyyy/mm/dd'), 5);


INSERT into ZIMMERART (BEZEICHNUNG, KURZBEZEICHNUNG, KOSTENPROTAG )
    values ('Luxus Suite','LS', 5);

INSERT into ZIMMERART (BEZEICHNUNG, KURZBEZEICHNUNG, KOSTENPROTAG )
    values ('Basis Zimmer','BZ', 0.5);

INSERT into ZIMMERART (BEZEICHNUNG, KURZBEZEICHNUNG, KOSTENPROTAG )
    values ('Intensiv Zimmer','IZ', 50);

INSERT into ZIMMERART (BEZEICHNUNG, KURZBEZEICHNUNG, KOSTENPROTAG )
    values ('Besenkammer','BK', 0.01);

INSERT into ZIMMERART (BEZEICHNUNG, KURZBEZEICHNUNG, KOSTENPROTAG )
    values ('OP-Saal','OP', 50000);


INSERT into STATION (BEZEICHNUNG, STATIONSNR )
    values ('Intensiv 1', 'I1');

INSERT into STATION (BEZEICHNUNG, STATIONSNR )
    values ('Kinder 1', 'K1');

INSERT into STATION (BEZEICHNUNG, STATIONSNR )
    values ('Ästhetik 1', 'A1');

INSERT into STATION (BEZEICHNUNG, STATIONSNR )
    values ('Chirurgie 1', 'C1');

INSERT into STATION (BEZEICHNUNG, STATIONSNR )
    values ('Egal 1', 'E1');


INSERT into PERSONAL (NAME, VORNAME, PERSONALNR, GEBURTSDATUM, ARBEITETINSTATIONSNR )
    values ('Susi', 'Susi', 'A1', TO_DATE('070903', 'MMDDYY'),'I1');

INSERT into PERSONAL (NAME, VORNAME, PERSONALNR, GEBURTSDATUM, ARBEITETINSTATIONSNR, LEITETSTATIONSNR )
    values ('Herrmann', 'Herbert', 'A2', TO_DATE('122903', 'MMDDYY'), 'K1', 'K1');

INSERT into PERSONAL (NAME, VORNAME, PERSONALNR, GEBURTSDATUM, ARBEITETINSTATIONSNR )
    values ('Müller', 'Lothgard', 'A3', TO_DATE('020836', 'MMDDYY'), 'A1');

INSERT into PERSONAL (NAME, VORNAME, PERSONALNR, GEBURTSDATUM, ARBEITETINSTATIONSNR, LEITETSTATIONSNR )
    values ('Susi', 'Sabine', 'A4', TO_DATE('070909', 'MMDDYY'), 'C1', 'E1');

INSERT into PERSONAL (NAME, VORNAME, PERSONALNR, GEBURTSDATUM, ARBEITETINSTATIONSNR )
    values ('Mustermann', 'Lödrig', 'B1', TO_DATE('070900', 'MMDDYY'), 'E1');
    
INSERT into PERSONAL (NAME, VORNAME, PERSONALNR, GEBURTSDATUM, ARBEITETINSTATIONSNR )
    values ('Kupfer', 'Tim', 'B2', TO_DATE('070900', 'MMDDYY'), 'E1');


INSERT into ZIMMER (ZIMMERNR, BETTENANZAHL, BEMERKUNG, STATIONSNR, ZIMMERKURZBEZEICHNUNG )
    values ('I1', 2, 'Stinkt nach Käse', 'E1', 'BK');

INSERT into ZIMMER (ZIMMERNR, BETTENANZAHL, STATIONSNR, ZIMMERKURZBEZEICHNUNG )
    values ('I2', 1, 'E1', 'LS');

INSERT into ZIMMER (ZIMMERNR, BETTENANZAHL, BEMERKUNG, STATIONSNR, ZIMMERKURZBEZEICHNUNG )
    values ('I3', 2, 'Muss mal gestaubsaugt werden', 'C1', 'BZ');

INSERT into ZIMMER (ZIMMERNR, BETTENANZAHL, STATIONSNR, ZIMMERKURZBEZEICHNUNG )
    values ('I4', 5, 'K1', 'BZ');

INSERT into ZIMMER (ZIMMERNR, BETTENANZAHL, STATIONSNR, ZIMMERKURZBEZEICHNUNG )
    values ('I5', 6, 'C1', 'OP');


INSERT into VERWEILTIN (PATIENTENNR, ZIMMERNR, VON )
    values (1, 'I1', TO_DATE('20020315', 'yyyymmdd'));

INSERT into VERWEILTIN (PATIENTENNR, ZIMMERNR, VON, BIS )
    values (2, 'I2', TO_DATE('20020301', 'yyyymmdd'), TO_DATE('02032002', 'DDMMYYYY'));

INSERT into VERWEILTIN (PATIENTENNR, ZIMMERNR, VON )
    values (3, 'I2', TO_DATE('20030301', 'yyyymmdd'));

INSERT into VERWEILTIN (PATIENTENNR, ZIMMERNR, VON, BIS )
    values (4, 'I4', TO_DATE('20000315', 'yyyymmdd'), TO_DATE('20040315', 'yyyymmdd'));

INSERT into VERWEILTIN (PATIENTENNR, ZIMMERNR, VON )
    values (5, 'I5', TO_DATE('20120315', 'yyyymmdd'));


RENAME Behandlung TO Aufenthalt;

RENAME VerweiltIn TO Zimmerbelegung;

ALTER TABLE Zimmerbelegung
    ADD AufenthaltStartDatum DATE DEFAULT TO_DATE('20120315', 'yyyymmdd') NOT NULL;

MERGE INTO Zimmerbelegung zmb
USING ( SELECT DISTINCT Startdatum, Aufenthalt.PatientenNR FROM Aufenthalt, Zimmerbelegung WHERE ZIMMERBELEGUNG.PatientenNR = Aufenthalt.PatientenNR) Auf
ON (Auf.PatientenNR = zmb.PatientenNR)
WHEN MATCHED THEN
UPDATE SET zmb.AufenthaltStartDatum = Auf.Startdatum;

-- Aufgabe 6.1.1
SELECT 
    Count(*)
FROM
    Patient p INNER JOIN Krankenkasse k ON p.Krankenkassenkuerzel = k.kuerzel
WHERE 
    k.name = 'Gesundheit Hamburg' ;

-- Aufgabe 6.1.2  
SELECT 
    k.name
FROM
    Patient p INNER JOIN Krankenkasse k ON p.Krankenkassenkuerzel = k.kuerzel
GROUP BY
    k.name
HAVING
    count(*) > 3;
    
-- Aufgabe 6.1.3
SELECT
    s.StationsNr, s.bezeichnung
FROM 
    Station s INNER JOIN Personal p ON s.StationsNr = p.arbeitetinstationsnr
GROUP BY
    s.StationsNr, s.bezeichnung
HAVING
    count(p.arbeitetinstationsnr) >= (SELECT MAX (ALL count(name)) FROM Personal GROUP BY arbeitetinstationsnr);
    
-- AUfgabe 6.1.4
SELECT 
    sum(Bettenanzahl), StationsNr
FROM 
    Zimmer
GROUP BY
    StationsNr;
    
-- Aufgabe 6.1.5
SELECT 
    count(DISTINCT PatientenNr) as anzahlP, z.stationsnr, (SELECT SUM (ALL Bettenanzahl) FROM  Zimmer zim GROUP BY   zim.StationsNr HAVING z.stationsnr = zim.StationsNr) as Bettenanzahl
FROM
    Zimmerbelegung zb INNER JOIN Zimmer z ON zb.ZimmerNr = z.ZimmerNr
WHERE
    zb.von <= TO_DATE('01022022', 'ddmmyyyy') AND (zb.bis >= TO_DATE('01022022', 'ddmmyyyy') OR zb.bis IS NULL)
GROUP BY
    z.stationsnr
ORDER BY
    anzahlP DESC;

--Aufgabe 6.1.6
SELECT DISTINCT Aufenthalt.*, (
    SELECT SUM(BIS - VON) 
    FROM Zimmerbelegung 
    WHERE Aufenthalt.Patientennr = Zimmerbelegung.Patientennr AND BIS IS NOT NULL) AS aufenthaltsdauer
FROM Aufenthalt, Patient, Zimmerbelegung, Zimmerart
WHERE Aufenthalt.PatientenNr = Patient.PATIENTENNR
AND Aufenthalt.PatientenNr = Zimmerbelegung.PATIENTENNR
AND (SELECT SUM(BIS - VON) 
    FROM Zimmerbelegung 
    WHERE Aufenthalt.Patientennr = Zimmerbelegung.Patientennr AND BIS IS NOT NULL) IS NOT NULL;

--Aufgabe 6.1.7
SELECT DISTINCT Aufenthalt.*
FROM Aufenthalt, Patient, Zimmerbelegung, Zimmerart
WHERE Aufenthalt.PatientenNr = Patient.PATIENTENNR
AND Aufenthalt.PatientenNr = Zimmerbelegung.PATIENTENNR
AND (
    SELECT SUM(BIS - VON) 
    FROM Zimmerbelegung 
    WHERE Aufenthalt.Patientennr = Zimmerbelegung.Patientennr) > (
        SELECT Fallpauschalenk.MVD 
        FROM Fallpauschalenk, Zimmerart, Zimmer
        WHERE Fallpauschalenk.DRG = Aufenthalt.DRG
        AND Zimmerbelegung.Zimmernr = Zimmer.Zimmernr
        AND Zimmer.Zimmerkurzbezeichnung = Zimmerart.Kurzbezeichnung
    );