-- 모든 직원의 아이디, 이름, 부서번호, 부서명을 조회하기(등가조인)
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+);

-- 커미션을 받는 직원의 아이디, 이름, 직종아이디, 급여, 커미션을 조회하기
SELECT EMPLOYEE_ID, FIRST_NAME, JOB_ID, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;

-- 커미션을 받는 직원의 아이디, 이름, 급여, 커미션, 급여등급을 조회하기(비등가조인)
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.JOB_ID, E.SALARY, E.COMMISSION_PCT, G.GRADE
FROM EMPLOYEES E, SALARY_GRADES G
WHERE COMMISSION_PCT IS NOT NULL
AND E.SALARY >= G.MIN_SALARY AND E.SALARY <= G.MAX_SALARY;

-- 80번 부서에 소속된 직원들의 평균급여, 최저급여, 최고급여를 조회하기(그룹함수)
SELECT TRUNC(AVG(SALARY)), MIN(SALARY), MAX(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 80;

-- 80번 부서에 소속된 직원들의 직원아이디, 이름, 직종제목, 급여, 최고급여와 급여간의 차이를 조회하기(등가조인)
SELECT E.EMPLOYEE_ID,
       E.FIRST_NAME,
       J.JOB_TITLE,
       E.SALARY,
       J.MAX_SALARY - E.SALARY GAP
FROM EMPLOYEES E, JOBS J
WHERE DEPARTMENT_ID = 80
AND E.JOB_ID = J.JOB_ID(+);

-- 각 부서별 최고급여, 최저급여, 최고급여와 최저급여의 차이를 조회하기(GROUP BY)
SELECT DEPARTMENT_ID,
       MAX(SALARY),
       MIN(SALARY),
       MAX(SALARY) - MIN(SALARY) GAP
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- 'Executive' 부서의 모든 직원아이디, 이름, 직종아이디를 조회하기(서브쿼리 혹은 조인)
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.JOB_ID
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND D.DEPARTMENT_NAME = 'Executive';

-- 전체 직원의 평균급여보다 급여를 적게 받는 직원의 아이디, 이름, 급여를 조회하기(서브쿼리)
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY < (SELECT AVG(SALARY)
                  FROM EMPLOYEES);

-- 'Ismael'과 같은 해에 입사했고, 같은 부서에 근무하고 있는 직원의 아이디, 이름, 입사일을 조회하기(서브쿼리)
SELECT EMPLOYEE_ID, FIRST_NAME, HIRE_DATE
FROM EMPLOYEES O
WHERE TO_CHAR(O.HIRE_DATE, 'YYYY') IN (SELECT TO_CHAR(I.HIRE_DATE, 'YYYY')
                                     FROM EMPLOYEES I
                                     WHERE I.FIRST_NAME = 'Ismael' 
                                     AND I.DEPARTMENT_ID = O.DEPARTMENT_ID);

-- 부서별 최고급여를 조회했을 때 최고급여가 15000을 넘는 부서의 아이디와 최고급여를 조회하기(GROUP BY, HAVING)
SELECT E.DEPARTMENT_ID, MAX(E.SALARY)
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = J.JOB_ID
GROUP BY E.DEPARTMENT_ID
HAVING MAX(E.SALARY) > 15000;

-- 'Neena'보다 급여을 많이 받는 직원의 아이디, 이름, 직종아이디, 급여를 조회하기(서브쿼리)
SELECT EMPLOYEE_ID, FIRST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEES
                WHERE FIRST_NAME = 'Neena');

-- 급여등급별로 직원수를 조회하기(비등가조인, GROUP BY)
SELECT G.GRADE, COUNT(*)
FROM EMPLOYEES E, SALARY_GRADES G
WHERE E.SALARY >= G.MIN_SALARY AND E.SALARY <= G.MAX_SALARY
GROUP BY G.GRADE;


-- 부서별 평균급여를 계산했을 그 부서의 평균급여보다 급여를 적게 받는 직원의 아이디, 이름, 급여, 부서명을 조회하기(인라인뷰, 조인)
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY, D.DEPARTMENT_NAME
FROM (SELECT DEPARTMENT_ID, TRUNC(AVG(SALARY)) AVG_SALARY
      FROM EMPLOYEES
      GROUP BY DEPARTMENT_ID) V, EMPLOYEES E, DEPARTMENTS D
WHERE V.DEPARTMENT_ID = D.DEPARTMENT_ID
AND V.DEPARTMENT_ID = E.DEPARTMENT_ID
AND E.SALARY < V.AVG_SALARY;

-- 'Ismael' 직원이 근무하는 부서의 아이디와 부서 이름을 조회하기(서브쿼리)
SELECT E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND E.EMPLOYEE_ID IN (SELECT A.EMPLOYEE_ID
                        FROM EMPLOYEES A
                        WHERE FIRST_NAME = 'Ismael');

-- 'Neena'에게 보고하는 직원의 아이디와 이름을 조회하기(서브쿼리)
SELECT O.EMPLOYEE_ID, O.FIRST_NAME
FROM EMPLOYEES O
WHERE O.MANAGER_ID = (SELECT I.EMPLOYEE_ID
                      FROM EMPLOYEES I
                      WHERE I.FIRST_NAME = 'Neena');

-- 부서별 평균급여를 계산했을 때 'Ismael'이 근무하는 부서의 평균급여보다 급여를 많이 받는 부서의 아이디와 평균급여를 조회하기(GROUP BY, 인라인뷰, 서브쿼리)

SELECT DEPARTMENT_ID, AVG(SALARY) AVG_SALARY
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > (SELECT AVG(SALARY)
                     FROM EMPLOYEES 
                     WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                                            FROM EMPLOYEES
                                            WHERE FIRST_NAME = 'Ismael'));