## 1. Para separar los archivos con tablas pesadas
1. Primero hay que limpiar ninguna tabla puede tener LONG, este tipo de datos ya fue deprecado en oracle
```
SELECT owner,
       table_name,
       column_name
FROM all_tab_columns
WHERE data_type = 'LONG'
AND owner NOT IN ('SYS','SYSTEM','WMSYS','EXFSYS','OUTLN')
ORDER BY owner, table_name, column_name;
```
## 2. Ejemplo para sacar todas las tablas que tienen decimales con campo number
 <!-- Ubicarse en el esquema en trabajo -->
1. Ejecuntar esto en desarrollo y produccion:

```
SELECT 
  'SELECT ''' || table_name || ''' AS table_name, ''' || column_name || ''' AS column_name FROM ' || table_name || 
  ' WHERE ' || column_name || ' IS NOT NULL AND ' || column_name || ' != TRUNC(' || column_name || ') AND ROWNUM = 1 union all' AS query
FROM user_tab_columns
WHERE data_type = 'NUMBER'
  AND data_precision IS NULL
  AND (TABLE_NAME NOT LIKE 'VW_%' AND TABLE_NAME NOT LIKE 'X_VW_%' AND TABLE_NAME NOT LIKE 'TT_%')
  AND data_scale IS NULL;
  ```

Del resultado buscar order,CLUSTER. Palabras reservadas y encerrarlos de "".
2. Despues el resultado pegarlo dentro de from ()x:

```
SELECT 'MODIFY_TYPE     '||table_name||':'||column_name||':numeric' FROM (
SELECT 'API_FIRMA' AS table_name, 'VIGENCIA' AS column_name FROM API_FIRMA WHERE VIGENCIA IS NOT NULL AND VIGENCIA != TRUNC(VIGENCIA) AND ROWNUM = 1 union all
SELECT 'API_FIRMA_USER' AS table_name, 'USER_ID' AS column_name FROM API_FIRMA_USER WHERE USER_ID IS NOT NULL AND USER_ID != TRUNC(USER_ID) AND ROWNUM = 1
)x
```

El resultado pegarlo en el archivo ora2pg.conf
primero los devs luego el prod

