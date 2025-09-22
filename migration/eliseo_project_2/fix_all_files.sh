#!/bin/bash

# Ruta donde están los archivos generados por ora2pg (ajusta según tu entorno)
BASE_DIR="./schema"
# Cambia esto por tu esquema real (por ejemplo: moises)
SCHEMA="eliseo"


find "$BASE_DIR" -type f -name "*.sql" -print0 | xargs -0 sed -i -E \
  -e 's/CREATE OR REPLACE TYPE/CREATE TYPE/I' \
  -e 's/\s+FORCE\s+/ /I' \
  -e 's/AS OBJECT\s*\(/AS (/I' \
  -e 's/\bvarchar2\b/varchar/Ig' \
  -e 's/\bnumber\b/numeric/Ig' \
  -e 's/\bdate\b/timestamp/Ig'

echo "Listo. Se han corregido los types en los archivos SQL con esquema: $SCHEMA"


find "$BASE_DIR" -type f -name "*.sql" -print0 | xargs -0 sed -i -E \
  -e '/dbms_random/I s/^/-- /'
echo "Listo. Se han corregido los dbms_random de los archivos SQL con esquema: $SCHEMA"


find "$BASE_DIR" -type f -name "*.sql" -print0 | xargs -0 sed -i \
  -e '/^[[:space:]]*goto[[:space:]]/I s/^/-- /' \
  -e '/^[[:space:]]*GOTO[[:space:]]/I s/^/-- /' \
  -e '/^[[:space:]]*<<[a-zA-Z0-9_]\+>>/ s/^/-- /' \
  -e '/^[[:space:]]*CREATE[[:space:]]\+USER/I s/^/-- /'

echo "Comentar el goto y las etiquetas <<etiqueta>> de los archivos SQL con esquema: $SCHEMA"

# Buscar y reemplazar TIMESTAMP(7) por TIMESTAMP(6) en todos los archivos .sql
find "$BASE_DIR" -type f -name "*.sql" -print0 | xargs -0 sed -i \
  -e 's/TIMESTAMP(7)/TIMESTAMP(6)/g' \
  -e 's/TIMESTAMP (7)/TIMESTAMP(6)/g'

echo "Modificación completada. Todos los TIMESTAMP(7) fueron cambiados a TIMESTAMP(6)."

# Crear carpeta de respaldo
# BACKUP_DIR="${BASE_DIR}/_backup_$(date +%Y%m%d_%H%M%S)"
# mkdir -p "$BACKUP_DIR"

# Procesar todos los archivos .sql
# find "$BASE_DIR" -type f -name "*.sql" | while read -r FILE; do
#     echo "Procesando: $FILE"
#     # Generar ruta relativa para respaldo
#     RELATIVE_PATH="${FILE#$BASE_DIR/}"
#     BACKUP_PATH="$BACKUP_DIR/$RELATIVE_PATH"
#     mkdir -p "$(dirname "$BACKUP_PATH")"
#     cp "$FILE" "$BACKUP_PATH"
#     # Comentar líneas con GOTO o etiquetas tipo <<etiqueta>>
#     sed -i \
#         -e '/^[[:space:]]*goto[[:space:]]/I s/^/-- /' \
#         -e '/^[[:space:]]*GOTO[[:space:]]/I s/^/-- /' \
#         -e '/^[[:space:]]*<<[a-zA-Z0-9_]\+>>/ s/^/-- /' \
#         "$FILE"
# done

# echo "Listo. Se han comentado las lineas con GOTO. Respaldo en: $BACKUP_DIR"
echo "Listo. Se han comentado las lineas con GOTO del esquema: $SCHEMA"


# Reemplaza todas las ocurrencias de nextval('sq_...') por nextval('moises.sq_...')
# find "$BASE_DIR" -type f -name "*.sql" -exec sed -i "s/nextval('sq_/nextval('${SCHEMA}.sq_/g" {} +

# BASE_DIR="./schema"

find "$BASE_DIR" -type f -name "*.sql" -print0 | xargs -0 sed -i -E \
  -e "s/nextval\('([a-zA-Z0-9_]+)'\)/nextval('${SCHEMA}.\1')/g" \
  -e "s/nextval\('${SCHEMA}\.([a-zA-Z0-9_]+)'\)/nextval('${SCHEMA}.\1')/g"

echo "Listo. Se han corregido las secuencias del esquema: $SCHEMA"


find schema -type f -name "*.sql" -exec sed -i \
  -e '/user varchar/s/\buser\b/"user"/' \
  -e '/left numeric/s/\bleft\b/"left"/' \
  -e '/left bigint/s/\bleft\b/"left"/' \
  -e '/right numeric/s/\bright\b/"right"/' \
  -e '/right bigint/s/\bright\b/"right"/' \
  -e '/order bigint/s/\border\b/"order"/' {} +

echo "Listo. Se han corregido las columnas con palabras reservadas del esquema: $SCHEMA"


find ./schema -type f -name "*.sql" -exec sed -i -E "
  s/(\w+\s+bigint\s+DEFAULT\s+)TO_char\(statement_timestamp\(\), 'yyyy'\)/\1EXTRACT(YEAR FROM statement_timestamp())::bigint/g
" {} +

echo "Correciones cuando hay fechas: $SCHEMA"

# persona_index2
sed -i "s/||%%string0%(|/||''||/g" schema/tables/INDEXES_table.sql
sed -i "s/||%%string1%(|/||''||/g" schema/tables/INDEXES_table.sql
echo "Correciones indices: $SCHEMA"