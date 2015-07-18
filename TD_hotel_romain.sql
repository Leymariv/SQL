1)

SELECT DISTINCT r.NS, r.NomS, r.CApCh
FROM RESORTS r
WHERE r.TypeS LIKE 'montagne';
--6 rows 

2)

SELECT DISTINCT h.NH, h.NS, h.nomH, h.AdrH, h.TelH, h.CatH
FROM RESORTS r, HOTELS h
WHERE h.NS = r.NS  AND r.TypeS LIKE 'mer';
--37 rows

3)

SELECT DISTINCT r.NomS, r.NS, h.NH, h.NS
FROM RESORTS r, HOTELS h
WHERE h.NS = r.NS  AND r.TypeS LIKE 'mer' AND h.CatH ='4';
-- 3 rows

4)

SELECT DISTINCT g.NomCl, g.AdrCl, r.NS
FROM RESORTS r, GUESTS g, BOOKINGS b
WHERE g.NCL = b.NCL AND b.NS = r.NS AND r.TypeS LIKE 'montagne';
--889 rows

5)

SELECT DISTINCT c.NCH, c.NS, C.NH
FROM HOTELS h, RESORTS r, ROOMS c
WHERE h.NS = r.NS AND c.NS = r.NS AND c.NH = h.NH AND h.CatH ='2' AND r.TypeS LIKE 'montagne' AND c.prix < '50';
--148 rows

6)

SELECT DISTINCT g.NCL, g.nomcl
FROM RESORTS r, ROOMS c, BOOKINGS b, GUESTS g
WHERE r.NS=c.NS AND c.NCH=b.NCH AND r.NS = b.NS AND g.NCL=b.NCL AND r.TypeS LIKE 'mer' AND (c.TypCh = 'D' OR c.TypCh = 'DWC');
-- 893 rows avec distinct 
--=> 750
7)

SELECT DISTINCT g.nomcl
FROM GUESTS g, HOTELS h
WHERE g.AdrCl = h.AdrH;
-- 2 rows

8)

SELECT DISTINCT h.NomH, h.NH, h.NS
FROM HOTELS h
WHERE h.CatH ='4'
MINUS
SELECT DISTINCT h.NomH, h.NH, h.NS
FROM HOTELS h, ROOMS c
WHERE c.NS=h.NS AND c.NH = h.NH AND h.CatH ='4' AND c.typCh != 'SDB';
--11 rows

9)

SELECT DISTINCT h.NomH, h.AdrH, h.CatH
FROM HOTELS h, ROOMS c1, ROOMS c2
WHERE c1.NH=h.NH  AND c2.NH=h.NH AND c1.NH=c2.NH AND c1.prix=c2.prix AND c1.NCH!=c2.NCH;
--77 rows
--autre possibilité :
Select distinct h.ns, h.nh, h.Nomh, h.AdrH, h.CatH
from Hotels h, Rooms r
Where h.ns = r.ns and h.nh = r.nh
group by h.ns, h.nh, r.prix, h.NomH, h.AdrH, h.CatH
having count(*)>=2;

10)

SELECT DISTINCT h.NomH, h.AdrH, h.CatH, h.NH, h.NS, COUNT(*) as reservation
FROM HOTELS h, BOOKINGS b
WHERE b.NH=h.NH AND b.NS = h.NS
GROUP BY h.NomH, h.AdrH, h.CatH, h.NH, h.NS
UNION
SELECT DISTINCT NomH, AdrH, CatH, NH, NS, 0 as reservation
FROM HOTELS
WHERE (ns,nh) not in (Select distinct ns, nh from Bookings);
-- 78 rows

11)

SELECT h.NH, h.NS, h.AdrH, h.NomH
FROM Hotels h, RESORTS r, Bookings b
WHERE r.ns = h.ns and h.ns = b.ns and h.nh = b.nh and r.NomS = 'Chamonix'
Group by h.ns, h.nh, h.NomH, h.AdrH
Having count(*) = (Select Max(Count(*))
from Bookings b, resorts r
where r.ns = b.ns and b.ncl is not null
and r.NomS = 'chamonix'
group by b.ns, b.nh);
--=> 1 

12)

Select b.jour
From Bookings b, Resorts r, hotels h
where r.ns = h.ns and h.ns = b.ns and h.nh = b.nh and r.NomS = 'Chamonix' and h.NomH ='Bon Sejour'
Group by b.jour
Having count(*) = (Select Max(count(*))
from Bookings b, resorts r, Hotels h
Where r.ns = h.ns and h.ns = b.ns and h.nh = b.nh and r.NomS = 'Chamonix' and h.NomH = 'Bon Sejour'
group by b.jour);
--2 rows 
 
13)

select h.ns, h.nh, h.NomH, h.AdrH, h.CatH
from hotels h, rooms c
where h.ns = c.ns and h.nh = c.nh
minus
select h.ns, h.nh, h.NomH, h.AdrH, h.CatH
from hotels h, rooms c
where h.ns = c.ns and h.nh = c.nh and c.Prix > 40;
-- 31 rows 
-- ou
select h.ns, h.nh, h.NomH, h.AdrH, h.CatH
from hotels h, rooms c
where h.ns = c.ns and h.nh = c.nh
group by h.ns, h.nh, h.NomH, h.AdrH, h.CatH
having max(c.prix)<40;

14)

select Min(c.prix)
from resorts r, hotels h, rooms c
where r.ns = h.ns and r.ns = c.ns and h.nh = c.nh and h.CatH =3 and r.TypeS='mer';
-- 65 euros

15)

select g.NCL, g.NomCl
from guests g, bookings b, resorts r, hotels h
where r.ns = h.ns and b.ns = r.ns and b.nh = h.nh and r.NomS = 'Chamonix' and h.CatH = 2 and b.NCL = g.NCL
group by g.ncl, g.nomcl
having count(distinct b.nh)=(select count (h.nh)
			From Hotels h, Resorts r
			Where r.ns = h.ns and h.CatH = 2 and r.NomS = 'Chamonix');
--5 noms

16)
-- 949 rows

