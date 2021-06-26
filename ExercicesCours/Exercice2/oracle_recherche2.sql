--Oracle: 

-- Pour rechercher une vue (index, contraintes...):

-- Vue table:
-- voir tout
select * 
from META_TABLES;


-- Vue colonnes:
-- voir tout
select *
from META_COLUMNS;

--voir pour chaque table
select *
from META_COLUMNS
where nomTable='VOL';

select *
from META_COLUMNS
where nomTable='PILOTE';

select *
from META_COLUMNS
where nomTable='AVION';


-- Vue index:
-- voir tout
select * 
from META_INDEX;

-- voir pour chaque table
select * 
from META_INDEX
where nomTable='VOL';

select * 
from META_INDEX
where nomTable='PILOTE';

select * 
from META_INDEX
where nomTable='AVION';


-- Vue contraintes: 
--voir tout
select * 
from META_CONSTRAINTS;

--voir pour chaque table
select *
from META_CONSTRAINTS
where nomTable = 'VOL';

select *
from META_CONSTRAINTS
where nomTable = 'PILOTE';

select *
from META_COSTRAINTS
where nomTable = 'AVION';


--Autre méthode pour tout afficher:

/*table user_cons_columns: table_name, constraint_name, column_name
table user_constraints : table_name, constraint_name, contraint_type, search_condition
table user_tab_columns: table_name, column_name, data_type, column_id
table user_ind_columns : table_name, column_name, index_name, column_position*/

select utcl.table_name, utcl.column_name, utcl.column_id, utcl.data_type, uic.index_name, utcc.constraint_name, uc.constraint_type, uc.search_condition
from user_tab_columns utcl
left join user_ind_columns uic on utcl.column_name = uic.column_name and utcl.table_name = uic.table_name --recup le index_name
left join user_cons_columns utcc on utcl.column_name = utcc.column_name and utcl.table_name = utcc.table_name --fait le lien entre la tab_columns et la user_cosntraints car pas de column_name dans user_constraintds
inner join user_constraints uc on utcc.constraint_name = uc.constraint_name;

--https://sql.sh/cours/jointures/inner-join
--left car je veux que ça me récupère toutes les colonnes même si elles n'ont pas d'index ou de contraintes (cf schéma des ensembles, ensA = table1 et ensB = table 2)








