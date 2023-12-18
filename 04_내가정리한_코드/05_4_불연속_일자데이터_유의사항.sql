-- 연속된 매출 일자에서 매출이 NULL일때와 그렇지 않을 때의 AGGREGATE ANALYTIC 결과 차이.
WITH REF_DAYS
         AS (
        SELECT GENERATE_SERIES('1996-07-04'::DATE , '1996-07-23'::DATE, '1 DAY'::INTERVAL)::DATE AS ORD_DATE
    ),
     TEMP_01 AS (
         SELECT DATE_TRUNC('DAY', B.ORDER_DATE)::DATE AS ORD_DATE, SUM(AMOUNT) AS DAILY_SUM
         FROM ORDER_ITEMS A
                  JOIN ORDERS B ON A.ORDER_ID = B.ORDER_ID
         GROUP BY DATE_TRUNC('DAY', B.ORDER_DATE)::DATE
    ),
    TEMP_02 AS (
SELECT A.ORD_DATE, B.DAILY_SUM AS DAILY_SUM
FROM REF_DAYS A
    LEFT JOIN TEMP_01 B ON A.ORD_DATE = B.ORD_DATE
    )
SELECT ORD_DATE, DAILY_SUM
     -- 매출이 없을때(NULL)일때 계산이 안됨
     , AVG(DAILY_SUM) OVER (ORDER BY ORD_DATE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MA_3DAYS
     -- 0으로 바꿔서 계산하도록 해야한다.
     , AVG(COALESCE(DAILY_SUM)) OVER (ORDER BY ORD_DATE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MA_3DAYS
FROM TEMP_02;