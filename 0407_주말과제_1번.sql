select * from place;


--���ο� �ּ� �÷� ����
ALTER TABLE PLACE
ADD �ּ� VARCHAR(256);

-- null �� üũ�ؼ� ���θ���ü�ּҿ� null�� �ִ� ��� ��������ü�ּ� ����
UPDATE PLACE
SET �ּ� = NVL(���θ���ü�ּ�, ��������ü�ּ�);

-- �ּҰ� null�� ���(���θ���ü�ּҿ� ��������ü�ּ� �� �� null�� ���)������ ����  
DELETE FROM PLACE
WHERE �ּ� IS NULL;

-- �ּҰ� null�� �� Ȯ��
SELECT * FROM PLACE
WHERE �ּ� IS NULL;

-- �ּҿ��� �� ��° �����̽��� �������� �����͸� �ڸ�(��/��/��)
UPDATE PLACE
SET �ּ� = SUBSTR(�ּ�, 1, INSTR(�ּ�, ' ', 1, 2) - 1);

SELECT * FROM PLACE;

-- COUNT(*)���� 10 �����̸� DELETE
DELETE FROM PLACE
WHERE �ּ� IN (
  SELECT �ּ�
  FROM PLACE
  GROUP BY �ּ�
  HAVING COUNT(*) <= 10
)
-- �ּҸ� �������� count(*)
SELECT �ּ�, COUNT(*)
FROM PLACE
GROUP BY �ּ�
ORDER BY COUNT(*) DESC;

SELECT * FROM CUSTOMER;
DESC CUSTOMER;

-- ���ο� CUSTOMER�� �ּҰ��� ������ CUSTOMERADD ���̺� ����
CREATE TABLE CUSTOMERADD (
  ADDRESS1 VARCHAR2(100)
);

-- CUSTOMERADD ���̺� Ȯ��
SELECT *
FROM CUSTOMERADD;

-- CUSTOMERADD ���̺� ADDRESS1 �� �ֱ�
INSERT INTO CUSTOMERADD (ADDRESS1)
SELECT ADDRESS1
FROM CUSTOMER;

-- CUSTOMERADD ���̺��� DCODE�� �ּ� ��ȯ
UPDATE CUSTOMERADD SET ADDRESS1 
= DECODE(SUBSTR(ADDRESS1,1,2), '����', '����Ư����',
'���', '��걤����',
'�λ�', '�λ걤����',
'����', '����������',
'��õ', '��õ������',
'�뱸', '�뱸������',
'����', '���ֱ�����',
'����', '����Ư����ġ��',
'���', '��⵵',
'����', '������',
'����', '���󳲵�',
'����', '����ϵ�',
'�泲', '��û����',
'���', '��û�ϵ�',
'�泲', '��󳲵�',
'���', '���ϵ�',
'����', '����Ư����ġ��') || ' ' ||SUBSTR(ADDRESS1,4,(INSTR(ADDRESS1,' ',1,1)));

-- CUSTOMERADD ���̺��� ���ڿ� ������ �� ���� ������ �ִ� ��� ����
UPDATE CUSTOMERADD
SET ADDRESS1 = RTRIM(ADDRESS1)
WHERE ADDRESS1 LIKE '% ';

-- CUSOMERADD ���̺� Ȯ��
SELECT * FROM CUSTOMERADD;

-- PLACE�� CUSTOMERADD ���̺��� �ּ�, ADDRESS�� �������� JOIN 
SELECT A.ADDRESS1, A.���� AS ���ο��� , B.���� AS �����������⼳ġ������, ROUND(A.����/ B.����, 2) AS ����������
FROM
(SELECT ADDRESS1, COUNT(*) AS ����
FROM CUSTOMERADD
GROUP BY ADDRESS1) A
JOIN
(SELECT �ּ�, COUNT(*) AS ����
FROM PLACE
WHERE �ּ� IS NOT NULL
GROUP BY �ּ�) B
ON A.ADDRESS1=B.�ּ�
ORDER BY ����������;
--ORDER BY �����������⼳ġ������ DESC;

-- CUSTOMER���� �ּҰ� ��⵵ ȭ���� ��� ��ȸ
SELECT * 
FROM CUSTOMER
WHERE ADDRESS1 LIKE '%��� ȭ��%';
-- CUSTOMER���� �ּҰ� ��⵵ ȭ���� ��� ��ȸ
SELECT * 
FROM CUSTOMER
WHERE ADDRESS1 LIKE '%��õ ����%';
-- PLACE���� �ּҰ� ��õ������ ������ ��� ��ȸ
SELECT *
FROM PLACE
WHERE �ּ� LIKE '%��õ������ ����%';


SELECT ADDRESS, COUNT(*)
FROM CUSTOMERADD
GROUP BY ADDRESS
ORDER BY COUNT(*) AS DESC;

SELECT * 
FROM CUSTOMER;

-- [������] ��õ ������ ��� ���� �����豺 �� 60�� �̻� & ���ſ���(ī���ѵ� 500���� ����)������ ����ũ ���� ����ǰ ����
-- ���ο� ���̺� MARKETING����  

CREATE TABLE MARKETING AS
SELECT NAME, ADDRESS1, ADDRESS2, MOBILE_NO, CREDIT_LIMIT, BIRTH_DT,
       TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTH_DT)/12) AS AGE
FROM CUSTOMER
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTH_DT)/12) >= 60 AND CREDIT_LIMIT <= 200 AND ADDRESS1 LIKE '%��õ ����%'; 

-- ������ ���̺� ����    
SELECT * 
FROM MARKETING;
