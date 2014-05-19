--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    line_1 character varying(255),
    line_2 character varying(255),
    line_3 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    province character varying(255),
    country character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: addresses_shipments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses_shipments (
    address_id integer NOT NULL,
    shipment_id integer NOT NULL
);


--
-- Name: addresses_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses_users (
    address_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: barcodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE barcodes (
    id integer NOT NULL,
    barcode character varying(255),
    barcode_set integer DEFAULT 0,
    barcodeable_id integer,
    barcodeable_type character varying(255)
);


--
-- Name: barcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE barcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: barcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE barcodes_id_seq OWNED BY barcodes.id;


--
-- Name: container_changes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE container_changes (
    id integer NOT NULL,
    container_id integer,
    past_ancestry_container_id integer,
    new_ancestry_container_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: container_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE container_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: container_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE container_changes_id_seq OWNED BY container_changes.id;


--
-- Name: container_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE container_types (
    id integer NOT NULL,
    type_id integer,
    name character varying(255),
    x_dimension integer DEFAULT 1,
    y_dimension integer DEFAULT 1,
    can_have_children boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    retired boolean DEFAULT false,
    label character varying(255),
    shipable boolean,
    can_have_external_identifier boolean DEFAULT false
);


--
-- Name: container_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE container_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: container_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE container_types_id_seq OWNED BY container_types.id;


--
-- Name: containers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE containers (
    id integer NOT NULL,
    container_type_id integer,
    name character varying(255),
    barcode_string character varying(255),
    ancestry character varying(500),
    ancestry_depth integer DEFAULT 0,
    container_x integer DEFAULT 0,
    container_y integer DEFAULT 0,
    retired boolean DEFAULT false,
    tags character varying(500),
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tsv_content tsvector,
    shipped boolean,
    external_identifier character varying(255)
);


--
-- Name: containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE containers_id_seq OWNED BY containers.id;


--
-- Name: containers_shipments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE containers_shipments (
    container_id integer,
    shipment_id integer
);


--
-- Name: external_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE external_links (
    id integer NOT NULL,
    name character varying(255),
    url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sample_id integer
);


--
-- Name: external_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE external_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: external_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE external_links_id_seq OWNED BY external_links.id;


--
-- Name: investigations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE investigations (
    id integer NOT NULL,
    title text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier character varying(255),
    tsv_content tsvector,
    description text
);


--
-- Name: investigations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE investigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: investigations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE investigations_id_seq OWNED BY investigations.id;


--
-- Name: investigations_people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE investigations_people (
    investigation_id integer,
    person_id integer
);


--
-- Name: material_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE material_types (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tsv_content tsvector
);


--
-- Name: material_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE material_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: material_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE material_types_id_seq OWNED BY material_types.id;


--
-- Name: material_types_samples; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE material_types_samples (
    material_type_id integer,
    sample_id integer
);


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_access_grants (
    id integer NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id integer NOT NULL,
    token character varying(255) NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying(255)
);


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_access_tokens (
    id integer NOT NULL,
    resource_owner_id integer,
    application_id integer NOT NULL,
    token character varying(255) NOT NULL,
    refresh_token character varying(255),
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying(255)
);


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oauth_applications (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;


--
-- Name: ontologies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ontologies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    release character varying(255),
    description character varying(500),
    uri character varying(255) NOT NULL,
    prefix character varying(255) NOT NULL
);


--
-- Name: ontologies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ontologies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ontologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ontologies_id_seq OWNED BY ontologies.id;


--
-- Name: ontology_terms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ontology_terms (
    id integer NOT NULL,
    ontology_id integer NOT NULL,
    accession character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(255),
    ancestry character varying(500),
    ancestry_depth integer DEFAULT 0,
    obsolete boolean DEFAULT false
);


--
-- Name: ontology_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ontology_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ontology_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ontology_terms_id_seq OWNED BY ontology_terms.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    id integer NOT NULL,
    firstname character varying(255),
    type character varying(255),
    institution character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying(255),
    phone integer,
    lastname character varying(255),
    user_id integer,
    study_id integer,
    tsv_content tsvector,
    laboratory character varying(255),
    identifier character varying(255)
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: people_studies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people_studies (
    person_id integer,
    study_id integer
);


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_id integer,
    searchable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tsv_content tsvector
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: protocol_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE protocol_applications (
    id integer NOT NULL,
    protocol_id integer,
    operator_id integer,
    procedure_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: protocol_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE protocol_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protocol_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE protocol_applications_id_seq OWNED BY protocol_applications.id;


--
-- Name: protocol_parameter_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE protocol_parameter_values (
    id integer NOT NULL,
    protocol_application_id integer,
    protocol_parameter_id integer,
    value character varying(255),
    unit character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: protocol_parameter_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE protocol_parameter_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protocol_parameter_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE protocol_parameter_values_id_seq OWNED BY protocol_parameter_values.id;


--
-- Name: protocol_parameters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE protocol_parameters (
    id integer NOT NULL,
    protocol_id integer,
    name character varying(255),
    description character varying(255),
    default_value character varying(255),
    unit_type_id integer,
    unit character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: protocol_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE protocol_parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protocol_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE protocol_parameters_id_seq OWNED BY protocol_parameters.id;


--
-- Name: protocols; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE protocols (
    id integer NOT NULL,
    protocol_type_id integer,
    name character varying(255),
    description character varying(255),
    accession character varying(255),
    uri character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: protocols_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE protocols_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protocols_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE protocols_id_seq OWNED BY protocols.id;


--
-- Name: sample_relationships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sample_relationships (
    id integer NOT NULL,
    ancestor_id integer,
    descendant_id integer,
    direct boolean,
    count integer
);


--
-- Name: sample_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sample_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sample_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sample_relationships_id_seq OWNED BY sample_relationships.id;


--
-- Name: samples; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE samples (
    id integer NOT NULL,
    name character varying(255),
    barcode_string character varying(255),
    taxon_id integer,
    container_id integer,
    container_x integer DEFAULT 0,
    container_y integer DEFAULT 0,
    protocol_application_id integer,
    tags character varying(500),
    notes text,
    retired boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tsv_content tsvector,
    source_name character varying(255),
    study_id integer,
    ancestry character varying(500),
    ancestry_depth integer DEFAULT 0,
    sex_id integer,
    material_type_id integer,
    external_identifier character varying(255),
    age integer,
    time_point character varying(255),
    age_id integer,
    strain_id integer,
    tissue_type_id integer,
    primary_cell_id integer,
    treatments character varying(255),
    genotype character varying(255),
    replicate character varying(255)
);


--
-- Name: samples_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE samples_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: samples_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE samples_id_seq OWNED BY samples.id;


--
-- Name: samples_studies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE samples_studies (
    sample_id integer,
    study_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: shipments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shipments (
    id integer NOT NULL,
    tracking_number character varying(255),
    shipper_id integer,
    receiver_id integer,
    ship_date timestamp without time zone,
    recieve_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    past_container character varying(255),
    new_container character varying(255),
    complete boolean,
    past_container_id integer,
    new_container_id integer,
    tsv_content tsvector
);


--
-- Name: shipments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shipments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shipments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shipments_id_seq OWNED BY shipments.id;


--
-- Name: studies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE studies (
    id integer NOT NULL,
    title text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier character varying(255),
    description text,
    investigation_id integer,
    tsv_content tsvector
);


--
-- Name: studies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: studies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE studies_id_seq OWNED BY studies.id;


--
-- Name: taxons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxons (
    id integer NOT NULL,
    ncbi_id integer NOT NULL,
    scientific_name character varying(255),
    common_name character varying(255),
    tsv_content tsvector
);


--
-- Name: taxons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxons_id_seq OWNED BY taxons.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    provider character varying(255),
    uid character varying(255),
    contact_id integer,
    admin boolean DEFAULT false,
    status character varying(255) DEFAULT 'active'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY barcodes ALTER COLUMN id SET DEFAULT nextval('barcodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY container_changes ALTER COLUMN id SET DEFAULT nextval('container_changes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY container_types ALTER COLUMN id SET DEFAULT nextval('container_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY containers ALTER COLUMN id SET DEFAULT nextval('containers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY external_links ALTER COLUMN id SET DEFAULT nextval('external_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY investigations ALTER COLUMN id SET DEFAULT nextval('investigations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY material_types ALTER COLUMN id SET DEFAULT nextval('material_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ontologies ALTER COLUMN id SET DEFAULT nextval('ontologies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ontology_terms ALTER COLUMN id SET DEFAULT nextval('ontology_terms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY protocol_applications ALTER COLUMN id SET DEFAULT nextval('protocol_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY protocol_parameter_values ALTER COLUMN id SET DEFAULT nextval('protocol_parameter_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY protocol_parameters ALTER COLUMN id SET DEFAULT nextval('protocol_parameters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY protocols ALTER COLUMN id SET DEFAULT nextval('protocols_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_relationships ALTER COLUMN id SET DEFAULT nextval('sample_relationships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples ALTER COLUMN id SET DEFAULT nextval('samples_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shipments ALTER COLUMN id SET DEFAULT nextval('shipments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY studies ALTER COLUMN id SET DEFAULT nextval('studies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxons ALTER COLUMN id SET DEFAULT nextval('taxons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: barcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY barcodes
    ADD CONSTRAINT barcodes_pkey PRIMARY KEY (id);


--
-- Name: container_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY container_changes
    ADD CONSTRAINT container_changes_pkey PRIMARY KEY (id);


--
-- Name: container_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY container_types
    ADD CONSTRAINT container_types_pkey PRIMARY KEY (id);


--
-- Name: containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY containers
    ADD CONSTRAINT containers_pkey PRIMARY KEY (id);


--
-- Name: experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY investigations
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (id);


--
-- Name: external_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY external_links
    ADD CONSTRAINT external_links_pkey PRIMARY KEY (id);


--
-- Name: material_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY material_types
    ADD CONSTRAINT material_types_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: ontologies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ontologies
    ADD CONSTRAINT ontologies_pkey PRIMARY KEY (id);


--
-- Name: ontology_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ontology_terms
    ADD CONSTRAINT ontology_terms_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: protocol_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY protocol_applications
    ADD CONSTRAINT protocol_applications_pkey PRIMARY KEY (id);


--
-- Name: protocol_parameter_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY protocol_parameter_values
    ADD CONSTRAINT protocol_parameter_values_pkey PRIMARY KEY (id);


--
-- Name: protocol_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY protocol_parameters
    ADD CONSTRAINT protocol_parameters_pkey PRIMARY KEY (id);


--
-- Name: protocols_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY protocols
    ADD CONSTRAINT protocols_pkey PRIMARY KEY (id);


--
-- Name: sample_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sample_relationships
    ADD CONSTRAINT sample_relationships_pkey PRIMARY KEY (id);


--
-- Name: samples_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT samples_pkey PRIMARY KEY (id);


--
-- Name: shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (id);


--
-- Name: studies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY studies
    ADD CONSTRAINT studies_pkey PRIMARY KEY (id);


--
-- Name: taxons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxons
    ADD CONSTRAINT taxons_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_addresses_shipments_on_address_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_shipments_on_address_id ON addresses_shipments USING btree (address_id);


--
-- Name: index_addresses_shipments_on_shipment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_shipments_on_shipment_id ON addresses_shipments USING btree (shipment_id);


--
-- Name: index_addresses_users_on_address_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_users_on_address_id ON addresses_users USING btree (address_id);


--
-- Name: index_addresses_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_users_on_user_id ON addresses_users USING btree (user_id);


--
-- Name: index_barcodes_on_barcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_barcodes_on_barcode ON barcodes USING btree (barcode);


--
-- Name: index_barcodes_on_barcode_set; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_barcodes_on_barcode_set ON barcodes USING btree (barcode_set);


--
-- Name: index_barcodes_on_barcodeable_type_and_barcodeable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_barcodes_on_barcodeable_type_and_barcodeable_id ON barcodes USING btree (barcodeable_type, barcodeable_id);


--
-- Name: index_container_changes_on_container_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_container_changes_on_container_id ON container_changes USING btree (container_id);


--
-- Name: index_container_types_on_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_container_types_on_type_id ON container_types USING btree (type_id);


--
-- Name: index_containers_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_on_ancestry ON containers USING btree (ancestry);


--
-- Name: index_containers_on_container_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_on_container_type_id ON containers USING btree (container_type_id);


--
-- Name: index_containers_on_external_identifier; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_on_external_identifier ON containers USING btree (external_identifier);


--
-- Name: index_containers_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_on_name ON containers USING btree (name);


--
-- Name: index_containers_shipments_on_container_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_shipments_on_container_id ON containers_shipments USING btree (container_id);


--
-- Name: index_containers_shipments_on_shipment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_shipments_on_shipment_id ON containers_shipments USING btree (shipment_id);


--
-- Name: index_investigations_people_on_investigation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investigations_people_on_investigation_id ON investigations_people USING btree (investigation_id);


--
-- Name: index_investigations_people_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_investigations_people_on_person_id ON investigations_people USING btree (person_id);


--
-- Name: index_material_types_samples_on_material_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_material_types_samples_on_material_type_id ON material_types_samples USING btree (material_type_id);


--
-- Name: index_material_types_samples_on_sample_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_material_types_samples_on_sample_id ON material_types_samples USING btree (sample_id);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);


--
-- Name: index_ontologies_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontologies_on_name ON ontologies USING btree (name);


--
-- Name: index_ontologies_on_prefix; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontologies_on_prefix ON ontologies USING btree (prefix);


--
-- Name: index_ontologies_on_uri; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontologies_on_uri ON ontologies USING btree (uri);


--
-- Name: index_ontology_terms_on_accession; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontology_terms_on_accession ON ontology_terms USING btree (accession);


--
-- Name: index_ontology_terms_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontology_terms_on_ancestry ON ontology_terms USING btree (ancestry);


--
-- Name: index_ontology_terms_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontology_terms_on_name ON ontology_terms USING btree (name);


--
-- Name: index_ontology_terms_on_ontology_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontology_terms_on_ontology_id ON ontology_terms USING btree (ontology_id);


--
-- Name: index_people_studies_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_studies_on_person_id ON people_studies USING btree (person_id);


--
-- Name: index_people_studies_on_study_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_studies_on_study_id ON people_studies USING btree (study_id);


--
-- Name: index_protocol_applications_on_operator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocol_applications_on_operator_id ON protocol_applications USING btree (operator_id);


--
-- Name: index_protocol_applications_on_protocol_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocol_applications_on_protocol_id ON protocol_applications USING btree (protocol_id);


--
-- Name: index_protocol_parameter_values_on_protocol_application_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocol_parameter_values_on_protocol_application_id ON protocol_parameter_values USING btree (protocol_application_id);


--
-- Name: index_protocol_parameter_values_on_protocol_parameter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocol_parameter_values_on_protocol_parameter_id ON protocol_parameter_values USING btree (protocol_parameter_id);


--
-- Name: index_protocol_parameters_on_protocol_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocol_parameters_on_protocol_id ON protocol_parameters USING btree (protocol_id);


--
-- Name: index_protocol_parameters_on_unit_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocol_parameters_on_unit_type_id ON protocol_parameters USING btree (unit_type_id);


--
-- Name: index_protocols_on_accession; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocols_on_accession ON protocols USING btree (accession);


--
-- Name: index_protocols_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocols_on_name ON protocols USING btree (name);


--
-- Name: index_protocols_on_protocol_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protocols_on_protocol_type_id ON protocols USING btree (protocol_type_id);


--
-- Name: index_sample_relationships_on_ancestor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sample_relationships_on_ancestor_id ON sample_relationships USING btree (ancestor_id);


--
-- Name: index_sample_relationships_on_descendant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sample_relationships_on_descendant_id ON sample_relationships USING btree (descendant_id);


--
-- Name: index_samples_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_ancestry ON samples USING btree (ancestry);


--
-- Name: index_samples_on_container_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_container_id ON samples USING btree (container_id);


--
-- Name: index_samples_on_external_identifier; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_external_identifier ON samples USING btree (external_identifier);


--
-- Name: index_samples_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_name ON samples USING btree (name);


--
-- Name: index_samples_on_protocol_application_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_protocol_application_id ON samples USING btree (protocol_application_id);


--
-- Name: index_samples_on_taxon_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_taxon_id ON samples USING btree (taxon_id);


--
-- Name: index_samples_studies_on_sample_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_studies_on_sample_id ON samples_studies USING btree (sample_id);


--
-- Name: index_samples_studies_on_study_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_studies_on_study_id ON samples_studies USING btree (study_id);


--
-- Name: index_shipments_on_receiver_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shipments_on_receiver_id ON shipments USING btree (receiver_id);


--
-- Name: index_shipments_on_shipper_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shipments_on_shipper_id ON shipments USING btree (shipper_id);


--
-- Name: index_shipments_on_tracking_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shipments_on_tracking_number ON shipments USING btree (tracking_number);


--
-- Name: index_taxons_on_common_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxons_on_common_name ON taxons USING btree (common_name);


--
-- Name: index_taxons_on_ncbi_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taxons_on_ncbi_id ON taxons USING btree (ncbi_id);


--
-- Name: index_taxons_on_scientific_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taxons_on_scientific_name ON taxons USING btree (scientific_name);


--
-- Name: index_users_on_contact_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_contact_id ON users USING btree (contact_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_provider_and_uid ON users USING btree (provider, uid);


--
-- Name: index_users_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_status ON users USING btree (status);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: containers_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER containers_tsvupdate BEFORE INSERT OR UPDATE ON containers FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'name', 'barcode_string', 'tags', 'notes');


--
-- Name: investigations_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER investigations_tsvupdate BEFORE INSERT OR UPDATE ON investigations FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'title', 'identifier');


--
-- Name: material_types_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER material_types_tsvupdate BEFORE INSERT OR UPDATE ON material_types FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'name');


--
-- Name: people_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER people_tsvupdate BEFORE INSERT OR UPDATE ON people FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'firstname', 'lastname', 'email', 'institution');


--
-- Name: pg_search_documents_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER pg_search_documents_tsvupdate BEFORE INSERT OR UPDATE ON pg_search_documents FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'content');


--
-- Name: samples_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER samples_tsvupdate BEFORE INSERT OR UPDATE ON samples FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'name', 'barcode_string', 'tags', 'notes');


--
-- Name: shipments_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER shipments_tsvupdate BEFORE INSERT OR UPDATE ON shipments FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'tracking_number');


--
-- Name: studies_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER studies_tsvupdate BEFORE INSERT OR UPDATE ON studies FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'title', 'identifier', 'description');


--
-- Name: taxons_tsvupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER taxons_tsvupdate BEFORE INSERT OR UPDATE ON taxons FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv_content', 'pg_catalog.english', 'scientific_name', 'common_name');


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130228140342');

INSERT INTO schema_migrations (version) VALUES ('20130228143222');

INSERT INTO schema_migrations (version) VALUES ('20130228151449');

INSERT INTO schema_migrations (version) VALUES ('20130228151502');

INSERT INTO schema_migrations (version) VALUES ('20130228151542');

INSERT INTO schema_migrations (version) VALUES ('20130228152615');

INSERT INTO schema_migrations (version) VALUES ('20130228152620');

INSERT INTO schema_migrations (version) VALUES ('20130228152641');

INSERT INTO schema_migrations (version) VALUES ('20130228155042');

INSERT INTO schema_migrations (version) VALUES ('20130228163330');

INSERT INTO schema_migrations (version) VALUES ('20130228163332');

INSERT INTO schema_migrations (version) VALUES ('20130228174053');

INSERT INTO schema_migrations (version) VALUES ('20130301024914');

INSERT INTO schema_migrations (version) VALUES ('20130301202201');

INSERT INTO schema_migrations (version) VALUES ('20130304171209');

INSERT INTO schema_migrations (version) VALUES ('20130513144752');

INSERT INTO schema_migrations (version) VALUES ('20130513144841');

INSERT INTO schema_migrations (version) VALUES ('20130709202649');

INSERT INTO schema_migrations (version) VALUES ('20130722131646');

INSERT INTO schema_migrations (version) VALUES ('20130722142838');

INSERT INTO schema_migrations (version) VALUES ('20130724165231');

INSERT INTO schema_migrations (version) VALUES ('20130731195626');

INSERT INTO schema_migrations (version) VALUES ('20130731195637');

INSERT INTO schema_migrations (version) VALUES ('20130925152643');

INSERT INTO schema_migrations (version) VALUES ('20131127171624');

INSERT INTO schema_migrations (version) VALUES ('20131127172415');

INSERT INTO schema_migrations (version) VALUES ('20131127172524');

INSERT INTO schema_migrations (version) VALUES ('20131127185917');

INSERT INTO schema_migrations (version) VALUES ('20131127205247');

INSERT INTO schema_migrations (version) VALUES ('20131127210411');

INSERT INTO schema_migrations (version) VALUES ('20131127211158');

INSERT INTO schema_migrations (version) VALUES ('20131127211928');

INSERT INTO schema_migrations (version) VALUES ('20131127212343');

INSERT INTO schema_migrations (version) VALUES ('20131127212509');

INSERT INTO schema_migrations (version) VALUES ('20131127213130');

INSERT INTO schema_migrations (version) VALUES ('20131127213817');

INSERT INTO schema_migrations (version) VALUES ('20131217151108');

INSERT INTO schema_migrations (version) VALUES ('20140114210057');

INSERT INTO schema_migrations (version) VALUES ('20140114210802');

INSERT INTO schema_migrations (version) VALUES ('20140114211515');

INSERT INTO schema_migrations (version) VALUES ('20140114212010');

INSERT INTO schema_migrations (version) VALUES ('20140114212156');

INSERT INTO schema_migrations (version) VALUES ('20140114212244');

INSERT INTO schema_migrations (version) VALUES ('20140114212809');

INSERT INTO schema_migrations (version) VALUES ('20140114213122');

INSERT INTO schema_migrations (version) VALUES ('20140114213400');

INSERT INTO schema_migrations (version) VALUES ('20140114213738');

INSERT INTO schema_migrations (version) VALUES ('20140114214033');

INSERT INTO schema_migrations (version) VALUES ('20140114214125');

INSERT INTO schema_migrations (version) VALUES ('20140114215841');

INSERT INTO schema_migrations (version) VALUES ('20140211154102');

INSERT INTO schema_migrations (version) VALUES ('20140211154515');

INSERT INTO schema_migrations (version) VALUES ('20140211155311');

INSERT INTO schema_migrations (version) VALUES ('20140211192652');

INSERT INTO schema_migrations (version) VALUES ('20140212164913');

INSERT INTO schema_migrations (version) VALUES ('20140219034759');

INSERT INTO schema_migrations (version) VALUES ('20140220155728');

INSERT INTO schema_migrations (version) VALUES ('20140220160531');

INSERT INTO schema_migrations (version) VALUES ('20140220170001');

INSERT INTO schema_migrations (version) VALUES ('20140220170255');

INSERT INTO schema_migrations (version) VALUES ('20140220170559');

INSERT INTO schema_migrations (version) VALUES ('20140226191509');

INSERT INTO schema_migrations (version) VALUES ('20140227070130');

INSERT INTO schema_migrations (version) VALUES ('20140227165540');

INSERT INTO schema_migrations (version) VALUES ('20140227195323');

INSERT INTO schema_migrations (version) VALUES ('20140228023732');

INSERT INTO schema_migrations (version) VALUES ('20140317175031');

INSERT INTO schema_migrations (version) VALUES ('20140317202700');

INSERT INTO schema_migrations (version) VALUES ('20140324192331');

INSERT INTO schema_migrations (version) VALUES ('20140415153903');

INSERT INTO schema_migrations (version) VALUES ('20140415161039');

INSERT INTO schema_migrations (version) VALUES ('20140415164126');

INSERT INTO schema_migrations (version) VALUES ('20140415181154');

INSERT INTO schema_migrations (version) VALUES ('20140429152125');

INSERT INTO schema_migrations (version) VALUES ('20140429152415');

INSERT INTO schema_migrations (version) VALUES ('20140429200120');

INSERT INTO schema_migrations (version) VALUES ('20140429200437');

INSERT INTO schema_migrations (version) VALUES ('20140501145227');

INSERT INTO schema_migrations (version) VALUES ('20140501151246');

INSERT INTO schema_migrations (version) VALUES ('20140515192917');

INSERT INTO schema_migrations (version) VALUES ('20140515201348');

INSERT INTO schema_migrations (version) VALUES ('20140516154718');

INSERT INTO schema_migrations (version) VALUES ('20140516174912');

INSERT INTO schema_migrations (version) VALUES ('20140517173046');