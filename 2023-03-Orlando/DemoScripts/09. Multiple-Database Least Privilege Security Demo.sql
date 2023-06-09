/*      AUTHOR: Joseph Kunk, Senior Software Architect at Dewpoint, Lansing MI USA. 
                LinkedIn:	joe-kunk-b926091
				Twitter:	@joekunk
				Mastodon:	@joekunk@techhub.social
				Email:		joekunk@gmail.com
*/

/*	For non-admins, SQL Server security is granted at the database level or lower
	What if you have a view that needs to query multiple databases?
	You could add a db role to each database and assign identical permissions ...
	Better to create one security context (SID) across all databases, but how?
*/

/*	Demo Process:
		1. Restore BikeShopUSA and BikeShopCAN

*/

--------------------------------------------------------------------
� 2017 sqlservertutorial.net All Rights Reserved
--------------------------------------------------------------------
Name   : BikeStores
Link   : http://www.sqlservertutorial.net/load-sample-database/
Version: 1.0
--------------------------------------------------------------------
*/
-- create schemas
CREATE SCHEMA production;
go

CREATE SCHEMA sales;
go

-- create tables
CREATE TABLE production.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sales.customers (
	customer_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);

CREATE TABLE sales.stores (
	store_id INT IDENTITY (1, 1) PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
);

CREATE TABLE sales.staffs (
	staff_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active tinyint NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sales.orders (
	order_id INT IDENTITY (1, 1) PRIMARY KEY,
	customer_id INT,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES sales.customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sales.order_items (
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE production.stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);


Use BikeStoresCAN
GO

UPDATE sales.customers SET city = 'Banff' WHERE City = 'Jackson Heights'
UPDATE sales.customers SET city = 'Brooks' WHERE City = 'Niagara Falls'
UPDATE sales.customers SET city = 'Calgary' WHERE City = 'Westbury'
UPDATE sales.customers SET city = 'Edmonton' WHERE City = 'Springfield Gardens'
UPDATE sales.customers SET city = 'Fort McMurray' WHERE City = 'Selden'
UPDATE sales.customers SET city = 'Grande Prairie' WHERE City = 'Monroe'
UPDATE sales.customers SET city = 'Jasper' WHERE City = 'Richmond Hill'
UPDATE sales.customers SET city = 'Lake Louise' WHERE City = 'Hollis'
UPDATE sales.customers SET city = 'Lethbridge' WHERE City = 'Bellmore'
UPDATE sales.customers SET city = 'Medicine Hat' WHERE City = 'Fresh Meadows'
UPDATE sales.customers SET city = 'Red Deer' WHERE City = 'Ronkonkoma'
UPDATE sales.customers SET city = 'Saint Albert' WHERE City = 'Lake Jackson'
UPDATE sales.customers SET city = 'Barkerville' WHERE City = 'West Babylon'
UPDATE sales.customers SET city = 'Burnaby' WHERE City = 'Torrance'
UPDATE sales.customers SET city = 'Campbell River' WHERE City = 'Santa Monica'
UPDATE sales.customers SET city = 'Chilliwack' WHERE City = 'Levittown'
UPDATE sales.customers SET city = 'Courtenay' WHERE City = 'San Carlos'
UPDATE sales.customers SET city = 'Cranbrook' WHERE City = 'Baldwinsville'
UPDATE sales.customers SET city = 'Dawson Creek' WHERE City = 'Lockport'
UPDATE sales.customers SET city = 'Delta' WHERE City = 'Hamburg'
UPDATE sales.customers SET city = 'Esquimalt' WHERE City = 'Amarillo'
UPDATE sales.customers SET city = 'Fort Saint James' WHERE City = 'Jamaica'
UPDATE sales.customers SET city = 'Fort Saint John' WHERE City = 'Fairport'
UPDATE sales.customers SET city = 'Hope' WHERE City = 'Yonkers'
UPDATE sales.customers SET city = 'Kamloops' WHERE City = 'Sunnyside'
UPDATE sales.customers SET city = 'Kelowna' WHERE City = 'Baldwin'
UPDATE sales.customers SET city = 'Kimberley' WHERE City = 'Commack'
UPDATE sales.customers SET city = 'Kitimat' WHERE City = 'Scarsdale'
UPDATE sales.customers SET city = 'Langley' WHERE City = 'Merrick'
UPDATE sales.customers SET city = 'Nanaimo' WHERE City = 'Port Chester'
UPDATE sales.customers SET city = 'Nelson' WHERE City = 'Santa Cruz'
UPDATE sales.customers SET city = 'New Westminster' WHERE City = 'Ballston Spa'
UPDATE sales.customers SET city = 'North Vancouver' WHERE City = 'Anaheim'
UPDATE sales.customers SET city = 'Oak Bay' WHERE City = 'Holbrook'
UPDATE sales.customers SET city = 'Penticton' WHERE City = 'Bayside'
UPDATE sales.customers SET city = 'Powell River' WHERE City = 'Albany'
UPDATE sales.customers SET city = 'Prince George' WHERE City = 'Lindenhurst'
UPDATE sales.customers SET city = 'Prince Rupert' WHERE City = 'Shirley'
UPDATE sales.customers SET city = 'Quesnel' WHERE City = 'Flushing'
UPDATE sales.customers SET city = 'Revelstoke' WHERE City = 'Longview'
UPDATE sales.customers SET city = 'Rossland' WHERE City = 'Garland'
UPDATE sales.customers SET city = 'Trail' WHERE City = 'Kingston'
UPDATE sales.customers SET city = 'Vancouver' WHERE City = 'Ossining'
UPDATE sales.customers SET city = 'Vernon' WHERE City = 'Huntington'
UPDATE sales.customers SET city = 'Victoria' WHERE City = 'Central Islip'
UPDATE sales.customers SET city = 'West Vancouver' WHERE City = 'North Tonawanda'
UPDATE sales.customers SET city = 'White Rock' WHERE City = 'Woodside'
UPDATE sales.customers SET city = 'Brandon' WHERE City = 'Far Rockaway'
UPDATE sales.customers SET city = 'Churchill' WHERE City = 'Saint Albans'
UPDATE sales.customers SET city = 'Dauphin' WHERE City = 'San Lorenzo'
UPDATE sales.customers SET city = 'Flin Flon' WHERE City = 'Rockville Centre'
UPDATE sales.customers SET city = 'Kildonan' WHERE City = 'Whitestone'
UPDATE sales.customers SET city = 'Saint Boniface' WHERE City = 'Franklin Square'
UPDATE sales.customers SET city = 'Swan River' WHERE City = 'Rego Park'
UPDATE sales.customers SET city = 'Thompson' WHERE City = 'Jamestown'
UPDATE sales.customers SET city = 'Winnipeg' WHERE City = 'Atwater'
UPDATE sales.customers SET city = 'York Factory' WHERE City = 'Endicott'
UPDATE sales.customers SET city = 'Bathurst' WHERE City = 'New Rochelle'
UPDATE sales.customers SET city = 'Caraquet' WHERE City = 'Oakland Gardens'
UPDATE sales.customers SET city = 'Dalhousie' WHERE City = 'Ithaca'
UPDATE sales.customers SET city = 'Fredericton' WHERE City = 'Freeport'
UPDATE sales.customers SET city = 'Miramichi' WHERE City = 'Rome'
UPDATE sales.customers SET city = 'Moncton' WHERE City = 'Plainview'
UPDATE sales.customers SET city = 'Saint John' WHERE City = 'South Richmond Hill'
UPDATE sales.customers SET city = 'Argentia' WHERE City = 'Wappingers Falls'
UPDATE sales.customers SET city = 'Bonavista' WHERE City = 'Desoto'
UPDATE sales.customers SET city = 'Channel-Port aux Basques' WHERE City = 'New Hyde Park'
UPDATE sales.customers SET city = 'Corner Brook' WHERE City = 'Spring Valley'
UPDATE sales.customers SET city = 'Ferryland' WHERE City = 'Patchogue'
UPDATE sales.customers SET city = 'Gander' WHERE City = 'South Ozone Park'
UPDATE sales.customers SET city = 'Grand Falls�Windsor' WHERE City = 'Forest Hills'
UPDATE sales.customers SET city = 'Happy Valley�Goose Bay' WHERE City = 'Rochester'
UPDATE sales.customers SET city = 'Harbour Grace' WHERE City = 'Duarte'
UPDATE sales.customers SET city = 'Labrador City' WHERE City = 'Hopewell Junction'
UPDATE sales.customers SET city = 'Placentia' WHERE City = 'Mahopac'
UPDATE sales.customers SET city = 'Saint Anthony' WHERE City = 'Saratoga Springs'
UPDATE sales.customers SET city = 'St. John�s' WHERE City = 'Encino'
UPDATE sales.customers SET city = 'Wabana' WHERE City = 'Harlingen'
UPDATE sales.customers SET city = 'Fort Smith' WHERE City = 'New City'
UPDATE sales.customers SET city = 'Hay River' WHERE City = 'Fullerton'
UPDATE sales.customers SET city = 'Inuvik' WHERE City = 'Richardson'
UPDATE sales.customers SET city = 'Tuktoyaktuk' WHERE City = 'Deer Park'
UPDATE sales.customers SET city = 'Yellowknife' WHERE City = 'Los Angeles'
UPDATE sales.customers SET city = 'Baddeck' WHERE City = 'Centereach'
UPDATE sales.customers SET city = 'Digby' WHERE City = 'Valley Stream'
UPDATE sales.customers SET city = 'Glace Bay' WHERE City = 'Auburn'
UPDATE sales.customers SET city = 'Halifax' WHERE City = 'Victoria'
UPDATE sales.customers SET city = 'Liverpool' WHERE City = 'Oswego'
UPDATE sales.customers SET city = 'Louisbourg' WHERE City = 'New Windsor'
UPDATE sales.customers SET city = 'Lunenburg' WHERE City = 'Canyon Country'
UPDATE sales.customers SET city = 'Pictou' WHERE City = 'Ontario'
UPDATE sales.customers SET city = 'Port Hawkesbury' WHERE City = 'Elmont'
UPDATE sales.customers SET city = 'Springhill' WHERE City = 'Mcallen'
UPDATE sales.customers SET city = 'Sydney' WHERE City = 'Fort Worth'
UPDATE sales.customers SET city = 'Yarmouth' WHERE City = 'Maspeth'
UPDATE sales.customers SET city = 'Iqaluit' WHERE City = 'Queensbury'
UPDATE sales.customers SET city = 'Bancroft' WHERE City = 'Glendora'
UPDATE sales.customers SET city = 'Barrie' WHERE City = 'Mount Vernon'
UPDATE sales.customers SET city = 'Belleville' WHERE City = 'Los Banos'
UPDATE sales.customers SET city = 'Brampton' WHERE City = 'Monsey'
UPDATE sales.customers SET city = 'Brantford' WHERE City = 'Helotes'
UPDATE sales.customers SET city = 'Brockville' WHERE City = 'Schenectady'
UPDATE sales.customers SET city = 'Burlington' WHERE City = 'Oceanside'
UPDATE sales.customers SET city = 'Cambridge' WHERE City = 'Ozone Park'
UPDATE sales.customers SET city = 'Chatham' WHERE City = 'Sugar Land'
UPDATE sales.customers SET city = 'Chatham-Kent' WHERE City = 'San Jose'
UPDATE sales.customers SET city = 'Cornwall' WHERE City = 'West Islip'
UPDATE sales.customers SET city = 'Elliot Lake' WHERE City = 'Copperas Cove'
UPDATE sales.customers SET city = 'Etobicoke' WHERE City = 'Canandaigua'
UPDATE sales.customers SET city = 'Fort Erie' WHERE City = 'Coram'
UPDATE sales.customers SET city = 'Fort Frances' WHERE City = 'Bay Shore'
UPDATE sales.customers SET city = 'Gananoque' WHERE City = 'Banning'
UPDATE sales.customers SET city = 'Guelph' WHERE City = 'East Meadow'
UPDATE sales.customers SET city = 'Hamilton' WHERE City = 'Lancaster'
UPDATE sales.customers SET city = 'Iroquois Falls' WHERE City = 'New York'
UPDATE sales.customers SET city = 'Kapuskasing' WHERE City = 'West Hempstead'
UPDATE sales.customers SET city = 'Kawartha Lakes' WHERE City = 'Howard Beach'
UPDATE sales.customers SET city = 'Kenora' WHERE City = 'Vista'
UPDATE sales.customers SET city = 'Kingston' WHERE City = 'Elmhurst'
UPDATE sales.customers SET city = 'Kirkland Lake' WHERE City = 'Euless'
UPDATE sales.customers SET city = 'Kitchener' WHERE City = 'Hempstead'
UPDATE sales.customers SET city = 'Laurentian Hills' WHERE City = 'San Angelo'
UPDATE sales.customers SET city = 'London' WHERE City = 'Plattsburgh'
UPDATE sales.customers SET city = 'Midland' WHERE City = 'Pittsford'
UPDATE sales.customers SET city = 'Mississauga' WHERE City = 'Corpus Christi'
UPDATE sales.customers SET city = 'Moose Factory' WHERE City = 'Poughkeepsie'
UPDATE sales.customers SET city = 'Moosonee' WHERE City = 'Yorktown Heights'
UPDATE sales.customers SET city = 'Niagara Falls' WHERE City = 'Troy'
UPDATE sales.customers SET city = 'Niagara-on-the-Lake' WHERE City = 'Redondo Beach'
UPDATE sales.customers SET city = 'North Bay' WHERE City = 'San Pablo'
UPDATE sales.customers SET city = 'North York' WHERE City = 'Palos Verdes Peninsula'
UPDATE sales.customers SET city = 'Oakville' WHERE City = 'Rosedale'
UPDATE sales.customers SET city = 'Orillia' WHERE City = 'Upland'
UPDATE sales.customers SET city = 'Oshawa' WHERE City = 'Oakland'
UPDATE sales.customers SET city = 'Ottawa' WHERE City = 'Fresno'
UPDATE sales.customers SET city = 'Parry Sound' WHERE City = 'Depew'
UPDATE sales.customers SET city = 'Perth' WHERE City = 'Port Jefferson Station'
UPDATE sales.customers SET city = 'Peterborough' WHERE City = 'San Antonio'
UPDATE sales.customers SET city = 'Picton' WHERE City = 'Glen Cove'
UPDATE sales.customers SET city = 'Port Colborne' WHERE City = 'Utica'
UPDATE sales.customers SET city = 'Saint Catharines' WHERE City = 'Lawndale'
UPDATE sales.customers SET city = 'Saint Thomas' WHERE City = 'Webster'
UPDATE sales.customers SET city = 'Sarnia-Clearwater' WHERE City = 'Pleasanton'
UPDATE sales.customers SET city = 'Sault Sainte Marie' WHERE City = 'Woodhaven'
UPDATE sales.customers SET city = 'Scarborough' WHERE City = 'Uniondale'
UPDATE sales.customers SET city = 'Simcoe' WHERE City = 'Syosset'
UPDATE sales.customers SET city = 'Stratford' WHERE City = 'Liverpool'
UPDATE sales.customers SET city = 'Sudbury' WHERE City = 'Buffalo'
UPDATE sales.customers SET city = 'Temiskaming Shores' WHERE City = 'Houston'
UPDATE sales.customers SET city = 'Thorold' WHERE City = 'Long Beach'
UPDATE sales.customers SET city = 'Thunder Bay' WHERE City = 'South El Monte'
UPDATE sales.customers SET city = 'Timmins' WHERE City = 'Nanuet'
UPDATE sales.customers SET city = 'Toronto' WHERE City = 'Bronx'
UPDATE sales.customers SET city = 'Trenton' WHERE City = 'Newburgh'
UPDATE sales.customers SET city = 'Waterloo' WHERE City = 'Ridgecrest'
UPDATE sales.customers SET city = 'Welland' WHERE City = 'San Diego'
UPDATE sales.customers SET city = 'West Nipissing' WHERE City = 'Oxnard'
UPDATE sales.customers SET city = 'Windsor' WHERE City = 'Floral Park'
UPDATE sales.customers SET city = 'Woodstock' WHERE City = 'Port Washington'
UPDATE sales.customers SET city = 'York' WHERE City = 'El Paso'
UPDATE sales.customers SET city = 'Borden' WHERE City = 'Hicksville'
UPDATE sales.customers SET city = 'Cavendish' WHERE City = 'Smithtown'
UPDATE sales.customers SET city = 'Charlottetown' WHERE City = 'Corona'
UPDATE sales.customers SET city = 'Souris' WHERE City = 'Bethpage'
UPDATE sales.customers SET city = 'Summerside' WHERE City = 'East Elmhurst'
UPDATE sales.customers SET city = 'Quebec' WHERE City = 'Apple Valley'
UPDATE sales.customers SET city = 'Asbestos' WHERE City = 'Astoria'
UPDATE sales.customers SET city = 'Baie-Comeau' WHERE City = 'Garden City'
UPDATE sales.customers SET city = 'Beloeil' WHERE City = 'Mountain View'
UPDATE sales.customers SET city = 'Cap-de-la-Madeleine' WHERE City = 'Wantagh'
UPDATE sales.customers SET city = 'Chambly' WHERE City = 'Brooklyn'
UPDATE sales.customers SET city = 'Charlesbourg' WHERE City = 'Coachella'
UPDATE sales.customers SET city = 'Ch�teauguay' WHERE City = 'Middle Village'
UPDATE sales.customers SET city = 'Chibougamau' WHERE City = 'Farmingdale'
UPDATE sales.customers SET city = 'C�te-Saint-Luc' WHERE City = 'Pomona'
UPDATE sales.customers SET city = 'Dorval' WHERE City = 'Clifton Park'
UPDATE sales.customers SET city = 'Gasp�' WHERE City = 'Forney'
UPDATE sales.customers SET city = 'Gatineau' WHERE City = 'Sacramento'
UPDATE sales.customers SET city = 'Granby' WHERE City = 'Staten Island'
UPDATE sales.customers SET city = 'Havre-Saint-Pierre' WHERE City = 'Amityville'
UPDATE sales.customers SET city = 'Hull' WHERE City = 'Tonawanda'
UPDATE sales.customers SET city = 'Jonqui�re' WHERE City = 'Carmel'
UPDATE sales.customers SET city = 'Kuujjuaq' WHERE City = 'Orchard Park'
UPDATE sales.customers SET city = 'La Salle' WHERE City = 'Brentwood'
UPDATE sales.customers SET city = 'La Tuque' WHERE City = 'Massapequa Park'
UPDATE sales.customers SET city = 'Lachine' WHERE City = 'East Northport'
UPDATE sales.customers SET city = 'Laval' WHERE City = 'Rocklin'
UPDATE sales.customers SET city = 'L�vis' WHERE City = 'Bakersfield'
UPDATE sales.customers SET city = 'Longueuil' WHERE City = 'Huntington Station'
UPDATE sales.customers SET city = 'Magog' WHERE City = 'Santa Clara'
UPDATE sales.customers SET city = 'Matane' WHERE City = 'Yuba City'
UPDATE sales.customers SET city = 'Montreal' WHERE City = 'Massapequa'
UPDATE sales.customers SET city = 'Montr�al-Nord' WHERE City = 'Rowlett'
UPDATE sales.customers SET city = 'Perc�' WHERE City = 'Campbell'
UPDATE sales.customers SET city = 'Port-Cartier' WHERE City = 'Amsterdam'
