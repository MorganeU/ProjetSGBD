#Fichiers de controle
SHOW PARAMETER CONTROL_FILES;

#NAME          TYPE   VALUE                                                                                                
#------------- ------ ---------------------------------------------------------------------------------------------------- 
#control_files string /u02/app/oracle/oradata/BDMBDS/control01.ctl, /u03/app/oracle/fast_recovery_area/BDMBDS/control02.ct 

#Fichiers de donnees
select 
    FILE_ID, 
    FILE_NAME, 
    STATUS, 
    TABLESPACE_NAME 
from 
    DBA_DATA_FILES 
order by FILE_ID; 

/*FILE_ID FILE_NAME											STATUS		TABLESPACE_NAME
26	  /u01/app/oradata/BDMBDS/pdbm1inf/datafile/pdbm1inf_system01.dbf				AVAILABLE	SYSTEM
27	  /u01/app/oradata/BDMBDS/pdbm1inf/datafile/pdbm1inf_sysaux01.dbf				AVAILABLE	SYSAUX
28	  /u01/app/oradata/BDMBDS/pdbm1inf/datafile/pdbm1inf_undotbs01.dbf				AVAILABLE	UNDOTBS1
29	  /u01/app/oradata/BDMBDS/pdbm1inf/datafile/pdbm1inf_users01.dbf				AVAILABLE	USERS
170	  /u04/app/oracle/oradata/BDMBDS/pdbm1inf/users_pdbm1inf_02.dbf					AVAILABLE	USERS
171	  /u04/app/oracle/oradata/BDMBDS/pdbm1inf/sysaux_pdbm1inf_02.dbf				AVAILABLE	SYSAUX
190	  /u01/app/oracle/product/18.0.0/dbhome_1/dbs/%ORACLE_BASE%oradataorcltsobjts_table_res_1.dbf	AVAILABLE	TS_TABLE_RES
191	  /u01/app/oracle/product/18.0.0/dbhome_1/dbs/%ORACLE_BASE%oradataorcltsobjts_index_res_1.dbf	AVAILABLE	TS_INDEX_RES
192	  /u01/app/oracle/product/18.0.0/dbhome_1/dbs/%ORACLE_BASE%oradataorcltsobjts_lob_res_1.dbf	AVAILABLE	TS_LOB_RES*/

#Fichiers de redolog
SELECT * FROM v$logfile;

/*GROUP#	STATUS	TYPE	MEMBER				IS_RECOVERY_DEST_FILE	CON_ID
3	(null)	ONLINE	/u04/app/oracle/redo/redo03.log	NO			0
2	(null)	ONLINE	/u04/app/oracle/redo/redo02.log	NO			0
1	(null)	ONLINE	/u04/app/oracle/redo/redo01.log	NO			0
1	(null)	ONLINE	/u04/app/oracle/redo/redo11.log	NO			0
2	(null)	ONLINE	/u04/app/oracle/redo/redo12.log	NO			0
3	(null)	ONLINE	/u04/app/oracle/redo/redo13.log	NO			0
4	(null)	ONLINE	/u04/app/oracle/redo/redo04.log	NO			0
4	(null)	ONLINE	/u04/app/oracle/redo/redo14.log	NO			0*/