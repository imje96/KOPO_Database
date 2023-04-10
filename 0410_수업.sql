-- SINGLE COLUMN,SINGLE ROW
SELECT ENAME, JOB FROM EMP
WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'SMITH');

SELECT ENMAE, SAL FROM EMP WHERE SAL < (SELECT AVG(SAL) FROM EMP);

SELECT DEPTNO,ENAME,JOB,SAL,( SELECT ROUND(AVG(SAL),0)
FROM EMP S WHERE S.JOB=M.JOB) AS JOB_AVG_SAL
FROM EMP M
ORDER BY JOB;

-- single colum, multiple row
select enaem, job from emp where deptno = 10, 30;
select ename, job from emp where deptno in (10,30);
-- 3인 이상 근무 부서 정보 조회 
select dname, loc from dept 
where deptno = (select deptno from emp group by deptno having count(*) > 3);

-- MULTIPLE COLUMN, MULTIPLE ROW RETURN
SELECT DEPTNO, JOB, ENAME, SAL FROM EMP
    WHERE (DEPTNO, JOB) IN (SELECT DEPTNO, JOB FROM EMP
                            GROUP BY DEPTNO, JOB HAVING AVG(SAL) > 2000);

SELECT DEPTNO, JOB FROM EMP GROUP BY DEPTNO, JOB HAVING AVG(SAL) > 2000;


select deptno, job, ename, sal from emp
where (deptno, job) in (select deptno, job from emp
group by deptno, job having avg(sal) > 2000;

SELECT DEPTNO,ENAME,JOB,SAL,( SELECT ROUND(AVG(SAL),0)
FROM EMP S WHERE S.JOB=M.JOB) AS JOB_AVG_SAL
FROM EMP M
ORDER BY JOB;

-- SCALAR SUBQUERY
SELECT DEPTNO,ENAME,JOB,SAL,( SELECT ROUND(AVG(SAL),0)
FROM EMP S WHERE S.JOB=M.JOB) AS JOB_AVG_SAL
FROM EMP M
ORDER BY JOB;

-- SCALAR SUBQUERY
SELECT DEPTNO, ENAME, JOB, SAL, (SELECT ROUND(AVG(SAL),0) FROM EMP S
WHERE S.JOB=M.JOB)
FROM EMP M
ORDER BY JOB;

-- CORREALATED SUBQUERY
SELECT DEPTNO, ENAME, JOB, SAL FROM EMP M
WHERE SAL > (SELECT AVG(SAL) AS AVG_SAL FROM EMP WHERE JOB = M.JOB);

-- IN-LINE VIEW
-- 부서별로 사원의 정보를 조회하면서, 각 직무별 평균급여보다 높은 급여를 받는 사원들의 정보를 조합 
-- 평균급여보다 높은 급여를 받는 사원을 계산하려면 셀렉트를 두번 해야 함 ?
SELECT DEPTNO, ENAME, EMP.JOB, SAL, A.AVG_SAL
FROM EMP, (SELECT JOB, ROUND(AVG(SAL)) AS AVG_SAL FROM EMP GROUP BY JOB) A
WHERE EMP.JOB = A.JOB AND SAL > A.AVG_SAL
ORDER BY DEPTNO, SAL DESC;

-- TOP-N, BOTTOM-M
-- 급여를 가장 적게 받는 5명 추출 
SELECT * 
FROM (SELECT EMPNO, ENAME, SAL FROM EMP ORDER BY SAL ASC) BM
WHERE ROWNUM <= 5;

-- 급여를 가장 많이 받는 4명 추출
SELECT TN.EMPNO, TN.ENAME, TN.SAL
FROM (SELECT EMPNO, ENAME, SAL FROM EMP ORDER BY SAL DESC) TN
WHERE ROWNUM < 5;


-- DML과 SUBQUERY
-- SUBQUERY로 N개 ROW INSERT
INSERT INTO BONUS(ENAME,JOB,SAL,COMM) SELECT ENAME,JOB,SAL,COMM FROM EMP;
SELECT * FROM BONUS;
ROLLBACK;
SELECT * FROM BONUS;

SELECT * FROM EMP;

-- 부서별 성과별 보너스 계산 후(데이터 연산) N개 ROW INSERT + 데이터 연산(가공)
INSERT INTO BONUS(ENAME,JOB,SAL,COMM)
SELECT ENAME,JOB,SAL,DECODE(DEPTNO,10,SAL*0.3,20,SAL*0.2)+ NVL(COMM,0) 
FROM EMP WHERE DEPTNO IN (10,20);

ROLLBACK;

SELECT * FROM BONUS;
COMMIT;


-- 평상시 COMM을 받지 못하는 사원들에게 평균 COMM 금액의 50%를 보너스로 지급
UPDATE EMP SET COMM = (SELECT AVG(COMM)/2 FROM EMP)
WHERE COMM IS NULL OR COMM = 0;
ROLLBACK;
SELECT * FROM EMP;

-- 평균 이상의 급여를 받는 사원들은 보너스 지급 대상자에서 제외
DELETE FROM BONUS WHERE SAL > (SELECT AVG(SAL) FROM EMP);
SELECT * FROM BONUS;
COMMIT;
