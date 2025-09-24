SET client_encoding TO 'UTF8';

SET search_path = eliseo,public;
\set ON_ERROR_STOP ON

DROP MATERIALIZED VIEW IF EXISTS vwm_conta_diario_totales;
CREATE MATERIALIZED VIEW vwm_conta_diario_totales AS
SELECT ID_CUENTAAASI, ID_ANHO, ID_MES, SUM(COS_VALOR) COS_VALOR  FROM VW_CONTA_DIARIO WHERE (ID_DEPTO IS NOT NULL AND ID_DEPTO::text <> '') --AND ID_ANHO=2021 AND ID_MES<=12 
	AND (ID_FONDO IS NOT NULL AND ID_FONDO::text <> '') AND ID_TIPOASIENTO<>'EA'
 GROUP BY ID_CUENTAAASI, ID_ANHO, ID_MES;


-- DROP MATERIALIZED VIEW IF EXISTS vwm_sales_detail_mov_col;
-- CREATE MATERIALIZED VIEW vwm_sales_detail_mov_col AS
-- SELECT col.* FROM VW_SALES_DETAIL_MOV_COL_DIARIO col
-- INNER JOIN jose.SCHOOL_INSTITUCION si ON si.ID_CAMPO = col.ID_ENTIDAD AND si.ID_DEPTO = col.ID_DEPTO;


DROP MATERIALIZED VIEW IF EXISTS vwm_sales_detail_mov_col_d;
CREATE MATERIALIZED VIEW vwm_sales_detail_mov_col_d AS
SELECT ID_ENTIDAD,ID_DEPTO,ID_ANHO,ID_MES,ID_VOUCHER,ID_VENTA,ID_ARTICULO,ID_CLIENTE,ID_SUCURSAL,ID_COMPROBANTE,ID_MONEDA,SERIE,NUMERO,DOCUMENTO_VENTA,SERIE_MOV,NUMERO_MOV,DOCUMENTO_MOV,FECHA,GLOSA,DETALLE,IMPORTE,IMPORTE_ME,ID_TIPOTRANSACCION,ID_DEPTO_CCOSTO FROM (
  SELECT 	  A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          NULL AS id_voucher,
          A.ID_VENTA,
          A.ID_ARTICULO,
          B.ID_CLIENTE,
          B.ID_SUCURSAL,
          B.ID_COMPROBANTE,
          B.ID_MONEDA,
          B.SERIE,
          B.NUMERO,
          T.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          B.SERIE AS SERIE_MOV,
          B.NUMERO AS NUMERO_MOV,
          'Sal Ini' as DOCUMENTO_MOV,
          B.FECHA,
          B.GLOSA,
          A.DETALLE AS DETALLE,
          A.TOTAL AS IMPORTE,
          A.TOTAL_ME AS IMPORTE_ME,
          B.ID_TIPOTRANSACCION,
          B.ID_DEPTO_CCOSTO 
   FROM ELISEO.VENTA_SALDO A
        INNER JOIN eliseo.VENTA B ON A.ID_VENTA = B.ID_VENTA
        LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = B.ID_COMPROBANTE
   
UNION all

  SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.id_voucher,
          A.ID_VENTA,
          B.ID_ARTICULO,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          A.ID_COMPROBANTE,
          A.ID_MONEDA,
          A.SERIE,
          A.NUMERO,
          T.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          A.SERIE AS SERIE_MOV,
          A.NUMERO AS NUMERO_MOV,   
          T.NOMBRE_CORTO AS DOCUMENTO_MOV,
          A.FECHA,
          A.GLOSA,
          B.DETALLE,
          B.IMPORTE,
          B.IMPORTE_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_DEPTO_CCOSTO
   FROM VENTA A 
   INNER JOIN VENTA_DETALLE B ON A.ID_VENTA = B.ID_VENTA
   LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = A.ID_COMPROBANTE
   WHERE A.ID_COMPROBANTE NOT IN ('07','08')
   AND A.ESTADO = '1'
   
UNION ALL

   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.id_voucher,
          C.ID_VENTA,
          B.ID_ARTICULO,
          A.ID_CLIENTE,
          D.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          T.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          A.SERIE AS SERIE_MOV,
          A.NUMERO AS NUMERO_MOV,   
          'Dep' as DOCUMENTO_MOV,
          A.FECHA,
          D.GLOSA,
          A.GLOSA,
          B.IMPORTE *-1,
		  B.IMPORTE_ME *-1,
          A.ID_TIPOTRANSACCION,
          D.ID_DEPTO_CCOSTO
     FROM CAJA_DEPOSITO A
        INNER JOIN CAJA_DEPOSITO_DETALLE B ON A.ID_DEPOSITO = B.ID_DEPOSITO
        INNER JOIN VENTA_SALDO C ON B.ID_VENTA = C.ID_VENTA AND A.ID_ANHO = C.ID_ANHO 
        INNER JOIN VENTA D ON B.ID_VENTA = D.ID_VENTA
        LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = C.ID_COMPROBANTE
    WHERE A.ESTADO = '1'

UNION ALL
 
    SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.id_voucher,
          C.ID_VENTA,
          COALESCE(B.ID_ARTICULO, D.ID_ARTICULO ),
          --D.ID_ARTICULO,
          A.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          T.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          A.SERIE AS SERIE_MOV,
          A.NUMERO AS NUMERO_MOV,   
          'Dep' as DOCUMENTO_MOV,
          A.FECHA,
          C.GLOSA,
          A.GLOSA,
          CASE WHEN coalesce(B.ID_ARTICULO::text, '') = '' THEN 
          CASE WHEN COALESCE(C.TOTAL,0) = 0 THEN 
          	0 ELSE (D.IMPORTE/C.TOTAL*B.IMPORTE) * -1
          	END
          ELSE  
          	B.IMPORTE *-1
          END ,
		  CASE WHEN coalesce(B.ID_ARTICULO::text, '') = '' THEN 
          CASE WHEN COALESCE(C.TOTAL_ME,0) = 0 THEN 
          	0 ELSE (D.IMPORTE_ME/C.TOTAL_ME*B.IMPORTE_ME) * -1
          	END
          ELSE 
          	B.IMPORTE_ME *-1
          END,
          A.ID_TIPOTRANSACCION,
          C.ID_DEPTO_CCOSTO
     FROM CAJA_DEPOSITO A
        INNER JOIN CAJA_DEPOSITO_DETALLE B ON A.ID_DEPOSITO = B.ID_DEPOSITO
        INNER JOIN VENTA C ON B.ID_VENTA = C.ID_VENTA
        INNER JOIN VENTA_DETALLE D ON D.ID_VENTA = C.ID_VENTA
        LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = C.ID_COMPROBANTE
    WHERE A.ESTADO = '1'
    AND COALESCE(B.ID_ARTICULO, D.ID_ARTICULO ) = D.ID_ARTICULO  
    AND NOT EXISTS (SELECT x.ID_VENTA FROM VENTA_SALDO x WHERE x.ID_ENTIDAD= A.ID_ENTIDAD AND x.ID_ANHO=A.ID_ANHO AND x.ID_VENTA = B.ID_VENTA) 
    
UNION ALL

    SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.id_voucher,
          B.ID_VENTA,
          D.ID_ARTICULO,
          A.ID_CLIENTE,
          B.ID_SUCURSAL,
          B.ID_COMPROBANTE, 
          A.ID_MONEDA,
          B.SERIE,
          B.NUMERO,
          U.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          A.SERIE AS SERIE_MOV,
          A.NUMERO AS NUMERO_MOV,
          T.NOMBRE_CORTO AS DOCUMENTO_MOV,
          A.FECHA,
          A.GLOSA,
          D.DETALLE,
          CASE WHEN D.DC='C' THEN -1  ELSE 1 END *D.IMPORTE AS TOTAL,
          CASE WHEN D.DC='C' THEN -1  ELSE 1 END *D.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_DEPTO_CCOSTO
   FROM VENTA A 
   INNER JOIN VENTA_DETALLE D ON A.ID_VENTA = D.ID_VENTA 
   INNER JOIN VENTA B ON A.ID_PARENT = B.ID_VENTA
   LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = A.ID_COMPROBANTE
   LEFT OUTER JOIN TIPO_COMPROBANTE U ON U.ID_COMPROBANTE = B.ID_COMPROBANTE
   WHERE A.ID_COMPROBANTE IN ('07','08')
   AND A.ESTADO = '1' 
   
UNION ALL

   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO, 
          A.ID_MES,
          A.id_voucher,
          C.ID_VENTA,
          B.ID_ARTICULO,
          A.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          T.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          A.SERIE AS SERIE_MOV,
          A.NUMERO AS NUMERO_MOV,
          'Trs.' AS DOCUMENTO_MOV,
          A.FECHA,
          A.GLOSA,
          B.DETALLE,
          CASE WHEN B.DC='C' THEN -1  ELSE 1 END *B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN -1  ELSE 1 END *B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_DEPTO_CCOSTO
     FROM VENTA_TRANSFERENCIA A
        INNER JOIN VENTA_TRANSFERENCIA_DETALLE B ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
        INNER JOIN VENTA C ON B.ID_VENTA = C.ID_VENTA
        LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = C.ID_COMPROBANTE
    WHERE A.ESTADO = '1'
    
UNION ALL

   SELECT C.ID_ENTIDAD,
          C.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.id_voucher,
          C.ID_VENTA,
          B.ID_ARTICULO_DESTINO,
          C.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          T.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          A.SERIE AS SERIE_MOV,
          A.NUMERO AS NUMERO_MOV,
          'Trs.' AS DOCUMENTO_MOV,
          A.FECHA,
          A.GLOSA,
          B.DETALLE,
          CASE WHEN B.DC='C' THEN 1  ELSE -1 END *B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN 1  ELSE -1 END *B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_DEPTO_CCOSTO
     FROM VENTA_TRANSFERENCIA A
        INNER JOIN VENTA_TRANSFERENCIA_DETALLE B ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
        INNER JOIN VENTA C ON B.ID_VENTA_DESTINO = C.ID_VENTA
        LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = C.ID_COMPROBANTE
    WHERE A.ESTADO = '1'
    	AND A.ES_ENTRECLIENTES = 'S'
    
UNION ALL
 
        SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.id_voucher,
          C.ID_VENTA,
          B.ID_ARTICULO,
          B.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          T.NOMBRE_CORTO AS DOCUMENTO_VENTA,
          '' AS SERIE_MOV,
          A.NUMERO AS NUMERO_MOV,
          'Dev.' AS DOCUMENTO_MOV,
          A.FECHA,
          C.GLOSA,
          B.DETALLE,
          B.IMPORTE,
          B.IMPORTE_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_DEPTO_CCOSTO
     FROM CAJA_PAGO A
        INNER JOIN CAJA_PAGO_VENTA B ON A.ID_PAGO = B.ID_PAGO
        INNER JOIN VENTA C ON B.ID_VENTA = C.ID_VENTA
        LEFT OUTER JOIN TIPO_COMPROBANTE T ON T.ID_COMPROBANTE = C.ID_COMPROBANTE
     WHERE A.ESTADO = '1'
)a;


DROP MATERIALIZED VIEW IF EXISTS vwm_sales_mov;
CREATE MATERIALIZED VIEW vwm_sales_mov AS
SELECT ID_ENTIDAD,ID_DEPTO,ID_ANHO,ID_MES,ID_VENTA,ID_CLIENTE,ID_SUCURSAL,ID_COMPROBANTE,ID_MONEDA,SERIE,NUMERO,FECHA,GLOSA,TOTAL,TOTAL_ME,ID_TIPOTRANSACCION,ID_TIPOVENTA,TIPO,MOV,VOUCHER,LOTE,TIPO_DOCUMENTO,NUMERO_LEGAL
FROM (
SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.ID_VENTA,
          A.ID_CLIENTE,
          B.ID_SUCURSAL,
          A.ID_COMPROBANTE,
          A.ID_MONEDA,
          A.SERIE,
          A.NUMERO,
          A.FECHA,
          'Saldo Pendiente: ' || B.GLOSA AS GLOSA,
          A.TOTAL,
          A.TOTAL_ME,
          B.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'V' AS TIPO,
          'SI: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          '' AS VOUCHER,
          '' AS LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_SALDO A, VENTA B
    WHERE     A.ID_VENTA = B.ID_VENTA
          AND A.ID_CLIENTE = B.ID_CLIENTE
          AND A.TOTAL <> 0
   
UNION ALL
                                                  --VENTAS QUERY 1
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.ID_VENTA,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          A.ID_COMPROBANTE,
          A.ID_MONEDA,
          A.SERIE,
          A.NUMERO,
          A.FECHA,
          A.GLOSA,
          A.TOTAL,
          A.TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'V' AS TIPO,
          'VNT: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          B.NUMERO::text AS VOUCHER,
          B.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A LEFT JOIN CONTA_VOUCHER B ON A.ID_VOUCHER = B.ID_VOUCHER
    WHERE     A.ID_COMPROBANTE NOT IN ('07', '08')
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL
                                --DEPOSITOS PAGAN VENTAS QUERY 1.1
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          A.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          B.IMPORTE * -1,
          B.IMPORTE_ME * -1,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'V' AS TIPO,
          'DEP: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '00' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM CAJA_DEPOSITO A,
          CAJA_DEPOSITO_DETALLE B,
          VENTA C,
          CONTA_VOUCHER D
    WHERE     A.ID_DEPOSITO = B.ID_DEPOSITO
          AND B.ID_VENTA = C.ID_VENTA
          AND A.ID_CLIENTE = C.ID_CLIENTE
          AND A.ID_VOUCHER = D.ID_VOUCHER
          AND B.IMPORTE <> 0
   
UNION ALL
                     --NOTAS DE CREDITO AFECTAN A VENTAS QUERY 1.2
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          B.ID_VENTA,
          A.ID_CLIENTE,
          B.ID_SUCURSAL,
          B.ID_COMPROBANTE,
          A.ID_MONEDA,
          B.SERIE,
          B.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL AS TOTAL,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          B.ID_TIPOVENTA,
          'V' AS TIPO,
          'NCD: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          C.NUMERO::text AS VOUCHER,
          C.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A
          JOIN VENTA B
             ON A.ID_PARENT = B.ID_VENTA AND A.ID_CLIENTE = B.ID_CLIENTE
          LEFT JOIN CONTA_VOUCHER C ON A.ID_VOUCHER = C.ID_VOUCHER
    WHERE     A.ID_COMPROBANTE IN ('07', '08')         --FROM VENTA A, VENTA B
                                              --WHERE A.ID_PARENT = B.ID_VENTA
                                             --AND A.ID_CLIENTE = B.ID_CLIENTE
          AND A.ID_COMPROBANTE IN ('07', '08')
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL
                       --TRANSFERENCIAS AFECTAN A VENTAS QUERY 1.3
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          A.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'V' AS TIPO,
          'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A
          JOIN VENTA_TRANSFERENCIA_DETALLE B
             ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          JOIN VENTA C
             ON B.ID_VENTA = C.ID_VENTA AND A.ID_CLIENTE = C.ID_CLIENTE
          LEFT JOIN CONTA_VOUCHER D ON A.ID_VOUCHER = D.ID_VOUCHER
    
    WHERE B.IMPORTE <> 0 AND A.ESTADO = '1'
   
UNION ALL

   --TRANSFERENCIAS AFECTAN A ENTRECLIENTES
   SELECT C.ID_ENTIDAD,
          C.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          C.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN B.DC='C' THEN  1  ELSE -1 END  * B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN  1  ELSE -1 END  * B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'V' AS TIPO,
          'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          '' AS VOUCHER,
          '' AS LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A, VENTA_TRANSFERENCIA_DETALLE B, VENTA C
    WHERE     A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          AND B.ID_VENTA_DESTINO = C.ID_VENTA
          AND B.IMPORTE <> 0
          AND A.ESTADO = '1'
          AND A.ES_ENTRECLIENTES = 'S'
   
UNION ALL

   -- DEVOLUCION
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          B.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          C.GLOSA,
          B.IMPORTE,
          B.IMPORTE_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'P' AS TIPO,
          'DEV: OP.' || A.NUMERO AS MOV,
          '' AS VOUCHER,
          '' AS LOTE,
          '00' AS TIPO_DOCUMENTO,
          A.NUMERO AS NUMERO_LEGAL
     FROM CAJA_PAGO A
          INNER JOIN CAJA_PAGO_VENTA B ON A.ID_PAGO = B.ID_PAGO
          INNER JOIN VENTA C ON B.ID_VENTA = C.ID_VENTA
          LEFT OUTER JOIN TIPO_COMPROBANTE T
             ON T.ID_COMPROBANTE = C.ID_COMPROBANTE
    WHERE A.ESTADO = '1'
   
UNION ALL

   --SALDO INICIAL SISTEMA EXTERNO QUERY 2
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          coalesce(A.ID_VENTA, ID_SALDO) AS ID_VENTA,
          A.ID_CLIENTE,
          0 AS ID_SUCURSAL,
          A.ID_COMPROBANTE,
          A.ID_MONEDA,
          A.SERIE,
          A.NUMERO,
          A.FECHA,
          A.DETALLE AS GLOSA,
          --'Saldo Incial' AS GLOSA,
          A.TOTAL,
          A.TOTAL_ME,
          NULL AS ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'S' AS TIPO,
          'SIN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          '' AS VOUCHER,
          '' AS LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_SALDO A
    WHERE coalesce(ID_VENTA::text, '') = '' AND A.TOTAL > 0 
   
UNION ALL
                            --DEPOSITOS QUE PAGAN SALDOS QUERY 2.1
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_SALDO AS ID_VENTA,
          A.ID_CLIENTE,
          0 AS ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          B.IMPORTE * -1,
          B.IMPORTE_ME * -1,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'S' AS TIPO,
          'DEP: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '00' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM CAJA_DEPOSITO A,
          CAJA_DEPOSITO_DETALLE B,
          VENTA_SALDO C,
          CONTA_VOUCHER D
    WHERE     A.ID_DEPOSITO = B.ID_DEPOSITO
          AND B.ID_SALDO = C.ID_SALDO
          AND A.ID_CLIENTE = C.ID_CLIENTE
          AND A.ID_VOUCHER = D.ID_VOUCHER
          AND ESTADO = '1'
          AND B.IMPORTE <> 0
   
UNION ALL
                     --NOTAS DE CREDITO AFECTAN AL SALOD QUERY 2.2
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          B.ID_SALDO AS ID_VENTA,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          B.ID_COMPROBANTE,
          A.ID_MONEDA,
          B.SERIE,
          B.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL AS TOTAL,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'S' AS TIPO,
          'NCD: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          C.NUMERO::text AS VOUCHER,
          C.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A, VENTA_SALDO B, CONTA_VOUCHER C
    WHERE     A.ID_SALDO = B.ID_SALDO
          AND A.ID_CLIENTE = B.ID_CLIENTE
          AND A.ID_VOUCHER = C.ID_VOUCHER
          AND A.ID_COMPROBANTE IN ('07', '08')
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL

   SELECT                       --TRANSFERENCIAS QUE AFECTAN AL SALDO QUERY 2.3
         A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_SALDO AS ID_VENTA,
          A.ID_CLIENTE,
          0 AS ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'S' AS TIPO,
          'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A
          JOIN VENTA_TRANSFERENCIA_DETALLE B
             ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          JOIN VENTA_SALDO C
             ON A.ID_CLIENTE = C.ID_CLIENTE AND B.ID_SALDO = C.ID_SALDO
          LEFT JOIN CONTA_VOUCHER D ON A.ID_VOUCHER = D.ID_VOUCHER
    WHERE A.ESTADO = '1' AND A.ES_ANTICIPO IN ('S', 'N') --AND A.ES_ANTICIPO = 'N'
                                                      AND B.IMPORTE <> 0
   
UNION ALL
               --TRANSFERENCIAS QUE SON DOCUMENTOS A PAGAR QUERY 3
   SELECT DISTINCT A.ID_ENTIDAD,
                   A.ID_DEPTO,
                   A.ID_ANHO,
                   A.ID_MES,
                   A.ID_TRANSFERENCIA AS ID_VENTA,
                   A.ID_CLIENTE,
                   0 AS ID_SUCURSAL,
                   '99' AS ID_COMPROBANTE,
                   A.ID_MONEDA,
                   A.SERIE,
                   A.NUMERO,
                   A.FECHA,
                   A.GLOSA,
                   A.IMPORTE AS TOTAL,
                   A.IMPORTE_ME AS TOTAL_ME,
                   A.ID_TIPOTRANSACCION,
                   A.ID_TIPOVENTA,
                   'T' AS TIPO,
                   'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
                   C.NUMERO::text AS VOUCHER,
                   C.LOTE,
                   '99' AS TIPO_DOCUMENTO,
                   A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A
          JOIN VENTA_TRANSFERENCIA_DETALLE B
             ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          JOIN CONTA_VOUCHER C ON A.ID_VOUCHER = C.ID_VOUCHER
    WHERE     A.ES_ANTICIPO = 'N'
          AND coalesce(B.ID_VENTA::text, '') = ''
          AND coalesce(B.ID_SALDO::text, '') = ''
          AND coalesce(B.ID_TRANSFERENCIA_P::text, '') = ''
          AND A.ESTADO = '1'
          AND A.IMPORTE <> 0 
   
UNION ALL
                        --DEPOSITOS PAGAN TRANSFERENCIAS QUERY 3.1
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_TRANSFERENCIA AS ID_VENTA,
          A.ID_CLIENTE,
          0 AS ID_SUCURSAL,
          '99' AS ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          B.IMPORTE * -1,
          B.IMPORTE_ME * -1,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'T' AS TIPO,
          'DEP: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM CAJA_DEPOSITO A,
          CAJA_DEPOSITO_DETALLE B,
          VENTA_TRANSFERENCIA C,
          CONTA_VOUCHER D
    WHERE     A.ID_DEPOSITO = B.ID_DEPOSITO
          AND B.ID_TRANSFERENCIA = C.ID_TRANSFERENCIA
          AND A.ID_CLIENTE = C.ID_CLIENTE
          AND A.ID_VOUCHER = D.ID_VOUCHER
          AND A.ESTADO = '1'
          AND B.IMPORTE <> 0
   
UNION ALL
             --NOTAS DE CREDITO AFECTAN A TRANSFERENCIAS QUERY 3.2
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          B.ID_TRANSFERENCIA AS ID_VENTA,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          '99' AS ID_COMPROBANTE,
          A.ID_MONEDA,
          B.SERIE,
          B.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL AS TOTAL,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'T' AS TIPO,
          'NCD: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          C.NUMERO::text AS VOUCHER,
          C.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A, VENTA_TRANSFERENCIA B, CONTA_VOUCHER C
    WHERE     A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          AND A.ID_CLIENTE = B.ID_CLIENTE
          AND A.ID_VOUCHER = C.ID_VOUCHER
          AND A.ID_COMPROBANTE IN ('07', '08')
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL

   SELECT A.ID_ENTIDAD, --ANTICIPO (AUTOMATICO) QUE PAGA UNA TRANSFERENCIA QUERY 3.3
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_TRANSFERENCIA,
          A.ID_CLIENTE,
          0 AS ID_SUCURSAL,
          '99' AS ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'T' AS TIPO,
          'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A
          JOIN VENTA_TRANSFERENCIA_DETALLE B
             ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          JOIN VENTA_TRANSFERENCIA C
             ON     A.ID_CLIENTE = C.ID_CLIENTE
                AND B.ID_TRANSFERENCIA_P = C.ID_TRANSFERENCIA
          LEFT JOIN CONTA_VOUCHER D ON A.ID_VOUCHER = D.ID_VOUCHER
    WHERE                                                 --A.ES_ANTICIPO = 'S'
          --AND B.DC = 'C'
          --AND
          A.ESTADO = '1' AND B.IMPORTE <> 0
   
UNION ALL

   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.ID_VENTA,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          A.ID_COMPROBANTE,
          A.ID_MONEDA,
          A.SERIE,
          A.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL AS TOTAL,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'V' AS TIPO,
          'NCD: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          B.NUMERO::text AS VOUCHER,
          B.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A LEFT JOIN CONTA_VOUCHER B ON A.ID_VOUCHER = B.ID_VOUCHER
    WHERE     A.ID_COMPROBANTE IN ('07', '08')
          AND coalesce(A.ID_PARENT::text, '') = ''
          AND coalesce(A.ID_SALDO::text, '') = ''
          AND coalesce(A.ID_TRANSFERENCIA::text, '') = ''
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL

   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          A.ID_PROVEEDOR,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          C.FECHA,
          SUBSTR(B.DETALLE, 0, 50) AS GLOSA,
          B.IMPORTE * -1 AS TOTAL,
          B.IMPORTE_ME * -1 AS TOTAL_ME,
          C.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'D' AS TIPO,
          'DET.-' || A.NRO_OPERACION AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.NUMERO || '-' || A.NRO_OPERACION AS NUMERO_LEGAL
     FROM CAJA_DETRACCION A
          JOIN CAJA_DETRACCION_VENTA B ON A.ID_DETRACCION = B.ID_DETRACCION
          JOIN VENTA C ON B.ID_VENTA = C.ID_VENTA AND A.ID_ANHO = C.ID_ANHO
          LEFT JOIN CONTA_VOUCHER D ON A.ID_VOUCHER = D.ID_VOUCHER
    WHERE A.ESTADO = '1'
)A;


DROP MATERIALIZED VIEW IF EXISTS vwm_sales_mov_ssi;
CREATE MATERIALIZED VIEW vwm_sales_mov_ssi AS
SELECT ID_ENTIDAD,ID_DEPTO,ID_ANHO,ID_MES,ID_VENTA,ID_CLIENTE,ID_SUCURSAL,ID_COMPROBANTE,ID_MONEDA,SERIE,NUMERO,FECHA,GLOSA,TOTAL,TOTAL_ME,ID_TIPOTRANSACCION,ID_TIPOVENTA,TIPO,MOV,VOUCHER,LOTE,TIPO_DOCUMENTO,NUMERO_LEGAL
FROM (
SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.ID_VENTA,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          A.ID_COMPROBANTE,
          A.ID_MONEDA,
          A.SERIE,
          A.NUMERO,
          A.FECHA,
          A.GLOSA,
          A.TOTAL,
          A.TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'V' AS TIPO,
          'VNT: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          B.NUMERO::text AS VOUCHER,
          B.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A LEFT JOIN CONTA_VOUCHER B ON A.ID_VOUCHER = B.ID_VOUCHER
    WHERE     A.ID_COMPROBANTE NOT IN ('07', '08')
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL
                                --DEPOSITOS PAGAN VENTAS QUERY 1.1
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          A.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          B.IMPORTE * -1,
          B.IMPORTE_ME * -1,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'V' AS TIPO,
          'DEP: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '00' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM CAJA_DEPOSITO A,
          CAJA_DEPOSITO_DETALLE B,
          VENTA C,
          CONTA_VOUCHER D
    WHERE     A.ID_DEPOSITO = B.ID_DEPOSITO
          AND B.ID_VENTA = C.ID_VENTA
          AND A.ID_CLIENTE = C.ID_CLIENTE
          AND A.ID_VOUCHER = D.ID_VOUCHER
          AND B.IMPORTE <> 0
   
UNION ALL
                     --NOTAS DE CREDITO AFECTAN A VENTAS QUERY 1.2
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          B.ID_VENTA,
          A.ID_CLIENTE,
          B.ID_SUCURSAL,
          B.ID_COMPROBANTE,
          A.ID_MONEDA,
          B.SERIE,
          B.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL AS TOTAL,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          B.ID_TIPOVENTA,
          'V' AS TIPO,
          'NCD: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          C.NUMERO::text AS VOUCHER,
          C.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A
          JOIN VENTA B
             ON A.ID_PARENT = B.ID_VENTA AND A.ID_CLIENTE = B.ID_CLIENTE
          LEFT JOIN CONTA_VOUCHER C ON A.ID_VOUCHER = C.ID_VOUCHER
    WHERE     A.ID_COMPROBANTE IN ('07', '08')         --FROM VENTA A, VENTA B
          --WHERE A.ID_PARENT = B.ID_VENTA
          --AND A.ID_CLIENTE = B.ID_CLIENTE
          AND A.ID_COMPROBANTE IN ('07', '08')
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL
                       --TRANSFERENCIAS AFECTAN A VENTAS QUERY 1.3
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          A.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'V' AS TIPO,
          'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A
          JOIN VENTA_TRANSFERENCIA_DETALLE B
             ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          JOIN VENTA C
             ON B.ID_VENTA = C.ID_VENTA AND A.ID_CLIENTE = C.ID_CLIENTE
          LEFT JOIN CONTA_VOUCHER D ON A.ID_VOUCHER = D.ID_VOUCHER
    
    WHERE B.IMPORTE <> 0 AND A.ESTADO = '1'
   
UNION ALL

   --TRANSFERENCIAS AFECTAN A ENTRECLIENTES
   SELECT C.ID_ENTIDAD,
          C.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          C.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN B.DC='C' THEN  1  ELSE -1 END  * B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN  1  ELSE -1 END  * B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'V' AS TIPO,
          'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          '' AS VOUCHER,
          '' AS LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A, VENTA_TRANSFERENCIA_DETALLE B, VENTA C
    WHERE     A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          AND B.ID_VENTA_DESTINO = C.ID_VENTA
          AND B.IMPORTE <> 0
          AND A.ESTADO = '1'
          AND A.ES_ENTRECLIENTES = 'S'
   
UNION ALL

   -- DEVOLUCION
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          B.ID_CLIENTE,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          C.GLOSA,
          B.IMPORTE,
          B.IMPORTE_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'P' AS TIPO,
          'DEV: OP.' || A.NUMERO AS MOV,
          '' AS VOUCHER,
          '' AS LOTE,
          '00' AS TIPO_DOCUMENTO,
          A.NUMERO AS NUMERO_LEGAL
     FROM CAJA_PAGO A
          INNER JOIN CAJA_PAGO_VENTA B ON A.ID_PAGO = B.ID_PAGO
          INNER JOIN VENTA C ON B.ID_VENTA = C.ID_VENTA
          LEFT OUTER JOIN TIPO_COMPROBANTE T
             ON T.ID_COMPROBANTE = C.ID_COMPROBANTE
    WHERE A.ESTADO = '1'
   
UNION ALL
                     --NOTAS DE CREDITO AFECTAN AL SALOD QUERY 2.2
   --TRANSFERENCIAS QUE SON DOCUMENTOS A PAGAR QUERY 3
   SELECT DISTINCT A.ID_ENTIDAD,
                   A.ID_DEPTO,
                   A.ID_ANHO,
                   A.ID_MES,
                   A.ID_TRANSFERENCIA AS ID_VENTA,
                   A.ID_CLIENTE,
                   0 AS ID_SUCURSAL,
                   '99' AS ID_COMPROBANTE,
                   A.ID_MONEDA,
                   A.SERIE,
                   A.NUMERO,
                   A.FECHA,
                   A.GLOSA,
                   A.IMPORTE AS TOTAL,
                   A.IMPORTE_ME AS TOTAL_ME,
                   A.ID_TIPOTRANSACCION,
                   A.ID_TIPOVENTA,
                   'T' AS TIPO,
                   'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
                   C.NUMERO::text AS VOUCHER,
                   C.LOTE,
                   '99' AS TIPO_DOCUMENTO,
                   A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A
          JOIN VENTA_TRANSFERENCIA_DETALLE B
             ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          JOIN CONTA_VOUCHER C ON A.ID_VOUCHER = C.ID_VOUCHER
    WHERE     A.ES_ANTICIPO = 'N'
          AND coalesce(B.ID_VENTA::text, '') = ''
          AND coalesce(B.ID_SALDO::text, '') = ''
          AND coalesce(B.ID_TRANSFERENCIA_P::text, '') = ''
          AND A.ESTADO = '1'
          AND A.IMPORTE <> 0 
   
UNION ALL
                        --DEPOSITOS PAGAN TRANSFERENCIAS QUERY 3.1
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_TRANSFERENCIA AS ID_VENTA,
          A.ID_CLIENTE,
          0 AS ID_SUCURSAL,
          '99' AS ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          B.IMPORTE * -1,
          B.IMPORTE_ME * -1,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'T' AS TIPO,
          'DEP: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM CAJA_DEPOSITO A,
          CAJA_DEPOSITO_DETALLE B,
          VENTA_TRANSFERENCIA C,
          CONTA_VOUCHER D
    WHERE     A.ID_DEPOSITO = B.ID_DEPOSITO
          AND B.ID_TRANSFERENCIA = C.ID_TRANSFERENCIA
          AND A.ID_CLIENTE = C.ID_CLIENTE
          AND A.ID_VOUCHER = D.ID_VOUCHER
          AND A.ESTADO = '1'
          AND B.IMPORTE <> 0
   
UNION ALL
             --NOTAS DE CREDITO AFECTAN A TRANSFERENCIAS QUERY 3.2
   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          B.ID_TRANSFERENCIA AS ID_VENTA,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          '99' AS ID_COMPROBANTE,
          A.ID_MONEDA,
          B.SERIE,
          B.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL AS TOTAL,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'T' AS TIPO,
          'NCD: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          C.NUMERO::text AS VOUCHER,
          C.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A, VENTA_TRANSFERENCIA B, CONTA_VOUCHER C
    WHERE     A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          AND A.ID_CLIENTE = B.ID_CLIENTE
          AND A.ID_VOUCHER = C.ID_VOUCHER
          AND A.ID_COMPROBANTE IN ('07', '08')
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL

   SELECT A.ID_ENTIDAD, --ANTICIPO (AUTOMATICO) QUE PAGA UNA TRANSFERENCIA QUERY 3.3
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_TRANSFERENCIA,
          A.ID_CLIENTE,
          0 AS ID_SUCURSAL,
          '99' AS ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE AS TOTAL,
          CASE WHEN B.DC='C' THEN  -1  ELSE 1 END  * B.IMPORTE_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'T' AS TIPO,
          'TRAN: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA_TRANSFERENCIA A
          JOIN VENTA_TRANSFERENCIA_DETALLE B
             ON A.ID_TRANSFERENCIA = B.ID_TRANSFERENCIA
          JOIN VENTA_TRANSFERENCIA C
             ON     A.ID_CLIENTE = C.ID_CLIENTE
                AND B.ID_TRANSFERENCIA_P = C.ID_TRANSFERENCIA
          LEFT JOIN CONTA_VOUCHER D ON A.ID_VOUCHER = D.ID_VOUCHER
    WHERE                                                 --A.ES_ANTICIPO = 'S'
          --AND B.DC = 'C'
          --AND
          A.ESTADO = '1' AND B.IMPORTE <> 0
   
UNION ALL

   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          A.ID_VENTA,
          A.ID_CLIENTE,
          A.ID_SUCURSAL,
          A.ID_COMPROBANTE,
          A.ID_MONEDA,
          A.SERIE,
          A.NUMERO,
          A.FECHA,
          A.GLOSA,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL AS TOTAL,
          CASE WHEN A.ID_COMPROBANTE='07' THEN  -1  ELSE 1 END  * A.TOTAL_ME AS TOTAL_ME,
          A.ID_TIPOTRANSACCION,
          A.ID_TIPOVENTA,
          'V' AS TIPO,
          'NCD: ' || A.SERIE || '-' || A.NUMERO AS MOV,
          B.NUMERO::text AS VOUCHER,
          B.LOTE,
          A.ID_COMPROBANTE AS TIPO_DOCUMENTO,
          A.SERIE || '-' || A.NUMERO AS NUMERO_LEGAL
     FROM VENTA A LEFT JOIN CONTA_VOUCHER B ON A.ID_VOUCHER = B.ID_VOUCHER
    WHERE     A.ID_COMPROBANTE IN ('07', '08')
          AND coalesce(A.ID_PARENT::text, '') = ''
          AND coalesce(A.ID_SALDO::text, '') = ''
          AND coalesce(A.ID_TRANSFERENCIA::text, '') = ''
          AND A.ESTADO = '1'
          AND A.TOTAL <> 0 
   
UNION ALL

   SELECT A.ID_ENTIDAD,
          A.ID_DEPTO,
          A.ID_ANHO,
          A.ID_MES,
          C.ID_VENTA,
          A.ID_PROVEEDOR,
          C.ID_SUCURSAL,
          C.ID_COMPROBANTE,
          A.ID_MONEDA,
          C.SERIE,
          C.NUMERO,
          C.FECHA,
          SUBSTR(B.DETALLE, 0, 50) AS GLOSA,
          B.IMPORTE * -1 AS TOTAL,
          B.IMPORTE_ME * -1 AS TOTAL_ME,
          C.ID_TIPOTRANSACCION,
          C.ID_TIPOVENTA,
          'D' AS TIPO,
          'DET.-' || A.NRO_OPERACION AS MOV,
          D.NUMERO::text AS VOUCHER,
          D.LOTE,
          '99' AS TIPO_DOCUMENTO,
          A.NUMERO || '-' || A.NRO_OPERACION AS NUMERO_LEGAL
     FROM CAJA_DETRACCION A
          JOIN CAJA_DETRACCION_VENTA B ON A.ID_DETRACCION = B.ID_DETRACCION
          JOIN VENTA C ON B.ID_VENTA = C.ID_VENTA AND A.ID_ANHO = C.ID_ANHO
          LEFT JOIN CONTA_VOUCHER D ON A.ID_VOUCHER = D.ID_VOUCHER
    WHERE A.ESTADO = '1'
)A;


