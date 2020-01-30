-- Exercice 1 --

CREATE FUNCTION calculTemps () returns void as $$

DECLARE
	cursorDate CURSOR for SELECT dateAch, dateIns, nlog FROM Installer I JOIN Logiciel L ON I.nLog = L.nLog;

BEGIN
	for val in cursorDate loop
		if val.dateAch IS NULL
			RAISE NOTICE "Pas de date d'achat sur %", val.nlog;
		else
			if val.dateIns IS NULL
				RAISE NOTICE "Pas de date d'installation sur %", val.nlog;
			else
				if (val.dateAch > val.dateIns)
					RAISE NOTICE "Date d'achat supérieur à date d'installation sur %", val.nlog;
				else
					UPDATE Installer SET delai=(val.dateIns - val.dateAch) WHERE I.nLog=val.nLog and I.nposte=val.nposte;
				end if;
			end if;
		end if;
	end loop;
END;

$$ LANGUAGE plpgsql;

-- Exerice 2 --

CREATE FUNCTION installLogSeg (_indIP in Varchar, _nLog in Varchar, _nomLog in Varchar, _dateAch in Varchar, _version in Varchar, _typeLog in Varchar, _prix in Number) returns void as $$

DECLARE
	cursorPoste CURSOR for SELECT P.nposte, P.nomPoste, P.nsalle FROM Poste P WHERE P.indIP=_indIP and P.typePoste=_typeLog;

BEGIN
	INSERT INTO Logiciel values (_nLog, _nomLog, _dateAch, _version, _typeLog, _prix, 0)
		RAISE NOTICE "% stocké dans la table Logiciel", _nLog;
	for lig in cursorPoste loop
		INSERT INTO Installer (lig.nposte, _nLog, nextval(seqIns), currentDate, currentDate-_dateAch);
		RAISE NOTICE "Installation sur Poste % dans la salle %", lig.nposte, lig.nsalle;
	end loop
END;

$$ LANGUAGE plpgsql;