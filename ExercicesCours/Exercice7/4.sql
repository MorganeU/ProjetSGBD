--Exo7_T2

SET TRANSACTION READ WRITE;
UPDATE PILOTE SET sal=sal+2 where pl#=1;
COMMIT;
SELECT * FROM PILOTE WHERE pl#=1;

