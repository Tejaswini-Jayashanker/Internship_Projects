/*                        QUESTION - 2 
Q2) Generate reports to containing details of the company's customers to support sales campaign
a. Retrieve customer details.
   - Familiarize yourself with the Customer Table by writing a Transact-SQL query that retrieves 
     all columns for all customers.
b. Retrieve customer name data.
    -Create a list of all customer contact names that include the title,first name, middle name
     (if any) of all customers.
c. Retreive customer names and phone numbers-
   Each customer has an assigned salesperson. You must write a query to create a 
   call sheet that lists:
    i. The salesperson.
    ii. A column named CustomerName that displays how the customer contact should be 
        greeted (for example, "Mr. Smith").
    iii. The customer's phone number.
*/
-- Solution to 2.a:
SELECT * FROM SalesLT.Customer;

-- Solution to 2.b:
SELECT Title, FirstName, MiddleName, LastName, Suffix 
FROM SalesLT.Customer 
where MiddleName IS NOT NULL AND Suffix IS NOT NULL; --Eliminating/Dropping rows that have 
                                                     -- MiddleName and Suffix as NULL.

/* Another Solution to this maybe to keep the rows and display names excluding Suffix 
and Middle name that are null */
SELECT Title + ' ' + FirstName + ' ' + ISNULL(MiddleName + ' ', '' ) + ISNULL(LastName + ' ', '' ) +
ISNULL(Suffix + ' ', '' ) AS CustomerName FROM SalesLT.Customer;

/*                          Solutions for 2.c                          */
-- Solution to 2.c (Using First Name basis to address the Customer):
SELECT Title + ' ' + FirstName AS CustomerName, Phone, SalesPerson 
FROM SalesLT.Customer;

-- Solution to 2.c (Using Last Name basis to address the Customer):
SELECT Title + ' ' + LastName AS CustomerName, Phone, SalesPerson 
FROM SalesLT.Customer;

/*                        QUESTION 3                     
Q3) Concatenating Columns to create reports from same tables.
    a. Retrieve a list of customer companies.
      - You have been asked to provide a list of all customer companies in the format:-
        CustomerID : CompanyName --> Eg: < 78: Preferred Bikes >
    b. Retreive a list of sales order revisions.
       - The SalesLT.SalesOrderHeader table contains records of sales orders. You have been 
       asked to retreive data for a report that shows:
        i. The sales order number and revision number in the format() -> Eg:- < SO71774 (2) >.
        ii. The order date was converted to ANSI standard format ( yyyy.mm.dd --> Eg:- 2015.01.31 ).
*/
--Solution to 3.a:
SELECT CAST( CustomerID AS varchar ) + ' : ' + CompanyName AS CustomerCompany
FROM SalesLT.Customer;

--Solution to 3.b:
SELECT * FROM SalesLT.SalesOrderHeader;

SELECT SalesOrderNumber + '( ' + STR( RevisionNumber, 1 ) + ' )'
AS OrderRevision, CONVERT( nvarchar( 25 ), OrderDate, 102 ) AS OrderDate
FROM SalesLT.SalesOrderHeader;

/*                              Question - 4:                               
Q4) Handling the NULL values in the database:
Some records in the database include missing or unknown values that are returned as NULL.
You must create some queries taht handle  these NULL fields appropriately.

    a. Retrieve customer contact names with Middles names if known:
      - You have been asked to write a query that returns a list of customer names. The list
        consists of a single field in the format --> Eg: Keith Harris, if Middle Name 
        is unknown, or --> Eg: Jane M. Gates if a middle name is stored in the database.
    b. Retrieve primary contact details:
      - Customers may provide AdventureWorks with an email address, a Phone number or both.
      If an email address is available then it should be used as a primary contact method; if not, then 
      the Phone number should be used. You must write a query that returns a list of customer IDs in one
      column, and a second column named PrimaryContact that contains the email address or phone number.
    c. Retrieve the shipping status:
      - You have been asked to create a query that returns a list of sales oder IDs and Order Dates
      with a column named "ShippingStatus" that contains the text "Shipped" for orders with a known
      ship date, and "AwaitingShipment" for orders with no ship date.
*/
--Solution to 4.a:
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '' ) + LastName AS CustomerName
FROM SalesLT.Customer;

--Solution to 4.b:
SELECT CustomerID, COALESCE( EmailAddress, Phone ) AS PrimaryContact
FROM SalesLT.Customer;

--Solution to 4.c:
SELECT  * from SalesLT.SalesOrderHeader;

SELECT SalesOrderID, OrderDate,
    CASE 
        WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
        ELSE 'Shipped'
    END
AS ShippingStatus
FROM SalesLT.SalesOrderHeader;

/*                              Question - 5
Q5) Querying tables to fileand sort data using:
    a. Retrieve a list of cities:-
     - Initially, you need to produce a list of all of your customers' locations. Write a 
      Transact-SQL query that queries the Address table and retrieves all values for City 
      and StateProvince, removing duplicates.

    b. Rretrieve the heaviest products:-
     - Transportation costs are increasing, and you need to identify the heaviest products.
     - Retrieve the names of the top ten percent of products by weight.

    c. Retrieve the heaviest 100 products not including the heaviest ten:-
     - The heaviest ten products are transported by a specialist carrier; therefore, you need to 
     modify the previous query to list the heaviest 100 products not including the heaviest
     ten. ( Hint: Use OFFSET and FETCH NEXT )

    d. Retreive product details for product model 1:-
     - Initially, you need to find the names, colours, and sizes of the products with the 
     Product model ID 1.

    e. Filter products by colour and size:-
     - Retrieve the product number and name of the products that have a color of 'BLACK', 'RED'
     or 'WHITE' and a size of 'S' or 'M'.

    f. Filter products by product number:-
     - Retrieve the product number, name, and list price of products whose product number 
     begins 'BK-'.
*/
SELECT * FROM SalesLT.Address;

-- Solution to 5.a:
SELECT DISTINCT City, StateProvince
FROM SalesLT.Address;

          -- Sometimes, DISTINCT Keyword does not really remove duplicates, thus, the solution
          -- to 5.a could be using "Groupby".
SELECT City, StateProvince
FROM SalesLT.Address
GROUP BY City, StateProvince;

--Solution to 5.b:
SELECT * FROM SalesLT.Product;

--Selecting top 10 products that are heaviest.
SELECT TOP ( 10 ) PERCENT Name 
FROM SalesLT.Product
ORDER BY Weight DESC;

--Solution to 5.c:
SELECT Name
FROM SalesLT.Product
ORDER BY Weight DESC
OFFSET 10 ROWS
FETCH NEXT 100 ROWS ONLY;

--Solution to 5.d:
SELECT Name, Color, Size
FROM SalesLT.Product
WHERE ProductModelID = 1;

--Solution to 5.e:
SELECT ProductNumber, Name
FROM SalesLT.Product
WHERE ( Color = 'Black' OR Color = 'Red' OR Color = 'White' ) 
AND ( Size = 'S' OR Size = 'M' );

--Solution to 5.f:
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-%';

/*                          Question - 6:
Q6) Querying tables to join multiple tables and generate reports:
  a. Retrieve customer orders to generate invoice reports:
    - As an initial step towards generating the invoice report,
    write a query that returns the company name from the SalesLT.Customer table,
    and the sales order ID and total due from the SalesLT.SalesOrderHeader Table.
  b. Retrieve customer orders with addresses:
   - Extend your customer orders query to include the main office address for each customer, 
   including the full street address, city, state or province, postal code and country or region.
  c. Retrieve a list of all customers  and their orders.
   - The sales manager wants a list of all customer companies and their conatcts (first name and
      last name), showing the sales order ID and total due for each order they have placed. Customers
      who have not placed any oders should be included at the bottom of the list with the NULL values
      for the Order ID and total due.

  d. Retieve a list of customers with no address:
   - A sales employee has noticed that Adventure Works does not have address information for all
    customers. You must write a query taht returns a list of Customer IDs, company names, contact
    names (first and last names),  and phone numbers fro customers with no address stored in the 
    Database.
  
  e. Retrieve a list of customers and products without orders:-
    - Some Customers have never placed orders, and products have never been ordered.
    -Create a Query that returns a column of Customer IDs for Customers who have nevere placed 
    an order, and a Column of Product IDs for NULL productID (because the customer has never 
    ordered a product) and each row with a ProductID should have a NULL CustomerID (because the 
    product has never been ordered by a customer).

*/

SELECT * FROM SalesLT.Customer;

SELECT * FROM SalesLT.SalesOrderHeader;

--Solution to 6.a:
SELECT c.CompanyName, o_h.SalesOrderID, o_h.TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS o_h
ON o_h.CustomerID = c.CustomerID;

--Solution to 6.b:
SELECT c.CompanyName, a.AddressLine1, ISNULL( a.AddressLine2, '') AS AddressLine2,
a.City, a.StateProvince, a.PostalCode, a.CountryRegion, o_h.SalesOrderID, o_h.TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS o_h
ON o_h.CustomerID = c.CustomerID
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID AND AddressType = 'Main Office'
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID;

--Solution to 6.c:
SELECT c.CompanyName, c.FirstName, c.LastName, o_h.SalesOrderID, o_h.TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS o_h
ON c.CustomerID = o_h.CustomerID
ORDER BY o_h.SalesOrderID DESC;

--Solution to 6.d:
SELECT c.CompanyName, c.FirstName, c.LastName, c.Phone
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS c_a
ON c.CustomerID = c_a.CustomerID
WHERE c_a.AddressID IS NULL;

--Solution to 6.e:
SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL JOIN SalesLT.SalesOrderHeader AS o_h
ON c.CustomerID = o_h.CustomerID
FULL JOIN SalesLT.SalesOrderDetail as o_d
ON o_d.SalesOrderID = o_h.SalesOrderID
FULL JOIN SalesLT.Product AS p
ON p.ProductID = o_d.ProductID 
WHERE o_h.SalesOrderID IS NULL
ORDER BY ProductID, CustomerID;

/*                              QUESTION - 7: 
Q7)Working with conditions, aggregation and sub-queries in TSQL:- 
 - Adventure Works products each have a standard cost price that indicates the cost of 
  manufacturing the product, and a list price that indicates the recommended 
  selling price for the product. This data is stored in the SalesLT.Product table.
 - Whenever a product is ordered, the actual unit price at which it was sold is also 
  recorded in the SalesLT.SalesOrderDetail table. 
  You must use subqueries to compare the cost and list prices for each product with the 
  unit prices charged in each sale.
  a. Retrieve products whose list price is higher than the average unit price.Retrieve 
      the product ID, name, and list price for each product where the list price is higher than
      the average unit price for all products that have been sold. 
  b. Retrieve Products with a list price of $100 or more that have been sold for less than $100.
     Retrieve the product ID, name, and list price for each product where the list price is 
     $100 or more, and the product has been sold for less than $100.
  c. Retrieve the cost, list price, and average selling price for each product. 
     Retrieve the product ID, name, cost, and list price for each product along 
     with the average unit price for which that product has been sold.
  d. Retrieve products that have an average selling price that is lower than the cost.
      Filter your previous query to include only products where the cost price is 
      higher than the average selling price.
*/

SELECT * FROM SalesLT.Product;
SELECT * FROM SalesLT.SalesOrderDetail;

--Solution to 7.a:
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice > (SELECT MAX(UnitPrice) FROM SalesLT.SalesOrderDetail );

--Solution to 7.b:
SELECT ProductID,Name, ListPrice 
FROM SalesLT.Product
WHERE ProductID IN
( SELECT ProductID FROM SalesLT.SalesOrderDetail 
  WHERE UnitPrice < 100.00
)
AND ListPrice >= 100.00
ORDER BY ProductID;

--Solution 7.c:
SELECT ProductID, Name, StandardCost, ListPrice,
  (SELECT AVG( UnitPrice ) 
  FROM SalesLT.SalesOrderDetail AS s_o_d 
  WHERE p.ProductID = s_o_d.ProductID
  ) AS AverageSellingPrice
FROM SalesLT.Product AS p 
ORDER BY ProductID;

--Solution to 7.d:
SELECT ProductID, Name, StandardCost, ListPrice,
(
  SELECT AVG( UnitPrice ) 
  FROM SalesLT.SalesOrderDetail AS s_o_d
  WHERE p.ProductID = s_o_d.ProductID 
) AS AverageSellingPrice
FROM SalesLT.Product as p 
WHERE StandardCost > ( SELECT AVG( UnitPrice ) FROM SalesLT.SalesOrderDetail AS s_o_d 
                        WHERE p.ProductID = s_o_d.ProductID )
ORDER BY p.ProductID;