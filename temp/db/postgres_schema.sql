--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.0
-- Started on 2015-08-05 22:00:44 EDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 195 (class 3079 OID 11859)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2186 (class 0 OID 0)
-- Dependencies: 195
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 208 (class 1255 OID 16968)
-- Name: category_audit(); Type: FUNCTION; Schema: public; Owner: passanager
--

CREATE FUNCTION category_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
            operation character varying(20);
    BEGIN
        --
        -- Perform the required operation on category, and create a row in category_audit_log
        -- to reflect the change made to category.
        --
        IF (TG_OP = 'UPDATE') THEN

            -- check for isdeleted, if true operation = DELETED, else UPDATE
            IF (NEW.isdeleted = true) THEN
                operation = 'DELETED';
            ELSE
                operation = 'UPDATE';

            END IF;

            INSERT INTO category_audit_log(categoryid, previousstate, operation, createdby, createddate, modifiedby, modifieddate)
            SELECT OLD.categoryid, row_to_json(OLD.*), operation, OLD.modifiedby, OLD.modifieddate, NEW.modifiedby, NEW.modifieddate;

            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            operation = 'INSERT';
            INSERT INTO category_audit_log(categoryid, previousstate, operation, createdby, createddate, modifiedby, modifieddate)
            SELECT NEW.categoryid, row_to_json(NEW.*), operation, NEW.createdby, NEW.createddate, NEW.modifiedby, NEW.modifieddate;

            RETURN NEW;
        END IF;

    END;
$$;


ALTER FUNCTION public.category_audit() OWNER TO passanager;

--
-- TOC entry 209 (class 1255 OID 16970)
-- Name: item_audit(); Type: FUNCTION; Schema: public; Owner: passanager
--

CREATE FUNCTION item_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
            operation character varying(20);
    BEGIN
        --
        -- Perform the required operation on category, and create a row in category_audit_log
        -- to reflect the change made to category.
        --
        IF (TG_OP = 'UPDATE') THEN

            -- check for isdeleted, if true operation = DELETED, else UPDATE
            IF (NEW.isdeleted = true) THEN
                operation = 'DELETED';
            ELSE
                operation = 'UPDATE';

            END IF;

            INSERT INTO item_audit_log(itemid, previousstate, operation, createdby, createddate, modifiedby, modifieddate)
            SELECT OLD.itemid, row_to_json(OLD.*), operation, OLD.modifiedby, OLD.modifieddate, NEW.modifiedby, NEW.modifieddate;

            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            operation = 'INSERT';
            INSERT INTO item_audit_log(itemid, previousstate, operation, createdby, createddate, modifiedby, modifieddate)
            SELECT NEW.itemid, row_to_json(NEW.*), operation, NEW.createdby, NEW.createddate, NEW.modifiedby, NEW.modifieddate;

            RETURN NEW;
        END IF;

    END;
$$;


ALTER FUNCTION public.item_audit() OWNER TO passanager;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 175 (class 1259 OID 16620)
-- Name: category; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE category (
    categoryid integer NOT NULL,
    name character varying(100) NOT NULL,
    isdeleted boolean DEFAULT false NOT NULL,
    parentcategoryid integer,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE category OWNER TO passanager;

--
-- TOC entry 192 (class 1259 OID 16696)
-- Name: category_audit_log; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE category_audit_log (
    logid bigint NOT NULL,
    categoryid integer NOT NULL,
    previousstate json NOT NULL,
    operation character varying(20) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE category_audit_log OWNER TO passanager;

--
-- TOC entry 191 (class 1259 OID 16694)
-- Name: category_audit_log_logid_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE category_audit_log_logid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_audit_log_logid_seq OWNER TO passanager;

--
-- TOC entry 2187 (class 0 OID 0)
-- Dependencies: 191
-- Name: category_audit_log_logid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE category_audit_log_logid_seq OWNED BY category_audit_log.logid;


--
-- TOC entry 174 (class 1259 OID 16618)
-- Name: category_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE category_categoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_categoryid_seq OWNER TO passanager;

--
-- TOC entry 2188 (class 0 OID 0)
-- Dependencies: 174
-- Name: category_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE category_categoryid_seq OWNED BY category.categoryid;


--
-- TOC entry 177 (class 1259 OID 16629)
-- Name: category_role_acl; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE category_role_acl (
    id integer NOT NULL,
    isreadonly boolean NOT NULL,
    roleid integer NOT NULL,
    categoryid integer NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE category_role_acl OWNER TO passanager;

--
-- TOC entry 176 (class 1259 OID 16627)
-- Name: category_role_acl_id_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE category_role_acl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_role_acl_id_seq OWNER TO passanager;

--
-- TOC entry 2189 (class 0 OID 0)
-- Dependencies: 176
-- Name: category_role_acl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE category_role_acl_id_seq OWNED BY category_role_acl.id;


--
-- TOC entry 179 (class 1259 OID 16637)
-- Name: category_user_acl; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE category_user_acl (
    id integer NOT NULL,
    isreadonly boolean NOT NULL,
    categoryid integer NOT NULL,
    userid integer NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE category_user_acl OWNER TO passanager;

--
-- TOC entry 178 (class 1259 OID 16635)
-- Name: category_user_acl_id_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE category_user_acl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_user_acl_id_seq OWNER TO passanager;

--
-- TOC entry 2190 (class 0 OID 0)
-- Dependencies: 178
-- Name: category_user_acl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE category_user_acl_id_seq OWNED BY category_user_acl.id;


--
-- TOC entry 181 (class 1259 OID 16645)
-- Name: item; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE item (
    itemid integer NOT NULL,
    name character varying(200) NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(500) NOT NULL,
    url character varying(100),
    notes text,
    categoryid integer,
    isdeleted boolean DEFAULT false NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE item OWNER TO passanager;

--
-- TOC entry 194 (class 1259 OID 16709)
-- Name: item_audit_log; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE item_audit_log (
    logid bigint NOT NULL,
    itemid integer NOT NULL,
    previousstate json NOT NULL,
    operation character varying(20) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE item_audit_log OWNER TO passanager;

--
-- TOC entry 193 (class 1259 OID 16707)
-- Name: item_audit_log_logid_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE item_audit_log_logid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE item_audit_log_logid_seq OWNER TO passanager;

--
-- TOC entry 2191 (class 0 OID 0)
-- Dependencies: 193
-- Name: item_audit_log_logid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE item_audit_log_logid_seq OWNED BY item_audit_log.logid;


--
-- TOC entry 180 (class 1259 OID 16643)
-- Name: item_itemid_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE item_itemid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE item_itemid_seq OWNER TO passanager;

--
-- TOC entry 2192 (class 0 OID 0)
-- Dependencies: 180
-- Name: item_itemid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE item_itemid_seq OWNED BY item.itemid;


--
-- TOC entry 183 (class 1259 OID 16657)
-- Name: item_role_acl; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE item_role_acl (
    id integer NOT NULL,
    isreadonly boolean NOT NULL,
    itemid integer NOT NULL,
    roleid integer NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE item_role_acl OWNER TO passanager;

--
-- TOC entry 182 (class 1259 OID 16655)
-- Name: item_role_acl_id_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE item_role_acl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE item_role_acl_id_seq OWNER TO passanager;

--
-- TOC entry 2193 (class 0 OID 0)
-- Dependencies: 182
-- Name: item_role_acl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE item_role_acl_id_seq OWNED BY item_role_acl.id;


--
-- TOC entry 185 (class 1259 OID 16665)
-- Name: item_user_acl; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE item_user_acl (
    id integer NOT NULL,
    isreadonly boolean NOT NULL,
    itemid integer NOT NULL,
    userid integer NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE item_user_acl OWNER TO passanager;

--
-- TOC entry 184 (class 1259 OID 16663)
-- Name: item_user_acl_id_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE item_user_acl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE item_user_acl_id_seq OWNER TO passanager;

--
-- TOC entry 2194 (class 0 OID 0)
-- Dependencies: 184
-- Name: item_user_acl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE item_user_acl_id_seq OWNED BY item_user_acl.id;


--
-- TOC entry 186 (class 1259 OID 16671)
-- Name: related_items; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE related_items (
    primaryitemid integer NOT NULL,
    relateditemid integer NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE related_items OWNER TO passanager;

--
-- TOC entry 188 (class 1259 OID 16678)
-- Name: roles; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE roles (
    roleid integer NOT NULL,
    name character varying(100) NOT NULL,
    isdeleted boolean DEFAULT false NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE roles OWNER TO passanager;

--
-- TOC entry 187 (class 1259 OID 16676)
-- Name: roles_roleid_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE roles_roleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roles_roleid_seq OWNER TO passanager;

--
-- TOC entry 2195 (class 0 OID 0)
-- Dependencies: 187
-- Name: roles_roleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE roles_roleid_seq OWNED BY roles.roleid;


--
-- TOC entry 190 (class 1259 OID 16687)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE user_roles (
    userid integer NOT NULL,
    roleid integer NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE user_roles OWNER TO passanager;

--
-- TOC entry 189 (class 1259 OID 16685)
-- Name: user_roles_userid_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE user_roles_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_roles_userid_seq OWNER TO passanager;

--
-- TOC entry 2196 (class 0 OID 0)
-- Dependencies: 189
-- Name: user_roles_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE user_roles_userid_seq OWNED BY user_roles.userid;


--
-- TOC entry 173 (class 1259 OID 16606)
-- Name: users; Type: TABLE; Schema: public; Owner: passanager; Tablespace: 
--

CREATE TABLE users (
    userid integer NOT NULL,
    username character varying(100) NOT NULL,
    passwordhash character varying(150) NOT NULL,
    salt character varying(100) NOT NULL,
    name character varying(500) NOT NULL,
    email character varying(250) NOT NULL,
    isdeleted boolean DEFAULT false NOT NULL,
    islocked boolean DEFAULT false NOT NULL,
    isadmin boolean DEFAULT false NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    modifiedby integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE users OWNER TO passanager;

--
-- TOC entry 172 (class 1259 OID 16604)
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: passanager
--

CREATE SEQUENCE users_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_userid_seq OWNER TO passanager;

--
-- TOC entry 2197 (class 0 OID 0)
-- Dependencies: 172
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: passanager
--

ALTER SEQUENCE users_userid_seq OWNED BY users.userid;


--
-- TOC entry 1960 (class 2604 OID 16623)
-- Name: categoryid; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category ALTER COLUMN categoryid SET DEFAULT nextval('category_categoryid_seq'::regclass);


--
-- TOC entry 1988 (class 2604 OID 16699)
-- Name: logid; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_audit_log ALTER COLUMN logid SET DEFAULT nextval('category_audit_log_logid_seq'::regclass);


--
-- TOC entry 1964 (class 2604 OID 16632)
-- Name: id; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_role_acl ALTER COLUMN id SET DEFAULT nextval('category_role_acl_id_seq'::regclass);


--
-- TOC entry 1967 (class 2604 OID 16640)
-- Name: id; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_user_acl ALTER COLUMN id SET DEFAULT nextval('category_user_acl_id_seq'::regclass);


--
-- TOC entry 1970 (class 2604 OID 16648)
-- Name: itemid; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item ALTER COLUMN itemid SET DEFAULT nextval('item_itemid_seq'::regclass);


--
-- TOC entry 1991 (class 2604 OID 16712)
-- Name: logid; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_audit_log ALTER COLUMN logid SET DEFAULT nextval('item_audit_log_logid_seq'::regclass);


--
-- TOC entry 1974 (class 2604 OID 16660)
-- Name: id; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_role_acl ALTER COLUMN id SET DEFAULT nextval('item_role_acl_id_seq'::regclass);


--
-- TOC entry 1977 (class 2604 OID 16668)
-- Name: id; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_user_acl ALTER COLUMN id SET DEFAULT nextval('item_user_acl_id_seq'::regclass);


--
-- TOC entry 1982 (class 2604 OID 16681)
-- Name: roleid; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY roles ALTER COLUMN roleid SET DEFAULT nextval('roles_roleid_seq'::regclass);


--
-- TOC entry 1985 (class 2604 OID 16690)
-- Name: userid; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY user_roles ALTER COLUMN userid SET DEFAULT nextval('user_roles_userid_seq'::regclass);


--
-- TOC entry 1953 (class 2604 OID 16609)
-- Name: userid; Type: DEFAULT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY users ALTER COLUMN userid SET DEFAULT nextval('users_userid_seq'::regclass);


--
-- TOC entry 2027 (class 2606 OID 16706)
-- Name: category_audit_log_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY category_audit_log
    ADD CONSTRAINT category_audit_log_pk PRIMARY KEY (logid);


--
-- TOC entry 2005 (class 2606 OID 16721)
-- Name: category_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pk PRIMARY KEY (categoryid);


--
-- TOC entry 2007 (class 2606 OID 16723)
-- Name: category_role_acl_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY category_role_acl
    ADD CONSTRAINT category_role_acl_pk PRIMARY KEY (id);


--
-- TOC entry 2009 (class 2606 OID 16725)
-- Name: category_user_acl_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY category_user_acl
    ADD CONSTRAINT category_user_acl_pk PRIMARY KEY (id);


--
-- TOC entry 2029 (class 2606 OID 16719)
-- Name: item_audit_log_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY item_audit_log
    ADD CONSTRAINT item_audit_log_pk PRIMARY KEY (logid);


--
-- TOC entry 2013 (class 2606 OID 16727)
-- Name: item_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_pk PRIMARY KEY (itemid);


--
-- TOC entry 2015 (class 2606 OID 16729)
-- Name: item_role_acl_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY item_role_acl
    ADD CONSTRAINT item_role_acl_pk PRIMARY KEY (id);


--
-- TOC entry 2017 (class 2606 OID 16731)
-- Name: item_user_acl_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY item_user_acl
    ADD CONSTRAINT item_user_acl_pk PRIMARY KEY (id);


--
-- TOC entry 2019 (class 2606 OID 16733)
-- Name: related_items_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY related_items
    ADD CONSTRAINT related_items_pk PRIMARY KEY (primaryitemid, relateditemid);


--
-- TOC entry 2023 (class 2606 OID 16735)
-- Name: roles_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (roleid);


--
-- TOC entry 2025 (class 2606 OID 16737)
-- Name: user_roles_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pk PRIMARY KEY (userid, roleid);


--
-- TOC entry 1995 (class 2606 OID 16943)
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 1998 (class 2606 OID 16739)
-- Name: users_pk; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pk PRIMARY KEY (userid);


--
-- TOC entry 2001 (class 2606 OID 16941)
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: passanager; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 2002 (class 1259 OID 16944)
-- Name: category_isdeleted_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX category_isdeleted_idx ON category USING btree (isdeleted DESC);


--
-- TOC entry 2003 (class 1259 OID 16945)
-- Name: category_name_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX category_name_idx ON category USING btree (name);


--
-- TOC entry 2010 (class 1259 OID 16946)
-- Name: item_isdeleted_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX item_isdeleted_idx ON item USING btree (isdeleted);


--
-- TOC entry 2011 (class 1259 OID 16947)
-- Name: item_name_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX item_name_idx ON item USING btree (name);


--
-- TOC entry 2020 (class 1259 OID 16948)
-- Name: roles_isdeleted_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX roles_isdeleted_idx ON roles USING btree (isdeleted DESC);


--
-- TOC entry 2021 (class 1259 OID 16949)
-- Name: roles_name_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX roles_name_idx ON roles USING btree (name);


--
-- TOC entry 1996 (class 1259 OID 16950)
-- Name: users_isdeleted_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX users_isdeleted_idx ON users USING btree (isdeleted DESC);


--
-- TOC entry 1999 (class 1259 OID 16951)
-- Name: users_username_idx; Type: INDEX; Schema: public; Owner: passanager; Tablespace: 
--

CREATE INDEX users_username_idx ON users USING btree (username);


--
-- TOC entry 2068 (class 2620 OID 16969)
-- Name: category_audit; Type: TRIGGER; Schema: public; Owner: passanager
--

CREATE TRIGGER category_audit AFTER INSERT OR UPDATE ON category FOR EACH ROW EXECUTE PROCEDURE category_audit();


--
-- TOC entry 2069 (class 2620 OID 16972)
-- Name: item_audit; Type: TRIGGER; Schema: public; Owner: passanager
--

CREATE TRIGGER item_audit AFTER INSERT OR UPDATE ON item FOR EACH ROW EXECUTE PROCEDURE item_audit();


--
-- TOC entry 2062 (class 2606 OID 16755)
-- Name: category_audit_log_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_audit_log
    ADD CONSTRAINT category_audit_log_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES category(categoryid);


--
-- TOC entry 2063 (class 2606 OID 16760)
-- Name: category_audit_log_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_audit_log
    ADD CONSTRAINT category_audit_log_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2064 (class 2606 OID 16765)
-- Name: category_audit_log_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_audit_log
    ADD CONSTRAINT category_audit_log_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2031 (class 2606 OID 16745)
-- Name: category_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2032 (class 2606 OID 16750)
-- Name: category_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2030 (class 2606 OID 16740)
-- Name: category_parentcategoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_parentcategoryid_fkey FOREIGN KEY (parentcategoryid) REFERENCES category(categoryid);


--
-- TOC entry 2033 (class 2606 OID 16770)
-- Name: category_role_acl_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_role_acl
    ADD CONSTRAINT category_role_acl_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES category(categoryid);


--
-- TOC entry 2035 (class 2606 OID 16780)
-- Name: category_role_acl_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_role_acl
    ADD CONSTRAINT category_role_acl_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2036 (class 2606 OID 16785)
-- Name: category_role_acl_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_role_acl
    ADD CONSTRAINT category_role_acl_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2034 (class 2606 OID 16775)
-- Name: category_role_acl_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_role_acl
    ADD CONSTRAINT category_role_acl_roleid_fkey FOREIGN KEY (roleid) REFERENCES roles(roleid);


--
-- TOC entry 2037 (class 2606 OID 16790)
-- Name: category_user_acl_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_user_acl
    ADD CONSTRAINT category_user_acl_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES category(categoryid);


--
-- TOC entry 2039 (class 2606 OID 16800)
-- Name: category_user_acl_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_user_acl
    ADD CONSTRAINT category_user_acl_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2040 (class 2606 OID 16805)
-- Name: category_user_acl_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_user_acl
    ADD CONSTRAINT category_user_acl_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2038 (class 2606 OID 16795)
-- Name: category_user_acl_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY category_user_acl
    ADD CONSTRAINT category_user_acl_userid_fkey FOREIGN KEY (userid) REFERENCES users(userid);


--
-- TOC entry 2066 (class 2606 OID 16830)
-- Name: item_audit_log_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_audit_log
    ADD CONSTRAINT item_audit_log_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2065 (class 2606 OID 16825)
-- Name: item_audit_log_itemid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_audit_log
    ADD CONSTRAINT item_audit_log_itemid_fkey FOREIGN KEY (itemid) REFERENCES item(itemid);


--
-- TOC entry 2067 (class 2606 OID 16835)
-- Name: item_audit_log_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_audit_log
    ADD CONSTRAINT item_audit_log_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2041 (class 2606 OID 16810)
-- Name: item_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES category(categoryid);


--
-- TOC entry 2042 (class 2606 OID 16815)
-- Name: item_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2043 (class 2606 OID 16820)
-- Name: item_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2046 (class 2606 OID 16850)
-- Name: item_role_acl_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_role_acl
    ADD CONSTRAINT item_role_acl_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2044 (class 2606 OID 16840)
-- Name: item_role_acl_itemid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_role_acl
    ADD CONSTRAINT item_role_acl_itemid_fkey FOREIGN KEY (itemid) REFERENCES item(itemid);


--
-- TOC entry 2047 (class 2606 OID 16855)
-- Name: item_role_acl_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_role_acl
    ADD CONSTRAINT item_role_acl_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2045 (class 2606 OID 16845)
-- Name: item_role_acl_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_role_acl
    ADD CONSTRAINT item_role_acl_roleid_fkey FOREIGN KEY (roleid) REFERENCES roles(roleid);


--
-- TOC entry 2050 (class 2606 OID 16870)
-- Name: item_user_acl_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_user_acl
    ADD CONSTRAINT item_user_acl_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2048 (class 2606 OID 16860)
-- Name: item_user_acl_itemid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_user_acl
    ADD CONSTRAINT item_user_acl_itemid_fkey FOREIGN KEY (itemid) REFERENCES item(itemid);


--
-- TOC entry 2051 (class 2606 OID 16875)
-- Name: item_user_acl_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_user_acl
    ADD CONSTRAINT item_user_acl_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2049 (class 2606 OID 16865)
-- Name: item_user_acl_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY item_user_acl
    ADD CONSTRAINT item_user_acl_userid_fkey FOREIGN KEY (userid) REFERENCES users(userid);


--
-- TOC entry 2054 (class 2606 OID 16890)
-- Name: related_items_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY related_items
    ADD CONSTRAINT related_items_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2055 (class 2606 OID 16895)
-- Name: related_items_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY related_items
    ADD CONSTRAINT related_items_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2052 (class 2606 OID 16880)
-- Name: related_items_primaryitemid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY related_items
    ADD CONSTRAINT related_items_primaryitemid_fkey FOREIGN KEY (primaryitemid) REFERENCES item(itemid);


--
-- TOC entry 2053 (class 2606 OID 16885)
-- Name: related_items_relateditemid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY related_items
    ADD CONSTRAINT related_items_relateditemid_fkey FOREIGN KEY (relateditemid) REFERENCES item(itemid);


--
-- TOC entry 2056 (class 2606 OID 16900)
-- Name: roles_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2057 (class 2606 OID 16905)
-- Name: roles_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2060 (class 2606 OID 16920)
-- Name: user_roles_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_createdby_fkey FOREIGN KEY (createdby) REFERENCES users(userid);


--
-- TOC entry 2061 (class 2606 OID 16925)
-- Name: user_roles_modifiedby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_modifiedby_fkey FOREIGN KEY (modifiedby) REFERENCES users(userid);


--
-- TOC entry 2059 (class 2606 OID 16915)
-- Name: user_roles_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_roleid_fkey FOREIGN KEY (roleid) REFERENCES roles(roleid);


--
-- TOC entry 2058 (class 2606 OID 16910)
-- Name: user_roles_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: passanager
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_userid_fkey FOREIGN KEY (userid) REFERENCES users(userid);


--
-- TOC entry 2185 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-08-05 22:00:45 EDT

--
-- PostgreSQL database dump complete
--

