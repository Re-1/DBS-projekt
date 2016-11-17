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
CREATE ROLE Referentka_Role AUTHORIZATION dbo;
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
CREATE SCHEMA Referentka_Schema AUTHORIZATION Referentka_Role;
GO

--Vytvoření aplikačních rolí

-- Vytvoření tabulek
CREATE TABLE Fakulta
(
IDFakulta INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
FAnazev VARCHAR(20)NOT NULL,
FAadresa VARCHAR(40)NOT NULL,
FAmesto VARCHAR(50)NOT NULL
);
GO
CREATE TABLE Student
(
IDStudent INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
STjmeno VARCHAR(20) NOT NULL,
STprijmeni VARCHAR(40)NOT NULL,
STrodne_cislo VARCHAR(12)NOT NULL,
STadresa VARCHAR(60)NOT NULL,
STmesto VARCHAR(50)NOT NULL,
STfakulta INTEGER NOT NULL FOREIGN KEY references Fakulta(IDFakulta)
);
GO
CREATE TABLE Ucel_platby
(
IDUcel_platby INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
UPnazev VARCHAR(50) NOT NULL,
UPcastka INTEGER NOT NULL
);
GO
CREATE TABLE Referentka
(
IDReferentka INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
REFjmeno VARCHAR(20) NOT NULL,
REFprijmeni VARCHAR(50) NOT NULL,
REFadresa VARCHAR(50) NOT NULL,
REFmesto VARCHAR(40) NOT NULL
);
GO
CREATE TABLE Platba
(
IDPlatba INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
PLucel INTEGER NOT NULL FOREIGN KEY references Ucel_platby(IDUcel_platby), 
PLdatum DATETIME NOT NULL,
PLreferentka INTEGER NOT NULL FOREIGN KEY references Referentka(IDReferentka),
PLstudent INTEGER NOT NULL FOREIGN KEY references Student(IDStudent)
);
GO
CREATE TABLE Ustav
(
IDUstav INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
USnazev VARCHAR(30)NOT NULL,
USadresa VARCHAR(50)NOT NULL,
USmesto VARCHAR(40)NOT NULL
);
GO

-- Data do tabulek

INSERT INTO Fakulta(FAnazev,FAadresa,FAmesto) VALUES ('Fakulta Strojní', 'Klusáčkova 3','Brno');
INSERT INTO Student(STjmeno,STprijmeni,STrodne_cislo,STadresa,STmesto,STfakulta) VALUES ('Jan','Novák','841215/0206', 'Štěpánovská 15', 'Brno', 1);
INSERT INTO Ucel_platby (UPnazev,UPcastka) VALUES ('Administrativní poplatek', 400);
INSERT INTO Referentka(REFjmeno,REFprijmeni,REFadresa,REFmesto) VALUES ('Jana','Nová','Česká 3','Brno');
INSERT INTO Platba(PLucel,PLdatum,PLreferentka,PLstudent) VALUES (1,22/02/2004/0005,1,1);
INSERT INTO Ustav(USnazev,USadresa,USmesto) VALUES ('Ústav Informatiky','Kolejní 2','Brno');

-- Operace s tabulkami

-- Triggery
