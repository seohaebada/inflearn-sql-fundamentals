/************************************
   조인 실습 - NON EQUI 조인과 CROSS 조인.
*************************************/
-- 직원정보와 급여등급 정보를 추출.
SELECT A.*, B.GRADE AS SALGRADE
FROM HR.EMP A
         JOIN HR.SALGRADE B ON A.SAL BETWEEN B.LOSAL AND B.HISAL;


-- 직원 급여의 이력정보를 나타내며, 해당 급여를 가졌던 시점에서의 부서번호도 함께 가져올것.
SELECT *
FROM HR.EMP_SALARY_HIST A
         JOIN HR.EMP_DEPT_HIST B ON A.EMPNO = B.EMPNO AND A.FROMDATE BETWEEN B.FROMDATE AND B.TODATE;

-- CROSS 조인
WITH
    TEMP_01 AS (
        SELECT 1 AS RNUM
        UNION ALL
        SELECT 2 AS RNUM
    )
SELECT A.*, B.*
FROM HR.DEPT A
         CROSS JOIN TEMP_01 B;