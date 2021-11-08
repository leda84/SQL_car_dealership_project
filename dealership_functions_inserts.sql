--****************************************
-----------------CUSTOMER-----------------
--Creating ADD CUSTOMER function
CREATE OR REPLACE FUNCTION add_customer(_first_name VARCHAR, _last_name VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO customer(first_name,last_name)
	VALUES(_first_name, _last_name);
END;
$MAIN$
LANGUAGE plpgsql;

--Adding customers using stored function
SELECT add_customer('John', 'Wick');
SELECT add_customer('Jimi', 'Hendrix');
SELECT add_customer('Albus', 'Dumbledore');
SELECT add_customer('Dolores', 'Umbridge');
SELECT add_customer('Fleur', 'Delacour');

--***************************************
------------------SALESPERSON-------------
--Creating ADD SALESPERSON function
CREATE OR REPLACE FUNCTION add_salesperson(_first_name VARCHAR, _last_name VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO salesperson(first_name,last_name)
	VALUES(_first_name, _last_name);
END;
$MAIN$
LANGUAGE plpgsql;

--Adding salesperson with stored function
SELECT add_salesperson('Severus', 'Snape');
SELECT add_salesperson('Seamus', 'Finnigan');
SELECT add_salesperson('Dean', 'Thomas');

--Adding a salesperson using values
INSERT INTO salesperson(
	first_name,
	last_name
)VALUES(
	'Luna',
	'Lovegood'
);

--***************************************
------------------MECHANIC---------------
--Creating function to add a mechanic
CREATE OR REPLACE FUNCTION add_mechanic(_first_name VARCHAR, _last_name VARCHAR)
RETURNS void
AS $$
BEGIN
	INSERT INTO mechanic(first_name, last_name)
	VALUES(_first_name, _last_name);
END;
$$
LANGUAGE plpgsql;

--Adding mechanic using function
SELECT add_mechanic('Ron', 'Weasley');
SELECT add_mechanic('Neville', 'Longbottom');

--Adding mechanic using values
INSERT INTO mechanic(
	first_name,
	last_name
)VALUES(
	'Draco',
	'Malfoy'
);

--*****************************************
----------------PARTS INVENTORY------------
--Creating function to add to parts inventory
CREATE OR REPLACE FUNCTION add_part(_cost NUMERIC(6,2), _name VARCHAR)
RETURNS void
AS $$
BEGIN
	INSERT INTO parts_inventory(part_cost, part_name)
	VALUES(_cost, _name);
END;
$$
LANGUAGE plpgsql;

--Adding a part using function
SELECT add_part(120.00, 'battery');
SELECT add_part(29.99, 'alternator');
SELECT add_part(29.99, 'carburetor');
SELECT add_part(3.99, 'fuel filter');
SELECT add_part(28.99, 'electric fuel pump');
SELECT add_part(9.99, 'manual fuel pump');

--Adding a part using values
INSERT INTO parts_inventory(
	part_cost,
	part_name
)VALUES(
	30.00,
	'cabin filter'
);

--***************************************
------------------CAR--------------------
--Creating function to add car
CREATE OR REPLACE FUNCTION add_car(_car_price NUMERIC(8,2), _make VARCHAR, _model VARCHAR, _mileage INTEGER, _year INTEGER)
RETURNS void
AS $$
BEGIN
	INSERT INTO car(car_price, make, model, mileage, car_year)
	VALUES(_car_price, _make, _model, _mileage, _year);
END;
$$
LANGUAGE plpgsql;

--Adding a car using the car function
SELECT add_car(26222.00, 'Hyundai', 'Tucson', 22, 2017);
SELECT add_car(30950.00, 'Hyundai', 'Santa Fe', 24, 2021);

--Adding a car using values
INSERT INTO car(
	car_price,
	make,
	model,
	mileage,
	car_year
)VALUES(
	35790,
	'KIA',
	'Telluride',
	40,
	2022
);

INSERT INTO car(
	car_price,
	make,
	model,
	mileage,
	car_year
)VALUES(
	27900,
	'Toyota',
	'RAV4',
	61000,
	2019
);

--Updating entries to add into new column(car_state)
UPDATE car
SET car_state = 'new'
WHERE vin_number = '3';

UPDATE car
SET car_state = 'used'
WHERE vin_number = '4';

UPDATE car
SET sold_here = true;

--UPDATING FUNCTION TO INCLUDE NEW COLUMNS CAR_STATE & SOLD_HERE
CREATE OR REPLACE FUNCTION add_car(_car_price NUMERIC(8,2), _make VARCHAR, _model VARCHAR, _mileage INTEGER, _year INTEGER, _car_state sold_as, _sold_here boolean)
RETURNS void
AS $$
BEGIN
	INSERT INTO car(car_price, make, model, mileage, car_year, car_state, sold_here)
	VALUES(_car_price, _make, _model, _mileage, _year, _car_state, _sold_here);
END;
$$
LANGUAGE plpgsql;

--ADD CAR USING NEW FUNCTION
SELECT add_car(29479, 'Ford', 'Explorer', 61935, 2018, 'used', true);


--CREATING FUNCTION TO ADD A CAR THAT COMES IN FOR SERVICE ONLY
CREATE OR REPLACE FUNCTION add_serviced_car(_make VARCHAR, _model VARCHAR, _mileage INTEGER, _year INTEGER, _car_status status_type)
RETURNS void
AS $$
BEGIN
	INSERT INTO car(make, model, mileage, car_year, car_status)
	VALUES(_make, _model, _mileage, _year, _car_status);
END;
$$
LANGUAGE plpgsql;

--Adding a car using new function
	--This car will not have been sold here because it only comes in for service
SELECT add_serviced_car('Honda', 'Element', 89506, 2011, false);
--updating cars to show status
UPDATE car
SET car_status = 'service only'
WHERE vin_number = '5';

UPDATE car
SET car_status = 'for sale'
WHERE vin_number = '6';

UPDATE car
SET customer_id = '4'
WHERE vin_number = '5';

--****************************************************
----------------SERVICE TICKET----------
---------------NAME CHANGED TO SERVICE_HISTORY---------
--Creating a function to add to service tickets
-- CREATE OR REPLACE FUNCTION add_service_ticket(_vin INTEGER, _part_number INTEGER, _labor_cost NUMERIC(8,2), _mechanic_id INTEGER, _service_date DATE DEFAULT CURRENT_DATE)
-- RETURNS void
-- AS $$
-- BEGIN
-- 	INSERT INTO service_ticket(vin_number, part_number, labor_cost, mechanic_id, service_date)
-- 	VALUES(_vin, _part_number, _labor_cost, _mechanic_id, _service_date);
-- END;
-- $$
-- LANGUAGE plpgsql;


--Changing function to insert into new name service_history
CREATE OR REPLACE FUNCTION add_service_ticket(_vin INTEGER, _part_number INTEGER, _labor_cost NUMERIC(8,2), _mechanic_id INTEGER, _service_date DATE DEFAULT CURRENT_DATE)
RETURNS void
AS $$
BEGIN
	INSERT INTO service_history(vin_number, part_number, labor_cost, mechanic_id, service_date)
	VALUES(_vin, _part_number, _labor_cost, _mechanic_id, _service_date);
END;
$$
LANGUAGE plpgsql;



-----------------------------ASK ABOUT------------------------------
----NEED TO FIND A WAY TO HAVE PART COST AUTOMATICALLY ADD WHEN PART NUMBER IS USED.
	--Possibly just going to drop the part cost column from service history to keep it simple.
		--Will make a query to show the service ticket(with price and all info using joins/subqueries)
----ALSO FIND WAY TO HAVE TOTAL COST FIGURED OUT
	--will probably just make this a procedure that gives sum

--Adding service ticket using function
SELECT add_service_ticket(3,2,1,0);
SELECT add_service_ticket(3,2,50,1);
SELECT add_service_ticket(2,1,80,1);

--Adding service ticket using updated function for inserting into updated table name
SELECT add_service_ticket(1,2,60,2);

--Deleting service ticket because of incorrect data
DELETE FROM service_ticket
WHERE service_ticket_id = '1';

--Adding a service ticket using values(date wasn't added to ticket since it was not included in this query)
INSERT INTO service_ticket(
	vin_number,
	part_number,
	labor_cost,
	total_cost_service,
	mechanic_id
)VALUES(
	3,
	1,
	30,
	150,
	1
);

INSERT INTO service_ticket(
	vin_number,
	part_number,
	service_date,
	labor_cost,
	total_cost_service,
	mechanic_id
)VALUES(
	1,
	1,
	CURRENT_DATE,
	30,
	150,
	2
);

--UPDATING service tickets to add info into service_info column
UPDATE service_history
SET service_info = 'changed cabin filter'
WHERE service_ticket_id = '6';

UPDATE service_history
SET service_info = 'Replaced battery'
WHERE part_number = '1';

--UPDATING FUNCTION TO ACCOUNT FOR ADDED service_info column
--THIS FUNCTION IS USED WHEN A CAR IS SERVICED AND A PART IS NEEDED
CREATE OR REPLACE FUNCTION add_service_ticket(_vin INTEGER, _part_number INTEGER, _labor_cost NUMERIC(8,2), _mechanic_id INTEGER, _service_info VARCHAR(200), _service_date DATE DEFAULT CURRENT_DATE)
RETURNS void
AS $$
BEGIN
	INSERT INTO service_history(vin_number, part_number, labor_cost, mechanic_id, service_info, service_date)
	VALUES(_vin, _part_number, _labor_cost, _mechanic_id, _service_info, _service_date);
END;
$$
LANGUAGE plpgsql;

--Create a function for service that did not need a part(service_only)
CREATE OR REPLACE FUNCTION add_service_only_ticket(_vin INTEGER, _labor_cost NUMERIC(8,2), _mechanic_id INTEGER, _service_info VARCHAR(200), _service_date DATE DEFAULT CURRENT_DATE)
RETURNS void
AS $$
BEGIN
	INSERT INTO service_history(vin_number, labor_cost, mechanic_id, service_info, service_date)
	VALUES(_vin, _labor_cost, _mechanic_id, _service_info, _service_date);
END;
$$
LANGUAGE plpgsql;

--Create ticket for service only(no part used)
SELECT add_service_only_ticket(4, 20, 3, 'Cleaned a fuel injector nozzle');

--**MAKE A FUNCTION OR PROCEDURE OF QUERY TO COME UP WITH THE SUM/TOTAL FOR SERVICE TICKET

--Joining service history table and part inventory table to check if price is added
SELECT *
FROM service_history
INNER JOIN parts_inventory
ON service_history.part_number = parts_inventory.part_number;

-- First test for service ticket "print" on ticket #4
--needs customer info
SELECT service_history.service_ticket_id, service_history.service_date, car.vin_number, car.make, car.model, car.car_year, service_history.mechanic_id, service_history.service_info, parts_inventory.part_name, parts_inventory.part_cost, service_history.labor_cost
FROM service_history
LEFT JOIN parts_inventory
ON service_history.part_number = parts_inventory.part_number
INNER JOIN car
ON service_history.vin_number = car.vin_number
WHERE service_ticket_id = 4;

--trying it as a function*******error connecting it to service ticket
-- CREATE OR REPLACE FUNCTION print_service_ticket(_service_ticket_id)
-- RETURNS void 
-- AS $MAIN$
-- BEGIN
-- 	SELECT service_history.service_ticket_id, service_history.service_date, service_history.labor_cost, service_history.mechanic_id, service_history.service_info, parts_inventory.part_name, parts_inventory.part_cost, car.vin_number, car.make, car.model, car.car_year
-- 	FROM service_history
-- 	LEFT JOIN parts_inventory
-- 	ON service_history.part_number = parts_inventory.part_number
-- 	INNER JOIN car
-- 	ON service_history.vin_number = car.vin_number
-- 	WHERE service_ticket_id = _service_ticket_id;
-- END;
-- $MAIN$
-- LANGUAGE plpgsql;

-------------------Service ticket copy----------------
-- CREATE OR REPLACE FUNCTION add_service_ticket_copy(_vin INTEGER, _part_number INTEGER, _part_cost NUMERIC(6,2), _labor_cost NUMERIC(8,2), _mechanic_id INTEGER, _service_date DATE DEFAULT CURRENT_DATE)
-- RETURNS void
-- AS $$
-- BEGIN
-- 	INSERT INTO service_ticket_copy(vin_number, part_number, labor_cost, mechanic_id, part_cost, service_date)
-- 	VALUES(_vin, _part_number, _labor_cost, _mechanic_id, _part_cost, _service_date);
-- END;
-- $$
-- LANGUAGE plpgsql;

-- SELECT add_service_ticket_copy(2,1,50,1);
-- SELECT add_service_ticket_copy(3,1,60,2,)

--Dropping this test copy of the function
DROP FUNCTION IF EXISTS add_service_ticket_copy;

------------------INVOICE--------------
--Dropped this table to use newly created one

--******************************************
-----------------SALES INVOICE--------------
--Function to add an invoice
CREATE OR REPLACE FUNCTION add_invoice(_customer_id INTEGER, _vin_number INTEGER, _car_price NUMERIC(8,2), _salesperson_id INTEGER, _invoice_date DATE DEFAULT CURRENT_DATE)
RETURNS void
AS $$
BEGIN
	INSERT INTO sales_invoice(customer_id, vin_number, car_price, salesperson_id, invoice_date)
	VALUES(_customer_id, _vin_number, _car_price, _salesperson_id, _invoice_date);
END;
$$
LANGUAGE plpgsql;

--Using function to add to sales_invoice
SELECT add_invoice(3,2,35790,2);
SELECT add_invoice(5,4,27900,2);
SELECT add_invoice(1,3,30950,4);
SELECT add_invoice(3,1,26222,2);

--updating car status to show sold
UPDATE car
SET car_status = 'sold'
WHERE vin_number = 3;
--updating customer_id in car table since they're sold
UPDATE car
SET customer_id = 3
WHERE vin_number = 1;

--*******find a way to show difference from list price and price sold for the cars


SELECT *
FROM sales_invoice;

SELECT *
FROM service_history;

SELECT *
FROM car;

SELECT *
FROM parts_inventory;

SELECT *
FROM mechanic;

SELECT *
FROM salesperson;

SELECT *
FROM customer;


--------Dropped tables----
SELECT *
FROM service_ticket_copy

SELECT *
FROM service_history;

SELECT *
FROM invoice;