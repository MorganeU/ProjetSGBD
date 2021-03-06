DROP TABLE META_CONSTRAINTS;
DROP TABLE META_INDEX;
DROP TABLE META_COLUMNS;
DROP TABLE META_TABLES;

CREATE TABLE META_TABLES(
        idTable NUMBER CONSTRAINT NOTNULL_IDTABLE NOT NULL,
        nomTable VARCHAR (50) CONSTRAINT NOTNULL_NOMTABLE NOT NULL,
        proprietaire VARCHAR (50) CONSTRAINT NOTNULL_PROPRIETAIRE NOT NULL,
	CONSTRAINT META_TABLES_PK PRIMARY KEY (idTable), 
   CONSTRAINT CHK_NOMTABLE CHECK (REGEXP_LIKE(nomTable,'^[A-Za-z]')),
    CONSTRAINT UNIQUE_PROPRIETAIRE_NOMTABLE UNIQUE (nomTable, proprietaire)
    );


CREATE TABLE META_COLUMNS(
        idColonne      NUMBER CONSTRAINT NOTNULL_idCOLONNE NOT NULL,
        nomColonne     VARCHAR (50) CONSTRAINT NOTNULL_NOMCOLONNE NOT NULL,
        libelleColonne VARCHAR (50) CONSTRAINT NOTNULL_LIBELLECOLONNE NOT NULL,
        typeColonne    VARCHAR (50) CONSTRAINT NOTNULL_TYPECOLONNE NOT NULL,
        tailleColonne  NUMBER CONSTRAINT NOTNULL_TAILLECOLONNE NOT NULL,
        idTable        NUMBER CONSTRAINT NOTNULL_IDTABLE_COLUMN NOT NULL,
	CONSTRAINT META_COLUMNS_PK PRIMARY KEY (idColonne),
    CONSTRAINT META_TABLES_COLUMNS_FK FOREIGN KEY (idTable) REFERENCES META_TABLES (idTable), 
    CONSTRAINT CHK_NOMCOLONNE CHECK (REGEXP_LIKE(nomColonne,'^[A-Za-z]'))
);

CREATE TABLE META_INDEX(
        idIndex   NUMBER CONSTRAINT NOTNULL_idIndex NOT NULL,
        nomIndex  VARCHAR (50) CONSTRAINT NOTNULL_NOMINDEX NOT NULL,
        typeIndex VARCHAR (50)  CONSTRAINT NOTNULL_TYPEINDEX NOT NULL,
        idTable   NUMBER CONSTRAINT NOTNULL_IDTABLE_INDEX NOT NULL,
	CONSTRAINT META_INDEX_PK PRIMARY KEY (idIndex),
    CONSTRAINT META_TABLES_INDEX_FK FOREIGN KEY (idTable) REFERENCES META_TABLES(idTable), 
    CONSTRAINT UNIQUE_NOMINDEX_IDTABLE UNIQUE (nomIndex, idTable), 
    CONSTRAINT CHK_TYPEINDEX_HASH_BTREE CHECK (typeIndex IN ('HASH','BTREE')) //à enlever car ne marche pas
);

CREATE TABLE META_CONSTRAINTS(
        idContrainte     NUMBER CONSTRAINT NOTNULL_IDCONTRAINTE NOT NULL,
        typeContrainte   VARCHAR (50) CONSTRAINT NOTNULL_TYPECONTRAINTE NOT NULL,
        nomContrainte    VARCHAR (50) CONSTRAINT NOTNULL_NOMCONTRAINTE NOT NULL,
        valeurContrainte VARCHAR (50) CONSTRAINT NOTNULL_VALEURCONTRAINTE NOT NULL,
        statusContrainte VARCHAR (50)  CONSTRAINT NOTNULL_STATUSCONTRAINTE NOT NULL,
        idTable          NUMBER CONSTRAINT NOTNULL_iDTABLE_CONSTRAINT NOT NULL,
        idColonne        NUMBER CONSTRAINT NOTNULL_IDCOLONNE_CONSTRAINT NOT NULL,
	CONSTRAINT META_CONSTRAINTS_PK PRIMARY KEY (idContrainte),
    CONSTRAINT META_TABLES_CONSTRAINTS_FK FOREIGN KEY (idTable) REFERENCES META_TABLES(idTable),
    CONSTRAINT META_COLUMNS_CONSTRAINTS_FK FOREIGN KEY (idColonne) REFERENCES META_COLUMNS(idColonne),
    CONSTRAINT UNIQUE_NOMCONTRAINTE_IDTABLE UNIQUE (nomContrainte, idTable),
    CONSTRAINT CHK_TYPECONTRAINTE CHECK (typeContrainte IN ('P','C','U','R'))
);

CREATE SEQUENCE Seq_META_TABLES_idTable START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_META_COLUMNS_idColonne START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_META_INDEX_idIndex START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_META_CONSTRAINTS_idContrainte START WITH 1 INCREMENT BY 1 NOCYCLE;


CREATE OR REPLACE TRIGGER META_TABLES_idTable
	BEFORE INSERT ON META_TABLES 
  FOR EACH ROW 
	WHEN (NEW.idTable IS NULL) 
	BEGIN
		 select Seq_META_TABLES_idTable.NEXTVAL INTO :NEW.idTable from DUAL; 
	END;
CREATE OR REPLACE TRIGGER META_COLUMNS_idColonne
	BEFORE INSERT ON META_COLUMNS 
  FOR EACH ROW 
	WHEN (NEW.idColonne IS NULL) 
	BEGIN
		 select Seq_META_COLUMNS_idColonne.NEXTVAL INTO :NEW.idColonne from DUAL; 
	END;
CREATE OR REPLACE TRIGGER META_INDEX_idIndex
	BEFORE INSERT ON META_INDEX 
  FOR EACH ROW 
	WHEN (NEW.idIndex IS NULL) 
	BEGIN
		 select Seq_META_INDEX_idIndex.NEXTVAL INTO :NEW.idIndex from DUAL; 
	END;
CREATE OR REPLACE TRIGGER META_CONSTRAINTS_idContrainte
	BEFORE INSERT ON META_CONSTRAINTS 
  FOR EACH ROW 
	WHEN (NEW.idContrainte IS NULL) 
	BEGIN
		 select Seq_META_CONSTRAINTS_idContrainte.NEXTVAL INTO :NEW.idContrainte from DUAL; 
	END;