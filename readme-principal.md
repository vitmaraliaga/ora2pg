# ORDEN DE MIGRACION
# 1. GENERAR EL ESQUELETO
    
# 2. PRIMER INTENTO: SECUENCIAS, VALOR-SECUENCIAS, TABLAS, DATA
    
## Esquema: genesis ::: Schema generated Ok
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
## Esquema: caleb ::: Schema generated Ok
    SEQUENCE success (1th try)
    SEQUENCE_VALUES success (1th try)
    TABLE success (1th try)
    FUNCTION success (2th try)
    VIEW no con errores de pivot
    <!- PACKAGE no -->
    TRIGGER success (3th try)
    PROCEDURE success (3th try)
    <!- MVIEW no
    DBLINK no -->
    <!- DIRECTORY no -->
    indexes yes
          index  success (2th try)
          contraints success (2th try)
          foreignkey con error (2th try) // Esta pidiendo lucas
    GRANT no
    TABLESPACE no
    data success (1th try)
## Esquema: josue ::: no existe en dev
## Esquema: moises ::: Schema generated Ok
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
## Esquema: eliseo :: Schema generated Ok
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
        - Necesita de vistas
    DBLINK no
        - Por ahora no
    indexes yes
        indexes  success (2th try)
        constraints success (2th try)
        foreignkey success (2th try)
    <!-- DIRECTORY no -->
    GRANT no
    TABLESPACE no
    data success (1th try)
    indexes success (1th try)
    constraints success (1th try)
    foreign no
    TRIGGER no
## Esquema: david :: Schema generated Ok
## Esquema: lucas :: 
## Esquema: enoc :: 
## Esquema: unionito
## Esquema: jonas
## Esquema: jairo
## Esquema: esther -- Hay que separar heavy
## Esquema: ester
## Esquema: jose
## Esquema: pablo -- Hay que separar heavy
## Esquema: jared -- Hay que separar heavy

# METODOLOGIA

Migrar solo TABLES de todos los esquemas
Migrar secuencias y sus valores
Migrar pk
Migrar funciones, procedimientos, vistas, etc
Migrar data
Migrar contrais