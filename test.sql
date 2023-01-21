/*
Source Server         : DB Tests
Source Server Type    : PostgreSQL
Source Server Version : 140004
Source Host           : localhost:5433
Source Catalog        : dbprin_db

Target Server Type    : PostgreSQL
Target Server Version : 140004
File Encoding         : 65001

Date: 15/08/2022 19:17:21
 */

/*
==============================================================
CREATE TABLES
================================================================
 */
 
--
-- Name: mpaa_rating; Type: TYPE 
--
CREATE TYPE
  mpaa_rating AS ENUM ('G', 'PG', 'PG-13', 'R', 'NC-17');

--
-- Name: country; Type: TABLE
--
CREATE TABLE
  country (
    country_id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL
  );

-- ----------------------------
-- Records of country
-- ----------------------------


--
-- Name: city; Type: TABLE
--
CREATE TABLE
  city (
    city_id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country_id INTEGER NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      CONSTRAINT city_country_id_fkey FOREIGN KEY (country_id) REFERENCES country (country_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );


-- ----------------------------
-- Records of city
-- ----------------------------

--
-- Name: address; Type: TABLE
--
CREATE TABLE
  address (
    address_id SERIAL PRIMARY KEY,
    address VARCHAR(100) NOT NULL,
    address2 VARCHAR(100),
    district VARCHAR(30) NOT NULL,
    city_id INTEGER NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(15) NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      CONSTRAINT address_city_id_fkey FOREIGN KEY (city_id) REFERENCES city(city_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );


-- ----------------------------
-- Records of address
-- ----------------------------

--
-- Name: store; Type: TABLE
--
CREATE TABLE
  store (
    store_id SERIAL PRIMARY KEY,
    manager_staff_id INTEGER NOT NULL,
    address_id INTEGER NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      CONSTRAINT store_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );

-- ----------------------------
-- Records of store
-- ----------------------------

--
-- Name: staff; Type: TABLE
--
CREATE TABLE
  staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    address_id INTEGER NOT NULL,
    email VARCHAR(150),
    store_id INTEGER NOT NULL,
    active boolean DEFAULT true NOT NULL,
    username text NOT NULL,
    password text,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      picture bytea,
      CONSTRAINT staff_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT staff_store_id_fkey FOREIGN KEY (store_id) REFERENCES store(store_id)
  );

-- ----------------------------
-- Records of staff
-- ----------------------------

--
-- Name: customer; Type: TABLE
--
CREATE TABLE
  customer (
    customer_id SERIAL PRIMARY KEY,
    store_id INTEGER NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(150),
    address_id INTEGER NOT NULL,
    activebool boolean DEFAULT true NOT NULL,
    create_date date DEFAULT CURRENT_DATE NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now(),
      active INTEGER,
      CONSTRAINT customer_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT customer_store_id_fkey FOREIGN KEY (store_id) REFERENCES store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );

-- ----------------------------
-- Records of customer
-- ----------------------------

--
-- Name: actor; Type: TABLE
--
CREATE TABLE
  actor (
    actor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL
  );


-- ----------------------------
-- Records of actor
-- ----------------------------

--
-- Name: language; Type: TABLE 
--
CREATE TABLE
  language (
    language_id SERIAL PRIMARY KEY,
    name character(20) NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL
  );

-- ----------------------------
-- Records of language
-- ----------------------------

--
-- Name: movie; Type: TABLE
--
CREATE TABLE
  movie (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description text,
    release_year INTEGER,
    language_id INTEGER NOT NULL,
    original_language_id INTEGER,
    rental_duration smallint DEFAULT 3 NOT NULL,
    rental_rate numeric(4, 2) DEFAULT 4.99 NOT NULL,
    length smallint,
    replacement_cost numeric(5, 2) DEFAULT 19.99 NOT NULL,
    rating mpaa_rating DEFAULT 'G' :: mpaa_rating,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      special_features text[],
      fulltext tsvector NOT NULL,
      CONSTRAINT movie_language_id_fkey FOREIGN KEY (language_id) REFERENCES language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT movie_original_language_id_fkey FOREIGN KEY (original_language_id) REFERENCES language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );


-- ----------------------------
-- Records of movie
-- ----------------------------




--
-- Name: movie_actor; Type: TABLE
--
CREATE TABLE
  movie_actor (
    actor_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      CONSTRAINT movie_actor_pkey PRIMARY KEY (actor_id, movie_id),
      CONSTRAINT movie_actor_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT movie_actor_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );


-- ----------------------------
-- Records of movie_actor
-- ----------------------------

--
-- Name: category; Type: TABLE
--
CREATE TABLE
  category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL
  );

-- ----------------------------
-- Records of category
-- ----------------------------

--
-- Name: movie_category; Type: TABLE
--
CREATE TABLE
  movie_category (
    movie_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      CONSTRAINT movie_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES category(category_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT movie_category_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );


-- ----------------------------
-- Records of movie_category
-- ----------------------------

--
-- Name: inventory; Type: TABLE
--
CREATE TABLE
  inventory (
    inventory_id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    store_id INTEGER NOT NULL,
    last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      CONSTRAINT inventory_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT inventory_store_id_fkey FOREIGN KEY (store_id) REFERENCES store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );


-- ----------------------------
-- Records of inventory
-- ----------------------------

--
-- Name: rental; Type: TABLE
--
CREATE TABLE
  rental (
    rental_id SERIAL PRIMARY KEY,
    rental_date timestamp
    with
      time zone NOT NULL,
      inventory_id INTEGER NOT NULL,
      customer_id INTEGER NOT NULL,
      return_date timestamp
    with
      time zone,
      staff_id INTEGER NOT NULL,
      last_update timestamp
    with
      time zone DEFAULT now() NOT NULL,
      CONSTRAINT rental_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT rental_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id) ON UPDATE CASCADE ON DELETE RESTRICT,
      CONSTRAINT rental_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT
  );


-- ----------------------------
-- Records of rental
-- ----------------------------

--
-- Name: payment; Type: TABLE
--
CREATE TABLE
  payment (
    payment_id SERIAL,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL,
      CONSTRAINT payment_id_pkey PRIMARY KEY (payment_id, payment_date)
  ) PARTITION BY RANGE (payment_date);

--
-- Name: payment_p2022_01; Type: TABLE
--
CREATE TABLE
  payment_p2022_01 (
    payment_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL,
      CONSTRAINT payment_p2022_01_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
      CONSTRAINT payment_p2022_01_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
      CONSTRAINT payment_p2022_01_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
      CONSTRAINT payment_p2022_02_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
  );

--
-- Data for Name: payment_p2022_01; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- Name: payment_p2022_02; Type: TABLE
--
CREATE TABLE
  payment_p2022_02 (
    payment_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL,
      CONSTRAINT payment_p2022_02_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
      CONSTRAINT payment_p2022_02_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
  );

--
-- Data for Name: payment_p2022_02; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- Name: payment_p2022_03; Type: TABLE
--
CREATE TABLE
  payment_p2022_03 (
    payment_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL,
      CONSTRAINT payment_p2022_03_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
      CONSTRAINT payment_p2022_03_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
      CONSTRAINT payment_p2022_03_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
  );

 --
-- Data for Name: payment_p2022_03; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- Name: payment_p2022_04; Type: TABLE
--
CREATE TABLE
  payment_p2022_04 (
    payment_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL,
      CONSTRAINT payment_p2022_04_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
      CONSTRAINT payment_p2022_04_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
      CONSTRAINT payment_p2022_04_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
  );

--
-- Data for Name: payment_p2022_04; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- Name: payment_p2022_05; Type: TABLE
--
CREATE TABLE
  payment_p2022_05 (
    payment_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL,
      CONSTRAINT payment_p2022_05_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
      CONSTRAINT payment_p2022_05_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
      CONSTRAINT payment_p2022_05_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
  );

--
-- Data for Name: payment_p2022_05; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- Name: payment_p2022_06; Type: TABLE
--
CREATE TABLE
  payment_p2022_06 (
    payment_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL,
      CONSTRAINT payment_p2022_06_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
      CONSTRAINT payment_p2022_06_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id),
      CONSTRAINT payment_p2022_06_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
  );


--
-- Data for Name: payment_p2022_06; Type: TABLE DATA; Schema: public; Owner: postgres
--


--
-- Name: payment_p2022_07; Type: TABLE
--
CREATE TABLE
  payment_p2022_07 (
    payment_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount numeric(5, 2) NOT NULL,
    payment_date timestamp
    with
      time zone NOT NULL
  );

--
-- Data for Name: payment_p2022_07; Type: TABLE DATA; Schema: public; Owner: postgres
--


/*
==============================================================
CREATE FUNCTIONS
==============================================================
 */
--
-- Name: year; Type: DOMAIN
--
CREATE DOMAIN
  year AS integer CONSTRAINT year_check CHECK (
    (
      (VALUE >= 1901)
      AND (VALUE <= 2155)
    )
  );

--
-- Name: _group_concat(text, text); Type: FUNCTION
--
CREATE FUNCTION
  group_concat(text, text) RETURNS text LANGUAGE sql IMMUTABLE AS $_$
SELECT CASE
  WHEN $2 IS NULL THEN $1
  WHEN $1 IS NULL THEN $2
  ELSE $1 || ', ' || $2
END
$_$;

CREATE AGGREGATE
  group_concat(text) (SFUNC = group_concat, STYPE = text);

--
-- Name: inventory_in_stock(integer); Type: FUNCTION
--
CREATE FUNCTION
  inventory_in_stock(p_inventory_id integer) RETURNS boolean LANGUAGE plpgsql AS $$
DECLARE
    v_rentals INTEGER;
    v_out     INTEGER;
BEGIN
    -- AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    -- FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT count(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END $$;

--
-- Name: movie_in_stock(integer, integer); Type: FUNCTION
--
CREATE FUNCTION
  movie_in_stock(
    p_movie_id integer,
    p_store_id integer,
    OUT p_movie_count integer
  ) RETURNS SETOF integer LANGUAGE sql AS $_$
     SELECT inventory_id
     FROM inventory
     WHERE movie_id = $1
     AND store_id = $2
     AND inventory_in_stock(inventory_id);
$_$;

--
-- Name: movie_not_in_stock(integer, integer); Type: FUNCTION
--
CREATE FUNCTION
  movie_not_in_stock(
    p_movie_id integer,
    p_store_id integer,
    OUT p_movie_count integer
  ) RETURNS SETOF integer LANGUAGE sql AS $_$
    SELECT inventory_id
    FROM inventory
    WHERE movie_id = $1
    AND store_id = $2
    AND NOT inventory_in_stock(inventory_id);
$_$;

--
-- Name: get_customer_balance(integer, timestamp with time zone); Type: FUNCTION
--
CREATE FUNCTION
  get_customer_balance(
    p_customer_id integer,
    p_effective_date timestamp
    with
      time zone
  ) RETURNS numeric LANGUAGE plpgsql AS $$
       --#OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       --#THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       --#   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       --#   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       --#   3) IF A movie IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       --#   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED
DECLARE
    v_rentfees DECIMAL(5,2); --#FEES PAID TO RENT THE VIDEOS INITIALLY
    v_overfees INTEGER;      --#LATE FEES FOR PRIOR RENTALS
    v_payments DECIMAL(5,2); --#SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN
    SELECT COALESCE(SUM(movie.rental_rate),0) INTO v_rentfees
    FROM movie, inventory, rental
    WHERE movie.movie_id = inventory.movie_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(IF((rental.return_date - rental.rental_date) > (movie.rental_duration * '1 day'::interval),
        ((rental.return_date - rental.rental_date) - (movie.rental_duration * '1 day'::interval)),0)),0) INTO v_overfees
    FROM rental, inventory, movie
    WHERE movie.movie_id = inventory.movie_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(payment.amount),0) INTO v_payments
    FROM payment
    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

    RETURN v_rentfees + v_overfees - v_payments;
END
$$;

--
-- Name: inventory_held_by_customer(integer); Type: FUNCTION
--
CREATE FUNCTION
  inventory_held_by_customer(p_inventory_id integer) RETURNS integer LANGUAGE plpgsql AS $$
DECLARE
    v_customer_id INTEGER;
BEGIN

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END $$;

--
-- Name: last_day(timestamp with time zone); Type: FUNCTION
--
CREATE FUNCTION
  last_day(
    timestamp
    with
      time zone
  ) RETURNS date LANGUAGE sql IMMUTABLE STRICT AS $_$
  SELECT CASE
    WHEN EXTRACT(MONTH FROM $1) = 12 THEN
      (((EXTRACT(YEAR FROM $1) + 1) operator(pg_catalog.||) '-01-01')::date - INTERVAL '1 day')::date
    ELSE
      ((EXTRACT(YEAR FROM $1) operator(pg_catalog.||) '-' operator(pg_catalog.||) (EXTRACT(MONTH FROM $1) + 1) operator(pg_catalog.||) '-01')::date - INTERVAL '1 day')::date
    END
$_$;

--
-- Name: last_updated(); Type: FUNCTION
--
CREATE FUNCTION
  last_updated() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END $$;

--
-- Name: rewards_report(integer, numeric); Type: FUNCTION
--
CREATE FUNCTION
  rewards_report(
    min_monthly_purchases integer,
    min_dollar_amount_purchased numeric
  ) RETURNS SETOF customer LANGUAGE plpgsql SECURITY DEFINER AS $_$
DECLARE
    last_month_start DATE;
    last_month_end DATE;
rr RECORD;
tmpSQL TEXT;
BEGIN

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        RAISE EXCEPTION 'Minimum monthly purchases parameter must be > 0';
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        RAISE EXCEPTION 'Minimum monthly dollar amount purchased parameter must be > $0.00';
    END IF;

    last_month_start := CURRENT_DATE - '3 month'::interval;
    last_month_start := to_date((extract(YEAR FROM last_month_start) || '-' || extract(MONTH FROM last_month_start) || '-01'),'YYYY-MM-DD');
    last_month_end := LAST_DAY(last_month_start);

    /*
    Create a temporary storage area for Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id INTEGER NOT NULL PRIMARY KEY);

    /*
    Find all customers meeting the monthly purchase requirements
    */

    tmpSQL := '        SELECT p.customer_id
        FROM payment AS p
        WHERE DATE(p.payment_date) BETWEEN '||quote_literal(last_month_start) ||' AND '|| quote_literal(last_month_end) || '
        GROUP BY customer_id
        HAVING SUM(p.amount) > '|| min_dollar_amount_purchased || '
        AND COUNT(customer_id) > ' ||min_monthly_purchases ;

    EXECUTE tmpSQL;

    /*
    Output ALL customer information of matching rewardees.
    Customize output as needed.
    */
    FOR rr IN EXECUTE 'SELECT c.* FROM tmpCustomer AS t INNER JOIN customer AS c ON t.customer_id = c.customer_id' LOOP
        RETURN NEXT rr;
    END LOOP;

    /* Clean up */
    tmpSQL := 'DROP TABLE tmpCustomer';
    EXECUTE tmpSQL;

RETURN;
END
$_$;

/*
===========================================================
VIEWS
==============================================================
 */
--
-- Name: actor_info; Type: VIEW
--
CREATE VIEW
  actor_info AS
SELECT
  a.actor_id,
  a.first_name,
  a.last_name,
  group_concat(
    DISTINCT (
      (c.name || ': ' :: text) || (
        SELECT
          group_concat(f.title) AS group_concat
        FROM
          (
            (
              movie f
              JOIN movie_category fc_1 ON ((f.movie_id = fc_1.movie_id))
            )
            JOIN movie_actor fa_1 ON ((f.movie_id = fa_1.movie_id))
          )
        WHERE
          (
            (fc_1.category_id = c.category_id)
            AND (fa_1.actor_id = a.actor_id)
          )
        GROUP BY
          fa_1.actor_id
      )
    )
  ) movie_info
FROM
  (
    (
      (
        actor a
        LEFT JOIN movie_actor fa ON ((a.actor_id = fa.actor_id))
      )
      LEFT JOIN movie_category fc ON ((fa.movie_id = fc.movie_id))
    )
    LEFT JOIN category c ON ((fc.category_id = c.category_id))
  )
GROUP BY
  a.actor_id,
  a.first_name,
  a.last_name;

--
-- Name: customer_list; Type: VIEW
--
CREATE VIEW
  customer_list AS
SELECT
  cu.customer_id AS id,
  ((cu.first_name || ' ' :: text) || cu.last_name) AS name,
  a.address,
  a.postal_code AS "zip code",
  a.phone,
  city.city,
  country.country,
  CASE
    WHEN cu.activebool THEN 'active' :: text
    ELSE '' :: text
  END AS notes,
  cu.store_id AS sid
FROM
  (
    (
      (
        customer cu
        JOIN address a ON ((cu.address_id = a.address_id))
      )
      JOIN city ON ((a.city_id = city.city_id))
    )
    JOIN country ON ((city.country_id = country.country_id))
  );

--
-- Name: movie_list; Type: VIEW
--
CREATE VIEW
  movie_list AS
SELECT
  movie.movie_id AS fid,
  movie.title,
  movie.description,
  category.name AS category,
  movie.rental_rate AS price,
  movie.length,
  movie.rating,
  group_concat(((actor.first_name || ' ' :: text) || actor.last_name)) AS actors
FROM
  (
    (
      (
        (
          category
          LEFT JOIN movie_category ON ((category.category_id = movie_category.category_id))
        )
        LEFT JOIN movie ON ((movie_category.movie_id = movie.movie_id))
      )
      JOIN movie_actor ON ((movie.movie_id = movie_actor.movie_id))
    )
    JOIN actor ON ((movie_actor.actor_id = actor.actor_id))
  )
GROUP BY
  movie.movie_id,
  movie.title,
  movie.description,
  category.name,
  movie.rental_rate,
  movie.length,
  movie.rating;

--
-- Name: nicer_but_slower_movie_list; Type: VIEW 
--
CREATE VIEW
  nicer_but_slower_movie_list AS
SELECT
  movie.movie_id AS fid,
  movie.title,
  movie.description,
  category.name AS category,
  movie.rental_rate AS price,
  movie.length,
  movie.rating,
  group_concat(
    (
      (
        (
          upper("substring"(actor.first_name, 1, 1)) || lower("substring"(actor.first_name, 2))
        ) || upper("substring"(actor.last_name, 1, 1))
      ) || lower("substring"(actor.last_name, 2))
    )
  ) AS actors
FROM
  (
    (
      (
        (
          category
          LEFT JOIN movie_category ON ((category.category_id = movie_category.category_id))
        )
        LEFT JOIN movie ON ((movie_category.movie_id = movie.movie_id))
      )
      JOIN movie_actor ON ((movie.movie_id = movie_actor.movie_id))
    )
    JOIN actor ON ((movie_actor.actor_id = actor.actor_id))
  )
GROUP BY
  movie.movie_id,
  movie.title,
  movie.description,
  category.name,
  movie.rental_rate,
  movie.length,
  movie.rating;

--
-- Name: rental_by_category; Type: MATERIALIZED VIEW
--
CREATE MATERIALIZED VIEW
  rental_by_category AS
SELECT
  c.name AS category,
  sum(p.amount) AS total_sales
FROM
  (
    (
      (
        (
          (payment p
          JOIN rental r ON ((p.rental_id = r.rental_id)))
          JOIN inventory i ON ((r.inventory_id = i.inventory_id))
        )
        JOIN movie f ON ((i.movie_id = f.movie_id))
      )
      JOIN movie_category fc ON ((f.movie_id = fc.movie_id))
    )
    JOIN category c ON ((fc.category_id = c.category_id))
  )
GROUP BY
  c.name
ORDER BY
  (sum(p.amount)) DESC
WITH
  NO DATA;

--
-- Name: sales_by_movie_category; Type: VIEW
--
CREATE VIEW
  sales_by_movie_category AS
SELECT
  c.name AS category,
  sum(p.amount) AS total_sales
FROM
  (
    (
      (
        (
          (payment p
          JOIN rental r ON ((p.rental_id = r.rental_id)))
          JOIN inventory i ON ((r.inventory_id = i.inventory_id))
        )
        JOIN movie f ON ((i.movie_id = f.movie_id))
      )
      JOIN movie_category fc ON ((f.movie_id = fc.movie_id))
    )
    JOIN category c ON ((fc.category_id = c.category_id))
  )
GROUP BY
  c.name
ORDER BY
  (sum(p.amount)) DESC;

--
-- Name: sales_by_store; Type: VIEW
--
CREATE VIEW
  sales_by_store AS
SELECT
  ((c.city || ',' :: text) || cy.country) AS store,
  ((m.first_name || ' ' :: text) || m.last_name) AS manager,
  sum(p.amount) AS total_sales
FROM
  (
    (
      (
        (
          (
            (
              (payment p
              JOIN rental r ON ((p.rental_id = r.rental_id)))
              JOIN inventory i ON ((r.inventory_id = i.inventory_id))
            )
            JOIN store s ON ((i.store_id = s.store_id))
          )
          JOIN address a ON ((s.address_id = a.address_id))
        )
        JOIN city c ON ((a.city_id = c.city_id))
      )
      JOIN country cy ON ((c.country_id = cy.country_id))
    )
    JOIN staff m ON ((s.manager_staff_id = m.staff_id))
  )
GROUP BY
  cy.country,
  c.city,
  s.store_id,
  m.first_name,
  m.last_name
ORDER BY
  cy.country,
  c.city;

CREATE VIEW
  staff_list AS
SELECT
  s.staff_id AS id,
  ((s.first_name || ' ' :: text) || s.last_name) AS name,
  a.address,
  a.postal_code AS "zip code",
  a.phone,
  city.city,
  country.country,
  s.store_id AS sid
FROM
  (
    (
      (
        staff s
        JOIN address a ON ((s.address_id = a.address_id))
      )
      JOIN city ON ((a.city_id = city.city_id))
    )
    JOIN country ON ((city.country_id = country.country_id))
  );

/*
==============================================================
CREATE INDEX
=================================================================
 */
--
-- Name: movie_fulltext_idx; Type: INDEX
--
CREATE INDEX
  movie_fulltext_idx ON movie USING gist (fulltext);

--
-- Name: idx_actor_last_name; Type: INDEX
--
CREATE INDEX
  idx_actor_last_name ON actor USING btree (last_name);

--
-- Name: idx_fk_address_id; Type: INDEX
--
CREATE INDEX
  idx_fk_address_id ON customer USING btree (address_id);

--
-- Name: idx_fk_city_id; Type: INDEX
--
CREATE INDEX
  idx_fk_city_id ON address USING btree (city_id);

--
-- Name: idx_fk_country_id; Type: INDEX
--
CREATE INDEX
  idx_fk_country_id ON city USING btree (country_id);

--
-- Name: idx_fk_movie_id; Type: INDEX
--
CREATE INDEX
  idx_fk_movie_id ON movie_actor USING btree (movie_id);

--
-- Name: idx_fk_inventory_id; Type: INDEX
--
CREATE INDEX
  idx_fk_inventory_id ON rental USING btree (inventory_id);

--
-- Name: idx_fk_language_id; Type: INDEX
--
CREATE INDEX
  idx_fk_language_id ON movie USING btree (language_id);

--
-- Name: idx_fk_original_language_id; Type: INDEX
--
CREATE INDEX
  idx_fk_original_language_id ON movie USING btree (original_language_id);

--
-- Name: idx_fk_payment_p2022_01_customer_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_01_customer_id ON payment_p2022_01 USING btree (customer_id);

--
-- Name: idx_fk_payment_p2022_01_staff_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_01_staff_id ON payment_p2022_01 USING btree (staff_id);

--
-- Name: idx_fk_payment_p2022_02_customer_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_02_customer_id ON payment_p2022_02 USING btree (customer_id);

--
-- Name: idx_fk_payment_p2022_02_staff_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_02_staff_id ON payment_p2022_02 USING btree (staff_id);

--
-- Name: idx_fk_payment_p2022_03_customer_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_03_customer_id ON payment_p2022_03 USING btree (customer_id);

--
-- Name: idx_fk_payment_p2022_03_staff_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_03_staff_id ON payment_p2022_03 USING btree (staff_id);

--
-- Name: idx_fk_payment_p2022_04_customer_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_04_customer_id ON payment_p2022_04 USING btree (customer_id);

--
-- Name: idx_fk_payment_p2022_04_staff_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_04_staff_id ON payment_p2022_04 USING btree (staff_id);

--
-- Name: idx_fk_payment_p2022_05_customer_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_05_customer_id ON payment_p2022_05 USING btree (customer_id);

--
-- Name: idx_fk_payment_p2022_05_staff_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_05_staff_id ON payment_p2022_05 USING btree (staff_id);

--
-- Name: idx_fk_payment_p2022_06_customer_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_06_customer_id ON payment_p2022_06 USING btree (customer_id);

--
-- Name: idx_fk_payment_p2022_06_staff_id; Type: INDEX
--
CREATE INDEX
  idx_fk_payment_p2022_06_staff_id ON payment_p2022_06 USING btree (staff_id);

--
-- Name: idx_fk_store_id; Type: INDEX
--
CREATE INDEX
  idx_fk_store_id ON customer USING btree (store_id);

--
-- Name: idx_last_name; Type: INDEX
--
CREATE INDEX
  idx_last_name ON customer USING btree (last_name);

--
-- Name: idx_store_id_movie_id; Type: INDEX
--
CREATE INDEX
  idx_store_id_movie_id ON inventory USING btree (store_id, movie_id);

--
-- Name: idx_title; Type: INDEX
--
CREATE INDEX
  idx_title ON movie USING btree (title);

--
-- Name: idx_unq_manager_staff_id; Type: INDEX
--
CREATE UNIQUE INDEX idx_unq_manager_staff_id ON store USING btree (manager_staff_id);

--
-- Name: idx_unq_rental_rental_date_inventory_id_customer_id; Type: INDEX
--
CREATE UNIQUE INDEX idx_unq_rental_rental_date_inventory_id_customer_id ON rental USING btree (rental_date, inventory_id, customer_id);

--
-- Name: payment_p2022_01_customer_id_idx; Type: INDEX
--
CREATE INDEX
  payment_p2022_01_customer_id_idx ON payment_p2022_01 USING btree (customer_id);

--
-- Name: payment_p2022_02_customer_id_idx; Type: INDEX
--
CREATE INDEX
  payment_p2022_02_customer_id_idx ON payment_p2022_02 USING btree (customer_id);

--
-- Name: payment_p2022_03_customer_id_idx; Type: INDEX
--
CREATE INDEX
  payment_p2022_03_customer_id_idx ON payment_p2022_03 USING btree (customer_id);

--
-- Name: payment_p2022_04_customer_id_idx; Type: INDEX
--
CREATE INDEX
  payment_p2022_04_customer_id_idx ON payment_p2022_04 USING btree (customer_id);

--
-- Name: payment_p2022_05_customer_id_idx; Type: INDEX
--
CREATE INDEX
  payment_p2022_05_customer_id_idx ON payment_p2022_05 USING btree (customer_id);

--
-- Name: payment_p2022_06_customer_id_idx; Type: INDEX
--
CREATE INDEX
  payment_p2022_06_customer_id_idx ON payment_p2022_06 USING btree (customer_id);

--
-- Name: rental_category; Type: INDEX
--
CREATE UNIQUE INDEX rental_category ON rental_by_category USING btree (category);

/*
==============================================================
CREATE TRIGGERS
================================================================
 */
--
-- Name: movie movie_fulltext_trigger; Type: TRIGGER
--
CREATE TRIGGER
  movie_fulltext_trigger BEFORE
  OR
UPDATE
  ON movie FOR EACH ROW
EXECUTE
  FUNCTION tsvector_update_trigger(
    'fulltext',
    'pg_catalog.english',
    'title',
    'description'
  );

--
-- Name: actor last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON actor FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: address last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON address FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: category last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON category FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: city last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON city FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: country last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON country FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: customer last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON customer FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: movie last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON movie FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: movie_actor last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON movie_actor FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: movie_category last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON movie_category FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: inventory last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON inventory FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: language last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON language FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: rental last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON rental FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: staff last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON staff FOR EACH ROW
EXECUTE
  FUNCTION last_updated();

--
-- Name: store last_updated; Type: TRIGGER
--
CREATE TRIGGER
  last_updated BEFORE
UPDATE
  ON store FOR EACH ROW
EXECUTE
  FUNCTION last_updated();
--
--  Type: SEQUENCE SETS
--

SELECT pg_catalog.setval('actor_actor_id_seq', 200, true);
SELECT pg_catalog.setval('address_address_id_seq', 605, true);
SELECT pg_catalog.setval('category_category_id_seq', 16, true);
SELECT pg_catalog.setval('city_city_id_seq', 600, true);
SELECT pg_catalog.setval('country_country_id_seq', 109, true);
SELECT pg_catalog.setval('customer_customer_id_seq', 599, true);
SELECT pg_catalog.setval('movie_movie_id_seq', 1000, true);
SELECT pg_catalog.setval('inventory_inventory_id_seq', 4581, true);
SELECT pg_catalog.setval('language_language_id_seq', 6, true);
SELECT pg_catalog.setval('payment_payment_id_seq', 32098, true);
SELECT pg_catalog.setval('rental_rental_id_seq', 16049, true);
SELECT pg_catalog.setval('staff_staff_id_seq', 2, true);
SELECT pg_catalog.setval('store_store_id_seq', 2, true);

--
-- PostgreSQL movie_rental database instalation complete
--
