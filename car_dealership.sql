CREATE TABLE "customer" (
  "customer_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  PRIMARY KEY ("customer_id")
);


-- CREATE TABLE "service history" (
--   "service_history_id" SERIAL,
--   "mechanic_id" INTEGER,
--   "vin_number" INTEGER,
--   "service_ticket_id" INTEGER,
--   PRIMARY KEY ("service_history_id")
-- );
--Dropping table because it is not needed
DROP TABLE IF EXISTS service_history;

-- CREATE TABLE "invoice" (
--   "invoice_id" SERIAL,
--   "customer_id" INTEGER,
--   "salesperson_id" INTEGER,
--   "invoice_date" DATE,
--   "car_price" NUMERIC(8,2),
--   "invoice_total_cost" NUMERIC(8,2),
--   "total_cost_service" NUMERIC(8,2),
--   PRIMARY KEY ("invoice_id")
-- );
--Adding a car_id column to invoice table
-- ALTER TABLE invoice
-- ADD car_id INTEGER;

-- ALTER TABLE invoice
-- ADD FOREIGN KEY (car_id) REFERENCES car(car_id);
--Dropping this able to use new "sales_invoice" table instead
DROP TABLE invoice;




---Using  this version that includes car_id foreign key REFERENCE from the start and other changes
CREATE TABLE "sales_invoice" (
    "invoice_id" SERIAL,
    "customer_id" INTEGER,
	"vin_number" INTEGER,
	"car_price" NUMERIC(8,2),
    "salesperson_id" INTEGER,
    "invoice_date" DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY ("invoice_id"),
	FOREIGN KEY ("vin_number") REFERENCES car("vin_number"),
	FOREIGN KEY ("customer_id") REFERENCES customer("customer_id"),
	FOREIGN KEY ("salesperson_id") REFERENCES salesperson("salesperson_id")
);



CREATE TABLE "parts_inventory" (
  "part_number" SERIAL,
  "part_cost" NUMERIC(6,2),
  "part_name" VARCHAR(100),
  PRIMARY KEY ("part_number")
);



CREATE TABLE "service_ticket" (
  "service_ticket_id" SERIAL,
  "vin_number" INTEGER,
  "part_number" INTEGER,
  "service_date" DATE,
  "part_cost" NUMERIC(8,2),
  "labor_cost" NUMERIC(8,2),
  "total_cost_service" NUMERIC(8,2),
  "mechanic_id" INTEGER,
  PRIMARY KEY ("service_ticket_id")
);

--Altering table to add foreign key connection
ALTER TABLE service_ticket 
ADD FOREIGN KEY (part_number) REFERENCES parts_inventory(part_number);


--Change name to service_history
ALTER TABLE service_ticket
RENAME TO service_history;


--Adding a column to show service done to car
ALTER TABLE service_history
ADD service_info VARCHAR(200);

ALTER TABLE service_history
ADD FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id);
ALTER TABLE service_history
ADD FOREIGN KEY (vin_number) REFERENCES car(vin_number);


--REMEMBER TO DROP TOTAL COST COLUMN(query can be used to show total when needed instead up using up space with column)
			--MAKE QUERY BEFORE DROPPING




--MAKING A COPY TO TEST OUT THE AUTOMATIC FILL IN OF PART PRICE USING PART ID
--Changed the number in NUMERIC part cost to 6 from 8
--Adding the foreign key from the creation of table
-- CREATE TABLE "service_ticket_copy" (
--   "service_ticket_id" SERIAL,
--   "vin_number" INTEGER,
--   "part_number" INTEGER,
--   "service_date" DATE DEFAULT CURRENT_DATE,
--   "part_cost" NUMERIC(6,2),
--   "labor_cost" NUMERIC(8,2),
--   "total_cost_service" NUMERIC(8,2),
--   "mechanic_id" INTEGER,
--   PRIMARY KEY ("service_ticket_id"),
-- 	FOREIGN KEY (part_number) REFERENCES parts_inventory(part_number)
-- );
--Drop test copy table 
DROP TABLE IF EXISTS service_ticket_copy;


CREATE TABLE "salesperson" (
  "salesperson_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  PRIMARY KEY ("salesperson_id")
);


CREATE TABLE "car" (
  "vin_number" SERIAL,
  "salesperson_id" INTEGER,
  "invoice_id" INTEGER,
  "customer_id" INTEGER,
  "car_price" NUMERIC(8,2),
  PRIMARY KEY ("vin_number")
);
--Dropping columns from car table
ALTER TABLE car
DROP COLUMN invoice_id;

ALTER TABLE car
DROP COLUMN salesperson_id;

--Adding column to car table
ALTER TABLE car
ADD make VARCHAR(150);

ALTER TABLE car
ADD model VARCHAR(150);

ALTER TABLE car
ADD mileage INTEGER;

ALTER TABLE car
ADD car_year INTEGER;


--Creating an enumerate type to show if car is new or used
CREATE TYPE sold_as AS ENUM ('new', 'used');

--Adding column car_state to car table to show sold_as new or used
ALTER TABLE car
ADD car_state sold_as;

--Adding column to show boolean if car sold at dealership
-- ALTER TABLE car
-- ADD sold_here BOOLEAN;
--dropping to add a different column
ALTER TABLE car
DROP COLUMN sold_here;

--Adding column to show if car is for sale, sold or service only 
	--creating type enumerate for this column
CREATE TYPE status_type AS ENUM ('for sale', 'sold', 'service only');
ALTER TABLE car
ADD car_status status_type;


CREATE TABLE "mechanic" (
  "mechanic_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  PRIMARY KEY ("mechanic_id")
);

