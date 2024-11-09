--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: order_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_list (
    order_list_id integer NOT NULL,
    order_id integer,
    product_id integer,
    quantity integer,
    subtotal numeric(10,2)
);


ALTER TABLE public.order_list OWNER TO postgres;

--
-- Name: order_list_order_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_list_order_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_list_order_list_id_seq OWNER TO postgres;

--
-- Name: order_list_order_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_list_order_list_id_seq OWNED BY public.order_list.order_list_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    order_date timestamp with time zone,
    order_type character varying(50),
    store_id integer,
    transaction_number integer,
    total_amount numeric(9,2)
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(100),
    product_price numeric(10,2),
    category_id integer,
    product_image text,
    product_type character varying(20)
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotions (
    promo_id integer NOT NULL,
    promo_image text,
    promo_title character varying(255),
    promo_description text,
    active boolean DEFAULT true
);


ALTER TABLE public.promotions OWNER TO postgres;

--
-- Name: promotions_promo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotions_promo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotions_promo_id_seq OWNER TO postgres;

--
-- Name: promotions_promo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotions_promo_id_seq OWNED BY public.promotions.promo_id;


--
-- Name: recommendations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recommendations (
    recommendation_id integer NOT NULL,
    recommendation text,
    date_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.recommendations OWNER TO postgres;

--
-- Name: recommendations_recommendation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recommendations_recommendation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recommendations_recommendation_id_seq OWNER TO postgres;

--
-- Name: recommendations_recommendation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recommendations_recommendation_id_seq OWNED BY public.recommendations.recommendation_id;


--
-- Name: store_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_location (
    store_id integer NOT NULL,
    store_name character varying(100),
    address text,
    latitude numeric(9,6),
    longitude numeric(9,6)
);


ALTER TABLE public.store_location OWNER TO postgres;

--
-- Name: store_location_store_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_location_store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.store_location_store_id_seq OWNER TO postgres;

--
-- Name: store_location_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_location_store_id_seq OWNED BY public.store_location.store_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    birth_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    role character varying(10),
    email character varying(50),
    password character varying(100),
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['manager'::character varying, 'owner'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: order_list order_list_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_list ALTER COLUMN order_list_id SET DEFAULT nextval('public.order_list_order_list_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Name: promotions promo_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions ALTER COLUMN promo_id SET DEFAULT nextval('public.promotions_promo_id_seq'::regclass);


--
-- Name: recommendations recommendation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendations ALTER COLUMN recommendation_id SET DEFAULT nextval('public.recommendations_recommendation_id_seq'::regclass);


--
-- Name: store_location store_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_location ALTER COLUMN store_id SET DEFAULT nextval('public.store_location_store_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name) FROM stdin;
1	Light Bites
2	Burger & Sandwiches
3	Pasta
4	Frappe Non-coffee base
5	Frappe Coffee base
6	Pizza
7	Espresso Cold
8	Sparkling Soda
9	Espresso Hot
10	All Day Breakfast
11	Chicken Wings
12	Cookies
13	Rice Meal
14	Fruit Tea
15	Beer
16	222
17	2221
21	22211
22	22211111
23	sdfds2222
24	333
25	234234
26	hehe
\.


--
-- Data for Name: order_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_list (order_list_id, order_id, product_id, quantity, subtotal) FROM stdin;
35	59	1	5	845.00
36	58	1	5	695.00
37	58	1	5	800.00
38	58	1	2	278.00
39	58	1	2	498.00
40	58	1	5	1195.00
41	59	1	2	438.00
42	61	1	3	360.00
43	59	1	5	1245.00
44	61	1	2	318.00
45	61	1	5	750.00
46	61	1	2	498.00
47	60	10	3	777.00
48	60	1	5	600.00
49	60	1	5	650.00
50	62	1	1	139.00
51	62	1	2	240.00
52	63	1	3	450.00
53	63	1	3	480.00
54	63	1	1	389.00
55	63	10	2	518.00
56	63	1	3	327.00
57	64	1	2	338.00
58	64	1	1	160.00
59	64	1	2	200.00
60	64	1	3	597.00
61	64	1	1	160.00
64	67	1	4	480.00
65	67	1	2	318.00
66	67	1	4	600.00
68	67	1	5	1245.00
69	66	1	453	67950.00
70	66	1	34	5440.00
71	66	1	53	20617.00
72	66	10	23	5957.00
73	66	1	3	327.00
74	68	10	4	1036.00
75	68	1	34	4080.00
76	68	1	25	3250.00
77	69	1	3	417.00
78	69	1	123	14760.00
79	70	1	443	61577.00
80	70	1	5	800.00
81	70	1	453	62967.00
82	70	1	4	996.00
83	70	1	1	239.00
84	71	1	324	54756.00
85	71	1	2	320.00
86	71	1	34	3400.00
87	71	1	22	4378.00
88	71	1	2	320.00
116	79	10	3	777.00
117	80	1	3	360.00
118	80	1	2	318.00
119	80	1	5	750.00
120	80	1	2	498.00
121	79	1	5	600.00
122	79	1	5	650.00
123	81	1	5	695.00
124	81	1	5	800.00
125	81	1	2	278.00
126	81	1	2	498.00
127	81	1	5	1195.00
128	82	1	5	845.00
129	82	1	2	438.00
130	82	1	5	1245.00
131	83	1	3	450.00
132	83	1	3	480.00
133	83	1	1	389.00
134	83	10	2	518.00
135	83	1	3	327.00
136	84	1	2	338.00
137	84	1	1	160.00
138	84	1	2	200.00
139	84	1	3	597.00
140	84	1	1	160.00
141	85	1	1	139.00
142	85	1	2	240.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, order_date, order_type, store_id, transaction_number, total_amount) FROM stdin;
58	2022-08-06 00:00:00+08	Take Out	1	4	3466.00
59	2022-08-06 00:00:00+08	Take Out	1	1	2528.00
60	2022-08-06 00:00:00+08	Dine In	1	3	2027.00
61	2022-08-06 00:00:00+08	Dine In	1	7	1926.00
62	2022-08-06 00:00:00+08	Dine In	1	5	379.00
63	2022-08-06 00:00:00+08	Dine In	1	2	2164.00
64	2022-08-06 00:00:00+08	Dine In	1	6	1455.00
66	2022-06-02 00:00:00+08	Dine In	1	9	100291.00
67	2022-06-02 00:00:00+08	Dine In	1	14	2643.00
68	2022-06-02 00:00:00+08	Dine In	1	10	8366.00
69	2022-06-02 00:00:00+08	Dine In	1	12	15177.00
70	2022-06-02 00:00:00+08	Take Out	1	11	126579.00
71	2022-06-02 00:00:00+08	Dine In	1	13	63174.00
79	2022-07-14 00:00:00+08	Dine In	1	3	2027.00
80	2022-07-29 00:00:00+08	Dine In	1	7	1926.00
81	2022-07-21 00:00:00+08	Take Out	1	4	3466.00
82	2022-07-06 00:00:00+08	Take Out	1	1	2528.00
83	2022-07-09 00:00:00+08	Dine In	1	2	2164.00
84	2022-07-28 00:00:00+08	Dine In	1	6	1455.00
85	2022-07-22 00:00:00+08	Dine In	1	5	379.00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, product_price, category_id, product_image, product_type) FROM stdin;
1	Fries	3.50	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
2	Garlic Bread	4.00	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
3	Cheese Sticks	4.50	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
4	Spring Rolls	5.00	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
5	Cheeseburger	6.50	2	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
6	Chicken Sandwich	6.00	2	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
7	Veggie Burger	5.75	2	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
8	Club Sandwich	7.00	2	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
11	Pesto Pasta	7.75	3	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
12	Mac & Cheese	7.00	3	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
13	Vanilla Frappe	4.50	4	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
14	Strawberry Frappe	4.75	4	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
15	Matcha Frappe	5.00	4	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
17	Mocha Frappe	5.50	5	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
18	Caramel Frappe	5.75	5	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
19	Hazelnut Frappe	5.75	5	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
20	Espresso Frappe	5.50	5	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
21	Pepperoni Pizza	10.00	6	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
22	Margherita Pizza	9.50	6	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
23	BBQ Chicken Pizza	11.00	6	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
24	Veggie Pizza	9.75	6	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
16	Chocolate Frappe	4.75	4	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
10	Carbonara	8.00	3	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
9	Spaghetti Bolognese	85.00	3	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
25	Iced Latte	4.00	7	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
26	Iced Americano	3.75	7	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
27	Iced Cappuccino	4.25	7	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
28	Iced Mocha	4.50	7	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
29	Lemon Sparkling	3.50	8	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
30	Orange Sparkling	3.75	8	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
31	Berry Sparkling	4.00	8	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
32	Mint Sparkling	3.50	8	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
33	Espresso	2.50	9	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
34	Americano	3.00	9	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
35	Cappuccino	3.75	9	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
36	Latte	4.00	9	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
37	Pancakes	6.00	10	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
45	Chocolate Chip Cookie	1.50	12	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
46	Oatmeal Raisin Cookie	1.75	12	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
47	Peanut Butter Cookie	1.80	12	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
48	White Chocolate Cookie	1.90	12	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
38	Waffles	6.50	10	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
39	Omelette	5.50	10	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
40	French Toast	5.75	10	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
41	Buffalo Wings	7.50	11	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
42	BBQ Wings	7.75	11	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
43	Garlic Parmesan Wings	8.00	11	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
44	Spicy Wings	8.25	11	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
49	Chicken Rice	5.50	13	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
50	Pork Rice	5.75	13	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
51	Lemon Fruit Tea	3.50	14	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
52	Peach Fruit Tea	3.75	14	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
53	Mango Fruit Tea	3.80	14	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
54	Apple Fruit Tea	3.60	14	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
55	Lager	4.00	15	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
56	Pale Ale	4.25	15	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Drink
57	jw	23.00	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
58	qweqwe	561.00	10	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
61	\N	\N	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
62	dsf	432423.00	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
63	w	4324.00	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
66	21312312	312312.00	1	..\\frontend\\src\\assets\\products\\1731023760499.jpg	Meal
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (promo_id, promo_image, promo_title, promo_description, active) FROM stdin;
2	..\\kape-main\\src\\assets\\promos\\1731072136535.png	123123	123	t
3	..\\kape-main\\src\\assets\\promos\\1731138246296.jpg	jhjsdfsd	sdfsd	t
\.


--
-- Data for Name: recommendations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recommendations (recommendation_id, recommendation, date_created) FROM stdin;
\.


--
-- Data for Name: store_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_location (store_id, store_name, address, latitude, longitude) FROM stdin;
1	Coffee Beer Cafe	P. Burgos Street Barangay 10, Batangas City, 4200, Batangas	13.759106	121.055285
2	Coffee Beer Cafe	Maharlika Highway, Barangay Tiaong, 4325, Quezon	13.945031	121.360418
3	Coffee Beer Cafe	Lower Ground Level, One Ayala, 1 Ayala Ave, Makati, Metro Manila	14.550253	121.023775
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, first_name, last_name, birth_date, created_at, role, email, password) FROM stdin;
1	John	Doe	2000-01-15	2024-11-01 21:51:19.43417	owner	johndoe@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
5	Charlie	Davis	1985-02-18	2024-11-01 21:51:19.43417	manager	charliedavis@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
6	Diana	Wilson	2001-04-12	2024-11-01 21:51:19.43417	manager	dianawilson@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
7	Ethan	Taylor	1990-09-25	2024-11-01 21:51:19.43417	manager	ethantaylor@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
8	Fiona	Anderson	1978-12-01	2024-11-01 21:51:19.43417	manager	fionaanderson@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
9	George	Thomas	1994-07-14	2024-11-01 21:51:19.43417	manager	georgethomas@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
10	Hannah	Moore	1993-08-19	2024-11-01 21:51:19.43417	manager	hannahmoore@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
12	Justmyr	Gutierrez	2024-11-21	2024-11-02 01:28:47.507752	manager	justmyrgutierrez92@gmail.com	$2b$10$6ra1XdzHNOQ1.iptyIo8m./m4bmQ0VKs9fjbnobirbja3AqLIrusa
13	Justmyr	Gutierrez	2024-11-21	2024-11-02 01:30:45.628182	manager	justmyrgutierrez92@gmail.com	$2b$10$pnhtumNTvW579jrKaaJJAuFgzPgRUTcxbV/ZG98kBSMyVLGXJ603G
14	asdasd	;adk;l	0001-02-12	2024-11-02 01:31:08.654952	manager	asd@gmail.com	$2b$10$GlMWb/zXjbF.9ynJgYjgYutEbGIfMzYXFR9Nm3MezZQjqwwiUc1m.
16	asdasd	;adk;l	0001-02-12	2024-11-02 01:32:15.370327	manager	asd@gmail.com	$2b$10$9Vu63RrvbDEjgOLKkGUaTOOhRH.muISz5qD6PNwNoXH1n4tOvtrHq
18	dasdasdasdasd	asdlasd;lk	2024-11-28	2024-11-02 01:37:31.369777	manager	asdaskdl@gmail.com	$2b$10$H8d.M2QrBv53jwoqGl/jLOE4DTW3g9MJ3csXO/eFWodY273MgG.9y
19	a	k	0081-03-12	2024-11-02 01:40:52.593024	manager	oiiuossdii@gmail.com	$2b$10$iRjOWIfVqyj020mQp9KtvOIhVnHWo5nRm0ZWyxRAEbQUQ4uTDpHpi
20	asdasldk	;lk;lkl	1989-03-12	2024-11-02 01:43:23.298077	manager	adas@s.com	$2b$10$QWwGX2L4cpmb.GdotDTUIuqz/0hHMdmIeMnegbsUJhIoJep8WJ5qa
21	sadasd	kljkj	0008-07-08	2024-11-02 01:43:33.999913	manager	adas@s.com	$2b$10$H6kwG.8.7NJg1lvseLB9KedVDtzc.MUfomv3vNaJ/qvClgDgWP5jS
23	Jane	Smith	1988-05-23	2024-11-02 01:44:47.120686	owner	janesmith@example.com	password123
24	Robert	Brown	1995-02-14	2024-11-02 01:44:47.120686	manager	robertbrown@example.com	password123
25	Emily	Johnson	1992-08-09	2024-11-02 01:44:47.120686	manager	emilyjohnson@example.com	password123
26	Michael	Davis	1987-11-03	2024-11-02 01:44:47.120686	owner	michaeldavis@example.com	password123
27	Sarah	Miller	1993-12-22	2024-11-02 01:44:47.120686	manager	sarahmiller@example.com	password123
28	David	Wilson	1985-06-18	2024-11-02 01:44:47.120686	owner	davidwilson@example.com	password123
29	Jessica	Taylor	1991-07-30	2024-11-02 01:44:47.120686	manager	jessicataylor@example.com	password123
30	Daniel	Anderson	1989-04-27	2024-11-02 01:44:47.120686	manager	danielanderson@example.com	password123
31	Laura	Thomas	1994-09-12	2024-11-02 01:44:47.120686	owner	laurathomas@example.com	password123
32	James	Jackson	1996-10-05	2024-11-02 01:44:47.120686	manager	jamesjackson@example.com	password123
33	Megan	White	1990-03-17	2024-11-02 01:44:47.120686	owner	meganwhite@example.com	password123
34	Kevin	Harris	1992-11-21	2024-11-02 01:44:47.120686	manager	kevinharris@example.com	password123
35	Linda	Martin	1986-01-19	2024-11-02 01:44:47.120686	owner	lindamartin@example.com	password123
36	Paul	Garcia	1994-05-02	2024-11-02 01:44:47.120686	manager	paulgarcia@example.com	password123
2	Jane	Smith	1995-05-22	2024-11-01 21:51:19.43417	manager	janesmitha@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
3	Alice	Johnson	1988-03-30	2024-11-01 21:51:19.43417	manager	asdasdasdohnson@example.com	$2b$10$hCvl/ocFbDiY9/nU1JcWbe2H2uIM5vMOkIMoXFifOmqbOOD1j/vnK
\.


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 26, true);


--
-- Name: order_list_order_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_list_order_list_id_seq', 142, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 85, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 67, true);


--
-- Name: promotions_promo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotions_promo_id_seq', 3, true);


--
-- Name: recommendations_recommendation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recommendations_recommendation_id_seq', 1, false);


--
-- Name: store_location_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_location_store_id_seq', 4, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 37, true);


--
-- Name: categories categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: order_list order_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_list
    ADD CONSTRAINT order_list_pkey PRIMARY KEY (order_list_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (promo_id);


--
-- Name: recommendations recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (recommendation_id);


--
-- Name: store_location store_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_location
    ADD CONSTRAINT store_location_pkey PRIMARY KEY (store_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: order_list order_list_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_list
    ADD CONSTRAINT order_list_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: order_list order_list_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_list
    ADD CONSTRAINT order_list_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: orders orders_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store_location(store_id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- PostgreSQL database dump complete
--

