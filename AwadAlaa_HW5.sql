# SQL - product, depot, stock
# Author: Alaa Awad


-- What are the #prods whose name begins with a ’p’ and are less than $300.00?
SELECT prod_id
FROM Product
WHERE pname
LIKE 'p%' AND price < 300;

-- Names of the products stocked in ”d2”.
-- (a) without in/not in
SELECT p.pname 
FROM Stock s, Product p 
WHERE p.prod_id=s.prod_id AND s.dep_id='d2';

-- (b) with in/not in
SELECT pname FROM Product
WHERE prod_id IN (
SELECT prod_id from Stock
WHERE dep_id='d2');


-- #prod and names of the products that are out of stock.
-- (a) without in/not in
SELECT p.prod_id, p.pname
FROM stock s, product p
WHERE s.prod_id=p.prod_id
GROUP BY p.prod_id, p.pname
HAVING SUM(quantity) <= 0;

-- (b) with in/not in
SELECT prod_id, pname
FROM Product
WHERE prod_id NOT IN (
    SELECT prod_id
FROM stock
GROUP BY prod_id
HAVING sum(quantity)>0
);



-- Addresses of the depots where the product ”p1” is stocked.
-- (a) without exists/not exists and without in/not in
SELECT d.addr
FROM Depot d, Stock s
WHERE d.dep_id = s.dep_id AND s.prod_id='p1';

-- (b) with in/not in
SELECT addr
FROM Depot
WHERE dep_id IN
(SELECT dep_id FROM Stock WHERE prod_id='p1');

-- (c) with exists/not exists
SELECT d.addr
FROM Depot d
WHERE EXISTS
(SELECT dep_id FROM Stock WHERE prod_id='p1' and dep_id=d.dep_id);



-- #prods whose price is between $250.00 and $400.00. 
-- (a) using intersect.
(SELECT prod_id FROM product WHERE price >= 250)
INTERSECT
(SELECT prod_id FROM product WHERE price <= 400);

-- (b) without intersect.
SELECT prod_id FROM product WHERE price >= 250 AND  price <= 400;



-- How many products are out of stock?
SELECT COUNT(ps.prod_id)
FROM (
SELECT prod_id
FROM stock s
GROUP BY prod_id
HAVING sum(quantity)<=0
) ps;



-- Average of the prices of the products stocked in the ”d2” depot.
SELECT avg(p.price) as avg_price
FROM stock s, product p
WHERE s.prod_id=p.prod_id and s.dep_id='d2';



-- #deps of the depot(s) with the largest capacity (volume).
SELECT dep_id
FROM depot
WHERE volume = (select MAX(volume) FROM depot);



--  Sum of the stocked quantity of each product.
SELECT prod_id, SUM(quantity) FROM stock GROUP BY prod_id;



-- Products names stocked in at least 3 depots.
-- (a) using count
SELECT pname FROM product WHERE prod_id IN (
SELECT prod_id FROM stock
GROUP BY prod_id  HAVING COUNT(dep_id)>=3
);

-- (b) without using count
SELECT p2.pname FROM
(SELECT prod_id, SUM(1) as num_deps
 FROM stock GROUP BY prod_id) p1, product p2
WHERE p1.prod_id=p2.prod_id AND p1.num_deps>=3;



-- #prod stocked in all depots.
-- (a) using count 
SELECT prod_id
FROM stock
GROUP BY prod_id
HAVING count(dep_id) = (SELECT count(dep_id) FROM depot);


-- (b) using exists/not exists
SELECT p.prod_id
FROM product p
WHERE NOT EXISTS
    (SELECT  d.dep_id
    FROM  depot d
        EXCEPT
SELECT s.dep_id
FROM stock s
WHERE s.prod_id = p.prod_id);

