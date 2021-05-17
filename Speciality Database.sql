/*
Exploring Databases
*/

use karentaf_assign1_sakila;

/*
1. Display the details of all the films from the film table for PG-rated films. (1 point)
*/

SELECT *
FROM film
WHERE rating = 'PG';

/*
2.	Select the customer_id, first_name, and last_name for the active customers (0 means inactive).
 Sort the customers by their last name and restrict the results to 10 customers. (1 point)
*/
SELECT customer_id, first_name, last_name
FROM customer
WHERE active = 1;

/*
3.	Select customer_id, first_name, and last_name for all customers where the last name is Clark. (1 point)
*/

SELECT customer_id, first_name, last_name
FROM customer
WHERE last_name =  'Clark';
/*
4.	Select film_id, title, rental_duration, and description for films with a rental duration of 3 days. (1 point)
*/

SELECT film_id,title,rental_duration, description
FROM film
WHERE rental_duration = 3;

/*
5.	Select film_id, title, rental_rate, and rental_duration for films that can be rented for more than 1 day and at a cost of $0.99 or more
 Sort the results by rental_rate then rental_duration. (2 points)
*/

SELECT film_id,title,rental_rate, rental_duration
FROM film
WHERE rental_duration > 1 AND rental_rate >= 0.99;



/*
6.	Select film_id, title, replacement_cost, and length for films that cost 9.99 or 10.99 to replace and have a running time of 60 minutes or more. (2 points)
*/

SELECT film_id, title, replacement_cost, length
FROM film
WHERE (replacement_cost = 9.99 OR  replacement_cost = 10.99) AND length >=60;



/*
7.	Select film_id, title, replacement_cost, and rental_rate for films that cost $20 or more to replace and the cost to rent is less than a dollar. (2 points)
*/

SELECT film_id, title, replacement_cost, rental_rate
FROM film
WHERE replacement_cost >= 20 AND rental_rate < 1;


/*
8.	Select film_id, title, and rating for films that do not have a G, PG, and PG-13 rating.  Do not use the OR logical operator. (2 points)
*/

SELECT  film_id, title, rating
FROM film
WHERE rating NOT IN ('G', 'PG', 'PG-13');


/*
9.	How many films can be rented for 5 to 7 days? Your query should only return 1 row. (2 points)
*/

SELECT COUNT(*) AS no_of_films
FROM film
WHERE rental_duration BETWEEN 5 AND 7;


/*
10.	INSERT your favorite movie into the film table. You can arbitrarily set the column values as long as they are related to the column.
Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/

INSERT INTO film (title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, special_features, last_update, rating)
				VALUES('SPLIT', 'The film follows a man with 24 different personalities who kidnaps and imprisons three teenage girls in an isolated underground facility.', 2016, 1, 1, 3, 0.99, 117, 5, 'Trailers', '2006-02-15 05:03:42','PG');

/*

11.INSERT your two favorite actors/actresses into the actor table with a single SQL statement. (2points)
*/

INSERT INTO actor VALUES(NULL,'Kerry', 'Washington','2006-02-15 04:34:33');


/*

12.The address2 column in the address table inconsistently defines what it means to not have an address2 associated with an address.
UPDATE the address2 column to an empty string where the address2 value is currently null. (3points)
*/
UPDATE address
SET address2 = ""
WHERE address2 IS NULL;

/*
13. For rated G films less than an hour long, update the special_features column to replace Commentaries with Audio Commentary.
Be sure the other special features are not removed. (3points)

*/

ALTER TABLE film
MODIFY COLUMN special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes', 'Audio Commentary');

UPDATE film
SET special_features= REPLACE (special_features,'Commentaries','Audio Commentary')
WHERE rating = "G" AND length <60;


/*
14.For each of the films, list the film title and all the actors (first and last names) in that film.
The result should display one row for each film.  Note that you have to use the GROUP_CONCATENATE function. (3 points)

*/

SELECT film.title , GROUP_CONCAT(actor.first_name," ", actor.last_name SEPARATOR ', ' ) as Actors
FROM film
	JOIN film_actor
		ON film_actor.film_id = film.film_id
	JOIN actor
		ON actor.actor_id = film_actor.actor_id
	GROUP BY title;


/*
15.For each film, determine the total number of copies that are kept by the store.
How many of those copies were never returned?  Who rented them (names of the customers)? (3 points)

*/

 SELECT film.title,inventory.store_id, COUNT(inventory.film_id)  AS copies_by_store 
FROM film
	JOIN inventory
		ON inventory.film_id = film.film_id
	JOIN rental
		ON rental.inventory_id = inventory.inventory_id
        GROUP BY store_id, title;  
        
SELECT film.title,  GROUP_CONCAT(customer.first_name," ", customer.last_name SEPARATOR ',') as CustomerNames,COUNT(inventory.film_id)  AS copies_not_returned
FROM film
JOIN inventory
		ON inventory.film_id = film.film_id
	JOIN rental
		ON rental.inventory_id = inventory.inventory_id
	JOIN customer
		ON customer.customer_id = rental.customer_id
where rental.return_date IS NULL
GROUP BY title; 

/*
16.	Create an ERD for the database.  You just have to create the diagram.
 However, the diagram must clearly indicate all the of the PK, FK and the connections. (3 points)

*/

#creating a proper foreign key relationship

use `karentaf_SpecialtyFoodSchemaData`;

ALTER TABLE Orders
ADD FOREIGN KEY (ShipVia) REFERENCES Shippers(ShipperID);


/*

17.	Count the number of records in the order table. (1 points)
*/

SELECT COUNT(*) AS no_of_records
FROM Orders;


/*
18.	The warehouse manager wants to know all of the products the company carries.
Generate a list of all the products with all of the columns. (1 point)

*/

SELECT *
FROM Products;




/*
19.	The marketing department wants to run a direct mail marketing campaign to its American, Canadian, and Mexican customers.
Write a query to gather the data needed for a mailing label. (2 points)

*/

SELECT  CompanyName, ContactName, Address, City, Region, PostalCode, Country, Phone, Fax
FROM Customers
WHERE Country IN ("USA", "Canada" ,"Mexico");


/*
20.	HR wants to celebrate hire date anniversaries for the sales representatives in the USA office.
Develop a query that would give HR the information they need to coordinate hire date anniversary gifts. Sort the data as you see best fit. (2 points)

*/
#changed format because I thought it would be easier to read for HR

SELECT  FirstName,LastName, Country,TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) AS years_employed, DATE_FORMAT(HireDate, "%d %M %Y") AS HireDate
FROM Employees
WHERE Title = 'Sales Representative' AND Country = 'USA'
ORDER BY HireDate ASC;


/*
21.	Customer service noticed an increase in shipping errors for orders handled by the employee, Janet Leverling.
Return the OrderIDs handled by Janet so that the orders can be inspected for other errors. (2 points)

*/

SELECT  Orders.OrderID as orders_by_janet
FROM Employees
	JOIN Orders
		ON Orders.EmployeeID = Employees.EmployeeID
WHERE FirstName = 'Janet' AND LastName = 'Leverling' ;


/*
22.	The sales team wants to develop stronger supply chain relationships with its suppliers by reaching out to the managers who have the decision making power to create a just-in-time inventory arrangement.
 Display the supplier's company name, contact name, title, and phone number for suppliers who have manager or mgr in their title. (2 points)
*/

SELECT CompanyName, ContactName, ContactTitle, Phone
FROM Suppliers
WHERE ContactTitle  LIKE "%manager%" or ContactTitle  LIKE "%mgr%";



/*
23.	The warehouse packers want to label breakable products with a fragile sticker. Identify the products with glasses, jars, or bottles and are not discontinued (0 = not discontinued). (2 points)

*/

SELECT  ProductName AS fragile_products
FROM Products
WHERE Discontinued = 0 AND QuantityPerUnit  LIKE "%jars%" OR QuantityPerUnit  LIKE "%glasses%" OR QuantityPerUnit  LIKE "%bottles%";


/*

24.	How many customers are from Brazil and have a role in sales? Your query should only return 1 row. (2 points)
*/

SELECT COUNT(*) AS role_in_sales
FROM Customers
WHERE ContactTitle LIKE "%sales%" AND Country = "Brazil";


/*
25.	Who is the oldest employee in terms of age? Your query should only return 1 row. (2 points)

*/

SELECT FirstName, LastName, BirthDate,  TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) AS Age
ORDER BY Age DESC
LIMIT 1;


/*

26.	Calculate the total order price per order and product before and after the discount. The products listed should only be for those where a discount was applied. Alias the before discount and after discount expressions. (3 points)
*/


SELECT OrderDetails.OrderID, Products.ProductName, Quantity*OrderDetails.UnitPrice AS before_discount,Discount, ROUND(Quantity*OrderDetails.UnitPrice*(1-Discount),2) as after_discount
FROM OrderDetails
	JOIN Products
		ON Products.ProductID = OrderDetails.ProductID
WHERE Discount>0
ORDER BY OrderID;


/*
27.	To assist in determining the company's assets, find the total dollar value for all products in stock. Your query should only return 1 row.  (2 points)

*/

SELECT SUM(UnitsInStock*UnitPrice) AS ' total value for all product'
FROM Products;


/*
28.	Supplier deliveries are confirmed via email and fax. Create a list of suppliers with a missing fax number to help the warehouse receiving team identify who to contact to fill in the missing information. (2 points)

*/

#added the data they need to contact them
SELECT CompanyName, ContactName, Phone
FROM Suppliers
WHERE Fax IS NULL;



/*
29.	The PR team wants to promote the company's global presence on the website. Identify a unique and sorted list of countries where the company has customers. (2 points)
*/

SELECT DISTINCT Country
FROM Customers
ORDER BY Country ASC ;

/*
30.	You're the newest hire. INSERT yourself as an employee. You can arbitrarily set the column values as long as they are related to the column. Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/

INSERT INTO Employees(EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath)
						Values(NULL, 'Tafa', 'Karen', 'Sales Manager', 'Ms.', '1997-03-07 00:00:00','2021-02-01 00:00:00', '944 home base','Los Angeles', 'CA','90045', 'USA', '(310) 322-1234', '5555', 'super cool kid',NULL,'http://accweb/emmployees/karentafa');


/*
31.	The supplier, Bigfoot Breweries, recently launched their website. UPDATE their website to bigfootbreweries.com. (2 points)
*/

UPDATE Suppliers
SET HomePage = 'bigfootbreweries.com'
WHERE CompanyName = 'Bigfoot Breweries';



/*
32.	The images on the employee profiles are broken. The link to the employee headshot is missing the .com domain extension.
Fix the PhotoPath link so that the domain properly resolves. Broken link example: http://accweb/emmployees/buchanan.bmp (2 points)
*/


UPDATE Employees
SET PhotoPath = INSERT(PhotoPath, 14,0, '.com')
WHERE PhotoPath IS NOT NULL;
;


/*
33.	Create a table each to identify the Low, Medium and High group companies based on their total order amount.
Each table should contain the company name, the total order quantity and the group description that it belongs to.
 An example for Medium group (with partial results) is shown below.
 Note that you have to dynamically determine the group membership using the ranges in CustomerGroupThresholds table. (6 points)
*/


SHOW CREATE TABLE `karentaf_SpecialtyFoodSchemaData`.`OrderDetails`;

 CREATE TABLE Low_Group (

  Company_name varchar(255) NOT NULL,
  Total_order_quantity int NOT NULL,
  Group_description enum('Low'),
  FOREIGN KEY (Company_name) REFERENCES Customers(CompanyName),
  FOREIGN KEY (Group_description) REFERENCES CustomerGroupThresholds(Group_description)
);

 CREATE TABLE Medium_Group (

  Company_name varchar(255) NOT NULL,
  Total_order_quantity int NOT NULL,
  Group_description enum('Medium'),
  FOREIGN KEY (Company_name) REFERENCES Customers(CompanyName),
  FOREIGN KEY (Group_description) REFERENCES CustomerGroupThresholds(Group_description)
);

 CREATE TABLE High_Group (

  Company_name varchar(255) NOT NULL,
  Total_order_quantity int NOT NULL,
  Group_description enum('High'),
  FOREIGN KEY (Company_name) REFERENCES Customers(CompanyName),
  FOREIGN KEY (Group_description) REFERENCES CustomerGroupThresholds(Group_description)
);

CREATE TABLE Very_High_Group (

  Company_name varchar(255) NOT NULL,
  Total_order_quantity int NOT NULL,
  Group_description enum('Very High'),
  FOREIGN KEY (Company_name) REFERENCES Customers(CompanyName),
  FOREIGN KEY (Group_description) REFERENCES CustomerGroupThresholds(Group_description)
);



drop table Low_Group;
drop table Very_High_Group;
drop table Medium_Group;


/*
Custom Data Requests -
*/



/*
# Data Request 1a.

Question: What are the best selling products? Find out out the Top 5 products in terms of sales

Business Justification: this will allow for the company to see where it is doing well and possibly place more focus on these products

*/

SELECT Products.ProductName, SUM(OrderDetails.Quantity* OrderDetails.UnitPrice) AS Total_Sales
FROM Products
	JOIN OrderDetails
		ON Products.ProductID = OrderDetails.ProductID
GROUP BY ProductName
ORDER BY Total_Sales DESC
LIMIT 5;




/*
# Data Request 1.b

Question: What are the worst selling products? Find out out the Bottom 5 products and their quantities and sales

Business Justification: this will allow for the company to see where it is not doing well and find out whether they should stop selling those products or find reasons as to
why they are not performing well

*/

SELECT Products.ProductName, SUM(OrderDetails.Quantity* OrderDetails.UnitPrice) AS Total_Sales
FROM Products
	JOIN OrderDetails
		ON Products.ProductID = OrderDetails.ProductID
GROUP BY ProductName
ORDER BY Total_Sales ASC
LIMIT 5;





/*
# Data Request 2a.

Question: Who are the top customers? Find out out the Top 5 customers in terms of quantity and where they are from

Business Justification: This could help get the business know who to focus on and also maybe provide them with more value such as discounts or priority ordering/shipping

*/

SELECT Customers.CompanyName, SUM(OrderDetails.Quantity) AS Total_Quantity, SUM(OrderDetails.Quantity* OrderDetails.UnitPrice) AS TOTAL_SALES
FROM Customers
	JOIN Orders
		ON Customers.CustomerID = Orders.CustomerID
	JOIN OrderDetails
		ON Orders.OrderID = OrderDetails.OrderID
GROUP BY CompanyName
ORDER BY Total_Quantity DESC
LIMIT 5;



/*
# Data Request 3a.

Question: Who are the top performing employees? Find out out the Top 3 employees in terms of orders handled

Business Justification: this will allow for the company to possibly reward them for their efforts thus increasing their motivation and encouraging even better performance from them
*/

SELECT Concat(Employees.FirstName, " ", Employees.LastName) as Employees, SUM(OrderDetails.Quantity) AS Total_Quantity_Sold
FROM Employees
JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID
	JOIN OrderDetails
		ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employees
ORDER BY Total_Quantity_Sold DESC
LIMIT 3;


/*
# Data Request 3b

Question: Who are the worst performing employees? Find out out the Bottom 3 employees in terms of orders handled

Business Justification: this will allow for the company to possibly reward them for their efforts thus increasing their motivation and encouraging even better performance from them
*/

SELECT Concat(Employees.FirstName, " ", Employees.LastName) as Employees, SUM(OrderDetails.Quantity) AS Total_Quantity_Sold
FROM Employees
JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID
	JOIN OrderDetails
		ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employees
ORDER BY Total_Quantity_Sold ASC
LIMIT 3;


/*
# Data Request 4

Question: What is the contact info for the top customers
Business Justification: as we have now found who the top customers are, lets save the info in a view so that we have it ready to pull and contact them on the rewards we will give them
*/


CREATE VIEW top_customers AS 
SELECT Customers.CompanyName, Customers.ContactName, Customers.Phone, Customers.Fax, SUM(OrderDetails.Quantity) AS Total_Quantity, SUM(OrderDetails.Quantity* OrderDetails.UnitPrice) AS TOTAL_SALES
FROM Customers
	JOIN Orders
		ON Customers.CustomerID = Orders.CustomerID
	JOIN OrderDetails
		ON Orders.OrderID = OrderDetails.OrderID
GROUP BY CompanyName
ORDER BY Total_Quantity DESC
LIMIT 10;

CREATE VIEW top_customers_contact_info AS 
SELECT CompanyName, ContactName, Phone, Fax
FROM top_customers;

SELECT *
FROM top_customers_contact_info;

/*
# Data Request 5

Question: #Which product need to be reordered?
Business Justification: This allows the manager or stock supervisors to see which products to re-order. 

*/


CREATE VIEW reorder_check AS
select ProductName,  (UnitsInStock +UnitsOnOrder- ReorderLevel) AS TotalUnits, ReorderLevel ,(CASE 
	WHEN (UnitsInStock + UnitsOnOrder- ReorderLevel) <= ReorderLevel THEN 'Reorder' 
    else 'No Reorder Needed'
    end) As Check_For_Reorder
from Products
where Discontinued !=1;


SELECT*
FROM reorder_check
WHERE Check_For_Reorder = 'Reorder';


