--
-- PostgreSQL database dump
--

-- Dumped from database version 13.8 (Ubuntu 13.8-1.pgdg20.04+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-09-28 16:32:41

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

--
-- TOC entry 8 (class 2615 OID 3657846)
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: bcktrcvcxvfuys
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 6 (class 2615 OID 6511182)
-- Name: heroku_ext; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA heroku_ext;


ALTER SCHEMA heroku_ext OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: bcktrcvcxvfuys
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4405 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: bcktrcvcxvfuys
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 272 (class 1255 OID 3657884)
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 273 (class 1255 OID 4725312)
-- Name: set_current_timestamp_updated_at(); Type: FUNCTION; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;


ALTER FUNCTION public.set_current_timestamp_updated_at() OWNER TO bcktrcvcxvfuys;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 205 (class 1259 OID 3657908)
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 207 (class 1259 OID 3657934)
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 206 (class 1259 OID 3657919)
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 204 (class 1259 OID 3657897)
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 209 (class 1259 OID 3657964)
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 208 (class 1259 OID 3657950)
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 210 (class 1259 OID 3657979)
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 203 (class 1259 OID 3657885)
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 234 (class 1259 OID 5624324)
-- Name: case; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public."case" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    form_factor_json text,
    length numeric,
    width numeric,
    height numeric NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    image_url text
);


ALTER TABLE public."case" OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4408 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE "case"; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public."case" IS 'Table for pc case';


--
-- TOC entry 235 (class 1259 OID 5624348)
-- Name: case_prices; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.case_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    case_id uuid NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.case_prices OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE case_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.case_prices IS 'table for case prices';


--
-- TOC entry 212 (class 1259 OID 4710942)
-- Name: chipset; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.chipset (
    chipset_name text NOT NULL
);


ALTER TABLE public.chipset OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE chipset; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.chipset IS 'Motherboard Chipset';


--
-- TOC entry 230 (class 1259 OID 4866914)
-- Name: cooling; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.cooling (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    cfm text,
    cpu_height text,
    dba text,
    rpm text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    image_url text
);


ALTER TABLE public.cooling OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE cooling; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.cooling IS 'Table for cooling (fans only)';


--
-- TOC entry 231 (class 1259 OID 4866933)
-- Name: cooling_prices; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.cooling_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cooling_id uuid NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    note text
);


ALTER TABLE public.cooling_prices OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE cooling_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.cooling_prices IS 'Table for cooling prices';


--
-- TOC entry 213 (class 1259 OID 4725295)
-- Name: cpu; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.cpu (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    "Cores" text NOT NULL,
    "Clock" text NOT NULL,
    socket_name text NOT NULL,
    process text NOT NULL,
    l3_cache text NOT NULL,
    tdp_watt integer NOT NULL,
    release_date date DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    target_market_number integer,
    manufacturer text,
    image_url text
);


ALTER TABLE public.cpu OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE cpu; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.cpu IS 'Table for CPU';


--
-- TOC entry 217 (class 1259 OID 4797498)
-- Name: cpu_prices; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.cpu_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cpu_id uuid NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    note text
);


ALTER TABLE public.cpu_prices OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE cpu_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.cpu_prices IS 'Table for cpu prices';


--
-- TOC entry 215 (class 1259 OID 4797467)
-- Name: gpu; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.gpu (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    gpu_chip text NOT NULL,
    interface_bus text NOT NULL,
    memory text NOT NULL,
    gpu_clock text NOT NULL,
    memory_clock text NOT NULL,
    release_date date DEFAULT now(),
    recommended_wattage integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    target_market_number integer,
    manufacturer text,
    image_url text
);


ALTER TABLE public.gpu OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE gpu; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.gpu IS 'Database for GPU';


--
-- TOC entry 218 (class 1259 OID 4797516)
-- Name: gpu_prices; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.gpu_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    gpu_id uuid DEFAULT gen_random_uuid() NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    gpu_name text
);


ALTER TABLE public.gpu_prices OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE gpu_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.gpu_prices IS 'Table for gpu price';


--
-- TOC entry 214 (class 1259 OID 4778751)
-- Name: interface_bus; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.interface_bus (
    bus_name text NOT NULL
);


ALTER TABLE public.interface_bus OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE interface_bus; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.interface_bus IS 'Table for motherboard bus, usually used for GPU';


--
-- TOC entry 233 (class 1259 OID 4895118)
-- Name: manufacturer; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.manufacturer (
    manufacturer_name text NOT NULL
);


ALTER TABLE public.manufacturer OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE manufacturer; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.manufacturer IS 'Table for manufacturer';


--
-- TOC entry 228 (class 1259 OID 4842313)
-- Name: motherboard; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.motherboard (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    release_year integer NOT NULL,
    form_factor text NOT NULL,
    chipset text NOT NULL,
    ram_slot text NOT NULL,
    ram_slot_count integer NOT NULL,
    cpu_socket text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    sata3_slot_count integer DEFAULT 1 NOT NULL,
    pcie_slots_json text,
    m2_slots_json text,
    image_url text
);


ALTER TABLE public.motherboard OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 219 (class 1259 OID 4816407)
-- Name: motherboard_form_factor; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.motherboard_form_factor (
    form_factor text NOT NULL
);


ALTER TABLE public.motherboard_form_factor OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE motherboard_form_factor; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.motherboard_form_factor IS 'Table for motherboard form factor';


--
-- TOC entry 229 (class 1259 OID 4866888)
-- Name: motherboard_price; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.motherboard_price (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    motherboard_id uuid NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.motherboard_price OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE motherboard_price; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.motherboard_price IS 'Table for motherboard price';


--
-- TOC entry 224 (class 1259 OID 4834089)
-- Name: power_supply; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.power_supply (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    "power_W" integer NOT NULL,
    efficiency numeric DEFAULT 0.5 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    image_url text
);


ALTER TABLE public.power_supply OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE power_supply; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.power_supply IS 'Table for Power Supply';


--
-- TOC entry 227 (class 1259 OID 4841486)
-- Name: power_supply_prices; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.power_supply_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    psu_id uuid NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.power_supply_prices OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE power_supply_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.power_supply_prices IS 'Table for power supply prices';


--
-- TOC entry 223 (class 1259 OID 4833099)
-- Name: ram; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.ram (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    size_gb integer NOT NULL,
    ram_slot text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    ram_frequency_mhz integer NOT NULL,
    image_url text
);


ALTER TABLE public.ram OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE ram; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.ram IS 'Table for RAM';


--
-- TOC entry 226 (class 1259 OID 4841463)
-- Name: ram_prices; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.ram_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ram_id uuid NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    sell_count integer DEFAULT 1
);


ALTER TABLE public.ram_prices OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE ram_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.ram_prices IS 'Table for ram prices';


--
-- TOC entry 222 (class 1259 OID 4833091)
-- Name: ram_slot; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.ram_slot (
    ram_slot text NOT NULL
);


ALTER TABLE public.ram_slot OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE ram_slot; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.ram_slot IS 'Table for ram slot protocol';


--
-- TOC entry 216 (class 1259 OID 4797485)
-- Name: shops; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.shops (
    shop text NOT NULL
);


ALTER TABLE public.shops OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE shops; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.shops IS 'Table for shops enum';


--
-- TOC entry 211 (class 1259 OID 4710930)
-- Name: socket; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.socket (
    socket_name text NOT NULL
);


ALTER TABLE public.socket OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE socket; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.socket IS 'Motherboard Socket';


--
-- TOC entry 221 (class 1259 OID 4817563)
-- Name: storage; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.storage (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    storage_type text NOT NULL,
    size text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    quality_index integer DEFAULT 0 NOT NULL,
    interface_bus text,
    image_url text
);


ALTER TABLE public.storage OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE storage; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.storage IS 'Table for non-volatile storage drives';


--
-- TOC entry 225 (class 1259 OID 4841431)
-- Name: storage_prices; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.storage_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    storage_id uuid NOT NULL,
    price numeric NOT NULL,
    shop text NOT NULL,
    shop_link text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text
);


ALTER TABLE public.storage_prices OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE storage_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.storage_prices IS 'Table for storage prices';


--
-- TOC entry 220 (class 1259 OID 4817117)
-- Name: storage_type; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.storage_type (
    storage_type text NOT NULL
);


ALTER TABLE public.storage_type OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE storage_type; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.storage_type IS 'Table for storage type';


--
-- TOC entry 232 (class 1259 OID 4867021)
-- Name: target_market; Type: TABLE; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TABLE public.target_market (
    power_number integer NOT NULL,
    target_market text NOT NULL
);


ALTER TABLE public.target_market OWNER TO bcktrcvcxvfuys;

--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE target_market; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TABLE public.target_market IS 'Table for target market';


--
-- TOC entry 4368 (class 0 OID 3657908)
-- Dependencies: 205
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- TOC entry 4370 (class 0 OID 3657934)
-- Dependencies: 207
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 4369 (class 0 OID 3657919)
-- Dependencies: 206
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- TOC entry 4367 (class 0 OID 3657897)
-- Dependencies: 204
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"rest_endpoints":[{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Case Prices"}},"url":"case-prices","methods":["GET"],"name":"Case Prices","comment":null},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Cooling Prices"}},"url":"cooling-prices","methods":["GET"],"name":"Cooling Prices","comment":"Get Cooling Prices"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Cpu Prices"}},"url":"cpu-prices","methods":["GET"],"name":"Cpu Prices","comment":"Get Cpu Price"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Gpu Prices"}},"url":"gpu-prices","methods":["GET"],"name":"Gpu Prices","comment":"get gpu prices"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Motherboard Prices"}},"url":"motherboard-prices","methods":["PUT"],"name":"Motherboard Prices","comment":null},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"PSU Prices"}},"url":"psu-prices","methods":["GET"],"name":"PSU Prices","comment":"Get PSU Prices"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Ram Prices"}},"url":"ram-prices","methods":["GET"],"name":"Ram Prices","comment":"API for RAM Price"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Storage Prices"}},"url":"storage-prices","methods":["GET"],"name":"Storage Prices","comment":"Get Storage Prices API"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"TestRest"}},"url":"testRest","methods":["GET"],"name":"TestRest","comment":null},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update Case Price"}},"url":"update-case-price","methods":["PUT"],"name":"Update Case Price","comment":null},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update Cooling Price"}},"url":"update-cooling-price","methods":["PUT"],"name":"Update Cooling Price","comment":"update cooling price"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update Cpu Price"}},"url":"update-cpu-price","methods":["PUT"],"name":"Update Cpu Price","comment":null},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update Gpu Price"}},"url":"update-gpu-price","methods":["PUT"],"name":"Update Gpu Price","comment":"update gpu price by pk"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update Motherboard Price"}},"url":"update-motherboard-price","methods":["PUT"],"name":"Update Motherboard Price","comment":null},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update PSU Prices"}},"url":"update-psu-price","methods":["PUT"],"name":"Update PSU Prices","comment":"update psu prices"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update Ram Prices"}},"url":"update-ram-price","methods":["PUT"],"name":"Update Ram Prices","comment":"Update Ram Prices by PK"},{"definition":{"query":{"collection_name":"allowed-queries","query_name":"Update Storage Price"}},"url":"update-storage-price","methods":["PUT"],"name":"Update Storage Price","comment":"update storage price by PK"}],"allowlist":[{"collection":"allowed-queries","scope":{"global":true}}],"sources":[{"kind":"postgres","name":"default","tables":[{"table":{"schema":"public","name":"case"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"case_id","table":{"schema":"public","name":"case_prices"}}},"name":"case_prices"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"case_id"},"name":"case"},{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"}],"table":{"schema":"public","name":"case_prices"}},{"table":{"schema":"public","name":"chipset"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"chipset","table":{"schema":"public","name":"motherboard"}}},"name":"motherboards"}]},{"table":{"schema":"public","name":"cooling"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"cooling_id","table":{"schema":"public","name":"cooling_prices"}}},"name":"cooling_prices"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"cooling_id"},"name":"cooling"},{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"}],"table":{"schema":"public","name":"cooling_prices"}},{"object_relationships":[{"using":{"foreign_key_constraint_on":"manufacturer"},"name":"manufacturerByManufacturer"},{"using":{"foreign_key_constraint_on":"socket_name"},"name":"socket"},{"using":{"foreign_key_constraint_on":"target_market_number"},"name":"target_market"}],"table":{"schema":"public","name":"cpu"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"cpu_id","table":{"schema":"public","name":"cpu_prices"}}},"name":"cpu_prices"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"cpu_id"},"name":"cpu"},{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"}],"table":{"schema":"public","name":"cpu_prices"}},{"object_relationships":[{"using":{"foreign_key_constraint_on":"interface_bus"},"name":"interfaceBusByInterfaceBus"},{"using":{"foreign_key_constraint_on":"manufacturer"},"name":"manufacturerByManufacturer"},{"using":{"foreign_key_constraint_on":"target_market_number"},"name":"target_market"}],"table":{"schema":"public","name":"gpu"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"gpu_id","table":{"schema":"public","name":"gpu_prices"}}},"name":"gpu_prices"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"gpu_id"},"name":"gpu"},{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"}],"table":{"schema":"public","name":"gpu_prices"}},{"table":{"schema":"public","name":"interface_bus"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"interface_bus","table":{"schema":"public","name":"gpu"}}},"name":"gpus"},{"using":{"foreign_key_constraint_on":{"column":"interface_bus","table":{"schema":"public","name":"storage"}}},"name":"storages"}]},{"table":{"schema":"public","name":"manufacturer"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"manufacturer","table":{"schema":"public","name":"cpu"}}},"name":"cpus"},{"using":{"foreign_key_constraint_on":{"column":"manufacturer","table":{"schema":"public","name":"gpu"}}},"name":"gpus"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"chipset"},"name":"chipsetByChipset"},{"using":{"foreign_key_constraint_on":"form_factor"},"name":"motherboard_form_factor"},{"using":{"foreign_key_constraint_on":"ram_slot"},"name":"ramSlotByRamSlot"},{"using":{"foreign_key_constraint_on":"cpu_socket"},"name":"socket"}],"table":{"schema":"public","name":"motherboard"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"motherboard_id","table":{"schema":"public","name":"motherboard_price"}}},"name":"motherboard_prices"}]},{"table":{"schema":"public","name":"motherboard_form_factor"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"form_factor","table":{"schema":"public","name":"motherboard"}}},"name":"motherboards"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"motherboard_id"},"name":"motherboard"},{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"}],"table":{"schema":"public","name":"motherboard_price"}},{"table":{"schema":"public","name":"power_supply"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"psu_id","table":{"schema":"public","name":"power_supply_prices"}}},"name":"power_supply_prices"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"psu_id"},"name":"power_supply"},{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"}],"table":{"schema":"public","name":"power_supply_prices"}},{"object_relationships":[{"using":{"foreign_key_constraint_on":"ram_slot"},"name":"ramSlotByRamSlot"}],"table":{"schema":"public","name":"ram"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"ram_id","table":{"schema":"public","name":"ram_prices"}}},"name":"ram_prices"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"ram_id"},"name":"ram"},{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"}],"table":{"schema":"public","name":"ram_prices"}},{"table":{"schema":"public","name":"ram_slot"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"ram_slot","table":{"schema":"public","name":"motherboard"}}},"name":"motherboards"},{"using":{"foreign_key_constraint_on":{"column":"ram_slot","table":{"schema":"public","name":"ram"}}},"name":"rams"}]},{"table":{"schema":"public","name":"shops"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"case_prices"}}},"name":"case_prices"},{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"cooling_prices"}}},"name":"cooling_prices"},{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"cpu_prices"}}},"name":"cpu_prices"},{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"gpu_prices"}}},"name":"gpu_prices"},{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"motherboard_price"}}},"name":"motherboard_prices"},{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"power_supply_prices"}}},"name":"power_supply_prices"},{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"ram_prices"}}},"name":"ram_prices"},{"using":{"foreign_key_constraint_on":{"column":"shop","table":{"schema":"public","name":"storage_prices"}}},"name":"storage_prices"}]},{"table":{"schema":"public","name":"socket"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"socket_name","table":{"schema":"public","name":"cpu"}}},"name":"cpus"},{"using":{"foreign_key_constraint_on":{"column":"cpu_socket","table":{"schema":"public","name":"motherboard"}}},"name":"motherboards"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"interface_bus"},"name":"interfaceBusByInterfaceBus"}],"table":{"schema":"public","name":"storage"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"storage_id","table":{"schema":"public","name":"storage_prices"}}},"name":"storage_prices"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"shop"},"name":"shopByShop"},{"using":{"foreign_key_constraint_on":"storage_id"},"name":"storage"}],"table":{"schema":"public","name":"storage_prices"}},{"table":{"schema":"public","name":"storage_type"}},{"table":{"schema":"public","name":"target_market"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"target_market_number","table":{"schema":"public","name":"cpu"}}},"name":"cpus"},{"using":{"foreign_key_constraint_on":{"column":"target_market_number","table":{"schema":"public","name":"gpu"}}},"name":"gpus"}]}],"configuration":{"connection_info":{"use_prepared_statements":true,"database_url":"postgres://bcktrcvcxvfuys:026aba74fa0160992c086f40e212ec8766800eaee1eb04be9cc1152da17bd6c9@ec2-52-208-229-228.eu-west-1.compute.amazonaws.com:5432/d465h17bnnimlg","isolation_level":"read-committed","pool_settings":{"connection_lifetime":600,"retries":1,"idle_timeout":180,"max_connections":15}}}}],"version":3,"query_collections":[{"definition":{"queries":[{"name":"TestRest","query":"query testRest {\\r\\n  cpu {\\r\\n    Name\\r\\n  }\\r\\n}"},{"name":"Storage Prices","query":"query storagePrices {\\n  storage_prices {\\n    id\\n    storage_id\\n    name\\n    shop\\n    shop_link\\n  }\\n}"},{"name":"Ram Prices","query":"query MyQuery {\\n  ram_prices {\\n    id\\n    ram_id\\n    shop\\n    shop_link\\n    price\\n  }\\n}"},{"name":"Update Storage Price","query":"mutation updateStoragePrice($id: uuid!, $price: numeric!) {\\n  update_storage_prices_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"PSU Prices","query":"query PsuPrices {\\n  power_supply_prices {\\n    id\\n    psu_id\\n    shop\\n    shop_link\\n    price\\n  }\\n}"},{"name":"Gpu Prices","query":"query GpuPrices {\\n  gpu_prices {\\n    id\\n    gpu_id\\n    shop\\n    shop_link\\n    price\\n  }\\n}"},{"name":"Update Gpu Price","query":"mutation MyMutation($id: uuid!, $price: numeric!) {\\n  update_gpu_prices_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"Update PSU Prices","query":"mutation MyMutation($id: uuid!, $price: numeric!) {\\n  update_power_supply_prices_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"Update Ram Prices","query":"mutation updateRamPrices($id: uuid!, $price: numeric!) {\\n  update_ram_prices_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"Cooling Prices","query":"query CoolingPrices {\\n  cooling_prices {\\n    id\\n    cooling_id\\n    shop\\n    shop_link\\n    price\\n  }\\n}"},{"name":"Update Cooling Price","query":"mutation MyMutation($id: uuid!, $price: numeric!) {\\n  update_cooling_prices_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"Cpu Prices","query":"query CpuPrices {\\n  cpu_prices {\\n    id\\n    cpu_id\\n    note\\n    price\\n    shop\\n    shop_link\\n  }\\n}"},{"name":"Update Cpu Price","query":"mutation UpdateCpuPrice($id: uuid!, $price: numeric = \\"\\") {\\n  update_cpu_prices_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"Update Motherboard Price","query":"mutation UpdateMotherboardPrice($id: uuid!, $price: numeric!) {\\n  update_motherboard_price_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"Update Case Price","query":"mutation UpdateCasePrice($id: uuid!, $price: numeric!) {\\n  update_case_prices_by_pk(pk_columns: {id: $id}, _set: {price: $price}) {\\n    id\\n    price\\n  }\\n}"},{"name":"Case Prices","query":"query CasePrices {\\n  case_prices {\\n    id\\n    case_id\\n    price\\n    shop\\n    shop_link\\n  }\\n}"},{"name":"Motherboard Prices","query":"query MotherboardPrices {\\n  motherboard_price {\\n    id\\n    motherboard_id\\n    price\\n    shop\\n    shop_link\\n  }\\n}"}]},"name":"allowed-queries"}]}	200
\.


--
-- TOC entry 4372 (class 0 OID 3657964)
-- Dependencies: 209
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- TOC entry 4371 (class 0 OID 3657950)
-- Dependencies: 208
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- TOC entry 4373 (class 0 OID 3657979)
-- Dependencies: 210
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":[]}	200	67aa69af-78e1-4e0c-8784-f785b605f892	2022-03-05 07:11:36.72392+00
\.


--
-- TOC entry 4366 (class 0 OID 3657885)
-- Dependencies: 203
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
3d3dd712-f1cf-4e80-8f1d-e0830e67e290	47	2022-01-05 14:19:19.104527+00	{}	{"console_notifications": {"admin": {"date": "2022-08-13T14:19:51.090Z", "read": [], "showBadge": false}}, "telemetryNotificationShown": true, "disablePreReleaseUpdateNotifications": true}
\.


--
-- TOC entry 4397 (class 0 OID 5624324)
-- Dependencies: 234
-- Data for Name: case; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public."case" (id, name, form_factor_json, length, width, height, created_at, updated_at, image_url) FROM stdin;
48ed0ba3-12da-4d8c-9131-84e79852c9e7	Fractal Design Torrent	{"form_factor":["ATX","Micro-ATX","Mini-ITX","SSI-EEB","SSI-CEB","EATX"]}	544	242	530	2022-05-21 14:32:15.808992+00	2022-05-21 14:32:46.306037+00	https://cdna.pcpartpicker.com/static/forever/images/product/bfb65008c40083d6799ebdae629c5b6f.1600.jpg
eb507790-b757-4b4c-ae6c-617e195ba2f8	Corsair 760T	{"form_factor":["ATX","Micro-ATX","Mini-ITX","XL-ATX","EATX"]}	564	246	568	2022-05-21 14:44:15.575652+00	2022-05-21 14:44:15.575652+00	https://m.media-amazon.com/images/I/41Dz-UmNVBL.jpg
02895ff5-254d-4822-b93e-89b471d21e02	Corsair 900D	{"form_factor":["ATX","Micro-ATX","Mini-ITX","E-ATX","HPTX","XL-ATX"]}	650	251	690	2022-05-21 11:12:45.704437+00	2022-05-21 11:12:45.704437+00	https://images-fe.ssl-images-amazon.com/images/I/41t-R6P%2BH9L.jpg
6c528f2b-92b8-41ce-9ad9-758052da0087	Corsair 4000D Airflow - black	{"form_factor":["ATX","Micro-ATX","Mini-ITX"]}	453	230	466	2022-05-21 03:53:32.7182+00	2022-05-21 11:13:49.913227+00	https://images.tokopedia.net/img/cache/900/VqbcmM/2020/10/15/1a228018-7ea6-45ec-b44e-eb6fb8ee1d47.jpg
567c6ccd-c88f-4684-a2c5-8b70d1dfd56c	NZXT H510 - white	{"form_factor":["ATX","Micro-ATX","Mini-ITX"]}	428	210	460	2022-05-21 04:04:53.787037+00	2022-05-21 11:14:05.753303+00	https://images.tokopedia.net/img/cache/900/product-1/2019/8/13/13757756/13757756_a60edb44-5efa-4b65-a15d-64a5004211cb_700_700
f04aad68-7874-4547-8025-6964327abe9c	Lian Li Lancool II Mesh - black	{"form_factor":["ATX","Micro-ATX","Mini-ITX","EATX"]}	478	229	494	2022-05-21 04:37:01.366776+00	2022-05-21 11:14:27.54579+00	https://cdna.pcpartpicker.com/static/forever/images/product/1f0d01b57cc9d3c2e050041beb99f787.1600.jpg
9bc649fe-82fa-49fe-a369-caae5567045f	Lian Li PC-O11 Dynamic - white	{"form_factor":["ATX","Micro-ATX","Mini-ITX","EATX"]}	445	272	446	2022-05-21 04:20:20.117418+00	2022-05-21 11:14:40.362829+00	https://cdna.pcpartpicker.com/static/forever/images/product/580387945cfb3fe6bac9ef5844c2b55f.1600.jpg
a67e46ec-17ea-4e7c-b167-61d3bc2ea0fa	Cooler Master MasterBox Q300L	{"form_factor":["Micro-ATX","Mini-ITX"]}	387	230	378	2022-05-21 04:59:25.962358+00	2022-05-21 11:14:50.225296+00	https://images.tokopedia.net/img/cache/900/product-1/2018/11/28/7701906/7701906_72396925-1399-4188-bfac-668f3aac4b94_800_468.jpg
22c6df83-b337-4e16-b9d1-d098e4d1dd6d	NZXT Tempest 410 Elite	{"form_factor":["ATX","Micro-ATX","Mini-ITX","Thin-Mini-ITX"]}	496	214	481	2022-05-21 11:33:03.15883+00	2022-05-21 11:33:03.15883+00	https://images-na.ssl-images-amazon.com/images/I/51Qg8Um%2BYxL.jpg
ed8c0408-67b4-418a-a4cc-9f4ce340d916	Cooler Master MasterBox TD500 Mesh	{"form_factor":["ATX","Micro-ATX","Mini-ITX","SSI-CEB"]}	493	217	469	2022-05-21 11:43:15.155042+00	2022-05-21 11:43:15.155042+00	https://ecs7.tokopedia.net/img/cache/900/VqbcmM/2021/1/14/ad692d41-36f9-4777-8bf6-f1d979f98f41.jpg
d830c754-7aaa-48ed-934f-334139f126a0	Cougar PANZER EVO RGB	{"form_factor":["ATX","Micro-ATX","Mini-ITX","SSI-CEB","EATX"]}	556	266	612	2022-05-21 11:48:08.716748+00	2022-05-21 11:48:08.716748+00	https://images.tokopedia.net/img/cache/900/product-1/2019/4/13/13757756/13757756_fbac944e-1fb1-4e1f-8d86-d933063b1a6e_700_700.jpg
4d1a5d6f-3d91-448d-b83e-58121a1a3e4d	Phanteks Enthoo Pro Tempered Glass 	{"form_factor":["ATX","Micro-ATX","Mini-ITX","SSI-EEB","EATX"]}	550	235	535	2022-05-21 14:10:38.841381+00	2022-05-21 14:26:58.325276+00	https://images.tokopedia.net/img/cache/900/VqbcmM/2021/8/27/9d7731bb-d495-45b8-b4cc-d4fb5796c99b.jpg
\.


--
-- TOC entry 4398 (class 0 OID 5624348)
-- Dependencies: 235
-- Data for Name: case_prices; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.case_prices (id, case_id, price, shop, shop_link, created_at, updated_at) FROM stdin;
f7a28dbb-250c-4ba0-86df-9396ae2dcd86	6c528f2b-92b8-41ce-9ad9-758052da0087	1379000	Tokopedia	https://www.tokopedia.com/nanokomputer/corsair-4000d-airflow-tempered-glass-mid-tower-atx-case-black?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 03:53:57.903669+00	2022-05-21 03:55:03.79599+00
d4ed0bfa-aed5-4904-997b-661249d0095e	567c6ccd-c88f-4684-a2c5-8b70d1dfd56c	1280000	Tokopedia	https://www.tokopedia.com/distributorpc/nzxt-h510-with-type-c-port-casing-pc-matte-white?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 04:05:23.785678+00	2022-05-21 04:05:23.785678+00
c42c1091-3ff1-45b5-9830-dabc00f83325	9bc649fe-82fa-49fe-a369-caae5567045f	3285000	Tokopedia	https://www.tokopedia.com/enterkomputer/lian-li-pc-o11-dynamic-xl-rog-white-tempered-glass-casing-gaming?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 04:20:54.829132+00	2022-05-21 04:20:54.829132+00
f59e609b-f3b7-4bde-a967-b0a69c85196f	f04aad68-7874-4547-8025-6964327abe9c	1535000	Tokopedia	https://www.tokopedia.com/cockomputer/lian-li-lancool-ii-mesh-rgb-black?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 04:37:26.775989+00	2022-05-21 04:37:26.775989+00
9f756c13-7bff-4aa6-b147-bb1b07c1b2ea	a67e46ec-17ea-4e7c-b167-61d3bc2ea0fa	590000	Tokopedia	https://www.tokopedia.com/jnj77/cooler-master-masterbox-q300l-m-atx-gaming-case?src=topads	2022-05-21 04:59:49.637147+00	2022-05-21 04:59:49.637147+00
6e0b9576-96ed-44f3-bf2b-9944aab9c8e5	02895ff5-254d-4822-b93e-89b471d21e02	4995000	Tokopedia	https://www.tokopedia.com/wiracom/corsair-obsidian-series-900d-super-tower-case?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-05-21 11:13:26.179389+00	2022-05-21 11:13:26.179389+00
d587e168-8e80-4f14-990e-c6737c9d3e91	22c6df83-b337-4e16-b9d1-d098e4d1dd6d	900000	Tokopedia	https://www.tokopedia.com/supernovaharco/nzxt-crafted-series-tempest-410-elite-black-steel-atx-mid-tower-case?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 11:33:26.526469+00	2022-05-21 11:33:26.526469+00
42997fd7-90b3-4ce3-9d08-45355eba3997	ed8c0408-67b4-418a-a4cc-9f4ce340d916	1269000	Tokopedia	https://www.tokopedia.com/jnj77/cooler-master-masterbox-td500-mesh-airflow-atx-gaming-case-hitam?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 11:43:43.806826+00	2022-05-21 11:43:43.806826+00
19201eae-043e-4483-b4a9-f357c82d7af7	d830c754-7aaa-48ed-934f-334139f126a0	2898000	Tokopedia	https://www.tokopedia.com/distributorpc/cougar-panzer-evo-rgb-full-tower-the-crystalline-titan?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 11:49:26.337829+00	2022-05-21 11:49:26.337829+00
b68a1af4-ef7c-41bd-a868-d37b070f6c38	4d1a5d6f-3d91-448d-b83e-58121a1a3e4d	1780000	Tokopedia	https://www.tokopedia.com/sportonlineshop/phanteks-enthoo-pro-tempered-glass-full-tower-pc-case-gaming-chassis?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 14:11:23.67866+00	2022-05-21 14:11:23.67866+00
40e14eed-eddf-4b9e-8dc7-dd0bb4f7cc33	48ed0ba3-12da-4d8c-9131-84e79852c9e7	3825000	Tokopedia	https://www.tokopedia.com/tonixcomp/fractal-design-torrent-rgb-black-tg-light-tint?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 14:33:08.309367+00	2022-05-21 14:33:08.309367+00
2f888123-37a8-442e-9e8c-ed8c423a0159	eb507790-b757-4b4c-ae6c-617e195ba2f8	2814000	Tokopedia	https://www.tokopedia.com/jojocomptech/corsair-graphite-series-760t-arctic-white-full-tower-windowed-case?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-21 14:45:52.402343+00	2022-05-21 14:45:52.402343+00
\.


--
-- TOC entry 4375 (class 0 OID 4710942)
-- Dependencies: 212
-- Data for Name: chipset; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.chipset (chipset_name) FROM stdin;
AMD 760G
AMD 770
AMD 790FX
AMD 870
AMD 880G
AMD 890FX
AMD 890GX
AMD 970
AMD 990FX
AMD 990X
AMD A320
AMD A70M
AMD A88X
AMD B350
AMD B450
AMD B550
AMD X370
AMD X399
AMD X470
AMD X570
INTEL 5520
INTEL 945GC
INTEL B150
INTEL B250
INTEL B360
INTEL B365
INTEL B460
INTEL C232
INTEL C236
INTEL C242
INTEL C422
INTEL C606
INTEL C612
INTEL C621
INTEL C622
INTEL C624
INTEL C628
INTEL H110
INTEL H170
INTEL H270
INTEL H310
INTEL H370
INTEL H410
INTEL H470
INTEL H497
INTEL P35
INTEL P45
INTEL P55
INTEL P67
INTEL P965
INTEL Q150
INTEL Q170
INTEL Q270
INTEL Q370
INTEL X299
INTEL X38
INTEL X48
INTEL X58
INTEL X79
INTEL X99
INTEL Z170
INTEL Z270
INTEL Z370
INTEL Z390
INTEL Z490
INTEL Z68
INTEL Z77
INTEL Z87
INTEL Z97
NVIDIA nForce 590 SLI
NVIDIA nForce 780a SLI
NVIDIA nForce 780i SLI
NVIDIA nForce 790i SLI
NVIDIA nForce 790i Ultra SLI
VIA P4M800
INTEL Z690
INTEL B660
\.


--
-- TOC entry 4393 (class 0 OID 4866914)
-- Dependencies: 230
-- Data for Name: cooling; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.cooling (id, name, cfm, cpu_height, dba, rpm, created_at, updated_at, image_url) FROM stdin;
55d08654-0c72-4352-9809-ff19549efeef	Scythe Big Shuriken 3	8.28 - 50.79 CFM	\N	2.7 - 30.4 dBA	300 - 1800 RPM	2022-03-29 15:13:53.260513+00	2022-03-29 15:13:53.260513+00	\N
f2f60e69-3011-45e3-a53a-abc67af97560	Noctua NH-L9A-AM4	24 - 33.8 CFM	\N	14.8 - 23.6 dBA	600 - 2500 RPM	2022-03-29 14:40:27.404433+00	2022-03-29 15:14:04.33065+00	\N
549229e3-9e52-4e04-80ed-5956e2baff06	Noctua NH-U12S REDUX	70.7 CFM	\N	25.1 dBA	450 - 1700 RPM	2022-03-29 15:23:28.129595+00	2022-03-29 15:23:28.129595+00	\N
de04adeb-3e9e-456e-a1cc-ecc01abd4b40	Noctua NH-L9x65 SE-AM4 	24.0 - 33.8 CFM	\N	14.8 - 23.6 dBA	600 - 1800 RPM	2022-03-29 15:27:46.631756+00	2022-03-29 15:27:46.631756+00	\N
a1147fb1-9ab2-484e-be6a-222cc4198fb0	Noctua NH-L12S	41.6 - 55.4 CFM	\N	16.8 - 23.9 dBA	450 - 1850 RPM	2022-03-29 15:32:14.43412+00	2022-03-29 15:32:14.43412+00	\N
367ebad4-a64d-4efc-8fc2-89bd64c97d62	Noctua NH-L9a-AM4 chromax.black	24.0 - 33.8 CFM	\N	14.8 - 23.6 dB(A)	600 - 2500 RPM	2022-03-29 15:41:18.441513+00	2022-03-29 15:41:18.441513+00	\N
e141a650-e299-462f-b831-d2682d1d6c85	Noctua NH-D9L	36.8 - 46.4 CFM	\N	16.3 - 22.8 dBA	400 - 2000 RPM	2022-03-29 15:45:23.502418+00	2022-03-29 15:45:23.502418+00	\N
bc90ed05-8ce7-4485-86f4-5de710fd0e5d	Scythe Mugen 5 Rev.B	16.6 ~ 51.17 CFM	\N	4.0 ~ 24.9 dBA	300 - 1,200 RPM	2022-03-29 15:49:13.304092+00	2022-03-29 15:49:13.304092+00	\N
45ce2f4d-2c04-467b-b37c-053bafde5f16	Noctua NH-U9S	36.8 - 46.4 CFM	\N	16.3 - 22.8 dBA	400 - 2000 RPM	2022-03-29 15:56:00.396629+00	2022-03-29 15:56:00.396629+00	\N
96039447-4c00-4306-bade-5a91fe72e586	Scythe Fuma 2	8.3 - 33.9 CFM (Fan 1), 16.6 - 51.2 CFM (Fan 2)	\N	2.7 - 23.9 dBA (Fan 1), 4.0 - 24.9 dBA (Fan 2)	300 (±300 rpm) ~ 1200 RPM	2022-03-29 15:59:03.280016+00	2022-03-29 15:59:03.280016+00	\N
b51be124-8568-4dee-8590-9ab0915dbf97	Noctua NH-U12S	43.7 - 54.9 CFM	\N	18.6 - 22.4 dBA	300 - 1500 RPM	2022-03-30 12:20:10.380297+00	2022-03-30 12:20:10.380297+00	\N
0b329241-c089-49d5-b038-01b6ff5d5f89	Noctua NH-U9S chromax black	36.8 - 46.4 CFM	\N	16.3 - 22.8 dBA	400 - 2000 RPM	2022-03-30 12:23:34.295448+00	2022-03-30 12:23:34.295448+00	\N
15b372a5-3888-4177-a6ca-2564e6785c3b	Noctua NH-C14S	67.9 - 82.5 CFM	\N	19.2 - 24.6 dBA	300 - 1500 RPM	2022-03-30 12:30:53.267306+00	2022-03-30 12:30:53.267306+00	\N
a5cbe408-bbf3-4c35-a211-c3733b95cf1b	Noctua NH-U14S	67.9 - 82.5 CFM	\N	19.2 - 24.6 dBA	300 - 1500 RPM	2022-03-30 12:49:56.442913+00	2022-03-30 12:49:56.442913+00	\N
327d15ef-3541-481e-8a86-1efebc574de1	Noctua NH-U12S chromax black	43.7 - 54.9 CFM	\N	18.6 - 22.4 dBA	300 - 1500 RPM	2022-03-30 12:55:43.854726+00	2022-03-30 12:55:43.854726+00	\N
f4f4bd50-1248-4e12-a252-c5d4a635136d	Noctua NH-D15S	67.9 - 82.5 CFM	\N	19.2 - 24.6 dB(A)	300 - 1500 RPM	2022-03-30 13:00:54.223609+00	2022-03-30 13:00:54.223609+00	\N
d0a68962-d3eb-4718-906a-f3142fe687be	Noctua NH-U12A	49.7 - 60 CFM	\N	18.8 - 22.6 dB(A)	450 - 2000 RPM	2022-03-30 13:10:16.929898+00	2022-03-30 13:10:16.929898+00	\N
8d4f3e24-7638-4a88-82fa-88ceccc2fcf4	Noctua NH-D15	67.9 - 82.5 CFM	\N	19.2 - 24.6 dBA	300 - 1500 RPM	2022-03-30 13:52:04.284153+00	2022-03-30 13:52:04.284153+00	\N
7561a1c2-f681-40ac-a536-280d5e5647de	Noctua NH-D15S chromax black	67.9 - 82.5 CFM	\N	19.2 - 24.6 dBA	300 - 1500 RPM	2022-03-30 13:58:08.524375+00	2022-03-30 13:58:08.524375+00	\N
087e935e-3662-436d-b57b-0fe697d357bd	Noctua NH-D15 chromax black	67.9 - 82.5 CFM	\N	19.2 - 24.6 dBA	300 - 1500 RPM	2022-03-30 14:01:58.058734+00	2022-03-30 14:01:58.058734+00	\N
12d27680-4cae-497c-85c8-b3644d3eb067	Noctua NH-U12A chromax black	49.7 - 60 CFM	\N	18.8 - 22.6 dBA	450 - 2000 RPM	2022-03-30 14:22:47.515059+00	2022-03-30 14:23:02.636386+00	\N
8c34bc3f-23f1-4d02-8598-f11b009ab598	Noctua NH-D14	37.3 - 54.3 CFM	\N	12.6 - 19.8 dBA	900 - 1300 RPM	2022-03-31 11:55:35.471572+00	2022-03-31 11:55:35.471572+00	\N
81293bcb-b90b-4d4f-9113-1d2fb04c532c	Noctua NH-L9i	24.0 - 33.8 CFM	\N	14.8 - 23.6 dBA	300 - 2500 RPM	2022-04-02 11:58:27.626253+00	2022-04-02 11:58:27.626253+00	\N
e0e0d201-7ac0-412b-a37d-607b85f2a43b	Noctua NH-L9i chromax black	24.0 - 33.8 CFM	\N	14.8 - 23.6 dBA	600 - 2500 RPM	2022-04-02 12:01:47.734919+00	2022-04-02 12:01:47.734919+00	\N
\.


--
-- TOC entry 4394 (class 0 OID 4866933)
-- Dependencies: 231
-- Data for Name: cooling_prices; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.cooling_prices (id, cooling_id, price, shop, shop_link, created_at, updated_at, note) FROM stdin;
e0cc2248-115d-404b-9084-97ce69d3c59d	f2f60e69-3011-45e3-a53a-abc67af97560	705000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-l9a-am4	2022-03-29 14:48:32.048676+00	2022-07-31 06:33:31.034175+00	Sisa 3 stok ketika pendataan
4c3d7876-fed1-4374-903a-78de6d39d092	549229e3-9e52-4e04-80ed-5956e2baff06	805000.0	Tokopedia	https://www.tokopedia.com/eseskomputer/hsf-noctua-nh-u12s-redux-120mm-pwm-cpu-air-cooler?src=topads	2022-03-29 15:24:19.777423+00	2022-07-31 06:33:34.347985+00	sisa 6 stok ketika pendataan
b942709c-91fe-4dcc-a83b-980f8091f0a8	f2f60e69-3011-45e3-a53a-abc67af97560	730000.0	Tokopedia	https://www.tokopedia.com/yoestore/noctua-nh-l9a-am4	2022-03-29 14:41:08.083245+00	2022-07-31 06:33:29.833173+00	sisa 7 stok ketika pendataan
30f07827-b76c-4bc0-a23c-3b7851b7dadc	55d08654-0c72-4352-9809-ff19549efeef	620000.0	Tokopedia	https://www.tokopedia.com/maxcom-computer/scythe-big-shuriken-3-rgb-edition-cpu-air-cooler-120mm	2022-03-29 15:16:03.117301+00	2022-07-31 06:33:32.145312+00	RGB Edition
06e611d9-7171-4a73-9918-938e1193fbb2	55d08654-0c72-4352-9809-ff19549efeef	750000.0	Tokopedia	https://www.tokopedia.com/lezzcom/scythe-big-shuriken-3-rgb-edition-low-profile-cpu-cooler-mini-itx	2022-03-29 15:14:36.719612+00	2022-07-31 06:33:33.284574+00	RGB Edition
cf1ef8b9-80e3-4f22-a63c-891b6b2fe6fc	549229e3-9e52-4e04-80ed-5956e2baff06	830000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-u12s-redux-air-cpu-cooler-158mm-height	2022-03-29 15:24:47.119698+00	2022-07-31 06:33:35.452325+00	Sisa 9 stok ketika pendataan
85de6d31-5618-475a-8071-c35a16163fff	de04adeb-3e9e-456e-a1cc-ecc01abd4b40	775000.0	Tokopedia	https://www.tokopedia.com/distributorpc/hsf-noctua-nh-l9x65-nhl9x65-se-am4-khusus-buat-am4	2022-03-29 15:28:14.486991+00	2022-07-31 06:33:36.572234+00	\N
45083100-e5c5-4653-bff1-aa40a1a8bca5	de04adeb-3e9e-456e-a1cc-ecc01abd4b40	741000.0	Tokopedia	https://www.tokopedia.com/gasolsumbersari/noctua-nh-l9x65-se-am4-65mm-fan-with-pwm	2022-03-29 15:29:08.505672+00	2022-07-31 06:33:37.901427+00	\N
3a5e7c79-8d90-4e98-bbfa-3685aa317dff	a1147fb1-9ab2-484e-be6a-222cc4198fb0	910000.0	Tokopedia	https://www.tokopedia.com/distributorpc/noctua-nh-l12s-multi-socket-intel-and-amd-am4-ready	2022-03-29 15:33:16.755719+00	2022-07-31 06:33:38.92375+00	multi-socket intel dan AMD
7a4bf0c9-48e9-4266-a32f-718629ad2b30	a1147fb1-9ab2-484e-be6a-222cc4198fb0	910000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-l12s-multi-socket-intel-and-amd-am4-ready-1	2022-03-29 15:33:33.813916+00	2022-07-31 06:33:40.038244+00	multi-socket intel dan AMD
3531b515-4183-40be-a666-bbf10741c520	a1147fb1-9ab2-484e-be6a-222cc4198fb0	910000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-l12s-multi-socket-intel-and-amd-am4-ready-1	2022-03-29 15:33:46.313711+00	2022-07-31 06:33:41.116884+00	multi-socket intel dan AMD
6ed73aa8-abed-4d0f-a087-95d153926cca	367ebad4-a64d-4efc-8fc2-89bd64c97d62	831000.0	Tokopedia	https://www.tokopedia.com/gasol/noctua-nh-l9a-am4-ch-bk-chromax-black-37mm-fan-with-pwm	2022-03-29 15:42:10.063832+00	2022-07-31 06:33:42.301608+00	\N
73254c9e-e686-428a-9d17-3ec6aace32b9	367ebad4-a64d-4efc-8fc2-89bd64c97d62	785000.0	Tokopedia	https://www.tokopedia.com/distributorpc/noctua-nh-l9a-am4-chromax-black	2022-03-29 15:42:25.795741+00	2022-07-31 06:33:43.360593+00	\N
b15ea71a-32e0-4864-86bf-22f6778a4120	367ebad4-a64d-4efc-8fc2-89bd64c97d62	785000.0	Tokopedia	https://www.tokopedia.com/tokoexpert/noctua-nh-l9a-am4-ch-bk-chromax-black-for-amd-low-profile-cpu-cooler	2022-03-29 15:42:46.053809+00	2022-07-31 06:33:44.442687+00	
81facfa8-281d-4c78-9efc-da70529d5a0a	e141a650-e299-462f-b831-d2682d1d6c85	835000.0	Tokopedia	https://www.tokopedia.com/distributorpc/noctua-nh-d9l?refined=true	2022-03-29 15:46:00.704816+00	2022-07-31 06:33:45.603099+00	\N
e9b9b134-99b9-416a-b368-b5c4d01cec47	e141a650-e299-462f-b831-d2682d1d6c85	847000.0	Tokopedia	https://www.tokopedia.com/enterkomputer/noctua-nh-d9l?refined=true	2022-03-29 15:46:13.617705+00	2022-07-31 06:33:46.605266+00	\N
020e8463-de76-4449-870a-9dc6034e7f8a	e141a650-e299-462f-b831-d2682d1d6c85	835000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-d9l?refined=true	2022-03-29 15:46:23.021888+00	2022-07-31 06:33:47.819765+00	\N
de509f1f-e225-4ac9-adc8-234fe1939429	bc90ed05-8ce7-4485-86f4-5de710fd0e5d	789000.0	Tokopedia	https://www.tokopedia.com/gamersoutpost/scythe-air-cpu-cooling-mugen-5-rev-b	2022-03-29 15:51:28.590097+00	2022-07-31 06:33:50.076083+00	sisa 7 stok ketika pendataan, diskon 4% menjadi 769000
d6b05229-d0da-44cc-a09d-469a185452f0	bc90ed05-8ce7-4485-86f4-5de710fd0e5d	835000.0	Tokopedia	https://www.tokopedia.com/lezzcom/scythe-mugen-5-rev-b-high-performance-silent-cpu-air-cooler	2022-03-29 15:51:48.077743+00	2022-07-31 06:33:51.316527+00	sisa 9 stok ketika pendataan
0cdfe23b-70cd-4573-ba95-20d6a78ef61b	45ce2f4d-2c04-467b-b37c-053bafde5f16	910000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-u9s	2022-03-29 15:56:24.916409+00	2022-07-31 06:33:52.532941+00	\N
0939fd7e-35ed-48a3-a3bf-0331f96e2487	96039447-4c00-4306-bade-5a91fe72e586	1019000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/scythe-fuma-2-twin-tower-cpu-cooler-with-dual-fan-reverse-airflow-dengan-lga-1700	2022-03-29 16:00:03.221632+00	2022-07-31 06:33:53.965707+00	sisa stok 9 untuk varian tanpa socket LGA 1700
e30c2988-cfa2-4033-947c-20e02e9a2b69	96039447-4c00-4306-bade-5a91fe72e586	950000.0	Tokopedia	https://www.tokopedia.com/eseskomputer/scythe-fuma-2-cpu-air-cooler-hsf-intel-lga1200-lga1151-amd-am4-ryzen	2022-03-29 16:00:56.8867+00	2022-07-31 06:33:56.238386+00	
7507c471-9908-4fee-b7db-7f3d22dde6cc	b51be124-8568-4dee-8590-9ab0915dbf97	1160000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-u12s	2022-03-30 12:20:45.045535+00	2022-07-31 06:33:57.449509+00	sisa 2 stok ketika pendataan
a7b0c79b-dd12-4502-9474-1e3f579b5400	b51be124-8568-4dee-8590-9ab0915dbf97	1160000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-u12s	2022-03-30 12:21:04.909386+00	2022-07-31 06:33:58.489381+00	\N
20f765b3-8bfa-455e-8bf9-e8806a81cc2b	0b329241-c089-49d5-b038-01b6ff5d5f89	950000.0	Tokopedia	https://www.tokopedia.com/distributorpc/noctua-nh-u9s-ch-bk-chromax-black	2022-03-30 12:28:40.132734+00	2022-07-31 06:33:59.699969+00	\N
7c346c10-8bb2-4e8a-bc0a-28816215855f	0b329241-c089-49d5-b038-01b6ff5d5f89	940000.0	Tokopedia	https://www.tokopedia.com/maxcom-computer/noctua-nh-u9s-ch-bk-chromax-black	2022-03-30 12:28:55.707169+00	2022-07-31 06:34:00.737009+00	\N
0686b72b-6591-4887-8f90-701e8413c357	15b372a5-3888-4177-a6ca-2564e6785c3b	1265000.0	Tokopedia	https://www.tokopedia.com/maxcom-computer/noctua-cpu-cooler-nh-c14s	2022-03-30 12:31:23.653549+00	2022-07-31 06:34:01.96367+00	\N
6fe1a50a-c23a-4b59-a9cc-71a03021568d	15b372a5-3888-4177-a6ca-2564e6785c3b	1240000.0	Tokopedia	https://www.tokopedia.com/sportonlineshop/noctua-nh-c14s	2022-03-30 12:31:32.84558+00	2022-07-31 06:34:03.109744+00	\N
b8f816da-2c77-41db-a601-1ad576025a78	15b372a5-3888-4177-a6ca-2564e6785c3b	1230000.0	Tokopedia	https://www.tokopedia.com/fhc-store123/noctua-nh-c14s-cpu-cooler	2022-03-30 12:31:51.950255+00	2022-07-31 06:34:04.20418+00	Sisa 2 stok ketika pendataan
092d3a44-2759-4311-a737-26e87e26b164	a5cbe408-bbf3-4c35-a211-c3733b95cf1b	1220000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-u14s	2022-03-30 12:51:36.286376+00	2022-07-31 06:34:05.35331+00	Sisa 4 stok ketika pendataan
50d9628c-db71-48fb-99c8-0e5c0f38dbd5	a5cbe408-bbf3-4c35-a211-c3733b95cf1b	1220000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-u14s	2022-03-30 12:51:50.870672+00	2022-07-31 06:34:06.463871+00	\N
a78d942e-4e53-4693-af60-860e9da151d5	a5cbe408-bbf3-4c35-a211-c3733b95cf1b	1238000.0	Tokopedia	https://www.tokopedia.com/enterkomputer/noctua-nh-u14s	2022-03-30 12:52:26.591991+00	2022-07-31 06:34:09.018969+00	\N
4a79edad-bf20-4d1f-814d-36c0636de19d	327d15ef-3541-481e-8a86-1efebc574de1	1260000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-u12s-ch-bk-chromax-black	2022-03-30 12:56:17.059951+00	2022-07-31 06:34:10.143803+00	\N
a5900e3e-489c-4239-8f06-b571d3828481	327d15ef-3541-481e-8a86-1efebc574de1	1250000.0	Tokopedia	https://www.tokopedia.com/onedicom/fan-noctua-nh-u12s-chromax-black	2022-03-30 12:57:00.548892+00	2022-07-31 06:34:11.203714+00	Sisa 6 stok ketika pendataan
715c0913-fc6d-416b-b55b-f04f02ef9a14	f4f4bd50-1248-4e12-a252-c5d4a635136d	1420000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-d15s?refined=true	2022-03-30 13:01:26.570028+00	2022-07-31 06:34:12.266082+00	\N
bdedae87-8c45-4912-aa5c-1abf326fc679	d0a68962-d3eb-4718-906a-f3142fe687be	1720000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-u12a	2022-03-30 13:10:49.035134+00	2022-07-31 06:34:13.451285+00	\N
aaeed709-8687-4537-bb55-67f55ee9bebf	d0a68962-d3eb-4718-906a-f3142fe687be	1720000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-u12a	2022-03-30 13:11:14.626853+00	2022-07-31 06:34:14.661625+00	\N
b34fdde4-4a87-4a46-8ce4-264561483a9e	d0a68962-d3eb-4718-906a-f3142fe687be	1746000.0	Tokopedia	https://www.tokopedia.com/enterkomputer/noctua-nh-u12a	2022-03-30 13:11:31.478086+00	2022-07-31 06:34:15.78753+00	\N
51fcda80-6224-4b74-b4eb-638cc03bb879	8d4f3e24-7638-4a88-82fa-88ceccc2fcf4	1570000.0	Tokopedia	https://www.tokopedia.com/distributorpc/noctua-nh-d15?refined=true	2022-03-30 13:53:59.389339+00	2022-07-31 06:34:16.913831+00	\N
1313899f-4675-4477-8e8f-2152f93baf89	8d4f3e24-7638-4a88-82fa-88ceccc2fcf4	1595000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-d15?refined=true	2022-03-30 13:54:09.501813+00	2022-07-31 06:34:17.962038+00	\N
60cee643-ff96-4232-9c97-f0ecf681365c	bc90ed05-8ce7-4485-86f4-5de710fd0e5d	760000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/scythe-mugen-5-rev-b-tower-cpu-air-cooler-dengan-lga-1700	2022-03-29 15:50:50.7795+00	2022-07-31 06:33:48.844883+00	Sisa stok 3 (tanpa socket LGA 1700) dan 4 (dengan socket LGA 1700)
650bd4e5-9e17-4b7d-b2e9-018b7c9e9b2e	96039447-4c00-4306-bade-5a91fe72e586	1049000.0	Tokopedia	https://www.tokopedia.com/gamersoutpost/scythe-air-cpu-cooling-fuma-2	2022-03-29 16:00:37.569992+00	2022-07-31 06:33:55.110191+00	sisa 6 stok ketika pendataan, diskon 3% menjadi 1019000
49739d98-e9a3-4c4e-8e02-2665ac65e4e8	7561a1c2-f681-40ac-a536-280d5e5647de	1555000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-d15s-chromax-black-air-cpu-cooler-160mm-height?refined=true	2022-03-30 13:58:46.079369+00	2022-07-31 06:34:19.054434+00	Sisa 4 stok ketika pendataan
8a6f7d2f-7861-4aef-9fe2-74b31e374510	7561a1c2-f681-40ac-a536-280d5e5647de	1510000.0	Tokopedia	https://www.tokopedia.com/maxcom-computer/noctua-nh-d15s-ch-bk-chromax-black-fan-cooler?refined=true	2022-03-30 13:58:58.656971+00	2022-07-31 06:34:21.312558+00	\N
0be9f21a-595f-477f-8e54-1a44e4885f71	7561a1c2-f681-40ac-a536-280d5e5647de	1578000.0	Tokopedia	https://www.tokopedia.com/enterkomputer/noctua-nh-d15s-ch-bk-chromax-black?refined=true	2022-03-30 13:59:16.106679+00	2022-07-31 06:34:22.548864+00	\N
b131cbfa-752a-4a95-bacd-54615ba2bf75	087e935e-3662-436d-b57b-0fe697d357bd	1690000.0	Tokopedia	https://www.tokopedia.com/distributorpc/noctua-nh-d15-ch-bk-chromax-black?refined=true	2022-03-30 14:02:44.553716+00	2022-07-31 06:34:23.535872+00	Sisa 2 stok ketika pendataan
e5f4c1bf-6d03-4e5f-bd58-4c1a07d28c40	087e935e-3662-436d-b57b-0fe697d357bd	1741000.0	Tokopedia	https://www.tokopedia.com/enterkomputer/noctua-nh-d15-ch-bk-chromax-black?refined=true	2022-03-30 14:03:02.805094+00	2022-07-31 06:34:24.791273+00	\N
91b44c5f-0b40-4aff-b848-38aa460dd8de	12d27680-4cae-497c-85c8-b3644d3eb067	1845000.0	Tokopedia	https://www.tokopedia.com/eseskomputer/hsf-noctua-nh-u12a-chromax-black-dual-fan-nf-a12x25-120mm-cpu-cooler?src=topads	2022-03-30 14:23:42.818874+00	2022-07-31 06:34:25.926507+00	Sisa 8 stok ketika pendataan
c0aa8dcf-49c4-4c54-8e74-695cff2575a4	12d27680-4cae-497c-85c8-b3644d3eb067	1900000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-u12a-chromax-black-140mm-performance-in-120mm-size	2022-03-30 14:23:54.931378+00	2022-07-31 06:34:26.914358+00	\N
4313f0e5-955b-44fb-bb3b-1ffbb5b34aa8	8c34bc3f-23f1-4d02-8598-f11b009ab598	1255000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-d14-fan-14cm-fan-12cm?refined=true	2022-03-31 11:56:04.378482+00	2022-07-31 06:34:28.017478+00	\N
c61dc18d-9bdc-42b6-a5a0-12d7ad46415f	8c34bc3f-23f1-4d02-8598-f11b009ab598	1274000.0	Tokopedia	https://www.tokopedia.com/enterkomputer/noctua-nh-d14-fan-14cm-fan-12cm?refined=true	2022-03-31 11:56:19.12883+00	2022-07-31 06:34:29.098296+00	\N
8d4f3bcd-9c41-4ecf-b9dd-2c537315edf2	8c34bc3f-23f1-4d02-8598-f11b009ab598	1275000.0	Tokopedia	https://www.tokopedia.com/jnj77/noctua-nh-d14-cooler-fan?refined=true	2022-03-31 11:56:30.01389+00	2022-07-31 06:34:30.317908+00	\N
ae6ddfd2-1ae4-4b95-91ba-b5bfa4240f95	81293bcb-b90b-4d4f-9113-1d2fb04c532c	730000.0	Tokopedia	https://www.tokopedia.com/yoestore/noctua-nh-l9i-intel	2022-04-02 11:59:01.509886+00	2022-07-31 06:34:31.560526+00	Sisa 3 stok ketika pendataan
90dcfef7-bbcc-4e40-8a66-c405ff2ee2b9	81293bcb-b90b-4d4f-9113-1d2fb04c532c	705000.0	Tokopedia	https://www.tokopedia.com/nanokomputer/noctua-nh-l9i	2022-04-02 11:59:14.383063+00	2022-07-31 06:34:32.783298+00	Sisa 4 stok ketika pendataan
1626deae-c5e2-4047-acef-b1b5e12007bd	e0e0d201-7ac0-412b-a37d-607b85f2a43b	810000.0	Tokopedia	https://www.tokopedia.com/cockomputer/noctua-nh-l9i-ch-bk-chromax-black	2022-04-02 12:02:50.423934+00	2022-07-31 06:34:33.901581+00	\N
f1d26450-79ff-424d-87b5-8540366c7002	e0e0d201-7ac0-412b-a37d-607b85f2a43b	822000.0	Tokopedia	https://www.tokopedia.com/enterkomputer/noctua-nh-l9i-ch-bk-chromax-black	2022-04-02 12:03:01.142+00	2022-07-31 06:34:35.142453+00	\N
58b338df-77f2-41f4-b541-ffb30593fb9b	e0e0d201-7ac0-412b-a37d-607b85f2a43b	785000.0	Tokopedia	https://www.tokopedia.com/eseskomputer/hsf-noctua-nh-l9i-ch-bk-chromax-black-low-profile-pwm-cpu-cooler	2022-04-02 12:03:12.495577+00	2022-07-31 06:34:36.357302+00	\N
48df8fe4-f241-42fc-b2c8-ff762f08c689	de04adeb-3e9e-456e-a1cc-ecc01abd4b40	770000.0	Tokopedia	https://www.tokopedia.com/lezzcom/noctua-nh-l9x65-se-am4-cpu-cooler-for-amd-am4-ryzen?extParam=ivf%3Dfalse%26src%3Dsearch	2022-03-29 15:28:38.231099+00	2022-07-31 06:34:37.601491+00	Sisa 5 stok ketika pendataan
\.


--
-- TOC entry 4376 (class 0 OID 4725295)
-- Dependencies: 213
-- Data for Name: cpu; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.cpu (id, name, "Cores", "Clock", socket_name, process, l3_cache, tdp_watt, release_date, created_at, updated_at, target_market_number, manufacturer, image_url) FROM stdin;
4db9fc51-8da6-423e-8cc6-cb1cc3aee181	Core i5-9400F	6	2.9 to 4.1 GHz	LGA 1151	14 nm	9MB	65	2019-01-08	2022-03-11 13:39:29.371008+00	2022-06-01 11:39:06.064841+00	2	Intel	\N
2deca30a-654b-4151-b64c-c342213ad1f1	Core i3-6100	2 / 4	3.7 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-07 15:21:47.242099+00	2022-03-17 06:50:27.755397+00	\N	Intel	\N
d6277f06-d234-4134-84b1-91bc6a7a5b31	Core i3-6300	2 / 4	3.8 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-07 15:22:54.728724+00	2022-03-17 06:50:27.94081+00	\N	Intel	\N
369e9a4e-b550-48bc-a648-7adb3ccff452	Core i3-6320	2 / 4	3.9 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-07 15:23:44.182358+00	2022-03-17 06:50:28.1254+00	\N	Intel	\N
3500a457-2029-44c8-8095-f33bc86085dd	Core i5-6500	4	3.2 to 3.6 GHz	LGA 1151	14 nm	6MB	65	2015-07-02	2022-03-07 15:26:03.986584+00	2022-03-17 06:50:28.499271+00	\N	Intel	\N
59fc7492-c5b0-4fb5-a70a-59ea8eb24f03	Core i5-6600	4	3.3 to 3.9 GHz	LGA 1151	14 nm	\t6MB	65	2015-07-02	2022-03-07 15:27:02.240998+00	2022-03-17 06:50:28.685369+00	\N	Intel	\N
15e18ae2-724b-44da-a665-658721066307	Core i7-6700K	4 / 8	4 to 4.2 GHz	LGA 1151	14 nm	8MB	95	2015-08-01	2022-03-07 15:30:14.406048+00	2022-03-17 06:50:29.237164+00	\N	Intel	\N
badca754-fc26-4115-9a3f-34e3776a3d6a	Core i7-6700T	4 / 8	2.8 to 3.6 GHz	LGA 1151	14 nm	8MB	35	2015-09-01	2022-03-07 15:31:34.444564+00	2022-03-17 06:50:29.422534+00	\N	Intel	\N
82e37e3b-c3fb-4435-add1-6eef48d66d2e	Core i7-6700TE	4 / 8	2.4 to 3.4 GHz	LGA 1151	14 nm	8MB	35	2015-09-01	2022-03-07 15:33:00.681617+00	2022-03-17 06:50:29.609243+00	\N	Intel	\N
3a817a2f-4e55-4192-b2a0-b2673312e861	Core i7-6850K	6 / 12	3.6 to 3.8 GHz	LGA 2011-3	14 nm	15MB	140	2016-05-31	2022-03-07 15:46:24.476488+00	2022-03-17 06:50:29.984834+00	\N	Intel	\N
a5b33a17-0033-4f89-9b2c-9e05affe9d33	Core i7-6900K	8 / 16	3.2 to 3.7 GHz	LGA 2011-3	14 nm	20MB	140	2016-05-31	2022-03-07 15:47:10.752862+00	2022-03-17 06:50:30.16891+00	\N	Intel	\N
f6d20277-4d60-46ad-a8c0-95802c91d06f	Core i7-6950X	10 / 20	3 to 3.5 GHz	LGA 2011-3	14 nm	25MB	140	2016-05-31	2022-03-07 15:47:53.450129+00	2022-03-17 06:50:30.353919+00	\N	Intel	\N
2725993e-d98d-4c8b-8351-23cf6e86d2d7	Core i3-7100	2 / 4	3.9 GHz	LGA 1151	14 nm	3MB	51	2017-01-03	2022-03-07 16:07:33.326549+00	2022-03-17 06:50:30.537858+00	\N	Intel	\N
18cbfd6a-142c-44f6-9ef3-04b8f01bb468	Core i3-7120	2 / 4	4 GHz	LGA 1151	14 nm	3MB	51	2017-07-17	2022-03-07 16:10:32.637967+00	2022-03-17 06:50:30.908696+00	\N	Intel	\N
03c959f1-1902-4173-ba17-484ca15984a0	Core i3-7120T	2 / 4	3.6 GHz	LGA 1151	14 nm	3MB	35	2017-07-17	2022-03-07 16:11:18.263223+00	2022-03-17 06:50:31.094723+00	\N	Intel	\N
593092b2-5fc8-4036-bcc9-852dd50426c1	Core i3-7300	2 / 4	4 GHz	LGA 1151	14 nm	4MB	51	2017-01-03	2022-03-07 16:16:34.588611+00	2022-03-17 06:50:31.280952+00	\N	Intel	\N
ff40ae7d-705e-4c8e-8de2-767d8165e00d	Core i3-7300T	2 / 4	3.5 GHz	LGA 1151	14 nm	4MB	35	2017-01-03	2022-03-07 16:17:13.334908+00	2022-03-17 06:50:31.466039+00	\N	Intel	\N
a1f61d3a-fe38-41e3-8466-94f1a3bdba89	Core i3-7320	2 / 4	4.1 GHz	LGA 1151	14 nm	4MB	51	2017-01-03	2022-03-08 13:34:18.355374+00	2022-03-17 06:50:31.651104+00	\N	Intel	\N
043395c2-2ed8-4f90-89e6-e5a214357bb8	Core i3-7320T	2 / 4	3.6 GHz	LGA 1151	14 nm	4MB	35	2017-07-17	2022-03-08 13:35:13.283718+00	2022-03-17 06:50:31.836729+00	\N	Intel	\N
422a7585-475a-4d03-b2c0-bca10e9a0c76	Core i3-7340	2 / 4	4.2 GHz	LGA 1151	14 nm	4,B	51	2017-07-17	2022-03-08 13:36:01.963709+00	2022-03-17 06:50:32.020127+00	\N	Intel	\N
f011d70c-72f1-490a-9d0d-cf1ea56ccbc1	Core i3-7350K	2 / 4	4.2 GHz	LGA 1151	14 nm	4MB	60	2017-01-03	2022-03-08 13:36:56.467776+00	2022-03-17 06:50:32.204758+00	\N	Intel	\N
26e8e3c9-9d8f-4ad3-9e48-72f1fc17c93a	Core i3-8100	4	2.8 to 3.6 GHz	LGA 1151	14 nm	6MB	62	2017-10-05	2022-03-08 13:37:35.086673+00	2022-03-17 06:50:32.388159+00	\N	Intel	\N
2c42c997-1a08-4552-9665-2bb793ec4e5a	Core i3-8350K	4	4 GHz	LGA 1151	14 nm	8MB	91	2017-10-05	2022-03-08 13:41:45.357626+00	2022-03-17 06:50:32.572283+00	\N	Intel	\N
a5a34cf1-433d-4861-ac9a-6586b5e6e12b	Core i5-7400	4	3 to 3.5 GHz	LGA 1151	14 nm	6MB	65	2017-01-03	2022-03-08 13:42:27.286219+00	2022-03-17 06:50:32.755956+00	\N	Intel	\N
29658954-6eca-4aca-9065-40aacb030cde	Core i5-7400T	4	2.4 to 3 GHz	LGA 1151	14 nm	6MB	35	2017-01-03	2022-03-08 13:43:22.533879+00	2022-03-17 06:50:32.94951+00	\N	Intel	\N
b81898c3-8cbf-4890-8703-131b385ebd5e	Core i5-7500	4	3.4 to 3.8 GHz	LGA 1151	14 nm	6MB	65	2017-01-03	2022-03-08 13:44:04.086867+00	2022-03-17 06:50:33.183699+00	\N	Intel	\N
610e8328-ebb0-49f9-9265-c037544d80e6	Core i5-7500T	4	2.7 to 3.3 GHz	LGA 1151	14 nm	6MB	35	2017-01-03	2022-03-08 13:44:47.808614+00	2022-03-17 06:50:33.367444+00	\N	Intel	\N
451f0c1b-64b2-452e-bafc-6be0ea1ce444	Core i5-7600	4	3.5 to 4.1 GHz	LGA 1151	14 nm	6MB	65	2017-01-03	2022-03-08 13:45:25.495262+00	2022-03-17 06:50:33.551234+00	\N	Intel	\N
5e7a35d6-b1fc-42dd-a3ae-2bfa9a96b93a	Core i5-7600K	4	3.8 to 4.2 GHz	LGA 1151	14 nm	6MB	91	2017-01-03	2022-03-08 13:46:09.366985+00	2022-03-17 06:50:33.737196+00	\N	Intel	\N
f0d6aa92-b659-42d3-8d76-ca31548ea14d	Core i5-8400	6	2.8 to 4 GHz	LGA 1151	14 nm	9MB	65	2017-10-05	2022-03-08 13:47:41.519608+00	2022-03-17 06:50:34.105514+00	\N	Intel	\N
fe67f670-8ae5-4d99-933c-33431783993d	Core i5-8600K	6	3.6 to 4.3 GHz	LGA 1151	14 nm	9MB	95	2017-10-05	2022-03-08 13:48:25.806294+00	2022-03-17 06:50:34.289831+00	\N	Intel	\N
44212aa8-3662-47c9-bae4-f66b8e26f029	Core i7-7700	4 / 8	3.6 to 4.2 GHz	LGA 1151	14 nm	8MB	65	2017-01-03	2022-03-08 13:49:04.982986+00	2022-03-17 06:50:34.474763+00	\N	Intel	\N
3002a092-a509-4fca-bf79-5aa1db4ffa85	Core i7-7700K	4 / 8	4.2 to 4.5 GHz	LGA 1151	14 nm	8MB	91	2017-01-03	2022-03-08 13:49:55.704652+00	2022-03-17 06:50:34.658976+00	\N	Intel	\N
df1e893f-d06a-421a-996d-2f40b3bfd8e1	Core i7-7700T	4 / 8	2.9 to 3.8 GHz	LGA 1151	14 nm	8MB	35	2017-01-03	2022-03-08 13:52:42.892201+00	2022-03-17 06:50:34.842948+00	\N	Intel	\N
7b4d7aad-300e-455e-b8d8-5f8993df3f52	Core i7-8700K	6 / 12	3.7 to 4.7 GHz	LGA 1151	14 nm	12MB	95	2017-10-05	2022-03-08 13:53:23.257758+00	2022-03-17 06:50:35.028715+00	\N	Intel	\N
bb5beeb4-0251-4a2d-952d-03702407b461	Core i3-7360X	2 / 4	4.3 GHz	LGA 2066	14 nm	4MB	112	2017-10-03	2022-03-08 14:14:17.155676+00	2022-03-17 06:50:35.213008+00	\N	Intel	\N
0cb7897d-3c56-4d4e-b134-0074b27ad735	Core i5-7640X	4	3.9 to 4.3 GHz	LGA 2066	14 nm	6MB	112	2017-06-26	2022-03-08 14:15:31.553177+00	2022-03-17 06:50:35.398536+00	\N	Intel	\N
0211e623-f7f5-4415-9694-6fd149a0a4d3	Core i7-7740X	4 / 8	4.3 to 4.6 GHz	LGA 2066	14 nm	8MB	112	2017-06-26	2022-03-08 14:20:15.338375+00	2022-03-17 06:50:35.5824+00	\N	Intel	\N
40aaa18d-d67a-4729-8d4a-5a1b3e90e373	Core i7-7800X	6 / 12	3.5 to 4 GHz	LGA 2066	14 nm	8.25MB	140	2017-06-26	2022-03-08 14:22:01.282217+00	2022-03-17 06:50:35.766145+00	\N	Intel	\N
de6c00bd-8494-474e-b07e-b990788f4eba	Core i9-7900X	10 / 20	3.3 to 4.5 GHz	LGA 2066	14 nm	14MB	140	2017-06-26	2022-03-08 14:23:23.25125+00	2022-03-17 06:50:36.134998+00	\N	Intel	\N
6b5d591a-3ffd-4a64-ac06-b12aadfcaea3	Core i9-7920X	12 / 24	2.9 to 4.4 GHz	LGA 2066	14 nm	16.5MB	140	2017-09-10	2022-03-08 14:24:09.746897+00	2022-03-17 06:50:36.31878+00	\N	Intel	\N
8046319c-d565-417a-b993-c3ed468959ee	Core i9-7940X	14 / 28	3.1 to 4.4 GHz	LGA 2066	14 nm	19.25MB	165	2017-09-01	2022-03-08 14:24:53.503828+00	2022-03-17 06:50:36.502937+00	\N	Intel	\N
9c9f7c7c-11b4-4119-95fb-237e26270229	Core i9-7960X	16 / 32	2.8 to 4.4 GHz	LGA 2066	14 nm	22MB	165	2017-09-01	2022-03-08 14:25:35.245106+00	2022-03-17 06:50:36.68635+00	\N	Intel	\N
0205e6e8-4c32-4c5d-a6b8-8df1acb5c50e	Core i9-7980XE	18 / 36	2.6 to 4.4 GHz	LGA 2066	14 nm	24.75MB	165	2017-09-01	2022-03-08 14:26:16.692267+00	2022-03-17 06:50:36.869745+00	\N	Intel	\N
90881a69-2f92-49dd-a4a5-a43746c8ce60	Pentium G4400	2	3.3 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-07 15:34:00.460553+00	2022-03-17 06:51:32.255097+00	\N	Intel	\N
6452c99a-7ccc-44cf-99e2-c301271ea9c5	Pentium G4560	2 / 4	3.5 GHz	LGA 1151	14 nm	3MB	51	2017-01-03	2022-03-08 13:53:58.755456+00	2022-03-17 06:51:32.811514+00	\N	Intel	\N
61aa8300-c963-41e1-8299-1ecb6049b3fb	Pentium G4560T	2 / 4	2.9 GHz	LGA 1151	14 nm	3MB	35	2017-01-03	2022-03-08 13:54:38.93317+00	2022-03-17 06:51:32.995352+00	\N	Intel	\N
8b89620a-4647-4b99-a632-0133d26fa6a7	Pentium G4600	2 / 4	3.6 GHz	LGA 1151	14 nm	3MB	51	2017-01-03	2022-03-08 13:55:52.325064+00	2022-03-17 06:51:33.180659+00	\N	Intel	\N
ea528726-017d-4b99-acda-d006e8622bba	Pentium G4600T	2 / 4	3 GHz	LGA 1151	14 nm	3MB	35	2017-01-03	2022-03-08 13:56:23.515606+00	2022-03-17 06:51:33.377579+00	\N	Intel	\N
442afc02-c22f-48ba-86ca-fce533160ef1	Pentium G4620	2 / 4	3.7 GHz	LGA 1151	14 nm	3MB	51	2017-01-03	2022-03-08 13:56:59.55683+00	2022-03-17 06:51:33.5611+00	\N	Intel	\N
e1476bf8-cfec-4dab-b84d-a1b74d249841	Celeron G3900	2	2.8 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-06 13:38:35.339883+00	2022-03-17 06:53:06.864808+00	\N	Intel	\N
c97a80c4-0ce8-407d-99ff-8ee2b5b17bf1	Celeron G3920	2	2.9 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-06 13:39:15.40541+00	2022-03-17 06:53:07.04815+00	\N	Intel	\N
39045342-d1fe-4346-8366-20cd2c0c534e	Core i5-8400T	6	1.7 to 3.3 GHz	LGA 1151	14 nm	9MB	35	2018-04-02	2022-03-08 14:35:28.392215+00	2022-06-01 07:12:30.314577+00	2	Intel	\N
8be182d2-8da1-45b2-8100-66dfde23dfdf	Core i3-8000	4	3.6 GHz	LGA 1151	14 nm	6MB	65	2018-09-01	2022-03-08 14:29:48.593245+00	2022-06-01 06:54:23.921818+00	1	Intel	\N
d528cb55-c69f-4d45-9bae-b46d623b77c8	Core i3-8100T	4	3.1 GHz	LGA 1151	14 nm	6MB	35	2018-04-02	2022-03-08 14:30:57.075349+00	2022-06-01 06:54:48.893003+00	1	Intel	\N
3841bc4c-8e50-47cc-a056-9318b3193cc3	Core i3-8120	4	3.7 GHz	LGA 1151	14 nm	6MB	65	2018-09-01	2022-03-08 14:31:31.296322+00	2022-06-01 06:56:12.648373+00	1	Intel	\N
4455b1e4-af07-48cd-b547-d1bbe0b1cd60	Core i3-8300T	4	3.2 GHz	LGA 1151	14 nm	8MB	35	2018-04-02	2022-03-08 14:33:20.384048+00	2022-06-01 07:02:44.322003+00	1	Intel	\N
a0f5ffc8-cabd-4911-b7b3-d22055211750	Core i3-8300	4	3.7 GHz	LGA 1151	14 nm	8MB	62	2018-02-14	2022-03-08 14:32:26.364824+00	2022-06-01 06:58:48.29993+00	1	Intel	\N
b7dabda1-b32e-40a6-8c3b-983848b508bc	Core i3-9000	4	3.7 GHz	LGA 1151	14 nm	6MB	65	2018-09-01	2022-03-08 14:34:10.12143+00	2022-06-01 07:11:10.645051+00	1	Intel	\N
7df12187-d125-49d1-988b-34ce4362cbe3	Core i9-9920X	12 / 24	3.5 to 4.4 GHz	LGA 2066	14 nm	19.25MB	165	2018-10-19	2022-03-11 13:30:28.175236+00	2022-06-26 16:27:29.220237+00	4	Intel	\N
74a24f0f-533a-4c75-8a39-e415fddcdf2d	Core i5-9400T	6	1.8 to 3.4 GHz	LGA 1151	14 nm	9MB	35	2018-09-01	2022-03-08 15:03:12.346581+00	2022-06-01 07:11:49.783039+00	2	Intel	\N
85b187a0-1e24-471e-8506-e8859e3f804d	Core i5-8420T	6	1.8 to 3.4 GHz	LGA 1151	14 nm	9MB	35	2018-09-01	2022-03-08 14:51:26.627917+00	2022-06-01 07:19:43.578229+00	2	Intel	\N
95448d9c-0b93-48ea-862f-f8f74c6ad210	Core i5-8500	6	3 to 4.1 GHz	LGA 1151	14 nm	9MB	65	2018-02-14	2022-03-08 14:52:35.725262+00	2022-06-01 07:19:56.214798+00	2	Intel	\N
d8d41e28-77e2-4c2c-b0f0-5d38a42ea164	Core i5-8550	6	3 to 4.3 GHz	LGA 1151	14 nm	9MB	65	2018-09-01	2022-03-08 14:57:19.219495+00	2022-06-01 07:24:53.190656+00	2	Intel	\N
04500f7f-6b9c-4356-a8ae-7eb2c9a310a9	Pentium Gold G5400	2 / 4	3.7 GHz	LGA 1151	14 nm	4MB	51	2018-04-02	2022-03-11 13:25:14.88559+00	2022-03-17 06:51:33.747058+00	\N	Intel	\N
c39f15c8-e6f9-4663-950c-e3fed87669a7	Core i5-8600	6	3.1 to 4.3 GHz	LGA 1151	14 nm	9MB	65	2018-02-14	2022-03-08 14:57:55.353745+00	2022-06-01 07:25:14.861659+00	2	Intel	\N
8424aec2-a2c4-498d-bc73-f75737f8f59a	Core i5-8600T	6	2.3 to 3.7 GHz	LGA 1151	14 nm	9MB	35	2018-04-02	2022-03-08 14:58:33.48717+00	2022-06-01 07:25:29.20202+00	2	Intel	\N
9cd527c3-1372-4cb4-9f6d-37b01f2718c3	Core i5-8650	6	3.1 to 4.5 GHz	LGA 1151	14 nm	9MB	65	2018-09-01	2022-03-08 14:59:10.428249+00	2022-06-01 07:29:20.737102+00	2	Intel	\N
94ad902f-8f8d-4563-81ee-22c621b031d5	Core i5-8650K	6	3.7 to 4.5 GHz\t	LGA 1151	14 nm	9MB	95	2018-09-01	2022-03-08 15:00:45.033777+00	2022-06-01 07:44:55.521481+00	2	Intel	\N
fa746038-0d96-40ff-ad4b-a3a91860d52b	Core i5-9400	6	2.9 to 4.1 GHz	LGA 1151	14 nm	9MB	65	2018-10-19	2022-03-08 15:02:27.016539+00	2022-06-01 07:45:10.300751+00	2	Intel	\N
199af7de-2108-45ea-9cda-4893b35c9fe3	Core i5-9500	6	3 to 4.3 GHz	LGA 1151	14 nm	9MB	65	2018-10-19	2022-03-08 15:04:14.399022+00	2022-06-01 07:47:48.516643+00	2	Intel	\N
1705c0a5-a3b4-4040-981c-f65ac0617104	Core i5-9600K	6	3.7 to 4.6 GHz	LGA 1151	14 nm	9MB	95	2018-10-19	2022-03-08 15:05:33.875651+00	2022-06-01 07:48:01.727423+00	2	Intel	\N
f48426a2-72fd-4b05-b0f6-1c20f2b83b05	Core i7-8086K	6 / 12	4 to 5 GHz	LGA 1151	14 nm	12MB	95	2018-06-05	2022-03-11 13:19:28.039025+00	2022-06-01 11:22:20.012026+00	3	Intel	\N
59eadcbf-11ae-442f-b6da-2d17845dce83	Core i7-8670T	6 / 12	2.3 to 3.7 GHz	LGA 1151	14 nm	12MB	35	2018-09-01	2022-03-11 13:21:03.322562+00	2022-06-01 11:22:34.676568+00	3	Intel	\N
ac426bfb-460b-444f-981b-dcfdfff9e55e	Core i7-8700T	6 / 12	2.4 to 4 GHz	LGA 1151	14 nm	12MB	35	2018-04-02	2022-03-11 13:22:46.339664+00	2022-06-01 11:22:46.738625+00	3	Intel	\N
47ab876b-b53a-42ee-9177-58666e506562	Core i7-9700K	8	3.6 to 4.9 GHz	LGA 1151	14 nm	12MB	95	2018-10-19	2022-03-11 13:23:29.922709+00	2022-06-01 11:23:01.505751+00	3	Intel	\N
a0ad10f3-28c5-4d64-8d4f-74ad53b4ad81	Core i9-9900X	10 / 20	3.5 to 4.5 GHz	LGA 2066	14 nm	19.25MB	165	2018-10-19	2022-03-11 13:29:19.61321+00	2022-06-02 15:37:44.009597+00	4	Intel	\N
c159c278-b303-4ee4-a5f0-4d9a5841d24d	Core i9-9940X	14/ 28	3.3 to 4.5 GHz	LGA 2066	14 nm	19.25MB	165	2018-10-19	2022-03-11 13:31:04.631544+00	2022-06-02 15:38:15.234299+00	4	Intel	\N
691b22a7-96dd-4e3b-b277-f869b8beffaf	Core i9-9960X	16 / 32	3.1 to 4.5 GHz	LGA 2066	14 nm	22MB	165	2018-10-19	2022-03-11 13:31:53.221099+00	2022-06-02 15:38:30.206095+00	4	Intel	\N
e4cc22cf-7597-414b-ab8d-bae0e9c048df	Core i9-9900	8 / 16	3.1 to 5 GHz	LGA 1151	14 nm	16MB	65	2019-04-23	2022-03-11 14:23:18.771416+00	2022-06-02 15:38:45.468184+00	4	Intel	\N
d46babe0-3b28-4e81-8056-ad1540f119c4	Core i3-9320	4	3.7 to 4.4 GHz	LGA 1151	14 nm	8MB	62	2019-04-23	2022-03-11 13:36:31.412511+00	2022-06-01 11:35:56.310166+00	1	Intel	\N
2a6dbecb-2a6d-48af-8523-261a981a0457	Core i3-9300	4	3.7 to 4.3 GHz	LGA 1151	14 nm	8MB	62	2019-04-23	2022-03-11 13:35:44.221741+00	2022-06-01 11:35:44.879985+00	1	Intel	\N
7fa218f4-9106-454e-b31e-f9019d32ea72	Core i3-9350K	4	4 to 4.6 GHz	LGA 1151	14 nm	8MB	91	2019-04-23	2022-03-11 13:37:00.887806+00	2022-06-01 11:38:29.401655+00	1	Intel	\N
e95357b3-ea60-4448-a6f8-faa9e58cb59c	Core i7-8670	6 / 12	3.1 to 4.4 GHz	LGA 1151	14 nm	12MB	65	2018-01-01	2022-03-11 13:20:05.830205+00	2022-03-17 06:50:41.488604+00	\N	Intel	\N
fba101af-3b6c-4979-9bb7-d499733c8e92	Core i3-9350KF	4	4 to 4.6 GHz	LGA 1151	14 nm	8MB	91	2018-01-08	2022-03-11 13:38:10.218405+00	2022-06-01 11:38:44.470037+00	1	Intel	\N
8224ccf1-0efe-485c-b734-e57a81031eb6	Core i7-8700	6 / 12	3.2 to 4.6 GHz	LGA 1151	14 nm	12MB	65	2018-01-01	2022-03-11 13:21:37.701769+00	2022-03-17 06:50:41.856044+00	\N	Intel	\N
f9c923d5-2a49-4a21-9a8f-72efa0e29d39	Core i5-9500F	6	3 to 4.4 GHz	LGA 1151	14 nm	9MB	65	2019-04-23	2022-03-11 13:40:25.569785+00	2022-06-01 11:39:18.58055+00	2	Intel	\N
4d22cb33-6840-4aaf-b9e6-47764d6b1162	Core i5-9600KF	6	3.7 to 4.6 GHz	LGA 1151	14 nm	9MB	95	2019-01-08	2022-03-11 13:41:06.191844+00	2022-06-01 11:40:29.231913+00	2	Intel	\N
3b9bf666-b1de-4368-b13c-04001a27f538	Core i7-9700	8	3 to 4.7 GHz	LGA 1151	14 nm	12MB	65	2019-04-23	2022-03-11 13:41:40.353948+00	2022-06-01 11:40:52.968601+00	3	Intel	\N
5a362a97-896f-4fad-bb25-138ec8ed4571	Core i7-9700F	8	3 to 4.7 GHz	LGA 1151	14 nm	12MB	65	2019-04-23	2022-03-11 13:42:08.779847+00	2022-06-01 11:41:06.100493+00	3	Intel	\N
90b8404a-5580-45b7-b5c3-263fe3e53fff	Core i7-9700KF	8	3.6 to 4.9 GHz	LGA 1151	14 nm	12MB	95	2019-01-08	2022-03-11 13:43:21.505347+00	2022-06-01 11:41:17.665079+00	3	Intel	\N
7d1e7179-1821-4541-b577-8e88105b68d4	Core i9-9900KF	8 / 16	3.6 to 5 GHz	LGA 1151	14 nm	16MB	95	2019-01-08	2022-03-11 14:24:12.419567+00	2022-06-02 15:38:59.648178+00	4	Intel	\N
7b0df12a-de66-46e7-85a7-bf6de1907e31	Core i9-9900KS	8 / 16	4 to 5 GHz	LGA 1151	14 nm	16MB	127	2019-10-28	2022-03-11 14:25:11.6668+00	2022-06-02 15:39:14.569312+00	4	Intel	\N
fab81423-ac47-45a2-9b05-1303db1c14cd	Core i9-10920X	12 / 24	3.5 to 4.8 GHz	LGA 2066	14 nm	19.25MB	165	2019-10-19	2022-03-11 14:28:05.980204+00	2022-06-02 15:39:27.209749+00	4	Intel	\N
07b8103c-bbcd-4983-acc1-726ad47c7929	Core i9-10900X	10 / 20	3.7 to 4.7 GHz	LGA 2066	14 nm	19.25MB	165	2019-10-19	2022-03-11 14:27:17.144264+00	2022-06-02 15:39:40.688233+00	4	Intel	\N
88a6b713-4b68-48a5-9bbe-3911cabbeb57	Core i9-10940X	14 / 28	3.3 to 4.8 GHz	LGA 2066	14 nm	19.25MB	165	2019-10-19	2022-03-11 14:31:26.760973+00	2022-06-02 15:40:31.132265+00	4	Intel	\N
a54e256e-acf0-46c8-8e60-116fa47ff0dc	Core i9-10980XE	18 / 36	3 to 4.8 GHz	LGA 2066	14 nm	24.75MB	165	2019-10-19	2022-03-11 14:33:26.499915+00	2022-06-02 15:40:46.194872+00	4	Intel	\N
d81514dd-2f0e-41b1-a6e5-e408f8ff7ce7	Core i3-9100	4	3.6 GHz	LGA 1151	14 nm	6MB	65	2018-09-01	2022-03-08 14:34:44.095438+00	2022-06-26 15:59:41.629153+00	1	Intel	\N
9461c630-19af-4dc0-bf21-825d82ff1b01	Core i3-10300	4 / 8	3.7 to 4.4 GHz	LGA 1200	\t14 nm	8MB	62	2020-04-30	2022-03-11 14:36:46.576439+00	2022-06-01 12:16:04.479387+00	1	Intel	\N
79d7498b-5f6b-4684-bc1c-abc76f8c7b9f	Core i3-10100	4 / 8	3.6 to 4.3 GHz	LGA 1200	14 nm	6MB	65	2020-04-30	2022-03-11 14:36:07.233068+00	2022-06-01 12:16:18.801296+00	1	Intel	\N
544f1e10-2e8f-4079-9dd1-e773468ebcda	Core i9-9820X	10 / 20	3.3 to 4.2 GHz	LGA 2066	14 nm	16.5MB	165	2018-10-19	2022-03-11 13:28:40.607313+00	2022-06-02 15:35:54.39217+00	4	Intel	\N
cc14bf28-4a73-442f-884e-8742371f720e	Pentium Gold G5500	2 / 4	3.8 GHz	LGA 1151	14 nm	4MB	51	2018-04-02	2022-03-11 13:25:46.31287+00	2022-03-17 06:51:33.930292+00	\N	Intel	\N
b658985f-c4f5-4372-b836-5e4a4ac41d73	Pentium Gold G5600	2 / 4	3.9 GHz	LGA 1151	14 nm	4MB	51	2018-04-02	2022-03-11 13:26:39.883054+00	2022-03-17 06:51:34.116194+00	\N	Intel	\N
56b58f08-16f3-47de-a7c9-49d14bd3f667	Celeron G5900	2	3.4 GHz	LGA 1200	14 nm	2MB	58	2020-04-30	2022-03-11 14:34:30.253665+00	2022-03-17 06:53:08.14971+00	\N	Intel	\N
1ff71637-b831-4ac0-a247-86eb01902889	Celeron G5920	2	3.5 GHz	LGA 1200	14 nm	2MB	58	2020-04-30	2022-03-11 14:35:20.252296+00	2022-03-17 06:53:08.333549+00	\N	Intel	\N
c3ab527d-786d-4674-8e89-d593744caf0e	Core i3-10105F	4 / 8	3.7 to 4.4 GHz	LGA 1200	14 nm	6MB	65	2021-03-16	2022-03-11 15:01:04.53004+00	2022-06-01 12:16:35.451267+00	1	Intel	\N
03bf5a1a-acd2-4cfc-8a19-88a126dc148c	Core i3-10105T	4 / 8	3 to 3.9 GHz	LGA 1200	14 nm	6MB	35	2021-03-16	2022-03-11 15:01:38.574544+00	2022-06-01 12:16:51.037815+00	1	Intel	\N
ce04f119-5220-487c-ab02-248eb82227f9	Core i5-10400	6 / 12	2.9 to 4.3 GHz	LGA 1200	14 nm	12MB	65	2020-04-30	2022-03-11 14:38:51.489384+00	2022-06-01 12:17:05.658497+00	2	Intel	\N
4e791b4c-4d6c-4981-a02f-32e89680bd0d	Core i5-10400F	6 / 12	2.9 to 4.3 GHz	LGA 1200	14 nm	12MB	65	2020-04-30	2022-03-11 14:39:32.27508+00	2022-06-01 12:17:57.36293+00	2	Intel	\N
c2ff6453-c5f2-40d3-a3c8-e607aef37675	Core i5-10500	6 / 12	3.1 to 4.5 GHz	LGA 1200	14 nm	12MB	65	2020-04-30	2022-03-11 14:40:04.502806+00	2022-06-01 12:18:12.693114+00	2	Intel	\N
cac27627-7f0c-454a-9474-7ce4a6301786	Core i7-11700K	8 / 16	3.6 to 5 GHz	LGA 1200	14 nm	16MB	125	2021-03-16	2022-03-12 15:05:16.674799+00	2022-06-01 12:24:33.706581+00	3	Intel	\N
dec4612a-9926-45a9-b400-46ce2eaa892f	Core i5-10600	6 / 12	3.3 to 4.8 GHz	LGA 1200	14 nm	12MB	65	2020-04-30	2022-03-11 14:41:01.436152+00	2022-06-01 12:24:45.725563+00	2	Intel	\N
9a54db86-a6d0-432d-bcff-d5a078a2d306	Pentium Gold G6600	2 / 4	4.2 GHz	LGA 1200	14 nm	4MB	58	2020-04-30	2022-03-11 14:56:07.161887+00	2022-03-17 06:51:34.851138+00	\N	Intel	\N
71a21837-b9b4-44ab-9da5-00c90f4fe4e9	Pentium Gold G6405T	2 / 4	3.5 GHz	LGA 1200	14 nm	4MB	35	2021-03-16	2022-03-12 15:49:32.525471+00	2022-03-17 06:51:35.221339+00	\N	Intel	\N
859587f7-5171-4d0a-ac59-916839da4d8e	Pentium Gold G6505	2 / 4	4.2 GHz	LGA 1200	14 nm	4MB	65	2021-03-16	2022-03-12 15:50:16.839354+00	2022-03-17 06:51:35.405556+00	\N	Intel	\N
af8e73cf-5837-4067-81be-ae8139106831	Core i3-10320	4 / 8	3.8 to 4.6 GHz\t	LGA 1200	14 nm	8MB	91	2020-04-30	2022-03-11 14:37:37.34566+00	2022-06-01 12:24:57.818447+00	1	Intel	\N
21a4c4d7-e970-4b25-b27b-6fd93f31ed87	Core i9-10850K	10 / 20	3.6 to 5.2 GHz	LGA 1200	14 nm	20MB	125	2020-07-27	2022-03-11 14:48:03.773667+00	2022-06-02 15:41:13.49037+00	4	Intel	\N
043753d7-fa9e-431d-bf02-b1fb3ed3b4aa	Core i3-10350K	4 / 8	4.1 to 4.8 GHz	LGA 1200	14 nm	8MB	91	2020-04-30	2022-03-11 14:38:18.066034+00	2022-06-01 12:25:22.203165+00	1	Intel	\N
2941fd93-c32a-4147-8660-0b2a52a26cf7	Core i3-10305T	4 / 8	3 to 4 GHz	LGA 1200	14 nm	8MB	35	2021-03-16	2022-03-12 14:49:02.953084+00	2022-06-01 12:25:35.062853+00	1	Intel	\N
642a0b02-28bf-4b10-b82f-f6fed65fd5f6	Core i3-10305	4 / 8	3.8 to 4.5 GHz	LGA 1200	14 nm	8MB	65	2021-03-16	2022-03-12 14:47:57.802327+00	2022-06-01 12:25:47.06407+00	1	Intel	\N
ecdbe30f-467f-43a1-828a-3a18b8454500	Core i3-10325	4 / 8	3.9 to 4.7 GHz\t	LGA 1200	14 nm	8MB	65	2021-03-16	2022-03-12 14:51:33.678641+00	2022-06-01 12:29:44.952541+00	1	Intel	\N
e454fd8e-948c-4f27-ade4-5ec252bc4880	Core i5-11400F	6 / 12	2.6 to 4.4 GHz	LGA 1200	14 nm	12MB	65	2021-03-16	2022-03-12 14:55:57.830645+00	2022-06-01 12:30:00.064128+00	2	Intel	\N
693193cd-0851-4e52-a92d-2776ad18f777	Core i7-10700	8 / 16	2.9 to 4.8 GHz	LGA 1200	14 nm	16MB	65	2020-04-30	2022-03-11 14:43:21.513103+00	2022-06-01 12:30:15.394434+00	3	Intel	\N
5992c1ad-20b1-4b24-81bb-7ffd4dbaf8f3	Core i7-10700KF	8 / 16	3.8 to 5.1 GHz	LGA 1200	14 nm	16MB	125	2020-04-30	2022-03-11 14:45:36.847471+00	2022-06-01 12:30:39.038682+00	3	Intel	\N
84a773e7-1ec0-46a7-b6f0-7bfc522e8a61	Core i9-10900	10 / 20	2.8 to 5.2 GHz	LGA 1200	14 nm	20MB	65	2020-04-30	2022-03-11 14:49:18.183469+00	2022-06-02 15:41:29.894256+00	4	Intel	\N
18899a96-ac6d-4f52-85f8-aab8a5fd2d8e	Core i9-10900KF	10 / 20	3.7 to 5.3 GHz	LGA 1200	14 nm	20MB	125	2020-04-30	2022-03-11 14:52:43.09161+00	2022-06-02 15:41:48.843421+00	4	Intel	\N
796c5f61-6466-4671-b3c4-4f9ee7bc4ae6	Core i9-11900	8 / 16 	2.5 to 5.2 GHz	LGA 1200	14 nm	16MB	65	2021-03-16	2022-03-12 15:44:42.897454+00	2022-06-02 15:42:07.864321+00	4	Intel	\N
0ef2e45c-f4da-4f44-b8da-47293162ad9b	Core i3-10105	4 / 8	3.7 to 4.4 GHz	LGA 1200	14 nm	6MB	65	2021-03-16	2022-03-11 15:00:32.983687+00	2022-06-01 12:31:35.594465+00	1	Intel	\N
58b08999-3f96-48cf-b2db-f0350343abca	Core i5-10600KF	6 / 12	4.1 to 4.8 GHz	LGA 1200	14 nm	12MB	95	2020-04-30	2022-03-11 14:42:27.596323+00	2022-06-01 12:31:47.798751+00	2	Intel	\N
f386038e-931c-4fbf-97a5-3d01f82f596c	Core i7-10700F	8 / 16	2.9 to 4.8 GHz	LGA 1200	14 nm	16MB	65	2020-04-30	2022-03-11 14:44:12.142176+00	2022-06-01 12:32:01.212022+00	3	Intel	\N
3e49f395-e6ed-4611-ad75-56e6c7ff4c8e	Core i5-11400T	6 / 12	1.3 to 3.7 GHz	LGA 1200	14 nm	12MB	35	2021-03-16	2022-03-12 14:56:39.274612+00	2022-06-01 12:50:52.863312+00	2	Intel	\N
550c30b1-d384-4f9e-8828-a8034503be72	Core i5-11500T	6 / 12	1.5 to 3.9 GHz	LGA 1200	14 nm	12MB	35	2021-03-16	2022-03-12 14:59:05.24966+00	2022-06-01 12:51:04.176307+00	2	Intel	\N
65749fa7-357b-441e-924b-f6dcbbfac967	Core i5-11600	6 / 12	2.8 to 4.8 GHz	LGA 1200	14 nm	12MB	65	2021-03-16	2022-03-12 14:59:56.164206+00	2022-06-01 12:51:48.497029+00	2	Intel	\N
184ad42c-39af-4be1-a8a9-bc14d799cf02	Core i5-11600K	6 / 12	3.9 to 4.9 GHz	LGA 1200	14 nm	12MB	125	2021-03-16	2022-03-12 15:00:38.701172+00	2022-06-01 12:52:06.450013+00	2	Intel	\N
26eaef1a-f50d-467e-ba64-148f56f4714e	Core i5-11600KF	6 / 12	3.9 to 4.9 GHz	LGA 1200	14 nm	12MB	125	2021-03-16	2022-03-12 15:01:26.821046+00	2022-06-01 12:53:08.456228+00	2	Intel	\N
6f027b1e-fb28-4000-8028-1a9a87556da0	Core i7-11700	8 / 16	2.5 to 4.9 GHz	LGA 1200	14 nm	16MB	65	2021-03-16	2022-03-12 15:03:25.495535+00	2022-06-01 12:53:21.220678+00	3	Intel	\N
bd4bb486-f70f-4c70-af73-bec79b7cb4cf	Core i7-11700F	8 / 16	2.5 to 4.9 GHz	LGA 1200	14 nm	16MB	65	2021-03-16	2022-03-12 15:04:40.664302+00	2022-06-01 12:53:56.863874+00	3	Intel	\N
c539ecdc-5fd6-484e-8f7f-1de8081c7ba1	Core i7-11700KF	8 / 16	3.6 to 5 GHz	LGA 1200	14 nm	16MB	125	2021-03-16	2022-03-12 15:06:16.737593+00	2022-06-01 12:54:20.242761+00	3	Intel	\N
3dc22ef6-830d-4326-b826-0b7f0b36d707	Core i7-11700T	8 / 16	1.4 to 4.6 GHz	LGA 1200	14 nm	16MB	35	2021-03-16	2022-03-12 15:06:53.325053+00	2022-06-01 12:54:41.130045+00	3	Intel	\N
1eef9ff6-f909-4e35-aa31-f6cb9dc71607	Core i9-11900K	8 / 16	3.5 to 5.3 GHz	LGA 1200	14 nm	16MB	125	2021-03-16	2022-03-12 15:45:52.414892+00	2022-06-02 15:42:22.768431+00	4	Intel	\N
64efe370-722d-4026-8ac4-818ac9ab1835	Core i9-11900F	8 / 16	2.5 to 5.2 GHz	LGA 1200	14 nm	16MB	65	2021-03-16	2022-03-12 15:45:16.867449+00	2022-06-02 15:42:40.148079+00	4	Intel	\N
7226b06d-55fe-4ae0-8ef8-d9b4e054af50	Core i9-11900KF	8 / 16	3.5 to 5.3 GHz\t	LGA 1200	14 nm	16MB	125	2021-03-16	2022-03-12 15:46:31.564086+00	2022-06-02 15:46:24.772991+00	4	Intel	\N
f10e79c5-0eac-4524-af78-32cf7c7cbd66	Core i9-11900T	8 / 16	1.5 to 4.9 GHz	LGA 1200	14 nm\t	16MB	35	2021-03-16	2022-03-12 15:47:14.253018+00	2022-06-02 15:46:38.955024+00	4	Intel	\N
89e235d8-c24f-4de7-befa-4e80e8ea2872	Core i9-10900F	10 / 20	2.8 to 5.2 GHz	LGA 1200	14 nm	20MB	65	2020-04-30	2022-03-11 14:49:53.894722+00	2022-06-02 15:40:59.584523+00	4	Intel	\N
9a8063a0-abec-49b3-b609-24b126b985b8	Pentium Gold G6400	2 / 4	4 GHz	LGA 1200	14 nm	4MB	58	2020-04-30	2022-03-11 14:54:38.631623+00	2022-03-17 06:51:34.482812+00	\N	Intel	\N
c8fcd8d1-25a4-43cd-a0ea-76bd7e3404bb	Pentium Gold G6500	2 / 4	4.1 GHz	LGA 1200	14 nm	4MB	58	2020-04-30	2022-03-11 14:55:37.025579+00	2022-03-17 06:51:34.666967+00	\N	Intel	\N
2cad0b5f-83a2-4a8b-9b48-91888af5b7a6	FX-6330	6	3.6 to 4.2 GHz	AM3+	32 nm	8MB	125	2015-12-15	2022-03-12 15:55:29.808897+00	2022-03-17 06:53:08.518916+00	\N	AMD	\N
35e119d6-6543-481b-b19d-6d196c1e60a6	A10-7870K	4	3.9 to 4.1 GHz	FM2+	28 nm	N/A	95	2015-05-28	2022-03-12 15:56:21.844655+00	2022-03-17 06:53:08.70269+00	\N	AMD	\N
d7dc7f28-33b1-4181-b853-9c2b84feb195	A8-7650K	4	3.3 to 3.8 GHz	FM2+	28 nm	N/A	95	2015-01-07	2022-03-12 16:01:28.678346+00	2022-03-17 06:53:08.886735+00	\N	AMD	\N
9dfa51c8-2617-414c-ae86-d702c1085259	A8-7670K	4	3.6 to 3.9 GHz\t	FM2+	28 nm	N/A	95	2015-07-20	2022-03-12 16:02:30.512243+00	2022-03-17 06:53:09.072846+00	\N	AMD	\N
1ce79ddb-18d0-4d55-9592-4b9f82c51011	PRO A6-8550B	2	3.5 to 4 GHz	FM2+	28 nm	N/A	65	2015-09-29	2022-03-12 16:09:36.138515+00	2022-03-17 06:53:09.811376+00	\N	AMD	\N
87c37037-77a0-4d16-b434-268d71f6d2f9	PRO A8-8650B	4	3.2 to 3.9 GHz	FM2+	28 nm	N/A	65	2015-09-29	2022-03-12 16:10:00.939251+00	2022-03-17 06:53:09.996245+00	\N	AMD	\N
969d706c-4ebc-4f9e-884a-9ca7541d0315	A6-9500	2	3.5 to 3.8 GHz	AM4	28 nm	N/A	65	2016-09-05	2022-03-12 16:12:43.812126+00	2022-03-17 06:53:10.181511+00	\N	AMD	\N
0fbaef2c-0ffc-4543-856a-0c241762f255	A6-9500E	2	3 to 3.4 GHz	AM4	28 nm	N/A	35	2016-09-05	2022-03-12 16:13:12.599061+00	2022-03-17 06:53:10.364875+00	\N	AMD	\N
b1746879-9136-4768-80f4-a874cb851d0a	PRO A12-9800	4	3.8 to 4.2 GHz	AM4	28 nm	N/A	65	2016-10-03	2022-03-12 16:15:40.456403+00	2022-03-17 06:53:10.548202+00	\N	AMD	\N
0439f251-6342-4f72-9d67-2b5ccc418b13	PRO A6-9500	2	3.5 to 3.8 GHz	AM4	28 nm	N/A	65	2016-10-03	2022-03-12 16:16:22.621009+00	2022-03-17 06:53:10.731158+00	\N	AMD	\N
d8fd9b40-9433-4640-b8a4-6b8ebc8a3111	Ryzen 5 PRO 2600	6 / 12	3.4 to 3.9 GHz	AM4	12 nm	16MB	65	2018-09-19	2022-03-13 16:23:39.173273+00	2022-06-02 15:11:07.031882+00	2	AMD	\N
ddbb36ff-0d57-40e7-bbfa-07b24b867b2d	Ryzen 3 2200G	4	3.5 to 3.7 GHz	AM4	14 nm	4MB	65	2018-02-12	2022-03-13 16:15:58.093331+00	2022-06-02 14:50:39.541006+00	1	AMD	\N
e3a6aeb0-377a-4de8-bb85-e38122ef6d8d	Ryzen 5 2400G	4 / 8	3.6 to 3.9 GHz	AM4	14 nm	4MB	65	2018-02-12	2022-03-13 16:17:11.354777+00	2022-06-02 14:56:34.348433+00	2	AMD	\N
5318fa72-febe-4372-b491-cb6d1e937f0a	Ryzen 5 2500X	4 / 8	3.6 to 4 GHz	AM4	12 nm	16MB	65	2018-10-01	2022-03-13 16:17:44.461711+00	2022-06-02 14:59:51.084102+00	2	AMD	\N
d3413cdb-072c-4d39-a34e-8f7dd4559ae4	Ryzen 5 2600E	6 / 12	3.1 to 4 GHz	AM4	12 nm	16MB	65	2018-09-19	2022-03-13 16:21:46.214303+00	2022-06-02 15:00:06.535922+00	2	AMD	\N
a95af759-ce0c-4ffb-ab3a-ab15e68dc1df	Ryzen 5 2600X	6 / 12	3.6 to 4.25 GHz	AM4	12 nm	16MB	95	2018-04-19	2022-03-13 16:22:16.169819+00	2022-06-02 15:04:35.585269+00	2	AMD	\N
3192c010-5925-4301-9f8f-402950521151	Ryzen 5 PRO 2400G	4 / 8	3.6 to 3.9 GHz	AM4	14 nm	4MB	65	2018-05-10	2022-03-13 16:22:50.318799+00	2022-06-02 15:05:04.908016+00	2	AMD	\N
f733a33c-1dcb-456e-ade0-16a245bdbbb2	Ryzen 7 2700	8 / 16	3.2 to 4.1 GHz	AM4	12 nm	16MB	65	2018-04-19	2022-03-13 16:24:10.329085+00	2022-06-02 15:11:43.668973+00	3	AMD	\N
5ae18326-6eae-40ee-a006-8f479ef66ac6	Ryzen 7 2700E	8 / 16	2.8 to 4 GHz	AM4	12 nm	16MB	65	2018-09-19	2022-03-13 16:24:36.450807+00	2022-06-02 15:11:57.324036+00	3	AMD	\N
14b07cdb-4306-44c9-a15e-5fa36807753e	Ryzen 7 2700X	8 / 16	3.7 to 4.35 GHz	AM4	12 nm	16MB	105	2018-04-19	2022-03-13 16:25:09.841731+00	2022-06-02 15:12:10.299779+00	3	AMD	\N
77d54f55-07d7-463d-af62-fb833388bece	Ryzen 7 PRO 2700	8 / 16	3.2 to 4.1 GHz	AM4	12 nm	16MB	65	2018-09-19	2022-03-13 16:25:39.130098+00	2022-06-02 15:12:22.455574+00	3	AMD	\N
6ea566e8-83e1-4fc3-b24d-b9617409f178	Ryzen 3 2300X	4	3.5 to 4.0 GHz	AM4	14 nm	4MB	65	2018-08-01	2022-03-13 16:16:31.45274+00	2022-06-27 16:42:37.795007+00	1	AMD	\N
45a51911-cfad-4d74-9962-749289c7873e	Ryzen 7 PRO 2700X	8 / 16	3.7 to 4.1 GHz	AM4	12 nm	16MB	95	2018-09-19	2022-03-13 16:26:13.76925+00	2022-06-28 14:39:35.67162+00	3	AMD	\N
2d78a4bb-2463-4b9d-9464-b3f4d921a815	A10-7890K	4	4 to 4.3 GHz	FM2+	28 nm	N/A	95	2016-01-11	2022-03-13 03:21:15.230777+00	2022-03-17 06:53:11.472605+00	\N	AMD	\N
fa803502-349f-4ba4-9dcb-43184b82b97e	A6-7470K	2	3.7 to 4 GHz	FM2+	28 nm	N/A	65	2016-02-02	2022-03-13 03:21:55.014737+00	2022-03-17 06:53:11.656883+00	\N	AMD	\N
c31f1bff-aaa7-4b7c-a49c-f8e21fe0356d	Athlon X4 845	4	3.5 to 3.8 GHz	FM2+	28 nm	N/A	65	2016-02-02	2022-03-13 03:23:13.509697+00	2022-03-17 06:53:11.839625+00	\N	AMD	\N
af57959e-c7a8-4aed-bada-a78b694d2879	A10-9700	4	3.5 to 3.8 GHz	AM4	28 nm	N/A	65	2017-07-27	2022-03-13 03:25:33.332681+00	2022-03-17 06:53:12.023954+00	\N	AMD	\N
7bf0c273-14a1-4820-b4e7-da670941f542	A10-9700E	4	3 to 3.5 GHz	AM4	28 nm	N/A	35	2017-07-27	2022-03-13 03:27:04.819467+00	2022-03-17 06:53:12.207148+00	\N	AMD	\N
2c09c2c0-2cb9-4737-a9da-8b4f2754095d	A12-9800	4	3.8 to 4.2 GHz	AM4	28 nm	N/A	65	2017-07-27	2022-03-13 03:27:42.104749+00	2022-03-17 06:53:12.390766+00	\N	AMD	\N
4c3e455b-9687-4312-85f6-761ccc930acb	A12-9800E	4	3.1 to 3.8 GHz	AM4	28 nm	N/A	35	2017-07-27	2022-03-13 03:28:42.367578+00	2022-03-17 06:53:12.574369+00	\N	AMD	\N
3e717bf0-1097-4e10-95c0-6ab3730b2b27	A6-9550	2	3.8 to 4 GHz	AM4	28 nm	N/A	65	2017-07-27	2022-03-13 03:29:10.568639+00	2022-03-17 06:53:12.757762+00	\N	AMD	\N
a902b170-8e55-4e5a-a49c-e8d696379bb4	A8-9600	4	3.1 to 3.4 GHz	AM4	28 nm	N/A	65	2017-07-27	2022-03-13 03:29:43.179981+00	2022-03-17 06:53:12.945537+00	\N	AMD	\N
ffeaa6d1-159e-475d-927d-a76a958a99b7	Athlon X4 950	4	3.5 to 3.8 GHz	AM4	28 nm	N/A	65	2017-07-27	2022-03-13 03:30:46.760162+00	2022-03-17 06:53:13.312626+00	\N	AMD	\N
7acabd03-b540-4105-9638-5cc98e249971	Athlon X4 970	4	3.8 to 4 GHz	AM4	28 nm	N/A	65	2017-07-27	2022-03-13 03:31:17.839104+00	2022-03-17 06:53:13.498191+00	\N	AMD	\N
8a9dc963-2b68-452f-af23-f80ecf26eb4c	Ryzen 3 1200	4	3.1 to 3.4 GHz	AM4	14 nm	8MB	65	2017-07-27	2022-03-13 03:32:30.424613+00	2022-03-17 06:53:13.86572+00	\N	AMD	\N
6c2fcbaa-4632-495a-a860-4b9545d6e214	Ryzen 3 1300	4	3.2 to 3.5 GHz	AM4	14 nm	8MB	65	2017-04-11	2022-03-13 11:41:06.694002+00	2022-03-17 06:53:14.04977+00	\N	AMD	\N
53f7760b-f367-4513-a50e-366d2eb53f36	Ryzen 3 1300X	4	3.4 to 3.7 GHz	AM4	14 nm	8MB	65	2017-07-27	2022-03-13 11:43:13.654239+00	2022-03-17 06:53:14.233455+00	\N	AMD	\N
f3fc943d-f800-4790-915e-cc3e12607865	Ryzen 3 PRO 1200	4	3.1 to 3.4 GHz	AM4	14 nm	8MB	65	2017-06-29	2022-03-13 11:45:28.120516+00	2022-03-17 06:53:14.417735+00	\N	AMD	\N
43ea0367-991b-4918-9448-92b946029248	Ryzen 5 1400	4 / 8	3.2 to 3.4 GHz	AM4	14 nm	8MB	65	2017-04-11	2022-03-13 11:46:40.264452+00	2022-03-17 06:53:14.786297+00	\N	AMD	\N
d1c06894-ab8b-4d17-944e-a17c44996e01	Ryzen 5 1500X	4 / 8	3.5 to 3.7 GHz\t	AM4	14 nm	16MB	65	2017-04-11	2022-03-13 11:47:11.455639+00	2022-03-17 06:53:14.970994+00	\N	AMD	\N
c536f9b8-2d30-44c2-a9f7-81f3cdddc5c2	Ryzen 5 1600	6 / 12	3.2 to 3.6 GHz	AM4	14 nm	16MB	65	2017-04-11	2022-03-13 11:47:49.487804+00	2022-03-17 06:53:15.157967+00	\N	AMD	\N
076fe002-8bde-462a-83ce-cb645669a063	Ryzen 5 1600X	6 / 12	3.6 to 4 GHz	AM4	14 nm	16MB	95	2017-04-11	2022-03-13 11:48:19.063355+00	2022-03-17 06:53:15.343522+00	\N	AMD	\N
9245a57b-4516-400a-80a9-aa1fe77c908d	Ryzen 5 PRO 1500	4 / 8	3.5 to 3.7 GHz	AM4	14 nm	16MB	65	2017-06-29	2022-03-13 11:51:49.362708+00	2022-03-17 06:53:15.526789+00	\N	AMD	\N
bcfecd14-9b45-49dd-a900-ede3242367d9	Ryzen 5 PRO 1600	6 / 12	3.2 to 3.6 GHz	AM4	14 nm	16MB	65	2017-06-29	2022-03-13 11:52:21.818979+00	2022-03-17 06:53:15.711104+00	\N	AMD	\N
06f230ac-a2dc-40de-805b-9b5012b8bd8b	Ryzen 7 1700	8 / 16	3 to 3.7 GHz	AM4	14 nm	16MB	65	2017-03-02	2022-03-13 11:53:04.450192+00	2022-03-17 06:53:15.894976+00	\N	AMD	\N
5b0c089a-935a-4722-ac54-07c113ac74fb	Ryzen 7 1700X	8 / 16	3.4 to 3.8 GHz	AM4	14 nm	16MB	95	2017-03-02	2022-03-13 11:53:37.652807+00	2022-03-17 06:53:16.078727+00	\N	AMD	\N
8fa7ffa7-286b-4f90-a24a-c418f2840a59	Ryzen 7 1800X	8 / 16	3.6 to 4 GHz	AM4	14 nm	16MB	95	2017-03-02	2022-03-13 11:54:13.833159+00	2022-03-17 06:53:16.263434+00	\N	AMD	\N
ff430ba7-495b-4312-bf85-e453e70f095a	Ryzen 7 PRO 1700	8 / 16	3 to 3.7 GHz	AM4	14 nm	16MB	65	2017-06-29	2022-03-13 11:54:56.917813+00	2022-03-17 06:53:16.447226+00	\N	AMD	\N
bf90bd04-83eb-4374-90f2-5ab94d999cae	Ryzen 7 PRO 1700X	8 / 16	3.4 to 3.8 GHz	AM4	14 nm	16MB	95	2017-06-29	2022-03-13 11:55:29.276093+00	2022-03-17 06:53:16.631461+00	\N	AMD	\N
f07c57a9-dbdb-42cd-8d80-a92ce01f94da	Athlon 240GE	2 / 4	3.5 GHz	AM4	14 nm	4MB	35	2018-12-21	2022-03-13 16:13:52.591445+00	2022-03-17 06:53:19.400699+00	\N	AMD	\N
588f9fa2-4451-4f4e-95d7-9f2056ce1b78	Athlon PRO 200GE	2	3.2 GHz	AM4	14 nm	4MB	35	2018-06-01	2022-03-13 16:14:32.480491+00	2022-03-17 06:53:19.58667+00	\N	AMD	\N
ec333751-4ab4-4825-ab79-5fbb28608322	PRO A6-8570	2	3.5 to 3.8 GHz	AM4	28 nm	N/A	65	2018-10-01	2022-03-14 16:10:04.475902+00	2022-03-17 06:53:22.346948+00	\N	AMD	\N
a49f9eba-8a5e-410b-91cc-83337f433279	PRO A6-8570E	2	3 to 3.4 GHz	AM4	28 nm	N/A	65	2018-10-01	2022-03-14 16:10:40.527874+00	2022-03-17 06:53:22.531296+00	\N	AMD	\N
9df23c33-12a8-4312-a31c-3642ffaa6edc	A6-7480	2	3.5 to 3.8 GHz	FM2+	28 nm	N/A	45	2018-10-26	2022-03-14 16:12:00.885777+00	2022-03-17 06:53:22.715765+00	\N	AMD	\N
e8b78cb2-6128-40ad-9293-a693f95fa8bb	A6-9400	2	3.4 to 3.7 GHz	AM4	28 nm	N/A	65	2019-03-16	2022-03-15 13:24:30.637753+00	2022-03-17 06:53:23.449514+00	\N	AMD	\N
7aba02e4-1808-4c47-a5c8-7efa0ef1d0f7	Ryzen 3 3200G	4	3.6 to 4 GHz	AM4	12 nm	4MB	65	2019-07-07	2022-03-15 13:25:49.021496+00	2022-06-02 15:14:45.620031+00	1	AMD	\N
311e2945-6b04-499c-9b65-065583e0ec45	Ryzen 5 3500X	6	3.6 to 4.1 GHz	AM4	7 nm	32MB	65	2019-09-24	2022-03-15 13:28:33.24081+00	2022-06-02 15:14:58.253343+00	2	AMD	\N
61f064f8-5bde-49fd-adfc-8f52c55a0c2b	Ryzen 5 3600	6 / 12	3.6 to 4.2 GHz	AM4	7 nm	32MB	65	2019-07-07	2022-03-15 13:29:06.395928+00	2022-06-02 15:15:14.792107+00	2	AMD	\N
788b55c3-dcf0-4679-a8eb-ef919b6551e8	Ryzen 5 3600X	6 / 12	3.8 to 4.4 GHz	AM4	7 nm	32MB	95	2019-07-07	2022-03-15 13:29:36.206466+00	2022-06-02 15:15:34.634188+00	2	AMD	\N
586970e7-7f52-4032-af47-47a4366f7db1	Ryzen 5 3600XT	6 / 12	3.8 to 4.5 GHz	AM4	7 nm	32MB	95	2019-07-07	2022-03-15 13:30:02.773364+00	2022-06-02 15:15:47.263499+00	2	AMD	\N
4dbed1ae-13cf-4593-a2ff-4d74b903138e	Ryzen 7 2700X 50th Anniversary	8 / 16	3.7 to 4.35 GHz	AM4	12 nm	16MB	105	2019-04-29	2022-03-15 13:31:03.025461+00	2022-06-02 15:16:06.800749+00	3	AMD	\N
30c1a091-834e-4091-b9e1-5d0add666f85	Ryzen 7 3800X	8 / 16	3.9 to 4.5 GHz	AM4	7 nm	32MB	105	2019-07-07	2022-03-15 13:32:05.672254+00	2022-06-02 15:16:20.073984+00	3	AMD	\N
083880ca-ee30-4e2a-998d-b55592ae6da6	Ryzen 9 3900X	12 / 24	3.8 to 4.6 GHz	AM4	7 nm	64MB	105	2019-07-07	2022-03-15 13:32:41.152406+00	2022-06-02 15:16:32.192243+00	4	AMD	\N
4c7e344c-11b6-4863-afe3-d259e4bc36a1	Ryzen 9 3950X	16 / 32	3.5 to 4.7 GHz	AM4	7 nm	64MB	105	2019-11-25	2022-03-15 13:33:08.422311+00	2022-06-02 15:18:07.254316+00	4	AMD	\N
61bef273-0e3a-4715-a2e2-236a3771d996	Ryzen 7 3700X	8 / 16	3.6 to 4.4 GHz	AM4	7 nm	32MB	65	2019-07-07	2022-03-15 13:31:35.238016+00	2022-06-02 15:18:23.283938+00	3	AMD	\N
f2b52e19-da2d-4245-98aa-92d036cf07a1	Ryzen 3 3100	4 / 8	3.6 to 3.9 GHz	AM4	7 nm	16MB	65	2020-04-24	2022-03-15 17:29:06.594953+00	2022-06-02 15:18:40.268006+00	1	AMD	\N
03931f95-8e78-44eb-82f6-4cbea59f4311	Ryzen 3 3300X	4 / 8	3.8 to 4.3 GHz	AM4	7 nm	16MB	65	2020-04-24	2022-03-15 17:29:42.540755+00	2022-06-02 15:19:09.485319+00	1	AMD	\N
60ae6630-3cdb-4277-bc0f-a6ecba7016f8	Ryzen 3 4300G	4 / 8	3.8 to 4 GHz	AM4	7 nm	4MB	65	2020-07-21	2022-03-15 17:30:08.975103+00	2022-06-02 15:19:23.88812+00	1	AMD	\N
bfccbcff-d082-4699-948a-480e2df6f654	Ryzen 3 4300GE	4/ 8	3.5 to 4 GHz	AM4	7 nm	4MB	35	2020-07-21	2022-03-15 17:30:59.489994+00	2022-06-02 15:19:37.758322+00	1	AMD	\N
1b6aff4c-0773-4978-9c17-8669a32e4992	Ryzen 3 PRO 4350G	4 / 8	3.8 to 4 GHz	AM4	7 nm	4MB	65	2020-07-21	2022-03-15 17:31:26.155281+00	2022-06-02 15:19:51.215288+00	1	AMD	\N
73362a53-068d-400e-aaf4-d148eb27e679	Ryzen 5 4600G	6 / 12	3.7 to 4.2 GHz\t	AM4	7 nm	8MB	65	2020-07-21	2022-03-15 17:32:47.212791+00	2022-06-02 15:20:24.452044+00	2	AMD	\N
073791cf-4a50-4e78-9663-4d24bbe18f07	Ryzen 5 4600GE	6 / 12	3.3 to 4.2 GHz	AM4	7 nm	8MB	35	2020-07-21	2022-03-15 17:33:40.185251+00	2022-06-02 15:20:43.433753+00	2	AMD	\N
7afe602d-7cfb-475f-8537-8b14cd313035	Ryzen 5 5600X	6 / 12	3.7 to 4.6 GHz	AM4	7 nm	32MB	65	2020-11-05	2022-03-15 17:34:24.60977+00	2022-06-02 15:21:01.832802+00	2	AMD	\N
701716c4-52e7-4f51-90ab-f1f361368594	Ryzen 5 PRO 4650G	6 / 12	3.7 to 4.2 GHz	AM4	7 nm	8MB	65	2020-07-21	2022-03-15 17:34:57.258633+00	2022-06-02 15:24:19.765899+00	2	AMD	\N
dc5e1b17-b185-4db0-9201-60a690ac6cd3	Ryzen 5 PRO 4650GE	6 / 12	3.3 to 4.2 GHz	AM4	7 nm	8MB	35	2020-07-21	2022-03-15 17:35:41.746916+00	2022-06-02 15:24:33.32304+00	2	AMD	\N
232ae596-71a6-4be6-89e6-7e902e419dc4	Ryzen 7 3800XT	8 / 16	3.8 to 4.7 GHz	AM4	7 nm	32MB	105	2020-07-07	2022-03-15 17:36:28.154778+00	2022-06-02 15:24:50.156052+00	3	AMD	\N
7357400b-64c1-4691-aca8-0147715b4eae	Ryzen 7 4700G	8 / 16	3.6 to 4.4 GHz	AM4	7 nm	8MB	65	2020-07-21	2022-03-15 17:37:07.4506+00	2022-06-02 15:25:23.555405+00	3	AMD	\N
ecc517c4-5a48-4eb1-b36c-57b12f7c314b	Ryzen 7 4700GE	8 / 16	3.1 to 4.3 GHz	AM4	7 nm	8MB	35	2020-07-21	2022-03-15 17:37:33.340833+00	2022-06-02 15:25:52.50808+00	3	AMD	\N
47f9065f-c191-4f7a-8fe0-e7dba01f6f13	Ryzen 7 5800X	8 / 16	3.8 to 4.7 GHz	AM4	7 nm	32MB	105	2020-11-05	2022-03-15 17:38:28.249019+00	2022-06-02 15:28:49.670334+00	3	AMD	\N
dc0f1958-4695-4307-ac7f-980db5ce2e3c	Ryzen 7 PRO 4750G	8 / 16	3.6 to 4.4 GHz	AM4	7 nm	8MB	65	2020-07-21	2022-03-15 17:38:54.46107+00	2022-06-02 15:29:04.353859+00	3	AMD	\N
f8e56ce4-4d08-4a6f-86c3-6841d4f05ef0	Ryzen 7 PRO 4750GE	8 / 16	3.1 to 4.3 GHz	AM4	7 nm	8MB	35	2020-07-21	2022-03-15 17:39:50.897715+00	2022-06-02 15:29:17.224082+00	3	AMD	\N
11f25fc4-f6e0-4186-b45d-3b26be0dcbd2	Ryzen 9 3900XT	12 / 24	3.9 to 4.7 GHz	AM4	7 nm	64MB	105	2020-07-07	2022-03-15 17:40:20.3352+00	2022-06-02 15:29:32.804257+00	4	AMD	\N
736f86fd-24fd-48ca-b6d0-4e4bcf5aff55	Ryzen 9 5900X	12 / 24	3.7 to 4.8 GHz	AM4	7 nm	64MB	105	2020-11-05	2022-03-15 17:41:13.01657+00	2022-06-02 15:29:47.575178+00	4	AMD	\N
555b05a3-4f54-4d1c-a8b3-568323490a80	Ryzen 9 5950X	16 / 32	3.4 to 4.9 GHz	AM4	7 nm	64MB	105	2020-11-05	2022-03-15 17:41:44.212269+00	2022-06-02 15:30:01.876119+00	4	AMD	\N
1aa4b40a-b203-4181-aafc-a1829416a535	Ryzen 3 5300G	4 / 8	4 to 4.2 GHz	AM4	7 nm	8MB	65	2021-04-13	2022-03-16 13:13:30.019052+00	2022-06-02 15:30:47.812154+00	1	AMD	\N
6b284255-809c-4cae-b3ea-e948ba1e7237	Ryzen 3 PRO 4350GE	4 / 8	3.8 to 4 GHz	AM4	7 nm	4MB	35	2020-07-21	2022-03-15 17:32:17.370973+00	2022-06-28 15:20:10.122369+00	1	AMD	\N
fe718e07-fe43-4e12-8bba-3ec949efba97	Athlon Gold 3150G	4	3.5 to 3.9 GHz	AM4	12 nm	4MB	65	2020-07-21	2022-03-15 17:24:02.851623+00	2022-03-17 06:53:29.707627+00	\N	AMD	\N
24147a42-0be4-4f6b-bb46-cd4d24bad20a	Athlon Gold 3150GE	4	3.5 to 3.8 GHz	AM4	12 nm	4MB	35	2020-07-21	2022-03-15 17:25:39.341868+00	2022-03-17 06:53:29.892408+00	\N	AMD	\N
310f4936-6f6c-4b53-94a8-82c02d4fa462	Athlon Silver 3050GE	2 / 4	3.4 GHz	AM4	12 nm	4MB	35	2020-07-21	2022-03-15 17:27:58.484773+00	2022-03-17 06:53:30.449367+00	\N	AMD	\N
2f9697ff-ee51-4717-b19b-f3c92260f4ef	Athlon Silver PRO 3125GE	2 / 4	3.4 GHz	AM4	12 nm	4MB	35	2020-07-21	2022-03-15 17:28:25.752268+00	2022-03-17 06:53:30.632614+00	\N	AMD	\N
230d6f01-aca8-4ce5-a293-e99fcc18c545	Core i3-8020	4	3.7 GHz	LGA 1151	14 nm	6MB	65	2018-09-01	2022-03-08 14:30:21.55035+00	2022-06-01 12:58:56.17076+00	1	Intel	\N
61ddc9eb-1e22-4600-8f80-e1a5e5ed4b32	Core i5-8420	6	2.9 to 4.1 GHz	LGA 1151	14 nm	9MB	65	2018-09-01	2022-03-08 14:36:05.053491+00	2022-06-01 12:59:09.466933+00	2	Intel	\N
bedd94bb-e361-4652-a512-129002c5c0b4	Core i5-8500T	6	2.1 to 3.5 GHz	LGA 1151	14 nm	9MB	35	2018-04-02	2022-03-08 14:53:24.579517+00	2022-06-01 12:59:21.11293+00	2	Intel	\N
c1413bf0-e0e9-4872-a60e-566e5f096e92	Core i5-9600	6	3.1 to 4.5 GHz	LGA 1151	14 nm	9MB	65	2018-10-19	2022-03-08 15:04:59.249135+00	2022-06-01 12:59:58.718784+00	2	Intel	\N
3fd17ea9-e236-4aaa-8d37-366a1af3f887	Core i9-10900K	10 / 20	3.7 to 5.3 GHz	LGA 1200	14 nm	20MB	125	2020-04-30	2022-03-11 14:51:30.972888+00	2022-06-02 15:47:38.569517+00	4	Intel	\N
c979cf6d-acf5-4e52-8abe-1772e4503f67	Core i7-9800X	8 / 16	3.8 to 4.4 GHz	LGA 2066	14 nm	16.5MB	165	2018-10-19	2022-03-11 13:27:44.509128+00	2022-06-01 13:00:27.242846+00	3	Intel	\N
94b785a3-fa6f-4390-831a-05baa17e86ed	Core i9-10800F	10 / 20	2.7 to 5 GHz	LGA 1200	14 nm	20MB	65	2020-04-30	2022-03-11 14:47:09.725745+00	2022-06-02 15:47:54.166999+00	4	Intel	\N
bda2ccb7-38d7-4ded-be20-9234e4271b40	Core i3-9100F	4	3.6 to 4.2 GHz	LGA 1151	14 nm	6MB	65	2019-04-23	2022-03-11 13:35:14.181223+00	2022-06-01 13:01:35.904835+00	1	Intel	\N
5b347256-f2c5-4f42-b0dc-41dce997d605	Core i5-10600K	6 / 12	4.1 to 4.8 GHz	LGA 1200	14 nm	12MB	125	2020-04-30	2022-03-11 14:41:34.090871+00	2022-06-01 13:01:50.640429+00	2	Intel	\N
a41b7c18-ed92-4e86-bd97-fb8477232a51	Core i7-10700K	8 / 16	3.8 to 5.1 GHz	LGA 1200	14 nm	16MB	125	2020-04-30	2022-03-11 14:45:00.220541+00	2022-06-01 13:03:06.000846+00	3	Intel	\N
a5f02d1c-3123-41e8-a6ab-28611502b3aa	Core i5-11400	6 / 12	2.6 to 4.4 GHz	LGA 1200	14 nm	12MB	65	2021-03-16	2022-03-12 14:53:33.271488+00	2022-06-01 13:03:47.896823+00	2	Intel	\N
88f779b4-4fc0-4795-aa36-ad506f07e16a	Core i5-11500	6 / 12	2.7 to 4.6 GHz	LGA 1200	14 nm	12MB	65	2022-03-12	2022-03-12 14:57:19.636149+00	2022-06-01 13:04:00.460623+00	2	Intel	\N
7243616d-9e4f-49c0-9b6e-2c9ec1188aac	Core i5-11600T	6 / 12	1.7 to 4.1 GHz	LGA 1200	14 nm	12MB	35	2021-03-16	2022-03-12 15:02:45.58582+00	2022-06-01 13:04:12.594619+00	2	Intel	\N
77e0cde0-552a-4f07-989e-1b1e0fe49dcf	Ryzen 5 5600G	6 / 12	3.9 to 4.4 GHz\t	AM4	7 nm	16MB	65	2021-04-13	2022-03-16 13:17:30.5949+00	2022-06-02 15:31:03.673818+00	2	AMD	\N
afe43e24-1dc6-4070-a485-762c36941f49	Ryzen 5 PRO 5650G	6 / 12	3.9 to 4.4 GHz	AM4	7 nm	16MB	65	2021-06-01	2022-03-16 13:17:59.885375+00	2022-06-02 15:31:16.934293+00	2	AMD	\N
77e9601c-35c4-4a20-97b2-da5c05052946	Ryzen 5 PRO 5650GE	6 / 12	3.4 to 4.4 GHz	AM4	7 nm	16MB	35	2021-06-01	2022-03-16 13:18:27.526765+00	2022-06-02 15:31:31.436147+00	2	AMD	\N
2f067e16-2206-4c3f-b03e-c9a8a3cce2b8	Ryzen 7 5700G	8 / 16	3.8 to 4.6 GHz	AM4	7 nm	16MB	65	2021-04-13	2022-03-16 13:19:37.66756+00	2022-06-02 15:31:44.736264+00	3	AMD	\N
c3f1f219-270a-41a2-9cb6-a8909b77d7eb	Ryzen 7 PRO 5750G	8 / 16	3.8 to 4.6 GHz	AM4	7 nm	16MB	65	2021-06-01	2022-03-16 13:20:41.104583+00	2022-06-02 15:33:20.000182+00	3	AMD	\N
370f4628-1e88-4b4c-89c3-bae5e312596e	Ryzen 7 PRO 5750GE\t	8 / 16	3.2 to 4.6 GHz	AM4	7 nm	16MB	35	2021-06-01	2022-03-16 13:21:15.6563+00	2022-06-02 15:33:34.772184+00	3	AMD	\N
d730b090-50c2-43ec-b873-a346be42b249	Core i5-5675C	4	3.1 to 3.6 GHz	LGA 1150	14 nm	4MB	65	2015-05-15	2022-03-06 13:04:49.448243+00	2022-03-17 06:50:27.35948+00	\N	Intel	\N
32b2a737-1a12-4b06-bd79-093e62eff703	Core i7-5775C	4 / 8	3.3 to 3.7 GHz	LGA 1150	14 nm	6MB	65	2015-05-15	2022-03-06 13:31:47.732999+00	2022-03-17 06:50:27.568354+00	\N	Intel	\N
111e3b0a-0e07-42fb-88ef-4bfaadc44f2b	Core i5-6400	4	2.7 to 3.3 GHz	LGA 1151	14 nm	6MB	65	2015-07-02	2022-03-07 15:25:13.000344+00	2022-03-17 06:50:28.308629+00	\N	Intel	\N
c7b36993-69a0-4dee-a34c-8add8ee9fff1	Core i5-6600K	4	3.5 to 3.9 GHz	LGA 1151	14 nm	6MB	95	2015-07-02	2022-03-07 15:27:43.860021+00	2022-03-17 06:50:28.868874+00	\N	Intel	\N
cdd9b70a-6f25-40c8-8ddf-b62a46620cff	Core i7-6700	4 / 8	3.4 to 4 GHz	LGA 1151	14 nm	8MB	65	2015-07-01	2022-03-07 15:29:03.953881+00	2022-03-17 06:50:29.053033+00	\N	Intel	\N
f51c55a6-ed2e-41fb-b0e9-fbe36c258599	Core i7-6800K	6 / 12	3.4 to 3.8 GHz	LGA 2011-3	14 nm	15MB	140	2016-05-31	2022-03-07 15:42:42.76201+00	2022-03-17 06:50:29.794129+00	\N	Intel	\N
942240b7-6271-4b02-9496-82e316051c00	Core i3-7100T	2 / 4	3.4 GHz	LGA 1151	14 nm	3MB	35	2017-01-03	2022-03-07 16:09:35.240892+00	2022-03-17 06:50:30.722508+00	\N	Intel	\N
393e1297-b683-4f34-90a8-94b4efc34c97	Core i5-7600T	4	2.8 to 3.7 GHz	LGA 1151	14 nm	6MB	35	2017-01-03	2022-03-08 13:46:50.03898+00	2022-03-17 06:50:33.920429+00	\N	Intel	\N
a43adfc7-863c-4881-8968-67b1aa6c7177	Core i7-7820X	8 / 16	3.6 to 4.5 GHz	LGA 2066	14 nm	11MB	140	2017-06-26	2022-03-08 14:22:46.604608+00	2022-03-17 06:50:35.951142+00	\N	Intel	\N
d14ccdcb-a244-476d-b9da-97256c122a6d	Pentium G4500	2	3.5 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-07 15:34:48.586681+00	2022-03-17 06:51:32.440301+00	\N	Intel	\N
c2adac5a-2df4-47a3-924f-71ed938d5da7	Pentium G4520	2	3.6 GHz	LGA 1151	14 nm	4MB	51	2015-09-01	2022-03-07 15:35:35.462704+00	2022-03-17 06:51:32.626568+00	\N	Intel	\N
af63a0f8-44b7-4357-b403-56ff4d991cc7	Pentium Gold G5620	2 / 4	4 GHz	LGA 1151	14 nm	4MB	51	2019-02-20	2022-03-11 14:26:12.317015+00	2022-03-17 06:51:34.299859+00	\N	Intel	\N
4bb3bca8-387a-41c3-a699-230d2947d47e	Pentium Gold G6405	2 / 4	4.1 GHz	LGA 1200	14 nm	4MB	65	2021-03-16	2022-03-12 15:48:51.527834+00	2022-03-17 06:51:35.037855+00	\N	Intel	\N
e563de49-d688-4d1d-80ab-0d81e76a29ed	Pentium Gold G6505T	2 / 4	3.6 GHz	LGA 1200	14 nm	4MB	35	2021-03-16	2022-03-12 15:51:00.569447+00	2022-03-17 06:51:35.588303+00	\N	Intel	\N
b82f4833-afb2-4e27-9255-5d5f8a466da4	Pentium Gold G6605	2 / 4	4.3 GHz	LGA 1200	14 nm	4MB	65	2021-03-16	2022-03-12 15:51:58.128765+00	2022-03-17 06:51:35.771711+00	\N	Intel	\N
bfc0419b-15e1-47ee-aed3-5b3c1e16553e	Ryzen 9 5900	12 / 24	3 to 4.7 GHz	AM4	7 nm	64MB	65	2021-01-12	2022-03-16 13:21:46.482183+00	2022-06-02 15:33:48.94231+00	4	AMD	\N
b930d792-7d47-4ddb-a422-b919da359e3b	Core i9-9900K	8 / 16	3.6 to 5 GHz	LGA 1151	14 nm	16MB	95	2018-10-19	2022-03-11 13:24:30.584907+00	2022-06-02 15:46:55.76187+00	4	Intel	\N
038cfdbd-b670-41f0-9bbf-4664195703dc	Core i9-9980XE	18 / 36	3 to 4.5 GHz	LGA 2066	14 nm	24.75MB	165	2018-10-19	2022-03-11 13:32:36.731118+00	2022-06-02 15:47:10.914579+00	4	Intel	\N
608f8c34-5035-4683-8228-6002e28695bc	Core i9-9990XE	14 / 28	4 to 5.1 GHz	LGA 2066	14 nm	19.25	255	2018-10-19	2022-03-11 13:33:42.609344+00	2022-06-02 15:47:24.212244+00	4	Intel	\N
073919ea-c350-475f-a060-27edb5130b59	Celeron G3930	2	2.9 GHz	LGA 1151	14 nm	2MB	51	2017-01-03	2022-03-07 15:50:39.063141+00	2022-03-17 06:53:07.232073+00	\N	Intel	\N
69b24d5b-316a-4af0-a269-9728cca1b68d	Celeron G3930T	2	2.7 GHz	LGA 1151	14 nm	2MB	35	2017-01-03	2022-03-07 15:51:20.451185+00	2022-03-17 06:53:07.415923+00	\N	Intel	\N
e51801d8-b378-419a-808d-330cc3fad90e	Celeron G3950	2	3 GHz	LGA 1151	14 nm	2MB	51	2017-01-03	2022-03-07 15:52:10.108228+00	2022-03-17 06:53:07.598859+00	\N	Intel	\N
4a350474-d297-499d-b83a-0934c15490ab	Celeron G4900	2	3.1 GHz	LGA 1151	14 nm	6MB	51	2018-04-03	2022-03-08 14:28:36.885547+00	2022-03-17 06:53:07.782392+00	\N	Intel	\N
de0e06d0-4a4b-4c0a-93e8-78ce4dcba36f	Celeron G4920	2	3.2 GHz	LGA 1151	\t14 nm	6MB	51	2018-04-03	2022-03-08 14:29:11.063307+00	2022-03-17 06:53:07.965874+00	\N	Intel	\N
dd0ac8cd-e6bc-4367-bdd3-bb2ea931407a	PRO A10-8750B\t	4	3.6 to 4 GHz	FM2+	28 nm	N/A	95	2015-09-29	2022-03-12 16:07:21.074533+00	2022-03-17 06:53:09.260205+00	\N	AMD	\N
33678496-9f17-4408-a6b6-e862eba7e8f9	PRO A10-8850B	4	3.9 to 4.1 GHz	FM2+	28 nm	N/A	95	2015-09-29	2022-03-12 16:08:18.809275+00	2022-03-17 06:53:09.443565+00	\N	AMD	\N
2b64586e-548e-41d6-b086-5f3d99ed9516	PRO A4-8350B	2	3.5 to 3.9 GHz	FM2+	28 nm	N/A	65	2015-09-29	2022-03-12 16:08:57.818912+00	2022-03-17 06:53:09.627838+00	\N	AMD	\N
b031f92c-f1ed-40e6-af6a-103348b50d07	PRO A6-9500E	2	3 to 3.4 GHz	AM4	28 nm	N/A	35	2016-10-03	2022-03-12 16:16:59.556437+00	2022-03-17 06:53:10.914465+00	\N	AMD	\N
7ce469b9-2b1d-43ef-9f14-dc87affc2ad3	PRO A8-9600	4	3.1 to 3.4 GHz	AM4	28 nm	N/A	65	2016-10-03	2022-03-12 16:17:28.943421+00	2022-03-17 06:53:11.099105+00	\N	AMD	\N
8399a0be-c2fb-4cfd-820c-94af5993e43f	A10-7860K	4	3.6 to 4 GHz	FM2+	28 nm	N/A	65	2016-02-02	2022-03-13 03:19:52.785506+00	2022-03-17 06:53:11.289068+00	\N	AMD	\N
7c651b4e-c769-4546-b9f7-11f16e29ff80	Athlon X4 940	4	3.2 to 3.6 GHz\t	AM4	28 nm	N/A	65	2017-07-27	2022-03-13 03:30:15.60807+00	2022-03-17 06:53:13.129162+00	\N	AMD	\N
25bd2a38-0c90-4834-97b4-879b34ba4683	PRO A12-9800E	4	3.1 to 3.8 GHz	AM4	28 nm	N/A	35	2017-07-27	2022-03-13 03:31:52.629244+00	2022-03-17 06:53:13.682379+00	\N	AMD	\N
30dfea59-6205-4ac7-a7ff-ec3e7eb60662	Ryzen 3 PRO 1300	4	3.2 to 3.5 GHz	AM4	14 nm	8MB	65	2017-06-29	2022-03-13 11:46:06.617648+00	2022-03-17 06:53:14.602867+00	\N	AMD	\N
15cfaf49-698a-4b48-8f00-d6666d0f5123	Ryzen 5 2600	6 / 12	3.4 to 3.9 GHz	AM4	12 nm	16MB	65	2018-04-19	2022-03-13 16:20:17.417355+00	2022-06-02 15:34:02.874206+00	2	AMD	\N
65b9d6cd-bc07-495e-903e-f7bbc6d78f1a	Ryzen 5 1600AF	6 / 12	3.2 to 3.6 GHz	AM4	12 nm	16MB	65	2019-10-11	2022-03-15 13:27:11.189366+00	2022-06-02 15:34:18.766046+00	2	AMD	\N
5f3f1af3-d12d-4a81-8224-0bc569555d72	Athlon 200GE	2 / 4	3.2 GHz	AM4	14 nm	4MB	35	2018-09-06	2022-03-13 16:12:23.215051+00	2022-03-17 06:53:19.033309+00	\N	AMD	\N
a7a2139b-0a6c-4539-bcb2-3c69e81ee8c5	Athlon 220GE	2 / 4	3.4 GHz	AM4	14 nm	4MB	35	2018-12-21	2022-03-13 16:12:59.359411+00	2022-03-17 06:53:19.216968+00	\N	AMD	\N
2a30b6f4-ab26-40bd-b763-d65fa9e3e21a	A8-7680	4	3.5 to 3.8 GHz	FM2+	28 nm	N/A	45	2018-10-26	2022-03-14 16:12:47.650106+00	2022-03-17 06:53:22.899112+00	\N	AMD	\N
e489f2d4-3067-4d24-9621-2d9d1aed5772	Athlon 3000G	2 / 4	3.5 GHz	AM4	14 nm	4MB	35	2019-11-20	2022-03-15 13:25:04.798545+00	2022-03-17 06:53:23.633161+00	\N	AMD	\N
d8d9c336-833b-4e2e-b626-99738a388f77	Ryzen 5 3400G	4 / 8	3.7 to 4.2 GHz	AM4	12 nm	4MB	65	2019-07-07	2022-03-15 13:27:44.585307+00	2022-06-02 15:34:32.583974+00	2	AMD	\N
964183ac-89db-4fe1-b067-dbf1336761bc	Ryzen 3 PRO 5350G	4 / 8	4 to 4.2 GHz	AM4	7 nm	8MB	65	2021-06-01	2022-03-16 13:14:04.201708+00	2022-06-02 15:34:49.180999+00	1	AMD	\N
20b2dc79-517d-4601-a56f-d8dc7f0fcca4	Ryzen 3 PRO 5350GE	4 / 8	3.6 to 4.2 GHz	AM4	7 nm	8MB	35	2021-06-01	2022-03-16 13:15:57.468928+00	2022-06-02 15:35:04.844334+00	1	AMD	\N
e7d1d5f4-8759-425d-93c5-05fc72463ffd	Athlon Gold PRO 3150G	4	3.5 to 3.9 GHz	AM4	12 nm	4MB	65	2020-07-21	2022-03-15 17:26:20.230175+00	2022-03-17 06:53:30.081514+00	\N	AMD	\N
ce1797a0-a0f8-4831-abc0-ff6ac8879d8b	Athlon Gold PRO 3150GE\t	4	3.5 to 3.8 GHz	AM4	12 nm	4MB	35	2020-07-21	2022-03-15 17:27:14.345291+00	2022-03-17 06:53:30.265635+00	\N	AMD	\N
0a4f16ff-be33-4a28-84f1-c9e3429efb9c	Ryzen 7 5800	8 / 16	3.4 to 4.6 GHz	AM4	7 nm	32MB	65	2021-01-12	2022-03-16 13:20:07.289598+00	2022-06-02 15:35:20.08885+00	3	AMD	\N
\.


--
-- TOC entry 4380 (class 0 OID 4797498)
-- Dependencies: 217
-- Data for Name: cpu_prices; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.cpu_prices (id, cpu_id, price, shop, shop_link, created_at, updated_at, note) FROM stdin;
5f1d7fda-01c7-4bd8-a12d-507ac1e46b44	311e2945-6b04-499c-9b65-065583e0ec45	2599000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-3500x-3-6-ghz-box	2022-03-20 03:54:26.953613+00	2022-03-20 04:07:49.139713+00	Bundling dengan motherboard, SSD, RAM
53c5d4af-1e29-4d4b-8ed0-dba0bbc756d7	311e2945-6b04-499c-9b65-065583e0ec45	2745000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-3500x-3-6-ghz-box-tanpa-bundling	2022-03-20 04:09:09.81186+00	2022-03-20 04:09:09.81186+00	tanpa Bundling
28a579c3-6ca6-475d-be4a-226d8edeaffe	61f064f8-5bde-49fd-adfc-8f52c55a0c2b	3161000	Shopee	https://shopee.co.id/AMD-Ryzen-5-3600-3-6Ghz-4-2Ghz-6-Core-12-Thread-AM4-i.22145472.2456956410?sp_atk=3753de96-03c1-4040-811f-8560ea2d8794	2022-03-20 04:22:14.583022+00	2022-03-20 04:22:14.583022+00	\N
6db8c8cb-fa3a-44b7-9085-fc25b8cf89d4	61f064f8-5bde-49fd-adfc-8f52c55a0c2b	3115000	Tokopedia	https://www.tokopedia.com/tokoexpert/amd-ryzen-5-3600-6-core-3-6ghz?src=topads	2022-03-20 04:29:34.574064+00	2022-03-20 04:29:34.574064+00	\N
392cc69c-5462-4363-be5b-d587f4e31810	788b55c3-dcf0-4679-a8eb-ef919b6551e8	3680000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-3600x-3-8-ghz-box	2022-03-20 04:39:16.732913+00	2022-03-20 04:39:16.732913+00	stock sisa 8 saat pencatatan
1c859d76-c83f-4417-b86e-3f0716eeef82	586970e7-7f52-4032-af47-47a4366f7db1	3600000	Shopee	https://shopee.co.id/PROCESSOR-AMD-RYZEN-5-3600XT-BARU-NON-FAN-NON-BOX-i.35406160.4562486166?sp_atk=a642b950-abcb-4bfb-97cf-12da538faba9	2022-03-20 04:41:44.078687+00	2022-03-20 04:41:44.078687+00	non-box
c0d90d56-4045-41b0-9501-8b5b617e88e3	586970e7-7f52-4032-af47-47a4366f7db1	4099000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-3600xt-4-0-ghz-box-garansi-3-tahun?refined=true	2022-03-20 04:42:07.893996+00	2022-03-20 04:42:07.893996+00	\N
a2737dec-da6d-4b30-bbf1-1804249e77ea	7aba02e4-1808-4c47-a5c8-7efa0ef1d0f7	2999000	Shopee	https://shopee.co.id/Processor-AMD-Ryzen-3-3200G-3.6-Ghz-BOX-i.265698488.7538400544?sp_atk=1c1823fa-1480-4a6d-9288-3ba3c517bf12	2022-03-20 11:16:17.1451+00	2022-03-20 11:16:17.1451+00	\N
2836b709-0f17-4492-941e-7a96e2b28b04	7aba02e4-1808-4c47-a5c8-7efa0ef1d0f7	2990000	Tokopedia	tokopedia.com/queenprocessor/processor-amd-ryzen-3-3200g-3-6-ghz-box	2022-03-20 11:19:33.197627+00	2022-03-20 11:21:38.724599+00	BOX, Harus dengan bundling, harga belum termasuk bundling
8508e94e-f0c7-4308-b4a5-978d94af8a82	61f064f8-5bde-49fd-adfc-8f52c55a0c2b	2799000	Tokopedia	https://www.tokopedia.com/queenprocessor/amd-ryzen-5-3600-tray-am4-3-6ghz	2022-03-20 11:36:23.069814+00	2022-03-20 11:36:23.069814+00	Tray
6091a4d0-1d9c-420e-a3da-8812e49f2c65	61f064f8-5bde-49fd-adfc-8f52c55a0c2b	2990000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-3600-3-6-ghz-box	2022-03-20 11:42:56.168417+00	2022-03-20 11:42:56.168417+00	Box
3664eb8a-9973-4807-ab07-d1c791867f51	61f064f8-5bde-49fd-adfc-8f52c55a0c2b	3075000	Tokopedia	https://www.tokopedia.com/siliconone/amd-processor-ryzen-5-3600-box	2022-03-20 11:43:45.2028+00	2022-03-20 11:43:45.2028+00	Box
5e655b75-ee7f-436c-8fbd-ce4e68721ec7	61f064f8-5bde-49fd-adfc-8f52c55a0c2b	3115000	Shopee	https://shopee.co.id/Processor-AMD-Ryzen-5-3600-3.6-4.2-GHz-Socket-AM4-Matisse-i.15607053.2771364618?sp_atk=9c585f03-8e6d-454f-ac51-576261a7b39c	2022-03-20 11:38:40.283694+00	2022-03-20 11:45:57.354116+00	\N
c117c1ed-0f57-4109-aa5b-1f5b12b01edb	61f064f8-5bde-49fd-adfc-8f52c55a0c2b	3029000	Tokopedia	https://www.tokopedia.com/nanokomputer/processor-amd-ryzen-5-3600-matisse-am4-6-core-zen-2-cpu-tray	2022-03-20 11:40:21.154663+00	2022-03-20 11:46:21.919027+00	Tray
0b00b2bd-4a6a-4f4d-9838-f58dac542b6a	788b55c3-dcf0-4679-a8eb-ef919b6551e8	3920000	Tokopedia	https://www.tokopedia.com/apacarigan2/amd-ryzen-5-3600x-6-core-3-8ghz-socket-am4	2022-03-20 11:50:37.077024+00	2022-03-20 11:50:37.077024+00	\N
abcc3d43-6d95-43eb-93f9-066682028d40	788b55c3-dcf0-4679-a8eb-ef919b6551e8	4475000	Tokopedia	https://www.tokopedia.com/gcomp-1/amd-ryzen-5-3600x-6-core-3-8-ghz-socket-amd-am4	2022-03-20 11:50:57.008953+00	2022-03-20 11:50:57.008953+00	\N
9dba5000-9c2f-4209-a29b-0ac41b2df40d	586970e7-7f52-4032-af47-47a4366f7db1	3889000	Tokopedia	https://www.tokopedia.com/optionid-1/processor-amd-ryzen-5-3600xt-box-am4-7-nm-6-core-3-8ghz?refined=true	2022-03-20 13:02:57.90119+00	2022-03-20 13:02:57.90119+00	Stock sisa 2 ketika didata
e7f16278-e726-497b-b9ea-1c96dd8cd124	4dbed1ae-13cf-4593-a2ff-4d74b903138e	5000000	Tokopedia	https://www.tokopedia.com/allmixshop/ryzen-7-2700x-amd-50th-anniversary-gold-limited-edition-ryzen-7-2700	2022-03-20 13:23:05.417739+00	2022-03-20 13:23:05.417739+00	Preorder
241ebb44-d947-40dd-ae3a-30b98def1289	30c1a091-834e-4091-b9e1-5d0add666f85	5399000	Shopee	https://shopee.co.id/Processor-AMD-Ryzen-7-3800x-3.9-Ghz-BOX-i.265698488.4738416092?sp_atk=82ca51d5-e4f1-4ce2-843e-e4a3d6124dd0	2022-03-20 13:25:49.027078+00	2022-03-20 13:25:49.027078+00	Box
8f9da9de-8a9f-440b-9757-b9bdca44017b	30c1a091-834e-4091-b9e1-5d0add666f85	4990000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-7-3800x-3-9-ghz-box?refined=true	2022-03-20 13:29:36.20347+00	2022-03-20 13:29:36.20347+00	Box
2409905a-fe29-4fb4-ba6c-1428b2fce181	30c1a091-834e-4091-b9e1-5d0add666f85	5550000	Tokopedia	https://www.tokopedia.com/tokoexpert/amd-ryzen-7-3800x-8-core-3-9-ghz-socket-am4?refined=true	2022-03-20 13:33:48.42361+00	2022-03-20 13:33:48.42361+00	\N
42fd64e1-4432-4a2d-b17e-b32796c4429e	30c1a091-834e-4091-b9e1-5d0add666f85	5950000	Tokopedia	https://www.tokopedia.com/fondratamiya/processor-amd-ryzen-7-3800x-3-9ghz-box?refined=true	2022-03-20 13:35:57.938755+00	2022-03-20 13:35:57.938755+00	Box
b39e3172-7b40-4c5a-b2e7-541eda330b2f	083880ca-ee30-4e2a-998d-b55592ae6da6	7499000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-9-3900x-3-8-ghz-box	2022-03-20 13:45:32.454603+00	2022-03-20 13:45:32.454603+00	\N
8c1eff12-b054-4245-b28d-f21e050a5516	083880ca-ee30-4e2a-998d-b55592ae6da6	10000000	Tokopedia	https://www.tokopedia.com/ichtion/amd-ryzen-9-3900x-12-core-24-thread-3-8-4-6-ghz	2022-03-20 13:52:43.970631+00	2022-03-20 13:52:43.970631+00	\N
17763fdb-e773-4f0f-9c66-fb76dcd6d354	4c7e344c-11b6-4863-afe3-d259e4bc36a1	11679000	Shopee	https://shopee.co.id/Processor-AMD-Ryzen-9-3950x-3.5-Ghz-BOX-i.265698488.4538419650?sp_atk=3905c6fd-427a-4fe8-91dd-efd1eb82fca3	2022-03-20 13:57:21.760672+00	2022-03-20 13:57:21.760672+00	Box
617a205a-a35a-4b74-b939-547e69e44d26	4c7e344c-11b6-4863-afe3-d259e4bc36a1	10780000	Tokopedia	https://www.tokopedia.com/maxcom-computer/amd-ryzen-9-3950x-3-5ghz-up-to-4-7ghz-am4	2022-03-20 14:18:06.175432+00	2022-03-20 14:18:06.175432+00	\N
dbacaf7a-4eba-407a-b0a5-89521599004b	03931f95-8e78-44eb-82f6-4cbea59f4311	2455000	Shopee	https://shopee.co.id/AMD-RYZEN-3-3300X-i.76610822.4434748990?sp_atk=c1f660a3-422f-4f00-819b-8e280672395c	2022-03-20 14:43:38.563914+00	2022-03-20 14:43:38.563914+00	\N
1fa0e90a-b919-49b3-b9c0-101c50ae5db0	4c7e344c-11b6-4863-afe3-d259e4bc36a1	11650000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-9-3950x-3-5-ghz-new-item-box	2022-03-20 13:58:32.747519+00	2022-03-20 14:22:45.362821+00	New Item Box
46173b2a-271e-4f5c-a3c3-6fa25e23ccd6	61bef273-0e3a-4715-a2e2-236a3771d996	4850000	Shopee	https://shopee.co.id/AMD-Ryzen-7-3700X-3.6Ghz-Up-To-4.4Ghz-Cache-32MB-65W-AM4-Box-8-Core-i.39863317.8619723946?sp_atk=a14955f2-174e-4368-90d8-f7ed4f2aa581	2022-03-20 14:26:28.721545+00	2022-03-20 14:26:28.721545+00	Box
2b0b91d1-3fda-456f-aa3b-790f63b99346	61bef273-0e3a-4715-a2e2-236a3771d996	4499000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-7-3700x-3-6-ghz-box	2022-03-20 14:27:51.763673+00	2022-03-20 14:27:51.763673+00	Box
27bcf6e4-91d7-411a-bba0-3f3204b7a760	61bef273-0e3a-4715-a2e2-236a3771d996	4699000	Tokopedia	https://www.tokopedia.com/dualcom/processor-amd-am4-ryzen-7-3700x-box-wraith-cooler	2022-03-20 14:28:31.870343+00	2022-03-20 14:28:31.870343+00	Box, wraith cooler
a9f6da18-5d58-4ac9-bf45-e8c28321c438	f2b52e19-da2d-4245-98aa-92d036cf07a1	2399000	Shopee	https://shopee.co.id/Processor-Ryzen-3-3100-3.6Ghz-Box-i.265698488.7840290731?sp_atk=87d35f9e-f5ed-4edd-afa6-79edb54ad7be	2022-03-20 14:35:44.208182+00	2022-03-20 14:35:44.208182+00	Box
0f55878d-babe-4964-9d89-a3641d2438cc	f2b52e19-da2d-4245-98aa-92d036cf07a1	2199000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-ryzen-3-3100-3-6-ghz-box-new-product	2022-03-20 14:41:11.562727+00	2022-03-20 14:41:11.562727+00	Bundling
929d25b9-126f-4799-8331-18ca8fc4357b	f2b52e19-da2d-4245-98aa-92d036cf07a1	2299000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-ryzen-3-3100-3-6-ghz-box-new-product-tanpa-bundling	2022-03-20 14:41:41.337242+00	2022-03-20 14:41:41.337242+00	Tanpa bundling
a2af5f50-7e94-4393-96e0-a22d2d5717f5	03931f95-8e78-44eb-82f6-4cbea59f4311	2589000	Tokopedia	https://www.tokopedia.com/optionid-1/processor-amd-ryzen-3-3300x-box-quad-core-4-3-ghz-4-cores-am4?src=topads	2022-03-20 14:45:54.602835+00	2022-03-20 14:45:54.602835+00	L3 Cache 18MB
238a335d-4e18-4daa-9cf4-60405c697857	03931f95-8e78-44eb-82f6-4cbea59f4311	2430000	Tokopedia	https://www.tokopedia.com/tokoexpert/amd-ryzen-3-3300x-4-core-3-8-ghz-up-to-4-3-ghz	2022-03-20 14:46:55.905572+00	2022-03-20 14:46:55.905572+00	\N
32059b3c-3f83-4d23-8bae-5f6f204f512d	03931f95-8e78-44eb-82f6-4cbea59f4311	2479000	Tokopedia	https://www.tokopedia.com/starcomporigin/amd-ryzen-3-3300x-am4-4-core-8-threads	2022-03-20 14:48:16.606232+00	2022-03-20 14:48:16.606232+00	\N
2af02b8a-51a9-45b6-8f36-613804f6176e	60ae6630-3cdb-4277-bc0f-a6ecba7016f8	7342000	Tokopedia	https://www.tokopedia.com/exacttools/amd-ryzen-3-4300g-r3-4300g-3-8ghz-four-core-eight-thread-exact?refined=true	2022-03-20 14:59:14.852102+00	2022-03-20 14:59:14.852102+00	Preorder
b0ccc26d-9820-4a2e-af8f-dcb806c87740	60ae6630-3cdb-4277-bc0f-a6ecba7016f8	4173930	Tokopedia	https://www.tokopedia.com/archive-fabiengelael-1638756613/amd-ryzen-3-4300g-r3-4300g-3-8ghz-four-core-eight-thread-fabgel?refined=true	2022-03-20 14:59:49.528502+00	2022-03-20 14:59:49.528502+00	Preorder
8a05247e-9785-48a0-82cb-5168e460a09e	1b6aff4c-0773-4978-9c17-8669a32e4992	2990000	Shopee	https://shopee.co.id/Processor-AMD-ryzen-3-Pro-4350G-TRAY-fan-i.265698488.8515970968?sp_atk=9b02af65-2a81-43c4-b4b0-228ea390515c	2022-03-20 15:05:28.751255+00	2022-03-20 15:09:51.151386+00	tray + fan
e7adb004-16ce-4422-a367-068187c55944	1b6aff4c-0773-4978-9c17-8669a32e4992	2849000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-3-pro-4350g-tray-fan-july-20	2022-03-20 15:11:36.200472+00	2022-03-20 15:11:36.200472+00	Tray + fan
34d4b043-e8d6-4ac0-8bd7-874773c927d2	1b6aff4c-0773-4978-9c17-8669a32e4992	4535000	Tokopedia	https://www.tokopedia.com/dunetcomputer/amd-ryzen-3-pro-4350g-4-core-8-threads-up-to-4-0ghz-wraith-cooler	2022-03-20 15:12:05.342276+00	2022-03-20 15:12:05.342276+00	+ Wraith Cooler
e0275dc8-cc55-4024-b768-913b21f54c3e	73362a53-068d-400e-aaf4-d148eb27e679	8841000	Tokopedia	https://www.tokopedia.com/the-bestore/amd-ryzen-5-4600g-r5-4600g-3-7ghz-six-core-twelve-thread-faui?refined=true	2022-03-20 15:22:52.615245+00	2022-03-20 15:22:52.615245+00	Preorder
6607fc88-65b4-491b-9bb8-8d00888da188	73362a53-068d-400e-aaf4-d148eb27e679	8827820	Tokopedia	https://www.tokopedia.com/sberkah1/amd-ryzen-5-4600g-r5-4600g-3-7ghz-six-core-twelve-thread-saputka?refined=true	2022-03-20 15:23:15.58546+00	2022-03-20 15:23:15.58546+00	Preorder
9d3bea58-26c8-49ee-9d12-f1efbc813381	7afe602d-7cfb-475f-8537-8b14cd313035	4299000	Shopee	https://shopee.co.id/AMD-Ryzen-5-5600X-i.746822.4762622611?sp_atk=891f0989-d605-432b-af01-ce3787d74c0b	2022-03-20 15:27:52.886558+00	2022-03-20 15:27:52.886558+00	\N
e1435adf-595e-424c-96f2-3968ff5fc108	7afe602d-7cfb-475f-8537-8b14cd313035	4211000	Shopee	https://shopee.co.id/AMD-Ryzen-5-5600X-3.7Ghz-Up-To-4.6Ghz-Cache-32MB-65W-AM4-Box-6-Core-100-100000065BOX-With-AM-i.43570421.10800199506?sp_atk=80f9863a-40d0-41dc-801a-d665c83d79da	2022-03-20 15:28:07.970663+00	2022-03-20 15:28:07.970663+00	\N
4d35ff61-896b-4e03-9545-07446dabc6b1	7afe602d-7cfb-475f-8537-8b14cd313035	4220000	Shopee	https://shopee.co.id/Processor-AMD-Ryzen-5-5600X-3.7-4.6-GHz-Socket-AM4-i.15607053.9613233784?sp_atk=948690a3-dabd-4ea9-b2f8-49134a7770e5	2022-03-20 15:29:22.463999+00	2022-03-20 15:29:22.463999+00	\N
47caa27b-d4ca-4874-b486-b5d9ef8776b4	7afe602d-7cfb-475f-8537-8b14cd313035	4259000	Tokopedia	https://www.tokopedia.com/nanokomputer/amd-ryzen-5-5600x-processor-amd-am4-zen-3-vermeer-6-cores-12-threads-box	2022-03-20 15:30:31.619412+00	2022-03-20 15:30:31.619412+00	Box
c4e65fd2-b736-4b67-b2d7-f20c37d265f6	7afe602d-7cfb-475f-8537-8b14cd313035	4269000	Tokopedia	https://www.tokopedia.com/karyacitra/processor-amd-ryzen-5-5600x-box-4-6ghz?src=topads	2022-03-20 15:31:11.114863+00	2022-03-20 15:31:11.114863+00	Box
f08f3d34-c9a2-45a4-a73f-e2df987c0188	701716c4-52e7-4f51-90ab-f1f361368594	3206000	Tokopedia	https://www.tokopedia.com/karyacitra/processor-amd-ryzen-5-pro-4650g-up-to-4-2ghz-socket-am4-tray?src=topads	2022-03-20 15:34:23.52596+00	2022-03-20 15:34:23.52596+00	Tray
0bb5a5e6-dcea-44c5-99f8-ffa9f22a76bf	701716c4-52e7-4f51-90ab-f1f361368594	3029000	Tokopedia	https://www.tokopedia.com/julyaugustshop/amd-ryzen-5-pro-4650g-6-core-12-threads-up-to-4-3ghz	2022-03-20 15:34:57.255112+00	2022-03-20 15:34:57.255112+00	\N
68a22b64-cc51-4a55-a646-c9d43fc2a4ff	701716c4-52e7-4f51-90ab-f1f361368594	2999000	Tokopedia	https://www.tokopedia.com/gasol/amd-ryzen-5-renoir-pro-4650g-3-7ghz-4-3ghz-turbo-6-core-12thread	2022-03-20 15:35:24.29908+00	2022-03-20 15:35:24.29908+00	\N
2381d682-3815-40e0-b231-a57d6a4d32e2	701716c4-52e7-4f51-90ab-f1f361368594	2990000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-pro-4650g-tray-new-product-july-2020	2022-03-20 15:37:10.931482+00	2022-03-20 15:37:10.931482+00	Tray
2569af2e-e9d7-49ae-8214-5759722a3896	dc5e1b17-b185-4db0-9201-60a690ac6cd3	2990000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-pro-4650ge-3-3ghz-new-product-july-2020?refined=true	2022-03-20 15:40:00.504268+00	2022-03-20 15:40:00.504268+00	\N
5a09d045-8c9c-4bba-9212-563798612861	232ae596-71a6-4be6-89e6-7e902e419dc4	5679000	Shopee	https://shopee.co.id/PROCESSOR-AMD-Ryzen-7-3800XT-4.2-Ghz-BOX-NEW-GARANSI-3-TAHUN-i.265698488.3746793630?sp_atk=8a0b95f4-ed98-40d9-83ab-0cbd14d57e4e	2022-03-20 15:42:09.005822+00	2022-03-20 15:42:09.005822+00	Box
2b7a1d82-7ccd-4bf5-8f6c-601d72f1ff3e	232ae596-71a6-4be6-89e6-7e902e419dc4	5655000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-7-3800xt-4-2-ghz-box-new-3-tahun?refined=true	2022-03-20 15:43:19.842538+00	2022-03-20 15:43:19.842538+00	Box
8c7d5238-8094-4a00-8c15-0aad28916aec	232ae596-71a6-4be6-89e6-7e902e419dc4	5649000	Tokopedia	https://www.tokopedia.com/optionid-1/processor-amd-ryzen-7-3800xt-box-matisse-am4-8-core-zen2-up-to-4-7ghz?refined=true	2022-03-20 15:43:40.352247+00	2022-03-20 15:43:40.352247+00	Box
45e87e19-042e-49cf-9c2b-1940679f2daf	47f9065f-c191-4f7a-8fe0-e7dba01f6f13	5799000	Shopee	https://shopee.co.id/AMD-Ryzen-7-5800X-i.746822.7262621093?sp_atk=8f7c62eb-4fd5-4c05-916c-3890cdf29854	2022-03-20 15:48:50.567065+00	2022-03-20 15:48:50.567065+00	\N
2440fb81-dc26-4c4d-9069-f60c77f6699a	47f9065f-c191-4f7a-8fe0-e7dba01f6f13	5499000	Shopee	https://shopee.co.id/PROCESSOR-AMD-RYZEN-7-5800X-4.7GHz-BOX-LIMITED-i.265698488.6579522551?sp_atk=043e4117-04ce-4f69-b736-9b7131045d69	2022-03-20 15:51:19.783765+00	2022-03-20 15:51:19.783765+00	Box
0863ddad-a80a-4ad1-b115-cbf62857650c	47f9065f-c191-4f7a-8fe0-e7dba01f6f13	5599000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-7-5800x-4-7ghz-box	2022-03-20 15:53:58.024333+00	2022-03-20 15:53:58.024333+00	Box
082abfb8-afc6-4cf1-afc9-3816099ad8f6	47f9065f-c191-4f7a-8fe0-e7dba01f6f13	5869000	Shopee	https://www.tokopedia.com/nanokomputer/amd-ryzen-7-5800x-processor-amd-am4-zen-3-vermeer-8-core-16-threads	2022-03-20 15:54:45.910768+00	2022-03-20 15:54:45.910768+00	Tidak termasuk cooler
5e09bf0a-984d-45bf-bdc2-a1c73823df0f	47f9065f-c191-4f7a-8fe0-e7dba01f6f13	5475000	Tokopedia	https://www.tokopedia.com/supply-drop/amd-ryzen-7-5800x-8-cores-3-8ghz-up-to-4-7ghz-105w-8-core-box	2022-03-20 15:55:11.7866+00	2022-03-20 15:55:11.7866+00	Box
292db45a-5214-4eed-9744-32d7e9df46f6	dc0f1958-4695-4307-ac7f-980db5ce2e3c	4599000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-7-pro-4750g-3-6ghz-new-product-july-2020	2022-03-21 13:48:39.661495+00	2022-03-21 13:49:03.741415+00	Bundling dengan motherboard
403397b9-d2dc-4677-a9d0-591cc625497e	f8e56ce4-4d08-4a6f-86c3-6841d4f05ef0	4599000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-7-pro-4750ge-3-1ghz-new-product-july-2020?refined=true	2022-03-21 13:50:28.529713+00	2022-03-21 13:50:28.529713+00	\N
4a007732-8ec1-496d-8b84-acc87f0f5073	11f25fc4-f6e0-4186-b45d-3b26be0dcbd2	7990000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-9-3900xt-3-8-ghz-box-new-product-2020?refined=true	2022-03-21 13:53:11.255317+00	2022-03-21 13:53:11.255317+00	Box
c9ff942b-beef-4613-8df6-69074c1c9938	11f25fc4-f6e0-4186-b45d-3b26be0dcbd2	7849000	Tokopedia	https://www.tokopedia.com/optionid-1/ready-processor-amd-ryzen-9-3900xt-box-matisse-12-cores-am4-w-o-fan?refined=true	2022-03-21 13:53:32.664821+00	2022-03-21 13:53:32.664821+00	\N
eced7a16-9fc2-455f-b249-ea6ea2411b50	736f86fd-24fd-48ca-b6d0-4e4bcf5aff55	8260000	Shopee	https://shopee.co.id/Processor-AMD-AM4-Ryzen-9-5900X-Box-i.14954873.7462092946?sp_atk=91fc24df-f04d-499f-ae4b-d6c390d58709	2022-03-21 13:55:58.013226+00	2022-03-21 13:55:58.013226+00	Box
b16b887a-6cfe-4815-aa14-342486e469e9	736f86fd-24fd-48ca-b6d0-4e4bcf5aff55	8333000	Shopee	https://shopee.co.id/AMD-Ryzen-9-5900X-3.7Ghz-Up-To-4.8Ghz-AM4-Box-Garansi-AMD-Global-i.43570421.11831558498?sp_atk=da6927f5-c72f-4bbf-983f-12067d44eea1	2022-03-21 13:56:16.861138+00	2022-03-21 13:56:16.861138+00	Box
b1c1108a-4e92-4990-9af1-7263b39b6bd9	736f86fd-24fd-48ca-b6d0-4e4bcf5aff55	8432490	Shopee	https://shopee.co.id/AMD-Ryzen-9-5900X-i.746822.6062617737?sp_atk=f945193b-10c3-4679-bf28-8c8c89e187e4	2022-03-21 13:56:45.869252+00	2022-03-21 13:56:45.869252+00	\N
ebe9b275-65d4-49ba-ac26-cfed0680a7fb	736f86fd-24fd-48ca-b6d0-4e4bcf5aff55	7437000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-9-5900x-4-8ghz-box-limited	2022-03-21 14:09:23.258803+00	2022-03-21 14:09:23.258803+00	Box
80f9759f-57e9-4e46-8b63-272591c1db70	736f86fd-24fd-48ca-b6d0-4e4bcf5aff55	7535000	Tokopedia	https://www.tokopedia.com/supply-drop/amd-ryzen-9-5900x-12-cores-24-threads-up-to-4-8ghz-garansi-3-tahun	2022-03-21 14:09:45.801371+00	2022-03-21 14:09:45.801371+00	\N
4af7a41b-daab-4010-9e43-6bdca8d2774f	736f86fd-24fd-48ca-b6d0-4e4bcf5aff55	8240000	Tokopedia	https://www.tokopedia.com/klikgalaxy/amd-ryzen-9-5900x-am4-processor?whid=13325	2022-03-21 14:10:06.44213+00	2022-03-21 14:10:06.44213+00	\N
22b38c79-a5a7-4077-9c40-9191091d029c	555b05a3-4f54-4d1c-a8b3-568323490a80	11820000	Shopee	https://shopee.co.id/Processor-AMD-AM4-Ryzen-9-5950X-Box-i.14954873.4962092980?sp_atk=6598b6b1-6edc-4f33-a57e-0bea2fe8b53e	2022-03-21 14:11:19.854649+00	2022-03-21 14:11:19.854649+00	\N
23b341e3-1ae4-41ed-850b-2f68d20d1e27	555b05a3-4f54-4d1c-a8b3-568323490a80	12245000	Shopee	https://shopee.co.id/AMD-Ryzen-9-5950X-16-Core-3.4-GHz-Turbo-4.9Ghz-Socket-AM4-105W-ZEN3-i.59402203.6462123882?sp_atk=613609b9-9d9e-4141-b498-4fe21157f666	2022-03-21 14:11:37.447363+00	2022-03-21 14:11:37.447363+00	\N
5d00c82f-2804-457b-8a23-15b60cc52642	555b05a3-4f54-4d1c-a8b3-568323490a80	11895000	Shopee	https://shopee.co.id/AMD-Processor-RYZEN-9-5950X-BOX-i.24539943.7786418991?sp_atk=9cf94ad8-c129-4890-8932-13f4ef1dc544	2022-03-21 14:11:58.418197+00	2022-03-21 14:11:58.418197+00	Box
5d9014b4-6338-41d4-b0e0-c38850b7c653	555b05a3-4f54-4d1c-a8b3-568323490a80	12350000	Tokopedia	https://www.tokopedia.com/nanokomputer/amd-ryzen-9-5950x-processor-amd-am4-zen-3-vermeer-16-core-32-threads	2022-03-21 14:13:41.862807+00	2022-03-21 14:13:41.862807+00	\N
454a641f-a77e-4e73-a760-10edb7199d86	555b05a3-4f54-4d1c-a8b3-568323490a80	11820000	Tokopedia	https://www.tokopedia.com/it-shoponline/processor-amd-am4-ryzen-9-5950x-box?whid=13325	2022-03-21 14:14:31.340107+00	2022-03-21 14:14:31.340107+00	Box, stok sisa 2 saat pendataan
8ede48f8-f594-42dd-8d7b-37eb62bcc05d	555b05a3-4f54-4d1c-a8b3-568323490a80	10090000	Tokopedia	https://www.tokopedia.com/supply-drop/amd-ryzen-9-5950x-3-4ghz-up-to-4-9ghz-cache-64mb-105w-am4-box	2022-03-21 14:13:59.389525+00	2022-03-21 14:14:59.596304+00	Box, stok sisa 9 saat pendataan
52fc9229-5ee9-4c17-ac5a-c76e5f01738b	77e0cde0-552a-4f07-989e-1b1e0fe49dcf	3280000	Shopee	https://shopee.co.id/Processor-AMD-Ryzen-5-5600G-3.9Ghz-TRAY-AM4-i.28679071.14602463776?sp_atk=9be77d89-517b-4436-8f2f-b4414566fc17	2022-03-21 14:22:22.152582+00	2022-03-21 14:22:22.152582+00	Tray, sisa 3 stok saat pendataan
0a213607-78f9-48bc-9eb1-f6e1aabdb89a	77e0cde0-552a-4f07-989e-1b1e0fe49dcf	3629000	Shopee	https://shopee.co.id/AMD-Ryzen-5-5600G-6-Core-12-Threads-3.9GHz-Radeon-Vega-7-i.24539943.3896838628?sp_atk=c583004d-dfed-417b-93dc-8ce1aade7b20	2022-03-21 14:22:48.553173+00	2022-03-21 14:22:48.553173+00	\N
7fb4652d-4d73-4927-b5c0-d466f131d58c	77e0cde0-552a-4f07-989e-1b1e0fe49dcf	3679000	Shopee	https://shopee.co.id/AMD-Ryzen-5-5600G-AM4-Processor-i.22145472.7496854885?sp_atk=77cb7270-7167-4487-8a5e-0ccf1eda2f33	2022-03-21 14:23:14.368757+00	2022-03-21 14:23:14.368757+00	\N
89fa4ef4-877d-4086-b2fe-dbc6fc6dff06	77e0cde0-552a-4f07-989e-1b1e0fe49dcf	3689000	Tokopedia	https://www.tokopedia.com/nanokomputer/amd-ryzen-5-5600g-processor-amd-am4-zen-3-cezanne-6-cores-12-threads	2022-03-21 14:24:23.81237+00	2022-03-21 14:24:23.81237+00	\N
73136f35-ee1f-4d9a-a096-1de8e03a6b8f	77e0cde0-552a-4f07-989e-1b1e0fe49dcf	3499000	Tokopedia	https://www.tokopedia.com/queenprocessor/amd-ryzen-5-5600g-3-9ghz-6-cpu-cores-12-threads-7-gpu-cores-box	2022-03-21 14:24:51.154895+00	2022-03-21 14:24:51.154895+00	\N
22c50b4d-820d-40a0-b339-32d98f6c6ca3	77e0cde0-552a-4f07-989e-1b1e0fe49dcf	3675000	Tokopedia	https://www.tokopedia.com/it-shoponline/processor-amd-am4-ryzen-5-5600g-box?whid=13325	2022-03-21 14:25:34.676142+00	2022-03-21 14:25:34.676142+00	Box, sisa 4 stok ketika pendataan
05f7560a-550e-4e5d-88ac-2e6cc1a06c3c	2f067e16-2206-4c3f-b03e-c9a8a3cce2b8	4720000	Shopee	https://shopee.co.id/Processor-AMD-Ryzen-7-5700G-3.9Ghz-BOX-AM4-i.28679071.10839830315?sp_atk=9c042642-6dc0-4620-a6a9-544950df59c4	2022-03-21 14:27:40.018858+00	2022-03-21 14:27:40.018858+00	Box, sisa 6 stok saat pendataan
6cba103c-781c-412c-bbb2-6ee5cc7b5add	2f067e16-2206-4c3f-b03e-c9a8a3cce2b8	4870000	Shopee	https://shopee.co.id/Processor-AMD-AM4-Ryzen-7-5700G-Wraith-Cooler-i.14954873.7196665324?sp_atk=fca6ee91-6df6-4add-a64b-5cf1e5fdeb14	2022-03-21 14:28:16.306804+00	2022-03-21 14:28:16.306804+00	Sisa 5 stok ketika pendataan
7da8d6e8-4265-45d9-bff7-9cf3ba81b61b	2f067e16-2206-4c3f-b03e-c9a8a3cce2b8	4879000	Tokopedia	https://www.tokopedia.com/nanokomputer/amd-ryzen-7-5700g-processor-amd-am4-zen-3-cezanne-8-cores-16-threads	2022-03-21 14:32:36.58991+00	2022-03-21 14:32:36.58991+00	\N
591dec70-6e24-4bc6-bb2a-9e2b142936d5	2f067e16-2206-4c3f-b03e-c9a8a3cce2b8	4649000	Tokopedia	https://www.tokopedia.com/queenprocessor/amd-ryzen-7-5700g-3-9ghz-8-cpu-cores-16-threads-8-gpu-cores-box	2022-03-21 14:33:27.662259+00	2022-03-21 14:33:27.662259+00	Box
c30c9b20-1c57-4642-be42-a8612c545a71	2f067e16-2206-4c3f-b03e-c9a8a3cce2b8	4855000	Tokopedia	https://www.tokopedia.com/yoestore/amd-ryzen-7-5700g-8-cores-16-threads-radeon-vega-8	2022-03-21 14:34:17.666535+00	2022-03-21 14:34:17.666535+00	\N
e882776b-729d-49c7-aa83-8a4aafe5ee26	2f067e16-2206-4c3f-b03e-c9a8a3cce2b8	4830000	Tokopedia	https://www.tokopedia.com/klikgalaxy/amd-ryzen-7-5700g-cezanne-8-cores-16-threads-4-6ghz-am4-processor	2022-03-21 14:36:05.273415+00	2022-03-21 14:36:05.273415+00	\N
9e7a217f-8f2a-4c32-8533-6d36218e712b	e489f2d4-3067-4d24-9621-2d9d1aed5772	1449000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-athlon-3000g-3-5-ghz-box-tanpa-bundling	2022-03-22 13:46:36.486212+00	2022-03-22 13:46:36.486212+00	\N
bf80677a-6683-4d55-8e25-a570a1e1b66b	e489f2d4-3067-4d24-9621-2d9d1aed5772	1399000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-athlon-3000g-3-5-ghz-box	2022-03-22 13:47:54.242266+00	2022-03-22 13:47:54.242266+00	Minimal pembelian 20 unit
47e6e7f5-09cd-4676-b2b9-fb6cd0a3c097	e489f2d4-3067-4d24-9621-2d9d1aed5772	1299000	Tokopedia	https://www.tokopedia.com/oneitsolution/amd-prosesor-athlon-3000g-am4-3-5ghz-cache-4mb-35w	2022-03-22 13:48:35.231298+00	2022-03-22 13:48:35.231298+00	Sis 4 stok ketika pendataan, Pembelian wajib bundle paket rakitan (Mobo,Ram,Storage,PSU,Case)
b9b5ea1b-a085-4f98-8c3e-95acb148f4e9	65b9d6cd-bc07-495e-903e-f7bbc6d78f1a	2454000	Tokopedia	https://www.tokopedia.com/jualkom/amd-ryzen-5-1600af-6-core-am4-3-2ghz-cpu-with-wraith-stealth-cooler?refined=true	2022-03-22 13:50:57.757064+00	2022-03-22 13:50:57.757064+00	\N
b35aafca-f84c-4e9a-b6ed-788a09ee91e5	65b9d6cd-bc07-495e-903e-f7bbc6d78f1a	2454000	Tokopedia	https://www.tokopedia.com/karyacitra/amd-ryzen-5-1600af-6-core-am4-3-2ghz-cpu-with-wraith-stealth-cooler?refined=true	2022-03-22 13:51:42.110731+00	2022-03-22 13:51:42.110731+00	\N
9624d30e-e1b0-4a76-ad49-d92575cea7f1	d8d9c336-833b-4e2e-b626-99738a388f77	3990000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-amd-ryzen-5-3400g-3-7-ghz-box	2022-03-22 13:54:37.288265+00	2022-03-22 13:54:37.288265+00	\N
d8ac30c2-cdfb-4b3c-84fd-29242c0a2f2c	d8d9c336-833b-4e2e-b626-99738a388f77	3899000	Tokopedia	https://www.tokopedia.com/queenprocessor/amd-ryzen-5-3400g-4-core-3-7ghz-rx-vega-11-graphics-socket-am4	2022-03-22 13:57:55.75202+00	2022-03-22 13:57:55.75202+00	Wajib bundling dengan Motherboard B550M STEEL LEGEND, SSD ACE POWER 256GB, RAM  ADATA 8GB, Power Supply FRACTAL DESIGN ION SFX-L 500W 80+ GOLD PRODUCT OF UK
db1edd25-d455-4ea1-9fc6-731701438339	07b8103c-bbcd-4983-acc1-726ad47c7929	9500000	Tokopedia	https://www.tokopedia.com/jujogamingshop/intel-core-i9-10900x-3-7ghz-up-to-4-5ghz-lga-2066-garansi-resmi?refined=true	2022-03-23 14:05:19.948598+00	2022-03-23 14:05:19.948598+00	Sisa 7 stok ketika pendataan
e7793254-dfe6-4713-9fb5-f5efde7784a8	07b8103c-bbcd-4983-acc1-726ad47c7929	7365000	Tokopedia	https://www.tokopedia.com/lezzcom/intel-core-i9-10900x-cascade-lake-x-lga-2066-10-core?refined=true	2022-03-23 14:05:54.243827+00	2022-03-23 14:05:54.243827+00	Sisa 2 stok ketika pendataan
769f71f0-729b-4bc0-a17b-ebefcba098c7	07b8103c-bbcd-4983-acc1-726ad47c7929	9599000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-10900x-3-7-ghz-box-socket-2066-new-item?refined=true	2022-03-23 14:06:24.964744+00	2022-03-23 14:06:24.964744+00	\N
05831760-a326-49b6-a5f6-b12a71752707	fab81423-ac47-45a2-9b05-1303db1c14cd	9899000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-10920x-3-5-ghz-box-12-core-socket-2066?refined=true	2022-03-23 14:10:50.060053+00	2022-03-23 14:10:50.060053+00	Box
50faadc5-3e65-48fb-a5bd-f0aadf6f8fb0	fab81423-ac47-45a2-9b05-1303db1c14cd	10718000	Tokopedia	https://www.tokopedia.com/prodigicom/processor-intel-core-i9-10920x-x-series-3-50ghz-19-25m-lga-2066-box?refined=true	2022-03-23 14:11:48.658532+00	2022-03-23 14:11:48.658532+00	Box
18891d67-f857-45e3-b2cb-ade88a76c1ce	fab81423-ac47-45a2-9b05-1303db1c14cd	10900000	Tokopedia	https://www.tokopedia.com/angelinastore07/prosesor-intel-core-i9-10920x-seri-x-cache-19-25-m-3-50-ghz?refined=true	2022-03-23 14:12:13.923299+00	2022-03-23 14:12:13.923299+00	\N
b986c9fb-b850-47d8-a05a-b3f150888eea	88a6b713-4b68-48a5-9bbe-3911cabbeb57	11199000	Tokopedia	https://www.tokopedia.com/nanokomputer/processor-intel-core-i9-10940x-cascade-lake-x-lga-2066-14-core	2022-03-23 14:14:29.578643+00	2022-03-23 14:14:29.578643+00	Sisa stok 2 ketika pendataan
27e3ef8e-0295-4b9c-84ab-6ef27577f6e1	88a6b713-4b68-48a5-9bbe-3911cabbeb57	13456000	Tokopedia	https://www.tokopedia.com/klikgalaxy/processor-intel-core-i9-10940x-cascade-lake-x-lga-2066-14-core	2022-03-23 14:15:07.321628+00	2022-03-23 14:15:07.321628+00	
3c03eaa5-aecf-4b46-b580-797de986a5eb	88a6b713-4b68-48a5-9bbe-3911cabbeb57	12238000	Tokopedia	https://www.tokopedia.com/prodigicom/processor-intel-core-i9-10940x-x-series-3-30ghz-19-25m-lga-2066-box	2022-03-23 14:15:30.186497+00	2022-03-23 14:15:30.186497+00	\N
7cd464be-9fb4-4a50-b851-06a8a37c2f8c	a54e256e-acf0-46c8-8e60-116fa47ff0dc	16499000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-10980xe-extreme-edition-box	2022-03-23 14:17:33.390655+00	2022-03-23 14:17:33.390655+00	Box, sisa 2 stok ketika pendataan
c5749555-c66f-4217-ba53-746e378c4dee	a54e256e-acf0-46c8-8e60-116fa47ff0dc	16550000	Tokopedia	https://www.tokopedia.com/pazcom/intel-core-i9-10980xe-extreme-processor-24-75m-cache	2022-03-23 14:20:24.267113+00	2022-03-23 14:20:24.267113+00	sisa 3 stok ketika pendataan
94d6a82a-b1ca-406e-92ae-00c3ee4f6590	a54e256e-acf0-46c8-8e60-116fa47ff0dc	18064000	Tokopedia	https://www.tokopedia.com/klikgalaxy/intel-core-i9-10980xe-cascade-lake-x-lga-2066-18-core	2022-03-23 14:20:58.559379+00	2022-03-23 14:20:58.559379+00	\N
e682b44d-1df8-4ad1-8964-8dfe7ff988d6	9461c630-19af-4dc0-bf21-825d82ff1b01	2300000	Tokopedia	https://www.tokopedia.com/distributorpc/intel-core-i3-10300-4-cores-8-threads-processor-lga-1200?refined=true	2022-03-23 14:25:36.726286+00	2022-03-23 14:25:36.726286+00	sisa 9 stok ketika pendataan
2ccd9b0d-e741-41a7-ae49-7c7bbfc69580	9461c630-19af-4dc0-bf21-825d82ff1b01	2300000	Tokopedia	https://www.tokopedia.com/d-m-i/processor-intel-core-i3-10300-8m-cache-up-to-4-40ghz-box-socket-1200?refined=true	2022-03-23 14:31:45.294625+00	2022-03-23 14:31:45.294625+00	Sisa 2 stok ketika pendataan
add7c865-77f6-41d2-b822-218a67705a05	9461c630-19af-4dc0-bf21-825d82ff1b01	2315000	Tokopedia	https://www.tokopedia.com/maxcom-computer/intel-processor-i3-10300-comet-lake-quad-core-3-7-ghz-lga-1200-65w?refined=true	2022-03-23 14:32:04.713622+00	2022-03-23 14:32:04.713622+00	\N
175fc4f9-8cc9-4527-b1e6-0e46271fe8e1	79d7498b-5f6b-4684-bc1c-abc76f8c7b9f	1590000	Shopee	https://shopee.co.id/Processor-Intel-Core-i3-10100-3.6Ghz-Box-socket-1200-NEW-i.28679071.7147420979?sp_atk=5712f855-5a48-48aa-b909-107d31dee1d5	2022-03-23 14:33:35.755745+00	2022-03-23 14:33:35.755745+00	Box
c2c20bad-17b9-4102-9b21-0a99725b510d	79d7498b-5f6b-4684-bc1c-abc76f8c7b9f	1569000	Shopee	https://shopee.co.id/Processor-Intel-Core-i3-10100-3.6-GHz-Box-Socket-1200-New-Item-i.265698488.4040292959?sp_atk=fc7e86ec-4228-44d9-a08f-fcbd6d726a98	2022-03-23 14:33:59.515316+00	2022-03-23 14:33:59.515316+00	\N
f6835a59-b854-4c1c-849b-c0e6f79f0bc5	79d7498b-5f6b-4684-bc1c-abc76f8c7b9f	1569000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i3-10100-3-6-ghz-box-socket-1200-new-item?refined=true	2022-03-23 14:35:14.692384+00	2022-03-23 14:35:14.692384+00	\N
a27bf90e-6eaa-481a-9ea1-3f9d8f95a38b	79d7498b-5f6b-4684-bc1c-abc76f8c7b9f	1644000	Tokopedia	https://www.tokopedia.com/enterkomputer/intel-core-i3-10100-3-6ghz-up-to-4-3ghz-box-lga-1200?refined=true	2022-03-23 14:35:32.033886+00	2022-03-23 14:35:32.033886+00	\N
5072a21f-3311-4a61-b29f-0b50a7906fff	79d7498b-5f6b-4684-bc1c-abc76f8c7b9f	1529000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i3-10100-3-60-ghz-tray-socket-1200-fan?refined=true	2022-03-23 14:35:51.781741+00	2022-03-23 14:35:51.781741+00	\N
ad31491b-b890-4984-9b71-5037c29358e2	79d7498b-5f6b-4684-bc1c-abc76f8c7b9f	1730000	Tokopedia	https://www.tokopedia.com/supply-drop/processor-intel-core-i3-10100-3-6-ghz-box-socket-1200?src=topads	2022-03-23 14:36:29.5854+00	2022-03-23 14:36:29.5854+00	Box
19f0b2ce-b7b2-4131-bcbf-d9a3e134b438	c3ab527d-786d-4674-8e89-d593744caf0e	1059000	Shopee	https://shopee.co.id/PROCESSOR-INTER-CORE-i3-10105F-3.7-GHz-BOX-SOCKET-1200-i.265698488.6180128505?sp_atk=c2499e3d-eee9-4246-9d5e-34b5047a71f0	2022-03-23 14:46:59.943218+00	2022-03-23 14:46:59.943218+00	Box
5f6c3434-0bc1-44ba-bb24-b851820e3602	c3ab527d-786d-4674-8e89-d593744caf0e	1126000	Shopee	https://shopee.co.id/Intel-Core-i3-10105F-LGA1200-4-Core-8-Thread-Comet-Lake-i.135105440.7880367232?sp_atk=2c54aa68-f3b7-4ffd-babd-dcc1c31e61ab	2022-03-23 14:47:21.301315+00	2022-03-23 14:47:21.301315+00	\N
5ffe96be-c5db-4449-a5a8-8a96019cb195	c3ab527d-786d-4674-8e89-d593744caf0e	1059000	Shopee	https://shopee.co.id/Processor-Intel-Core-I3-10105F-Box-Comet-Lake-Socket-LGA-1200-i.15607053.8917570064?sp_atk=b1ce681b-6224-4c55-a3d9-6b2099ab761c	2022-03-23 14:47:39.758065+00	2022-03-23 14:47:39.758065+00	\N
3bfbf3ad-c400-4d50-8c21-30fe9ae80fa6	c3ab527d-786d-4674-8e89-d593744caf0e	1059000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-inter-core-i3-10105f-3-7-ghz-box-socket-1200	2022-03-23 14:49:42.57662+00	2022-03-23 14:49:42.57662+00	Box
3f17e050-d51e-44a8-b9c4-aea0cfc1dd23	c3ab527d-786d-4674-8e89-d593744caf0e	1059000	Tokopedia	https://www.tokopedia.com/ptmmg/processor-intel-core-i3-10105f-lga1200-box?whid=13037772	2022-03-23 14:50:20.984399+00	2022-03-23 14:50:20.984399+00	Box
93589aed-7959-4218-95c8-d65081287262	c3ab527d-786d-4674-8e89-d593744caf0e	1059000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i3-10105f-box-comet-lake-socket-lga-1200	2022-03-23 14:51:17.48493+00	2022-03-23 14:51:17.48493+00	Diskon 14%, harga asli 1235000
f86279bb-ab3c-4f13-bd26-912f4f26e390	ce04f119-5220-487c-ab02-248eb82227f9	1929999	Shopee	https://shopee.co.id/Intel-Core-i5-10400-2.9Ghz-Up-To-4.3Ghz-Box-i.19942575.3237172443?sp_atk=e7c818ce-3c3b-401e-aa14-9eb8afee6bff	2022-03-23 14:56:15.971889+00	2022-03-23 14:56:15.971889+00	Box
bab56186-896c-474a-bd53-5bd226daa267	ce04f119-5220-487c-ab02-248eb82227f9	2050000	Shopee	https://shopee.co.id/Processor-Intel-Core-I5-10400-Box-Comet-Lake-Socket-LGA-1200-i.15607053.5536807058?sp_atk=cda71e24-d793-4466-a69e-4374fe8f5971	2022-03-23 14:56:38.889148+00	2022-03-23 14:56:38.889148+00	\N
377e926c-ec09-4b96-ad8a-ff221f5c0de2	ce04f119-5220-487c-ab02-248eb82227f9	1940000	Shopee	https://shopee.co.id/Processor-Intel-Core-i5-10400-LGA-1200-Box-i.14954873.7938711434?sp_atk=86afd67c-7e6f-460e-9298-ad7734fb74b0	2022-03-23 14:57:10.547704+00	2022-03-23 14:57:10.547704+00	Box
308457e1-464f-4058-8e22-c96491b0004e	ce04f119-5220-487c-ab02-248eb82227f9	1949000	Shopee	https://shopee.co.id/Processor-Intel-core-i5-10400-2.9-GHz-BOX-Socket-1200-NEW-ITEM-!!!-i.265698488.4144305316?sp_atk=866fd261-9384-4cfc-9ba8-0a2adc290f27	2022-03-23 14:57:33.814419+00	2022-03-23 14:57:33.814419+00	Box
9e2b92cb-bd6f-4aef-91e2-72f2d771fcf2	ce04f119-5220-487c-ab02-248eb82227f9	1938000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i5-10400-2-9-ghz-box-socket-1200-new-item?refined=true	2022-03-23 15:00:31.595858+00	2022-03-23 15:00:31.595858+00	\N
fd2e4e42-1030-4f88-a211-1c8c2b70829c	ce04f119-5220-487c-ab02-248eb82227f9	1919000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i5-10400-2-9-ghz-tray-fan?refined=true&whid=13325	2022-03-23 15:00:52.516256+00	2022-03-23 15:00:52.516256+00	+ fan
d634f52a-e1de-4404-bf3a-fa611a55137c	ce04f119-5220-487c-ab02-248eb82227f9	1940000	Tokopedia	https://www.tokopedia.com/it-shoponline/processor-intel-core-i5-10400-lga-1200-box?refined=true&whid=13325	2022-03-23 15:01:15.460215+00	2022-03-23 15:01:15.460215+00	Box
288fa270-6a10-47a0-a444-9da8de3b09e3	4e791b4c-4d6c-4981-a02f-32e89680bd0d	1790000	Shopee	https://shopee.co.id/Processor-Intel-Core-I5-10400F-Box-Comet-Lake-Socket-LGA-1200-i.15607053.3941271253?sp_atk=0b900b12-e524-4713-a654-88ba2978c6db	2022-03-23 15:04:13.889056+00	2022-03-23 15:04:13.889056+00	Box
8e875abe-956a-4734-8036-b57e1be55fd3	4e791b4c-4d6c-4981-a02f-32e89680bd0d	1759999	Shopee	https://shopee.co.id/Intel-Core-i5-10400F-2.9Ghz-Up-To-4.3Ghz-Box-i.19942575.7143720603?sp_atk=60fac6b5-b1e7-4912-9fc7-ecddefe8787f	2022-03-23 15:04:31.00046+00	2022-03-23 15:04:31.00046+00	Box
5b718b06-013f-4266-8fbe-4121dc9921bd	4e791b4c-4d6c-4981-a02f-32e89680bd0d	1770000	Shopee	https://shopee.co.id/Processor-Intel-Core-i5-10400F-LGA-1200-Box-i.14954873.3338813039?sp_atk=7ee5da80-ccd3-45c2-a082-e3f7848d9724	2022-03-23 15:05:03.723023+00	2022-03-23 15:05:03.723023+00	Box
169c4a26-5aba-43b9-8c03-8b3961e1e3d9	4e791b4c-4d6c-4981-a02f-32e89680bd0d	1770000	Tokopedia	https://www.tokopedia.com/it-shoponline/processor-intel-core-i5-10400f-lga-1200-box?whid=13325	2022-03-23 15:05:26.688994+00	2022-03-23 15:05:26.688994+00	Box
ff7dba0b-16d9-4173-9b9e-d4de0d20002c	4e791b4c-4d6c-4981-a02f-32e89680bd0d	1788000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i5-10400f-2-9-ghz-box-socket-1200-new-item?whid=12619185	2022-03-23 15:05:57.864037+00	2022-03-23 15:05:57.864037+00	Box
369c44a3-e736-4218-a83f-b06e57cbc7a2	4e791b4c-4d6c-4981-a02f-32e89680bd0d	1790000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i5-10400f-box-comet-lake-socket-lga-1200?whid=12619185	2022-03-23 15:06:28.400311+00	2022-03-23 15:06:28.400311+00	diskon 14%, harga asli 2080000
ff92bb1a-8111-4b24-bddb-489e3d54b4c8	c2ff6453-c5f2-40d3-a3c8-e607aef37675	3171000	Shopee	https://shopee.co.id/Intel-Core-i5-10500-i.746822.6236415105?sp_atk=6dc9f7a8-1116-4942-bb5b-398b17ce6eae	2022-03-23 15:07:56.536283+00	2022-03-23 15:07:56.536283+00	\N
3f3a57ba-65fe-4f9c-9534-15adbefaff60	c2ff6453-c5f2-40d3-a3c8-e607aef37675	3135000	Shopee	https://shopee.co.id/Processor-Intel-Core-I5-10500-Box-Comet-Lake-Socket-LGA-1200-i.15607053.4436808673?sp_atk=e29e3797-859a-4541-94bd-de878517c16b	2022-03-23 15:08:28.035963+00	2022-03-23 15:08:28.035963+00	Box
3b7e50cd-d407-4396-ab30-572a088b36d4	c2ff6453-c5f2-40d3-a3c8-e607aef37675	3399999	Shopee	https://shopee.co.id/Intel-Core-i5-10500-3.1Ghz-Up-To-4.5Ghz-Box-i.19942575.7037007839?sp_atk=e992f73f-8e4a-4fb1-9748-31326da0f89e	2022-03-23 15:08:46.629201+00	2022-03-23 15:08:46.629201+00	Box
e884bc2f-37b6-46db-bbf4-5bb627289122	c2ff6453-c5f2-40d3-a3c8-e607aef37675	2999000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i5-10500-3-1-ghz-box-socket-1200-new-item?refined=true	2022-03-23 15:09:49.832894+00	2022-03-23 15:09:49.832894+00	Box
78745ee5-d9d1-4ee5-ac39-25be1b942764	c2ff6453-c5f2-40d3-a3c8-e607aef37675	3199000	Tokopedia	https://www.tokopedia.com/yoestore/intel-core-i5-10500-gen-10?refined=true	2022-03-23 15:10:48.511206+00	2022-03-23 15:10:48.511206+00	sisa 5 stok ketika pendataan
b5375323-062c-4cce-a2b2-16bc96f3ed4e	cac27627-7f0c-454a-9474-7ce4a6301786	5080000	Shopee	https://shopee.co.id/Processor-Intel-Core-I7-11700K-Box-Rocket-Lake-Socket-LGA-1200-i.15607053.6782850584?sp_atk=1ce7306a-9645-4999-90ca-b668b2ecf8f8	2022-03-23 15:12:24.982184+00	2022-03-23 15:12:24.982184+00	Box
232b8fdb-cecd-47c1-a85e-4ecb7c6a5eb7	cac27627-7f0c-454a-9474-7ce4a6301786	5144000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i7-11700k-3-6ghz-rocket-lake-8-core-16-thread-lga1200-box	2022-03-23 15:13:22.262179+00	2022-03-23 15:13:22.262179+00	Box
46d6af45-4b07-413d-a1d9-ffc6e040955f	cac27627-7f0c-454a-9474-7ce4a6301786	4925000	Tokopedia	https://www.tokopedia.com/supply-drop/intel-core-i7-11700k-3-6ghz-up-tray-fan-lga-1200-garansi-3-tahun?src=topads	2022-03-23 15:13:42.074347+00	2022-03-23 15:13:42.074347+00	Tray + fan
d77b16c1-e04a-416f-8d5e-a7977f26e8ce	cac27627-7f0c-454a-9474-7ce4a6301786	4898000	Tokopedia	https://www.tokopedia.com/supply-drop/intel-core-i7-11700k-3-6ghz-up-tray-lga-1200-garansi-3-tahun?src=topads	2022-03-23 15:14:21.255829+00	2022-03-23 15:14:21.255829+00	Tray
a67e40af-1b0a-4821-a1e7-20b24b382ecc	dec4612a-9926-45a9-b400-46ce2eaa892f	3433000	Shopee	https://shopee.co.id/Intel-Core-i5-10600-i.746822.5336416621?sp_atk=800f1300-242e-4c64-895f-70d4bb0b87bb	2022-03-23 15:16:08.576985+00	2022-03-23 15:16:08.576985+00	\N
b0f61b3b-f7e9-4522-a0ef-51bccda2f7c5	dec4612a-9926-45a9-b400-46ce2eaa892f	3388000	Shopee	https://shopee.co.id/Processor-Intel-core-i5-10600-3.3-GHz-BOX-Socket-1200-NEW-ITEM-!!!-i.265698488.7444295472?sp_atk=f5c5b0b0-df62-44b6-a368-7d9743fd3a96	2022-03-23 15:16:33.869918+00	2022-03-23 15:16:33.869918+00	Box
4836491c-a574-445f-822d-b09753b550e2	dec4612a-9926-45a9-b400-46ce2eaa892f	3388000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i5-10600-3-3-ghz-box-socket-1200-new-item?refined=true	2022-03-23 15:17:15.20108+00	2022-03-23 15:17:15.20108+00	Box
6eccace5-a43a-4b8a-a59b-669ae27d4cd8	dec4612a-9926-45a9-b400-46ce2eaa892f	3399000	Tokopedia	https://www.tokopedia.com/cockomputer/intel-core-i5-10600?refined=true	2022-03-23 15:17:32.848267+00	2022-03-23 15:17:32.848267+00	\N
3f20a7ce-3cb6-4a06-95c5-0ac418586849	dec4612a-9926-45a9-b400-46ce2eaa892f	3395000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i5-10600-box-comet-lake-socket-lga-1200?refined=true	2022-03-23 15:19:17.971775+00	2022-03-23 15:19:17.971775+00	Box
5d3ae0da-8636-41ef-a8d5-f7c093ef1876	89e235d8-c24f-4de7-befa-4e80e8ea2872	5599000	Shopee	https://shopee.co.id/Processor-Intel-core-i9-10900F-2.8-GHz-BOX-Socket-1200-NEW-ITEM-!!!-i.265698488.5567198186?sp_atk=11501213-6b98-4e8b-88cd-6188991ab9de	2022-03-24 12:57:04.469567+00	2022-03-24 12:57:04.469567+00	\N
2868a43e-b59a-4f2b-a0b8-1b9b896c37ef	89e235d8-c24f-4de7-befa-4e80e8ea2872	5700000	Shopee	https://shopee.co.id/Processor-Intel-Core-I9-10900F-Box-Comet-Lake-Socket-LGA-1200-i.15607053.5067645216?sp_atk=676850fe-aa8f-468e-9f75-8f35335404ce	2022-03-24 12:57:23.128105+00	2022-03-24 12:57:23.128105+00	\N
d9c0e514-7ea4-45a2-844b-520cfcb67d2f	89e235d8-c24f-4de7-befa-4e80e8ea2872	5599000	Tokopedia	tokopedia.com/queenprocessor/processor-intel-core-i9-10900f-2-8-ghz-box-socket-1200-new-item?refined=true	2022-03-24 12:58:14.752724+00	2022-03-24 12:58:14.752724+00	Box
cf93ae99-b282-445c-9890-dd4623be3c90	89e235d8-c24f-4de7-befa-4e80e8ea2872	5789000	Tokopedia	https://www.tokopedia.com/blessingcombali/processor-intel-core-i9-10900f?refined=true	2022-03-24 12:59:01.715937+00	2022-03-24 12:59:01.715937+00	sisa 2 stok saat pendataan
a3110ccc-c1c2-42ae-b5cd-68a92fb1fd90	e454fd8e-948c-4f27-ade4-5ec252bc4880	2179000	Shopee	https://shopee.co.id/INTEL-CORE-I5-11400F-2.6GHz-ROCKET-LAKE-6-CORE-12-THREAD-LGA1200-BOX--i.265698488.9733688047?sp_atk=8755fb81-c545-430f-b39b-b19626ef1a19	2022-03-24 13:02:46.754088+00	2022-03-24 13:02:46.754088+00	Box, sisa 6 stok ketika pendataan
6041bd62-9ded-480c-ba84-9097d94428a9	e454fd8e-948c-4f27-ade4-5ec252bc4880	2179000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i5-11400f-2-6ghz-rocket-lake-6-core-12-thread-lga1200-box?whid=13325	2022-03-24 13:03:20.858964+00	2022-03-24 13:03:20.858964+00	Box
857c6f0f-63c8-4bb2-a7dd-e007a5820d33	e454fd8e-948c-4f27-ade4-5ec252bc4880	2349000	Tokopedia	https://www.tokopedia.com/nanokomputer/intel-core-i5-11400f-processor-intel-gen-11-lga-1200-6-core?whid=13325	2022-03-24 13:03:51.538566+00	2022-03-24 13:03:51.538566+00	Fan included
4a8b8754-098f-4799-a1b5-07b0b0248c8a	693193cd-0851-4e52-a92d-2776ad18f777	4128000	Shopee	https://shopee.co.id/Processor-Intel-Core-I7-10700-Box-Comet-Lake-Socket-LGA-1200-i.15607053.6437491843?sp_atk=7ca3c6ad-44c0-4eb9-894a-c6e9ba918087	2022-03-24 13:06:37.652726+00	2022-03-24 13:06:37.652726+00	Box
1a728cc1-602e-46f5-adb5-74f6c64fb9d0	693193cd-0851-4e52-a92d-2776ad18f777	4129000	Shopee	https://shopee.co.id/Processor-Intel-core-i7-10700-2.9-GHz-BOX-Socket-1200-NEW-ITEM-!!!-i.265698488.6751486600?sp_atk=a18ebdf4-c1fa-48b9-9d1e-bf5abe0f913a	2022-03-24 13:06:56.949492+00	2022-03-24 13:06:56.949492+00	Box
8612e0d2-953b-4a32-b5cb-17a4bb7db2b4	693193cd-0851-4e52-a92d-2776ad18f777	4129000	Shopee	https://shopee.co.id/Intel-Core-i7-10700-2.90GHz-8Core-16Thread-Gen-10-Comet-Lake-LGA-1200-i.33644099.7338389368?sp_atk=1752c8fe-7d5d-4c57-9989-eb234d4b83c2	2022-03-24 13:07:30.037109+00	2022-03-24 13:07:30.037109+00	Sisa 2 stok ketika pendataan
2076967d-bc80-4a68-bd1f-ff229a5d10a7	693193cd-0851-4e52-a92d-2776ad18f777	4129000	Shopee	https://shopee.co.id/Intel-Core-i7-10700-2.90GHz-8Core-16Thread-Gen-10-Comet-Lake-LGA-1200-i.8687183.5638699239?sp_atk=9c63d51f-0871-487f-8a41-41e08a5f2d32	2022-03-24 13:07:59.689306+00	2022-03-24 13:07:59.689306+00	\N
79c24b44-5277-4869-80e8-fd59dcc9ba64	693193cd-0851-4e52-a92d-2776ad18f777	4129000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-10700-2-9-ghz-box-socket-1200-new-item?refined=true	2022-03-24 13:08:22.467273+00	2022-03-24 13:08:22.467273+00	Box
e1e1f7a7-df74-4cba-8d01-1bec9cb8d36f	693193cd-0851-4e52-a92d-2776ad18f777	4639000	Tokopedia	https://www.tokopedia.com/nanokomputer/processor-intel-core-i7-10700-comet-lake-s-lga-1200-8-core-gen-10-ff8f?refined=true	2022-03-24 13:08:44.805485+00	2022-03-24 13:08:44.805485+00	\N
2c81273f-9df1-4ee3-ba77-733472b7b4c3	693193cd-0851-4e52-a92d-2776ad18f777	4140000	Tokopedia	https://www.tokopedia.com/it-shoponline/processor-intel-core-i7-10700-lga-1200-box?refined=true&whid=13325	2022-03-24 13:09:13.235553+00	2022-03-24 13:09:13.235553+00	Box, sisa 4 stok ketika pendataan
a476c59d-57e5-4282-a55b-8e926886c443	5992c1ad-20b1-4b24-81bb-7ffd4dbaf8f3	4500000	Shopee	https://shopee.co.id/Processor-Intel-Core-I7-10700KF-Box-Comet-Lake-Socket-LGA-1200-i.15607053.4548890905?sp_atk=7b6a95e0-4f0e-4006-81a9-62d5e13425f4	2022-03-24 13:12:37.724631+00	2022-03-24 13:12:37.724631+00	Box
063612f1-5ff3-4811-9398-eeb7a0208e38	5992c1ad-20b1-4b24-81bb-7ffd4dbaf8f3	4535000	Shopee	https://shopee.co.id/Intel-Core-i7-10700KF-3.8Ghz-Up-To-5.1Ghz-Cache-16MB-Box-Socket-LGA-1200-Comet-Lakeee-i.43570421.7744238080?sp_atk=5f91d3ab-da6b-49ef-9296-c09c310e764c	2022-03-24 13:13:28.366869+00	2022-03-24 13:13:28.366869+00	Box
1894a139-dc5d-4bcc-91d2-c33cf6d6b24f	5992c1ad-20b1-4b24-81bb-7ffd4dbaf8f3	4558000	Tokopedia	https://www.tokopedia.com/enterkomputer/intel-core-i7-10700kf-3-8ghz-up-to-5-1ghz-box-socket-lga-1200?refined=true	2022-03-24 13:15:05.400424+00	2022-03-24 13:15:05.400424+00	Box
2bfb6478-0cb7-48ed-9304-47b4d090218d	5992c1ad-20b1-4b24-81bb-7ffd4dbaf8f3	4349000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-10700kf-3-8-ghz-box-socket-1200-new-item?refined=true	2022-03-24 13:15:42.018415+00	2022-03-24 13:15:42.018415+00	Box
9e49aab9-b355-4299-afbf-b8a99d59f238	21a4c4d7-e970-4b25-b27b-6fd93f31ed87	7199000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-10850k-3-6ghz-cache-20mb-box-lga-1200?refined=true	2022-03-24 13:19:26.151296+00	2022-03-24 13:19:26.151296+00	Box
4fec7424-18a1-45c5-b160-538a05e20846	21a4c4d7-e970-4b25-b27b-6fd93f31ed87	6099000	Tokopedia	https://www.tokopedia.com/ampmexpress/processor-intel-core-i9-10850k-3-6ghz-cache-20mb?refined=true	2022-03-24 13:20:18.540239+00	2022-03-24 13:20:18.540239+00	Sisa 7 stok ketika pendataan
6c55bbaf-e729-460f-8789-947761b698d7	84a773e7-1ec0-46a7-b6f0-7bfc522e8a61	5799000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-10900-2-8-ghz-box-socket-1200-new-item?refined=true	2022-03-26 02:34:59.379869+00	2022-03-26 02:34:59.379869+00	Box
b164df39-99c5-46b6-9b10-04ac167186a2	84a773e7-1ec0-46a7-b6f0-7bfc522e8a61	5990000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i9-10900-2-8-ghz-box-socket-1200-new-item?refined=true	2022-03-26 02:35:40.601072+00	2022-03-26 02:35:40.601072+00	Box
30ffd1b6-e2ab-48c8-a278-251f3bbe5421	18899a96-ac6d-4f52-85f8-aab8a5fd2d8e	5849000	Shopee	https://shopee.co.id/Processor-Intel-core-i9-10900KF-3.7-GHz-BOX-Socket-1200-NEW-ITEM-!!!-i.265698488.3870532240?sp_atk=05e0fdda-6648-4136-a4e5-4c980f5bbc6f	2022-03-26 02:39:22.444689+00	2022-03-26 02:39:22.444689+00	Box
eef59a4e-ff56-4daa-9244-11dc8f86ceec	18899a96-ac6d-4f52-85f8-aab8a5fd2d8e	5849000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-10900kf-3-7-ghz-box-socket-1200-new-item?refined=true&whid=13037760	2022-03-26 02:39:47.204217+00	2022-03-26 02:39:47.204217+00	Box
145f9d0b-74e9-4b73-ba76-6251bbc8cd23	0ef2e45c-f4da-4f44-b8da-47293162ad9b	1595000	Shopee	https://shopee.co.id/Processor-Intel-Core-i3-10105-LGA-1200-Box-i.14954873.7438726581?sp_atk=0f9bd365-4e9e-459d-b2ed-755dc7e78c49	2022-03-26 02:41:33.654743+00	2022-03-26 02:41:33.654743+00	Box
c737e288-7358-45a2-8a89-1b0371d056d3	0ef2e45c-f4da-4f44-b8da-47293162ad9b	1585000	Shopee	https://shopee.co.id/Intel-Core-i3-10105-3.7GHz-Up-To-4.4GHz-Box-Socket-LGA1200-i.14305724.9485230829?sp_atk=a9eed0fd-f072-4dbc-ab27-ebbd47e06995	2022-03-26 02:45:29.481091+00	2022-03-26 02:45:29.481091+00	Box
f16cd935-e24c-452b-ad7f-169ed228ba91	0ef2e45c-f4da-4f44-b8da-47293162ad9b	1656000	Shopee	https://shopee.co.id/Intel-Core-i3-10105-3.7Ghz-Up-To-4.4Ghz-Box-Socket-LGA-1200-i.43570421.8160285895?sp_atk=2b9545de-3e22-4100-9737-e2881af46af6	2022-03-26 02:45:47.370553+00	2022-03-26 02:45:47.370553+00	Box
027ec89e-b996-4a3b-bc0d-ae3c21438c1c	0ef2e45c-f4da-4f44-b8da-47293162ad9b	1647000	Shopee	https://shopee.co.id/Intel-Core-i3-10105-4-Cores-8-Threads-4.3Ghz-Comet-Lake-Processor-i.22145472.10606912865?sp_atk=4ce9fdb7-dd4b-4e5d-a31e-bc60edfc9d40	2022-03-26 02:46:41.351663+00	2022-03-26 02:46:41.351663+00	\N
c38f1aa4-5a8b-475a-a1f8-984c805d3af1	0ef2e45c-f4da-4f44-b8da-47293162ad9b	1599000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-inter-core-i3-10105-3-7-ghz-box-socket-1200-garansi-3-tahun?refined=true	2022-03-26 02:47:03.849169+00	2022-03-26 02:47:03.849169+00	Box
72276c87-0c6c-4257-a8f6-301ea547c761	58b08999-3f96-48cf-b2db-f0350343abca	3090000	Shopee	https://shopee.co.id/Processor-Intel-Core-I5-10600KF-Box-Comet-Lake-Socket-LGA-1200-i.15607053.5769497692?sp_atk=e2be1378-a614-4cbd-a9c6-b80f03028195	2022-03-26 02:57:44.39249+00	2022-03-26 02:57:44.39249+00	\N
f310b630-7385-40e1-862a-32d57b7ce813	58b08999-3f96-48cf-b2db-f0350343abca	3355000	Shopee	https://shopee.co.id/Intel-Core-i5-10600KF-4.1Ghz-Up-To-4.8Ghz-Box-i.19942575.3948998676?sp_atk=09868b25-eee6-4a0b-a869-a493e0dfada6	2022-03-26 02:58:07.759716+00	2022-03-26 02:58:07.759716+00	Box
d818c786-12f7-4d07-8448-13ae18f1c2f3	58b08999-3f96-48cf-b2db-f0350343abca	3049000	Tokopedia	https://www.tokopedia.com/nanokomputer/processor-intel-core-i5-10600kf-comet-lake-s-lga-1200-6-core-gen-10?refined=true	2022-03-26 03:02:10.812192+00	2022-03-26 03:02:10.812192+00	\N
def6f0d9-5d27-43fd-8bb4-35734c871140	58b08999-3f96-48cf-b2db-f0350343abca	3090000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i5-10600kf-box-comet-lake-socket-lga-1200?src=topads	2022-03-26 03:02:36.907149+00	2022-03-26 03:02:36.907149+00	Box
bf6efa99-85d4-435c-b3a1-57c82ffef367	f386038e-931c-4fbf-97a5-3d01f82f596c	5280000	Shopee	https://shopee.co.id/Processor-Intel-core-i7-10700F-2.9-GHz-BOX-Socket-1200-NEW-i.188556305.12734076546?sp_atk=1b9d1e79-2df2-48f8-9b97-0f0011c5362c	2022-03-26 03:12:11.848432+00	2022-03-26 03:12:11.848432+00	Box, sisa 4 stok ketika pendataan
43060b2b-701e-417d-b390-040592c840c6	f386038e-931c-4fbf-97a5-3d01f82f596c	3969000	Shopee	https://shopee.co.id/Intel-Core-i7-10700F-i.746822.5845994174?sp_atk=f5bb8fb8-461e-40a9-82a9-2d00de89b061	2022-03-26 03:13:01.149904+00	2022-03-26 03:13:01.149904+00	\N
b9630124-c625-47fe-a8c5-19167fe720c5	f386038e-931c-4fbf-97a5-3d01f82f596c	3790000	Shopee	https://shopee.co.id/Processor-Intel-Core-i7-10700F-LGA-1200-Box-i.14954873.5139793263?sp_atk=243f8cb0-e5f4-4394-aa3a-a9756b5680f0	2022-03-26 03:13:28.75666+00	2022-03-26 03:13:28.75666+00	Box, sisa 2 stok ketikap pendataan
05797c21-6db0-4738-aa9e-b4135a1d0b0c	f386038e-931c-4fbf-97a5-3d01f82f596c	3789999	Shopee	https://shopee.co.id/Intel-Core-i7-10700F-2.9Ghz-Up-To-4.6Ghz-Box-Comet-Lake-i.19942575.6645107803?sp_atk=babbeca9-b181-4645-a392-4b32b4c55ab0	2022-03-26 03:14:01.20302+00	2022-03-26 03:14:01.20302+00	Box, sisa 9 stok ketika pendataan
3720d7c0-c343-47ff-a986-59a1491ccf5d	f386038e-931c-4fbf-97a5-3d01f82f596c	3775000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-10700f-2-9-ghz-box-socket-1200-new-item?refined=true	2022-03-26 03:14:25.973866+00	2022-03-26 03:14:25.973866+00	Box
ab23dd4e-7d56-453b-836c-8f09123982d9	f386038e-931c-4fbf-97a5-3d01f82f596c	3990000	Tokopedia	https://www.tokopedia.com/nanokomputer/processor-intel-core-i7-10700f-comet-lake-s-lga-1200-8-core-gen-10?refined=true	2022-03-26 03:14:51.39942+00	2022-03-26 03:14:51.39942+00	\N
11cfcce9-a77d-462f-9291-bd7258f5d6f6	65749fa7-357b-441e-924b-f6dcbbfac967	3399000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i5-11600-2-8ghz-rocket-lake-6-core-12-thread-lga1200-box?refined=true	2022-03-26 03:21:23.501074+00	2022-03-26 03:21:23.501074+00	Box
10738a23-4076-4685-b5e3-90e4ae8595d4	65749fa7-357b-441e-924b-f6dcbbfac967	4335000	Tokopedia	https://www.tokopedia.com/starseventeen/intel-core-i5-11600-2-8ghz-up-to-4-8ghz-cache-12mb-box-lga-1200?refined=true	2022-03-26 03:21:52.955667+00	2022-03-26 03:21:52.955667+00	Box
70ab6934-9e9b-4621-bd47-4edad161c871	65749fa7-357b-441e-924b-f6dcbbfac967	3500000	Tokopedia	https://www.tokopedia.com/fondratamiya/processor-intel-core-i5-11600-2-8ghz-rocket-lake-lga1200-box?refined=true	2022-03-26 03:22:32.607971+00	2022-03-26 03:22:32.607971+00	Box, sisa 9 stok ketika pendataan
dc892729-4beb-4261-9648-c2f1373d75b0	184ad42c-39af-4be1-a8a9-bc14d799cf02	3499000	Shopee	https://shopee.co.id/INTEL-CORE-I5-11600K-3.9GHz-ROCKET-LAKE-6-CORE-12-THREAD-LGA1200-BOX--i.265698488.7586131578?sp_atk=d37d158d-2316-4caf-bd6c-e86b7d6e281d	2022-03-26 03:24:13.638562+00	2022-03-26 03:24:13.638562+00	Box, sisa 8 stok ketika pendataan
cadb632f-f358-41f3-8404-3854d02571ab	184ad42c-39af-4be1-a8a9-bc14d799cf02	3690000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i5-11600k-box-rocket-lake-socket-lga-1200?src=topads	2022-03-26 03:24:40.809484+00	2022-03-26 03:24:40.809484+00	Box
9154b762-12ce-4878-96b2-db343b578454	184ad42c-39af-4be1-a8a9-bc14d799cf02	3499000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i5-11600k-3-9ghz-rocket-lake-6-core-12-thread-lga1200-box	2022-03-26 03:25:00.34176+00	2022-03-26 03:25:00.34176+00	Box
1e6b4fb5-838e-4c9c-a496-23b03abadb9c	26eaef1a-f50d-467e-ba64-148f56f4714e	3270000	Shopee	https://shopee.co.id/PROCESSOR-INTEL-CORE-I5-11600KF-ROCKET-LAKE-LGA1200-6-CORES-12-THREAD-i.77540206.5689217105?sp_atk=5f6ed538-466c-485a-8849-fbb0e28a70dd	2022-03-26 03:29:10.559836+00	2022-03-26 03:29:10.559836+00	\N
a924266a-38cb-4c62-bcba-698ff233f310	26eaef1a-f50d-467e-ba64-148f56f4714e	3510000	Shopee	https://shopee.co.id/INTEL-CORE-i5-11600KF-LGA-1200-Gen-11-i.308384815.5386035302?sp_atk=9409f181-26ab-4f6d-b698-014a894b5b1f	2022-03-26 03:29:43.190199+00	2022-03-26 03:29:43.190199+00	sisa 5 stok ketika pendataan
80b4f13d-bd8f-4454-a96e-44bd72f67d68	26eaef1a-f50d-467e-ba64-148f56f4714e	2700000	Tokopedia	https://www.tokopedia.com/vgacrpto/processor-intel-core-i5-11600kf-tray-3-9ghz?src=topads	2022-03-26 03:30:10.284842+00	2022-03-26 03:30:10.284842+00	Tray, sisa 2 stok ketika pendataan
f94b5440-2c65-498e-b489-c1cb7e596d4b	26eaef1a-f50d-467e-ba64-148f56f4714e	3149000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i5-11600kf-3-9ghz-rocket-lake-6-core-12-thread-lga1200-box	2022-03-26 03:30:29.806654+00	2022-03-26 03:30:29.806654+00	Box
2497ab91-cdbf-466d-82f1-4618b39ee657	26eaef1a-f50d-467e-ba64-148f56f4714e	3819000	Tokopedia	https://www.tokopedia.com/nanokomputer/intel-core-i5-11600kf-processor-intel-gen-11-lga-1200-6-core	2022-03-26 03:30:47.970417+00	2022-03-26 03:30:47.970417+00	\N
cf6a0103-1f5b-4246-b5a0-4343acc0aa03	6f027b1e-fb28-4000-8028-1a9a87556da0	5089000	Tokopedia	https://www.tokopedia.com/nanokomputer/intel-core-i7-11700-processor-intel-gen-11-lga-1200-8-core	2022-03-26 11:07:47.178709+00	2022-03-26 11:07:47.178709+00	\N
d2bc8331-09c2-47ed-914a-0c3c4aff045e	6f027b1e-fb28-4000-8028-1a9a87556da0	4549000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i7-11700-2-5ghz-rocket-lake-8-core-16-thread-lga1200-box	2022-03-26 11:08:10.89153+00	2022-03-26 11:08:10.89153+00	Box
82237d42-aaaf-4a18-a879-dff715e21132	6f027b1e-fb28-4000-8028-1a9a87556da0	4449000	Tokopedia	https://www.tokopedia.com/siliconone/intel-processor-core-i7-11700f-box-11700?whid=12666209	2022-03-26 11:08:37.198174+00	2022-03-26 11:08:37.198174+00	Box, sisa 4 stok ketika pendataan
8fe38c45-7d77-4765-9520-c637003e1f31	bd4bb486-f70f-4c70-af73-bec79b7cb4cf	4359000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i7-11700f-2-5ghz-rocket-lake-8-core-16-thread-lga1200-box	2022-03-26 11:10:26.864358+00	2022-03-26 11:10:26.864358+00	Box, sisa 7 stok ketika pendataan
640c8076-441c-41ef-94a2-c20241d20d92	bd4bb486-f70f-4c70-af73-bec79b7cb4cf	4370000	Tokopedia	https://www.tokopedia.com/blessingcombali/processor-intel-core-i7-11700f-rocket-lake-lga-1200	2022-03-26 11:10:51.213793+00	2022-03-26 11:10:51.213793+00	Sisa 2 stok ketika pendataan
44ac50f5-01a6-444a-a635-c412c8278157	bd4bb486-f70f-4c70-af73-bec79b7cb4cf	4449000	Tokopedia	https://www.tokopedia.com/siliconone/intel-processor-core-i7-11700f-box-11700	2022-03-26 11:11:18.501806+00	2022-03-26 11:11:18.501806+00	Box, sisa 4 stok ketika pendataan
c11d2df9-2653-4ba8-bc5b-0e20f585085d	c539ecdc-5fd6-484e-8f7f-1de8081c7ba1	4790000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i7-11700kf-3-6ghz-rocket-lake-8-core-16-thread-lga1200-box?refined=true	2022-03-26 11:13:18.738229+00	2022-03-26 11:13:18.738229+00	Box
6f208c8a-8353-4869-b62b-817c33c9b286	c539ecdc-5fd6-484e-8f7f-1de8081c7ba1	5137000	Tokopedia	https://www.tokopedia.com/jnj77/intel-core-i7-11700kf-3-6ghz-8-core-16-threads-rocket-lake-lga1200?refined=true	2022-03-26 11:13:56.051498+00	2022-03-26 11:13:56.051498+00	Sisa 5 stok ketika pendataan
315ac928-c940-4f64-9121-15cd788872ee	c539ecdc-5fd6-484e-8f7f-1de8081c7ba1	5600000	Tokopedia	https://www.tokopedia.com/nanokomputer/intel-core-i7-11700kf-processor-intel-gen-11-lga-1200-8-core?refined=true	2022-03-26 11:14:18.129671+00	2022-03-26 11:14:18.129671+00	\N
7a6a769f-2a24-4ec2-bcb1-384f4612d844	796c5f61-6466-4671-b3c4-4f9ee7bc4ae6	6299000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i9-11900-2-5ghz-rocket-lake-8-core-16-thread-lga1200-box?refined=true	2022-03-26 11:17:01.525369+00	2022-03-26 11:17:01.525369+00	Box
f7c3184c-06db-4a3b-a9ee-c8264fa199e1	796c5f61-6466-4671-b3c4-4f9ee7bc4ae6	7189000	Tokopedia	https://www.tokopedia.com/nanokomputer/intel-core-i9-11900-processor-intel-gen-11-lga-1200-8-core?refined=true&whid=13037772	2022-03-26 11:17:42.961264+00	2022-03-26 11:17:42.961264+00	\N
940254ef-703f-4d3d-a98c-5b2e3f91f75e	796c5f61-6466-4671-b3c4-4f9ee7bc4ae6	6950000	Tokopedia	https://www.tokopedia.com/jayaprocomputer/processor-intel-core-i9-11900-box-rocket-lake-socket-lga-1200?refined=true&whid=13037772	2022-03-26 11:18:04.503715+00	2022-03-26 11:18:04.503715+00	Box
b7b4c243-5f4c-44f9-ad5b-5d7ae2b40ea4	64efe370-722d-4026-8ac4-818ac9ab1835	6550000	Shopee	https://shopee.co.id/Processor-Intel-Core-I9-11900F-Box-Rocket-Lake-Socket-LGA-1200-i.15607053.6292785074?sp_atk=eb12876c-2f54-4214-b468-8d8a4499b7c7	2022-03-26 11:19:24.440454+00	2022-03-26 11:19:24.440454+00	Box
f3100e10-9606-4324-89f8-86fce2fd22c1	64efe370-722d-4026-8ac4-818ac9ab1835	5899000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i9-11900f-2-5ghz-rocket-lake-8-core-16-thread-lga1200-box?refined=true	2022-03-26 11:19:50.860776+00	2022-03-26 11:19:50.860776+00	Box
23ea8c9e-0258-4cf7-8fb9-54919d4633e0	64efe370-722d-4026-8ac4-818ac9ab1835	7250000	Tokopedia	https://www.tokopedia.com/rakitancom/intel-core-i9-11900f-2-5ghz-rocket-lake-8-core-16-thread-lga1200-box?refined=true	2022-03-26 11:20:33.165745+00	2022-03-26 11:20:33.165745+00	Box, sisa 9 stok ketika pendataan
9d9d5493-4348-4b01-a29f-b753fd5fe732	1eef9ff6-f909-4e35-aa31-f6cb9dc71607	6450000	Shopee	https://shopee.co.id/Processor-Intel-Core-i9-11900K-LGA1200-BOX-CPU-Intel-i9-11900K-LGA-1200-ROCKETLAKE-i.516435798.12810044582?sp_atk=9f12950a-3df4-4bea-9774-4012c5612a39	2022-03-26 11:22:38.908642+00	2022-03-26 11:22:38.908642+00	Box, sisa 4 stok ketika pendataan
7f8b7717-ce18-4e26-808e-f4fea7ef18fd	1eef9ff6-f909-4e35-aa31-f6cb9dc71607	9185000	Shopee	https://shopee.co.id/INTEL-CORE-I9-11900K-3.5GHz-ROCKET-LAKE-8-CORE-16-THREAD-LGA1200-BOX--i.24539943.12511641342?sp_atk=e44908a3-f130-494f-858c-544832b3b84a	2022-03-26 11:23:06.045668+00	2022-03-26 11:23:06.045668+00	Box, sisa 2 stok ketika pendataan
9af28d46-f59a-40f9-b53e-32953ee1af41	1eef9ff6-f909-4e35-aa31-f6cb9dc71607	6349000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i9-11900k-3-5ghz-rocket-lake-8-core-16-thread-lga1200-box	2022-03-26 11:23:25.81864+00	2022-03-26 11:23:25.81864+00	Box
d6d1d83f-db2e-4152-949f-1621f0a70021	1eef9ff6-f909-4e35-aa31-f6cb9dc71607	8697000	Tokopedia	https://www.tokopedia.com/jnj77/intel-core-i9-11900k-3-5ghz-8-core-16-threads-rocket-lake-lga1200	2022-03-26 11:23:53.953542+00	2022-03-26 11:23:53.953542+00	Sisa 7 stok ketika pendataan
9c05bec1-0370-4e13-bda6-6f6115b67325	1eef9ff6-f909-4e35-aa31-f6cb9dc71607	7990000	Tokopedia	https://www.tokopedia.com/gasoldinoyo/intel-core-i9-11900k-8-cores-16-threads-5-3ghz-processor-rocket-lake?src=topads	2022-03-26 11:24:16.844357+00	2022-03-26 11:24:16.844357+00	\N
b1739113-9a6c-4da5-9ef8-e8e3f767ffc0	7226b06d-55fe-4ae0-8ef8-d9b4e054af50	5990000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i9-11900kf-3-5ghz-rocket-lake-8-core-16-thread-lga1200-box?refined=true	2022-03-26 11:25:43.699221+00	2022-03-26 11:25:43.699221+00	Box
9b1240ab-79ad-4b7d-988f-94dd04fcd034	7226b06d-55fe-4ae0-8ef8-d9b4e054af50	6060000	Tokopedia	https://www.tokopedia.com/sportonlineshop/processor-intel-core-i9-11900kf-rocket-lake-lga1200-8-cores-16-thread?refined=true	2022-03-26 11:26:25.763673+00	2022-03-26 11:26:25.763673+00	\N
3b9d6a89-847e-4951-b8c5-47fc0689bbe7	7226b06d-55fe-4ae0-8ef8-d9b4e054af50	8550000	Tokopedia	https://www.tokopedia.com/esportga/intel-core-i9-11900kf-box-8-core-16-thread-5-3ghz-lga-1200-gen-11th?refined=true	2022-03-26 11:26:58.370216+00	2022-03-26 11:26:58.370216+00	Box, sisa 8 stok ketika pendataan
dbfa1995-ec80-48af-bab1-e463ccf7987f	bda2ccb7-38d7-4ded-be20-9234e4271b40	1530000	Tokopedia	https://www.tokopedia.com/tpediapc/intel-core-i3-9100f-3-6ghz-up-to-4-2ghz-box-socket-lga-1151?refined=true	2022-03-27 03:16:47.409739+00	2022-03-27 03:16:47.409739+00	Box
83743861-30e3-4e0e-ab54-52c9976b0659	bda2ccb7-38d7-4ded-be20-9234e4271b40	1499000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i3-9100f-3-6ghz-socket-1151-box?refined=true	2022-03-27 03:17:14.58337+00	2022-03-27 03:17:14.58337+00	Box
b4e0c94d-2085-4e1f-813b-eda44f0d73e9	5b347256-f2c5-4f42-b0dc-41dce997d605	3625000	Shopee	https://shopee.co.id/Processor-Intel-Core-I5-10600K-Box-Comet-Lake-Socket-LGA-1200-i.15607053.3968096680?sp_atk=4c8ba550-fcef-4163-bc13-46f2ec0759a1	2022-03-27 03:21:20.607329+00	2022-03-27 03:21:20.607329+00	Box
0386957a-4746-465e-863c-f0cba7c6e76d	5b347256-f2c5-4f42-b0dc-41dce997d605	3449000	Shopee	https://shopee.co.id/Processor-Intel-core-i5-10600K-4.1-GHz-BOX-Socket-1200-NEW-ITEM-!!!-i.265698488.4443092296?sp_atk=d3c68b82-0263-463b-98b6-71f2cceaf41f	2022-03-27 03:21:43.14957+00	2022-03-27 03:21:43.14957+00	Box
e2619f07-ced8-4d44-a5e7-5aa8221ed732	5b347256-f2c5-4f42-b0dc-41dce997d605	3625000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i5-10600k-box-comet-lake-socket-lga-1200?src=topads	2022-03-27 03:22:25.365198+00	2022-03-27 03:22:25.365198+00	Box
b2b1b7c0-60e7-4d8d-8daf-e5c13bab3bd1	5b347256-f2c5-4f42-b0dc-41dce997d605	3449000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i5-10600k-4-1-ghz-box-socket-1200-new-item?refined=true	2022-03-27 03:22:57.597908+00	2022-03-27 03:22:57.597908+00	Box
722effcf-ef3e-46fe-8dc1-833fa04af56c	3fd17ea9-e236-4aaa-8d37-366a1af3f887	5990000	Shopee	https://shopee.co.id/Processor-Intel-core-i9-10900K-3.7-GHz-BOX-Socket-1200-new-i.265698488.7543083004?sp_atk=447a36b0-4122-4cb2-a99b-66e8934a4f0c	2022-03-27 03:30:00.899911+00	2022-03-27 03:30:00.899911+00	Box
d27fd2fd-d481-462f-b0cd-80c29296844d	3fd17ea9-e236-4aaa-8d37-366a1af3f887	5990000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-10900k-3-7-ghz-box-socket-1200-new-item	2022-03-27 03:31:05.31752+00	2022-03-27 03:31:05.31752+00	Box
a1febb12-8ff4-405e-a5f6-2f0f125dd3a5	3fd17ea9-e236-4aaa-8d37-366a1af3f887	6200000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i9-10900k-box-comet-lake-socket-lga-1200	2022-03-27 03:31:27.326824+00	2022-03-27 03:31:27.326824+00	Box
bb43f57a-741a-4da0-bcad-e4458ad6950a	a5f02d1c-3123-41e8-a6ab-28611502b3aa	2630000	Shopee	https://shopee.co.id/Processor-Intel-Core-I5-11400-LGA-1200-Box-i.8687183.7986670229?sp_atk=fc5dbc10-517d-41f5-9dbd-0a20129aea73	2022-03-27 03:36:08.904611+00	2022-03-27 03:36:08.904611+00	Box
0f13b4e4-650f-4167-900a-4d870cdc4e29	a5f02d1c-3123-41e8-a6ab-28611502b3aa	2555000	Shopee	https://shopee.co.id/Processor-Intel-Core-I5-11400-Box-Rocket-Lake-Socket-LGA-1200-i.15607053.8646899829?sp_atk=517c8010-06ab-4b79-87e2-cc0fc526b8fd	2022-03-27 03:36:29.457995+00	2022-03-27 03:36:29.457995+00	Box
0da16674-1f1b-49a8-992a-9a9876346fc1	a5f02d1c-3123-41e8-a6ab-28611502b3aa	2579000	Shopee	https://shopee.co.id/INTEL-CORE-I5-11400-2.6GHz-ROCKET-LAKE-6-CORE-12-THREAD-LGA1200-BOX--i.265698488.5783767941?sp_atk=1979ec6d-baf4-4e06-a2f1-29c536f86c57	2022-03-27 03:36:52.437269+00	2022-03-27 03:36:52.437269+00	Box
165d6779-ce9e-43c4-9ccb-7cb64bfd1ed0	a5f02d1c-3123-41e8-a6ab-28611502b3aa	2579000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i5-11400-2-6ghz-rocket-lake-6-core-12-thread-lga1200-box	2022-03-27 03:37:09.452575+00	2022-03-27 03:37:09.452575+00	Box
45a4525d-a686-4a5a-89c4-a90f1b180d27	a5f02d1c-3123-41e8-a6ab-28611502b3aa	2439000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i5-11400-tray-fan-socket-lga1200-2-6ghz?whid=13325	2022-03-27 03:39:08.135779+00	2022-03-27 03:39:08.135779+00	Tray + fan
f071465d-e465-4a2f-af32-e240f17daa4d	88f779b4-4fc0-4795-aa36-ad506f07e16a	3098000	Shopee	https://shopee.co.id/Processor-Intel-Core-i5-11500-2.7Ghz-LGA1200-BOX-i.28679071.8559898180?sp_atk=8ab58cec-bb43-4eb9-bd54-9118ffadd73d	2022-03-27 03:43:10.988944+00	2022-03-27 03:43:10.988944+00	Box, sisa 5 stok ketika pendataan
2a919e3b-1ade-47a0-adee-b7528f3881ac	88f779b4-4fc0-4795-aa36-ad506f07e16a	2949000	Tokopedia	https://www.tokopedia.com/queenprocessor/intel-core-i5-11500-2-7ghz-rocket-lake-6-core-12-thread-lga1200-box	2022-03-27 03:43:39.963712+00	2022-03-27 03:43:39.963712+00	Box
97ae3a7c-7320-4702-bc17-9f1437c00923	88f779b4-4fc0-4795-aa36-ad506f07e16a	2946000	Tokopedia	https://www.tokopedia.com/jayapc/processor-intel-core-i5-11500-box-rocket-lake-socket-lga-1200?src=topads	2022-03-27 03:45:05.70782+00	2022-03-27 03:45:05.70782+00	Box
5e050a0e-9245-4559-a0ba-0836a839adb0	88f779b4-4fc0-4795-aa36-ad506f07e16a	3119000	Tokopedia	https://www.tokopedia.com/duniastorage/intel-core-i5-11500-processor-rocket-lake-lga-1200-6-core-gen-11?whid=13037772	2022-03-27 03:47:26.296801+00	2022-03-27 03:47:26.296801+00	Sisa 3 stok ketika pendataan
3a35a559-f04e-49ed-8cda-528ad7bed885	a41b7c18-ed92-4e86-bd97-fb8477232a51	4799000	Shopee	https://shopee.co.id/Processor-Intel-Core-i7-10700K-3.8-GHz-BOX-SOCKET-1200-NEW-ITEM-GARANSI-3TH-i.265698488.5444299938?sp_atk=37dcfda8-ddfe-4417-b5bf-585820b4e290	2022-03-27 03:54:58.224583+00	2022-03-27 03:54:58.224583+00	Box
1dfc1db0-15ac-4712-8594-77be28bd7276	a41b7c18-ed92-4e86-bd97-fb8477232a51	5161000	Shopee	https://shopee.co.id/Processor-Intel-core-i7-10700K-BOX-AVENGER-EDITION-i.265698488.4879763369?sp_atk=dfb95e93-d04c-4dc7-a491-dff596832e5d	2022-03-27 03:55:18.39725+00	2022-03-27 03:55:18.39725+00	Avengers Edition
842b5e65-7db4-4534-901d-605439979c28	a41b7c18-ed92-4e86-bd97-fb8477232a51	4799000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-10700k-3-8-ghz-box-socket-1200-new-item	2022-03-27 03:56:02.036674+00	2022-03-27 03:56:02.036674+00	Box
161cbb8b-a7fc-4df8-b324-3e415b448728	a41b7c18-ed92-4e86-bd97-fb8477232a51	4799000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-10700k-box-avenger-edition	2022-03-27 03:56:26.361646+00	2022-03-27 03:56:26.361646+00	Box, sisa 5 stok ketika pendataan
b81fed58-02c9-42d9-a515-754b8bd0fae2	4db9fc51-8da6-423e-8cc6-cb1cc3aee181	2230000	Tokopedia	https://www.tokopedia.com/gudangajaa/intel-core-i5-9400f-2-9ghz-up-to-4-1ghz-cache-9mb-box-lga-1151?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 15:27:19.614892+00	2022-06-26 15:27:19.614892+00	\N
52900f1e-aa52-4841-805b-fd0a91ae27ea	39045342-d1fe-4346-8366-20cd2c0c534e	7035000	Tokopedia	https://www.tokopedia.com/benoitco/hotsale-intel-core-i58400t-i5-8400t-1-7-ghz-sixcore-sixthread-cpu?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 15:35:52.781526+00	2022-06-26 15:35:52.781526+00	\N
6838cbdb-2d07-484a-a2d6-5aa8d70aa534	4455b1e4-af07-48cd-b547-d1bbe0b1cd60	7470000	Tokopedia	https://www.tokopedia.com/benoitco/murah-intel-core-i38300t-i3-8300t-3-2-ghz-quadcore-quadthread-c?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-26 15:56:03.444374+00	2022-06-26 15:56:03.444374+00	\N
cc3520b0-629c-4c09-a75b-9f2f332fec50	a0f5ffc8-cabd-4911-b7b3-d22055211750	7385000	Tokopedia	https://www.tokopedia.com/updatemall-1/intel-core-i38300-i3-8300-3-7-ghz-quadcore-quadthread-cpu-processo?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 15:57:16.634116+00	2022-06-26 15:57:16.634116+00	\N
fffa0eb2-a5b2-4a38-a38a-39039eea5ff2	d81514dd-2f0e-41b1-a6e5-e408f8ff7ce7	1425000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i3-9100-3-6ghz-socket-1151-tray-fan?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-26 15:59:55.371134+00	2022-06-26 15:59:55.371134+00	\N
0cac5758-99eb-4614-8ee9-d4813f942c49	95448d9c-0b93-48ea-862f-f8f74c6ad210	2116000	Tokopedia	https://www.tokopedia.com/enterkomputer/intel-core-i5-8500-3-0ghz-up-to-4-1ghz-cache-9mb-tray-lga-1151v2?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:03:26.020874+00	2022-06-26 16:03:26.020874+00	\N
859d9bcd-bfa5-40d1-aac5-597f567fb120	c39f15c8-e6f9-4663-950c-e3fed87669a7	4200000	Tokopedia	https://www.tokopedia.com/tntpc/intel-core-i5-8600-soket-1151-coffelake?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:06:34.563539+00	2022-06-26 16:06:34.563539+00	\N
3ec32356-1b0e-4893-b40f-5095f040451a	8424aec2-a2c4-498d-bc73-f75737f8f59a	6633500	Tokopedia	https://www.tokopedia.com/procig/intel-core-i5-8600t-i5-8600t-2-3-ghz-six-core-six-thread-procig?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:08:03.513794+00	2022-06-26 16:08:03.513794+00	\N
659d3829-afa7-437c-8f6a-ae5cf68220f7	fa746038-0d96-40ff-ad4b-a3a91860d52b	2560000	Tokopedia	https://www.tokopedia.com/maxcom-computer/intel-core-i5-9400-coffee-lake-6-core-2-9-ghz-upto-4-1-ghz-turbo?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:09:49.219804+00	2022-06-26 16:09:49.219804+00	\N
d61a780e-5715-4710-b85b-757ea7852c2d	199af7de-2108-45ea-9cda-4893b35c9fe3	2520000	Tokopedia	https://www.tokopedia.com/maxcom-computer/intel-core-i5-9500-tray-6-cores-up-to-4-ghz-turbo-socket-1151?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-26 16:10:55.611831+00	2022-06-26 16:10:55.611831+00	\N
7c887fb3-c198-409f-b2b7-1d4ffc783007	1705c0a5-a3b4-4040-981c-f65ac0617104	2670000	Tokopedia	https://www.tokopedia.com/maxcom-computer/intel-core-i5-9600k-tray-3-7ghz-6-core-socket-1151-coffe-lake-gen-9?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-26 16:12:32.220944+00	2022-06-26 16:12:32.220944+00	\N
d575889f-e989-4874-b7b6-7b2bf7f03e07	ac426bfb-460b-444f-981b-dcfdfff9e55e	5499000	Tokopedia	https://www.tokopedia.com/xtenimport/intel-core-i7-8700t-es-i7-8700t-es-qn8j-1-6-ghz-six-core-xten?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:21:25.789388+00	2022-06-26 16:21:25.789388+00	\N
63e160d2-1001-4ad2-a123-37adbf3addb4	47ab876b-b53a-42ee-9177-58666e506562	4690000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-9700k-3-60-ghz-box-socket-1151?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:22:31.226108+00	2022-06-26 16:22:31.226108+00	\N
ea037fcb-9b9d-463b-92bb-c0e0b9b3d6d7	a0ad10f3-28c5-4d64-8d4f-74ad53b4ad81	8000000	Tokopedia	https://www.tokopedia.com/gvcoil/processor-intel-core-i9-9900x-box-intel-core-i9-9900x?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:24:02.248118+00	2022-06-26 16:24:02.248118+00	\N
e80c6355-7c8a-433b-bf56-e85b9dfdfc80	7df12187-d125-49d1-988b-34ce4362cbe3	13900000	Tokopedia	https://www.tokopedia.com/aleatuppy/intel-core-i9-9920x-skylake-x-12-core-3-5-ghz-upto-4-4-ghz-lga-2066?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-26 16:27:45.336256+00	2022-06-26 16:27:45.336256+00	\N
29454ec3-a334-4b51-bebb-bea268eb1a8b	c159c278-b303-4ee4-a5f0-4d9a5841d24d	16800000	Tokopedia	https://www.tokopedia.com/chandut/processor-intel-core-i9-9940x-skylake-x-lga-2066-14-core-cpu?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-26 16:31:12.731896+00	2022-06-26 16:31:12.731896+00	\N
c7a6d08e-edea-48c0-8986-e7537075855f	691b22a7-96dd-4e3b-b277-f869b8beffaf	17890000	Tokopedia	https://www.tokopedia.com/chandut/processor-intel-core-i9-9960x-3-1-ghz-sixteen-core-lga-2066?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-26 16:44:26.97183+00	2022-06-26 16:44:26.97183+00	\N
821f8284-b041-4f48-b4bb-95311a0f3898	e4cc22cf-7597-414b-ab8d-bae0e9c048df	5345000	Tokopedia	https://www.tokopedia.com/prismacomharco/processor-intel-core-i9-9900?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 12:40:54.461648+00	2022-06-27 12:40:54.461648+00	\N
694f3148-3574-4864-96fe-351ae46bb06f	fba101af-3b6c-4979-9bb7-d499733c8e92	1350000	Tokopedia	https://www.tokopedia.com/kiacom-1/intel-core-i3-9350kf-4-00ghz-up-to-4-60ghz-lga1151?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 14:11:24.144195+00	2022-06-27 14:11:24.144195+00	\N
5242c6e1-eeff-47dc-ade6-784d2eecca04	8224ccf1-0efe-485c-b734-e57a81031eb6	3390000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-8700-3-2ghz-tray-socket-1151-fan?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 14:12:30.578727+00	2022-06-27 14:12:30.578727+00	\N
b6a48912-fec8-4d79-8827-0d9126819a85	f9c923d5-2a49-4a21-9a8f-72efa0e29d39	2530000	Tokopedia	https://www.tokopedia.com/supernovadepok/intel-core-i5-9500f?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 14:14:26.581272+00	2022-06-27 14:14:26.581272+00	\N
857f6876-4720-4a10-a100-720246661b01	4d22cb33-6840-4aaf-b9e6-47764d6b1162	2944000	Tokopedia	https://www.tokopedia.com/prismacomharco/processor-intel-core-i5-9600kf?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 14:17:14.820588+00	2022-06-27 14:17:14.820588+00	\N
de0f572c-f58b-40cc-b045-67283a566060	3b9bf666-b1de-4368-b13c-04001a27f538	4599000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i7-9700-3-0-ghz-box?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 14:24:53.731236+00	2022-06-27 14:24:53.731236+00	\N
55cc1fd1-8c8d-4ada-88b9-b8fcafd8939c	5a362a97-896f-4fad-bb25-138ec8ed4571	4190000	Tokopedia	https://www.tokopedia.com/distributorpc/intel-core-i7-9700f-3-0ghz-up-to-4-7ghz-cache-12mb-box?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 14:35:51.92178+00	2022-06-27 14:35:51.92178+00	\N
38171f97-8782-4262-ae2a-55ef3467f522	90b8404a-5580-45b7-b5c3-263fe3e53fff	5998000	Tokopedia	https://www.tokopedia.com/menrockhouse69/intel-core-i7-9700kf-3-6-ghz-12m-cache-8-core-processor?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 15:01:05.674653+00	2022-06-27 15:01:05.674653+00	\N
7a92b056-f68a-4879-9156-5f67c7ecb44a	7d1e7179-1821-4541-b577-8e88105b68d4	5500000	Tokopedia	https://www.tokopedia.com/supernovadepok/intel-core-i9-9900kf-lga-1151-coffeelake-3-6ghz-unlocked?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 15:05:58.901479+00	2022-06-27 15:05:58.901479+00	\N
378c50ea-8da8-4e3a-9e08-a732d824aff9	544f1e10-2e8f-4079-9dd1-e773468ebcda	14300000	Tokopedia	https://www.tokopedia.com/platinumcomputer/intel-core-i9-9820x-box-socket-lga-2066-9th-generation?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 15:07:38.402708+00	2022-06-27 15:07:38.402708+00	\N
4cd1705f-6c39-4cc7-bd1a-f08a303a2f08	3e49f395-e6ed-4611-ad75-56e6c7ff4c8e	2179000	Tokopedia	https://www.tokopedia.com/nanokomputer/intel-core-i5-11400f-processor-intel-gen-11-lga-1200-6-core?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 16:28:40.048766+00	2022-06-27 16:28:40.048766+00	\N
8f3f9c7d-5b09-43f5-bfd3-f47b4b0781d5	d8fd9b40-9433-4640-b8a4-6b8ebc8a3111	4615150	Tokopedia	https://www.tokopedia.com/joko-olstore01/amd-ryzen-5-pro-2600-r5-pro-2600-3-4-ghz-six-core-jkstore?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 16:40:41.828544+00	2022-06-27 16:40:41.828544+00	\N
c450c2bc-44dd-4dec-910d-4bcb71517bd1	6ea566e8-83e1-4fc3-b24d-b9617409f178	1200000	Tokopedia	https://www.tokopedia.com/viragotech/amd-ryzen-3-2300x-tray-3-5ghz-up-to-4-0ghz-socket-am4?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 16:42:58.832556+00	2022-06-27 16:42:58.832556+00	\N
47b82705-6c09-403e-a13d-55700a04e790	5318fa72-febe-4372-b491-cb6d1e937f0a	3691400	Tokopedia	https://www.tokopedia.com/handshopimport/amd-ryzen-5-2500x-r5-2500x-3-6-ghz-quad-core-eight-thread-handshop?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 17:10:21.565652+00	2022-06-27 17:10:21.565652+00	\N
6f852c82-2f1c-4385-9f1d-1ccfe8ec756b	d3413cdb-072c-4d39-a34e-8f7dd4559ae4	2896000	Tokopedia	https://www.tokopedia.com/silverpeek/trendy-amd-ryzen-5-2600e-r5-2600e-3-1-ghz-six-core-twelve-core-45w?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 17:11:16.050136+00	2022-06-27 17:11:16.050136+00	\N
8f8bac5d-e169-4e50-af65-8847fd78c205	a95af759-ce0c-4ffb-ab3a-ab15e68dc1df	2349000	Tokopedia	https://www.tokopedia.com/queenprocessor/amd-ryzen-5-pinnacle-ridge-2600x-3-6ghz-up-to-4-2ghz-box-3-tahun?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-27 17:12:17.901381+00	2022-06-27 17:12:17.901381+00	\N
cf69fb32-27b4-4998-8909-4335f0568e38	3192c010-5925-4301-9f8f-402950521151	7064610	Tokopedia	https://www.tokopedia.com/archive-diatmika-1-1630710192/new-amd-ryzen-5-pro-2400g-r5-pro-2400g-3-6-ghz-quad-core-dtmka?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 17:13:23.576783+00	2022-06-27 17:13:23.576783+00	\N
9a7b58ad-0a1a-4940-acf5-37d5a09e1824	f733a33c-1dcb-456e-ade0-16a245bdbbb2	3661250	Tokopedia	https://www.tokopedia.com/megasuryacomp/proc-amd-ryzen-7-2700?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-27 17:14:29.938243+00	2022-06-27 17:14:29.938243+00	\N
e2baaba1-ca88-4a58-8453-e845f3d1fc8a	14b07cdb-4306-44c9-a15e-5fa36807753e	3562650	Tokopedia	https://www.tokopedia.com/megasuryacomp/proc-amd-ryzen-7-2700x?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 12:25:57.592078+00	2022-06-28 12:25:57.592078+00	\N
1720a6b6-cba8-430d-8b0d-2eaefd59f68a	77d54f55-07d7-463d-af62-fb833388bece	6052850	Tokopedia	https://www.tokopedia.com/procig/amd-ryzen-7-pro-2700-r7-pro-2700-3-2-ghz-eight-core-procig?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 14:38:07.536097+00	2022-06-28 14:38:07.536097+00	\N
f8de9850-74c4-4bc8-bcae-fea8f5988628	45a51911-cfad-4d74-9962-749289c7873e	6601590	Tokopedia	https://www.tokopedia.com/joko-olstore01/amd-ryzen-7-pro-2700x-r7-pro-2700x-3-7-ghz-eight-core-jkstore?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 14:39:53.809603+00	2022-06-28 14:39:53.809603+00	\N
2b78e093-5c16-4131-80ca-d1bd856d9def	6b284255-809c-4cae-b3ea-e948ba1e7237	1990000	Tokopedia	https://www.tokopedia.com/gamingpcstore/amd-ryzen-3-pro-4350g-tray-garansi-resmi-3-tahun?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-28 15:20:40.11415+00	2022-06-28 15:20:40.11415+00	\N
2879d55e-1673-4459-bb8a-98c5a50360b7	bedd94bb-e361-4652-a512-129002c5c0b4	7385000	Tokopedia	https://www.tokopedia.com/updatemall-1/intel-core-i58500t-i5-8500t-2-1-ghz-sixcore-sixthread-cpu-processo?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-28 15:32:57.20008+00	2022-06-28 15:32:57.20008+00	\N
b2d3c757-ca5e-42df-97df-db640986d0b3	c1413bf0-e0e9-4872-a60e-566e5f096e92	2850000	Tokopedia	https://www.tokopedia.com/tokotiaii/core-i5-9600-coffelake-soket-1151-gen9-garansi-1-tahun?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 15:34:34.583428+00	2022-06-28 15:34:34.583428+00	\N
da54eea9-c1eb-482e-9dd6-7f03f19d2c72	c979cf6d-acf5-4e52-8abe-1772e4503f67	10499000	Tokopedia	https://www.tokopedia.com/d-m-i/intel-core-i7-9800x-box-skylake-x-8-core-3-8-ghz-upto-4-4-ghz-lga-2066?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 15:35:28.96248+00	2022-06-28 15:35:28.96248+00	\N
d1a647c4-7633-44bb-b1c8-7d4f2be8d33d	b930d792-7d47-4ddb-a422-b919da359e3b	6499000	Tokopedia	https://www.tokopedia.com/queenprocessor/processor-intel-core-i9-9900k-3-6-ghz-box-socket-1151?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 15:56:45.16329+00	2022-06-28 15:56:45.16329+00	\N
094070d3-ccfa-4155-b891-c4fc6b529099	038cfdbd-b670-41f0-9bbf-4664195703dc	16273000	Tokopedia	https://www.tokopedia.com/pazcom/intel-core-i9-9980xe-extreme-edition-socket-2066-skylake-x?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 16:00:41.719688+00	2022-06-28 16:00:41.719688+00	\N
3695f0d9-de07-44f6-b077-788de4daccec	15cfaf49-698a-4b48-8f00-d6666d0f5123	3500000	Tokopedia	https://www.tokopedia.com/aogarenaofgadget/amd-ryzen-5-2600-box-3-4ghz-up-to-3-9ghz-socket-am4?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-28 16:02:42.208545+00	2022-06-28 16:02:42.208545+00	\N
\.


--
-- TOC entry 4378 (class 0 OID 4797467)
-- Dependencies: 215
-- Data for Name: gpu; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.gpu (id, name, gpu_chip, interface_bus, memory, gpu_clock, memory_clock, release_date, recommended_wattage, created_at, updated_at, target_market_number, manufacturer, image_url) FROM stdin;
e2a24440-4594-4fee-8867-5889a356fd1c	GeForce GTX 1050	GP107	PCIe 3.0 x16	2 GB, GDDR5, 128 bit	1354 MHz	1752 MHz	2016-10-25	320	2022-03-17 06:19:44.204463+00	2022-03-17 07:03:09.255248+00	2	Nvidia	\N
0ff50861-c98f-41d3-bb85-7d3eedd31627	GeForce GTX 1050 Ti	GP107	PCIe 3.0 x16	4 GB, GDDR5, 128 bit	1291 MHz	1752 MHz	2016-10-25	320	2022-03-17 06:21:04.284211+00	2022-03-17 07:03:09.438911+00	2	Nvidia	\N
fdab15a5-dfa1-4185-a0a8-95dcb20aedb4	GeForce GTX 1060 3 GB	GP106	PCIe 3.0 x16	3 GB, GDDR5, 192 bit	1506 MHz	2002 MHz	2016-08-18	450	2022-03-17 06:40:21.850712+00	2022-03-17 07:03:09.622033+00	2	Nvidia	\N
46b892ab-438d-434e-9642-6f4ab3742ea3	GeForce GTX 1060 6 GB	GP106	PCIe 3.0 x16	6 GB, GDDR5, 192 bit	1506 MHz	2002 MHz	2016-07-19	450	2022-03-17 07:30:12.03748+00	2022-03-17 07:30:12.03748+00	2	Nvidia	\N
d2283be7-be81-49b7-baeb-b190af5d79ec	GeForce GTX 1070	GP104	PCIe 3.0 x16	8 GB, GDDR5, 256 bit	1506 MHz	2002 MHz	2016-06-10	500	2022-03-17 07:31:35.225266+00	2022-03-17 07:31:35.225266+00	3	Nvidia	\N
cfeef39c-44de-4b5e-aa3d-314b3a3d76f3	GeForce GTX 1070 Ti	GP104	PCIe 3.0 x16	8 GB, GDDR5, 256 bit	1607 MHz	2002 MHz	2017-11-02	550	2022-03-17 07:32:57.256315+00	2022-03-17 07:32:57.256315+00	3	Nvidia	\N
31476c09-d1d4-47cb-b37b-f3e2691e999f	GeForce GTX 1080	GP104	PCIe 3.0 x16	8 GB, GDDR5X, 256 bit	1607 MHz	1251 MHz	2016-05-27	520	2022-03-17 07:35:44.983398+00	2022-03-17 07:35:44.983398+00	3	Nvidia	\N
efd5a375-38b3-4f74-9cc3-15c612506540	GeForce GTX 1080 Ti	GP104	PCIe 3.0 x16	11 GB, GDDR5X, 352 bit	1481 MHz	1376 MHz	2017-03-10	600	2022-03-17 07:36:51.59974+00	2022-03-17 07:37:23.940681+00	4	Nvidia	\N
cf767e23-fb7a-4f5c-be04-89946aa59237	GeForce GTX 1650	TU117	PCIe 3.0 x16	4 GB, GDDR5, 128 bit	1485 MHz	2001 MHz	2019-04-23	380	2022-03-17 07:48:28.743479+00	2022-03-17 07:48:28.743479+00	2	Nvidia	\N
373ad190-bb5d-461e-bd69-baad634fb0f8	GeForce GTX 1650 Super	TU116	PCIe 3.0 x16	4 GB, GDDR6, 128 bit	1530 MHz	1500 MHz	2019-11-22	400	2022-03-17 07:49:12.496923+00	2022-03-17 07:49:12.496923+00	2	Nvidia	\N
14e8da48-7929-49f6-8937-8948dcb5ccbb	GeForce GTX 1660	TU116	PCIe 3.0 x16	6 GB, GDDR5, 192 bit	1530 MHz	2001 MHz	2019-03-14	430	2022-03-17 07:50:03.608612+00	2022-03-17 07:50:03.608612+00	2	Nvidia	\N
63b21630-3e08-4383-82ef-513161709e1b	GeForce GTX 1660 SUPER	TU116	PCIe 3.0 x16	6 GB, GDDR5, 192 bit	1530 MHz	1750 MHz	2019-10-29	430	2022-03-17 07:51:06.652025+00	2022-03-17 07:51:06.652025+00	2	Nvidia	\N
0b8f046a-e64e-4a69-baa4-1b6804375784	GeForce GTX 1660 Ti	TU116	PCIe 3.0 x16	6 GB, GDDR5, 192 bit	1500 MHz	1500 MHz	2019-10-29	430	2022-03-17 07:51:49.651979+00	2022-03-17 07:51:49.651979+00	2	Nvidia	\N
ccfb5c08-6147-4ff3-b7b0-53afaef35129	GeForce GT 1030	GP108	PCIe 3.0 x4	2 GB, GDDR5, 64 bit	1228 MHz	1502 MHz	2017-05-17	250	2022-03-20 10:45:06.286092+00	2022-03-20 10:45:06.286092+00	1	Nvidia	\N
26c785e7-dffc-41b4-a91d-9090905b027c	GeForce RTX 2060	TU106	PCIe 3.0 x16	6 GB, GDDR6, 192 bit	1365 MHz	1750 MHz	2019-07-01	480	2022-03-20 10:49:02.070175+00	2022-03-20 10:49:02.070175+00	2	Nvidia	\N
46d7b634-d0ff-40f4-9fc5-a1deb7e6e02b	GeForce RTX 2070	TU106	PCIe 3.0 x16	8 GB, GDDR6, 256 bit	1410 MHz	1750 MHz	2018-10-17	500	2022-03-20 12:22:35.669041+00	2022-03-20 12:22:35.669041+00	3	Nvidia	\N
bb29afd4-123f-4db8-aa3b-232c39b6296c	GeForce RTX 2080	TU104	PCIe 3.0 x16	8 GB, GDDR6, 256 bit	1515 MHz	1750 MHz	2018-09-20	550	2022-03-20 12:23:25.147659+00	2022-03-20 12:23:25.147659+00	3	Nvidia	\N
10248bb0-d58a-4389-ac9c-b7f9fdb3a56a	GeForce RTX 2070 SUPER	TU104	PCIe 3.0 x16	8 GB, GDDR6, 256 bit	1515 MHz	1750 MHz	2019-07-09	520	2022-03-20 12:24:06.117948+00	2022-03-20 12:24:06.117948+00	3	Nvidia	\N
c48abeb0-fe29-4ff1-b0f2-1ec2c3aedc93	GeForce RTX 2080 SUPER	TU104	PCIe 3.0 x16	8 GB, GDDR6, 256 bit	1650 MHz	1937 MHz	2019-07-23	600	2022-03-20 12:27:02.672647+00	2022-03-20 12:27:02.672647+00	3	Nvidia	\N
816388c3-7e90-4ea1-a114-7a69e430ab8d	GeForce RTX 2080 Ti	TU102	PCIe 3.0 x16	11 GB, GDDR6, 352 bit	1350 MHz	1750 MHz	2018-09-20	600	2022-03-20 12:27:55.002884+00	2022-03-20 12:27:55.002884+00	3	Nvidia	\N
3e086317-0cf5-4ab0-90c7-4f811a968ed3	GeForce RTX 3060	GA106	PCIe 4.0 x16	12 GB, GDDR6, 192 bit	1320 MHz	1875 MHz	2021-01-12	550	2022-03-20 13:20:31.838542+00	2022-03-20 13:20:31.838542+00	2	Nvidia	\N
a7b3806f-0107-453f-86be-5828b4d2b205	GeForce RTX 3060 Ti	GA104	PCIe 4.0 x16	8 GB, GDDR6, 256 bit	1410 MHz	1750 MHz	2020-12-01	575	2022-03-21 01:58:43.072278+00	2022-03-21 01:58:43.072278+00	2	Nvidia	\N
00e46851-c344-4df0-96c7-7d32d853008a	GeForce RTX 3070	GA104	PCIe 4.0 x16	8 GB, GDDR6, 256 bit	1500 MHz	1750 MHz	2020-09-01	575	2022-03-21 01:59:44.41327+00	2022-03-21 01:59:44.41327+00	3	Nvidia	\N
a1ab648e-9b26-4477-83e7-ef0443286be6	GeForce RTX 3070 Ti	GA104	PCIe 4.0 x16	8 GB, GDDR6, 256 bit	1575 MHz	1188 MHz	2021-05-31	600	2022-03-21 02:05:24.89805+00	2022-03-21 02:05:24.89805+00	3	Nvidia	\N
e8599b8f-aa75-437a-aef6-1e7f6c760bad	GeForce RTX 3080	GA102	PCIe 4.0 x16	10 GB, GDDR6X, 320 bit	1440 MHz	1188 MHz	2020-09-01	700	2022-03-21 02:06:22.931731+00	2022-03-21 02:06:22.931731+00	3	Nvidia	\N
c57e3a9a-4ea0-4b48-a215-18e3ae8b0c93	GeForce RTX 3080 Ti	GA102	PCIe 4.0 x16	12 GB, GDDR6X, 384 bit	1365 MHz	1188 MHz	2021-05-31	750	2022-03-21 02:07:03.314604+00	2022-03-21 02:07:03.314604+00	3	Nvidia	\N
f2388178-30dc-431e-a432-4fdf16847191	Radeon RX 6600	Navi 23	PCIe 4.0 x8	8 GB, GDDR6, 128 bit	1626 MHz	1750 MHz	2021-10-13	450	2022-03-22 08:46:01.974322+00	2022-03-22 08:46:01.974322+00	2	AMD	\N
f7b91483-f3f7-42f1-a382-a8682daac27a	Radeon RX 6500 XT	Navi 24	PCIe 4.0 x4	4 GB, GDDR6, 64 bit	2310 MHz	2248 MHz	2022-01-19	450	2022-03-22 08:41:38.851723+00	2022-03-22 08:46:39.364625+00	2	AMD	\N
de68324a-7e87-4fea-82c3-92434d5d8b98	Radeon RX 6600 XT	Navi 23	PCIe 4.0 x8	8 GB, GDDR6, 128 bit	1968 MHz	2000 MHz	2021-07-30	550	2022-03-22 09:01:28.228488+00	2022-03-22 09:01:28.228488+00	2	AMD	\N
38f653ab-b56a-4853-a001-306ce167d4ff	Radeon RX 6700 XT	Navi 22	PCIe 4.0 x16	12 GB, GDDR6, 192 bit	2321 MHz	2000 MHz	2021-05-03	600	2022-03-22 09:03:41.385525+00	2022-03-22 09:03:41.385525+00	2	AMD	\N
\.


--
-- TOC entry 4381 (class 0 OID 4797516)
-- Dependencies: 218
-- Data for Name: gpu_prices; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.gpu_prices (id, gpu_id, price, shop, shop_link, created_at, updated_at, gpu_name) FROM stdin;
9028732e-52dd-45e6-bac8-b251f65fe971	46b892ab-438d-434e-9642-6f4ab3742ea3	4300000	Tokopedia	https://www.tokopedia.com/mecomputerbogor/vga-gtx-1060-6gb-ddr5-gigabyte-galax-msi-asus-asus-strix	2022-03-21 09:18:19.475777+00	2022-03-21 09:18:19.475777+00	VGA GTX 1060 6GB DDR5 Gigabyte / Galax / MSI / ASUS - ASUS Strix
4b98ced0-604c-4d3f-a04d-f2817933b80f	f7b91483-f3f7-42f1-a382-a8682daac27a	3698000.0	Tokopedia	https://www.tokopedia.com/gasol/sapphire-pulse-radeon-rx-6500-xt-4gb-gddr6-rdna-2-rx6500xt-ddr6?src=topads	2022-03-22 08:42:01.653103+00	2022-06-19 08:10:40.453428+00	SAPPHIRE PULSE Radeon RX 6500 XT 4GB GDDR6 RDNA 2 - RX6500XT DDR6
2e464d8a-3b10-4549-8043-a832ea2180d2	de68324a-7e87-4fea-82c3-92434d5d8b98	8580000.0	Tokopedia	https://www.tokopedia.com/goodstechid/asrock-rx-6600-xt-challenger-pro-oc-8gb-rx6600-6600xt?src=topads	2022-03-22 09:02:27.625215+00	2022-06-19 08:10:41.277308+00	ASROCK RX 6600 XT CHALLENGER PRO OC 8GB
75bbb3f9-782d-46c7-acf7-24ab323712ec	ccfb5c08-6147-4ff3-b7b0-53afaef35129	1435000.0	Tokopedia	https://www.tokopedia.com/jnj77/vga-colorful-geforce-gt-1030-2g-v3-ddr5?src=topads	2022-03-21 08:52:06.370498+00	2022-06-19 08:10:27.806263+00	VGA Colorful GeForce GT 1030 2G V3 - DDR5
7aa7d5ef-4180-4219-b057-4c0519ca018f	ccfb5c08-6147-4ff3-b7b0-53afaef35129	1400000.0	Tokopedia	https://www.tokopedia.com/global-link168/vga-colorful-gt-1030-2gb-colorful-geforce-gt-1030-2gb-v2-gt1030-2g	2022-03-21 08:59:21.992322+00	2022-06-19 08:10:28.677128+00	Vga ColorFul GT 1030 2GB - ColorFul Geforce GT 1030 2GB V2 - GT1030 2G
805f3515-d9bd-4bf0-97b6-36518e709f16	0ff50861-c98f-41d3-bb85-7d3eedd31627	3197000.0	Tokopedia	https://www.tokopedia.com/gasolsumbersari/colorful-geforce-gtx1050ti-4g-v-4gb-gddr5-vga-gtx-1050-ti-ddr5?src=topads	2022-03-21 09:03:31.158568+00	2022-06-19 08:10:29.546466+00	Colorful GeForce GTX1050Ti 4G-V 4GB GDDR5 - VGA GTX 1050 TI DDR5
b12b4615-7841-4e41-ad60-28c4d02a0064	14e8da48-7929-49f6-8937-8948dcb5ccbb	4799000.0	Tokopedia	https://www.tokopedia.com/queenprocessor/gigabyte-geforce-gtx-1660-oc-6g-gddr5-192-bit	2022-03-21 09:38:42.58622+00	2022-06-19 08:10:30.37883+00	GIGABYTE GEFORCE GTX 1660 OC 6G GDDR5 192 BIT
c00fd996-d4ca-4ce2-8c4d-042b8d4cae2f	63b21630-3e08-4383-82ef-513161709e1b	4499000.0	Tokopedia	https://www.tokopedia.com/queenprocessor/msi-gaming-geforce-gtx-1660-super-ventus-xs-6gb-192-bit	2022-03-21 09:39:16.139405+00	2022-06-19 08:10:31.204056+00	MSI GAMING GEFORCE GTX 1660 SUPER VENTUS XS 6GB 192-Bit
222bcdb3-d5d4-427b-99d2-6926e3a67a70	63b21630-3e08-4383-82ef-513161709e1b	4599000.0	Tokopedia	https://www.tokopedia.com/queenprocessor/asus-tuf-gaming-geforce-gtx-1660-super-6g-gddr6-192-bit	2022-03-21 09:39:45.676881+00	2022-06-19 08:10:32.075633+00	ASUS TUF GAMING GEFORCE GTX 1660 SUPER 6G GDDR6 192 BIT
fc66bec3-9c10-4447-b9ac-c0dc99602029	0b8f046a-e64e-4a69-baa4-1b6804375784	6077500.0	Tokopedia	https://www.tokopedia.com/gigabyteofficial/gigabyte-vga-geforce-gtx-1660-ti-oc-6g-gv-n166toc-6gd	2022-03-21 09:40:21.688031+00	2022-06-19 08:10:32.908947+00	Gigabyte VGA GeForce® GTX 1660 Ti OC 6G [GV-N166TOC-6GD]
04904b7b-e4b2-4dc2-a803-2734fd262abb	26c785e7-dffc-41b4-a91d-9090905b027c	5350000.0	Tokopedia	https://www.tokopedia.com/sportonlineshop/msi-geforce-rtx-2060-ventus-gp-oc-6gb-gddr6	2022-03-21 09:57:37.238814+00	2022-06-19 08:10:33.74172+00	MSI GEFORCE RTX 2060 VENTUS GP OC 6GB GDDR6
0c2d5dca-b187-4ec1-83b9-66fc9ef8beb9	3e086317-0cf5-4ab0-90c7-4f811a968ed3	7979000.0	Tokopedia	https://www.tokopedia.com/youngscom/msi-rtx-3060-gaming-x-12g-12gb-ddr6-vga-card-nvidia-geforce-rtx3060?src=topads	2022-03-22 02:38:54.491608+00	2022-06-19 08:10:34.579991+00	MSI RTX 3060 GAMING X 12G 12GB DDR6 VGA CARD NVIDIA GEFORCE RTX3060
89980446-2ca6-48d4-97ee-57817085ca1b	10248bb0-d58a-4389-ac9c-b7f9fdb3a56a	12500000	Tokopedia	https://www.tokopedia.com/jointventure/galax-geforce-rtx-2070-super-ex-8gb-ddr6-1-click-oc	2022-03-22 02:39:48.798216+00	2022-06-19 08:10:35.415786+00	GALAX Geforce RTX 2070 SUPER EX 8GB DDR6 (1-Click OC)
028520a2-707b-4d78-87ad-8f8c8c0d87cc	3e086317-0cf5-4ab0-90c7-4f811a968ed3	6989200.0	Tokopedia	https://www.tokopedia.com/tinker-er/zotac-nvidia-geforce-rtx-3060-twin-edge-oc-12gb-new-garansi-resmi?src=topads	2022-03-22 02:41:04.92874+00	2022-06-19 08:10:36.25203+00	Zotac Nvidia Geforce RTX 3060 Twin Edge OC 12GB
71647045-81aa-4659-9d5d-a7811526fac3	00e46851-c344-4df0-96c7-7d32d853008a	11750000	Tokopedia	https://www.tokopedia.com/sportonlineshop/msi-geforce-rtx-3070-gaming-z-trio-lhr-8gb-gddr6	2022-03-22 03:42:27.844149+00	2022-06-19 08:10:37.079647+00	MSI GEFORCE RTX 3070 GAMING Z TRIO LHR 8GB GDDR6
77314fdb-bca4-45de-bfb5-295e99095d56	a1ab648e-9b26-4477-83e7-ef0443286be6	14458500	Tokopedia	https://www.tokopedia.com/gigabyteofficial/gigabyte-vga-geforce-rtx-3070-ti-vision-oc-gv-n307tvision-oc-8gd	2022-03-22 03:42:54.099119+00	2022-06-19 08:10:37.959816+00	Gigabyte VGA GeForce RTX™ 3070 Ti VISION OC (GV-N307TVISION OC-8GD)
68e7987a-7efb-4d61-8b00-7a26e6d4ee2c	e8599b8f-aa75-437a-aef6-1e7f6c760bad	16720000	Tokopedia	https://www.tokopedia.com/goodstechid/gigabyte-vga-geforce-rtx-3080-10gb-gddr6x-320bit-gaming-oc?src=topads	2022-03-22 03:43:45.265325+00	2022-06-19 08:10:38.787938+00	Gigabyte VGA GeForce RTX 3080 10GB GDDR6X 320BIT Gaming OC
4b85c822-b0a0-4098-9ad8-b2e779f6fcb7	e8599b8f-aa75-437a-aef6-1e7f6c760bad	23500000	Tokopedia	https://www.tokopedia.com/garudamegastore/evga-rtx-3080ti-ftw3-ultra-vga-rtx-3080ti-ftw3-ultra-gaming?src=topads	2022-03-22 03:44:27.428022+00	2022-06-19 08:10:39.606817+00	EVGA RTX 3080Ti FTW3 ULTRA VGA RTX 3080Ti FTW3 ULTRA GAMING
bcbd7811-9b3e-4bae-9ddf-93ef3b759872	38f653ab-b56a-4853-a001-306ce167d4ff	13150000	Tokopedia	https://www.tokopedia.com/supply-drop/gigabyte-amd-radeon-rx-6700-xt-gaming-oc-12gb-gddr6?src=topads	2022-03-22 09:04:08.238408+00	2022-06-19 08:10:42.097805+00	GIGABYTE AMD RADEON RX 6700 XT GAMING OC 12GB GDDR6
bbedc077-90ca-4b41-8d86-266093e22679	373ad190-bb5d-461e-bd69-baad634fb0f8	3900000	Tokopedia	https://www.tokopedia.com/nvidiageforce/vga-card-zotac-gaming-geforce-gtx-1650-super-twin-fan-4gb-gddr6?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-29 12:36:37.866568+00	2022-06-29 12:36:37.866568+00	\N
6f465a94-086d-4015-a3e4-a9d892001609	cf767e23-fb7a-4f5c-be04-89946aa59237	3672000	Tokopedia	https://www.tokopedia.com/jayapc/vga-asus-dual-geforce-gtx1650-4gb-gtx-1650-oc-4-gb-gddr5?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-06-29 12:50:36.207216+00	2022-06-29 12:50:36.207216+00	\N
60ba1f87-3560-4237-a119-0b66a6c5eb9b	816388c3-7e90-4ea1-a114-7a69e430ab8d	24995000	Tokopedia	https://www.tokopedia.com/queenprocessor/msi-geforce-rtx-2080-ti-11gb-ddr6-gaming-x-trio?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-29 13:09:53.285018+00	2022-06-29 13:09:53.285018+00	MSI GeForce RTX 2080 Ti
28f60e10-bdbf-4ea7-94de-28dd55660103	a7b3806f-0107-453f-86be-5828b4d2b205	8350000	Tokopedia	https://www.tokopedia.com/enterkomputer/galax-geforce-rtx-3060-ti-8gb-ddr6-1-click-oc-dual-fan-lhr?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-29 13:12:10.430292+00	2022-06-29 13:12:10.430292+00	GeForce RTX 3060 Ti
d07e280e-ef01-47a7-8933-e141b9057df0	c57e3a9a-4ea0-4b48-a215-18e3ae8b0c93	24129000	Tokopedia	https://www.tokopedia.com/enterkomputer/galax-geforce-rtx-3080-ti-12gb-ddr6x-sg-1-click-oc-triple-argb-fan?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-29 13:15:22.078514+00	2022-06-29 13:15:22.078514+00	GeForce RTX 3080 Ti
\.


--
-- TOC entry 4377 (class 0 OID 4778751)
-- Dependencies: 214
-- Data for Name: interface_bus; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.interface_bus (bus_name) FROM stdin;
PCIe 2.0 x8
PCIe 2.0 x16
PCIe 3.0 x8
PCIe 3.0 x16
PCIe 4.0 x8
PCIe 4.0 x16
PCIe 3.0 x4
PCIe 4.0 x4
PCIe 3.0 x1
 PCIe 3.0 x2
 PCIe 2.0 x1
PCIe 2.0 x2
PCIe 5.0 x16
\.


--
-- TOC entry 4396 (class 0 OID 4895118)
-- Dependencies: 233
-- Data for Name: manufacturer; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.manufacturer (manufacturer_name) FROM stdin;
Intel
Nvidia
AMD
\.


--
-- TOC entry 4391 (class 0 OID 4842313)
-- Dependencies: 228
-- Data for Name: motherboard; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.motherboard (id, name, release_year, form_factor, chipset, ram_slot, ram_slot_count, cpu_socket, created_at, updated_at, sata3_slot_count, pcie_slots_json, m2_slots_json, image_url) FROM stdin;
12f74b01-8d46-4df1-9d51-a10ec0c5da12	Asrock B450 Pro4	2018	ATX	AMD B450	DDR4	4	AM4	2022-05-07 10:08:46.294157+00	2022-05-07 10:08:46.294157+00	6	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16","PCIe 2.0 x1"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x2"]}	\N
8e10954d-9d38-419f-b2de-ca32ad918d87	Asrock B460 Pro4	2020	ATX	INTEL B460	DDR4	4	LGA 1200	2022-05-07 11:20:58.878467+00	2022-05-07 11:20:58.878467+00	6	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x1"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4","Wi-Fi"]}	\N
9998ba31-5ec0-495a-8aa5-3a5e822380d0	Asrock X399 Phantom Gaming 6	2018	ATX	AMD X399	DDR4	8	TR4	2022-05-07 11:31:25.544061+00	2022-05-07 11:31:25.544061+00	8	{"pcie_slots":["PCIe 3.0 x16"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4","PCIe 3.0 x4"]}	\N
ef4e33d0-df8e-44bb-9783-46fcb4155dd2	MSI MAG Z390 Tomahawk	2018	ATX	INTEL Z390	DDR4	4	LGA 1151	2022-05-07 11:37:44.918349+00	2022-05-07 11:37:44.918349+00	6	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x1"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4","Wi-Fi"]}	\N
749287f4-5747-4447-afd6-ddca03ddaba8	Gigabyte X570 Aorus Xtreme	2019	E-ATX	AMD X570	DDR4	4	AM4	2022-05-08 03:38:09.695751+00	2022-05-08 03:38:09.695751+00	6	{"pcie_slots":["PCIe 4.0 x16","PCIe 4.0 x16","PCIe 4.0 x16"]}	{"m2_slots":["PCIe 4.0 x4"]}	\N
40e18a9a-48b3-49c8-92ce-f8c9983541cb	Gigabyte Z390 Aorus Xtreme Waterforce	2018	E-ATX	INTEL Z390	DDR4	4	LGA 1151	2022-05-08 04:24:11.879138+00	2022-05-08 04:24:11.879138+00	6	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x1"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4","PCIe 3.0 x4","Wi-Fi"]}	\N
6ee0dc9c-9a24-4fa9-bdf0-7505d77ecec7	Gigabyte Z490 Aorus Xtreme	2020	E-ATX	INTEL Z490	DDR4	4	LGA 1200	2022-05-08 04:31:00.379869+00	2022-05-08 04:31:00.379869+00	6	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x16"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4"]}	\N
77e4f7c8-d076-4f4a-a2a7-c1a8b75f3ad0	Gigabyte X299 Aorus Master	2018	E-ATX	INTEL X299	DDR4	8	LGA 2066	2022-05-08 04:40:31.609339+00	2022-05-08 04:40:31.609339+00	8	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4"]}	\N
a6cf0770-56e7-413f-a504-5eb20f10bdf3	Asus ROG Zenith Extreme Alpha	2019	E-ATX	AMD X399	DDR4	8	TR4	2022-05-08 04:46:36.328726+00	2022-05-08 04:46:36.328726+00	8	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x4","PCIe 3.0 x16"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4"]}	\N
0c943ae4-1e62-45db-9b06-fce4a668f620	Gigabyte B450M DS3H	2018	Micro-ATX	AMD B450	DDR4	4	AM4	2022-05-08 05:25:33.802603+00	2022-05-08 05:25:33.802603+00	4	{"pcie_slots":["PCIe 3.0 x16","PCIe 2.0 x16","PCIe 2.0 x1"]}	{"m2_slots":["PCIe 3.0 x4"]}	\N
f77b4116-6455-45cc-b6e9-9cc673a48fab	Gigabyte H310M DS2	2018	Micro-ATX	INTEL H310	DDR4	2	LGA 1151	2022-05-08 05:30:00.494549+00	2022-05-08 05:30:00.494549+00	4	{"pcie_slots":["PCIe 3.0 x16","PCIe 2.0 x1"]}	\N	\N
d4b51b7f-9827-43ec-b6ef-803521420704	Gigabyte Z490M	2020	Micro-ATX	INTEL Z490	DDR4	4	LGA 1200	2022-05-08 05:34:05.85057+00	2022-05-08 05:34:05.85057+00	6	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x1"]}	{"m2_slots":["PCIe 3.0 x4"]}	\N
a46dbf8f-cd3c-4a45-b97a-34ee40fb486e	Asrock B550 Phantom Gaming-ITX/ax	2020	Mini-ITX	AMD B550	DDR4	2	AM4	2022-05-08 11:00:15.075574+00	2022-05-08 11:00:15.075574+00	4	{"pcie_slots":["PCIe 4.0 x16"]}	{"m2_slots":["PCIe 4.0 x4","PCIe 3.0 x4","Wi-Fi"]}	\N
6a011934-d377-4363-b13a-d26099c684e5	Gigabyte B360N Wifi	2018	Mini-ITX	INTEL B360	DDR4	2	LGA 1151	2022-05-08 11:08:07.26938+00	2022-05-08 11:08:07.26938+00	4	{"pcie_slots":["PCIe 3.0 x16"]}	{"m2_slots":["PCIe 3.0 x4","PCIe 3.0 x4"]}	\N
926ca61d-3e0c-4c72-ac06-b8bac89fc75b	Asrock B460M-ITX/ac	2020	Mini-ITX	INTEL B460	DDR4	2	LGA 1200	2022-05-08 11:17:47.305041+00	2022-05-08 11:17:47.305041+00	4	{"pcie_slots":["PCIe 3.0 x16"]}	{"m2_slots":["PCIe 3.0 x4","Wi-Fi"]}	\N
e6f24233-7708-48dd-ae65-7fa5aaed68ef	Asus ROG Strix X299-E Gaming II	2020	ATX	INTEL X299	DDR4	8	LGA 2066	2022-05-16 10:26:19.212237+00	2022-05-16 10:26:19.212237+00	8	{"pcie_slots":["PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x16","PCIe 3.0 x1"]}	{"m2_slots":["PCIe 3.0 x4"]}	\N
64a54839-038b-4c89-b1d5-19f5b7718e65	MSI X99A SLI PLUS	2015	ATX	INTEL X99	DDR4	8	LGA 2011-3	2022-05-16 15:01:29.904553+00	2022-05-16 15:01:29.904553+00	10	{"pcie_slots":["PCIe 3.0 x16","PCIe 2.0 x1"]}	{"m2_slots":["PCIe 3.0 x4"]}	\N
e9569a16-0837-44c5-8dea-f81d097a4cb2	GIGABYTE GA-Z97X-UD3H	2015	ATX	INTEL Z97	DDR3	4	LGA 1150	2022-05-18 16:15:15.958956+00	2022-05-18 16:15:15.958956+00	6	{"pcie_slots":["PCIe 2.0 x16","PCIe 2.0 x16","PCIe 2.0 x16","PCIe 2.0 x1"]}	\N	\N
052889e3-6ba0-4c12-a50e-81c4e81bbd28	MSI PRO Z690-A WIFI DDR4	2021	ATX	INTEL Z690	DDR4	4	LGA 1700	2022-05-24 14:20:23.021546+00	2022-05-24 14:20:23.021546+00	6	{"pcie_slots":["PCIe 5.0 x16","PCIe 5.0 x16","PCIe 5.0 x16","PCIe 3.0 x1"]}	{"m2_slots":["PCIe 4.0 x4","PCIe 4.0 x4","PCIe 3.0 x4","PCIe 4.0 x4","Wi-Fi"]}	https://cdna.pcpartpicker.com/static/forever/images/product/9a893a5445108a083b1727bcd344b9c1.1600.jpg
9106f84c-a3bd-4be8-bbc0-21f1df7edac8	Gigabyte Z690 AORUS MASTER	2021	E-ATX	INTEL Z690	DDR5	4	LGA 1700	2022-05-24 14:59:32.721026+00	2022-05-24 14:59:32.721026+00	6	{"pcie_slots":["PCIe 5.0 x16","PCIe 3.0 x4","PCIe 3.0 x4"]}	{"m2_slots":["PCIe 4.0 x4","PCIe 4.0 x4","PCIe 4.0 x4","PCIe 3.0 x4","PCIe 4.0 x4"]}	https://cdna.pcpartpicker.com/static/forever/images/product/ea41140e6443430b9d3072b2307a20e1.1600.jpg
fa3e205f-8471-4a26-9267-8761f742d91c	Asus PRIME B660M-A WIFI D4	2022	Micro-ATX	INTEL B660	DDR4	4	LGA 1700	2022-05-25 13:39:56.965914+00	2022-05-25 13:39:56.965914+00	4	{"pcie_slots":["PCIe 4.0 x16","PCIe 3.0 x16","PCIe 3.0 x16"]}	{"m2_slots":["PCIe 4.0 x4","PCIe 4.0 x4"]}	https://cdna.pcpartpicker.com/static/forever/images/product/e6efdca50cee961d09d14143ae4cfd4a.256p.jpg
b7f6ca4d-843f-4bce-afb4-6a83e80795be	ASRock B660M-ITX/ac	2022	Mini-ITX	INTEL B660	DDR4	2	LGA 1700	2022-05-25 13:55:39.312929+00	2022-05-25 13:55:39.312929+00	4	{"pcie_slots":["PCIe 4.0 x16"]}	{"m2_slots":["PCIe 4.0 x4","Wi-Fi"]}	https://cdna.pcpartpicker.com/static/forever/images/product/f799abb73653b256f1bebb87d30f9468.256p.jpg
\.


--
-- TOC entry 4382 (class 0 OID 4816407)
-- Dependencies: 219
-- Data for Name: motherboard_form_factor; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.motherboard_form_factor (form_factor) FROM stdin;
ATX
E-ATX
HPTX
Micro-ATX
Micro-DTX
Micro-STX
Mini-ITX
Mini-STX
Proprietary
SSI-CEB
SSI-EEB
Thin-Mini-ITX
XL-ATX
\.


--
-- TOC entry 4392 (class 0 OID 4866888)
-- Dependencies: 229
-- Data for Name: motherboard_price; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.motherboard_price (id, motherboard_id, price, shop, shop_link, created_at, updated_at) FROM stdin;
22537ba8-079b-4440-b85d-4673f8c2460a	12f74b01-8d46-4df1-9d51-a10ec0c5da12	1428000	Tokopedia	https://www.tokopedia.com/tokoexpert/asrock-b450-pro4-socket-am4?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-07 10:09:15.797828+00	2022-05-07 10:09:15.797828+00
154e5332-f37b-4843-8f66-83a8361649c1	8e10954d-9d38-419f-b2de-ca32ad918d87	1479000	Tokopedia	https://www.tokopedia.com/queenprocessor/asrock-b460m-pro4-lga1200-ddr4-intel-b460-usb-3-2?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-05-07 11:21:27.044041+00	2022-05-07 11:21:27.044041+00
52451e30-df39-446e-be35-2a0f852b6d82	9998ba31-5ec0-495a-8aa5-3a5e822380d0	5990000	Tokopedia	https://www.tokopedia.com/primajayacomp/asrock-x399-phantom-gaming-6?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-07 11:32:38.610623+00	2022-05-07 11:32:38.610623+00
6f4b4452-de68-486c-9e8e-c33bbe5eeb54	ef4e33d0-df8e-44bb-9783-46fcb4155dd2	4940000	Tokopedia	https://www.tokopedia.com/elitecom/msi-mag-z390-tomahawk-lga1151-z390-ddr4-usb3-1-sata3-motherboard?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-07 11:38:07.75256+00	2022-05-07 11:38:07.75256+00
6cbb6303-7224-467d-bd01-38b4d592aadd	749287f4-5747-4447-afd6-ddca03ddaba8	11293000	Tokopedia	https://www.tokopedia.com/maxcom-computer/gigabyte-x570-aorus-xtreme?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 03:38:37.593934+00	2022-05-08 03:38:37.593934+00
345f50ab-e5fb-4873-95be-00cfe1f65a22	40e18a9a-48b3-49c8-92ce-f8c9983541cb	13550000	Tokopedia	https://www.tokopedia.com/global-link168/mainboard-gigabyte-z390-aorus-xtreme-waterforce-lga1151-z390-ddr4-hitam?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 04:24:40.98912+00	2022-05-08 04:24:40.98912+00
eb38411e-8e1b-42b8-a9c1-8d61e896a901	6ee0dc9c-9a24-4fa9-bdf0-7505d77ecec7	7336000	Tokopedia	https://www.tokopedia.com/klikgalaxy/gigabyte-z490-aorus-xtreme-intel-lg1200-b460-ddr4-motherboard?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 04:31:26.146282+00	2022-05-08 04:31:26.146282+00
613c09b0-39f3-4c20-a79d-540c084b5062	77e4f7c8-d076-4f4a-a2a7-c1a8b75f3ad0	10350000	Tokopedia	https://www.tokopedia.com/esportga/gigabyte-x299-aorus-master-lga-2066-intel-x299-ddr4?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 04:40:55.347566+00	2022-05-08 04:40:55.347566+00
6163ccaa-26f7-49dd-b1e9-70edd4e6e8c7	a6cf0770-56e7-413f-a504-5eb20f10bdf3	9220000	Tokopedia	https://www.tokopedia.com/julyaugustshop/asus-rog-zenith-extreme-alpha-motherboard-amd-tr4?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 04:47:06.702941+00	2022-05-08 04:47:06.702941+00
ef4e1e6b-a2ea-45d2-aa7b-558942b69f00	0c943ae4-1e62-45db-9b06-fce4a668f620	1227000	Tokopedia	https://www.tokopedia.com/queenprocessor/mainboard-gigabyte-b450m-ds3h-am4-amd-b450-ddr4-garansi-3-tahun?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 05:26:00.148569+00	2022-05-08 05:26:00.148569+00
cf6f37ba-46a4-47f7-8e6d-083a2e6bf870	f77b4116-6455-45cc-b6e9-9cc673a48fab	935000	Tokopedia	https://www.tokopedia.com/jayapc/motherboard-gigabyte-h310m-ds2-lga1151-h310-ddr4-usb3-1-sata3?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 05:30:25.589392+00	2022-05-08 05:30:25.589392+00
7f28c1d7-49ed-49f2-806d-86f6e73ffc08	d4b51b7f-9827-43ec-b6ef-803521420704	2522000	Tokopedia	https://www.tokopedia.com/cockomputer/gigabyte-z490m?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-05-08 05:34:27.927345+00	2022-05-08 05:34:27.927345+00
85496edb-8e70-4484-8628-63c5d2f6ca39	a46dbf8f-cd3c-4a45-b97a-34ee40fb486e	3323000	Tokopedia	https://www.tokopedia.com/cockomputer/asrock-b550-phantom-gaming-itx-ax?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 11:00:42.390349+00	2022-05-08 11:00:42.390349+00
112686f2-d0b6-4e2d-a306-f9f7878d4bc2	6a011934-d377-4363-b13a-d26099c684e5	2799000	Tokopedia	https://www.tokopedia.com/point99/gigabyte-b360n-wifi-mini-itx-socket-lga1151?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-08 11:08:42.333514+00	2022-05-08 11:08:42.333514+00
4fba0fb8-69d0-4bdf-80a3-012375d4515a	926ca61d-3e0c-4c72-ac06-b8bac89fc75b	1615000	Tokopedia	https://www.tokopedia.com/cockomputer/asrock-b460m-itx-ac?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-05-08 11:18:41.932157+00	2022-05-08 11:18:41.932157+00
01d0efae-ebc8-4897-91f8-237993080141	e6f24233-7708-48dd-ae65-7fa5aaed68ef	8040000	Tokopedia	https://www.tokopedia.com/queenprocessor/motherboard-asus-rog-strix-x299-e-gaming-ii-lga2066-x299-ddr4?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-16 10:26:51.903509+00	2022-05-16 10:26:51.903509+00
5588d62b-fb6e-4d68-bf93-d9fedd23071f	64a54839-038b-4c89-b1d5-19f5b7718e65	4646000	Tokopedia	https://www.tokopedia.com/cockomputer/msi-x99a-sli-plus-lga2011v3-x99-ddr4?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-16 15:02:02.795321+00	2022-05-16 15:02:02.795321+00
3e212557-d23a-4a3d-ac8e-fb92d560bbd7	e9569a16-0837-44c5-8dea-f81d097a4cb2	3009000	Tokopedia	https://www.tokopedia.com/shoponlinebq/gigabyte-ga-z97x-ud3h-motherboard-lga-1150-ddr3-usb3-0-32g-for-intel?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-18 16:15:49.982912+00	2022-05-18 16:15:49.982912+00
40752cfd-6f78-4823-b7af-d0ad4c35f784	052889e3-6ba0-4c12-a50e-81c4e81bbd28	3880000	Tokopedia	https://www.tokopedia.com/klikgalaxy/msi-pro-z690-a-wifi-intel-lga1700-z690-ddr4-alder-lake?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-24 14:20:55.353482+00	2022-05-24 14:20:55.353482+00
1f2c211f-d390-432a-aa7c-827204d817db	9106f84c-a3bd-4be8-bbc0-21f1df7edac8	8290000	Tokopedia	https://www.tokopedia.com/sportonlineshop/gigabyte-z690-aorus-master-intel-z690-lga1700-motherboard?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-24 15:00:25.052817+00	2022-05-24 15:00:25.052817+00
76de1b00-32f2-462c-933e-d5254272d279	fa3e205f-8471-4a26-9267-8761f742d91c	2760000	Tokopedia	https://www.tokopedia.com/nanokomputer/asus-prime-b660m-a-wifi-d4-intel-b660-lga-1700-ddr4-micro-atx?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-25 13:40:30.517876+00	2022-05-25 13:40:30.517876+00
e9c3b5c6-d05f-488a-8454-6de318d078ab	b7f6ca4d-843f-4bce-afb4-6a83e80795be	2061000	Tokopedia	https://www.tokopedia.com/enterkomputer/asrock-b660m-itx-ac-lga1700-b660-ddr4-usb3-2-sata3?extParam=ivf%3Dfalse%26src%3Dsearch&refined=true	2022-05-25 13:56:11.932714+00	2022-05-25 13:56:11.932714+00
\.


--
-- TOC entry 4387 (class 0 OID 4834089)
-- Dependencies: 224
-- Data for Name: power_supply; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.power_supply (id, name, "power_W", efficiency, created_at, updated_at, image_url) FROM stdin;
59ece953-0ff0-41c3-817d-3ba8471aaaf0	Cooler Master ELITE 600 V4 600Watt 80+ White Flat Cable Power Supply	600	80	2022-03-25 07:33:41.886811+00	2022-03-25 07:33:41.886811+00	\N
d92a83df-6ff6-435e-bb6c-c0d200a5809c	COOLER MASTER MWE 650 BRONZE V2 230V	650	80	2022-04-02 13:51:13.269743+00	2022-04-02 13:51:13.269743+00	\N
8422efaa-cc4c-4b80-a1e2-62833b6ecb95	Armaggeddon PSU Plus 80+ Voltron 350FX Max Power 700Watt 12cm RGB Fan	750	80	2022-04-02 14:21:34.31438+00	2022-04-02 14:21:34.31438+00	\N
6cd10dad-c0c7-4901-8f68-6fed08a21585	Enermax MaxPro II 700W 80+ White - EMP700AGT-C	700	80	2022-04-02 14:22:17.906651+00	2022-04-02 14:22:17.906651+00	\N
ec887661-a407-49e1-a10c-d9f2dc416a8c	Cooler Master MWE 750 V2 80+ Bronze	750	80	2022-04-02 14:24:18.907083+00	2022-04-02 14:24:18.907083+00	\N
17e2a4d9-d88d-4b7d-a598-a42cf1a655a9	1STPLAYER Gaming PSU BLACK SIR 450W PS-450BS	450	85	2022-04-02 14:26:32.398021+00	2022-04-02 14:26:32.398021+00	\N
2770764e-1524-4e3f-bb1f-3d692fbdfdf7	GAMEMAX PSU 450W GP-450 80+ Bronze	450	80	2022-04-02 14:27:12.428052+00	2022-04-02 14:27:12.428052+00	\N
cd013df5-3131-470b-9113-3ed7e5f7d5f5	PSU INFINITY 400 W	400	80	2022-04-02 14:28:37.427859+00	2022-04-02 14:28:37.427859+00	\N
868fd1c3-4065-44b7-826f-121146a927b1	1STPLAYER Gaming PSU DK4.0 400W - PS-400AX	400	80	2022-04-02 14:29:24.488168+00	2022-04-02 14:29:24.488168+00	\N
\.


--
-- TOC entry 4390 (class 0 OID 4841486)
-- Dependencies: 227
-- Data for Name: power_supply_prices; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.power_supply_prices (id, psu_id, price, shop, shop_link, created_at, updated_at) FROM stdin;
7c56a97a-e04c-48bd-896e-507bb0ac0680	59ece953-0ff0-41c3-817d-3ba8471aaaf0	690000	Tokopedia	https://www.tokopedia.com/duniacom-srv/cooler-master-elite-600-v4-600watt-80-white-flat-cable-power-supply-free-tumbler	2022-03-25 07:34:08.282812+00	2022-03-25 07:34:08.282812+00
c81e3d31-641d-417e-baaa-2632abf39e43	d92a83df-6ff6-435e-bb6c-c0d200a5809c	919000	Tokopedia	https://www.tokopedia.com/enterkomputer/cooler-master-mwe-650-v2-80-bronze-psu-650w	2022-04-02 13:51:49.694503+00	2022-04-02 13:51:49.694503+00
790bbeef-8290-4a36-b803-c31c741580b6	8422efaa-cc4c-4b80-a1e2-62833b6ecb95	379000	Tokopedia	https://www.tokopedia.com/armaggeddon-id/armaggeddon-psu-plus-80-voltron-350fx-max-power-700watt-12cm-rgb-fan?refined=true	2022-04-02 14:21:57.916821+00	2022-04-02 14:21:57.916821+00
f5085cd3-0fc2-43ba-8080-f130a2b0de0f	6cd10dad-c0c7-4901-8f68-6fed08a21585	781000	Tokopedia	https://www.tokopedia.com/enterkomputer/enermax-maxpro-ii-700w-80-white-emp700agt-c-psu-700w?refined=true	2022-04-02 14:23:31.37726+00	2022-04-02 14:23:31.37726+00
180d9c8a-6e98-41b7-acc1-7de436386487	ec887661-a407-49e1-a10c-d9f2dc416a8c	1056000	Tokopedia	https://www.tokopedia.com/enterkomputer/cooler-master-mwe-750-v2-80-bronze-psu-750w	2022-04-02 14:24:39.996239+00	2022-04-02 14:24:39.996239+00
7c7059fe-0fab-424b-9768-93962273b6df	17e2a4d9-d88d-4b7d-a598-a42cf1a655a9	320000	Tokopedia	https://www.tokopedia.com/enterkomputer/1stplayer-gaming-psu-black-sir-450w-ps-450bs-efficiency-up-to-85	2022-04-02 14:26:48.250702+00	2022-04-02 14:26:48.250702+00
d3e7cda6-8a49-4092-b3bf-9c711f867235	2770764e-1524-4e3f-bb1f-3d692fbdfdf7	520000	Tokopedia	https://www.tokopedia.com/tokoexpert/gamemax-psu-450w-gp-450-80-bronze-1	2022-04-02 14:27:29.939013+00	2022-04-02 14:27:29.939013+00
c53dfb9f-be64-43e1-aa00-6edd2fa2c8ae	cd013df5-3131-470b-9113-3ed7e5f7d5f5	275000	Tokopedia	https://www.tokopedia.com/mega-online-shop/psu-infinity-400-w-80-bronze-garansi-3-tahun	2022-04-02 14:29:02.747915+00	2022-04-02 14:29:02.747915+00
fb1fde8a-de82-4eaa-bd29-e73abef82e7e	868fd1c3-4065-44b7-826f-121146a927b1	480000	Tokopedia	https://www.tokopedia.com/enterkomputer/1stplayer-gaming-psu-dk4-0-400w-ps-400ax-80plus-bronze-3-years-w	2022-04-02 14:29:44.760192+00	2022-04-02 14:29:44.760192+00
\.


--
-- TOC entry 4386 (class 0 OID 4833099)
-- Dependencies: 223
-- Data for Name: ram; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.ram (id, name, size_gb, ram_slot, created_at, updated_at, ram_frequency_mhz, image_url) FROM stdin;
7d75d9b9-f9ff-475b-a46a-e97b41ee4994	RAM IMPERION RGB DDR4 8 GB	8	DDR4	2022-03-24 09:59:30.111054+00	2022-03-24 09:59:30.111054+00	2666	\N
9e2af4c0-e532-459b-9f5a-949c93ae0e31	Crucial DDR4 RAM 8G 3200	8	DDR4	2022-03-24 10:07:04.906392+00	2022-03-24 10:07:04.906392+00	3200	\N
e157372d-c23e-4b68-ae0b-a4960e8cacfe	CORSAIR VENGEANCE® LPX 8GB DDR4	8	DDR4	2022-03-24 10:18:07.032489+00	2022-03-24 10:18:07.032489+00	3200	\N
2d49cf4e-4e12-4bc5-ba57-916d2c54031a	KINGSTON HYPER X FURY DDR4 8GB	8	DDR4	2022-06-05 11:33:46.166222+00	2022-06-05 11:33:46.166222+00	2666	https://images.tokopedia.net/img/cache/900/product-1/2020/5/16/30544786/30544786_b82edabd-03e1-4ed0-851b-47ae7a99b0e3_1000_1000
3bdf8e41-2c07-43e2-8777-817d1892799a	RAM DDR4 V-GeN RESCUE 8GB	8	DDR4	2022-06-05 11:36:54.26839+00	2022-06-05 11:36:54.26839+00	2400	https://images.tokopedia.net/img/cache/900/VqbcmM/2021/2/2/f6fe6e1d-56c9-41bd-965a-f5e22ba34dfa.jpg
\.


--
-- TOC entry 4389 (class 0 OID 4841463)
-- Dependencies: 226
-- Data for Name: ram_prices; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.ram_prices (id, ram_id, price, shop, shop_link, created_at, updated_at, sell_count) FROM stdin;
47f93ba4-37ff-49a8-983d-d59bd53df7b2	e157372d-c23e-4b68-ae0b-a4960e8cacfe	629000.0	Tokopedia	https://www.tokopedia.com/corsair-official/corsair-vengeance-lpx-8gb-ddr4-dram-3200mhz-cmk8gx4m1e3200c16?src=topads	2022-03-24 10:18:29.375417+00	2022-08-05 08:24:25.580708+00	1
a4afdb30-0f82-4936-9add-9e4d105b2eca	9e2af4c0-e532-459b-9f5a-949c93ae0e31	664050.0	Tokopedia	https://www.tokopedia.com/ipason/crucial-ddr4-ram-8g-3200-ballistix-game-memory-white-desktop-diy-pc?src=topads	2022-03-24 10:07:33.268019+00	2022-08-05 08:24:26.605576+00	1
0741b8ff-7918-4b20-b049-6b5660e40218	7d75d9b9-f9ff-475b-a46a-e97b41ee4994	510000.0	Tokopedia	https://www.tokopedia.com/rajaramnusantara/ram-imperion-rgb-ddr4-16gb-2x8gb-2666mhz-kit-ram-pc-rgb-gaming-resmi-8gb-1x8gb?src=topads	2022-03-24 10:05:56.157474+00	2022-08-05 08:24:27.578134+00	1
f8c6fc0f-c983-4edd-8fa7-72454eedcb2c	2d49cf4e-4e12-4bc5-ba57-916d2c54031a	358000.0	Tokopedia	https://www.tokopedia.com/rajaramnusantara/ram-kingston-hyperx-fury-ddr4-8gb-2666mhz-21300-gaming-ram-pc-ddr4-8gb?src=topads	2022-06-05 11:35:14.864041+00	2022-08-05 08:24:28.596976+00	5000
76ab1cfe-bffc-46e5-b6e1-9f3ecdc24b52	3bdf8e41-2c07-43e2-8777-817d1892799a	398000.0	Tokopedia	https://www.tokopedia.com/intact-official/ram-ddr4-v-gen-rescue-8gb-pc19200-2400mhz-long-dimm-memory-pc-vgen?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-05 11:37:35.412117+00	2022-08-05 08:24:29.569753+00	500
\.


--
-- TOC entry 4385 (class 0 OID 4833091)
-- Dependencies: 222
-- Data for Name: ram_slot; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.ram_slot (ram_slot) FROM stdin;
DDR3
DDR4
DDR5
\.


--
-- TOC entry 4379 (class 0 OID 4797485)
-- Dependencies: 216
-- Data for Name: shops; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.shops (shop) FROM stdin;
Tokopedia
Shopee
\.


--
-- TOC entry 4374 (class 0 OID 4710930)
-- Dependencies: 211
-- Data for Name: socket; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.socket (socket_name) FROM stdin;
AM2
AM2+
AM3
AM3+
AM4
FM2+
LGA 1150
LGA 1151
LGA 1155
LGA 1156
LGA 1200
LGA 1366
LGA 2011
LGA 2011-3
LGA 2066
LGA 3647
LGA 775
SP3
TR4
LGA 1700
\.


--
-- TOC entry 4384 (class 0 OID 4817563)
-- Dependencies: 221
-- Data for Name: storage; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.storage (id, name, storage_type, size, created_at, updated_at, quality_index, interface_bus, image_url) FROM stdin;
038c902c-0b81-4410-b1eb-a12deead325b	SSD WD Green 480GB SN350 Nvme M.2 2280	M2 NVME SSD	480 GB	2022-03-23 09:01:21.601534+00	2022-03-23 09:45:00.16601+00	2	PCIe 3.0 x4	\N
38be0335-c62a-4a0d-b370-ec120053b4f3	WD GREEN SSD SN350 1TB - M2 NVME 2280	M2 NVME SSD	1 TB	2022-03-23 09:06:19.61467+00	2022-03-23 09:45:03.084589+00	2	PCIe 3.0 x4	\N
64ac1050-2716-4bd2-acfe-1f32bb7b694a	SSD ADATA XPG SX6000 LITE 512 GB PCIe3x4 M2 2280 NVME	M2 NVME SSD	512 GB	2022-03-23 09:43:00.508743+00	2022-03-23 09:45:06.134508+00	2	PCIe 3.0 x4	\N
5da23999-cf44-4eb1-91e2-671ad26764d2	Samsung SSD 980 PRO M.2 PCIe NVMe Gen4 M2 Internal SSD - 500GB	M2 NVME SSD	512 GB	2022-03-23 09:50:16.098148+00	2022-03-23 09:50:16.098148+00	4	PCIe 4.0 x4	\N
a6a7b148-9bd7-4a2c-b6e8-c7f3ac74c5ff	Samsung SSD 980 PRO M.2 PCIe NVMe Gen4 M2 Internal SSD - 1 TB	M2 NVME SSD	1 TB	2022-03-23 09:50:31.399457+00	2022-03-23 09:50:31.399457+00	4	PCIe 4.0 x4	\N
a0ec925c-9b0e-41ba-9010-86f4d436ae6a	Samsung SSD 980 PRO M.2 PCIe NVMe Gen4 M2 Internal SSD - 2 TB	M2 NVME SSD	2 TB	2022-03-23 09:50:31.399457+00	2022-03-23 09:50:31.399457+00	4	PCIe 4.0 x4	\N
b6a001b7-a8b3-4f69-b0f2-30aa9c44f436	Samsung SSD 980 M.2 PCIe NVMe 1.4 Gen3 M2 Internal SSD - 500GB	M2 NVME SSD	512 GB	2022-03-23 09:54:24.175419+00	2022-03-23 09:54:24.175419+00	3	PCIe 3.0 x4	\N
9aa18a2a-ddb0-49ef-b3fc-74f02c1d2d45	Samsung SSD 980 M.2 PCIe NVMe 1.4 Gen3 M2 Internal SSD - 1 TB	M2 NVME SSD	1 TB	2022-03-23 09:54:32.189484+00	2022-03-23 09:54:32.189484+00	3	PCIe 3.0 x4	\N
ce3dd4e3-3dcb-4964-8e3e-3382b7dac7b6	RX7 M2 NVME - 512 GB	M2 NVME SSD	512 GB	2022-03-23 08:26:55.16977+00	2022-03-23 09:54:59.074058+00	1	PCIe 3.0 x4	\N
adc57eff-144a-43e5-a57a-b2f0ffecb2cc	RX7 M2 NVME - 1 TB	M2 NVME SSD	1 TB	2022-03-23 08:26:55.16977+00	2022-03-23 09:55:06.830767+00	1	PCIe 3.0 x4	\N
24fd4110-b4fb-4c01-ab35-c3813a84fe69	V-Gen SSD SATA III 128GB	Sata3 SSD	128 GB	2022-05-07 06:32:42.316931+00	2022-05-07 06:32:42.316931+00	2	\N	\N
a59aa79d-a40a-404e-97b5-8f0c44f9a9d7	V-Gen SSD SATA III 256GB	Sata3 SSD	240 GB	2022-05-07 09:12:55.027103+00	2022-05-07 09:12:55.027103+00	2	\N	\N
87fd9ab0-11f9-4a91-8628-238f0a4d3909	V-Gen SSD SATA III 512GB	Sata3 SSD	512 GB	2022-05-07 09:16:46.35696+00	2022-05-07 09:16:46.35696+00	2	\N	\N
ca836457-9b4f-4a5d-b3c1-1c61fa994803	V-Gen SSD SATA III 1TB	Sata3 SSD	960 GB	2022-05-07 09:23:02.320066+00	2022-05-07 09:23:02.320066+00	2	\N	\N
3be312fa-435c-4cdf-943d-e6ce631c4eae	MIDASFORCE SSD M2 NVME - 512GB	M2 NVME SSD	512 GB	2022-06-05 13:19:31.695597+00	2022-06-05 13:19:31.695597+00	1	PCIe 3.0 x4	https://images.tokopedia.net/img/cache/900/VqbcmM/2021/9/18/cea15b9e-a05e-4e4b-84ab-6b9700fb4f40.jpg
\.


--
-- TOC entry 4388 (class 0 OID 4841431)
-- Dependencies: 225
-- Data for Name: storage_prices; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.storage_prices (id, storage_id, price, shop, shop_link, created_at, updated_at, name) FROM stdin;
184f188c-ed6d-458a-a3fa-da99a4b720e8	a6a7b148-9bd7-4a2c-b6e8-c7f3ac74c5ff	2792000.0	Tokopedia	https://www.tokopedia.com/samsung-storage/samsung-ssd-980-pro-250gb-500gb-m-2-pcie-nvme-gen4-m2-internal-ssd-1tb	2022-03-23 10:43:30.63689+00	2022-07-30 14:34:36.846414+00	Samsung SSD 980 PRO 250GB 500GB M.2 PCIe NVMe Gen4 M2 Internal SSD - 1 TB
e407bc43-8081-4a99-88bc-ca976c456a4c	a0ec925c-9b0e-41ba-9010-86f4d436ae6a	6121500.0	Tokopedia	https://www.tokopedia.com/samsung-storage/samsung-ssd-980-pro-250gb-500gb-m-2-pcie-nvme-gen4-m2-internal-ssd-2tb	2022-03-23 10:43:57.780737+00	2022-07-30 14:34:37.76103+00	Samsung SSD 980 PRO 250GB 500GB M.2 PCIe NVMe Gen4 M2 Internal SSD - 2TB
fccb6fc5-6e95-4139-847d-e2383d44e2bb	ce3dd4e3-3dcb-4964-8e3e-3382b7dac7b6	540000.0	Tokopedia	https://www.tokopedia.com/indolegend/ssd-m2-nvme-m-2-nvme-m2nvme-512gb-rx7-resmi-garansi-3-tahun?src=topads	2022-03-23 08:27:22.140747+00	2022-07-30 14:34:38.763189+00	SSD M.2 NVME 512GB RX7
5299b392-de2b-4ee1-8c53-881fa036d43c	ca836457-9b4f-4a5d-b3c1-1c61fa994803	1118000.0	Tokopedia	https://www.tokopedia.com/slnstore/ssd-960gb-v-gen-sata-iii-6-0gbps-solid-state-drive-960-gb-1tb-vgen?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-07 09:25:48.227105+00	2022-07-30 14:34:39.813261+00	SSD 960GB V-GeN SATA III 6.0GBps Solid State Drive 960 GB - 1TB Vgen
5f170d0e-4a93-432f-83fc-99bc190e02bc	24fd4110-b4fb-4c01-ab35-c3813a84fe69	260000.0	Tokopedia	https://www.tokopedia.com/vgenjogja/ssd-128gb-2tb-v-gen-sata-iii-128gb?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-07 06:33:39.914945+00	2022-07-30 14:34:40.847939+00	SSD 128GB - 2TB V-GeN SATA III - 128GB
8082dce8-000f-4a36-ab6d-e2a3b3d45382	a59aa79d-a40a-404e-97b5-8f0c44f9a9d7	328000.0	Tokopedia	https://www.tokopedia.com/v-genindonesia/ssd-v-gen-solid-state-drive-256gb-sata-3-ssd-sata-iii-vgen?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-07 09:13:39.202604+00	2022-07-30 14:34:41.950148+00	SSD V-GeN Solid State Drive 256GB SATA 3 SSD SATA III VGEN
4d56cac5-1b72-4623-b0aa-b223306f181f	87fd9ab0-11f9-4a91-8628-238f0a4d3909	618000.0	Tokopedia	https://www.tokopedia.com/v-genindonesia/ssd-v-gen-solid-state-drive-v-gen-512gb-sata-3-ssd-sata-iii-vgen?extParam=ivf%3Dfalse%26src%3Dsearch	2022-05-07 09:19:27.132263+00	2022-07-30 14:34:42.938129+00	SSD V-GeN Solid State Drive V-GeN 512GB SATA 3 SSD SATA III VGEN
4da2c6c9-60d0-4dd3-8e5a-d161e704afff	adc57eff-144a-43e5-a57a-b2f0ffecb2cc	986000.0	Tokopedia	https://www.tokopedia.com/indolegend/ssd-m2-nvme-m-2-nvme-m2nvme-1tb-rx7-resmi-garansi-3-tahun	2022-03-23 08:57:05.307311+00	2022-07-30 14:34:43.900217+00	SSD M2 NVME 1TB RX7 
86567889-0d1c-44bc-955a-c99826bc1bca	038c902c-0b81-4410-b1eb-a12deead325b	810000.0	Tokopedia	https://www.tokopedia.com/eternalasia/ssd-wd-green-480gb-sn350-nvme-m-2-2280?src=topads	2022-03-23 09:01:49.198169+00	2022-07-30 14:34:44.850078+00	SSD WD Green 480GB SN350 Nvme M.2 2280
6a96bbba-62e0-48e6-bc6f-a1e72bda2c27	38be0335-c62a-4a0d-b370-ec120053b4f3	1539000.0	Tokopedia	https://www.tokopedia.com/atkiosk/wd-green-ssd-sn350-1tb-m2-nvme-2280-garansi-3-tahun-original?src=topads	2022-03-23 09:08:48.22056+00	2022-07-30 14:34:45.748906+00	WD GREEN SSD SN350 1TB - M2 NVME 2280 - Garansi 3 Tahun - Original
b6a84da2-738a-4acf-92bc-d479b72e3e5e	64ac1050-2716-4bd2-acfe-1f32bb7b694a	780000.0	Tokopedia	https://www.tokopedia.com/yoestore/ssd-adata-xpg-sx6000-lite-512-gb-pcie3x4-m2-2280-nvme-new-fast	2022-03-23 09:48:03.313874+00	2022-07-30 14:34:46.697074+00	SSD ADATA XPG SX6000 LITE 512 GB PCIe3x4 M2 2280 NVME NEW & FAST
eb620415-e8fa-4f3a-a0f7-02100be74291	b6a001b7-a8b3-4f69-b0f2-30aa9c44f436	1047025.0	Tokopedia	https://www.tokopedia.com/samsung-storage/samsung-ssd-980-250gb-500gb-1tb-m-2-pcie-nvme-1-4-gen3-m2-internal-ssd-500gb	2022-03-23 10:42:14.283891+00	2022-07-30 14:34:34.02852+00	Samsung SSD 980 250GB 500GB 1TB M.2 PCIe NVMe 1.4 Gen3 M2 Internal SSD - 500GB
da59e8a8-8509-4aa4-b140-f47828cc1c8a	9aa18a2a-ddb0-49ef-b3fc-74f02c1d2d45	1804000.0	Tokopedia	https://www.tokopedia.com/samsung-storage/samsung-ssd-980-250gb-500gb-1tb-m-2-pcie-nvme-1-4-gen3-m2-internal-ssd-1tb	2022-03-23 10:42:36.560908+00	2022-07-30 14:34:34.967371+00	Samsung SSD 980 250GB 500GB 1TB M.2 PCIe NVMe 1.4 Gen3 M2 Internal SSD - 1TB
75a7688f-7e73-4de0-9613-96512c345a1f	5da23999-cf44-4eb1-91e2-671ad26764d2	1891000.0	Tokopedia	https://www.tokopedia.com/samsung-storage/samsung-ssd-980-pro-250gb-500gb-m-2-pcie-nvme-gen4-m2-internal-ssd-500gb	2022-03-23 10:43:09.673096+00	2022-07-30 14:34:35.901704+00	Samsung SSD 980 PRO 250GB 500GB M.2 PCIe NVMe Gen4 M2 Internal SSD - 500GB
2b7d428f-2566-47c7-a6a5-21635202aba7	3be312fa-435c-4cdf-943d-e6ce631c4eae	603000.0	Tokopedia	https://www.tokopedia.com/santikacomp/m2-nvme-512gb-midas-m-2-nvme-512gb-midasforce-pcie-gen3-x4-ssd-baut-nvme?extParam=ivf%3Dfalse%26src%3Dsearch	2022-06-05 13:20:51.752954+00	2022-07-30 14:34:47.692973+00	M2 NVME 512GB MIDAS M.2 NVME 512GB MIDASFORCE PCIe Gen3 x4 SSD
\.


--
-- TOC entry 4383 (class 0 OID 4817117)
-- Dependencies: 220
-- Data for Name: storage_type; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.storage_type (storage_type) FROM stdin;
M2 NVME SSD
M2 SATA SSD
Sata3 SSD
Sata3 HDD
\.


--
-- TOC entry 4395 (class 0 OID 4867021)
-- Dependencies: 232
-- Data for Name: target_market; Type: TABLE DATA; Schema: public; Owner: bcktrcvcxvfuys
--

COPY public.target_market (power_number, target_market) FROM stdin;
1	Office
2	Gaming
3	Workstation
4	Enthusiast
\.


--
-- TOC entry 4124 (class 2606 OID 3657918)
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4131 (class 2606 OID 3657943)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4127 (class 2606 OID 3657931)
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4120 (class 2606 OID 3657905)
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 4122 (class 2606 OID 3657907)
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- TOC entry 4136 (class 2606 OID 3657973)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4134 (class 2606 OID 3657962)
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4138 (class 2606 OID 3657989)
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4118 (class 2606 OID 3657895)
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- TOC entry 4184 (class 2606 OID 4895125)
-- Name: manufacturer Manufacturer_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.manufacturer
    ADD CONSTRAINT "Manufacturer_pkey" PRIMARY KEY (manufacturer_name);


--
-- TOC entry 4186 (class 2606 OID 5624334)
-- Name: case case_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public."case"
    ADD CONSTRAINT case_pkey PRIMARY KEY (id);


--
-- TOC entry 4188 (class 2606 OID 5624358)
-- Name: case_prices case_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.case_prices
    ADD CONSTRAINT case_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4142 (class 2606 OID 4710978)
-- Name: chipset chipset_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.chipset
    ADD CONSTRAINT chipset_pkey PRIMARY KEY (chipset_name);


--
-- TOC entry 4178 (class 2606 OID 4866924)
-- Name: cooling cooling_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cooling
    ADD CONSTRAINT cooling_pkey PRIMARY KEY (id);


--
-- TOC entry 4180 (class 2606 OID 4866943)
-- Name: cooling_prices cooling_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cooling_prices
    ADD CONSTRAINT cooling_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4144 (class 2606 OID 4725306)
-- Name: cpu cpu_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cpu
    ADD CONSTRAINT cpu_pkey PRIMARY KEY (id);


--
-- TOC entry 4152 (class 2606 OID 4797508)
-- Name: cpu_prices cpu_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cpu_prices
    ADD CONSTRAINT cpu_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4146 (class 2606 OID 4778758)
-- Name: interface_bus gpu_bus_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.interface_bus
    ADD CONSTRAINT gpu_bus_pkey PRIMARY KEY (bus_name);


--
-- TOC entry 4148 (class 2606 OID 4797477)
-- Name: gpu gpu_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.gpu
    ADD CONSTRAINT gpu_pkey PRIMARY KEY (id);


--
-- TOC entry 4154 (class 2606 OID 4877495)
-- Name: gpu_prices gpu_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.gpu_prices
    ADD CONSTRAINT gpu_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4156 (class 2606 OID 4816414)
-- Name: motherboard_form_factor motherboard_form_factor_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard_form_factor
    ADD CONSTRAINT motherboard_form_factor_pkey PRIMARY KEY (form_factor);


--
-- TOC entry 4174 (class 2606 OID 4842321)
-- Name: motherboard motherboard_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard
    ADD CONSTRAINT motherboard_pkey PRIMARY KEY (id);


--
-- TOC entry 4176 (class 2606 OID 4866898)
-- Name: motherboard_price motherboard_price_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard_price
    ADD CONSTRAINT motherboard_price_pkey PRIMARY KEY (id);


--
-- TOC entry 4166 (class 2606 OID 4834100)
-- Name: power_supply power_supply_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.power_supply
    ADD CONSTRAINT power_supply_pkey PRIMARY KEY (id);


--
-- TOC entry 4172 (class 2606 OID 4841496)
-- Name: power_supply_prices power_supply_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.power_supply_prices
    ADD CONSTRAINT power_supply_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4164 (class 2606 OID 4833109)
-- Name: ram ram_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.ram
    ADD CONSTRAINT ram_pkey PRIMARY KEY (id);


--
-- TOC entry 4170 (class 2606 OID 4841473)
-- Name: ram_prices ram_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.ram_prices
    ADD CONSTRAINT ram_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4162 (class 2606 OID 4833098)
-- Name: ram_slot ram_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.ram_slot
    ADD CONSTRAINT ram_slot_pkey PRIMARY KEY (ram_slot);


--
-- TOC entry 4150 (class 2606 OID 4797492)
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (shop);


--
-- TOC entry 4140 (class 2606 OID 4710960)
-- Name: socket socket_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.socket
    ADD CONSTRAINT socket_pkey PRIMARY KEY (socket_name);


--
-- TOC entry 4160 (class 2606 OID 4817573)
-- Name: storage storage_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.storage
    ADD CONSTRAINT storage_pkey PRIMARY KEY (id);


--
-- TOC entry 4168 (class 2606 OID 4841441)
-- Name: storage_prices storage_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.storage_prices
    ADD CONSTRAINT storage_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4158 (class 2606 OID 4817124)
-- Name: storage_type storage_type_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.storage_type
    ADD CONSTRAINT storage_type_pkey PRIMARY KEY (storage_type);


--
-- TOC entry 4182 (class 2606 OID 4867028)
-- Name: target_market target_market_pkey; Type: CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.target_market
    ADD CONSTRAINT target_market_pkey PRIMARY KEY (power_number);


--
-- TOC entry 4129 (class 1259 OID 3657949)
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- TOC entry 4125 (class 1259 OID 3657932)
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- TOC entry 4128 (class 1259 OID 3657933)
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- TOC entry 4132 (class 1259 OID 3657963)
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- TOC entry 4116 (class 1259 OID 3657896)
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- TOC entry 4235 (class 2620 OID 5624369)
-- Name: case_prices set_public_case_prices_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_case_prices_updated_at BEFORE UPDATE ON public.case_prices FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 4235
-- Name: TRIGGER set_public_case_prices_updated_at ON case_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_case_prices_updated_at ON public.case_prices IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4234 (class 2620 OID 5624340)
-- Name: case set_public_case_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_case_updated_at BEFORE UPDATE ON public."case" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 4234
-- Name: TRIGGER set_public_case_updated_at ON "case"; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_case_updated_at ON public."case" IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4233 (class 2620 OID 4866954)
-- Name: cooling_prices set_public_cooling_prices_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_cooling_prices_updated_at BEFORE UPDATE ON public.cooling_prices FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 4233
-- Name: TRIGGER set_public_cooling_prices_updated_at ON cooling_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_cooling_prices_updated_at ON public.cooling_prices IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4232 (class 2620 OID 4866925)
-- Name: cooling set_public_cooling_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_cooling_updated_at BEFORE UPDATE ON public.cooling FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 4232
-- Name: TRIGGER set_public_cooling_updated_at ON cooling; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_cooling_updated_at ON public.cooling IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4222 (class 2620 OID 4797514)
-- Name: cpu_prices set_public_cpu_prices_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_cpu_prices_updated_at BEFORE UPDATE ON public.cpu_prices FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 4222
-- Name: TRIGGER set_public_cpu_prices_updated_at ON cpu_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_cpu_prices_updated_at ON public.cpu_prices IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4220 (class 2620 OID 4725313)
-- Name: cpu set_public_cpu_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_cpu_updated_at BEFORE UPDATE ON public.cpu FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 4220
-- Name: TRIGGER set_public_cpu_updated_at ON cpu; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_cpu_updated_at ON public.cpu IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4223 (class 2620 OID 4797533)
-- Name: gpu_prices set_public_gpu_prices_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_gpu_prices_updated_at BEFORE UPDATE ON public.gpu_prices FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 4223
-- Name: TRIGGER set_public_gpu_prices_updated_at ON gpu_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_gpu_prices_updated_at ON public.gpu_prices IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4221 (class 2620 OID 4834114)
-- Name: gpu set_public_gpu_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_gpu_updated_at BEFORE UPDATE ON public.gpu FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 4221
-- Name: TRIGGER set_public_gpu_updated_at ON gpu; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_gpu_updated_at ON public.gpu IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4231 (class 2620 OID 4866909)
-- Name: motherboard_price set_public_motherboard_price_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_motherboard_price_updated_at BEFORE UPDATE ON public.motherboard_price FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 4231
-- Name: TRIGGER set_public_motherboard_price_updated_at ON motherboard_price; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_motherboard_price_updated_at ON public.motherboard_price IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4230 (class 2620 OID 4877492)
-- Name: motherboard set_public_motherboard_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_motherboard_updated_at BEFORE UPDATE ON public.motherboard FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4441 (class 0 OID 0)
-- Dependencies: 4230
-- Name: TRIGGER set_public_motherboard_updated_at ON motherboard; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_motherboard_updated_at ON public.motherboard IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4229 (class 2620 OID 4841507)
-- Name: power_supply_prices set_public_power_supply_prices_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_power_supply_prices_updated_at BEFORE UPDATE ON public.power_supply_prices FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4442 (class 0 OID 0)
-- Dependencies: 4229
-- Name: TRIGGER set_public_power_supply_prices_updated_at ON power_supply_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_power_supply_prices_updated_at ON public.power_supply_prices IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4226 (class 2620 OID 4834101)
-- Name: power_supply set_public_power_supply_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_power_supply_updated_at BEFORE UPDATE ON public.power_supply FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4443 (class 0 OID 0)
-- Dependencies: 4226
-- Name: TRIGGER set_public_power_supply_updated_at ON power_supply; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_power_supply_updated_at ON public.power_supply IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4228 (class 2620 OID 4841484)
-- Name: ram_prices set_public_ram_prices_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_ram_prices_updated_at BEFORE UPDATE ON public.ram_prices FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4444 (class 0 OID 0)
-- Dependencies: 4228
-- Name: TRIGGER set_public_ram_prices_updated_at ON ram_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_ram_prices_updated_at ON public.ram_prices IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4225 (class 2620 OID 4833115)
-- Name: ram set_public_ram_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_ram_updated_at BEFORE UPDATE ON public.ram FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4445 (class 0 OID 0)
-- Dependencies: 4225
-- Name: TRIGGER set_public_ram_updated_at ON ram; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_ram_updated_at ON public.ram IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4227 (class 2620 OID 4841452)
-- Name: storage_prices set_public_storage_prices_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_storage_prices_updated_at BEFORE UPDATE ON public.storage_prices FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4446 (class 0 OID 0)
-- Dependencies: 4227
-- Name: TRIGGER set_public_storage_prices_updated_at ON storage_prices; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_storage_prices_updated_at ON public.storage_prices IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4224 (class 2620 OID 4817574)
-- Name: storage set_public_storage_updated_at; Type: TRIGGER; Schema: public; Owner: bcktrcvcxvfuys
--

CREATE TRIGGER set_public_storage_updated_at BEFORE UPDATE ON public.storage FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- TOC entry 4447 (class 0 OID 0)
-- Dependencies: 4224
-- Name: TRIGGER set_public_storage_updated_at ON storage; Type: COMMENT; Schema: public; Owner: bcktrcvcxvfuys
--

COMMENT ON TRIGGER set_public_storage_updated_at ON public.storage IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4189 (class 2606 OID 3657944)
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4190 (class 2606 OID 3657974)
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4218 (class 2606 OID 5624359)
-- Name: case_prices case_prices_case_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.case_prices
    ADD CONSTRAINT case_prices_case_id_fkey FOREIGN KEY (case_id) REFERENCES public."case"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4219 (class 2606 OID 5624364)
-- Name: case_prices case_prices_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.case_prices
    ADD CONSTRAINT case_prices_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4216 (class 2606 OID 4866944)
-- Name: cooling_prices cooling_prices_cooling_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cooling_prices
    ADD CONSTRAINT cooling_prices_cooling_id_fkey FOREIGN KEY (cooling_id) REFERENCES public.cooling(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4217 (class 2606 OID 4866949)
-- Name: cooling_prices cooling_prices_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cooling_prices
    ADD CONSTRAINT cooling_prices_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4193 (class 2606 OID 4895127)
-- Name: cpu cpu_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cpu
    ADD CONSTRAINT cpu_manufacturer_fkey FOREIGN KEY (manufacturer) REFERENCES public.manufacturer(manufacturer_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4197 (class 2606 OID 4797509)
-- Name: cpu_prices cpu_prices_cpu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cpu_prices
    ADD CONSTRAINT cpu_prices_cpu_id_fkey FOREIGN KEY (cpu_id) REFERENCES public.cpu(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4198 (class 2606 OID 4841458)
-- Name: cpu_prices cpu_prices_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cpu_prices
    ADD CONSTRAINT cpu_prices_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4191 (class 2606 OID 4725307)
-- Name: cpu cpu_socket_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cpu
    ADD CONSTRAINT cpu_socket_name_fkey FOREIGN KEY (socket_name) REFERENCES public.socket(socket_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4192 (class 2606 OID 4867031)
-- Name: cpu cpu_target_market_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.cpu
    ADD CONSTRAINT cpu_target_market_number_fkey FOREIGN KEY (target_market_number) REFERENCES public.target_market(power_number) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4196 (class 2606 OID 5637341)
-- Name: gpu gpu_interface_bus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.gpu
    ADD CONSTRAINT gpu_interface_bus_fkey FOREIGN KEY (interface_bus) REFERENCES public.interface_bus(bus_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4195 (class 2606 OID 4895153)
-- Name: gpu gpu_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.gpu
    ADD CONSTRAINT gpu_manufacturer_fkey FOREIGN KEY (manufacturer) REFERENCES public.manufacturer(manufacturer_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4199 (class 2606 OID 4797528)
-- Name: gpu_prices gpu_prices_gpu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.gpu_prices
    ADD CONSTRAINT gpu_prices_gpu_id_fkey FOREIGN KEY (gpu_id) REFERENCES public.gpu(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4200 (class 2606 OID 4841453)
-- Name: gpu_prices gpu_prices_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.gpu_prices
    ADD CONSTRAINT gpu_prices_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4194 (class 2606 OID 4867036)
-- Name: gpu gpu_target_market_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.gpu
    ADD CONSTRAINT gpu_target_market_number_fkey FOREIGN KEY (target_market_number) REFERENCES public.target_market(power_number) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4211 (class 2606 OID 4842327)
-- Name: motherboard motherboard_chipset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard
    ADD CONSTRAINT motherboard_chipset_fkey FOREIGN KEY (chipset) REFERENCES public.chipset(chipset_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4213 (class 2606 OID 4877467)
-- Name: motherboard motherboard_cpu_socket_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard
    ADD CONSTRAINT motherboard_cpu_socket_fkey FOREIGN KEY (cpu_socket) REFERENCES public.socket(socket_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4210 (class 2606 OID 4842322)
-- Name: motherboard motherboard_form_factor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard
    ADD CONSTRAINT motherboard_form_factor_fkey FOREIGN KEY (form_factor) REFERENCES public.motherboard_form_factor(form_factor) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4214 (class 2606 OID 4866899)
-- Name: motherboard_price motherboard_price_motherboard_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard_price
    ADD CONSTRAINT motherboard_price_motherboard_id_fkey FOREIGN KEY (motherboard_id) REFERENCES public.motherboard(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4215 (class 2606 OID 4866904)
-- Name: motherboard_price motherboard_price_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard_price
    ADD CONSTRAINT motherboard_price_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4212 (class 2606 OID 4842332)
-- Name: motherboard motherboard_ram_slot_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.motherboard
    ADD CONSTRAINT motherboard_ram_slot_fkey FOREIGN KEY (ram_slot) REFERENCES public.ram_slot(ram_slot) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4208 (class 2606 OID 4841497)
-- Name: power_supply_prices power_supply_prices_psu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.power_supply_prices
    ADD CONSTRAINT power_supply_prices_psu_id_fkey FOREIGN KEY (psu_id) REFERENCES public.power_supply(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4209 (class 2606 OID 4841502)
-- Name: power_supply_prices power_supply_prices_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.power_supply_prices
    ADD CONSTRAINT power_supply_prices_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4206 (class 2606 OID 4841474)
-- Name: ram_prices ram_prices_ram_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.ram_prices
    ADD CONSTRAINT ram_prices_ram_id_fkey FOREIGN KEY (ram_id) REFERENCES public.ram(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4207 (class 2606 OID 4841479)
-- Name: ram_prices ram_prices_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.ram_prices
    ADD CONSTRAINT ram_prices_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4203 (class 2606 OID 4833110)
-- Name: ram ram_ram_slot_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.ram
    ADD CONSTRAINT ram_ram_slot_fkey FOREIGN KEY (ram_slot) REFERENCES public.ram_slot(ram_slot) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4201 (class 2606 OID 4973996)
-- Name: storage storage_interface_bus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.storage
    ADD CONSTRAINT storage_interface_bus_fkey FOREIGN KEY (interface_bus) REFERENCES public.interface_bus(bus_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4205 (class 2606 OID 4841447)
-- Name: storage_prices storage_prices_shop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.storage_prices
    ADD CONSTRAINT storage_prices_shop_fkey FOREIGN KEY (shop) REFERENCES public.shops(shop) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4204 (class 2606 OID 4841442)
-- Name: storage_prices storage_prices_storage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.storage_prices
    ADD CONSTRAINT storage_prices_storage_id_fkey FOREIGN KEY (storage_id) REFERENCES public.storage(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4202 (class 2606 OID 5748675)
-- Name: storage storage_storage_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bcktrcvcxvfuys
--

ALTER TABLE ONLY public.storage
    ADD CONSTRAINT storage_storage_type_fkey FOREIGN KEY (storage_type) REFERENCES public.storage_type(storage_type) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4404 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA heroku_ext; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA heroku_ext TO bcktrcvcxvfuys WITH GRANT OPTION;


--
-- TOC entry 4406 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: bcktrcvcxvfuys
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO bcktrcvcxvfuys;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 4407 (class 0 OID 0)
-- Dependencies: 828
-- Name: LANGUAGE plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO bcktrcvcxvfuys;


-- Completed on 2022-09-28 16:33:40

--
-- PostgreSQL database dump complete
--

