-- 2.1 Vytvoreni databaze a tabulek
CREATE DATABASE Znamky
GO

USE Znamky
GO

CREATE TABLE Student
(
  id_student int identity(1, 1),
  jmeno varchar(50),
  prijmeni varchar (50),
  CONSTRAINT PK_Tabulka_Student PRIMARY KEY (id_student)
)
GO

CREATE TABLE Predmet
(
  id_predmet int identity(1, 1),
  nazev varchar(50),
  CONSTRAINT PK_Tabulka_Predmet PRIMARY KEY (id_predmet)
)
GO

CREATE TABLE Ucitel
(
  id_ucitel int identity(1, 1),
  jmeno varchar(50),
  prijmeni varchar (50),
  CONSTRAINT PK_Tabulka_Ucitel PRIMARY KEY (id_ucitel)
)
GO

CREATE TABLE Vyucujici
(
  id_ucitel int,
  id_predmet int,
  CONSTRAINT PK_Tabulka_Vyucujici PRIMARY KEY (id_ucitel, id_predmet),
  CONSTRAINT FK_Vyucujici_Ucitel FOREIGN KEY (id_ucitel)
  REFERENCES Ucitel (id_ucitel),
  CONSTRAINT FK_Vyucujici_Predmet FOREIGN KEY (id_predmet)
  REFERENCES Predmet (id_predmet)
 )
GO

CREATE TABLE Znamka
(
  id_student int, 
  id_predmet int,
  id_ucitel int,
  body int,
  CONSTRAINT PK_Tabulka_Znamka PRIMARY KEY (id_student, id_ucitel, id_predmet),
  CONSTRAINT PK_Znamka_Student FOREIGN KEY (id_student)
  REFERENCES Student (id_student),
  CONSTRAINT FK_Znamka_Predmet FOREIGN KEY (id_predmet)
  REFERENCES Predmet (id_predmet),
  CONSTRAINT FK_Znamka_Ucitel FOREIGN KEY (id_ucitel)
  REFERENCES Ucitel(id_ucitel)
)
GO

-- 2.1 Naplneni tabulek daty
--	vložení studentù
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Franta', 'Novák')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Pepa', 'Janù')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Jarda', 'Poøízek')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Ferda', 'Petržela')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Roman', 'Koláø')
GO

--	vložení uèitelù

INSERT INTO ucitel (jmeno, prijmeni)
VALUES ('Vlastimil', 'Dvoøák')
INSERT INTO ucitel (jmeno, prijmeni)
VALUES ('Jaromír', 'Novotný')
INSERT INTO ucitel (jmeno, prijmeni) 
VALUES ('Tomáš', 'Marný')
GO

--	vložení pøedmìtù
INSERT INTO predmet (nazev)
VALUES ('matematika')
INSERT INTO predmet (nazev)
VALUES ('chemie')
INSERT INTO predmet (nazev)
VALUES ('dìjepis')
INSERT INTO predmet (nazev)
VALUES ('èeština')
GO

--	vložení vyuèujících (uèitelù, kteøí vyuèují pøedmìty)
INSERT INTO vyucujici (id_predmet, id_ucitel)
VALUES (3, 1)
INSERT INTO vyucujici (id_predmet, id_ucitel)
VALUES (3, 2)
INSERT INTO vyucujici (id_predmet, id_ucitel)
VALUES (1, 2)
GO

--	vložení známek 
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (1, 1, 3, 65)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (2, 1, 3, 45)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (3, 1, 3, 100)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (4, 1, 3, 50)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (1, 2, 3, 20)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (2, 2, 3, 50)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (3, 2, 3, 80)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (4, 2, 3, 60)
GO

-- 3. ZOBRAZENÍ DAT Z VYTVOØENÝCH TABULEK
-- 3.1 vypište uèitele, kteøí vyuèují pøedmety spolu 
-- s názvy vyuèovaného pøedmetu (jméno, pøíjmení, název)
SELECT u.jmeno, u.prijmeni, p.nazev
FROM ucitel u 
INNER JOIN vyucujici v 
 ON u.id_ucitel=v.id_ucitel
INNER JOIN predmet p
 ON v.id_predmet=p.id_predmet
GO

SELECT u.jmeno, u.prijmeni, p.nazev
FROM ucitel u, vyucujici v, predmet p
WHERE u.id_ucitel=v.id_ucitel
AND v.id_predmet=p.id_predmet
GO

-- 3.2 Vypište uèitele, kteøí nevyuèují žadný pøedmìt (jméno, pøíjmení)
-- (ve sbírce)
SELECT u.jmeno, u.prijmeni
FROM ucitel u 
WHERE NOT EXISTS 
  (
    SELECT * FROM vyucujici v 
    WHERE v.id_ucitel=u.id_ucitel
  )
GO

SELECT u.jmeno, u.prijmeni
FROM ucitel u 
LEFT JOIN vyucujici v 
 ON u.id_ucitel=v.id_ucitel
WHERE v.id_ucitel IS NULL
GO

-- 3.3 Vypište body jednotlivých studentù pøedmetu s názvem „matematika“
-- (jméno, pøíjmení, body)
SELECT s.jmeno, s.prijmeni, z.body
FROM student s, znamka z, predmet p
WHERE s.id_student=z.id_student
AND z.id_predmet=p.id_predmet
AND p.nazev='matematika'
GO

SELECT s.jmeno, s.prijmeni, z.body
FROM student s 
 INNER JOIN znamka z
 ON s.id_student=z.id_student
 INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
WHERE 
p.nazev='matematika'

-- 3.4 vypište všechny studenty, které máme v tabulce Student a tìm, kteøí 
-- konali nìjakou zkoušku souèasnì vypište i název pøedmìtu a body
SELECT s.jmeno, s.prijmeni, z.body, p.nazev
FROM student s 
 LEFT JOIN znamka z
 ON s.id_student=z.id_student
 LEFT JOIN predmet p
 ON z.id_predmet=p.id_predmet
GO

-- 3.5 Agregaèní funkce
-- jsou Poèet, Prùmìr, Suma, Minimum a Maximum. Obecná syntace: název funkce() 
SELECT p.nazev, count(z.body) AS Poèet, avg(z.body) AS Prùmìr, sum(z.body) AS Suma, 
min(z.body) AS Minimum,max(z.body) AS Maximum
FROM znamka z, predmet p
WHERE z.id_predmet=p.id_predmet
GROUP BY p.nazev
GO

-- 3.6 Zobrazte prùmìrný, minimální a maximální poèet bodù z jednotlivých pøedmìtù
-- pro každého studenta, který konal zkoušku, dále poèet pøedmìtù ze kterých 
-- byl bodován a souèasnì vypište jeho pøíjmení
SELECT s.prijmeni, count(z.body) AS Poèet, avg(z.body) AS Prumer, min(z.body) AS Minimum,
max(z.body) AS Maximum 
FROM student s, znamka z, predmet p
WHERE z.id_predmet=p.id_predmet
AND z.id_student=s.id_student
GROUP BY s.prijmeni
GO

-- 3.7 Zobrazte celé jména uèitelù (jméno a pøíjmení v jednom sloupci), 
-- kteøí zapsali body studentùm zobrazte také body, 
-- název pøedmetu a celé jméno studenta (jméno a pøíjmení v jednom sloupci)
SELECT u.jmeno+' '+u.prijmeni as 'Jméno uèitele', z.body, 
p.nazev, s.jmeno+' '+s.prijmeni as 'Jméno studenta'
FROM ucitel u
INNER JOIN znamka z 
 ON z.id_ucitel=u.id_ucitel
INNER JOIN student s
 ON z.id_student=s.id_student
INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
GO

-- 3.8 Upravte pøedcházející dotaz (3.7) tak, aby se zobrazila celá jména uèitelù, 
-- kteøí zapsali body studentùm se jménem "Jarda" a zamezte výpisu duplicitních záznamù.
-- Pozn.: Jako nápovìda je použit podobný dotaz s klauzulí WHERE, 
-- vy provedete dotaz s pøíkazem JOIN. 
SELECT DISTINCT u.jmeno, u.prijmeni 
FROM ucitel u, znamka z, student s, predmet p
WHERE u.id_ucitel=z.id_ucitel
AND z.id_student=s.id_student
AND z.id_predmet=p.id_predmet
AND s.jmeno='Jarda'
GO

SELECT DISTINCT u.jmeno+' '+u.prijmeni as 'Jméno uèitele'
FROM ucitel u
INNER JOIN znamka z 
 ON z.id_ucitel=u.id_ucitel
INNER JOIN student s
 ON z.id_student=s.id_student
INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
WHERE 
s.jmeno='Jarda'
GO

-- VYTVOØENÍ JEDNODUCHÝCH POHLEDÙ
-- 4.Vytvoøte pohled s názvem Prehled, který bude obsahovat 
-- celá jména uèitelù (jméno a pøíjmení v jednom sloupci), kteøí zapsali body studentùm, 
-- vèetnì bodù, názvù pøedmìtu a celých jmen studentù (jméno a pøíjmení v jednom sloupci)
CREATE VIEW Prehled AS
SELECT u.jmeno+' '+u.prijmeni as 'Jméno_uèitele', z.body, 
p.nazev, s.jmeno+' '+s.prijmeni as 'Jméno_studenta'
FROM ucitel u
INNER JOIN znamka z 
 ON z.id_ucitel=u.id_ucitel
INNER JOIN student s
 ON z.id_student=s.id_student
INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
GO  

-- 4.1 který uèitel známkoval, kolik bodù obdržel a z jakého pøedmìtu student Novák   
SELECT Jméno_uèitele, body FROM Prehled  WHERE Jméno_studenta LIKE '%Novák%'
GO

-- 4.2 který uèitel známkoval, kolik bodù obdržel a z jakého pøedmìtu student Novák
-- a student Poøízek
 SELECT Jméno_uèitele, nazev, body FROM Prehled  WHERE Jméno_studenta LIKE '%Novák%'
 OR Jméno_studenta LIKE '%Poøíz%' 
GO

-- 4.3 Kteøí studenti obdrželi 60 a více bodù z matematiky a 20 a ménì bodù z chemie
SELECT Jméno_studenta, body, nazev FROM Prehled  WHERE body >=60 AND nazev='matematika'
OR body <=20 AND nazev='chemie'
GO

-- 5. ULOZENE PROCEDURY
-- 5.1 Vytvoøte si tabulky student_zaloha a znamky_zaloha kam budete ukládat mazaná data. 
--(nebude se zálohovat uèitel, který známku vložil).
-- Napište proceduru, která smaže studenta z tabulky student a vytvoøí zálohu. 
-- (vstupní parametr je identifikátor studenta.

CREATE TABLE Student_zaloha
(
  id_student int,
  jmeno varchar(50),
  prijmeni varchar (50),
  CONSTRAINT PK_Tabulka_Student_Zaloha PRIMARY KEY (id_student)
)
GO

CREATE TABLE Znamka_Zaloha
(
  id_student int, 
  id_predmet int,
  body int,
  CONSTRAINT PK_Tabulka_Znamka_Zaloha PRIMARY KEY (id_student, id_predmet)
 )
GO

CREATE PROCEDURE smaz_studenta 
@id_st int
AS
BEGIN  
  INSERT INTO student_zaloha 
    SELECT * FROM student WHERE id_student=@id_st
  INSERT INTO znamka_zaloha (id_student, id_predmet, body)
   SELECT z.id_student, z.id_predmet, z.body
   FROM znamka z
   WHERE z.id_student=@id_st
  DELETE FROM znamka WHERE id_student=@id_st
  DELETE FROM student WHERE id_student=@id_st
END
GO

EXECUTE Smaz_Studenta 1
GO

select * from student
select * from znamka
select * from Student_zaloha
select * from Znamka_Zaloha
GO

-- 5.2 Napište proceduru, která bude vkládat nového uèitele a pøedmìt, který bude vyuèovat.
-- Napø. vloz_vyucujiciho(‘Jan’, ‘Novák’, ‘Tìlocvik’).
-- Procedura zkontroluje, jestli se vyuèující a pøedmìt nachází v databázi, 
-- pokud ne, vloží je do pøíslušných tabulek. Poté vloží záznam do tabulky vyuèující.
--Pozn.: poslední vložená hodnota sloupce oznaèeného IDENTITY se získá 
--IDENT_CURRENT('table_name')


CREATE PROCEDURE vloz_vyucujiciho 
@jmeno varchar(50),
@prijmeni varchar(50),
@predmet varchar(50)
AS
BEGIN
  DECLARE @id_pred int
  SELECT @id_pred=id_predmet 
   FROM predmet WHERE nazev=@predmet
  IF (@id_pred IS NULL) 
  BEGIN
    INSERT INTO predmet VALUES (@predmet)
    SET @id_pred=IDENT_CURRENT('predmet')
  END
  DECLARE @id_uc int
  SELECT @id_uc=id_ucitel 
    FROM ucitel WHERE jmeno=@jmeno AND prijmeni=@prijmeni
  IF (@id_uc IS NULL) BEGIN
    INSERT INTO ucitel (jmeno, prijmeni) 
     VALUES (@jmeno, @prijmeni)
    SET @id_uc=IDENT_CURRENT('ucitel')
  END  
  INSERT INTO vyucujici (id_ucitel, id_predmet)
  VALUES (@id_uc, @id_pred)
END
GO

EXECUTE vloz_vyucujiciho 'Jan','Novák','Tìlocvik'
GO

SELECT * FROM Ucitel
SELECT * FROM Vyucujici
SELECT * FROM PREDMET
GO

-- 5.3 Naprogramujte uloženou proceduru se jménem save_student, která bude mít dva vstupní 
-- parametry (jméno a pøíjmení) studenta a jeden výstupní parametr (jeho id). 
-- Procedura zjistí, zda se student s daným jménem a pøíjmením nachází v databázi,
-- pokud ano, pouze vrátí jeho id a pokud ne, vloží jej a také vrátí jeho id. 
-- Toto id se generuje identitou (IDENTITY) a získá se pomocí @@IDENTITY.

CREATE PROCEDURE save_student 
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_student int output  
AS  
BEGIN
  SET @id_student = (SELECT TOP 1 id_student  -- kdyby existovaly duplicity 
	FROM student 
	WHERE jmeno = @jmeno AND prijmeni = @prijmeni) 
  IF (@id_student IS NULL)  
  BEGIN
    INSERT INTO student (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_student = @@IDENTITY    
  END
END
GO

DECLARE @id_student int -- výstupní promìnná
EXEC save_student 'František', 'Koudelka', @id_student output
print @id_student
GO

-- 5.4 Naprogramujte analogickou proceduru save_ucitel, která uloží uèitele.
-- Bude mít dva vstupní parametry (jméno a pøíjmení) uèitele, dva výstupní parametry 
-- (id_ucitele, existuje).

CREATE PROCEDURE save_ucitel
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_ucitel int = 0 output,
  @existuje int output
AS
BEGIN
  SET @id_ucitel = (SELECT TOP 1 id_ucitel 
	FROM ucitel 
	WHERE jmeno = @jmeno 
	AND prijmeni = @prijmeni)  
    SET @existuje = 0
  IF (@id_ucitel IS NULL)  
  BEGIN
    INSERT INTO ucitel (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_ucitel = @@IDENTITY    
	SET @existuje = 1
  END
END
GO

DECLARE @id_ucitel int
DECLARE @existuje int
EXEC save_ucitel 'wwsadsaddgfdgfdfdw', 'pddùkljfoo', @id_ucitel output,@existuje output
IF (@existuje = 0)
BEGIN
  PRINT 'Uèitel s tímto jménem již existuje'
END
ELSE 
BEGIN
	PRINT 'Uèitel byl vložen s ID'+' '+convert(varchar(3),@id_ucitel)
END
GO

-- 5.5 Analogická procedura save_ucitel1 s využitím vnoøené procedury Vypis
CREATE PROCEDURE Vypis
@id_ucitel int,
@existuje int
AS
BEGIN
	IF (@existuje = 0)
	BEGIN
		PRINT 'Uèitel s tímto jménem již existuje'
	END
	IF (@existuje =1)
	BEGIN
		PRINT 'Uèitel byl vložen s ID'+' '+convert(varchar(3),@id_ucitel)
	END
END
GO

CREATE PROCEDURE save_ucitel1
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_ucitel int output,
  @existuje int output
AS
BEGIN
  SET @id_ucitel = (SELECT TOP 1 id_ucitel 
	FROM ucitel 
	WHERE jmeno = @jmeno 
	AND prijmeni = @prijmeni)  
    SET @existuje = 0
  IF (@id_ucitel IS NULL)  
  BEGIN
    INSERT INTO ucitel (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_ucitel = @@IDENTITY    
	SET @existuje = 1
  END
EXECUTE Vypis @id_ucitel,@existuje
END
GO

DECLARE @id_ucitel int
DECLARE @existuje int
EXEC save_ucitel1 'wwfdwhdsGHasadadagjghj', 'pjfoo', @id_ucitel output, @existuje output
GO


-- 5.6 Dále naprogramujte proceduru save_hodnoceni, která bude mít 6 vstupních parametrù.
-- Bude to jméno a pøíjmení uèitele, jméno a pøíjmení studenta, název pøedmìtu a poèet bodù - èíslo, 
-- které student z pøedmìtu obdržel. Tato procedura využije všechny 3 pøedcházející procedury.
-- Nakonec vypíše známku, kterou student obdržel (A-F), to znamená, že body pøevede na známku. 
-- Pokud už existuje hodnocení od daného uèitele pro daný pøedmìt a daného studenta, pouze vypíše, že známka již byla zadaná.

CREATE PROCEDURE vloz_vyucujiciho1 
@jmeno varchar(50),
@prijmeni varchar(50),
@predmet varchar(50),
@id_predmet int = 0 output,
@id_ucitel int = 0 output 
AS
BEGIN
  DECLARE @id_pred int
  SELECT @id_pred=id_predmet 
   FROM predmet WHERE nazev=@predmet
  IF (@id_pred IS NULL) 
  BEGIN
    INSERT INTO predmet VALUES (@predmet)
    SET @id_pred=IDENT_CURRENT('predmet')
  END
  DECLARE @id_uc int
  SELECT @id_uc=id_ucitel 
    FROM ucitel WHERE jmeno=@jmeno AND prijmeni=@prijmeni
  IF (@id_uc IS NULL) BEGIN
    INSERT INTO ucitel (jmeno, prijmeni) 
     VALUES (@jmeno, @prijmeni)
    SET @id_uc=IDENT_CURRENT('ucitel')
  END  
  IF (@id_uc IS NULL) OR (@id_pred IS NULL) BEGIN
    INSERT INTO vyucujici (id_ucitel, id_predmet)
    VALUES (@id_uc, @id_pred)
  END
SET @id_predmet=IDENT_CURRENT('predmet')
SET @id_ucitel=IDENT_CURRENT('ucitel')
END
GO


CREATE PROCEDURE save_student 
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_student int output  
AS  
BEGIN
  SET @id_student = (SELECT TOP 1 id_student  -- kdyby existovaly duplicity 
	FROM student 
	WHERE jmeno = @jmeno AND prijmeni = @prijmeni) 
  IF (@id_student IS NULL)  
  BEGIN
    INSERT INTO student (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_student = @@IDENTITY    
  END
END
GO

CREATE PROCEDURE save_hodnoceni
  @jmeno_uc varchar (50),
  @prijmeni_uc varchar (50),
  @jmeno_stud varchar (50),
  @prijmeni_stud varchar (50),
  @nazev_pred varchar (50), 
  @body int
AS
BEGIN
  DECLARE 
    @id_ucitel int,
	@id_student int,
	@id_predmet int
--  EXEC save_ucitel @jmeno_uc, @prijmeni_uc, @id_ucitel output
  	EXEC vloz_vyucujiciho1 @jmeno_uc,@prijmeni_uc,@nazev_pred, @id_predmet output, @id_ucitel output
    EXEC save_student @jmeno_stud, @prijmeni_stud, @id_student output
--  EXEC save_predmet @nazev_pred, @id_predmet output
  
  IF ((SELECT count (*) 
	FROM znamka 
	WHERE id_ucitel = @id_ucitel 
	AND id_student = @id_student 
	AND id_predmet = @id_predmet) > 0)
  BEGIN
    PRINT 'znamka jiz byla zadana'
  END
  ELSE
  BEGIN
    INSERT INTO znamka (id_ucitel, id_predmet, id_student, body) 
    VALUES (@id_ucitel, @id_predmet, @id_student, @body)
    IF (@body < 50)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen známkou:'+' '+'F'+' '+'z pøedmìtu'+' '+@nazev_pred
    ELSE IF (@body < 60)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen známkou:'+' '+'E'+' '+'z pøedmìtu'+' '+@nazev_pred
    ELSE IF (@body < 70)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen známkou:'+' '+'D'+' '+'z pøedmìtu'+' '+@nazev_pred
    ELSE IF (@body < 80)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen známkou:'+' '+'C'+' '+'z pøedmìtu'+' '+@nazev_pred
    ELSE IF (@body < 90)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen známkou:'+' '+'B'+' '+'z pøedmìtu'+' '+@nazev_pred
    ELSE 
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen známkou:'+' '+'A'+' '+'z pøedmìtu'+' '+@nazev_pred
  END
END
GO

EXEC save_hodnoceni 'Jiøí', 'Køíž', 'Roman', 'Kuèera', 'ZPC', 75
GO


