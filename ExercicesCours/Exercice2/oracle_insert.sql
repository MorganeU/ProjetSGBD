SET SERVEROUTPUT ON

DECLARE BEGIN
    FOR get_tabl_list IN (
        SELECT
            *
        FROM
            user_tables
        WHERE
            table_name = 'AVION'
            OR table_name = 'VOL'
            OR table_name = 'PILOTE'
    ) LOOP
        INSERT INTO meta_tables (
            idtable,
            nomtable,
            proprietaire
        ) VALUES (
            NULL,
            get_tabl_list.table_name,
            (
                SELECT
                    user
                FROM
                    dual
            )
        );

    END LOOP;

    FOR get_col_list IN (
        SELECT
            user_tab_columns.*,
            meta_tables.idtable
        FROM
                 user_tab_columns
            INNER JOIN meta_tables ON meta_tables.nomtable = user_tab_columns.table_name
    ) LOOP
        INSERT INTO meta_columns (
            idcolonne,
            nomcolonne,
            libellecolonne,
            typecolonne,
            taillecolonne,
            idtable
        ) VALUES (
            NULL,
            get_col_list.column_name,
            '',
            get_col_list.data_type,
            get_col_list.data_length,
            get_col_list.idtable
        );

    END LOOP;

    FOR get_index_list IN (
        SELECT
            user_indexes.*,
            meta_tables.idtable
        FROM
                 user_indexes
            INNER JOIN meta_tables ON meta_tables.nomtable = user_indexes.table_name
    ) LOOP
        INSERT INTO meta_index (
            idindex,
            nomindex,
            typeindex,
            idtable
        ) VALUES (
            NULL,
            get_index_list.index_name,
            get_index_list.index_type,
            get_index_list.idtable
        );

    END LOOP;

    FOR get_cons_list IN (
        SELECT
            user_cons_columns.constraint_name,
            user_constraints.constraint_type,
            user_cons_columns.table_name,
            user_cons_columns.column_name,
            user_constraints.search_condition,
            user_constraints.status,
            join_t_c.idtable,
            join_t_c.idcolonne
        FROM
                 user_cons_columns
            INNER JOIN (
                SELECT
                    meta_tables.idtable,
                    meta_tables.nomtable,
                    meta_columns.idcolonne,
                    meta_columns.nomcolonne
                FROM
                         meta_tables
                    INNER JOIN meta_columns ON meta_tables.idtable = meta_columns.idtable
            ) join_t_c ON join_t_c.nomtable = user_cons_columns.table_name
                          AND join_t_c.nomcolonne = user_cons_columns.column_name
            INNER JOIN user_constraints ON user_cons_columns.constraint_name = user_constraints.constraint_name
    ) LOOP
        INSERT INTO meta_constraints (
            idcontrainte,
            typecontrainte,
            nomcontrainte,
            valeurcontrainte,
            statuscontrainte,
            idtable,
            idcolonne
        ) VALUES (
            NULL,
            get_cons_list.constraint_type,
            get_cons_list.constraint_name,
            get_cons_list.search_condition,
            get_cons_list.status,
            get_cons_list.idtable,
            get_cons_list.idcolonne
        );

    END LOOP;

END;