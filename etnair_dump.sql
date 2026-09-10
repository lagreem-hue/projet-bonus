--
-- PostgreSQL database dump
--

\restrict M5Whgf2RLN4UdUXLDX53nR9V1njFsNEL5M1LXsbTk8wm32XBidihdcd7kI2WeJS

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.11 (Debian 16.11-1.pgdg13+1)

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
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO etnair_user;

--
-- Name: admin_profiles; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.admin_profiles (
    user_id integer NOT NULL,
    admin_level character varying(20) NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    last_action timestamp(6) with time zone,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.admin_profiles OWNER TO etnair_user;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    property_id integer NOT NULL,
    guest_id integer NOT NULL,
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    number_of_guests integer NOT NULL,
    price_per_night numeric(10,2) NOT NULL,
    cleaning_fee numeric(10,2) DEFAULT 0 NOT NULL,
    total_price numeric(10,2) NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    payment_status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    payment_method character varying(50),
    cancelled_at timestamp(6) with time zone,
    cancellation_reason text,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.bookings OWNER TO etnair_user;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO etnair_user;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: calendar_pricing; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.calendar_pricing (
    id integer NOT NULL,
    property_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    price_override numeric(10,2),
    modifier_factor numeric(3,2),
    is_available boolean DEFAULT true NOT NULL,
    reason character varying(100),
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.calendar_pricing OWNER TO etnair_user;

--
-- Name: calendar_pricing_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.calendar_pricing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.calendar_pricing_id_seq OWNER TO etnair_user;

--
-- Name: calendar_pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.calendar_pricing_id_seq OWNED BY public.calendar_pricing.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.favorites (
    user_id integer NOT NULL,
    property_id integer NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.favorites OWNER TO etnair_user;

--
-- Name: guest_profiles; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.guest_profiles (
    user_id integer NOT NULL,
    preferred_language character varying(10) DEFAULT 'fr'::character varying NOT NULL,
    loyalty_points integer DEFAULT 0 NOT NULL,
    total_bookings integer DEFAULT 0 NOT NULL,
    bio character varying(500),
    date_of_birth date,
    government_id_verified boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.guest_profiles OWNER TO etnair_user;

--
-- Name: host_profiles; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.host_profiles (
    user_id integer NOT NULL,
    is_superhost boolean DEFAULT false NOT NULL,
    response_rate numeric(5,2) DEFAULT 0.00 NOT NULL,
    response_time_hours integer,
    total_listings integer DEFAULT 0 NOT NULL,
    average_rating numeric(3,2),
    tax_id character varying(50),
    bank_account_verified boolean DEFAULT false NOT NULL,
    host_since date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    bio character varying(500),
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.host_profiles OWNER TO etnair_user;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    sender_id integer NOT NULL,
    recipient_id integer NOT NULL,
    booking_id integer,
    property_id integer,
    content text NOT NULL,
    read_at timestamp(6) with time zone,
    is_automated boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.messages OWNER TO etnair_user;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO etnair_user;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    currency character(3) DEFAULT 'EUR'::bpchar NOT NULL,
    payment_method character varying(50),
    status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    stripe_payment_id character varying(255),
    paid_at timestamp(6) with time zone,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.payments OWNER TO etnair_user;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO etnair_user;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: properties; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.properties (
    id integer NOT NULL,
    host_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    property_type character varying(50) NOT NULL,
    address character varying(255) NOT NULL,
    city character varying(100) NOT NULL,
    country character varying(100) NOT NULL,
    postal_code character varying(20),
    latitude numeric(10,8),
    longitude numeric(11,8),
    max_guests integer NOT NULL,
    bedrooms integer DEFAULT 0 NOT NULL,
    beds integer DEFAULT 0 NOT NULL,
    bathrooms numeric(3,1) DEFAULT 1.0 NOT NULL,
    price_per_night numeric(10,2) NOT NULL,
    cleaning_fee numeric(10,2) DEFAULT 0 NOT NULL,
    currency character(3) DEFAULT 'EUR'::bpchar NOT NULL,
    amenities jsonb DEFAULT '{}'::jsonb NOT NULL,
    house_rules jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    instant_booking boolean DEFAULT false NOT NULL,
    view_count integer DEFAULT 0 NOT NULL,
    booking_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.properties OWNER TO etnair_user;

--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.properties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.properties_id_seq OWNER TO etnair_user;

--
-- Name: properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.properties_id_seq OWNED BY public.properties.id;


--
-- Name: property_images; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.property_images (
    id integer NOT NULL,
    property_id integer NOT NULL,
    image_url character varying(255) NOT NULL,
    minio_key character varying(255),
    is_cover boolean DEFAULT false NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    uploaded_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.property_images OWNER TO etnair_user;

--
-- Name: property_images_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.property_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.property_images_id_seq OWNER TO etnair_user;

--
-- Name: property_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.property_images_id_seq OWNED BY public.property_images.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    property_id integer NOT NULL,
    author_id integer NOT NULL,
    rating integer NOT NULL,
    comment text,
    cleanliness_rating integer,
    accuracy_rating integer,
    communication_rating integer,
    location_rating integer,
    value_rating integer,
    host_response text,
    host_response_at timestamp(6) with time zone,
    is_public boolean DEFAULT true NOT NULL,
    is_flagged boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.reviews OWNER TO etnair_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO etnair_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: etnair_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(20),
    profile_picture character varying(255),
    is_guest boolean DEFAULT true NOT NULL,
    is_host boolean DEFAULT false NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    email_verified boolean DEFAULT false NOT NULL,
    phone_verified boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    last_login_at timestamp(6) with time zone
);


ALTER TABLE public.users OWNER TO etnair_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: etnair_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO etnair_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etnair_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: calendar_pricing id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.calendar_pricing ALTER COLUMN id SET DEFAULT nextval('public.calendar_pricing_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: properties id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.properties ALTER COLUMN id SET DEFAULT nextval('public.properties_id_seq'::regclass);


--
-- Name: property_images id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.property_images ALTER COLUMN id SET DEFAULT nextval('public.property_images_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
e6eeba43-e517-4dac-bc66-9878567cbe8e	0e4160782ed58d223af64c9d4973d2a8f8cc3b26fa221922b13cea48d65d277f	2025-12-06 18:29:36.798715+00	20251206182936_init	\N	\N	2025-12-06 18:29:36.620144+00	1
\.


--
-- Data for Name: admin_profiles; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.admin_profiles (user_id, admin_level, permissions, last_action, created_at) FROM stdin;
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.bookings (id, property_id, guest_id, check_in_date, check_out_date, number_of_guests, price_per_night, cleaning_fee, total_price, status, payment_status, payment_method, cancelled_at, cancellation_reason, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: calendar_pricing; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.calendar_pricing (id, property_id, start_date, end_date, price_override, modifier_factor, is_available, reason, created_at) FROM stdin;
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.favorites (user_id, property_id, created_at) FROM stdin;
\.


--
-- Data for Name: guest_profiles; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.guest_profiles (user_id, preferred_language, loyalty_points, total_bookings, bio, date_of_birth, government_id_verified, created_at) FROM stdin;
\.


--
-- Data for Name: host_profiles; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.host_profiles (user_id, is_superhost, response_rate, response_time_hours, total_listings, average_rating, tax_id, bank_account_verified, host_since, bio, created_at) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.messages (id, sender_id, recipient_id, booking_id, property_id, content, read_at, is_automated, created_at) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.payments (id, booking_id, amount, currency, payment_method, status, stripe_payment_id, paid_at, created_at) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.properties (id, host_id, title, description, property_type, address, city, country, postal_code, latitude, longitude, max_guests, bedrooms, beds, bathrooms, price_per_night, cleaning_fee, currency, amenities, house_rules, is_active, instant_booking, view_count, booking_count, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: property_images; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.property_images (id, property_id, image_url, minio_key, is_cover, display_order, uploaded_at) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.reviews (id, booking_id, property_id, author_id, rating, comment, cleanliness_rating, accuracy_rating, communication_rating, location_rating, value_rating, host_response, host_response_at, is_public, is_flagged, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: etnair_user
--

COPY public.users (id, email, password_hash, first_name, last_name, phone, profile_picture, is_guest, is_host, is_admin, email_verified, phone_verified, created_at, updated_at, last_login_at) FROM stdin;
\.


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.bookings_id_seq', 1, false);


--
-- Name: calendar_pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.calendar_pricing_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.properties_id_seq', 1, false);


--
-- Name: property_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.property_images_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etnair_user
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: admin_profiles admin_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.admin_profiles
    ADD CONSTRAINT admin_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: calendar_pricing calendar_pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.calendar_pricing
    ADD CONSTRAINT calendar_pricing_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (user_id, property_id);


--
-- Name: guest_profiles guest_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.guest_profiles
    ADD CONSTRAINT guest_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: host_profiles host_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.host_profiles
    ADD CONSTRAINT host_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_images property_images_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.property_images
    ADD CONSTRAINT property_images_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: admin_profiles_user_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX admin_profiles_user_id_idx ON public.admin_profiles USING btree (user_id);


--
-- Name: bookings_check_in_date_check_out_date_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX bookings_check_in_date_check_out_date_idx ON public.bookings USING btree (check_in_date, check_out_date);


--
-- Name: bookings_guest_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX bookings_guest_id_idx ON public.bookings USING btree (guest_id);


--
-- Name: bookings_property_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX bookings_property_id_idx ON public.bookings USING btree (property_id);


--
-- Name: bookings_status_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX bookings_status_idx ON public.bookings USING btree (status);


--
-- Name: calendar_pricing_property_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX calendar_pricing_property_id_idx ON public.calendar_pricing USING btree (property_id);


--
-- Name: calendar_pricing_start_date_end_date_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX calendar_pricing_start_date_end_date_idx ON public.calendar_pricing USING btree (start_date, end_date);


--
-- Name: favorites_property_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX favorites_property_id_idx ON public.favorites USING btree (property_id);


--
-- Name: favorites_user_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX favorites_user_id_idx ON public.favorites USING btree (user_id);


--
-- Name: guest_profiles_user_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX guest_profiles_user_id_idx ON public.guest_profiles USING btree (user_id);


--
-- Name: host_profiles_user_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX host_profiles_user_id_idx ON public.host_profiles USING btree (user_id);


--
-- Name: messages_booking_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX messages_booking_id_idx ON public.messages USING btree (booking_id);


--
-- Name: messages_recipient_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX messages_recipient_id_idx ON public.messages USING btree (recipient_id);


--
-- Name: messages_sender_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX messages_sender_id_idx ON public.messages USING btree (sender_id);


--
-- Name: messages_sender_id_recipient_id_created_at_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX messages_sender_id_recipient_id_created_at_idx ON public.messages USING btree (sender_id, recipient_id, created_at);


--
-- Name: payments_booking_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX payments_booking_id_idx ON public.payments USING btree (booking_id);


--
-- Name: payments_booking_id_key; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE UNIQUE INDEX payments_booking_id_key ON public.payments USING btree (booking_id);


--
-- Name: properties_city_country_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX properties_city_country_idx ON public.properties USING btree (city, country);


--
-- Name: properties_host_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX properties_host_id_idx ON public.properties USING btree (host_id);


--
-- Name: properties_is_active_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX properties_is_active_idx ON public.properties USING btree (is_active);


--
-- Name: properties_price_per_night_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX properties_price_per_night_idx ON public.properties USING btree (price_per_night);


--
-- Name: property_images_property_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX property_images_property_id_idx ON public.property_images USING btree (property_id);


--
-- Name: property_images_property_id_is_cover_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX property_images_property_id_is_cover_idx ON public.property_images USING btree (property_id, is_cover);


--
-- Name: reviews_author_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX reviews_author_id_idx ON public.reviews USING btree (author_id);


--
-- Name: reviews_booking_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX reviews_booking_id_idx ON public.reviews USING btree (booking_id);


--
-- Name: reviews_booking_id_key; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE UNIQUE INDEX reviews_booking_id_key ON public.reviews USING btree (booking_id);


--
-- Name: reviews_property_id_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX reviews_property_id_idx ON public.reviews USING btree (property_id);


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX users_email_idx ON public.users USING btree (email);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: users_is_guest_is_host_is_admin_idx; Type: INDEX; Schema: public; Owner: etnair_user
--

CREATE INDEX users_is_guest_is_host_is_admin_idx ON public.users USING btree (is_guest, is_host, is_admin);


--
-- Name: admin_profiles admin_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.admin_profiles
    ADD CONSTRAINT admin_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bookings bookings_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bookings bookings_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: calendar_pricing calendar_pricing_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.calendar_pricing
    ADD CONSTRAINT calendar_pricing_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: favorites favorites_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: favorites favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guest_profiles guest_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.guest_profiles
    ADD CONSTRAINT guest_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: host_profiles host_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.host_profiles
    ADD CONSTRAINT host_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: properties properties_host_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: property_images property_images_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.property_images
    ADD CONSTRAINT property_images_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reviews reviews_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reviews reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reviews reviews_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etnair_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict M5Whgf2RLN4UdUXLDX53nR9V1njFsNEL5M1LXsbTk8wm32XBidihdcd7kI2WeJS

