1)
select distinct e.empno,e.ename,e.deptno
from emp e;
--14

2)
select distinct e.empno,e.ename,e.hiredate
from emp e, dept d
where e.deptno=d.deptno and d.deptno = 20;
--5

3)
select sum (e.sal) as sommeSal
from emp e;
--29025

4)
select distinct e.empno,e.ename,e.job,e.sal
from emp e
where e.job = 'MANAGER' and e.sal >= 2800;
--2

5)
select distinct e.empno,e.ename
from emp e,dept d
where e.deptno=d.deptno and d.loc = 'DALLAS';
--5

6)
select distinct e.empno,e.deptno,e.ename,e.job,e.sal
from emp e
where e.deptno = 30
order by e.sal ASC; --ou desc
--6

7)
select distinct e.job
from emp e;
--5

8)
select distinct e.empno,e.ename,e.sal
from emp e
where e.sal >= 1290 and e.ename like 'M%' ; --mettre like
--1

9)
select distinct d.deptno,d.dname,d.loc
from emp e, dept d
where e.deptno = d.deptno and e.ename like 'ALLEN'; 
--chicago

10)
select distinct d.deptno,d.dname,d.loc
from  emp e,dept d
where e.deptno = d.deptno and (e.job like 'CLERK' or e.job like 'SALESMAN' or e.job like 'ANALYST');
--3

11)--o n cherche les subordonnées qui ont une comission, puis on regarde le num d'empoloyé du chef et on en déduit son nom

select distinct e.empno,e.ename
from emp e
where e.empno = (
      select distinct e.mgr
      from emp e
      where e.comm>0);--where e.job like 'manager'
--BLAKE

--ou autre solution avec un  group by


12)
select distinct e.empno,e.ename
from emp e, dept d
where e.deptno=d.deptno and (d.loc like 'DALLAS' or d.loc like 'CHICAGO') and e.sal >= 1000;

13)
--select appliqué aux 9 tableaux
select distinct d.deptno,d.dname,e.job, sum(e.sal), count(*) as nbEmp, avg(e.sal) as moySal
from dept d,emp e
where e.deptno=d.deptno 
group by d.deptno,d.dname,e.job
having count (*) > 2
order by d.deptno ASC;
--1

14)
select distinct e.empno,e.ename,e.sal,s.grade,e.mgr,r.ename as resp,d.deptno,d.dname,d.loc
from salgrade s, emp e, dept d,emp r
where d.deptno = e.deptno and (e.sal between s.losal and hisal) and e.mgr=r.empno
union
select distinct e.empno,e.ename,e.sal,s.grade,e.mgr,null as resp,d.deptno,d.dname,d.loc
from emp e, dept d, salgrade s, emp r
where d.deptno = e.deptno and (e.sal between s.losal and hisal) and not e.mgr=r.empno;

15)
select distinct avg (e.sal) as moy, d.dname
from emp e, dept d
where e.deptno=d.deptno
group by d.deptno,d.dname;

16)
select distinct e.sal,e.comm,e.ename,(e.comm/(e.sal+e.comm)*100) as propComm,(e.sal/(e.sal+e.comm)*100) as propSal 
from emp e;

17)
select distinct sum (e.sal) as SalTot, d.dname
from emp e, dept d
where e.deptno=d.deptno
group by d.deptno,d.dname
having (sum(e.sal)=(select  max(sum (e.sal)) from emp e, dept d where e.deptno=d.deptno group by d.deptno)) or 
       (sum(e.sal)=(select  min(sum (e.sal)) from emp e, dept d where e.deptno=d.deptno group by d.deptno));

18)
select distinct d.deptno,d.dname,count (*) as nbEmp, d.loc
from emp e,dept d
where e.deptno=d.deptno and not d.loc like 'CHICAGO'
group by d.deptno,d.dname,d.loc
having count (*) >3;

19)

select distinct d.deptno,d.dname,count (*) as nbEmp
from emp e,dept d
where e.deptno=d.deptno
group by d.deptno,d.dname
having count (*) =0;

20)
select distinct d.deptno,d.dname,count (*) as nbEmp
from emp e,dept d
where e.deptno=d.deptno
group by d.deptno,d.dname
having count (*) = (select max(count(*)) from d.deptno, emp e where e.deptno=e.deptno group by d.deptno);