/************************************
   조인 실습 - 1
*************************************/

-- 직원 정보와 직원이 속한 부서명을 가져오기
SELECT A.*, B.DNAME
FROM HR.EMP A
         JOIN HR.DEPT B ON A.DEPTNO = B.DEPTNO;

-- JOB이 SALESMAN인 직원정보와 직원이 속한 부서명을 가져오기.
SELECT A.*, B.DNAME
FROM HR.EMP A
         JOIN HR.DEPT B ON A.DEPTNO = B.DEPTNO
WHERE JOB = 'SALESMAN';

-- 부서명 SALES와 RESEARCH의 소속 직원들의 부서명, 직원번호, 직원명, JOB 그리고 과거 급여 정보 추출
SELECT A.DNAME, B.EMPNO, B.ENAME, B.JOB, C.FROMDATE, C.TODATE, C.SAL
FROM HR.DEPT A
         JOIN HR.EMP B ON A.DEPTNO = B.DEPTNO
         JOIN HR.EMP_SALARY_HIST C ON B.EMPNO = C.EMPNO
WHERE A.DNAME IN('SALES', 'RESEARCH')
ORDER BY A.DNAME, B.EMPNO, C.FROMDATE;

-- 부서명 SALES와 RESEARCH의 소속 직원들의 부서명, 직원번호, 직원명, JOB 그리고 과거 급여 정보중 1983년 이전 데이터는 무시하고 데이터 추출
SELECT A.DNAME, B.EMPNO, B.ENAME, B.JOB, C.FROMDATE, C.TODATE, C.SAL
FROM HR.DEPT A
         JOIN HR.EMP B ON A.DEPTNO = B.DEPTNO
         JOIN HR.EMP_SALARY_HIST C ON B.EMPNO = C.EMPNO
WHERE  A.DNAME IN('SALES', 'RESEARCH')
  AND FROMDATE >= TO_DATE('19830101', 'YYYYMMDD')
ORDER BY A.DNAME, B.EMPNO, C.FROMDATE;

-- 부서명 SALES와 RESEARCH 소속 직원별로 과거부터 현재까지 모든 급여를 취합한 평균 급여
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



-- 직원명 SMITH의 과거 소속 부서 정보를 구할 것.
SELECT A.ENAME, A.EMPNO, B.DEPTNO, C.DNAME, B.FROMDATE, B.TODATE
FROM HR.EMP A
         JOIN HR.EMP_DEPT_HIST B ON A.EMPNO = B.EMPNO
         JOIN HR.DEPT C ON B.DEPTNO = C.DEPTNO
WHERE A.ENAME = 'SMITH';

/************************************
   조인 실습 - 2
*************************************/

-- 고객명 ANTONIO MORENO이 1997년에 주문한 주문 정보를 주문 아이디, 주문일자, 배송일자, 배송 주소를 고객 주소와 함께 구할것.
SELECT A.CONTACT_NAME, A.ADDRESS, B.ORDER_ID, B.ORDER_DATE, B.SHIPPED_DATE, B.SHIP_ADDRESS
FROM NW.CUSTOMERS A
         JOIN NW.ORDERS B ON A.CUSTOMER_ID = B.CUSTOMER_ID
WHERE A.CONTACT_NAME = 'ANTONIO MORENO'
  AND B.ORDER_DATE BETWEEN TO_DATE('19970101', 'YYYYMMDD') AND TO_DATE('19971231', 'YYYYMMDD')
;

-- BERLIN에 살고 있는 고객이 주문한 주문 정보를 구할것
-- 고객명, 주문ID, 주문일자, 주문접수 직원명, 배송업체명을 구할것.
SELECT A.CUSTOMER_ID, A.CONTACT_NAME, B.ORDER_ID, B.ORDER_DATE
     , C.FIRST_NAME||' '||C.LAST_NAME AS EMPLOYEE_NAME, D.COMPANY_NAME AS SHIPPER_NAME
FROM NW.CUSTOMERS A
         JOIN NW.ORDERS B ON A.CUSTOMER_ID = B.CUSTOMER_ID
         JOIN NW.EMPLOYEES C ON B.EMPLOYEE_ID = C.EMPLOYEE_ID
         JOIN NW.SHIPPERS D ON B.SHIP_VIA = D.SHIPPER_ID
WHERE A.CITY = 'BERLIN';

--BEVERAGES 카테고리에 속하는 모든 상품아이디와 상품명, 그리고 이들 상품을 제공하는 SUPPLIER 회사명 정보 구할것
SELECT A.CATEGORY_ID, A.CATEGORY_NAME, B.PRODUCT_ID, B.PRODUCT_NAME, C.SUPPLIER_ID, C.COMPANY_NAME
FROM NW.CATEGORIES A
         JOIN NW.PRODUCTS B ON A.CATEGORY_ID = B.CATEGORY_ID
         JOIN NW.SUPPLIERS C ON B.SUPPLIER_ID = C.SUPPLIER_ID
WHERE CATEGORY_NAME = 'BEVERAGES';


-- 고객명 ANTONIO MORENO이 1997년에 주문한 주문 상품정보를 고객 주소, 주문 아이디, 주문일자, 배송일자, 배송 주소 및
-- 주문 상품아이디, 주문 상품명, 주문 상품별 금액, 주문 상품이 속한 카테고리명, SUPPLIER명을 구할 것.
SELECT A.CONTACT_NAME, A.ADDRESS, B.ORDER_ID, B.ORDER_DATE, B.SHIPPED_DATE, B.SHIP_ADDRESS
     , C.PRODUCT_ID, D.PRODUCT_NAME, C.AMOUNT, E.CATEGORY_NAME, F.CONTACT_NAME AS SUPPLIER_NAME
FROM NW.CUSTOMERS A
         JOIN NW.ORDERS B ON A.CUSTOMER_ID = B.CUSTOMER_ID
         JOIN NW.ORDER_ITEMS C ON B.ORDER_ID = C.ORDER_ID
         JOIN NW.PRODUCTS D ON C.PRODUCT_ID = D.PRODUCT_ID
         JOIN NW.CATEGORIES E ON D.CATEGORY_ID = E.CATEGORY_ID
         JOIN NW.SUPPLIERS F ON D.SUPPLIER_ID = F.SUPPLIER_ID
WHERE A.CONTACT_NAME = 'ANTONIO MORENO'
  AND B.ORDER_DATE BETWEEN TO_DATE('19970101', 'YYYYMMDD') AND TO_DATE('19971231', 'YYYYMMDD')
;