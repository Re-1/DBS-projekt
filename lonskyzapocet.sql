-- ZADANI Z LONSKA

create database test1
go
use test1
go
create schema KONTROLA
go
-- Tvorba tabulek

create table KONTROLA.student
(
	id_student int identity(1, 1),
	cislo_studenta int primary key not null,
	jmeno varchar (30),
	prijmeni varchar (50),
	adresa varchar (50),
	obec varchar (30),
	psc numeric (5),
	telefon numeric (9)
)

create table KONTROLA.lektor
(
	id_lektora int identity(1, 1),
	cislo_lektora int primary key not null,
	jmeno varchar (30),
	prijmeni varchar (50),
	adresa varchar (50),
	obec varchar (30),
	psc numeric (5),
	telefon numeric (9)
)

create table KONTROLA.kurs
(
	id_kursu int identity(1, 1),
	cislo_kursu varchar (4) primary key not null,
	nazev varchar (50),
	popis varchar (200)	
)

create table KONTROLA.predpoklady
(
	id_predpokladu int identity(1, 1) primary key,
	cislo_kursu varchar (4) foreign key references KONTROLA.kurs (cislo_kursu),
	cislo_predchozi varchar (4)
) 

create table KONTROLA.aprobace
(
	id_aprobace int identity(1, 1) primary key,
	cislo_lektora int foreign key references KONTROLA.lektor (cislo_lektora),	
	cislo_kursu varchar (4) foreign key references KONTROLA.kurs (cislo_kursu)
) 

create table KONTROLA.terminy
(
	id_terminu int identity(1, 1) primary key,
	rok varchar (9),
	semestr varchar (5),
	cislo_kursu varchar (4) foreign key references KONTROLA.kurs (cislo_kursu),
	ucebna varchar (4),
	den varchar (5),
	cas varchar (5),
	cislo_lektora int foreign key references KONTROLA.lektor (cislo_lektora)	
)

create table KONTROLA.hodnoceni
(
	id_hodnoceni int identity(1, 1) primary key,
	cislo_studenta int foreign key references KONTROLA.student (cislo_studenta),
	id_terminu int foreign key references KONTROLA.terminy (id_terminu),
	hodnoceni int
) 

-- ukonceni tvorby tabulek


-- vlozeni studentu
insert into KONTROLA.student (cislo_studenta, jmeno, prijmeni, adresa, obec, psc, telefon)
values (4567, 'Helena','Červená','Poříčí 128','Brno','60200','523698741')
insert into KONTROLA.student (cislo_studenta, jmeno, prijmeni, adresa, obec, psc, telefon)
values (4965, 'Barbora','Studená','U Pergamenky 26','Praha','12000','258963147')
insert into KONTROLA.student (cislo_studenta, jmeno, prijmeni, adresa, obec, psc, telefon)
values (6874, 'Jan','Čermák','U dvora 569','Jihlava','58698','365214895')
insert into KONTROLA.student (cislo_studenta, jmeno, prijmeni, adresa, obec, psc, telefon)
values (7096, 'Karel','Holub','U sokolovny 21','Brno','63500','512963478')
insert into KONTROLA.student (cislo_studenta, jmeno, prijmeni, adresa, obec, psc, telefon)
values (8513, 'Jiří','Adamec','Grohova 65','Brno','60200','587452369')

-- vlozeni lektoru
insert into KONTROLA.lektor (cislo_lektora, jmeno, prijmeni, adresa, obec, psc, telefon)
values (25897, 'Václav','Horník','Hlavní třída 1','Jihlava','58601','214563987')
insert into KONTROLA.lektor (cislo_lektora, jmeno, prijmeni, adresa, obec, psc, telefon)
values (36521, 'Martin','Dvořák','Křenová 54','Brno','62100','569743215')
insert into KONTROLA.lektor (cislo_lektora, jmeno, prijmeni, adresa, obec, psc, telefon)
values (87421, 'Ladislav','Pálka','Otakara Ševčíka 63','Brno','60200','539715698')
insert into KONTROLA.lektor (cislo_lektora, jmeno, prijmeni, adresa, obec, psc, telefon)
values (95471, 'Otakar','Možný','Kolejní 5','Brno','61600','411369852')

-- vlozeni kursu
insert into KONTROLA.kurs (cislo_kursu, nazev, popis)
values ('X100', 'Základy PC','Úvodní kurz informatiky')
insert into KONTROLA.kurs (cislo_kursu, nazev, popis)
values ('X201', 'Algoritmizace','Základy programování')
insert into KONTROLA.kurs (cislo_kursu, nazev, popis)
values ('X202', 'Visual Basic','Programovací tecjniky ve VB')
insert into KONTROLA.kurs (cislo_kursu, nazev, popis)
values ('X301', 'Základy zpracování dat','Struktura dat, techniky ukládání, práce s datovámi soubory')
insert into KONTROLA.kurs (cislo_kursu, nazev, popis)
values ('X302', 'Datové modelování','Relační datový model, normalizace, E-R diagramy')
insert into KONTROLA.kurs (cislo_kursu, nazev, popis)
values ('X401', 'Databázové systémy','Základy databází, SQL jazyk')

-- vlozeni predpokladu
insert into KONTROLA.predpoklady (cislo_kursu, cislo_predchozi)
values ('X201','X100')
insert into KONTROLA.predpoklady (cislo_kursu, cislo_predchozi)
values ('X202','X201')
insert into KONTROLA.predpoklady (cislo_kursu, cislo_predchozi)
values ('X302','X301')
insert into KONTROLA.predpoklady (cislo_kursu, cislo_predchozi)
values ('X401','X302')

-- vlozeni aprobace
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (25897,'X100')
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (36521,'X201')
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (36521,'X202')
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (95471,'X202')
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (95471,'X401')
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (87421,'X301')
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (87421,'X302')
insert into KONTROLA.aprobace (cislo_lektora, cislo_kursu)
values (87421,'X401')

-- vlozeni terminu
insert into KONTROLA.terminy (rok, semestr, cislo_kursu, ucebna, den, cas, cislo_lektora)
values ('2006/2007', 'Letní','X100','P384','Po','7-10',25897)
insert into KONTROLA.terminy (rok, semestr, cislo_kursu, ucebna, den, cas, cislo_lektora)
values ('2006/2007', 'Letní','X201','P164','St','13-15',36521)
insert into KONTROLA.terminy (rok, semestr, cislo_kursu, ucebna, den, cas, cislo_lektora)
values ('2006/2007', 'Letní','X401','P381','Po,Pá','9-11',87421)
insert into KONTROLA.terminy (rok, semestr, cislo_kursu, ucebna, den, cas, cislo_lektora)
values ('2007/2008', 'Zimní','X202','P165','St','10-12',95471)
insert into KONTROLA.terminy (rok, semestr, cislo_kursu, ucebna, den, cas, cislo_lektora)
values ('2007/2008', 'Zimní','X301','P292','St','17-19',87421)
insert into KONTROLA.terminy (rok, semestr, cislo_kursu, ucebna, den, cas, cislo_lektora)
values ('2007/2008', 'Zimní','X302','P264','Čt','15-17',87421)

-- vlozeni hodnoceni
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('4567',1,2)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('4567',4,2)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('4965',3,1)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('6874',2,1)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('6874',6,1)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('7096',3,2)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('7096',5,3)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('7096',6,2)
insert into KONTROLA.hodnoceni (cislo_studenta, id_terminu, hodnoceni)
values ('8513',3,3)
-- Nová tabulka bývalí studenti
CREATE TABLE Byvali_studenti
(
	id_student int,
	cislo_studenta int primary key not null,
	jmeno varchar (30),
	prijmeni varchar (50),
	adresa varchar (50),
	obec varchar (30),
	psc numeric (5),
	telefon numeric (9),
	datum_smazani DATETIME CONSTRAINT DF_Byvali_studenti_datum_smazani_GETDATE DEFAULT GETDATE()
);
GO
-- Trigger na smazání
CREATE TRIGGER smazano
on KONTROLA.student
FOR DELETE
AS
BEGIN
	INSERT INTO Byvali_studenti SELECT id_student,cislo_studenta,jmeno,prijmeni,adresa,obec,psc,telefon,getdate() FROM DELETED
END;
--transakce
BEGIN TRANSACTION TZ1
BEGIN TRY
ALTER TABLE KONTROLA.hodnoceni NOCHECK CONSTRAINT ALL
DELETE FROM KONTROLA.student
WHERE cislo_studenta=4567
SELECT * FROM Byvali_studenti;
SELECT * FROM KONTROLA.student;
COMMIT TRANSACTION TZ1
END TRY
BEGIN CATCH
  ROLLBACK TRANSACTION TZ1
END CATCH  
GO
-- procedura kurz
CREATE PROCEDURE KURZ
@kurzis VARCHAR(50)
	AS
	BEGIN
		SELECT nazev,popis,semestr,ucebna,den,cas,cislo_predchozi FROM KONTROLA.kurs,KONTROLA.terminy,KONTROLA.predpoklady
		WHERE @kurzis=nazev
	END;
	-- ověření
	KURZ 'Databázové systémy'
-- procedura s vnořenou procedurou
CREATE PROCEDURE ProcOuter
@hodnota INTEGER
	AS
	BEGIN
		SELECT jmeno,prijmeni,telefon FROM KONTROLA.lektor
		WHERE @hodnota=cislo_lektora
	END
	GO
CREATE PROCEDURE ProcInner
@idis VARCHAR(30),
@kurzisis VARCHAR(50),
@gimmeabreak INTEGER OUTPUT
	AS
	BEGIN
		SET @gimmeabreak = (SELECT cislo_lektora FROM KONTROLA.hodnoceni,KONTROLA.terminy WHERE @idis=cislo_studenta AND @kurzisis=cislo_kursu)		
	EXECUTE ProcOuter @gimmeabreak
	END
	GO



CREATE PROCEDURE OutroONE
@idlektor INTEGER
AS
BEGIN
IF @idlektor IS NULL
BEGIN
PRINT 'STUDENT NEBYL HODNOCEN'
END
ELSE
BEGIN
select (l.jmeno+' '+l.prijmeni) AS 'Jméno', l.telefon
from KONTROLA.lektor l
where id_lektora = @idlektor
END
END
GO
CREATE PROCEDURE IntroONE
@id_studenta INTEGER,
@cislo_kursu VARCHAR(4) 
AS
BEGIN
DECLARE @idlektor INTEGER 
SET @idlektor = (select l.id_lektora 
from KONTROLA.lektor l,KONTROLA.terminy t, KONTROLA.kurs k, KONTROLA.hodnoceni h, KONTROLA.student s
where s.cislo_studenta = h.cislo_studenta
and h.id_terminu = t.id_terminu
and k.cislo_kursu = t.cislo_kursu
and t.cislo_lektora = l.cislo_lektora
and @id_studenta = s.id_student
and @cislo_kursu = k.cislo_kursu)
EXECUTE OutroONE @idlektor 
END
	/*CONVERT(varchar(10), cislo_lektora)*/


CREATE PROCEDURE OutroONE
AS
BEGIN
IF @idlektor IS NULL
BEGIN
PRINT 'STUDENT NEBYL HODNOCEN'
END
ELSE
BEGIN
select (l.jmeno+' '+l.prijmeni) AS 'Jméno', l.telefon
from KONTROLA.lektor l
where id_lektora = @idlektor
END
END
GO
CREATE PROCEDURE IntroONE
@id_studenta INTEGER,
@cislo_kursu VARCHAR(4),
@idlektor INTEGER OUTPUT 
AS
BEGIN
@idlektor INTEGER 
SET @idlektor = (select l.id_lektora 
from KONTROLA.lektor l,KONTROLA.terminy t, KONTROLA.kurs k, KONTROLA.hodnoceni h, KONTROLA.student s
where s.cislo_studenta = h.cislo_studenta
and h.id_terminu = t.id_terminu
and k.cislo_kursu = t.cislo_kursu
and t.cislo_lektora = l.cislo_lektora
and @id_studenta = s.id_student
and @cislo_kursu = k.cislo_kursu)
EXECUTE OutroONE @idlektor
END

--kurzor
declare kurzor cursor for
select s.jmeno, s.prijmeni, t.den, t.ucebna
from kontrola.student s, kontrola.hodnoceni h, kontrola. terminy t
where s.cislo_studenta = h.cislo_studenta
and h.id_terminu = t.id_terminu
declare
@jmeno varchar (30),
@prijmeni varchar (50),
@den varchar (5),
@ucebna varchar (4)
open kurzor
fetch kurzor into @jmeno, @prijmeni, @den, @ucebna
while @@fetch_status = 0

begin

print @jmeno+' '+@prijmeni+' - '+@den+' - UŤebna: '+@ucebna
fetch kurzor into @jmeno, @prijmeni, @den, @ucebna
end

close kurzor
deallocate kurzor