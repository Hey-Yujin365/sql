/*
계층형 쿼리
    테이블에 계층형 데이터가 존재하는 경우 그 데이터를 조회하기 위해서 사용하는 쿼리다.
    * 계층형 데이터란 동일한 테이블에 계층적으로 상위와 하위 개념이 포함된 데이터다.
    * 예시) 직원테이블에 사원과 관리자
           조직도테이블에서 상위조직과 하위조직
           메뉴테이블에서 상위메뉴 하위메뉴
           카테고리테이블에서 상위카테고리와 하위카테고리
           
    형식
        SELECT 컬럼명, 컬럼명, ...
        FROM 테이블명
        [WHERE 조건식]
        START WITH 
        CONNECT BY PRIOR 조건식;
        
        * START WITH : 계층 검색의 시작지점을 지정한다.
        * CONNECT BY : 부모행과 자식행 간의 관계가 있는 컬럼을 지정한다.
            CONNECT BY PRIOR 부모키(기본키) = 자식키(외래키)
                계층구조에서 부모 -> 자식 방향으로 내려가는 순방향 검색
            CONNECT BY PRIOR 자식키(외래키) = 부모키(기본키)
                계층구조에서 자식 -> 부모 방향으로 올라가는 순방향 검색
*/

-- 순방향 검색
-- 101번 직원의 하위 직원을 검색하기
SELECT LEVEL,
       LPAD(' ', 4*(LEVEL-1), ' ') || EMPLOYEE_ID,
       FIRST_NAME,
       MANAGER_ID
FROM EMPLOYEES
START WITH EMPLOYEE_ID = 101    -- 101번 직원이 시작지점이다.
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;

-- 역방향 검색
SELECT LEVEL,
       LPAD(' ', 4*(LEVEL-1), ' ') || EMPLOYEE_ID,
       FIRST_NAME,
       MANAGER_ID
FROM EMPLOYEES
START WITH EMPLOYEE_ID = 206    -- 206번 직원이 시작지점이다.
CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID;

select to_char(hire_date, 'mm'), count(*)
from employees 
where to_char(hire_date, 'yyyy') = '2004'
group by to_char(hire_date, 'mm')
order by 1;
  
select lpad(level, 2, '0') month
from dual 
connect by level <= 12;

-- 위의 두개를 조인함
SELECT B.MONTH, A.CNT
from(select to_char(hire_date, 'mm') M, count(*) CNT
    from employees 
    where to_char(hire_date, 'yyyy') = '2004'
    group by to_char(hire_date, 'mm')
    order by 1) A, (
    select lpad(level, 2, '0') month
    from dual 
    connect by level <= 12) B
WHERE B.MONTH = A.M(+)
ORDER BY 1;

-- 연속된 숫자를 만들기
SELECT LEVEL
FROM DUAL
CONNECT BY LEVEL <= 10;

-- 01월 ~ 12월까지 연속된 숫자 만들기
SELECT LPAD(LEVEL, 2, '0') MONTH
FROM DUAL
CONNECT BY LEVEL <= 12;

-- 특정 기간 사이의 날짜 생성하기
SELECT TO_DATE('2023-12-01') + LEVEL -1
FROM DUAL
CONNECT BY LEVEL <= TO_DATE('2023-12-31') - TO_DATE('2023-12-01') + 1;

-- 2006년에 입사한 직원들의 월별 입사자 숫자를 조회하기
SELECT TO_CHAR(HIRE_DATE, 'MM'), COUNT(*)
FROM EMPLOYEES
WHERE HIRE_DATE >= '2003/01/01' AND HIRE_DATE < '2004/01/01'
GROUP BY TO_CHAR(HIRE_DATE, 'MM');

SELECT A.MONTH, NVL(B.CNT, 0) CNT
FROM (SELECT LPAD(LEVEL, 2, '0') MONTH
      FROM DUAL
      CONNECT BY LEVEL <= 12) A,
     (SELECT TO_CHAR(HIRE_DATE, 'MM') MONTH, COUNT(*) CNT
      FROM EMPLOYEES
      WHERE TO_CHAR(HIRE_DATE, 'YYYY') = '2003'
      GROUP BY TO_CHAR(HIRE_DATE, 'MM')) B
WHERE A.MONTH = B.MONTH(+)
ORDER BY A.MONTH;

