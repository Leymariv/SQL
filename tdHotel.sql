1)
select r.ns,r.noms,r.capch --toujpurs mettre toutes les clés de ce qu'on veut afficher
from resorts r
where r.types like 'montagne';
--=> 6

2)

select h.nh,h.adrH,h.telh,h.cath,h.nh,h.ns
from resorts r, hotels h
where h.ns=r.ns and r.types like 'mer';
--=>37

3)

select distinct r.noms,r.nh,r.ns,r.nch
from resorts r, hotels h
where h.ns=r.ns and r.types like 'mer' and h.cath like '4' ;
--=>3

4)

select distinct g.nomcl,g.adrcl,g.ncl
from resorts r, guests g, bookings b
where b.ns=r.ns and g.ncl=b.ncl and r.types like 'montagne';
--=>889

5)

select distinct c.nch,c.ns,c.nh
from resorts r,rooms c,hotels h
where h.NS=r.NS and c.NS=r.NS and c.NH=h.NH  and h.cath like '2' and r.types like 'montagne' and c.prix< '50'; 
--148 rows

6)

SELECT DISTINCT g.NCL, g.nomcl
FROM RESORTS r, ROOMS c, BOOKINGS b, GUESTS g
WHERE r.NS=c.NS AND c.NCH=b.NCH AND r.NS = b.NS AND g.NCL=b.NCL AND r.TypeS LIKE 'mer' AND (c.TypCh = 'D' OR c.TypCh = 'DWC');
-- 893 rows avec distinct 
--=> 750

7)
SELECT DISTINCT g.NomCl,g.NCL
FROM HOTELS h,GUESTS g
WHERE g.AdrCL = H.Adrh;
-- 2 rows

8)

SELECT DISTINCT h.NS,h.NH,h.NomH
FROM HOTELS h,ROOMS c
WHERE h.NH=c.NH and h.NS=c.NS and h.catH = '4'
minus
SELECT DISTINCT h.NS,h.NH,h.NomH
FROM HOTELS h,ROOMS c
WHERE h.NH=c.NH and h.NS=c.NS and h.catH = '4' and not c.TypCh = 'SDB';
--11

9)
SELECT DISTINCT h.NS,h.NH,h.NomH,h.CatH,h.AdrH
FROM HOTELS h,ROOMS c
WHERE h.NH=c.NH and h.NS=c.NS
GROUP BY h.NomH,h.NH,h.NS,h.catH,h.adrH,c.Prix
HAVING count (*) >= 2;
--77

10)


SELECT DISTINCT h.NomH, h.AdrH, h.CatH, h.NH, h.NS, COUNT(*) as reservation
FROM HOTELS h, BOOKINGS b
WHERE b.NH=h.NH AND b.NS = h.NS
GROUP BY h.NomH, h.AdrH, h.CatH, h.NH, h.NS
UNION
SELECT DISTINCT NomH, AdrH, CatH, NH, NS, 0 as reservation
FROM HOTELS
WHERE (ns,nh) not in (Select distinct ns, nh from Bookings);
--78

11)

SELECT DISTINCT h.NS,h.NH,H.AdrH,h.NomH, COUNT(*) as nbres
FROM BOOKINGS b, HOTELS h, RESORTS r
WHERE h.NS=r.NS and h.NS=b.NS and h.NH = b.NH and r.NomS = 'Chamonix'
GROUP BY h.NS,h.NH,H.AdrH,h.NomH
HAVING count(*) = (
SELECT Max(count(*))
FROM BOOKINGS b, RESORTS r
WHERE b.NS=r.NS and b.NCL is not null and r.NomS = 'Chamonix'
GROUP BY b.NS, b.NH);

12)

Select b.jour --POURQUOI ON NE RAJOUTE PAS b.NCH,B.NH,b.NS
From Bookings b, Resorts r, hotels h
where r.ns = h.ns and h.ns = b.ns and h.nh = b.nh and r.NomS = 'Chamonix' and h.NomH ='Bon Sejour'
Group by b.jour
Having count(*) = (Select Max(count(*))
from Bookings b, resorts r, Hotels h
Where r.ns = h.ns and h.ns = b.ns and h.nh = b.nh and r.NomS = 'Chamonix' and h.NomH = 'Bon Sejour'
group by b.jour);

13)

select h.ns, h.nh, h.NomH, h.AdrH, h.CatH
from hotels h, rooms c
where h.ns = c.ns and h.nh = c.nh
minus
select h.ns, h.nh, h.NomH, h.AdrH, h.CatH
from hotels h, rooms c
where h.ns = c.ns and h.nh = c.nh and c.Prix > 40;
-- 31 rows 

--OU

select h.ns, h.nh, h.NomH, h.AdrH, h.CatH
from hotels h, rooms c
where h.ns = c.ns and h.nh = c.nh
group by h.ns, h.nh, h.nomh, h.adrH, h.cath
having max(C.prix)<40;

14)

select c.prix, c.ns, c.nh, c.nch
from rooms c, hotels h, resorts r
where r.ns=h.ns and r.ns=c.ns and h.nh=c.nh and h.cath = 3 and r.types='mer'
group by c.prix, c.ns, c.nh, c.nch
having count(*)=(
select min(count(*))
from rooms c, hotels h, resorts r
where r.ns=h.ns and r.ns=c.ns and h.nh=c.nh and h.cath = 3 and r.types='mer'
group by c.prix);
