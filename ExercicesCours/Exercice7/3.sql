--T3 :
UPDATE pilote SET plnom='Conficies' WHERE plnom='Conficias';
select * from pilote where pl#=25;
SAVEPOINT updt_conf1;
UPDATE pilote SET
plnom='Conficius' WHERE plnom='Conficies';
SAVEPOINT updt_conf2 ;
select * from pilote where pl#=25;
UPDATE pilote SET plnom='Conficios' WHERE plnom='Conficius';
select * from pilote where pl#=25;
ROLLBACK TO updt_conf1 ;
select * from pilote where pl#=25;
UPDATE pilote SET plnom='Conficius' WHERE plnom='Conficies';
select * from pilote where pl#=25;
UPDATE pilote SET sal=40000.0 WHERE plnom='Conficius';
select * from pilote where pl#=25;
COMMIT ;
select * from pilote where pl#=25;