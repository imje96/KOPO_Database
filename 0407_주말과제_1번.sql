select * from place;


--새로운 주소 컬럼 생성
ALTER TABLE PLACE
ADD 주소 VARCHAR(256);

-- null 값 체크해서 도로명전체주소에 null이 있는 경우 소재지전체주소 넣음
UPDATE PLACE
SET 주소 = NVL(도로명전체주소, 소재지전체주소);

-- 주소가 null인 경우(도로명전체주소와 소재지전체주소 둘 다 null인 경우)데이터 삭제  
DELETE FROM PLACE
WHERE 주소 IS NULL;

-- 주소가 null인 값 확인
SELECT * FROM PLACE
WHERE 주소 IS NULL;

-- 주소에서 두 번째 스페이스를 기준으로 데이터를 자름(시/군/구)
UPDATE PLACE
SET 주소 = SUBSTR(주소, 1, INSTR(주소, ' ', 1, 2) - 1);

SELECT * FROM PLACE;

-- COUNT(*)값이 10 이하이면 DELETE
DELETE FROM PLACE
WHERE 주소 IN (
  SELECT 주소
  FROM PLACE
  GROUP BY 주소
  HAVING COUNT(*) <= 10
)
-- 주소를 기준으로 count(*)
SELECT 주소, COUNT(*)
FROM PLACE
GROUP BY 주소
ORDER BY COUNT(*) DESC;

SELECT * FROM CUSTOMER;
DESC CUSTOMER;

-- 새로운 CUSTOMER의 주소값을 저장할 CUSTOMERADD 테이블 생성
CREATE TABLE CUSTOMERADD (
  ADDRESS1 VARCHAR2(100)
);

-- CUSTOMERADD 테이블 확인
SELECT *
FROM CUSTOMERADD;

-- CUSTOMERADD 테이블에 ADDRESS1 값 넣기
INSERT INTO CUSTOMERADD (ADDRESS1)
SELECT ADDRESS1
FROM CUSTOMER;

-- CUSTOMERADD 테이블에서 DCODE로 주소 변환
UPDATE CUSTOMERADD SET ADDRESS1 
= DECODE(SUBSTR(ADDRESS1,1,2), '서울', '서울특별시',
'울산', '울산광역시',
'부산', '부산광역시',
'대전', '대전광역시',
'인천', '인천광역시',
'대구', '대구광역시',
'광주', '광주광역시',
'세종', '세종특별자치시',
'경기', '경기도',
'강원', '강원도',
'전남', '전라남도',
'전북', '전라북도',
'충남', '충청남도',
'충북', '충청북도',
'경남', '경상남도',
'경북', '경상북도',
'제주', '제주특별자치도') || ' ' ||SUBSTR(ADDRESS1,4,(INSTR(ADDRESS1,' ',1,1)));

-- CUSTOMERADD 테이블에서 문자열 오른쪽 맨 끝에 공백이 있는 경우 제거
UPDATE CUSTOMERADD
SET ADDRESS1 = RTRIM(ADDRESS1)
WHERE ADDRESS1 LIKE '% ';

-- CUSOMERADD 테이블 확인
SELECT * FROM CUSTOMERADD;

-- PLACE와 CUSTOMERADD 테이블을 주소, ADDRESS를 기준으로 JOIN 
SELECT A.ADDRESS1, A.갯수 AS 고객인원수 , B.갯수 AS 오염물질배출설치사업장수, ROUND(A.갯수/ B.갯수, 2) AS 사업장대비고객수
FROM
(SELECT ADDRESS1, COUNT(*) AS 갯수
FROM CUSTOMERADD
GROUP BY ADDRESS1) A
JOIN
(SELECT 주소, COUNT(*) AS 갯수
FROM PLACE
WHERE 주소 IS NOT NULL
GROUP BY 주소) B
ON A.ADDRESS1=B.주소
ORDER BY 사업장대비고객수;
--ORDER BY 오염물질배출설치사업장수 DESC;

-- CUSTOMER에서 주소가 경기도 화성인 경우 조회
SELECT * 
FROM CUSTOMER
WHERE ADDRESS1 LIKE '%경기 화성%';
-- CUSTOMER에서 주소가 경기도 화성인 경우 조회
SELECT * 
FROM CUSTOMER
WHERE ADDRESS1 LIKE '%인천 서구%';
-- PLACE에서 주소가 인천광역시 서구인 경우 조회
SELECT *
FROM PLACE
WHERE 주소 LIKE '%인천광역시 서구%';


SELECT ADDRESS, COUNT(*)
FROM CUSTOMERADD
GROUP BY ADDRESS
ORDER BY COUNT(*) AS DESC;

SELECT * 
FROM CUSTOMER;

-- [마케팅] 인천 서구에 사는 질병 고위험군 만 60세 이상 & 저신용자(카드한도 500만원 이하)고객에게 마스크 등의 생필품 지원
-- 새로운 테이블 MARKETING생성  

CREATE TABLE MARKETING AS
SELECT NAME, ADDRESS1, ADDRESS2, MOBILE_NO, CREDIT_LIMIT, BIRTH_DT,
       TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTH_DT)/12) AS AGE
FROM CUSTOMER
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTH_DT)/12) >= 60 AND CREDIT_LIMIT <= 200 AND ADDRESS1 LIKE '%인천 서구%'; 

-- 마케팅 테이블 생성    
SELECT * 
FROM MARKETING;
