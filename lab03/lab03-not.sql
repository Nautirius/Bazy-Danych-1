CREATE SCHEMA lab03;
CREATE TABLE IF NOT EXISTS lab03.customer
(
    customer_id                     serial                        ,
    title                           char(4)                       ,
    fname                           varchar(32)                   ,
    lname                           varchar(32)           not null,
    addressline                     varchar(64)                   ,
    town                            varchar(32)                   ,
    zipcode                         char(10)              not null,
    phone                           varchar(16)                   ,
    CONSTRAINT                      customer_pk PRIMARY KEY(customer_id)
);

CREATE TABLE IF NOT EXISTS lab03.item
(
    item_id                         serial                        ,
    description                     varchar(64)           not null,
    cost_price                      numeric(7,2)                  ,
    sell_price                      numeric(7,2)                  ,
    CONSTRAINT                      item_pk PRIMARY KEY(item_id)
);

insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Miss','Jenny','Stones','27 Rowan Avenue','Hightown','NT2 1AQ','023 9876');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Andrew','Stones','52 The Willows','Lowtown','LT5 7RA','876 3527');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Miss','Alex','Matthew','4 The Street','Nicetown','NT2 2TX','010 4567');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Adrian','Matthew','The Barn','Yuleville','YV67 2WR','487 3871');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Simon','Cozens','7 Shady Lane','Oahenham','OA3 6QW','514 5926');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Neil','Matthew','5 Pasture Lane','Nicetown','NT3 7RT','267 1232');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Richard','Stones','34 Holly Way','Bingham','BG4 2WE','342 5982');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mrs','Ann','Stones','34 Holly Way','Bingham','BG4 2WE','342 5982');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mrs','Christine','Hickman','36 Queen Street','Histon','HT3 5EM','342 5432');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Mike','Howard','86 Dysart Street','Tibsville','TB3 7FG','505 5482');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Dave','Jones','54 Vale Rise','Bingham','BG3 8GD','342 8264');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Richard','Neill','42 Thached way','Winersby','WB3 6GQ','505 6482');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mrs','Laura','Hendy','73 Margeritta Way','Oxbridge','OX2 3HX','821 2335');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','Bill','ONeill','2 Beamer Street','Welltown','WT3 8GM','435 1234');
insert into lab03.customer(title, fname, lname, addressline, town, zipcode, phone) values('Mr','David','Hudson','4 The Square','Milltown','MT2 6RT','961 4526');

insert into lab03.item(description, cost_price, sell_price) values('Wood Puzzle', 15.23, 21.95);
insert into lab03.item(description, cost_price, sell_price) values('Rubic Cube', 7.45, 11.49);
insert into lab03.item(description, cost_price, sell_price) values('Linux CD', 1.99, 2.49);
insert into lab03.item(description, cost_price, sell_price) values('Tissues', 2.11, 3.99);
insert into lab03.item(description, cost_price, sell_price) values('Picture Frame', 7.54, 9.95);
insert into lab03.item(description, cost_price, sell_price) values('Fan Small', 9.23, 15.75);
insert into lab03.item(description, cost_price, sell_price) values('Fan Large', 13.36, 19.95);
insert into lab03.item(description, cost_price, sell_price) values('Toothbrush', 0.75, 1.45);
insert into lab03.item(description, cost_price, sell_price) values('Roman Coin', 2.34, 2.45);
insert into lab03.item(description, cost_price, sell_price) values('Carrier Bag', 0.01, 0.0);
insert into lab03.item(description, cost_price, sell_price) values('Speakers', 19.73, 25.32);


CREATE TABLE lab03.orderinfo(
    orderinfo_id SERIAL,
    customer_id INTEGER NOT NULL REFERENCES lab03.customer(customer_id),
    date_placed DATE NOT NULL,
    date_shipped DATE,
    shipping NUMERIC(7,2),
    CONSTRAINT orderinfo_pk PRIMARY KEY(orderinfo_id)
);

DROP TABLE lab03.orderinfo;

CREATE TABLE lab03.orderinfo(
    orderinfo_id SERIAL,
    customer_id INTEGER NOT NULL,
    date_placed DATE NOT NULL,
    date_shipped DATE,
    shipping NUMERIC(7,2),
    CONSTRAINT orderinfo_pk PRIMARY KEY(orderinfo_id),
    CONSTRAINT orderinfo_customer_id_fk FOREIGN KEY(customer_id) REFERENCES lab03.customer(customer_id)
);

insert into lab03.orderinfo(customer_id, date_placed, date_shipped, shipping) values(3,'2000-03-13','2000-03-17', 2.99);
insert into lab03.orderinfo(customer_id, date_placed, date_shipped, shipping) values(8,'2000-06-23','2000-06-24', 0.00);
insert into lab03.orderinfo(customer_id, date_placed, date_shipped, shipping) values(15,'2000-09-02','2000-09-12', 3.99);
insert into lab03.orderinfo(customer_id, date_placed, date_shipped, shipping) values(13,'2000-09-03','2000-09-10', 2.99);
insert into lab03.orderinfo(customer_id, date_placed, date_shipped, shipping) values(8,'2000-07-21','2000-07-24', 0.00);

INSERT INTO lab03.orderinfo(customer_id, date_placed, shipping) VALUES (250, '2000-01-25', 0.00);

DELETE FROM lab03.customer WHERE customer_id =3;

DROP TABLE lab03.orderinfo;

CREATE TABLE lab03.orderinfo(
    orderinfo_id SERIAL,
    customer_id INTEGER ,--nie moze byc NOT NULL bo przy usuwaniu z tabeli customer bedziemy wstawiali NULL
    date_placed DATE NOT NULL,
    date_shipped DATE,
    shipping NUMERIC(7,2),
    CONSTRAINT orderinfo_pk PRIMARY KEY(orderinfo_id),
    CONSTRAINT orderinfo_customer_id_fk FOREIGN KEY(customer_id) REFERENCES lab03.customer(customer_id) ON DELETE SET NULL
);

DROP TABLE lab03.orderinfo;

CREATE TABLE lab03.orderinfo(
    orderinfo_id SERIAL,
    customer_id INTEGER NOT NULL,
    date_placed DATE NOT NULL,
    date_shipped DATE,
    shipping NUMERIC(7,2),
    CONSTRAINT orderinfo_pk PRIMARY KEY(orderinfo_id),
    CONSTRAINT orderinfo_customer_id_fk FOREIGN KEY(customer_id) REFERENCES lab03.customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE lab03.orderline(
    orderinfo_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    CONSTRAINT orderline_pk PRIMARY KEY(orderinfo_id, item_id),
    CONSTRAINT orderline_orderinfo_id_fk FOREIGN KEY(orderinfo_id) REFERENCES lab03.orderinfo (orderinfo_id),
    CONSTRAINT orderline_item_id_fk FOREIGN KEY(item_id) REFERENCES lab03.item (item_id)
);

insert into lab03.orderline(orderinfo_id, item_id, quantity) values(1, 4, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(1, 7, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(1, 9, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(2, 1, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(2, 10, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(2, 7, 2);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(2, 4, 2);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(3, 2, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(3, 1, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(4, 5, 2);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(5, 1, 1);
insert into lab03.orderline(orderinfo_id, item_id, quantity) values(5, 3, 1);

SELECT * FROM lab03.customer, lab03.orderinfo;

SELECT c.fname, o.orderinfo_id, o.date_placed FROM lab03.customer c JOIN lab03.orderinfo o ON c.customer_id=o.customer_id WHERE c.fname = 'Ann' AND c.lname = 'Stones';

SELECT lab03.orderinfo.orderinfo_id, lab03.orderinfo.date_placed, lab03.orderinfo.date_shipped, lab03.orderline.item_id, lab03.orderline.quantity
FROM ((lab03.customer JOIN lab03.orderinfo ON lab03.customer.customer_id = lab03.orderinfo.customer_id) JOIN lab03.orderline ON lab03.orderinfo.orderinfo_id = lab03.orderline.orderinfo_id)
WHERE lab03.customer.fname = 'Ann' AND lab03.customer.lname = 'Stones';

SELECT lab03.orderinfo.orderinfo_id, lab03.orderinfo.date_placed, lab03.orderinfo.date_shipped,
lab03.orderline.item_id,lab03.orderline.quantity FROM lab03.customer, lab03.orderinfo, lab03.orderline
WHERE  lab03.customer.customer_id = lab03.orderinfo.customer_id
AND lab03.orderinfo.orderinfo_id = lab03.orderline.orderinfo_id
AND lab03.customer.fname = 'Ann' AND lab03.customer.lname = 'Stones';

SELECT DISTINCT i.description,i.item_id FROM lab03.customer c, lab03.orderinfo ord, lab03.orderline ol, lab03.item i
WHERE c.customer_id = ord.customer_id
AND ord.orderinfo_id = ol.orderinfo_id
AND ol.item_id = i.item_id
AND fname = 'Ann' AND lname = 'Stones';

SET datestyle = 'ISO, DMY';

-- JOIN lepszy od filtracji iloczynu kartezjańskiego - w iloczynie wszystkie n^m rekordów musi najpierw powstać, a dopiero potem są filtrwane