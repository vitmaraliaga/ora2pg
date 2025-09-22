# ORDEN DE MIGRACION
# 1. GENERAR EL ESQUELETO
    
# 1. PRIMER INTENTO: TABLAS, SECUENCIAS, VALOR-SECUENCIAS
    
# 2. 
- 1. genesis ::: Schema Ok
    SEQUENCE success (1th try)
    SEQUENCE_VALUES success (1th try)
    TABLE success (1th try)
    VIEW success (2th try)
    TRIGGER success (2th try)
    FUNCTION success (2th try)
    INDEXES success (2th try)
        INDEX success (2th try)
        CONSTRAINTS success (2th try)
        foreign success (2th try)
        TRIGGER success (2th try)
    GRANT success (2th try)
    TABLESPACE no migrar
    data success (1th try)
    <!-- indexes success (2th try)
    foreign success keys (2th try) -->
- 2. caleb ::: Schema Ok
    SEQUENCE success (1th try)
    SEQUENCE_VALUES success (1th try)
    TABLE success (1th try)
    FUNCTION success (2th try)
    VIEW no con errores de pivot
    <!-- PACKAGE no -->
    TRIGGER success (3th try)
    PROCEDURE success (3th try)
    <!-- MVIEW no
    DBLINK no -->
    <!-- DIRECTORY no -->
    indexes yes
        index  success (2th try)
        contraints success (2th try)
        foreignkey con error (2th try) // Esta pidiendo lucas
    GRANT no
    TABLESPACE no
    data success (1th try)
- 3. josue ::: no existe en dev
- 4. moises ::: Schema Ok
    SEQUENCE success (1th try)
    SEQUENCE_VALUES success (1th try)
    TABLE success (1th try)
    FUNCTION success (2th try)
    PACKAGE success (2th try)
    VIEW success (2th try)
    TRIGGER success (2th try)
    PROCEDURE success (2th try)
    <!-- MVIEW no -->
    DBLINK no
    <!-- DIRECTORY no -->
    indexes yes (2th try)
        indexes success (2th try)
        constraints success (2th try)
        foreignkey no : depende de enoc 
    GRANT no (no existe el rol «userupdate»)
    TABLESPACE no
    data success (1th try)
- 8. eliseo :: Schema Ok
    SEQUENCE success (1th try)
    SEQUENCE_VALUES success (1th try)
    TABLE success (1th try)
    FUNCTION success (2th try)
        - (Se exporto con errores) 
        - Se comentó varias lineas del archivo, mas que todo se esta corrgiendo.
        - function.sql
    PACKAGE success (2th try)
        - (Se exporto con errores) 
        - Se comentó varias lineas del archivo
        - package.sql
    VIEW no
        Depende de david
    TRIGGER success (2th try)
        - Se comentó lineas del archivo
        - trigger.sql
    PROCEDURE no
         (Se exporto con errores) 
        - Se comentó varias lineas del archivo, mas que todo se esta corrgiendo.
        - procedure.sql
    MVIEW no
        - Necesita de visitas
    DBLINK no
        - Por ahora no
    DIRECTORY no
        indexes success (2th try)
        contraints (En algun momento se migro, sale que ya esta migrado)
    foreignkey no
    TRIGGER no
    GRANT no
    TABLESPACE no
    data success (1th try)
    indexes success (1th try)
    constraints success (1th try)
    foreign no
    TRIGGER no
- 5. david :: Schema Ok
- 6. lucas :: 
- 7. enoc :: 
- 9. unionito
- 10. jonas
- 11. jairo
- 12. esther -- Hay que separar heavy
- 13. ester
- 14. jose
- 15. pablo -- Hay que separar heavy
- 16. jared -- Hay que separar heavy

# METODOLOGIA

Migrar solo TABLES de todos los esquemas
Migrar secuencias y sus valores
Migrar pk
Migrar funciones, procedimientos, vistas, etc
Migrar data
Migrar contrais