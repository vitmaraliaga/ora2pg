# Stepts to install docker container to ora2pg

Aqui describimos los pasos para migrar la base de datos LAMB a posgres
## Pasos para la instalación (Necesario Docker)

1. Clona esta imagen:
    ```bash
    docker pull georgmoser/ora2pg
    ```
2. Configura el contenedor como en el ejemplo
3. Ejecuta el contenedor:
    ```bash
    docker compose up ora2pg -d
    docker exec -it name_container bash
    ```
4. Crea el proyecto dentro de la carpeta nigration
    ```bash
    ora2pg --project_base /migration/ --init_project moises_project
    ```
5. Configura el archivo conf
    - Configura la conección a la base de datos
    - Configura el nombre del esquema
    - EXPORT_SCHEMA 1
    - DROP_IF_EXISTS 1
    - USE_TABLESPACE 1 (Antes se debe crear los tablspace en postgres)
    - TRANSACTION	committed
    - TRUNCATE_TABLE_CASCADE 1 # no comprobado
    - PACKAGE_AS_SCHEMA	0
7. Ejecutar `./export_schema.sh`.
7. `import_all.sh` para que FUNCTION migre depues de TABLE
6. Corregir dato migrado antes de cargar
    - Corregir type
    - TYPE:: Buscar `Unsupported, please edit to match PostgreSQL syntax` para reemplazar manualmente

    - WARNINGS PACKAGES:: Buscar en `./migration/moises_project2/schema` `salida_final, salida_rapida,salida_val, goto_` y comentarlos
    - Eliminar todas las lineas que empiecen con `eliseo, jose, david` etc reemplazar por `--ora2pg` para comentarlos
    - Buscar este caracter `dbms_random.varchar` y comentar
    - Editar procedimiento `moises.iudp_persona_datos_multiples` falta un `call`
    - `./import_all.sh -h 10.171.11.175 -U sdaupn -d sdaupn_rid_to -p 5436 -o sdaupn`
    - sd4n0rt3_
    - Comentar los fk que hacen referencia a esquemas que no existen, en este caso bucar: `enoc`
    - `sed -i "s/nextval('sq_/nextval('moises.sq_/g" schema/triggers/*.sql` con esto hay que editar el prefijo de las secuencias de ID.
    
6. Escanear y generar un informe
    - `mkdir tmp`
    - `ora2pg -t show_report --estimate_cost -c config/ora2pg.conf --dump_as_html > ./tmp/ora2pg.html`
4. De los archivos generados cambiar buscar "left numer" y reemplazar por "left" numer:
4. Hay que crear los roles, nombre del esquema, manualmente

4. Ejecuta el contenedor:
    ```bash
    docker compose run --user root postgres-client
    ```
4. De los archivos generados cambiar buscar "left numer" y reemplazar por "left" numer:
4. Hay que crear los roles
3. Orden de migraciones de esquemas
    - Primero eliseo
    
5. Hay una preocupación por las dependencias, no se puede relacionar 
4. Ejecuta el contenedor:
    ```bash
    cd data
    ./migrar.sh
    ```
6. Correciones
    - en table_out.sql colocar bitint a todos los id_tipo_discapacidad
    - Moises depende de enoc, hay que romper todas las dependencias de enoc. o no migrarlas aun
5. Ejecuta el esto dentro del contenedor:
    ```bash
    PGPASSWORD='sd4n0rt3_' psql -h 10.171.11.175 -p 5436 -U sdaupn -d sdaupn_rid_to
    ```
