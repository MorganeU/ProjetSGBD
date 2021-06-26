-- T2 :
UPDATE pilote SET plnom='Conficios' WHERE plnom='Conficias';
select * from pilote where pl#=25;
ROLLBACK ;
select * from pilote where pl#=25;