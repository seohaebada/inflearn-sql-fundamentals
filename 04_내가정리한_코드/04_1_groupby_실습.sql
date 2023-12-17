/************************************
   GROUP BY 실습 - 01
*************************************/

-- EMP 테이블에서 부서별 최대 급여, 최소 급여, 평균 급여를 구할것.
SELECT DEPTNO, MAX(SAL) AS MAX_SAL, MIN(SAL) AS MIN_SAL, ROUND(AVG(SAL), 2) AS AVG_SAL
FROM HR.EMP
GROUP BY DEPTNO
;

-- EMP 테이블에서 부서별 최대 급여, 최소 급여, 평균 급여를 구하되 평균 급여가 2000 이상인 경우만 추출.
SELECT DEPTNO, MAX(SAL) AS MAX_SAL, MIN(SAL) AS MIN_SAL, ROUND(AVG(SAL), 2) AS AVG_SAL
FROM HR.EMP
GROUP BY DEPTNO
HAVING AVG(SAL) >= 2000
;

-- EMP 테이블에서 부서별 최대 급여, 최소 급여, 평균 급여를 구하되 평균 급여가 2000 이상인 경우만 추출(WITH 절을 이용)
WITH
    TEMP_01 AS (
        SELECT DEPTNO, MAX(SAL) AS MAX_SAL, MIN(SAL) AS MIN_SAL, ROUND(AVG(SAL), 2) AS AVG_SAL
        FROM HR.EMP
        GROUP BY DEPTNO
    )
SELECT * FROM TEMP_01 WHERE AVG_SAL >= 2000;


-- 부서명 SALES와 RESEARCH 소속 직원별로 과거부터 현재까지 모든 급여를 취합한 평균 급여
SELECT B.EMPNO, MAX(B.ENAME) AS ENAME, AVG(C.SAL) AS AVG_SAL --, COUNT(*) AS CNT
FROM HR.DEPT A
         JOIN HR.EMP B ON A.DEPTNO = B.DEPTNO
         JOIN HR.EMP_SALARY_HIST C ON B.EMPNO = C.EMPNO
WHERE  A.DNAME IN('SALES', 'RESEARCH')
GROUP BY B.EMPNO
ORDER BY 1;

-- 부서명 SALES와 RESEARCH 소속 직원별로 과거부터 현재까지 모든 급여를 취합한 평균 급여(WITH 절로 풀기)
WITH
    TEMP_01 AS
        (
            SELECT A.DNAME, B.EMPNO, B.ENAME, B.JOB, C.FROMDATE, C.TODATE, C.SAL
            FROM HR.DEPT A
                     JOIN HR.EMP B ON A.DEPTNO = B.DEPTNO
                     JOIN HR.EMP_SALARY_HIST C ON B.EMPNO = C.EMPNO
            WHERE  A.DNAME IN('SALES', 'RESEARCH')
            ORDER BY A.DNAME, B.EMPNO, C.FROMDATE
        )
SELECT EMPNO, MAX(ENAME) AS ENAME, AVG(SAL) AS AVG_SAL
FROM TEMP_01
GROUP BY EMPNO;

-- 부서명 SALES와 RESEARCH 부서별 평균 급여를 소속 직원들의 과거부터 현재까지 모든 급여를 취합하여 구할것.
-- A.DNAME 은 DEPTNO에 대해서 1건이므로 MAX써서 가져옴
SELECT A.DEPTNO, MAX(A.DNAME) AS DNAME, AVG(C.SAL) AS AVG_SAL, COUNT(*) AS CNT
FROM HR.DEPT A
         JOIN HR.EMP B ON A.DEPTNO = B.DEPTNO
         JOIN HR.EMP_SALARY_HIST C ON B.EMPNO = C.EMPNO
WHERE  A.DNAME IN('SALES', 'RESEARCH')
GROUP BY A.DEPTNO
ORDER BY 1;

-- 부서명 SALES와 RESEARCH 부서별 평균 급여를 소속 직원들의 과거부터 현재까지 모든 급여를 취합하여 구할것(WITH절로 풀기)
WITH
    TEMP_01 AS
        (
            SELECT A.DEPTNO, A.DNAME, B.EMPNO, B.ENAME, B.JOB, C.FROMDATE, C.TODATE, C.SAL
            FROM HR.DEPT A
                     JOIN HR.EMP B ON A.DEPTNO = B.DEPTNO
                     JOIN HR.EMP_SALARY_HIST C ON B.EMPNO = C.EMPNO
            WHERE  A.DNAME IN('SALES', 'RESEARCH')
            ORDER BY A.DNAME, B.EMPNO, C.FROMDATE
        )
SELECT DEPTNO, MAX(DNAME) AS DNAME, AVG(SAL) AS AVG_SAL
FROM TEMP_01
GROUP BY DEPTNO
ORDER BY 1;