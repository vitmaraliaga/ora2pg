# ORDEN DE MIGRACION
# 1. GENERAR EL ESQUELETO
    
# 2. PRIMER INTENTO: SECUENCIAS, VALOR-SECUENCIAS, TABLAS, DATA
    Hay que modificar el export_schema.sh
    para que apunte a otro conf

| ESQUEMA     | OBJETO              | Intento 1    | Intento 2    | Intento 3    | Observaciones                                                  |
|-------------|---------------------|--------------|--------------|--------------|----------------------------------------------------------------| 
| genesis     | SEQUENCE            | Success      |              |              |                                                                | 
| genesis     | SEQUENCE_VALUES     | Success      |              |              |                                                                |   
| genesis     | TABLE               | Success      |              |              |                                                                | 
| genesis     | VIEW                |              | Success      |              |                                                                | 
| genesis     | TRIGGER             |              | Success      |              |                                                                | 
| genesis     | FUNCTION            |              | Success      |              |                                                                | 
| genesis     | INDEXES             |              | Success      |              |                                                                | 
| genesis     | INDEX               |              | Success      |              |                                                                | 
| genesis     | CONSTRAINTS         |              | Success      |              |                                                                | 
| genesis     | foreign             |              | Success      |              |                                                                | 
| genesis     | GRANT               |              | Success      |              |                                                                | 
| genesis     | TABLESPACE          |              |              |              | No se migra                                                    | 
| genesis     | DATA                | Success      |              |              |                                                                | 
|-------------|---------------------|--------------|--------------|--------------|----------------------------------------------------------------| 
| caleb       | SEQUENCE            | Success      |              |              |                                                                | 
| caleb       | SEQUENCE_VALUES     | Success      |              |              |                                                                | 
| caleb       | TABLE               | Success      |              |              |                                                                | 
| caleb       | FUNCTION            |              | Success      |              |                                                                | 
| caleb       | VIEW                |              |              |              | Errores de pivot (Solo es una vista, y ese tiene error)        | 
| caleb       | PACKAGE             |              |              |              | No tiene                                                       | 
| caleb       | TRIGGER             |              |              | Success      |                                                                | 
| caleb       | PROCEDURE           |              |              | Success      |                                                                | 
| caleb       | MVIEW               |              |              |              | no tiene                                                       | 
| caleb       | DBLINK              |              |              |              | no tiene                                                       | 
| caleb       | DIRECTORY           |              |              |              | no tiene                                                       | 
| caleb       | INDEXES             |              | Success      |              |                                                                | 
| caleb       | INDEX               |              | Success      |              |                                                                |    
| caleb       | CONSTRAINTS         |              | Success      |              |                                                                | 
| caleb       | foreign             |              |              |              | con error // Esta pidiendo lucas                               | 
| caleb       | GRANT               |              |              |              | no tiene                                                       | 
| caleb       | TABLESPACE          |              |              |              | No se migra                                                    | 
| caleb       | DATA                | Success      |              |              |                                                                | 
|-------------|---------------------|--------------|--------------|--------------|----------------------------------------------------------------| 
| josue       | SEQUENCE            |              |              |              |                                                                | 
| josue       | SEQUENCE_VALUES     |              |              |              |                                                                | 
| josue       | TABLE               |              |              |              |                                                                | 
| josue       | FUNCTION            |              |              |              |                                                                | 
| josue       | VIEW                |              |              |              |         | 
| josue       | PACKAGE             |              |              |              |                                                        | 
| josue       | TRIGGER             |              |              |              |                                                                | 
| josue       | PROCEDURE           |              |              |              |                                                                | 
| josue       | MVIEW               |              |              |              |                                                       | 
| josue       | DBLINK              |              |              |              |                                                        | 
| josue       | DIRECTORY           |              |              |              |                                                       | 
| josue       | INDEXES             |              |              |              |                                                                | 
| josue       | INDEX               |              |              |              |                                                                |    
| josue       | CONSTRAINTS         |              |              |              |                                                                | 
| josue       | foreign             |              |              |              |                                                               | 
| josue       | GRANT               |              |              |              |                                                          | 
| josue       | TABLESPACE          |              |              |              |                                                        | 
| josue       | DATA                |              |              |              |                                                                | 
|-------------|---------------------|--------------|--------------|--------------|----------------------------------------------------------------| 
| moises      | SEQUENCE            | Success      |              |              |                                                                | 
| moises      | SEQUENCE_VALUES     | Success      |              |              |                                                                | 
| moises      | TABLE               | Success      |              |              |                                                                | 
| moises      | FUNCTION            |              | Success      |              |                                                                | 
| moises      | VIEW                |              | Success      |              |                                                            | 
| moises      | PACKAGE             |              | Success      |              |                                                       | 
| moises      | TRIGGER             |              | Success      |              |                                                                | 
| moises      | PROCEDURE           |              | Success      |              |                                                                | 
| moises      | MVIEW               |              |              |              | no tiene                                                       | 
| moises      | DBLINK              |              |              |              | no tiene                                                       | 
| moises      | DIRECTORY           |              |              |              | no tiene                                                       | 
| moises      | INDEXES             |              | Success      |              |                                                                | 
| moises      | INDEX               |              | Success      |              |                                                                |    
| moises      | CONSTRAINTS         |              | Success      |              |                                                                | 
| moises      | foreign             |              |              | Success      | depende de enoc // success (3th try) con exito despues de migrar enoc    | 
| moises      | GRANT               |              |              |              | no (no existe el rol «userupdate»)                             | 
| moises      | TABLESPACE          |              |              |              | No se migra                                                    | 
| moises      | DATA                | Success      |              |              |                                                                | 
<!-- ## Esquema: genesis ::: Schema generated Ok
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
    foreign success keys (2th try) --> -->
## Esquema: caleb ::: Schema generated Ok
    SEQUENCE success (1th try)
    SEQUENCE_VALUES success (1th try)
    TABLE success (1th try)
    FUNCTION success (2th try)
    VIEW no con errores de pivot (Solo es una vista, y ese tiene error)
    <!- PACKAGE no tiene-->
    TRIGGER success (3th try)
    PROCEDURE success (3th try)
    <!- MVIEW no tiene
    DBLINK no tiene-->
    <!- DIRECTORY no tiene-->
    indexes yes
          index  success (2th try)
          contraints success (2th try)
          foreignkey con error (2th try) // Esta pidiendo lucas
    GRANT no tiene
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
    <!-- MVIEW no found-->
    DBLINK no aún
    <!-- DIRECTORY no -->
    indexes yes (2th try)
        indexes success (2th try)
        constraints success (2th try)
        foreignkey no : depende de enoc // success (3th try) con exito despues de migrar enoc
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
        <!-- Esta engorroso -->
    TABLESPACE no
    data success (1th try)
    indexes success (1th try)
    constraints success (1th try)
    foreign no
    TRIGGER no
## Esquema: david :: Schema generated Ok
## Esquema: lucas :: 
    SEQUENCE 
    SEQUENCE_VALUES 
    TABLE 
    FUNCTION 
    PACKAGE 
    VIEW no
    TRIGGER 
    PROCEDURE no
    MVIEW no
    DBLINK no
    indexes no
    DIRECTORY no
    GRANT 
    TABLESPACE no
    data 
## Esquema: enoc :: 
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
        Depende de las vistas de eliseo
    TRIGGER success (2th try)
    PROCEDURE no
        - Se comentó varias lineas del archivo.
        - procedure.sql -->
    MVIEW no
        - Necesita de vistas
    DBLINK no
        - Por ahora no
    indexes yes
        indexes  success (2th try)
        constraints success (2th try)
        foreignkey success (2th try) (Depende de lucas)
        - Se edito el archivo para no correr dependencias de lucas
    <!-- DIRECTORY no -->
    GRANT success (2th try)
    TABLESPACE no
    data success (1th try)
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


ora2pg -p -t TABLE -o table.sql -b ./schema/tables -c ./config/ora2pg.conf