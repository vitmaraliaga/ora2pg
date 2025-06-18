#!/bin/bash

FILES=(USER SEQUENCE TABLE)
# FILES=(USER SEQUENCE TABLE INDEX FUNCTION PROCEDURE PACKAGE VIEW TRIGGER GRANT)

for file in "${FILES[@]}"; do
  echo "Ejecutando ${file}_output.sql..."
#   docker compose run --rm -e PGPASSWORD='sd4n0rt3_' -v $(pwd)/output:/scripts postgres-client \
  PGPASSWORD='sd4n0rt3_' psql -h 10.171.11.175 -p 5436 -U sdaupn -d sdaupn_rid_to -f myfolder/${file}_output.sql
done

# echo "Ejecutando FOREIGN KEYs..."
# PGPASSWORD='sd4n0rt3_' psql -h 10.171.11.175 -p 5436 -U sdaupn -d sdaupn_rid_to -f myfolder/FK_output.sql

# # oracle
# number(10.2)
# number(15.5)
# 100.00

# number(20)
# id_persona

# date 
# 2025-01-01
# 2025-01-01 00:00:00


# # postgress
# decimal(10,2)

# gitint
# int4
# int8

# timestamp
# # 2025-01-01 00:00:00
# date 
# 2025-01-01
