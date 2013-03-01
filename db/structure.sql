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
-- Name: barcodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE barcodes (
    id integer NOT NULL,
    barcode character varying(255),
    barcode_set integer DEFAULT 0
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
-- Name: container_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE container_types (
    id integer NOT NULL,
    type_id integer,
    name character varying(255),
    x_dimension integer,
    y_dimension integer,
    x_coord_labels character varying(255),
    y_coord_labels character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    barcode_id integer,
    container_type_id integer,
    ancestry character varying(255) NOT NULL,
    ancestry_depth integer DEFAULT 0,
    x integer DEFAULT 0,
    y integer DEFAULT 0,
    retired boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: identities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE identities (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_digest character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: ontologies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ontologies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
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
-- Name: sample_characteristics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sample_characteristics (
    id integer NOT NULL,
    ontology_term_id integer,
    name character varying(255),
    value character varying(255),
    unit_type_id integer,
    unit character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sample_characteristics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sample_characteristics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sample_characteristics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sample_characteristics_id_seq OWNED BY sample_characteristics.id;


--
-- Name: samples; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE samples (
    id integer NOT NULL,
    name character varying(255),
    container_id integer,
    protocol_application_id integer,
    ancestry character varying(255),
    ancestry_depth integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: taxon_names; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxon_names (
    id integer NOT NULL,
    taxon_id integer,
    name character varying(255),
    uniq_name character varying(255),
    name_class character varying(255)
);


--
-- Name: taxon_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxon_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxon_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxon_names_id_seq OWNED BY taxon_names.id;


--
-- Name: taxons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxons (
    id integer NOT NULL,
    ncbi_id integer,
    parent_ncbi_id integer,
    rank character varying(255),
    ancestry character varying(255),
    ancestry_depth integer
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

ALTER TABLE ONLY barcodes ALTER COLUMN id SET DEFAULT nextval('barcodes_id_seq'::regclass);


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

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


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

ALTER TABLE ONLY sample_characteristics ALTER COLUMN id SET DEFAULT nextval('sample_characteristics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples ALTER COLUMN id SET DEFAULT nextval('samples_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxon_names ALTER COLUMN id SET DEFAULT nextval('taxon_names_id_seq'::regclass);


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
-- Name: barcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY barcodes
    ADD CONSTRAINT barcodes_pkey PRIMARY KEY (id);


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
-- Name: identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


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
-- Name: sample_characteristics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sample_characteristics
    ADD CONSTRAINT sample_characteristics_pkey PRIMARY KEY (id);


--
-- Name: samples_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT samples_pkey PRIMARY KEY (id);


--
-- Name: taxon_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxon_names
    ADD CONSTRAINT taxon_names_pkey PRIMARY KEY (id);


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
-- Name: index_barcodes_on_barcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_barcodes_on_barcode ON barcodes USING btree (barcode);


--
-- Name: index_barcodes_on_barcode_set; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_barcodes_on_barcode_set ON barcodes USING btree (barcode_set);


--
-- Name: index_container_types_on_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_container_types_on_type_id ON container_types USING btree (type_id);


--
-- Name: index_containers_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_on_ancestry ON containers USING btree (ancestry);


--
-- Name: index_containers_on_barcode_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_containers_on_barcode_id ON containers USING btree (barcode_id);


--
-- Name: index_containers_on_container_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_containers_on_container_type_id ON containers USING btree (container_type_id);


--
-- Name: index_identities_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_identities_on_email ON identities USING btree (email);


--
-- Name: index_identities_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_identities_on_name ON identities USING btree (name);


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
-- Name: index_ontology_terms_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontology_terms_on_name ON ontology_terms USING btree (name);


--
-- Name: index_ontology_terms_on_ontology_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ontology_terms_on_ontology_id ON ontology_terms USING btree (ontology_id);


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
-- Name: index_sample_characteristics_on_ontology_term_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sample_characteristics_on_ontology_term_id ON sample_characteristics USING btree (ontology_term_id);


--
-- Name: index_sample_characteristics_on_unit_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sample_characteristics_on_unit_type_id ON sample_characteristics USING btree (unit_type_id);


--
-- Name: index_samples_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_ancestry ON samples USING btree (ancestry);


--
-- Name: index_samples_on_container_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_container_id ON samples USING btree (container_id);


--
-- Name: index_samples_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_name ON samples USING btree (name);


--
-- Name: index_samples_on_protocol_application_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_samples_on_protocol_application_id ON samples USING btree (protocol_application_id);


--
-- Name: index_taxon_names_on_name_and_uniq_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxon_names_on_name_and_uniq_name ON taxon_names USING btree (name, uniq_name);


--
-- Name: index_taxon_names_on_taxon_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxon_names_on_taxon_id ON taxon_names USING btree (taxon_id);


--
-- Name: index_taxons_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxons_on_ancestry ON taxons USING btree (ancestry);


--
-- Name: index_taxons_on_ancestry_depth; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxons_on_ancestry_depth ON taxons USING btree (ancestry_depth);


--
-- Name: index_taxons_on_ncbi_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taxons_on_ncbi_id ON taxons USING btree (ncbi_id);


--
-- Name: index_taxons_on_parent_ncbi_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxons_on_parent_ncbi_id ON taxons USING btree (parent_ncbi_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_provider_and_uid ON users USING btree (provider, uid);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130228140342');

INSERT INTO schema_migrations (version) VALUES ('20130228143222');

INSERT INTO schema_migrations (version) VALUES ('20130228151449');

INSERT INTO schema_migrations (version) VALUES ('20130228151502');

INSERT INTO schema_migrations (version) VALUES ('20130228151542');

INSERT INTO schema_migrations (version) VALUES ('20130228151643');

INSERT INTO schema_migrations (version) VALUES ('20130228152615');

INSERT INTO schema_migrations (version) VALUES ('20130228152620');

INSERT INTO schema_migrations (version) VALUES ('20130228152641');

INSERT INTO schema_migrations (version) VALUES ('20130228155042');

INSERT INTO schema_migrations (version) VALUES ('20130228163330');

INSERT INTO schema_migrations (version) VALUES ('20130228163332');

INSERT INTO schema_migrations (version) VALUES ('20130228174053');

INSERT INTO schema_migrations (version) VALUES ('20130228174055');

INSERT INTO schema_migrations (version) VALUES ('20130301024914');

INSERT INTO schema_migrations (version) VALUES ('20130301031746');