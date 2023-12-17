/************************************
   조인 실습 - FULL OUTER 조인.
*************************************/

-- DEPT는 소속 직원이 없는 경우 존재. 하지만 직원은 소속 부서가 없는 경우가 없음.
SELECT A.*, B.EMPNO, B.ENAME
FROM HR.DEPT A
         LEFT JOIN HR.EMP B ON A.DEPTNO = B.DEPTNO;

-- FULL OUTER JOIN 테스트를 위해 소속 부서가 없는 테스트용 데이터 생성.
DROP TABLE IF EXISTS HR.EMP_TEST;

CREATE TABLE HR.EMP_TEST
AS
SELECT * FROM HR.EMP;

SELECT * FROM HR.EMP_TEST;

-- 소속 부서를 NULL로 UPDATE
UPDATE HR.EMP_TEST SET DEPTNO = NULL WHERE EMPNO=7934;

SELECT * FROM HR.EMP_TEST;

-- DEPT를 기준으로 LEFT OUTER 조인시에는 소속직원이 없는 부서는 추출 되지만. 소속 부서가 없는 직원은 추출할 수 없음.
SELECT A.*, B.EMPNO, B.ENAME
FROM HR.DEPT A
         LEFT JOIN HR.EMP_TEST B ON A.DEPTNO = B.DEPTNO;

-- FULL OUTER JOIN 하여 양쪽 모두의 집합이 누락되지 않도록 함.
SELECT A.*, B.EMPNO, B.ENAME
FROM HR.DEPT A
         FULL OUTER JOIN HR.EMP_TEST B ON A.DEPTNO = B.DEPTNO;
