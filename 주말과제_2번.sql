SELECT D.DNAME AS 부서명,
       STDDEV(담당고객수) AS 표준편차
FROM (
    SELECT D.DEPTNO, TRUNC(COUNT(DISTINCT C.ID) / COUNT(DISTINCT E.EMPNO),2) AS 담당고객수
    FROM CUSTOMER C
    INNER JOIN EMP E ON C.ACCOUNT_MGR = E.EMPNO
    INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
    GROUP BY D.DEPTNO, E.EMPNO
) SUB
INNER JOIN DEPT D ON SUB.DEPTNO = D.DEPTNO
GROUP BY D.DNAME;

-- spool csv

set heading on
set pagesize 300
set echo off
set term off
set trimspool on
set linesize 300
set feedback off
set timing off
spool/home/oracle/conn_dbms.csv
SELECT D.DNAME AS 부서명,
       STDDEV(담당고객수) AS 표준편차
FROM (
    SELECT D.DEPTNO, TRUNC(COUNT(DISTINCT C.ID) / COUNT(DISTINCT E.EMPNO),2) AS 담당고객수
    FROM CUSTOMER C
    INNER JOIN EMP E ON C.ACCOUNT_MGR = E.EMPNO
    INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
    GROUP BY D.DEPTNO, E.EMPNO
) SUB
INNER JOIN DEPT D ON SUB.DEPTNO = D.DEPTNO
GROUP BY D.DNAME;
spool off


-- 기타 히스토리

select * from emp;

select * from customer;


select * from customer
where account_mgr like '%7900%';

select * from customer;
select * from dept;
select * from emp;

select * from mgmt;




select e.empno, e.job, e.ename, e.mgr,e.deptno,d.loc
from emp e, dept d 
where e.deptno=d.deptno;
where e.deptno (+)= d.deptno 
-- 40번 부서 null값 출력

select e.empno, e.ename, e.job, c.name
from emp e, customer c
where e.empno = c.account_mgr;


select c.name as 고객명, c.mobile_no as 휴대폰번호, e.ename as 관리자_이름, 
    e.job as 관리자_직무, d.loc as 담당지점
from customer c, emp e, dept d
where c.account_mgr = e.empno
and e.deptno = d.deptno;

SELECT * FROM CUSTOMER;
SELECT * FROM DEPT;

drop table c_mgmt;

CREATE TABLE C_MGMT(
    name VARCHAR2(50),
    cellphone VARCHAR2(20),
    address VARCHAR2(100),
    mgr_name VARCHAR2(50),
    mgr_job VARCHAR2(30),
    mgr_loc VARCHAR2(50)
);


# SQL 쿼리 실행
dbSendQuery(conn, "CREATE TABLE MGMT(
    name VARCHAR(50),
    phone VARCHAR(20),
    address VARCHAR(70),
    mgr_name VARCHAR(50),
    mgr_job VARCHAR(30),
    mgr_loc VARCHAR(50)
)")

DROP TABLE MGMT;

# SQL 쿼리 실행 결과를 데이터프레임으로 반환
test <- dbGetQuery(conn, "SELECT * FROM MGMT")

dbSendQuery(conn, "INSERT INTO MGMT(name, phone, address, mgr_name, mgr_job, mgr_loc)
SELECT C.NAME AS name, C.MOBILE_NO AS phone, C.ADDRESS1 AS address, 
E.ENAME AS mgr_name, E.JOB AS mgr_job, D.LOC AS mgr_loc
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO (+)= D.DEPTNO
AND C.ADDRESS1 LIKE '서울%'")



INSERT INTO mgmt(name, phone, address, mgr_name, mgr_job, mgr_loc)
SELECT C.NAME AS name, C.MOBILE_NO AS phone, C.ADDRESS1 AS address, 
E.ENAME AS mgr_name, E.JOB AS mgr_job, D.LOC AS mgr_loc
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO (+)= D.DEPTNO
AND C.ADDRESS1 LIKE '서울%'
AND ROWNUM <= 200;

-- mgmt 테이블에 삽입
#
INSERT INTO MGMT(NAME, PHONE, ADDRESS, MGR_NAME, MGR_JOB, MGR_LOC)
SELECT C.NAME AS NAME, C.MOBILE_NO AS PHONE, C.ADDRESS1 AS ADDRESS,
E.ENAME AS MGR_NAME, E.JOB AS MGR_JOB, D.LOC AS MGR_LOC
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO (+)= D.DEPTNO
AND C.ADDRESS1 LIKE '서울%'
AND ROWNUM <= 200;

SELECT C.NAME AS 고객명, C.MOBILE_NO AS 휴대폰번호, E.ENAME AS 관리자_이름, 
E.JOB AS 관리자_직무, D.LOC AS 담당지점
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO (+)= D.DEPTNO
AND C.ADDRESS1 LIKE '서울%'
AND D.LOC LIKE 'CHICAGO';


SELECT C.NAME AS 고객명, C.MOBILE_NO AS 휴대폰번호, C.ADDRESS1 AS 주소, E.ENAME AS 관리자_이름, 
E.JOB AS 관리자_직무, D.LOC AS 담당지점
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO (+)= D.DEPTNO
AND C.ADDRESS1 LIKE '서울%'
AND ROWNUM <= 200;

SELECT * FROM C_MGMT;

SELECT C.NAME AS 고객명, C.MOBILE_NO AS 휴대폰번호, TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTH_DT)/12) AS 나이, E.ENAME AS 관리자_이름, 
E.JOB AS 관리자_직무, D.LOC AS 담당지점
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO (+)= D.DEPTNO
AND D.LOC LIKE 'NEW_YORK'
AND ROWNUM <= 200;


SELECT C.NAME AS NAME, C.MOBILE_NO AS PHONE, C.ADDRESS1 AS ADDRESS,
E.ENAME AS MGR_NAME, E.JOB AS MGR_JOB, D.LOC AS MGR_LOC
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO (+)= D.DEPTNO
AND C.ADDRESS1 LIKE '서울%';

SELECT * FROM DEPT;

DROP TABLE mg;

ROLLBACK;
CREATE TABLE C_MGMT2(
    고객명 VARCHAR2(50),
    휴대폰번호 VARCHAR2(20),
    관리자_이름 VARCHAR2(50),
    관리자_직무 VARCHAR2(30),
    담당지점 VARCHAR2(50)
);

INSERT INTO C_MGMT2(고객명, 휴대폰번호, 관리자_이름, 관리자_직무, 담당지점)
SELECT C.NAME AS 고객명, C.MOBILE_NO AS 휴대폰번호, E.ENAME AS 관리자_이름, 
E.JOB AS 관리자_직무, D.LOC AS 담당지점
FROM CUSTOMER C, EMP E, DEPT D
WHERE C.ACCOUNT_MGR = E.EMPNO
AND E.DEPTNO = D.DEPTNO;
--AND ROWNUM <= 200;

ROLLBACK;
-- 시카고 지점의 관리자별 고객
SELECT * FROM C_MGMT;

SELECT 관리자_직무,COUNT(*)
FROM C_MGMT
GROUP BY 관리자_직무;
