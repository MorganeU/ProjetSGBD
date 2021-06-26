--Oracle: 

-- Pour rechercher une vue (index, contraintes...):

-- Vue table:
-- voir tout
SELECT
    *
FROM
    meta_tables;

-- Vue colonnes:
-- voir tout
SELECT
    *
FROM
    meta_columns;


--voir pour chaque table
SELECT
    *
FROM
         meta_columns
    INNER JOIN meta_tables ON meta_tables.idtable = meta_columns.idtable
WHERE
    nomtable='VOL';
    
SELECT
    *
FROM
         meta_columns
    INNER JOIN meta_tables ON meta_tables.idtable = meta_columns.idtable
WHERE
    nomtable = 'PILOTE';

SELECT
    *
FROM
         meta_columns
    INNER JOIN meta_tables ON meta_tables.idtable = meta_columns.idtable
WHERE
    nomtable = 'AVION';


-- Vue index:
-- voir tout
SELECT
    *
FROM
    meta_index;

-- voir pour chaque table
SELECT
    *
FROM
         meta_index
    INNER JOIN meta_tables ON meta_tables.idtable = meta_index.idtable
WHERE
    nomtable = 'VOL';

SELECT
    *
FROM
         meta_index
    INNER JOIN meta_tables ON meta_tables.idtable = meta_index.idtable
WHERE
    nomtable = 'PILOTE';

SELECT
    *
FROM
         meta_index
    INNER JOIN meta_tables ON meta_tables.idtable = meta_index.idtable
WHERE
    nomtable = 'AVION';

-- Vue contraintes: 
--voir tout
SELECT
    *
FROM
    meta_constraints;


--voir pour chaque table
SELECT
    *
FROM
         meta_index
    INNER JOIN meta_tables ON meta_tables.idtable = meta_constraints.idtable
WHERE
    nomtable = 'VOL';

SELECT
    *
FROM
         meta_index
    INNER JOIN meta_tables ON meta_tables.idtable = meta_constraints.idtable
WHERE
    nomtable = 'PILOTE';

SELECT
    *
FROM
         meta_index
    INNER JOIN meta_tables ON meta_tables.idtable = meta_constraints.idtable
WHERE
    nomtable = 'AVION';


--Autre méthode pour tout afficher:

/*table user_cons_columns: table_name, constraint_name, column_name
table user_constraints : table_name, constraint_name, contraint_type, search_condition
table user_tab_columns: table_name, column_name, data_type, column_id
table user_ind_columns : table_name, column_name, index_name, column_position*/

SELECT
    meta_tables.idTable,
    meta_tables.nomtable,
    meta_columns.nomcolonne,
    meta_columns.idcolonne,
    meta_columns.typecolonne,
    meta_index.nomindex,
    meta_constraints.nomcontrainte,
    meta_constraints.typecontrainte,
    meta_constraints.valeurcontrainte
FROM
    meta_tables
    LEFT JOIN meta_columns ON meta_columns.idTable = meta_tables.idTable
    LEFT JOIN meta_index ON meta_index.idTable = meta_tables.idTable
    LEFT JOIN meta_constraints ON meta_constraints.idTable = meta_tables.idTable

--https://sql.sh/cours/jointures/inner-join
--left car je veux que ça me récupère toutes les colonnes même si elles n'ont pas d'index ou de contraintes (cf schéma des ensembles, ensA = table1 et ensB = table 2)