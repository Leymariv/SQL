Partie 1:

ex1:
commit;
create table Comptes( NC int, Nom varchar (10), solde real check (solde>=0));

insert into Comptes
values(1,'Paul',10);
insert into Comptes
values(2,'Paul',20);

select distinct sum(c.solde)
from comptes c;

rollback;

--il n'y a plus rien! car on a pas commit!

ex2:

insert into Comptes
values(1,'Pierre',10);
insert into Comptes
values(2,'Pierre',20);

commit;

insert into Comptes
values(3,'Paul',30);
insert into Comptes
values(4,'Paul',40);

select distinct sum(c.solde),c.nom
from comptes c
group by c.nom;

rollback;

--Paul n'existe plus ce qui est normal car on avait pas commit

ex3:

set autocommit on;

insert into Comptes
values(3,'Jacques',30);
insert into Comptes
values(4,'Jacques',40);

select distinct sum(c.solde)
from comptes c;

set autocommit off;

ex4:

insert into Comptes
values(5,'Jean',50);
insert into Comptes
values(6,'Jean',60);

savepoint deuxinserts;

insert into Comptes
values(7,'Jean',70);
insert into Comptes
values(8,'Jean',80);

select distinct sum(c.solde),c.nom
from comptes c
group by c.nom;

rollback to deuxinserts;

select distinct sum(c.solde),c.nom
from comptes c
group by c.nom;


Partie 2:


ex1:

insert into Comptes
values(7,'Claude',100);

insert into Comptes
values(8,'Henri',200);

UPDATE comptes
SET solde=solde+50
WHERE nom = 'Claude';

UPDATE comptes
SET solde=solde-150
WHERE nom = 'Henri';

select distinct sum(c.solde),c.nom
from comptes c
group by c.nom;

Partie 3:

ex1:

	S1:delete from comptes where nom like 'Jacques'; 
	S1:select distinct sum(c.solde),c.nom
	from comptes c
	group by c.nom;  

SUM(C.SOLDE) NOM
------------ ----------
	 110 Jean
	  50 Henri
	  30 Pierre
	 150 Claude

	S2:select distinct sum(c.solde),c.nom
	from comptes c
	group by c.nom;   2    3  

SUM(C.SOLDE) NOM
------------ ----------
	  70 Jacques
	 110 Jean
	  30 Pierre
	  50 Henri
	  150 Claude
	  --N'a pas pris en compte la modif
	  
	  S1:commit;
	  S2:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;  2    3  

SUM(C.SOLDE) NOM
------------ ----------
	 110 Jean
	  50 Henri
	  30 Pierre
	 150 Claude
	 --Le commit de S1 a permit de mettre a jour S2

ex2:

	S1:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;

	S2:set transaction isolation level serializable; 
	S2:insert into Comptes
	values(10,'Paul',500);

	S1:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;
	 --PAul Napparait pas dans S1

	 S2:commit;

	 S1:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;
	 --PAul apparait maintenant dans S1	
	 
	 S2: set transaction isolation level serializable; 

	 S2:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;

	 S1:insert into Comptes
	values(11,'Paul',1000);

	S2:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;

	 S1:commit;
	 
	 S2:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;

	 --Paul n'apparait toujours pas
	 S2:commit;

	 S2:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;

	 --Paul apparait maintenant!

ex3:

	S1:UPDATE comptes
	SET solde=solde+100
	WHERE nom = 'Paul';
	
	S2:UPDATE comptes
	SET solde=solde+50
	WHERE nom = 'Pierre';

	S1:UPDATE comptes
	SET solde=solde+100
	WHERE nom = 'Pierre';
	--IMPOSSIBLE car S1 veut modifier une ressource (pierre) qui est en train d'être modifié par S2
	--=> INTERBLOCAGE

	S2:UPDATE comptes
	SET solde=solde+200
	WHERE nom = 'Paul';
	--IMPOSSIBLE car S2 veut modifier une ressource (paul) qui est en trai	n d'être modifié par S1
	--=> INTERBLOCAGE

	commit;--les deux
	
	S1:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;
	 
	 S2:select distinct sum(c.solde),c.nom
	 from comptes c
	 group by c.nom;
	 --les deux ont les mêmes données !