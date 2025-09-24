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

| ESQUEMA     | OBJETO              | Intento 1    | Intento 2    | Intento 3    | Observaciones                                                  |
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

| ESQUEMA     | OBJETO              | Intento 1    | Intento 2    | Intento 3    | Observaciones                                                  |
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

| ESQUEMA     | OBJETO              | Intento 1    | Intento 2    | Intento 3    | Observaciones                                                  |
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

| ESQUEMA     | OBJETO              | Intento 1    | Intento 2    | Intento 3    | Observaciones                                                  |
|-------------|---------------------|--------------|--------------|--------------|----------------------------------------------------------------| 
| eliseo      | SEQUENCE            | Success      |              |              |                                                                | 
| eliseo      | SEQUENCE_VALUES     | Success      |              |              |                                                                | 
| eliseo      | TABLE               | Success      |              |              |                                                                | 
| eliseo      | FUNCTION            |              | Success      |              | (Se exporto con errores) Se comentó varias lineas del archivo `function.sql`| 
| eliseo      | VIEW                |              | xx           |              |  Depende de david.                                             | 
| eliseo      | PACKAGE             |              | Success      |              | (Se exporto con errores) Se comentó varias lineas del archivo `package.sql`| 
| eliseo      | TRIGGER             |              | Success      |              | (Se exporto con errores) Se comentó varias lineas del archivo `trigger.sql`| 
| eliseo      | PROCEDURE           |              | Success      |              | (Se exporto con errores) Se comentó varias lineas del archivo `procedure.sql`| 
| eliseo      | MVIEW               |              |              |              | Necesita de vistas                                             | 
| eliseo      | DBLINK              |              |              |              | Por ahora no                                                   | 
| eliseo      | DIRECTORY           |              |              |              | No.                                                        | 
| eliseo      | INDEXES             |              | Success      |              |                                                                | 
| eliseo      | INDEX               |              | Success      |              |                                                                |    
| eliseo      | CONSTRAINTS         |              | Success      |              |                                                                | 
| eliseo      | foreign             |              | Success      |              |                                                     | 
| eliseo      | GRANT               |              |              |              | Esta engorroso                             | 
| eliseo      | TABLESPACE          |              |              |              | No se migra                                                    | 
| eliseo      | DATA                | Success      |              |              |                                                                | 

| ESQUEMA     | OBJETO              | Intento 1    | Intento 2    | Intento 3    | Observaciones                                                  |
|-------------|---------------------|--------------|--------------|--------------|----------------------------------------------------------------| 
| enoc        | SEQUENCE            | Success      |              |              |                                                                | 
| enoc        | SEQUENCE_VALUES     | Success      |              |              |                                                                | 
| enoc        | TABLE               | Success      |              |              |                                                                | 
| enoc        | FUNCTION            |              | Success      |              | (Se exporto con errores) Se comentó varias lineas del archivo `function.sql`| 
| enoc        | VIEW                |              | xx           |              | Depende de las vistas de eliseo                                            | 
| enoc        | PACKAGE             |              | Success      |              | (Se exporto con errores) Se comentó varias lineas del archivo `package.sql`| 
| enoc        | TRIGGER             |              | Success      |              |                                                         | 
| enoc        | PROCEDURE           |              | Success      |              | (Se exporto con errores) Se comentó varias lineas del archivo `procedure.sql`| 
| enoc        | MVIEW               |              |              |              | Necesita de vistas                                             | 
| enoc        | DBLINK              |              |              |              | Por ahora no                                                   | 
| enoc        | DIRECTORY           |              |              |              | No.                                                        | 
| enoc        | INDEXES             |              | Success      |              |                                                                | 
| enoc        | INDEX               |              | Success      |              |                                                                |    
| enoc        | CONSTRAINTS         |              | Success      |              |                                                                | 
| enoc        | foreign             |              |             |    Success       | (Depende de lucas) Se edito el archivo para no correr dependencias de lucas  | 
| enoc        | GRANT               |              | Success      |              |                                     | 
| enoc        | TABLESPACE          |              |              |              | No se migra                                                    | 
| enoc        | DATA                | Success      |              |              |                                                                | 
