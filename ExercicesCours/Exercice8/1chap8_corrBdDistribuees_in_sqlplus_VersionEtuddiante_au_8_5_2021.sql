/*
Exercice 8.6.1 : Distribution de données sous Oracle

8.6.1.1 Problème

Supposons que nous ayant deux bases de données : 
- Base1 : pdbl3mia.631174089.oraclecloud.internal : (machine host IP : 144.21.67.201 Port : 1521) 
- Base2 : pdbm1inf.631174089.oraclecloud.internal : (machine host IP : 144.21.67.201 Port : 1521).
Nous désirons permettre aux utilisateurs d’effectuer 
des transactions distribuées sur les deux bases. 

Pour ce faire vous avez un utilisateur appelé &DRUSER 
créé dans chacune des bases avec un mot de passe
identique dans chacune des bases.

8.6.1.2 Travail à faire
	
1.	Dessiner la topologie de vos bases de données distribuées

2.	Organiser et mettre en oeuvre la distribution
sur les deux bases de données existantes. 
Ces bases sont démarrées
*/

-------------------------------------------------------------------------------------------------
-- Activité 1 : Connexion et définition  de variables
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- Activité 1.1 : connexion sur la Base1
-- définition des variable de la première base :  Base1 (voir la définition plus haut)
-- Il faut ouvrir une fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exe
-- exemple : cd D:\FSGBDS\instantclient_19_6
-------------------------------------------------------------------------------------------------

cd C:\Users\morga\Documents\COURS\MIAGE\S2\BD\instantclient_19_6
sqlplus /nolog


define SERVICEDB2=pdbm1inf.631174089.oraclecloud.internal
define DBLINKNAME2=pdbm1inf
define ALIASDB1=pdbl3mia

-- Définir votre nom d'utilisateur et mot de passe sur la base 1
--define DRUSER=votreLoginOracleIci
--define DRUSERPASS=votrePasswordOracleIci
define DRUSER=votreLoginOracleIci
define DRUSERPASS=votrePasswordOracleIci

define DRUSER=ULVE1M2021
define DRUSERPASS=ULVE1M202101

-- definir le chemin vers les scripts du tp : chap12_demobld.sql, etc.
--define SCRIPTPATH=CheminAModifier\3SCRIPTS_EXERCICES\Scripts
((define SCRIPTPATH=D:\1agm05092005\1Cours\13B_COURS_FSGBD\3SCRIPTS_EXERCICES\Scripts))

define SCRIPTPATH=C:\Users\morga\Documents\COURS\MIAGE\S2\BD\Exercices\Exercice8

-------------------------------------------------------------------------------------------------
-- Activité 1.2 : connexion sur la base 2
-- définition des variable de la deuxième base :  Base2 (voir la définition plus haut)
-- Il faut ouvrir une deuxième fenêtre CMD : INVITE DE COMMANDE
-- Faire cd pour aller dans le dossier ou se trouve sqlplus.exemple
-- exemple : cd D:\FSGBDS\instantclient_19_6
-------------------------------------------------------------------------------------------------

cd C:\Users\morga\Documents\COURS\MIAGE\S2\BD\instantclient_19_6
sqlplus /nolog
define SERVICEDB1=pdbl3mia.631174089.oraclecloud.internal
define DBLINKNAME1=pdbl3mia
define ALIASDB2=pdbm1inf

-- Définir votre nom d'utilisateur et mot de passe sur la base 1
--define DRUSER=votreLoginOracleIci
--define DRUSERPASS=votrePasswordOracleIci
--A modifier !!!
define DRUSER=votreLoginOracleIci
define DRUSERPASS=votrePasswordOracleIci

define DRUSER=ULVE1M2021
define DRUSERPASS=ULVE1M202101

-- definir le chemin vers le script du tp appelé :chap12_demobld.sql, etc.
-- define SCRIPTPATH=CheminAModifier\3SCRIPTS_EXERCICES\Scripts
-- A modifier !!!
define SCRIPTPATH=D:\1agm05092005\1Cours\13B_COURS_FSGBD\3SCRIPTS_EXERCICES\Scripts

define SCRIPTPATH=C:\Users\morga\Documents\COURS\MIAGE\S2\BD\Exercices\Exercice8


-------------------------------------------------------------------------------------------------
-- Activité 2 : Chargment des données
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- Activité 2.1 : Chargment des données sur la base1
-------------------------------------------------------------------------------------------------

-- Charger les tables (EMP, DEPT, …) contenues dans le 
-- script chap12_demobld.sql dans le 
-- schéma de &DRUSER sur la base &SERVICEDB1 ou ALIASDB1
-- sur la base &SERVICEDB1 ou ALIASDB1

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

@&SCRIPTPATH\chap8_demobld.sql

-------------------------------------------------------------------------------------------------
-- Activité 2.2 : Chargment des données sur la base2
-- Charger les tables (CLIENT, PRODUIT, COMMANDE) contenues dans 
-- le script chap12_clientbld.sql dans le 
-- schéma de &DRUSER sur la base &SERVICEDB2 ou ALIASDB2
-------------------------------------------------------------------------------------------------

-- sur la base &SERVICEDB2 ou ALIASDB2

Connect &DRUSER@&ALIASDB2/&DRUSERPASS

@&SCRIPTPATH\chap8_clientbld.sql


-------------------------------------------------------------------------------------------------
-- Activité 3 .	Créer un database link public pour permettre à l’utilisateur &DRUSER 
-- depuis la Base1 de manipuler des objets à distance sur la Base2

-- Dans le cadre de cet exercice, le Database Link est déjà créé par l'adminitrateur
-- Il est contenu dans la variable : DBLINKNAME2 (voir sa valeur)
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activité 4 : Consultaions et mise à jour distante : requête sur 1 base distante
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- Activité 4.1	Effectuer des consultations distantes
-------------------------------------------------------------------------------------------------

Connect &DRUSER@&ALIASDB1/&DRUSERPASS

-- Structure des tables distantes
desc &DRUSER..produit@&DBLINKNAME2

Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PID#                                      NOT NULL NUMBER(6)
 PNOM                                               VARCHAR2(50)
 PDESCRIPTION                                       VARCHAR2(100)
 PPRIXUNIT                                          NUMBER(7,2)


desc &DRUSER..commande@&DBLINKNAME2

Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PCOMM#                                    NOT NULL NUMBER(6)
 CDATE                                              DATE
 PID#                                               NUMBER(6)
 CID#                                               NUMBER(6)
 PNBRE                                              NUMBER(4)
 PPRIXUNIT                                          NUMBER(7,2)
 EMPNO                                              NUMBER(4)


desc &DRUSER..client@&DBLINKNAME2

Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CID#                                      NOT NULL NUMBER(6)
 CNOM                                               VARCHAR2(20)
 CDNAISS                                            DATE
 CADR                                               VARCHAR2(50)


select *
from &DRUSER..commande@&DBLINKNAME2;

old   2: from &DRUSER..commande@&DBLINKNAME2
new   2: from ULVE1M2021.commande@pdbm1inf

    PCOMM# CDATE           PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- --------- ---------- ---------- ---------- ---------- ----------
         1 10-MAY-21       1000          1          4          2       7369
         2 10-MAY-21       1000          1         10          2       7369
         3 10-MAY-21       1000          1          9          2       7369


set linesize 200
col CADR format A20
select * from &DRUSER..client@&DBLINKNAME2;

old   1: select * from &DRUSER..client@&DBLINKNAME2
new   1: select * from ULVE1M2021.client@pdbm1inf

      CID# CNOM                 CDNAISS   CADR
---------- -------------------- --------- --------------------
         1 Akim                 12-DEC-72 Washington
         2 Erzulie              12-DEC-42 Artibonite


set linesize 200
col pnom format A30
col pdescription format A40

select * from &DRUSER..produit@&DBLINKNAME2;

old   1: select * from &DRUSER..produit@&DBLINKNAME2
new   1: select * from ULVE1M2021.produit@pdbm1inf

      PID# PNOM                           PDESCRIPTION                              PPRIXUNIT
---------- ------------------------------ ---------------------------------------- ----------
      1000 Coca cola 2 litres             Coca cola 2 litres avec caf?in                    2
      1001 orangina pack de 6 bouteilles  orangina pack de 6 bouteilles de 1,5 lit          6
           de 1,5 litres                  res


-------------------------------------------------------------------------------------------------
-- Activité 4.2	Effectuer des mises à jour distantes sur la Base1
-------------------------------------------------------------------------------------------------

-- Modification des données d'une table distante sur la Base1 uniquement
Update &DRUSER..commande@&DBLINKNAME2
Set empno= 7369;

-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- Résultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   CHAPOULIE1M2 _SYSSMU3_3057867331$   000000007A28CDD8 ACTIVE  05/10/21 10:00:10     146829084          2
           021
PDBL3MIA   BRONDINO1M20 _SYSSMU8_563287346$    000000007A2D1E68 ACTIVE  05/10/21 10:00:37     146829475          1
           21
PDBL3MIA   BEYOSMAN1M20 _SYSSMU10_4201072483$  000000007A24D0D8 ACTIVE  05/10/21 10:04:44     146832334          1
           21
PDBL3MIA   GUILLAUMET1M _SYSSMU4_3605207014$   000000007A173808 ACTIVE  05/10/21 10:02:41     146829675          1
           2021
PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   LEFEUVRE1M20 _SYSSMU5_1473839336$   000000007A2D6608 ACTIVE  05/10/21 09:56:31     146828008          1
           21
PDBL3MIA   LONGIN1M2021 _SYSSMU7_2682504410$   000000007A1B7CA8 ACTIVE  05/10/21 09:57:39     146828422          1
PDBL3MIA   ULVE1M2021   _SYSSMU11_2843521970$  000000007A276490 ACTIVE  05/10/21 10:03:20     146829696          1

7 rows selected.


-- Résultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS
---------- ------------ ---------------------- ---------------- -------
START_TIME            START SCN  Block RBS
-------------------- ---------- ----------
PDBM1INF   CHAPOULIE1M2 _SYSSMU3_3057867331$   000000007A24B8F8 ACTIVE
           021
05/10/21 10:00:10     146829089          1

PDBM1INF   ULVE1M2021   _SYSSMU2_3035727479$   000000007A1C0BE8 ACTIVE
05/10/21 10:03:20     146832479          1


-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;

-- Résultat sur la Base1

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        28 CHAPOULIE1M2 EMP             Row-X (SX)    None                   483 Not Blocking
           021


-- Résultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        18 CHAPOULIE1M2 CLIENT          Row-X (SX)    None                   486 Not Blocking
           021
        18 CHAPOULIE1M2 PRODUIT         Row-X (SX)    None                   486 Not Blocking
           021
        18 CHAPOULIE1M2 COMMANDE        Row-X (SX)    None                   486 Not Blocking
           021
       288 ULVE1M2021   COMMANDE        Row-X (SX)    None                   163 Not Blocking


-- Validation sur la Base 1 uniquement
Commit;


-- Insertion d'une ligne dans une table distante : Base 1

insert into &DRUSER..commande@&DBLINKNAME2 (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(4, sysdate, 1000,1, 9, 2, 7369);

-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- Résultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   CHAPOULIE1M2 _SYSSMU3_3057867331$   000000007A28CDD8 ACTIVE  05/10/21 10:00:10     146829084          2
           021
PDBL3MIA   BOUSTATI1M20 _SYSSMU7_2682504410$   000000007A28D9C8 ACTIVE  05/10/21 10:06:48     146832564          1
           21
PDBL3MIA   BEYOSMAN1M20 _SYSSMU11_2843521970$  000000007A24D0D8 ACTIVE  05/10/21 10:10:43     146833620          1
           21
PDBL3MIA   GARNIER1M202 _SYSSMU2_3035727479$   000000007A1BE818 ACTIVE  05/10/21 10:08:51     146833339          2
           1
PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   GUILLAUMET1M _SYSSMU4_3605207014$   000000007A173808 ACTIVE  05/10/21 10:02:41     146829675          1
           2021
PDBL3MIA   ULVE1M2021   _SYSSMU9_513303587$    000000007A1E2840 ACTIVE  05/10/21 10:10:26     146833540          1
PDBL3MIA   FERRARINI1M2 _SYSSMU1_4270700177$   000000007A2B9150 ACTIVE  05/10/21 10:09:29     146833389          1
           021
PDBL3MIA   PDBADMIN     _SYSSMU12_1855142505$  000000007A199C00 ACTIVE  05/10/21 10:08:58     146833356          1
PDBL3MIA   GALLIPR2021  _SYSSMU6_3381045840$   000000007A2699A0 ACTIVE  05/10/21 10:08:54     146833344          1

9 rows selected.


-- Résultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1INF   CHAPOULIE1M2 _SYSSMU3_3057867331$   000000007A24B8F8 ACTIVE  05/10/21 10:00:10     146829089          1
           021
PDBM1INF   ULVE1M2021   _SYSSMU6_3381045840$   000000007A1C0BE8 ACTIVE  05/10/21 10:10:26     146833540          1
PDBM1INF   GARNIER1M202 _SYSSMU8_563287346$    000000007A1E1060 ACTIVE  05/10/21 10:08:51     146833342          1
           1


-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;
-- Résultat sur la Base1

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        28 CHAPOULIE1M2 EMP             Row-X (SX)    None                   738 Not Blocking
           021


-- Résultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        18 CHAPOULIE1M2 CLIENT          Row-X (SX)    None                   741 Not Blocking
           021
        18 CHAPOULIE1M2 PRODUIT         Row-X (SX)    None                   741 Not Blocking
           021
        18 CHAPOULIE1M2 COMMANDE        Row-X (SX)    None                   741 Not Blocking
           021
       288 ULVE1M2021   CLIENT          Row-X (SX)    None                   125 Not Blocking
       288 ULVE1M2021   PRODUIT         Row-X (SX)    None                   125 Not Blocking

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       288 ULVE1M2021   COMMANDE        Row-X (SX)    None                   125 Not Blocking
        82 GALLIPR2021  COMMANDE        Row-X (SX)    None                    27 Not Blocking

7 rows selected.


-- Validation sur la Base1 uniquement
commit ;


-------------------------------------------------------------------------------------------------
-- Activité 5 : Consultaions et mises à jour distribuées : requêtes impliquant 
-- plusieurs bases de données(ici Base1 et Base2)
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- Activité 5.1 Effectuer des consultations distribuées : ici jointure ... sur la base 1
-------------------------------------------------------------------------------------------------

Select c.pcomm#, c.pid#, e.empno , c.PPRIXUNIT
from &DRUSER..commande@&DBLINKNAME2  c, 
&DRUSER..produit@&DBLINKNAME2 p, 
emp e
where c.pid#=p.pid# and c.empno=e.Empno;

old   2: from &DRUSER..commande@&DBLINKNAME2  c,
new   2: from ULVE1M2021.commande@pdbm1inf  c,
old   3: &DRUSER..produit@&DBLINKNAME2 p,
new   3: ULVE1M2021.produit@pdbm1inf p,

    PCOMM#       PID#      EMPNO  PPRIXUNIT
---------- ---------- ---------- ----------
         1       1000       7369          2
         2       1000       7369          2
         3       1000       7369          2
         4       1000       7369          2


-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- Résultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   CHAPOULIE1M2 _SYSSMU3_3057867331$   000000007A28CDD8 ACTIVE  05/10/21 10:00:10     146829084          2
           021
PDBL3MIA   BOUSTATI1M20 _SYSSMU7_2682504410$   000000007A28D9C8 ACTIVE  05/10/21 10:06:48     146832564          1
           21
PDBL3MIA   BEYOSMAN1M20 _SYSSMU11_2843521970$  000000007A1B9488 ACTIVE  05/10/21 10:12:12     146833770          1
           21
PDBL3MIA   BENABDELJELI _SYSSMU5_1473839336$   000000007A1C2FB8 ACTIVE  05/10/21 10:11:51     146833717          1
           L1M2021
PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   ULVE1M2021   _SYSSMU6_3381045840$   000000007A1E2840 ACTIVE  05/10/21 10:15:24     146834565          1
PDBL3MIA   FERRARINI1M2 _SYSSMU1_4270700177$   000000007A2B9150 ACTIVE  05/10/21 10:09:29     146833389          1
           021

6 rows selected.


-- Résultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1INF   CHAPOULIE1M2 _SYSSMU3_3057867331$   000000007A24B8F8 ACTIVE  05/10/21 10:00:10     146829089          1
           021
PDBM1INF   BENABDELJELI _SYSSMU10_4201072483$  000000007A271CF0 ACTIVE  05/10/21 10:11:51     146834463          1
           L1M2021
PDBM1INF   BEYOSMAN1M20 _SYSSMU8_563287346$    000000007A1DBCD0 ACTIVE  05/10/21 10:12:12     146833787          0
           21


-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;
-- Résultat sur la Base1

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        68 GALLIPR2021  EMP             Row-X (SX)    None                   160 Not Blocking

-- Résultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        42 GALLIPR2021  CLIENT          Row-X (SX)    None                   164 Not Blocking
        42 GALLIPR2021  PRODUIT         Row-X (SX)    None                   164 Not Blocking
        42 GALLIPR2021  COMMANDE        Row-X (SX)    None                   164 Not Blocking

-- Validation sur la Base1 uniquement
commit ;



-------------------------------------------------------------------------------------------------
-- Activité 5.2 Effectuer des mises à distribuées sur la Base1
-------------------------------------------------------------------------------------------------

-- Sur la Base1 : Insérer une nouvelle commande pour l'employé 7369 
-- Sur la Base1 : Augmenter la commission de l'employé 7369 de 2 Euros.
-- Vérifier les informations sur la transactions
-- Vérifier les informations sur les verrous
-- Effectuer un Commit: Ce commit sera un commit à deux phase
set serveroutput on
BEGIN
insert into &DRUSER..commande@&DBLINKNAME2 (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(6, sysdate, 1000,1, 9, 2, 7369);

update emp
set comm= nvl(comm, 0) + 2 
WHERE EMPNO=7369;
END ;
/

-------------------------------------------------------------------------------------------------
-- Activité 5.3 : Consultation des informations sur la transaction sur les Base1 et Base2
-------------------------------------------------------------------------------------------------

col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- Résultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   ULVE1M2021   _SYSSMU1_4270700177$   000000007A1B8898 ACTIVE  05/16/21 20:09:20     149597544          2

-- Résultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1INF   BOUCHE1M2021 _SYSSMU2_3035727479$   000000007A26C960 ACTIVE  05/16/21 20:09:20     149597549          1


-------------------------------------------------------------------------------------------------
-- Activité 5.4 : Consultation des informations sur les verrous DML sur les Base1 et Base2
-------------------------------------------------------------------------------------------------

set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;

-- Résultat sur la Base1

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        61 ULVE1M2021   EMP             Row-X (SX)    None                   299 Not Blocking

-- Résultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       310 ULVE1M2021   CLIENT          Row-X (SX)    None                   301 Not Blocking
       310 ULVE1M2021   PRODUIT         Row-X (SX)    None                   301 Not Blocking
       310 ULVE1M2021   COMMANDE        Row-X (SX)    None                   301 Not Blocking

-- Validation sur la Base1 uniquement
commit ;-- commit à 2 phases

-------------------------------------------------------------------------------------------------
-- Activité 6: Transparence vis à vis de la localisation via les synonymes
-- Rendre transparent l’accès aux données distantes grâce au synonymes, 
-- Règle 4 de Chris DATE
-------------------------------------------------------------------------------------------------

drop public synonym commande;
Create public synonym commande for &DRUSER..commande@&DBLINKNAME2;


BEGIN
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(7, sysdate, 1000,1, 9, 2, 7369);

update emp
set comm= nvl(comm, 0) + 2 
WHERE EMPNO=7369;

commit ;
END ;
/
-- vérification sur Base1
select * from commande;

    PCOMM# CDATE           PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- --------- ---------- ---------- ---------- ---------- ----------
         1 16-MAY-21       1000          1          4          2       7369
         2 16-MAY-21       1000          1         10          2       7369
         3 16-MAY-21       1000          1          9          2       7369
         4 16-MAY-21       1000          1          9          2       7369
         6 16-MAY-21       1000          1          9          2       7369
         7 16-MAY-21       1000          1          9          2       7369

6 rows selected.

-- vérification sur Base1
select * from emp where empno=7369;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 17-DEC-80        800          4         20


-------------------------------------------------------------------------------------------------
-- Activité 7 .	Créer un database link public pour permettre à l’utilisateur &DRUSER 
-- depuis la Base2 de manipuler des objets à distance sur la Base1

-- Dans le cadre de cet exercice, le Database Link est déjà créé par l'adminitrateur
-- Il est contenu dans la variable : DBLINKNAME1 (voir sa valeur plus haut)
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activité 8.	sur la Base2 créer un trigger sur la table COMMANDE qui met à jour la 
-- commission de l'employé (qui gère la commande) à 2 EUROS à chaque fois qu’une 
-- commande est insérée ou supprimée. 
-------------------------------------------------------------------------------------------------

-- Se connecter sur la Base2
connect &DRUSER/&DRUSERPASS@&ALIASDB2


CREATE OR REPLACE TRIGGER update_employe_comm
	AFTER DELETE OR INSERT ON commande FOR EACH ROW
	DECLARE 

BEGIN
	IF INSERTING THEN
		UPDATE &DRUSER..emp@&DBLINKNAME1 e 
SET e.comm = nvl(e.comm, 0) + 2 
WHERE empno= :new.empno;
	END IF;

	IF DELETING THEN
		UPDATE &DRUSER..emp@&DBLINKNAME1 e 
SET e.comm = decode(e.comm, null, 0, e.comm - 2)
WHERE empno= :old.empno;
	END IF;

END;
/


-------------------------------------------------------------------------------------------------
-- Activité 9.	sur la Base1 vérifier le fonctionnement du trigger
-------------------------------------------------------------------------------------------------

Connect &DRUSER@&ALIASDB1/&DRUSERPASS
-- vérification du fonctionnement du trigrer sur la Base1
select * from commande;

    PCOMM# CDATE           PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- --------- ---------- ---------- ---------- ---------- ----------
         1 16-MAY-21       1000          1          4          2       7369
         2 16-MAY-21       1000          1         10          2       7369
         3 16-MAY-21       1000          1          9          2       7369
         4 16-MAY-21       1000          1          9          2       7369
         6 16-MAY-21       1000          1          9          2       7369
         7 16-MAY-21       1000          1          9          2       7369

6 rows selected.

select * from emp where empno=7369;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 17-DEC-80        800          4         20

BEGIN
insert into commande (pcomm#, cdate,pid#,  cid#, pnbre, pprixunit, empno) 
values(8, sysdate, 1000,1, 9, 2, 7369);


END ;
/

-- vérification du fonctionnement du trigrer sur Base1
select * from commande;

    PCOMM# CDATE           PID#       CID#      PNBRE  PPRIXUNIT      EMPNO
---------- --------- ---------- ---------- ---------- ---------- ----------
         1 16-MAY-21       1000          1          4          2       7369
         2 16-MAY-21       1000          1         10          2       7369
         3 16-MAY-21       1000          1          9          2       7369
         4 16-MAY-21       1000          1          9          2       7369
         6 16-MAY-21       1000          1          9          2       7369
         7 16-MAY-21       1000          1          9          2       7369
         8 16-MAY-21       1000          1          9          2       7369

7 rows selected.

select * from emp where empno=7369;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7369 SMITH      CLERK           7902 17-DEC-80        800          6         20


-- Consultation des informations sur la transaction sur la Base1 et la Base2
col pdb_name format a10
col username format a12
col segment_name format a22
col status format A7

select ps.pdb_name, 
vs.username, 
rs.segment_name, 
vt.addr "Id trans", 
vt.status, 
vt.start_time,
vt.START_SCNB "START SCN",
vt.USED_UBLK "Block RBS"
from v$transaction vt, v$session vs, dba_rollback_segs rs, dba_pdbs ps
where vt.SES_ADDR=vs.saddr
and vt.con_id=ps.con_id
and vt.XIDUSN=rs.segment_id;

-- Résultat sur la Base1

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBL3MIA   ULVE1M2021   _SYSSMU3_3057867331$   000000007A28F1A8 ACTIVE  05/16/21 20:23:11     149601985          2

-- Résultat sur la Base2

PDB_NAME   USERNAME     SEGMENT_NAME           Id trans         STATUS  START_TIME            START SCN  Block RBS
---------- ------------ ---------------------- ---------------- ------- -------------------- ---------- ----------
PDBM1INF   BOUCHE1M2021 _SYSSMU9_513303587$    000000007A2014D8 ACTIVE  05/16/21 20:23:11     149601993          1

-- Consultation des informations sur les verrous DML sur la Base1 et la Base2
set linesize 200
col OWNER format a12
col NAME  format a15
col BLOCKING_OTHERS format a15

select 
SESSION_ID,
OWNER, 
NAME,
MODE_HELD,
MODE_REQUESTED,
LAST_CONVERT,
BLOCKING_OTHERS
from dba_dml_locks;
-- Résultat sur la Base1

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
       280 ULVE1M2021   EMP             Row-X (SX)    None                    55 Not Blocking

-- Résultat sur la Base2

SESSION_ID OWNER        NAME            MODE_HELD     MODE_REQUESTE LAST_CONVERT BLOCKING_OTHERS
---------- ------------ --------------- ------------- ------------- ------------ ---------------
        61 ULVE1M2021   CLIENT          Row-X (SX)    None                    58 Not Blocking
        61 ULVE1M2021   PRODUIT         Row-X (SX)    None                    58 Not Blocking
        61 ULVE1M2021   COMMANDE        Row-X (SX)    None                    58 Not Blocking


-- Validation sur la Base1 uniquement
commit ;

-------------------------------------------------------------------------------------------------
-- Activité 10 : Simulation de pannes d'une transaction distribuées

-- En cas de COMMIT distribué, il est extrêmement compliqué pour mettre en évidence des 
-- pannes.
-- Il ne reste plus que la simulation.
-- On utilise pour cela l'ordre SQL :
-- COMMIT COMMENT 'ORA-2PC-CRASH-TEST-N (N étant un des 10 numéros de pannes)
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- Activité 10.1 : Comprendre la Liste des Numéros de Pannes
-- 1	panne d'un site en transaction (commit point site) après collecte 
-- 2	panne d'un site non en transaction après collecte 
-- 3	panne avant la phase de préparation
-- 4	panne après la phase de préparation
-- 5	panne du commit point site avant la phase de validation 
-- 6	panne d'un site en transaction après le Commit
-- 7	panne d'un site non en transaction avant le Commit*
-- 8	panne d'un site non en transaction après la phase de validation
-- 9	panne d'un site en transaction après la phase ignorer
-- 10	panne d'un site non en transaction avant la phase ignorer
-------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------
-- Activité 10.2 :informations sur les transactions distribuées 
--               Comprendre le rôle des vues DBA_2PC_PENDING et DBA_2PC_NEIGHBORS
-- Deux vues Oracle contiennent les informations sur les transactions distribuées
-- DBA_2PC_PENDING :
-- 	. Cette vue décrit les informations sur les transactions distribuées en attente 
--    de recouvrement suite à une panne.
-- DBA_2PC_NEIGHBORS
--  . Cette vue décrit les informations sur les connexions entrantes ou sortantes  des 
--    transactions distribuées douteuses.
-------------------------------------------------------------------------------------------------


-- Se connecter sur la Base1 si ce n'est déjà fait
Connect &DRUSER@&ALIASDB1/&DRUSERPASS


-- DBA_2PC_PENDING :
-- 	. Cette vue décrit les informations sur les transactions distribuées en attente 
--    de recouvrement suite à une panne.

desc DBA_2PC_PENDING


Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 LOCAL_TRAN_ID                             NOT NULL VARCHAR2(22)
 GLOBAL_TRAN_ID                                     VARCHAR2(169)
 STATE                                     NOT NULL VARCHAR2(16)
 MIXED                                              VARCHAR2(3)
 ADVICE                                             VARCHAR2(1)
 TRAN_COMMENT                                       VARCHAR2(255)
 FAIL_TIME                                 NOT NULL DATE
 FORCE_TIME                                         DATE
 RETRY_TIME                                NOT NULL DATE
 OS_USER                                            VARCHAR2(64)
 OS_TERMINAL                                        VARCHAR2(255)
 HOST                                               VARCHAR2(128)
 DB_USER                                            VARCHAR2(128)
 COMMIT#                                            VARCHAR2(16)


-- DBA_2PC_NEIGHBORS
--  . Cette vue décrit les informations sur les connexions entrantes ou sortantes  des 
--    transactions distribuées douteuses.

-- noeud impliqué dans des transactions douteuses
desc DBA_2PC_NEIGHBORS

Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 LOCAL_TRAN_ID                                      VARCHAR2(22)
 IN_OUT                                             VARCHAR2(3)
 DATABASE                                           VARCHAR2(128)
 DBUSER_OWNER                                       VARCHAR2(128)
 INTERFACE                                          VARCHAR2(1)
 DBID                                               VARCHAR2(16)
 SESS#                                              NUMBER(38)
 BRANCH                                             VARCHAR2(128)

-------------------------------------------------------------------------------------------------
-- Activité 10.3 : Consultation des informations sur les transactions douteuses
-- sur les Base1 et Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Activité 10.3.1 : simulation de panne en cas de transaction distribuées
-- Simulation de la panne 6 sur la Base1 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

-- Se connecter sur la Base1 si ce n'est déjà fait
CONNECT &DRUSER@&ALIASDB1/&DRUSERPASS


select empno, ename, sal from emp where empno=7369;
col pdescription format a40

     EMPNO ENAME             SAL
---------- ---------- ----------
      7369 SMITH             800
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

old   1: select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
new   1: select pid#, pdescription from ULVE1M2021.produit@pdbm1inf

      PID# PDESCRIPTION
---------- ----------------------------------------
      1000 Coca cola 2 litres avec caf?in

update emp 
set sal=sal*1.1
where empno=7369;

update &DRUSER..produit@&DBLINKNAME2
set pdescription =pdescription||'BravoBravo'
where PID#=1000;

COMMIT COMMENT 'ORA-2PC-CRASH-TEST-6';

-- Mettre le résultat de l'exécution ici

ERROR at line 1:
ORA-02054: transaction 8.28.17838 in-doubt
ORA-02053: transaction 3.7.13858 committed, some remote DBs may be in-doubt
ORA-02059: ORA-2PC-CRASH-TEST-6 in commit comment
ORA-02063: preceding 2 lines from PDBM1INF


select empno, ename, sal from emp where empno=7369;

     EMPNO ENAME             SAL
---------- ---------- ----------
      7369 SMITH             880
 

select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

      PID# PDESCRIPTION
---------- ----------------------------------------
      1000 Coca cola 2 litres avec caf?inBravoBravo


-------------------------------------------------------------------------------------------------
-- Activité 10.3.2 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base1 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


-- Que constatez vous ?

no rows selected

-------------------------------------------------------------------------------------------------
-- Activité 10.3.3 : Consultation des informations sur les noeuds impliqués dans des 
-- transactions douteuses sur la Base1 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/


no rows selected

-------------------------------------------------------------------------------------------------
-- Activité 10.3.4 : Consultation des informations sur les transactions douteuses
-- sur la Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- Activité 10.3.4.1 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


-- Que constatez vous ?

no rows selected

-------------------------------------------------------------------------------------------------
-- Activité 10.3.4.2 : Consultation des informations sur les noeuds impliqués dans des 
-- transactions douteuses sur la Base2 SANS DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/
?
-- Que constatez vous ?

no rows selected

----------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-- Activité 10.4 : Consultation des informations sur les transactions douteuses
-- sur les Base1 et Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

-- Activité 10.4.0 : DESACTIVATION DU RECOUVREMENT DISTRIBUE PAR L'ADMINISTRATEUR (ENSEIGNANT)
sqlplus /nolog
connect system@AliasRootDB/passwordCompteSystem
ALTER SYSTEM DISABLE DISTRIBUTED RECOVERY;

-- Activité 10.4.1 : simulation de panne en cas de transaction distribuées
-- Simulation de la panne 6 sur la Base1 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6

-- Se connecter sur la Base1 si ce n'est déjà fait
CONNECT &DRUSER@&ALIASDB1/&DRUSERPASS


select empno, ename, sal from emp where empno=7369;
col pdescription format a40

     EMPNO ENAME             SAL
---------- ---------- ----------
      7369 SMITH             880
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

old   1: select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
new   1: select pid#, pdescription from ULVE1M2021.produit@pdbm1inf

      PID# PDESCRIPTION
---------- ----------------------------------------
      1000 Coca cola 2 litres avec caf?inBravoBravo

update emp 
set sal=sal*1.1
where empno=7369;

update &DRUSER..produit@&DBLINKNAME2
set pdescription =pdescription||'BravoBravo'
where PID#=1000;

COMMIT COMMENT 'ORA-2PC-CRASH-TEST-6';

-- Mettre le résultat de l'exécution ici

ERROR at line 1:
ORA-02054: transaction 5.11.17495 in-doubt
ORA-02053: transaction 9.30.13984 committed, some remote DBs may be in-doubt
ORA-02059: ORA-2PC-CRASH-TEST-6 in commit comment
ORA-02063: preceding 2 lines from PDBM1INF



select empno, ename, sal from emp where empno=7369;

ERROR at line 1:
ORA-01591: lock held by in-doubt distributed transaction 5.11.17495
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

old   1: select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
new   1: select pid#, pdescription from ULVE1M2021.produit@pdbm1inf

      PID# PDESCRIPTION
---------- ----------------------------------------
      1000 Coca cola 2 litres avec caf?inBravoBravo
           BravoBravo

-------------------------------------------------------------------------------------------------
-- Activité 10.4.2 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base1 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


-- Que constatez vous ?

no rows selected

-------------------------------------------------------------------------------------------------
-- Activité 10.4.3 : Consultation des informations sur les noeuds impliqués dans des 
-- transactions douteuses sur la Base1 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/

no rows selected


-------------------------------------------------------------------------------------------------
-- Activité 10.4.4 : Consultation des informations sur les transactions douteuses
-- sur la Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
-------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
-- Activité 10.4.4.1 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------


set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


-- Que constatez vous ?

no rows selected

------------------------------------------------------------------------------------------------
-- Activité 10.4.4.2 : Consultation des informations sur les noeuds impliqués dans des 
-- transactions douteuses sur la Base2 AVEC DESACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/

-- Que constatez vous ?

no rows selected


------------------------------------------------------------------------------------------------
-- Activité 10.5 : Consultation des informations sur les transactions douteuses
-- sur les Base1 et Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Activité 10.5.0 : REACTIVATION DU RECOUVREMENT DISTRIBUE PAR L'ADMINISTRATEUR (ENSEIGNANT)
------------------------------------------------------------------------------------------------

connect system@AliasRootDB/passwordCompteSystem

-- activer deux fois !!!
ALTER SYSTEM ENABLE DISTRIBUTED RECOVERY;
ALTER SYSTEM ENABLE DISTRIBUTED RECOVERY;
------------------------------------------------------------------------------------------------
-- Activité 10.5.1 : Consultation des données modifiées en cas de transaction distribuées
-- et de Simulation de la panne 6 sur la Base1 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE
------------------------------------------------------------------------------------------------

-- Se connecter sur la Base1 si ce n'est déjà fait
CONNECT &DRUSER@&ALIASDB1/&DRUSERPASS


select empno, ename, sal from emp where empno=7369;
col pdescription format a40

     EMPNO ENAME             SAL
---------- ---------- ----------
      7369 SMITH             968
 
select pid#, pdescription from &DRUSER..produit@&DBLINKNAME2
where pid#=1000;

      PID# PDESCRIPTION
---------- ----------------------------------------
      1000 Coca cola 2 litres avec caf?inBravoBravo
           BravoBravo



------------------------------------------------------------------------------------------------
-- Activité 10.5.2 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base1 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


?
-- Que constatez vous ?

------------------------------------------------------------------------------------------------
-- Activité 10.5.3 : Consultation des informations sur les noeuds impliqués dans des 
-- transactions douteuses sur la Base1 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/



------------------------------------------------------------------------------------------------
-- Activité 10.5.4 : Consultation des informations sur les transactions douteuses
-- sur la Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Activité 10.5.4.1 : Consultation des informations sur les transactions en attente 
-- de recouvrement sur la Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

set linesize 200
col GLOBAL_TRAN_ID format a12
col LOCAL_TRAN_ID format a12
col STATE format a10
col TRAN_COMMENT format a30
col OS_USER format a10
col OS_TERMINAL format a15
col HOST format a15
col DB_USER format a15
col COMMIT# format a10

select GLOBAL_TRAN_ID,
LOCAL_TRAN_ID, 
state ,
ADVICE,
TRAN_COMMENT,
FAIL_TIME,
FORCE_TIME,
RETRY_TIME,
OS_USER,
OS_TERMINAL,
HOST,
DB_USER,
COMMIT#  
from DBA_2PC_PENDING;


?
-- Que constatez vous ?

------------------------------------------------------------------------------------------------
-- Activité 10.5.4.2 : Consultation des informations sur les noeuds impliqués dans des 
-- transactions douteuses sur la Base2 AVEC REACTIVATION DU RECOUVREMENT DISTRIBUE, PANNE 6
------------------------------------------------------------------------------------------------

COL LOCAL_TRAN_ID FORMAT A13
COL IN_OUT FORMAT A6
COL DATABASE FORMAT A25
COL DBUSER_OWNER FORMAT A15
COL INTERFACE FORMAT A3
col SESS# format 999999
col BRANCH format A15
SELECT LOCAL_TRAN_ID, IN_OUT, DATABASE, DBUSER_OWNER, INTERFACE, SESS#, BRANCH
   FROM DBA_2PC_NEIGHBORS
/
?
-- Que constatez vous ?




------------------------------------------------------------------------------------------------
-- Activité 11 : REPRENDRE LES ACTIVITES 10. avec une autre panne par exemple : PANNE 3
------------------------------------------------------------------------------------------------
