# Stepts to install docker container to ora2pg

Aqui describimos los pasos para migrar la base de datos LAMB a posgres
## Pasos para la instalación (Necesario Docker)

1. Clona esta imagen:
    ```bash
    docker pull georgmoser/ora2pg
    ```

<!-- 2. Crea un archivo `.env` con las variables necesarias para Oracle y PostgreSQL. -->

<!-- 3. Construye la imagen de Docker:
    ```bash
    docker build -t ora2pg-migrator .
    ``` -->

4. Ejecuta el contenedor:
    ```bash
    docker compose up ora2pg -d
    ```
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
