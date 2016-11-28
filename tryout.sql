-- table
CREATE TABLE Byvali_dodavatele
(
DodavatelID	int primary key,
NazevFirmy varchar (50),
ICO	varchar	(8),
DIC	varchar	(10),
UcetCislo varchar (20),
Web	varchar	(50),
Vlozeno	date not null,
Smazano DATETIME CONSTRAINT DF_Byvali_dodavatele_Smazano_GETDATE DEFAULT GETDATE()
)
GO
-- trigger
CREATE TRIGGER smazano
ON Dodavatel.Identifikace
FOR DELETE
AS
BEGIN
		INSERT INTO Byvali_dodavatele SELECT DodavatelID,NazevFirmy,ICO,DIC,UcetCislo,Web,Vlozeno,GETDATE() FROM DELETED
END
-- TEST
ALTER TABLE Dodavatel.Identifikace NOCHECK CONSTRAINT ALL
ALTER TABLE Dodavatel.Zbozi NOCHECK CONSTRAINT ALL
ALTER TABLE Dodavatel.Kontakt NOCHECK CONSTRAINT ALL
DELETE FROM Identifikace.Dodavatele 
Where DodavatelID=1
-- Transakce
BEGIN TRANSACTION TZ1
BEGIN TRY
ALTER TABLE Dodavatel.Identifikace NOCHECK CONSTRAINT ALL
ALTER TABLE Dodavatel.Zbozi NOCHECK CONSTRAINT ALL
ALTER TABLE Dodavatel.Kontakt NOCHECK CONSTRAINT ALL
DELETE FROM Identifikace.Dodavatele 
Where DodavatelID=1
SELECT * FROM Byvali_studenti;
SELECT * FROM KONTROLA.student;
--potvrzení transakce: COMMIT TRANSACTION TZ1
END TRY
BEGIN CATCH
  ROLLBACK TRANSACTION TZ1
END CATCH  
GO
-- procedura ZBOZI_DLE_KATEGORIE
CREATE PROCEDURE ZBOZI_DLE_KATEGORIE
@zbozi VARCHAR(50)
AS
BEGIN 
	SELECT NazevKategorie nazev,NazevZbozi zbozi_nazev,Nasklade,NazevFirmy firma FROM
	Zbozi.Zbozi zbozi_nazev,Zbozi.Kategorie nazev,Dodavatel.Zbozi,Dodavatel.Identifikace firma
	WHERE @zbozi=NazevKategorie
END
--test
ZBOZI_DLE_KATEGORIE 'Ostatní'
--Vnorene procedury
CREATE PROCEDURE Vnorena
CREATE PROCEDURE Hlavni
@kategoris VARCHAR(50),
@dodavatelis INTEGER OUTPUT
AS
BEGIN
	SET @dodavatelis = (SELECT TOP 1 DodavatelID D
	FROM Dodavatel.Zbozi D,Zbozi.Zbozi Z,Zbozi.Kategorie K
	WHERE Z.ZboziKategorie=
	ZboziKategorie = @kategoris)
END


--Bonus
declare kurzor cursor for
select kat.NazevKategorie,n.NazevFirmy,k.Jmeno, k.Prijmeni, k.Telefon
from Zbozi.Zbozi zb,Zbozi.Kategorie kat,Dodavatel.Identifikace n,Dodavatel.Kontakt k
where zb.ZboziKategorie = kat.ZboziKategorie
declare
@kategorka Varchar(30),
@nazevfirmy Varchar(30),
@jmeno varchar (30),
@prijmeni varchar (50),
@telefon varchar (18)
open kurzor
fetch kurzor into @kategorka,@nazevfirmy,@jmeno, @prijmeni, @telefon
while @@fetch_status = 0

begin

print @kategorka+' '+@nazevfirmy+' - '+@jmeno+' - '+@prijmeni+' - '+@telefon
fetch kurzor into @kategorka, @nazevfirmy, @jmeno, @prijmeni,@telefon
end

close kurzor
deallocate kurzor


--test na proceduru
create procedure vnorena
@id_lektora int
as
begin
if(@id_lektora is null)
begin
print 'Student nebyl z danťho kurzu hodnocen'
end
else
begin
select (l.jmeno+' '+l.prijmeni) AS 'Jmťno', l.telefon
from KONTROLA.lekor l
where id_lektora = @id_lektora
end
end

create procedure hlavni
@id_studenta int,
@cislo_kursu varchar (4),
@id_lektora int output
as
begin

set @id_lektora = (
select l.id_lektora 
from KONTROLA.lektor l,KONTROLA.terminy t, KONTROLA.kurs k, KONTROLA.hodnoceni h, KONTROLA.student s
where s.cislo_studenta = h.cislo_studenta
and h.id_terminu = t.id_terminu
and k.cislo_kursu = t.cislo_kursu
and t.cislo_lektora = l.cislo_lektora
and @id_studenta = s.id_student
and @cislo_kursu = k.cislo_kursu
)


execute vnorena @id_lektora
end

declare @id_lektora int
execute hlavni 1, 'X100', @id_lektora output