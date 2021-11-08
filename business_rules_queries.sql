--Queries and Functions to show the base business rules
-- 1.A salesperson may sell many cars, but each car is sold by only one salesperson.
--Query to show how many cars each salesperson has sold
SELECT salesperson.salesperson_id, salesperson.first_name, salesperson.last_name, count(invoice_id)
FROM sales_invoice
INNER JOIN salesperson
ON sales_invoice.salesperson_id = salesperson.salesperson_id
GROUP BY salesperson.salesperson_id;


-- 2.A customer may buy many cars, but each car is purchased by only one customer.
--Query to show that all sold cars have one customer
SELECT *
FROM car
WHERE car_status = 'sold';


-- 3.A salesperson writes a single invoice for each car he or she sells.
--Query to show the sale invoices for each car that one salesperson has sold
SELECT *
FROM sales_invoice
WHERE salesperson_id = 2;


-- 4.A customer gets an invoice for each car he or she buys.
--	Query to show that a customer that bought two cars has two sale invoices
SELECT *
FROM sales_invoice
WHERE customer_id = 3;

-- 5.A customer may come in just to have his or her car serviced; that is, a customer need not buy a car to be classified as a customer.
--Query to show that customer has a car that has status as service only(so price is null)
SELECT *
FROM car
WHERE car_status = 'service only'; 

-- 6.When a customer takes one or more cars in for repair or service, one service ticket is written for each car.
--Query to show that one customer has many service tickets for each car and each service to each car
SELECT service_history.*, car.make, car.model, customer.first_name, customer.last_name
FROM service_history
INNER JOIN car
ON service_history.vin_number = car.vin_number
INNER JOIN customer
ON car.customer_id = customer.customer_id
WHERE customer.customer_id = 3;

-- 7.The car dealership maintains a service history for each of the cars serviced. The service  records are referenced by the car’s serial number.
--Query to show the service tickets made to one car based on it's vin_number
SELECT *
FROM service_history
WHERE vin_number = 1;

-- 8.A car brought in for service can be worked on by many mechanics, and each mechanic may work on many cars.
--haven't found a way to add many mechanics to one service ticket

-- 9.A car that is serviced may or may not need parts (e.g., adjusting a carburetor or cleaning a fuel injector nozzle does not require providing new parts).
--Query to show service ticket that does not have a part that was used
SELECT *
FROM service_history
WHERE part_number IS NULL;

