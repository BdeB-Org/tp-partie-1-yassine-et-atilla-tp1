-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: Mahfoudhi Mohamed Yassine                       Votre DA: 6253275
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2 (fait)

DESCRIBE OUTILS_OUTIL ;
DESCRIBE OUTILS_USAGER ;
DESCRIBE OUTILS_EMPRUNT ;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2 (fait)

SELECT CONCAT(PRENOM, ' ', NOM_FAMILLE) AS Nom_Complet
FROM OUTILS_USAGER;


-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2(fait)

SELECT DISTINCT VILLE
FROM OUTILS_USAGER
ORDER BY VILLE ASC;



-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2(fait)

SELECT *
FROM OUTILS_OUTIL
ORDER BY NOM, CODE_OUTIL ASC;


-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2(fait)

SELECT NUM_EMPRUNT
FROM OUTILS_EMPRUNT
WHERE DATE_RETOUR IS NULL;


-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3 (fait)

SELECT  NUM_EMPRUNT
FROM OUTILS_EMPRUNT
WHERE DATE_EMPRUNT < '2014-01-01';



-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3 ( fait)

SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE UPPER(CARACTERISTIQUES) LIKE '%J%';




-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2 (fait)

SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE FABRICANT = 'Stanley';



-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2 (fait)

SELECT NOM, FABRICANT
FROM OUTILS_OUTIL
WHERE ANNEE BETWEEN 2006 AND 2008;



-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3 (fait)


SELECT CODE_OUTIL, NOM
FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES NOT LIKE '%20 VOLTS%';



-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2(fait)

SELECT COUNT(*)
FROM OUTILS_OUTIL
WHERE FABRICANT <> 'Makita';



-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5( fait)

SELECT CONCAT(PRENOM, ' ', NOM_FAMILLE) AS Nom_Complet , NUM_EMPRUNT, DATE_RETOUR-DATE_EMPRUNT AS Duree_empruntenjour, PRIX
FROM OUTILS_USAGER
JOIN OUTILS_EMPRUNT 
ON OUTILS_USAGER.NUM_USAGER = OUTILS_EMPRUNT.NUM_USAGER
JOIN OUTILS_OUTIL ON OUTILS_EMPRUNT.CODE_OUTIL = OUTILS_OUTIL.CODE_OUTIL
WHERE VILLE IN ('Vancouver', 'Regina');




-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4 (fait)

SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE CODE_OUTIL IN (
    SELECT CODE_OUTIL
    FROM OUTILS_EMPRUNT
    WHERE DATE_RETOUR IS NULL
);




-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3 (fait)

SELECT NOM_FAMILLE, COURRIEL
FROM OUTILS_USAGER
WHERE NUM_USAGER NOT IN (
    SELECT DISTINCT NUM_USAGER
    FROM OUTILS_EMPRUNT
);




-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4 (fait)

SELECT o.CODE_OUTIL, COALESCE(o.PRIX, 0) AS PRIX
FROM OUTILS_OUTIL o
LEFT JOIN OUTILS_EMPRUNT e ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE e.CODE_OUTIL IS NULL;



-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4 (fait)

SELECT NOM, 
       COALESCE(PRIX, (SELECT AVG(PRIX) FROM OUTILS_OUTIL WHERE FABRICANT = 'Makita')) AS PRIX
FROM OUTILS_OUTIL 
WHERE FABRICANT = 'Makita' 
AND (PRIX > (SELECT AVG(PRIX) FROM OUTILS_OUTIL WHERE FABRICANT = 'Makita'));



-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4 (fait)

SELECT u.NOM_FAMILLE, u.PRENOM, u.ADRESSE, o.NOM AS nom_outil, o.CODE_OUTIL AS code_outil
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e ON u.NUM_USAGER = e.NUM_USAGER
JOIN OUTILS_OUTIL o ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE e.DATE_EMPRUNT > '2014-01-01'
ORDER BY u.NOM_FAMILLE;


-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4 ( fait)

SELECT o.NOM, o.PRIX
FROM OUTILS_OUTIL o
JOIN OUTILS_EMPRUNT e ON o.CODE_OUTIL = e.CODE_OUTIL
GROUP BY o.CODE_OUTIL, o.NOM, o.PRIX
HAVING COUNT(e.CODE_OUTIL) > 1;





-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6 ( fait)

--  Une jointure

SELECT DISTINCT u.NOM_FAMILLE, u.ADRESSE, u.VILLE
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e ON u.NUM_USAGER = e.NUM_USAGER;


--  IN

SELECT DISTINCT u.NOM_FAMILLE, u.ADRESSE, u.VILLE
FROM OUTILS_USAGER u
WHERE u.NUM_USAGER IN (SELECT NUM_USAGER FROM OUTILS_EMPRUNT);

--  EXISTS

SELECT DISTINCT u.NOM_FAMILLE, u.ADRESSE, u.VILLE
FROM OUTILS_USAGER u
WHERE EXISTS (SELECT 1 FROM OUTILS_EMPRUNT e WHERE e.NUM_USAGER = u.NUM_USAGER);




-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3 (fait)

SELECT FABRICANT AS marque, AVG(PRIX) AS MOYENNE_PRIX
FROM OUTILS_OUTIL
GROUP BY FABRICANT;



-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4 (fait)

SELECT SUM(e.PRIX), c.ville
FROM OUTILS_OUTIL e
INNER JOIN OUTILS_EMPRUNT d ON e.CODE_OUTIL = d.CODE_OUTIL
JOIN OUTILS_USAGER c ON c.NUM_USAGER = d.NUM_USAGER
GROUP BY c.VILLE
ORDER BY SUM(e.PRIX) DESC;



-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2 (fait)

INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('7891011', 'NOUVEL_OUTIL1', 'YASSINE', 'rouge et brillant','2020','999');




-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2 (fait)

INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('123456', 'NOUVEL_OUTIL2','2017');


-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2 (fait)

DELETE FROM OUTILS_OUTIL
WHERE CODE_OUTIL IN ('123456', '7891011');


-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2 (fait)

UPDATE OUTILS_USAGER
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);




