-- Exercice 9.5 : simulation des techniques d'annulation

-- Considérant la structure des caches mémmoires et des fichiers d'un SGBD comme décrits ci-dessous.
-- . CMV: Cache en Mémoire Vive
--   Ensemble des tampons concourant à gérer les objets du SGBD en mémoire. TIA et TIV en font partie
-- . TIA: Tampon Image Après
--   Tampon contenant les données (lignes) APRES modification par les transactions dans la Base de Données
-- . TIV :Tampon Image aVant
--   Tampon contenant les données (lignes) AVANT modification par les transactions dans la Base de Données. Copie avant modification
-- . TJT: Tampon Journal des Transactions
--   Tampon contenant les données (lignes) AVANT et APRES  modification par les transactions dans la Base de Données
-- . FIA: Fichiers Image Après
--   Fichiers contenant les données (lignes) persistantes venant du TIA
-- . FIV: Fichiers Image aVant
--   Fichiers contenant les données (lignes) persistantes venant du TIV
-- . FJT : Fichiers Journal des Transactions
--   Fichiers de sauvegarde des contenus du TJT

-- Nous allons dans cet exercice proposer une série d'activités pour mettre en oeuvre les techniques d'annulation
-- Il s'agit de mettre en oeuvre des transactions en construisant leurs effets dans les différentes
-- zones.
-- Afin d'illustrer vos actions vous devez vous appuyer sur le script Airbase.sql qui contient
-- trois tables :
-- . PILOTE
-- . Avion 
-- . et Vol

-- Pas besoin d'être connecté pour faire ces activités pour l'insant.

-- Note :
--	. Les tampons : TIA et TIV sont découpés en pages ou blocs (dans 1 bloc on peut trouver 
--    0, 1 ou plusieurs lignes.
--		. Blocs TIA : BDAx (x de 0 à N), exemple : BDA0:1, Miranda, 2000
--		. Blocs TIV : BDVx (x de 0 à N), exemple : BDV0:1, Miranda, 2000

--  . Le tampon TJT  : Contient les enregistrements des transactions courantes. Voici 
--    leur structure : Id Transaction, Timestamp, IdBloc: enregistrement
--                     T0, D0, BDA0:1, Miranda, 2000
--                     T0, D0+1, COMMIT

--  . Le tampon FJT  : Contient les enregistrements venant du TJT
 
--  . Le tampon FIA  : Contient les enregistrements venant du TIA
--	  Est découpé en blocs BDAx (x de 0 à N)
	  
--  . Le tampon FIV  : Contient les enregistrements venant du TIV
--	  Est découpé en blocs BDVx (x de 0 à N)
	  
-- Voici la série d'exercices à faire : Voir avec l'enseignant pour plus de consignes  	  
-- Exercice 9.5.1.1 : Simulation de trois transactions (Sans COMMIT ni ROLLBACK)
-- Exercice 9.5.1.2 : Simulation de COMMIT
-- Exercice 9.5.1.3 : Simulation d'une lecture consistante
-- Exercice 9.5.1.4 : Simulation du Rollback
--------------------------------------------------------------------------------------------

-- Exercice 9.5.1 : Simulation manuelle	

-- Exercice 9.5.1.1 : Simulation de deux transactions (Sans COMMIT ni ROLLBACK)

-- Mettre en oeuvre l'effet de deux transactions dans les différentes 
-- zones ci-dessous (pas de COMMIT)

-- Soient les deux transactions suivantes (elles ne sont  :
-- Transaction 1 (T1): 
insert into  pilote values(24, 'Hassan', '13-MAY-1957', null, '',21000.6);
select * from pilote;
insert into  avion values(13, 'A300', 400, 'Paris', 'En service');
update avion set remarq='En panne'
where av#=11;

select * from avion;

-- Transaction 2 (T2): 
insert into  vol values(360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate );
delete from vol where vol#=310;
select * from vol;

-- TIA: Tampon Image Après
-- ici tous les changements
BDA0 (T1,x) : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
BDA1 (T1,x) : 13, 'A300', 400, 'Paris', 'En service'
BDA2 (T1,x) : 11, 'A300', 400, 'Paris', 'En panne'
BDA3 (T2,x) : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
BDA4 (T2,x) : 310, null

-- TIV :Tampon Image aVant
BDV0 : 11, 'A300', 400, 'Paris', 'En service'  -- au cas où besoin d'annuler
BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- TJT: Tampon Journal des Transactions
-- toutes les transactions, les avant et apre
T1, D0, BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
T1, D1, BDA1 : 13, 'A300', 400, 'Paris', 'En service'
T1, D2, BDV0 : 11, 'A300', 400, 'Paris', 'En service'
T1, D3, BDA2 : 11, 'A300', 400, 'Paris', 'En panne'
T2, D4, BDA3 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
T2, D5, BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D6, BDA4 : 310, null
T1, D7, COMMIT

-- FIA: Fichiers Image Après
-- (le select va dedans)
-- images d'origine
BDA2 : 11, 'A300', 400, 'Paris', 'En service' -- il recup le 11 ici, avant de modif dans TIA
BDA4 (T2,x) : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- FIV: Fichiers Image aVant
-- /

-- FJT : Fichiers Journal des Transactions
-- /
 
 
-- Exercice 9.5.1.2 : Simulation de COMMIT

-- En partant du résultat de l'exercice 9.5.1.1, faire COMMIT dans la transaction 1
-- Mettre à jour les zones en conséquence
-- on reprends ce qu'on a fait au dessus, et on ajoute ce que fait le commit

-- TIA: Tampon Image Après
-- ici tous les changements
BDA0 (T1,x) : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
BDA1 (T1,x) : 13, 'A300', 400, 'Paris', 'En service'
BDA2 (T1,x) : 11, 'A300', 400, 'Paris', 'En panne'
BDA3 (T2,x) : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
BDA4 (T2,x) : 310, null

-- TIV :Tampon Image aVant
BDV0 : 11, 'A300', 400, 'Paris', 'En service'  -- au cas où besoin d'annuler
BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- TJT: Tampon Journal des Transactions
-- toutes les transactions, les avant et apres
T1, D0, BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
T1, D1, BDA1 : 13, 'A300', 400, 'Paris', 'En service'
T1, D2, BDV0 : 11, 'A300', 400, 'Paris', 'En service'
T1, D3, BDA2 : 11, 'A300', 400, 'Paris', 'En panne'
T2, D4, BDA3 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
T2, D5, BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D6, BDA4 : 310, null
T1, D7, COMMIT

-- FIA: Fichiers Image Après
-- (le select va dedans)
-- images d'origine
BDA2 : 11, 'A300', 400, 'Paris', 'En service' -- il recup le 11 ici, avant de modif dans TIA
BDA4 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- FIV: Fichiers Image aVant
-- /

-- FJT : Fichiers Journal des Transactions
-- le commit copie juste tout dans le FJT
T1, D0, BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
T1, D1, BDA1 : 13, 'A300', 400, 'Paris', 'En service'
T1, D2, BDV0 : 11, 'A300', 400, 'Paris', 'En service'
T1, D3, BDA2 : 11, 'A300', 400, 'Paris', 'En panne'
T2, D4, BDA3 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
T2, D5, BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D6, BDA4 : 310, null
T1, D7, COMMIT


-- Exercice 9.5.1.3 : Simulation d'une lecture consistante

-- En partant du résultat de l'exercice 9.5.1.2 faire ce qui suit

--	a) A partir de la Transaction 2 (T2) effectuer une lecture consistante: 
--	Quel est le salaire du pilote Nr 24 ? (lecture consistante)
-- lecture consistante fait reference au niveau d'isolation, repeatable read
-- lecture impropre c'est quand on lit une valeur qui n'a pas été commit
-- lecture non reproductible T2 fait l'update d'une valeur et T1 se retrouve changé aussi, au sein d'une transaction, on va demander la meme donnee et elle sera differente à chq fois
-- tuple fantome : T1 commence, T2 créée et commit un nv element, et que T1 peut recup cet element qui n'existait pas au debut de la transaction
	
-- TIA: Tampon Image Après
-- ici tous les changements
BDA0 (T1,x) : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
BDA1 (T1,x) : 13, 'A300', 400, 'Paris', 'En service'
BDA2 (T1,x) : 11, 'A300', 400, 'Paris', 'En panne'
BDA3 (T2,x) : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
BDA4 (T2,x) : 310, null

-- TIV :Tampon Image aVant
BDV0 : 11, 'A300', 400, 'Paris', 'En service'  -- au cas où besoin d'annuler
BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- TJT: Tampon Journal des Transactions
-- toutes les transactions, les avant et apres
T1, D0, BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
T1, D1, BDA1 : 13, 'A300', 400, 'Paris', 'En service'
T1, D2, BDV0 : 11, 'A300', 400, 'Paris', 'En service'
T1, D3, BDA2 : 11, 'A300', 400, 'Paris', 'En panne'
T2, D4, BDA3 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
T2, D5, BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D6, BDA4 : 310, null
T1, D7, COMMIT

-- FIA: Fichiers Image Après
-- (le select va dedans)
-- images d'origine
BDA2 : 11, 'A300', 400, 'Paris', 'En service' -- il recup le 11 ici, avant de modif dans TIA
BDA4 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- FIV: Fichiers Image aVant
-- /

-- FJT : Fichiers Journal des Transactions
T1, D0, BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
T1, D1, BDA1 : 13, 'A300', 400, 'Paris', 'En service'
T1, D2, BDV0 : 11, 'A300', 400, 'Paris', 'En service'
T1, D3, BDA2 : 11, 'A300', 400, 'Paris', 'En panne'
T2, D4, BDA3 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
T2, D5, BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D6, BDA4 : 310, null
T1, D7, COMMIT
	
--	si isolation = serealizable alors le pilote 24 n'existe pas pr la T2 car c'est un tuple fantome
--	donc ds ce cas pas de salaire
--	si isolation = repeatable read ou moins alors on recup les donnees de l'enregistrement directement dans le TIA
	
	
-- Exercice 9.5.1.4 :Simulation du Rollback
 
-- En partant du résultat de l'exercice 9.5.1.3 faire 

--	a) Un rollack de la transaction T2
--	b) Mettre à jour les zones en conséquence

-- TIA: Tampon Image Après
-- ici tous les changements
BDA0 (T1) : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
BDA1 (T1) : 13, 'A300', 400, 'Paris', 'En service'
BDA2 (T1) : 11, 'A300', 400, 'Paris', 'En panne'
BDA3 (T2) : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
BDA4 (T2) : 310, null
-- apres rollback :
BDA5 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- TIV :Tampon Image aVant
BDV0 : 11, 'A300', 400, 'Paris', 'En service'  -- au cas où besoin d'annuler
BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- TJT: Tampon Journal des Transactions
-- toutes les transactions, les avant et apres
T1, D0, BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
T1, D1, BDA1 : 13, 'A300', 400, 'Paris', 'En service'
T1, D2, BDV0 : 11, 'A300', 400, 'Paris', 'En service'
T1, D3, BDA2 : 11, 'A300', 400, 'Paris', 'En panne'
T2, D4, BDA3 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
T2, D5, BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D6, BDA4 : 310, null
T1, D7, COMMIT
-- apres rollback :
T2, D8, BDA5 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D9, ROLLBACK

-- FIA: Fichiers Image Après
-- (le select va dedans)
-- images d'origine
BDA2 : 11, 'A300', 400, 'Paris', 'En service' -- il recup le 11 ici, avant de modif dans TIA
BDA4 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989

-- FIV: Fichiers Image aVant
-- /

-- FJT : Fichiers Journal des Transactions
T1, D0, BDA0 : 24, 'Hassan', '13-MAY-1957', null, '',21000.6
T1, D1, BDA1 : 13, 'A300', 400, 'Paris', 'En service'
T1, D2, BDV0 : 11, 'A300', 400, 'Paris', 'En service'
T1, D3, BDA2 : 11, 'A300', 400, 'Paris', 'En panne'
T2, D4, BDA3 : 360, 4,8,'Bordeaux', 'Paris', '23:00','23:55', sysdate 
T2, D5, BDV1 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D6, BDA4 : 310, null
T1, D7, COMMIT
-- apres rollback :
T2, D8, BDA5 : 310, 19, 8, Beauvais, Marseille, 1230, 1425, 09-MARS-1989
T2, D9, ROLLBACK



-- un checkpoint (pour ecriture intelligente) fait il rappatrie ttes les donnees, les tampons vers les images correspondantes
-- les tampons vont ds les fichiers 


---------------------------------------------------------------------------------------------

-- Exercice 9.5.2 : Simulation avec le SGBD Oracle	
-- 

-- Activité 9.5.2.0 : 

-- Activité 9.5.2.0.1 Première connexion
-- définition des variable pour la première connexion
-- Il faut ouvrir une fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple : cd D:\FSGBDS\instantclient_19_6

sqlplus /nolog


define ALIASDB1=pdbm1inf
define DRUSER=votreNomUserOracle
define DRUSERPASS=votrePassWordOracle
define SCRIPTPATH=CHEMIN\3SCRIPTS_EXERCICES\Scripts

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

@&SCRIPTPATH\airbase.sql

-- T1 et T3 se dérouleront dans cette connexion


-- Activité 9.5.2.0.2 Deuxième connexion
-- définition des variable pour la première connexion
-- Il faut ouvrir une fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple : cd D:\FSGBDS\instantclient_19_6

sqlplus /nolog

define ALIASDB1=pdbm1inf
define DRUSER=votreNomUserOracle
define DRUSERPASS=votrePassWordOracle

Connect &DRUSER@&ALIASDB1/&DRUSERPASS
	
-- T2 se déroulera dans cette connexion

	
-- Exercice 9.5.2.1 : Simulation deux transactions (Sans COMMIT ni ROLLBACK)
-- reprendre les activités de 9.5.1.1

-- Exercice 9.5.2.2 : Simulation de COMMIT
-- reprendre les activités de 9.5.1.2


-- Exercice 9.5.2.3 : Simulation d'une lecture consistante
-- reprendre les activités de 9.5.1.3

-- Exercice 9.5.2.4 :Simulation du Rollback
-- reprendre les activités de 9.5.1.4
