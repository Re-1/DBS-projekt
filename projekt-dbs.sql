/* 

Název: Návrh IS
Předmět: DBS - Databázové systémy
Garant: Ing. Jiří Kříž, Ph.D.
Vyučující: Ing. Jan Luhan, Ph.D., MSc
Vypracovali: Radek Daněk, Monika Masteiková, Anna Shadrina

*/

-- Vytvoření databáze
CREATE DATABASE MI_DBS_Danek_Masteikova_Shadrina;
GO
USE  MI_DBS_Danek_Masteikova_Shadrina;
GO

-- Vytvoření rolí
CREATE ROLE Board_Role AUTHORIZATION dbo;
GO
CREATE ROLE Garant_Role AUTHORIZATION dbo;
GO
CREATE ROLE Student_Role AUTHORIZATION dbo;
GO
CREATE ROLE Vyucujici_Role AUTHORIZATION dbo;
GO
CREATE ROLE REFperm;
GO
-- Vytvoření schémat
CREATE SCHEMA Board_Schema AUTHORIZATION Board_Role;
GO
CREATE SCHEMA Garant_Schema AUTHORIZATION Garant_Role;
GO
CREATE SCHEMA Student_Schema AUTHORIZATION Student_Role;
GO
CREATE SCHEMA Vyucujici_Schema AUTHORIZATION Vyucujici_Role;
GO
CREATE SCHEMA REF AUTHORIZATION REFperm;
GO
--Práva rolí
GRANT ALTER ON SCHEMA :: REF to REFperm;
GO 
-- Vytvoření tabulek
CREATE TABLE Fakulta
(
IDFakulta INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
FAzkratka VARCHAR(10)NOT NULL,
FAnazev VARCHAR(60)NOT NULL,
FAadresa VARCHAR(40)NOT NULL,
FAmesto VARCHAR(50)NOT NULL,
FApsc VARCHAR(8)NOT NUll
);
GO
CREATE TABLE REF.Student
(
IDStudent INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
STlogin AS 'XP' + RIGHT('00' + CAST(IDStudent AS VARCHAR(8)), 8) PERSISTED,
STjmeno VARCHAR(20)NOT NULL,
STprijmeni VARCHAR(40)NOT NULL,
STemail VARCHAR(89)NOT NULL,
STrodne_cislo VARCHAR(12)NOT NULL,
STadresa VARCHAR(60)NOT NULL,
STmesto VARCHAR(50)NOT NULL,
STpsc VARCHAR(8) NOT NULL,
STfakulta INTEGER NOT NULL FOREIGN KEY references Fakulta(IDFakulta)
);
GO
CREATE TABLE REF.Ucel_platby
(
IDUcel_platby INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
UPnazev VARCHAR(50) NOT NULL,
UPcastka INTEGER NOT NULL
);
GO
CREATE TABLE REF.Referentka
(
IDReferentka INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
REFlogin AS 'XR' + RIGHT('00' + CAST(IDReferentka AS VARCHAR(8)), 8) PERSISTED,
REFjmeno VARCHAR(20) NOT NULL,
REFprijmeni VARCHAR(50) NOT NULL,
REFadresa VARCHAR(50) NOT NULL,
REFmesto VARCHAR(40) NOT NULL
);
GO
CREATE TABLE REF.Platba
(
IDPlatba INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
PLucel INTEGER NOT NULL FOREIGN KEY references REF.Ucel_platby(IDUcel_platby), 
PLdatum DATETIME NOT NULL,
PLreferentka INTEGER NOT NULL FOREIGN KEY references REF.Referentka(IDReferentka),
PLstudent INTEGER NOT NULL FOREIGN KEY references REF.Student(IDStudent)
);
GO
CREATE TABLE Ustav
(
IDUstav INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
USnazev VARCHAR(30)NOT NULL,
USzkratka VARCHAR(10)NOT NULL,
USadresa VARCHAR(50)NOT NULL,
USpsc VARCHAR(8)NOT NULL,
USmesto VARCHAR(40)NOT NULL
);
GO
CREATE TABLE Garant
(
IDGarant INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
GAlogin AS 'XG' + RIGHT('00' + CAST(IDGarant AS VARCHAR(8)), 8) PERSISTED,
GAtitul_pred VARCHAR(17)NOT NULL,
GAtitul_za VARCHAR(15),
GAjmeno VARCHAR(20)NOT NULL,
GAprijmeni VARCHAR(30)NOT NULL,
GAfakulta INTEGER NOT NULL FOREIGN KEY references Fakulta(IDFakulta),
GAustav INTEGER NOT NULL FOREIGN KEY references Ustav(IDUstav)
);
GO
CREATE TABLE Vyucujici
(
IDVyucujici INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
LOGIN AS 'XV' + RIGHT('00' + CAST(IDVyucujici AS VARCHAR(8)), 8) PERSISTED,
VYtitul_pred VARCHAR(17),
VYtitul_za VARCHAR(15),
VYjmeno VARCHAR(20)NOT NULL,
VYprijmeni VARCHAR(30)NOT NULL
);
GO
-- Tabulky Studijniho oboru/programu
CREATE TABLE Studijni_obor
(
IDStudijni_obor INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
SOnazev VARCHAR(15),
SOdelka INTEGER NOT NULL,
);
GO
CREATE TABLE Studijni_program
(
IDStudijni_program INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
SPRnazev VARCHAR(15),
SPRprofil_absolventa VARCHAR(100),
SPRgarant INTEGER NOT NULL FOREIGN KEY references Garant(IDGarant),
SPRstudijni_obor INTEGER NOT NULL FOREIGN KEY references Studijni_obor(IDStudijni_obor)
);
GO
CREATE TABLE Skladba_predmetu
(
IDSkladba_predmetu INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
SPpredmet VARCHAR(15) NOT NULL,
SProcnik VARCHAR(2) NOT NULL,
SPsemestr VARCHAR(6) NOT NULL,
SPstudijni_program INTEGER NOT NULL FOREIGN KEY references Studijni_program(IDStudijni_program)
);
GO
-- Tabulky Předmětu
CREATE TABLE Predmet
(
IDPredmet INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
PDzkratka VARCHAR(15),
PDnazev VARCHAR(15),
PDpovinnost VARCHAR(20)NOT NULL,
PDpocet_kreditu VARCHAR(30)NOT NULL,
PDgarant INTEGER NOT NULL FOREIGN KEY references Garant(IDGarant),
PDvyucujici INTEGER NOT NULL FOREIGN KEY references Vyucujici(IDVyucujici),
PDfakulta INTEGER NOT NULL FOREIGN KEY references Fakulta(IDFakulta),
PDustav INTEGER NOT NULL FOREIGN KEY references Ustav(IDUstav),
PDstudijni_obor INTEGER NOT NULL FOREIGN KEY references Studijni_obor(IDStudijni_obor)
);
GO
CREATE TABLE Kriteria_hodnoceni 
(
IDKriteria_hodnoceni INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
KHnazev VARCHAR(30) NOT NULL,
KHbody_pro_splneni INTEGER
);
GO
CREATE TABLE Karta_predmetu 
(
IDKarta_predmetu INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
IDPredmetu INTEGER NOT NULL FOREIGN KEY references Predmet(IDPredmet),
cesky BIT NOT NULL,
anglicky BIT NOT NULL,
obsah VARCHAR(600) NOT NULL,
cil VARCHAR(200) NOT NULL, 
kriteria_hodnoceni INTEGER NOT NULL FOREIGN KEY references Kriteria_hodnoceni(IDKriteria_hodnoceni), 
prerekvizity BIT NOT NULL,
osnova_predmetu VARCHAR(300) NOT NULL,
osnova_cviceni VARCHAR(270)
);
GO
CREATE TABLE Prava
(
IDPrava INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
IDPredmetu INTEGER NOT NULL FOREIGN KEY references Predmet(IDPredmet),
zkouska BIT NOT NULL,
zapocet BIT NOT NULL,
bodove_hodnoceni BIT NOT NULL,
IDVyucujiciho INTEGER NOT NULL FOREIGN KEY references Vyucujici(IDVyucujici),
IDGaranta INTEGER NOT NULL FOREIGN KEY references Garant(IDGarant)
);
GO
CREATE TABLE Zapocet
(
IDZapocet INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
ZAPpredmet INTEGER NOT NULL FOREIGN KEY references Predmet(IDPredmet),
ZAPstudent INTEGER NOT NULL FOREIGN KEY references REF.Student(IDStudent),
ZAPbody INTEGER NOT NULL,
ZAPdatum SMALLDATETIME NOT NULL, 
ZAPvyucujici INTEGER NOT NULL FOREIGN KEY references Vyucujici(IDVyucujici)
);
GO
CREATE TABLE Termin
(
IDTermin INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
TERpredmet INTEGER NOT NULL FOREIGN KEY references Predmet(IDPredmet),
TERdatum SMALLDATETIME NOT NULL,
TERVyucujici INTEGER NOT NULL FOREIGN KEY references Vyucujici(IDVyucujici)
);
GO
CREATE TABLE Registrace_terminu
(
IDRegistrace_terminu INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
REGtermin INTEGER NOT NULL FOREIGN KEY references Termin(IDTermin),
REGstudent INTEGER NOT NULL FOREIGN KEY references REF.Student(IDStudent)
);
GO
CREATE TABLE Tema
(
IDTema INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
TMnazev VARCHAR(40),
TMpredmet INTEGER NOT NULL FOREIGN KEY REFERENCES Predmet(IDPredmet),
TMdatum SMALLDATETIME NOT NULL,
TMgarant INTEGER NOT NULL FOREIGN KEY REFERENCES Garant(IDGarant)
);
GO
CREATE TABLE Registrace_temat
(
IDRegistrace_temat INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
IDtema INTEGER NOT NULL FOREIGN KEY REFERENCES Tema(IDTema),
IDstudent INTEGER NOT NULL FOREIGN KEY REFERENCES REF.Student(IDStudent)
);
GO
CREATE TABLE Hodnoceni
(
IDhodnoceni INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
HOzapocet INTEGER FOREIGN KEY REFERENCES Zapocet(IDZapocet),  
HOtermin INTEGER FOREIGN KEY REFERENCES Termin(IDTermin),
HOtema INTEGER FOREIGN KEY REFERENCES Tema(IDTema),
HOects VARCHAR,
HObody INTEGER,
HOdatum SMALLDATETIME,
HOvyucujici INTEGER FOREIGN KEY REFERENCES Vyucujici(IDVyucujici), 
HOstudent INTEGER FOREIGN KEY REFERENCES REF.Student(IDStudent),
HOgarant INTEGER FOREIGN KEY REFERENCES Garant(IDGarant)
);
GO
-- Data do tabulek
INSERT INTO Fakulta(FAzkratka,FAnazev,FAadresa,FAmesto,FApsc) 
VALUES ('FA','Fakulta architektury','Poříčí 273/5','Brno','639 00'),('FEKT','Fakulta elektrotechniky a komunikačních technologií','Technická 3058/10','Brno','616 00'),('FCH','Fakulta chemická','Purkyňova 464/118','Brno','612 00'),('FIT','Fakulta informačních technologií','Božetěchova 1/2','Brno','612 66'),('FP','Fakulta podnikatelská','Kolejní 2906/4','Brno','612 00'),('FAST','Fakulta stavební','Veveří 331/95','Brno','602 00'),('FSI','Fakulta strojního inženýrství','Technická 2896/2','Brno','616 69'),('FAVU','Fakulta výtvarných umění','Údolní 244/53','Brno','602 00');
INSERT INTO REF.Student(STjmeno,STprijmeni,STemail,STrodne_cislo,STadresa,STmesto,STpsc,STfakulta) 
VALUES ('Jan','Novák','novak@seznam.cz','841215/0206', 'Štěpánovská 15', 'Brno','625 00', 1),('Josef','Novák','novak2@seznam.cz','841215/0206', 'Štěpánovská 15', 'Brno','623 00', 1),('Petr','Veselý','vesely@gmail.com','841215/0206', 'Glinkova 5', 'Brno','608 00', 1),('Helena','Černá','cerna@gmail.com','841215/0206', 'Francouzká 17', 'Brno','618 00', 1),('Lukáš','Bárek','barek@gmail.com','841215/0206', 'Botanická 51', 'Brno','602 00', 1),('Natalie','Balarinová','balarinova@gmail.com','841215/0206', 'Kounicova 69', 'Brno','603 00', 1),('Filip','Čelko','celko@gmail.com','841215/0206', 'Šelepova 5', 'Brno','605 00', 1),('Monika','Horká','horka@gmail.com','841215/0206', 'Lipská 2', 'Brno','615 00', 1),('Tomáš','Konečný','konecny@gmail.com','841215/0206', 'Kounicova 46', 'Brno','631 00', 1),('Anna','Krýzová','kryzova@gmail.com','841215/0206', 'Kanairova 84', 'Brno','622 00', 1),('Boris','Košík','kosik@gmail.com','841215/0206', 'Kounicova 46', 'Brno','644 00', 1),('Kateřina','Masteiková','masteikova@gmail.com','841215/0206', 'Kolejní 2', 'Brno','655 00', 1),('Jiří','Krones','krones@gmail.com','841215/0206', 'Cejl 36', 'Brno','614 00', 1),('Tereza','Novotná','novotna@gmail.com','841215/0206', 'Táborská 198', 'Brno','633 00', 1),('Martin','Kovalčík','kovalcik@gmail.com','841215/0206', 'Kolejní 2', 'Brno','611 00', 1),('Lenka','Mastná','mastna@gmail.com','841215/0206', 'Kounicova 46', 'Brno','603 00', 1),('Karel','Novotný','novotny@gmail.com','841215/0206', 'Kolejní 2', 'Brno','611 00', 1),('Lada','Topičová','topicova@gmail.com','841215/0206', 'Kounicova 46', 'Brno','601 00', 1),('Matej','Třetina','tretina@gmail.com','841215/0206', 'Kounicova 46', 'Brno','604 00', 1),('Kristína','Nobstová','nobstova@gmail.com','841215/0206', 'Kolejní 2', 'Brno','606 66', 1),('Jakub','Musil','musil@gmail.com','841215/0206', 'Kolejní 2', 'Brno','666 00', 1);
INSERT INTO REF.Ucel_platby (UPnazev,UPcastka) 
VALUES ('Administrativní poplatek', 400),('Školné - 1. splátka', 28000),('Školné - 2. splátka', 10000),('Školné - 3. splátka',28000),('Školné - 4. splátka',10000);
INSERT INTO REF.Referentka(REFjmeno,REFprijmeni,REFadresa,REFmesto) 
VALUES ('Jana','Nová','Česká 3','Brno');
INSERT INTO REF.Platba(PLucel,PLdatum,PLreferentka,PLstudent) 
VALUES (1,22/02/2004/0005,1,1);
INSERT INTO Ustav(USnazev,USzkratka,USadresa,USpsc,USmesto) 
VALUES ('Ústav Informatiky','ÚI','Kolejní 2906/4','612 00','Brno'),('Ústav Ekonomiky','ÚE','Kolejní 2906/4','612 00','Brno'),('Ústav Managementu','ÚM','Kolejní 2906/4','612 00','Brno');
INSERT INTO Garant(GAtitul_pred,GAtitul_za,GAjmeno,GAprijmeni,GAfakulta,GAustav) 
VALUES ('Ing.','Ph.D','Petr','Dydowicz',5,1),('Doc. Ing. et Ing.','Ph.D.','Stanislav','Škapa',5,2),('Doc. PhDr.','Ph.D.','Iveta','Šimberová',5,2),('Ing.',NULL,'Lenka','Niebauerová',5,3)
INSERT INTO Vyucujici(VYtitul_pred,VYtitul_za,VYjmeno,VYprijmeni) 
VALUES ('Ing.','PhD.','Petr','Novák');
GO
-- Procedury pro Referentku
CREATE PROCEDURE Platba
AS
BEGIN
	SELECT STjmeno AS jméno,STprijmeni AS příjmení,PLdatum AS datum,UPnazev AS název,UPcastka AS částka,REFprijmeni AS referentka FROM REF.Student,REF.Platba,REF.Ucel_platby,REF.Referentka
END;
GO
CREATE PROCEDURE Neplatici
AS
BEGIN
	SELECT STjmeno AS jméno,STprijmeni AS příjmení,FAnazev AS fakulta,STemail AS email FROM REF.Student,Fakulta 
	WHERE IDStudent NOT IN (SELECT PLstudent FROM REF.Platba)
END;
-- TRIGGERY --
-- Tabulky pro Triggery
CREATE TABLE Vylouceni_Studenti
(
IDVYL_Student INTEGER NOT NULL PRIMARY KEY,
STVYL_jmeno VARCHAR(20) NOT NULL,
STVYL_prijmeni VARCHAR(40)NOT NULL,
STVYL_rodne_cislo VARCHAR(12)NOT NULL,
STVYL_adresa VARCHAR(60)NOT NULL,
STVYL_mesto VARCHAR(50)NOT NULL,
STVYL_psc VARCHAR(8) NOT NULL,
STVYL_fakulta INTEGER NOT NULL FOREIGN KEY references Fakulta(IDFakulta),
STVYL_datum_vylouceni DATETIME CONSTRAINT DF_Vylouceni_Studenti_datum_vylouceni_GETDATE DEFAULT GETDATE()
);
GO
CREATE TABLE Updated_Student
(
IDUPDStudent INTEGER NOT NULL PRIMARY KEY,
STUPDjmeno VARCHAR(20) NOT NULL,
STUPDprijmeni VARCHAR(40)NOT NULL,
STUPDrodne_cislo VARCHAR(12)NOT NULL,
STUPDadresa VARCHAR(60)NOT NULL,
STUPDmesto VARCHAR(50)NOT NULL,
STUPDpsc VARCHAR(8) NOT NULL,
STUPDfakulta INTEGER NOT NULL FOREIGN KEY references Fakulta(IDFakulta),
STVYL_datum_updatetu DATETIME CONSTRAINT DF_Updated_Student_datum_updatetu_GETDATE DEFAULT GETDATE()
);
GO
-- Triggery pro REFerentku 
CREATE TRIGGER VylouceniST ON REF.Student
FOR DELETE AS
begin
	INSERT INTO Vylouceni_Studenti SELECT IDStudent,STjmeno,STprijmeni,STrodne_cislo,STadresa,STmesto,STpsc,STfakulta,GETDATE() FROM DELETED 
end;
GO
CREATE TRIGGER UpdatetovaniST ON REF.Student
FOR UPDATE AS
begin
	INSERT INTO Updated_Student SELECT IDStudent,STjmeno,STprijmeni,STrodne_cislo,STadresa,STmesto,STpsc,STfakulta,GETDATE() FROM DELETED 
end;
GO
-- Trigger pro Vyučujícího
CREATE Trigger Vlozeni_terminu
ON Termin
FOR INSERT,UPDATE,DELETE
AS
BEGIN
	PRINT ('ZMĚNY BYLY PROVEDENY')
END
GO
CREATE Trigger Vlozeni_hodnoceni
ON Hodnoceni
FOR INSERT,UPDATE,DELETE
AS
BEGIN
	PRINT ('ZMĚNY BYLY PROVEDENY')
END
GO
-- Trigger pro Garanta
CREATE Trigger Vlozeni_temat
ON Tema
FOR INSERT,UPDATE,DELETE
AS
BEGIN
	PRINT ('ZMĚNY BYLY PROVEDENY')
END
GO
-- Pohled Student
CREATE VIEW Student_zapocet_pohled
AS
SELECT STjmeno+' '+STprijmeni as 'Jméno studenta', ZAPpredmet as 'Předmět', ZAPbody as 'Body', VYjmeno+' '+VYprijmeni as 'Jméno vyuřujícího'
FROM REF.Student,Vyucujici,Predmet,Zapocet
-- SELECT * FROM Student_zapocet_pohled
-- Pohled Vyučující
CREATE VIEW Vyucujici_pohled
AS
SELECT VYtitul_pred as 'Titul', VYjmeno+' '+VYprijmeni as 'Jméno vyučujícího', PDnazev as 'Předmět'
FROM Vyucujici,Predmet
-- SELECT * FROM Vyucujici_pohled
-- Pohled Garant
CREATE VIEW Garant_pohled
AS
SELECT GAtitul_pred AS 'Titul před', GAjmeno AS 'Jméno', GAprijmeni AS 'Příjmení', GAtitul_za AS 'Titul za',GAfakulta AS 'Fakulta',GAustav AS 'Ústav'
FROM Garant
-- SELECT * FROM Garant_pohled