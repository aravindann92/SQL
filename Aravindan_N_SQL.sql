use orders;
/*1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) 
as per the following criteria and sort them in descending order of category:
a. If the category is 2050, increase the price by 2000
b. If the category is 2051, increase the price by 500 
c. If the category is 2052, increase the price by 600. 
Hint: Use case statement. no permanent change in table required. (60 ROWS) [NOTE: PRODUCT TABLE]*/

SELECT PRODUCT_CLASS_CODE AS Product_Catagory,
PRODUCT_ID AS Product_ID,
PRODUCT_DESC AS Product_Description,
PRODUCT_PRICE AS Actual_Price,
CASE PRODUCT_CLASS_CODE
WHEN 2050 THEN PRODUCT_PRICE+2000 -- Increase the price for Category 2050 by 2000
WHEN 2051 THEN PRODUCT_PRICE+500 -- Increase the price for Category 2051 by 500
WHEN 2052 THEN PRODUCT_PRICE+600 -- Increase the price for Category 2052 by 600
ELSE PRODUCT_PRICE
END AS Calculated_Price
FROM PRODUCT
-- Display the results in decending order by category(Product Class Code)
ORDER BY PRODUCT_CLASS_CODE DESC;

/*2. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show
inventory status of products as below as per their available quantity:
a. For Electronics and Computer categories, if available quantity is <= 10, show 'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock'
b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 80, show 'In stock', >= 81, show 'Enough stock' 
c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 51 – 'Enough stock' For all categories, if available quantity is 0, show 'Out of stock'. 
Hint: Use case statement. (60 ROWS) [NOTE: TABLES TO BE USED – product, product_class]*/

SELECT PRD_CLS.PRODUCT_CLASS_DESC AS Product_Category,
PRD.PRODUCT_ID AS Product_ID,
PRD.PRODUCT_DESC AS Product_Description,
PRD.PRODUCT_QUANTITY_AVAIL AS Product_Availability,
CASE
-- In table Product Class Electronics is listed as 2050 and Computer as 2053
WHEN PRD_CLS.PRODUCT_CLASS_CODE IN (2050,2053) THEN
CASE
WHEN PRD.PRODUCT_QUANTITY_AVAIL =0 THEN 'Out of stock' -- Out of stock criteria
WHEN PRD.PRODUCT_QUANTITY_AVAIL <=10 THEN 'Low stock'
WHEN (PRD.PRODUCT_QUANTITY_AVAIL >=11 AND PRD.PRODUCT_QUANTITY_AVAIL <=30) THEN 'In stock'
WHEN (PRODUCT_QUANTITY_AVAIL >=31) THEN 'Enough stock'
END
-- In table Roduct Class Stationery is listed as 2052 and Clothes as 2056
WHEN PRD_CLS.PRODUCT_CLASS_CODE IN (2052,2056) THEN
CASE
WHEN PRD.PRODUCT_QUANTITY_AVAIL =0 THEN 'Out of stock' -- Out of stock criteria
WHEN PRD.PRODUCT_QUANTITY_AVAIL <=20 THEN 'Low stock'
WHEN (PRD.PRODUCT_QUANTITY_AVAIL >=21 AND PRD.PRODUCT_QUANTITY_AVAIL <=80) THEN 'In stock'
WHEN (PRODUCT_QUANTITY_AVAIL >=81) THEN 'Enough stock'
END
-- Rest of the categories
ELSE
CASE
WHEN PRD.PRODUCT_QUANTITY_AVAIL =0 THEN 'Out of stock' -- Out of stock criteria
WHEN PRD.PRODUCT_QUANTITY_AVAIL <=15 THEN 'Low stock'
WHEN (PRD.PRODUCT_QUANTITY_AVAIL >=16 AND PRD.PRODUCT_QUANTITY_AVAIL <=50) THEN 'In stock'
WHEN (PRODUCT_QUANTITY_AVAIL >=51) THEN 'Enough stock'
END
END AS Inventory_Status
FROM PRODUCT PRD
-- Join the Product and Product Class TABLE based on the Product Class Code
INNER JOIN PRODUCT_CLASS PRD_CLS ON PRD.PRODUCT_CLASS_CODE = PRD_CLS.PRODUCT_CLASS_CODE
-- Order the results by descending values of Product Class Code and available quantity
ORDER BY PRD.PRODUCT_CLASS_CODE,PRD.PRODUCT_QUANTITY_AVAIL DESC;

/*3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with more
than 1 city, in the descending order of CITIES.*/

SELECT COUNT(CITY) AS Count_of_Cites, -- Count Of The Cities
COUNTRY AS Country
FROM ADDRESS
GROUP BY COUNTRY
-- Count of cities more than 1 and exclude the USA and Malaysia
HAVING COUNTRY NOT IN ('USA','Malaysia') AND COUNT(CITY) > 1
-- Descending order of count of cities
ORDER BY Count_of_Cites DESC;

/*4. Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id, product class desc, 
product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. 
Sort the output on customer name and subtotal. (52 ROWS) 
[NOTE: TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]*/

SELECT ON_CU.CUSTOMER_ID AS Customer_ID,
CONCAT_WS(' ', ON_CU.CUSTOMER_FNAME, ON_CU.CUSTOMER_LNAME) AS Customer_Full_Name,
AR.CITY AS City,
AR.PINCODE AS Pin_Code,
ORD_HD.ORDER_ID AS Order_Id,
PRD_CLS.PRODUCT_CLASS_DESC AS Product_Class_Description,
PRD.PRODUCT_DESC AS Product_Description,
PRD.PRODUCT_PRICE AS Product_Price,
ORD_IT.PRODUCT_QUANTITY AS Product_Order_Quantity,
(PRD.PRODUCT_PRICE * ORD_IT.PRODUCT_QUANTITY) AS Sub_Total -- Calculated value of Total Price
FROM
ONLINE_CUSTOMER ON_CU
INNER JOIN ADDRESS AR ON ON_CU.ADDRESS_ID = AR.ADDRESS_ID -- Join the Address table to fetch the City and Pincode details.
INNER JOIN ORDER_HEADER ORD_HD ON ORD_HD.CUSTOMER_ID = ON_CU.CUSTOMER_ID
INNER JOIN ORDER_ITEMS ORD_IT ON ORD_IT.ORDER_ID = ORD_HD.ORDER_ID -- For Product Order Quantity
INNER JOIN PRODUCT PRD ON PRD.PRODUCT_ID = ORD_IT.PRODUCT_ID -- For Product Price
INNER JOIN PRODUCT_CLASS PRD_CLS ON PRD_CLS.PRODUCT_CLASS_CODE = PRD.PRODUCT_CLASS_CODE -- For Product Class Description (Category)
-- Filter the data which is shipped and Pin code does not have value 0.
WHERE ORD_HD.ORDER_STATUS='Shipped' AND AR.PINCODE NOT LIKE '%0%'
-- Order the results by customer name and subtotal.
ORDER BY ON_CU.CUSTOMER_FNAME, Sub_Total;

/*5. Write a Query to display product id,product description,totalquantity(sum(product quantity) for a given item whose product id is 201 and which item has been bought along with it maximum no. of times. 
Display only one record which has the maximum value for total quantity in this scenario. 
(USE SUB-QUERY)(1 ROW)[NOTE : ORDER_ITEMS TABLE,PRODUCT TABLE]*/

SELECT ORD_IT.PRODUCT_ID AS Product_ID, 
PRD.PRODUCT_DESC AS Product_Description, 
SUM(ORD_IT.PRODUCT_QUANTITY) AS Total_Quantity -- Total quantity(sum(product quantity) for each product_id that was brought along with product_id 201
FROM ORDER_ITEMS ORD_IT
INNER JOIN PRODUCT PRD ON PRD.PRODUCT_ID = ORD_IT.PRODUCT_ID -- Join the Product Table to fetch the description
WHERE ORD_IT.ORDER_ID IN
( -- Pull out all the orders that have the product_id 201
SELECT DISTINCT ORDER_ID FROM ORDER_ITEMS ORD_IT WHERE PRODUCT_ID = 201
)
AND ORD_IT.PRODUCT_ID != 201 -- Pull out the item that has been brought along with item 201 
GROUP BY ORD_IT.PRODUCT_ID
ORDER BY Total_Quantity DESC -- Sort by Total_Quantity on descending
LIMIT 1; -- Show the first row

/*6. Write a query to display the customer_id,customer name, email and order details 
(order id, product desc,product qty, subtotal(product_quantity * product_price)) 
for all customers even if they have not ordered any item.(225 ROWS) 
[NOTE: TABLE TO BE USED - online_customer, order_header, order_items, product]*/

SELECT
ON_CU.CUSTOMER_ID AS Customer_ID,
CONCAT_WS(' ', ON_CU.CUSTOMER_FNAME, ON_CU.CUSTOMER_LNAME) AS Customer_Full_Name,
ON_CU.CUSTOMER_EMAIL AS Customer_Email,
ORD_HD.ORDER_ID AS Order_ID,
PRD.PRODUCT_DESC AS Product_Description,
ORD_IT.PRODUCT_QUANTITY AS Purchase_Quantity,
PRD.PRODUCT_PRICE AS Product_Price,
(ORD_IT.PRODUCT_QUANTITY*PRD.PRODUCT_PRICE) AS Subtotal -- Calulated value Total Price
FROM
ONLINE_CUSTOMER ON_CU
LEFT JOIN ORDER_HEADER ORD_HD ON ON_CU.CUSTOMER_ID = ORD_HD.CUSTOMER_ID 
LEFT JOIN ORDER_ITEMS ORD_IT ON ORD_HD.ORDER_ID = ORD_IT.ORDER_ID 
LEFT JOIN PRODUCT PRD ON ORD_IT.PRODUCT_ID = PRD.PRODUCT_ID 
ORDER BY Customer_ID,Purchase_Quantity DESC; -- Order by Customer_ID and Purchase_Quantitity

/*7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton 
(carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) 
for a given order whose order id is 10006, 
Assume all items of an order are packed into one single carton (box). (1 ROW) [NOTE: CARTON TABLE]*/

SELECT CART.CARTON_ID AS Carton_ID, (CART.LEN*CART.WIDTH*CART.HEIGHT) as Carton_Volume
FROM ORDERS.CARTON CART
WHERE (CART.LEN*CART.WIDTH*CART.HEIGHT) >= (
-- Subquery to take volume details from both Order_items and Product tables.
SELECT SUM(PRD.LEN*PRD.WIDTH*PRD.HEIGHT*ORD_IT.PRODUCT_QUANTITY) AS VOL -- Optimum carton value
FROM
ORDERS.ORDER_ITEMS ORD_IT
INNER JOIN ORDERS.PRODUCT PRD ON ORD_IT.PRODUCT_ID = PRD.PRODUCT_ID -- Join to get the LEN, WIDTH and HEIGHT
WHERE ORD_IT.ORDER_ID =10006) -- Filtered the only Order ID 10006
ORDER BY (CART.LEN*CART.WIDTH*CART.HEIGHT) ASC
LIMIT 1;

/*8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) 
products with credit card or Net banking as the mode of payment per shipped order. 
(6 ROWS) [NOTE: TABLES TO BE USED - online_customer, order_header, order_items,]*/

SELECT ON_CU.CUSTOMER_ID AS Customer_ID,
CONCAT_WS(' ', ON_CU.CUSTOMER_FNAME,ON_CU.CUSTOMER_LNAME) AS Customer_FullName,
ORD_HD.ORDER_ID AS Order_ID,
SUM(ORD_IT.PRODUCT_QUANTITY) AS Total_Order_Quantity
FROM ONLINE_CUSTOMER ON_CU
INNER JOIN ORDER_HEADER ORD_HD ON ORD_HD.CUSTOMER_ID = ON_CU.CUSTOMER_ID 
INNER JOIN ORDER_ITEMS ORD_IT ON ORD_IT.ORDER_ID = ORD_HD.ORDER_ID 
WHERE ORD_HD.ORDER_STATUS = 'Shipped' AND ORD_HD.PAYMENT_MODE in ('CREDIT CARD', 'NET BANKING') -- Check for order_status whether it is shipped and Payment mode 
GROUP BY ORD_HD.ORDER_ID
HAVING Total_Order_Quantity > 10 -- Check the Total Order Quality is greater than 10.
ORDER BY CUSTOMER_ID;

/*9. Write a query to display the order_id, customer id and cutomer full name of customers starting 
with the alphabet "A" along with (product_quantity) as total quantity of products shipped for order ids > 10030. (5 ROWS) 
[NOTE: TABLES TO BE USED - online_customer, order_header, order_items]*/

SELECT
ON_CU.CUSTOMER_ID AS Customer_ID,
CONCAT_WS(' ', ON_CU.CUSTOMER_FNAME, ON_CU.CUSTOMER_LNAME) AS Customer_FullName,
ORD_HD.ORDER_ID AS Order_ID,
SUM(ORD_IT.PRODUCT_QUANTITY) AS Total_Order_Quantity
FROM ONLINE_CUSTOMER ON_CU
INNER JOIN ORDER_HEADER ORD_HD ON ORD_HD.CUSTOMER_ID = ON_CU.CUSTOMER_ID 
INNER JOIN ORDER_ITEMS ORD_IT ON ORD_IT.ORDER_ID = ORD_HD.ORDER_ID 
WHERE ORD_HD.ORDER_STATUS = 'Shipped' AND ORD_HD.ORDER_ID > 10030 AND ON_CU.CUSTOMER_FNAME LIKE 'a%' -- Check for order_status whether it is shipped and those customer swith first name starting with a
GROUP BY ORD_HD.ORDER_ID
ORDER BY Customer_FullName;

/*10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and 
show which class of products have been shipped highest(Quantity) to countries outside India other than USA? 
Also show the total value of those items. (1 ROWS)
[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]*/

SELECT PRD_CLS.PRODUCT_CLASS_CODE AS Product_Class_Code,
PRD_CLS.PRODUCT_CLASS_DESC AS Product_Class_Description,
SUM(ORD_IT.PRODUCT_QUANTITY) AS Total_Quantity,
SUM(ORD_IT.PRODUCT_QUANTITY*PRD.PRODUCT_PRICE) AS Total_Value
FROM ORDER_ITEMS ORD_IT
INNER JOIN ORDER_HEADER ORD_HD ON ORD_HD.ORDER_ID = ORD_IT.ORDER_ID 
INNER JOIN ONLINE_CUSTOMER ON_CU ON ON_CU.CUSTOMER_ID = ORD_HD.CUSTOMER_ID
INNER JOIN PRODUCT PRD ON PRD.PRODUCT_ID = ORD_IT.PRODUCT_ID
INNER JOIN PRODUCT_CLASS PRD_CLS ON PRD_CLS.PRODUCT_CLASS_CODE = PRD.PRODUCT_CLASS_CODE
INNER JOIN ADDRESS AR ON AR.ADDRESS_ID = ON_CU.ADDRESS_ID 
WHERE ORD_HD.ORDER_STATUS ='Shipped' AND AR.COUNTRY NOT IN('India','USA') -- Order status as Shipped & country without India and USA.
GROUP BY PRD_CLS.PRODUCT_CLASS_CODE,PRD_CLS.PRODUCT_CLASS_DESC
ORDER BY Total_Quantity DESC -- Order by Total_Quality
LIMIT 1;