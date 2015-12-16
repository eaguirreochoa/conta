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
-- Name: catalogos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE catalogos (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    padre integer,
    estransaccional boolean,
    esflujodeejec boolean,
    usalaux1 boolean,
    usalaux2 boolean,
    tlaux1 character varying,
    tlaux2 character varying,
    idctaajustetc integer,
    idctaajusteufv integer,
    activo boolean,
    nivel_id integer,
    grupo_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    naturaleza character varying(2),
    padre_id character varying,
    idctaacumajusteufv integer
);


--
-- Name: diariodets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE diariodets (
    id integer NOT NULL,
    tlaux1 integer,
    codtlaux2 integer,
    tlaux2 integer,
    glosa character varying,
    debe numeric(20,8),
    haber numeric(20,8),
    debesec numeric(20,8),
    habersec numeric(20,8),
    tcsec numeric(20,8),
    debeori numeric(20,8),
    haberori numeric(20,8),
    tcori numeric(20,8),
    catalogo_id integer,
    oficina_id integer,
    fondo_id integer,
    moneda_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    diario_id integer,
    item integer,
    codtlaux1 integer,
    esdebito boolean,
    monto numeric(20,8),
    ajuste character varying(2),
    libauxdet_id integer
);


--
-- Name: diarios; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE diarios (
    id integer NOT NULL,
    nrocbte integer,
    fechacbte timestamp without time zone,
    glosagral character varying,
    esanulado boolean,
    estado character varying(2),
    origenasiento_id integer,
    tipocomprobante_id integer,
    empresa_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    codigo character varying,
    tc numeric(20,8)
);


--
-- Name: ajuste_ufv_saldos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW ajuste_ufv_saldos AS
    SELECT 0 AS em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, CASE WHEN (d.esdebito = true) THEN sum((d.debe - d.haber)) ELSE sum((d.haber - d.debe)) END AS saldo, CASE WHEN (d.esdebito = true) THEN sum((d.debesec - d.habersec)) ELSE sum((d.habersec - d.debesec)) END AS saldosec, d.esdebito FROM (((SELECT catalogos.id FROM catalogos WHERE (((catalogos.idctaajusteufv >= 1) AND (catalogos.idctaacumajusteufv >= 1)) AND (catalogos.activo = true))) c JOIN diariodets d ON ((c.id = d.catalogo_id))) JOIN diarios t ON (((t.id = d.diario_id) AND (t.tipocomprobante_id <> 5)))) WHERE (t.esanulado = false) GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, d.esdebito;


--
-- Name: ajustes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ajustes (
    id integer NOT NULL,
    fechaproceso timestamp without time zone,
    tipo integer,
    indiceant numeric(20,8),
    indiceact numeric(20,8),
    activo boolean,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    empresa_id integer
);


--
-- Name: ajustes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ajustes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ajustes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ajustes_id_seq OWNED BY ajustes.id;


--
-- Name: grupos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE grupos (
    id integer NOT NULL,
    nombre character varying,
    esbalance boolean,
    esestresul boolean,
    naturaleza character varying(2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nivels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE nivels (
    id integer NOT NULL,
    numnivel integer,
    nrodigitos integer,
    nrodigitostotal integer,
    esmoneda boolean,
    nrodigitosmoneda integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    nombre character varying,
    estransaccional boolean,
    activo boolean
);


--
-- Name: balance_gral_suma_saldos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW balance_gral_suma_saldos AS
    SELECT 0 AS em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, n.numnivel, c.padre_id, g.naturaleza, sum(d.debe) AS debe, sum(d.haber) AS haber, sum(d.debesec) AS debesec, sum(d.habersec) AS habersec, CASE WHEN (((g.esbalance = true) AND (g.esestresul = false)) AND ((g.naturaleza)::text = 'D'::text)) THEN 'ACT'::text WHEN (((g.esbalance = true) AND (g.esestresul = false)) AND ((g.naturaleza)::text = 'A'::text)) THEN 'PAS'::text WHEN (((g.esbalance = false) AND (g.esestresul = true)) AND ((g.naturaleza)::text = 'D'::text)) THEN 'GAS'::text WHEN (((g.esbalance = false) AND (g.esestresul = true)) AND ((g.naturaleza)::text = 'A'::text)) THEN 'ING'::text ELSE 'PAT'::text END AS tipo FROM ((((diarios t JOIN diariodets d ON (((t.id = d.diario_id) AND (t.tipocomprobante_id <> 5)))) JOIN catalogos c ON (((c.id = d.catalogo_id) AND (c.activo = true)))) JOIN grupos g ON ((g.id = c.grupo_id))) JOIN nivels n ON ((n.id = c.nivel_id))) WHERE (t.esanulado = false) GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, g.esbalance, g.esestresul, g.naturaleza, n.numnivel, c.padre_id;


--
-- Name: balance_grals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE balance_grals (
    id integer NOT NULL,
    sesion integer,
    em_of_c character varying,
    empresa_id integer,
    oficina_id integer,
    catalogo_id integer,
    ciclo_id integer,
    tlaux1 integer,
    codtlaux1 integer,
    tlaux2 integer,
    codtlaux2 integer,
    padre_id integer,
    codigo character varying,
    tipo character varying(3),
    numnivel integer,
    naturaleza character varying(2),
    estransaccional boolean,
    debe numeric(20,8),
    haber numeric(20,8),
    saldo numeric(20,8),
    saldob numeric(20,8),
    saldoc numeric(20,8),
    debeb numeric(20,8),
    haberb numeric(20,8),
    debec numeric(20,8),
    haberc numeric(20,8),
    debed numeric(20,8),
    haberd numeric(20,8),
    debesec numeric(20,8),
    habersec numeric(20,8),
    saldosec numeric(20,8),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: balance_grals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE balance_grals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: balance_grals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE balance_grals_id_seq OWNED BY balance_grals.id;


--
-- Name: cargos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cargos (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cargos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cargos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cargos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cargos_id_seq OWNED BY cargos.id;


--
-- Name: catalogos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE catalogos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: catalogos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE catalogos_id_seq OWNED BY catalogos.id;


--
-- Name: ciclos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ciclos (
    id integer NOT NULL,
    fini timestamp without time zone,
    ffin timestamp without time zone,
    activo boolean,
    empresa_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tipo character varying(3)
);


--
-- Name: ciclos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ciclos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ciclos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ciclos_id_seq OWNED BY ciclos.id;


--
-- Name: cierre_ciclos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cierre_ciclos (
    id integer NOT NULL,
    fechaproceso timestamp without time zone,
    esoficial boolean,
    iddiariocierre integer,
    activo boolean,
    ciclo_id integer,
    diario_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "desc" character varying,
    empresa_id integer
);


--
-- Name: cierre_ciclos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cierre_ciclos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cierre_ciclos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cierre_ciclos_id_seq OWNED BY cierre_ciclos.id;


--
-- Name: cierres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cierres (
    id integer NOT NULL,
    fechaproceso timestamp without time zone,
    tipo integer,
    "desc" character varying,
    activo boolean,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    empresa_id integer,
    periodo_id integer
);


--
-- Name: cierres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cierres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cierres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cierres_id_seq OWNED BY cierres.id;


--
-- Name: correlcbtes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE correlcbtes (
    id integer NOT NULL,
    nro integer,
    activo boolean,
    tipocomprobante_id integer,
    empresa_id integer,
    periodo_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    diario_id integer
);


--
-- Name: correlcbtes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE correlcbtes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: correlcbtes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE correlcbtes_id_seq OWNED BY correlcbtes.id;


--
-- Name: cuentabancos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cuentabancos (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    nrocuenta character varying,
    tipocuenta character varying(2),
    activo boolean,
    moneda_id integer,
    entidad_id integer,
    catalogo_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cuentabancos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cuentabancos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cuentabancos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cuentabancos_id_seq OWNED BY cuentabancos.id;


--
-- Name: diariodets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE diariodets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diariodets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE diariodets_id_seq OWNED BY diariodets.id;


--
-- Name: diarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE diarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE diarios_id_seq OWNED BY diarios.id;


--
-- Name: direccions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE direccions (
    id integer NOT NULL,
    zonaurbana character varying,
    edificio character varying,
    pisodepof character varying,
    descripcion character varying,
    persona_id integer,
    ubicaciongeografica_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: direccions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE direccions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: direccions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE direccions_id_seq OWNED BY direccions.id;


--
-- Name: docidenexts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE docidenexts (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    activo boolean,
    dociden_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: docidenexts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE docidenexts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: docidenexts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE docidenexts_id_seq OWNED BY docidenexts.id;


--
-- Name: docidens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE docidens (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    formato character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: docidens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE docidens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: docidens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE docidens_id_seq OWNED BY docidens.id;


--
-- Name: empresas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE empresas (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: empresas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE empresas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: empresas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE empresas_id_seq OWNED BY empresas.id;


--
-- Name: entidads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entidads (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: entidads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entidads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entidads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entidads_id_seq OWNED BY entidads.id;


--
-- Name: estado_cuenta_det_saldos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW estado_cuenta_det_saldos AS
    SELECT 0 AS em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, CASE WHEN (d.esdebito = true) THEN sum((d.debe - d.haber)) ELSE sum((d.haber - d.debe)) END AS saldo, CASE WHEN (d.esdebito = true) THEN sum((d.debesec - d.habersec)) ELSE sum((d.habersec - d.debesec)) END AS saldosec FROM (diarios t JOIN diariodets d ON (((t.id = d.diario_id) AND (t.tipocomprobante_id <> 5)))) WHERE (t.esanulado = false) GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.esdebito, d.tlaux1, d.codtlaux1;


--
-- Name: estado_resultados; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE estado_resultados (
    id integer NOT NULL,
    sesion integer,
    em_of_c character varying,
    empresa_id integer,
    oficina_id integer,
    catalogo_id integer,
    tlaux1 integer,
    codtlaux1 integer,
    tlaux2 integer,
    codtlaux2 integer,
    padre_id integer,
    codigo character varying,
    tipo character varying(3),
    numnivel integer,
    naturaleza character varying(2),
    estransaccional boolean,
    saldo numeric(20,8),
    saldosec numeric(20,8),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: estado_resultados_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE estado_resultados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estado_resultados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE estado_resultados_id_seq OWNED BY estado_resultados.id;


--
-- Name: fondocuentabancos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fondocuentabancos (
    id integer NOT NULL,
    activo boolean,
    cuentabanco_id integer,
    fondo_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fondocuentabancos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fondocuentabancos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fondocuentabancos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fondocuentabancos_id_seq OWNED BY fondocuentabancos.id;


--
-- Name: fondos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fondos (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    activo boolean,
    entidad_id integer,
    empresa_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fondos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fondos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fondos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fondos_id_seq OWNED BY fondos.id;


--
-- Name: grupos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE grupos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grupos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE grupos_id_seq OWNED BY grupos.id;


--
-- Name: libauxdets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE libauxdets (
    id integer NOT NULL,
    name character varying,
    libauxdetable_id integer,
    libauxdetable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: libauxdets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE libauxdets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: libauxdets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE libauxdets_id_seq OWNED BY libauxdets.id;


--
-- Name: libroauxiliars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE libroauxiliars (
    id integer NOT NULL,
    categoria character varying,
    descripcion character varying,
    selista boolean,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: libroauxiliars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE libroauxiliars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: libroauxiliars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE libroauxiliars_id_seq OWNED BY libroauxiliars.id;


--
-- Name: mayor_hists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mayor_hists (
    id integer NOT NULL,
    tlaux1 integer,
    codtlaux1 integer,
    tlaux2 integer,
    codtlaux2 integer,
    tipo character varying(3),
    esdebito boolean,
    debe numeric(20,8),
    haber numeric(20,8),
    debesec numeric(20,8),
    habersec numeric(20,8),
    empresa_id integer,
    oficina_id integer,
    catalogo_id integer,
    ciclo_id integer,
    periodo_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mayor_hists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mayor_hists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mayor_hists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mayor_hists_id_seq OWNED BY mayor_hists.id;


--
-- Name: mayor_saldos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW mayor_saldos AS
    SELECT 0 AS em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, CASE WHEN (d.esdebito = true) THEN sum((d.debe - d.haber)) ELSE sum((d.haber - d.debe)) END AS saldo, CASE WHEN (d.esdebito = true) THEN sum((d.debesec - d.habersec)) ELSE sum((d.habersec - d.debesec)) END AS saldosec FROM (diarios t JOIN diariodets d ON (((t.id = d.diario_id) AND (t.tipocomprobante_id <> 5)))) WHERE (t.esanulado = false) GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.esdebito;


--
-- Name: mayors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mayors (
    id integer NOT NULL,
    sesion integer,
    em_of_c character varying,
    fechacbte timestamp without time zone,
    grupo integer,
    catalogo_id integer,
    empresa_id integer,
    oficina_id integer,
    moneda_id integer,
    empresa character varying,
    oficina character varying,
    codigo character varying,
    tipocbte character varying,
    nrocbte integer,
    tlaux1 integer,
    codtlaux1 integer,
    tlaux2 integer,
    codtlaux2 integer,
    glosa character varying,
    esdebito boolean,
    debe numeric(20,8),
    haber numeric(20,8),
    debesec numeric(20,8),
    habersec numeric(20,8),
    tc numeric(20,8),
    saldo numeric(20,8),
    saldosec numeric(20,8),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mayors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mayors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mayors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mayors_id_seq OWNED BY mayors.id;


--
-- Name: monedas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE monedas (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    esfuncional boolean,
    esestranjera boolean,
    esufv boolean,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: monedas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE monedas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monedas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE monedas_id_seq OWNED BY monedas.id;


--
-- Name: nivels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE nivels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nivels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE nivels_id_seq OWNED BY nivels.id;


--
-- Name: oficinas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE oficinas (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    direccion character varying,
    telefono character varying,
    correo character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: oficinas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oficinas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oficinas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oficinas_id_seq OWNED BY oficinas.id;


--
-- Name: origenasientos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE origenasientos (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: origenasientos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE origenasientos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: origenasientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE origenasientos_id_seq OWNED BY origenasientos.id;


--
-- Name: periodos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE periodos (
    id integer NOT NULL,
    fini timestamp without time zone,
    ffin timestamp without time zone,
    nro integer,
    gestion character varying(5),
    activo boolean,
    empresa_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ciclo_id integer
);


--
-- Name: periodos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE periodos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: periodos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE periodos_id_seq OWNED BY periodos.id;


--
-- Name: personas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personas (
    id integer NOT NULL,
    codigo character varying,
    nombres character varying,
    appaterno character varying,
    apmaterno character varying,
    apcasada character varying,
    di character varying,
    telefono character varying,
    correo character varying,
    type character varying,
    oficina_id integer,
    cargo_id integer,
    dociden_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fechaingreso timestamp without time zone,
    fechanacimiento timestamp without time zone,
    genero boolean,
    estadocivil character varying(2),
    tiposociedad_id integer,
    tipoentidad_id integer,
    esjuridica boolean
);


--
-- Name: personas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personas_id_seq OWNED BY personas.id;


--
-- Name: replegals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE replegals (
    id integer NOT NULL,
    codigo character varying,
    replegalable_id integer,
    replegalable_type character varying,
    persona_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: replegals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE replegals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: replegals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE replegals_id_seq OWNED BY replegals.id;


--
-- Name: saldo_dets; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW saldo_dets AS
    SELECT 0 AS em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, d.tlaux1, d.codtlaux1, t.fechacbte, n.numnivel, c.padre_id, g.naturaleza, sum(d.debe) AS debe, sum(d.haber) AS haber, sum(d.debesec) AS debesec, sum(d.habersec) AS habersec, CASE WHEN (((g.esbalance = true) AND (g.esestresul = false)) AND ((g.naturaleza)::text = 'D'::text)) THEN 'ACT'::text WHEN (((g.esbalance = true) AND (g.esestresul = false)) AND ((g.naturaleza)::text = 'A'::text)) THEN 'PAS'::text WHEN (((g.esbalance = false) AND (g.esestresul = true)) AND ((g.naturaleza)::text = 'D'::text)) THEN 'GAS'::text WHEN (((g.esbalance = false) AND (g.esestresul = true)) AND ((g.naturaleza)::text = 'A'::text)) THEN 'ING'::text ELSE 'PAT'::text END AS tipo FROM ((((diarios t JOIN diariodets d ON (((t.tipocomprobante_id <> 5) AND (t.id = d.diario_id)))) JOIN catalogos c ON (((c.id = d.catalogo_id) AND (c.activo = true)))) JOIN grupos g ON ((g.id = c.grupo_id))) JOIN nivels n ON ((n.id = c.nivel_id))) WHERE (t.esanulado = false) GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, d.tlaux1, d.codtlaux1, t.fechacbte, g.esbalance, g.esestresul, g.naturaleza, n.numnivel, c.padre_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: suma_saldos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW suma_saldos AS
    SELECT 0 AS em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, c.codigo, t.fechacbte, sum(d.debe) AS debe, sum(d.haber) AS haber, sum(d.debesec) AS debesec, sum(d.habersec) AS habersec, CASE WHEN (((g.esbalance = true) AND (g.esestresul = false)) AND ((g.naturaleza)::text = 'D'::text)) THEN 'ACT'::text WHEN (((g.esbalance = true) AND (g.esestresul = false)) AND ((g.naturaleza)::text = 'A'::text)) THEN 'PAS'::text WHEN (((g.esbalance = false) AND (g.esestresul = true)) AND ((g.naturaleza)::text = 'D'::text)) THEN 'GAS'::text WHEN (((g.esbalance = false) AND (g.esestresul = true)) AND ((g.naturaleza)::text = 'A'::text)) THEN 'ING'::text ELSE NULL::text END AS tipo FROM (((diarios t JOIN diariodets d ON (((t.id = d.diario_id) AND (t.tipocomprobante_id <> 5)))) JOIN catalogos c ON (((c.id = d.catalogo_id) AND (c.activo = true)))) JOIN grupos g ON ((g.id = c.grupo_id))) WHERE (t.esanulado = false) GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, g.esbalance, g.esestresul, g.naturaleza, c.codigo;


--
-- Name: tipocomprobantes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tipocomprobantes (
    id integer NOT NULL,
    codigo character varying,
    nombre character varying,
    sigla character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tipocomprobantes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tipocomprobantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipocomprobantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tipocomprobantes_id_seq OWNED BY tipocomprobantes.id;


--
-- Name: tipoentidads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tipoentidads (
    id integer NOT NULL,
    codigo character varying,
    sigla character varying,
    nombre character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tipoentidads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tipoentidads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipoentidads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tipoentidads_id_seq OWNED BY tipoentidads.id;


--
-- Name: tiposociedads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tiposociedads (
    id integer NOT NULL,
    codigo character varying,
    sigla character varying,
    nombre character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tiposociedads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tiposociedads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tiposociedads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tiposociedads_id_seq OWNED BY tiposociedads.id;


--
-- Name: ubicaciongeograficas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ubicaciongeograficas (
    id integer NOT NULL,
    codigodept character varying,
    codigoprov character varying,
    codigoloca character varying,
    nombredept character varying,
    nombreprov character varying,
    nombreloca character varying,
    activo boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ubicaciongeograficas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ubicaciongeograficas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ubicaciongeograficas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ubicaciongeograficas_id_seq OWNED BY ubicaciongeograficas.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    username character varying,
    role character varying,
    persona_id integer
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ajustes ALTER COLUMN id SET DEFAULT nextval('ajustes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY balance_grals ALTER COLUMN id SET DEFAULT nextval('balance_grals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cargos ALTER COLUMN id SET DEFAULT nextval('cargos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY catalogos ALTER COLUMN id SET DEFAULT nextval('catalogos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ciclos ALTER COLUMN id SET DEFAULT nextval('ciclos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierre_ciclos ALTER COLUMN id SET DEFAULT nextval('cierre_ciclos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierres ALTER COLUMN id SET DEFAULT nextval('cierres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY correlcbtes ALTER COLUMN id SET DEFAULT nextval('correlcbtes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cuentabancos ALTER COLUMN id SET DEFAULT nextval('cuentabancos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets ALTER COLUMN id SET DEFAULT nextval('diariodets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY diarios ALTER COLUMN id SET DEFAULT nextval('diarios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY direccions ALTER COLUMN id SET DEFAULT nextval('direccions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY docidenexts ALTER COLUMN id SET DEFAULT nextval('docidenexts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY docidens ALTER COLUMN id SET DEFAULT nextval('docidens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY empresas ALTER COLUMN id SET DEFAULT nextval('empresas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entidads ALTER COLUMN id SET DEFAULT nextval('entidads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY estado_resultados ALTER COLUMN id SET DEFAULT nextval('estado_resultados_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fondocuentabancos ALTER COLUMN id SET DEFAULT nextval('fondocuentabancos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fondos ALTER COLUMN id SET DEFAULT nextval('fondos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY grupos ALTER COLUMN id SET DEFAULT nextval('grupos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY libauxdets ALTER COLUMN id SET DEFAULT nextval('libauxdets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY libroauxiliars ALTER COLUMN id SET DEFAULT nextval('libroauxiliars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mayor_hists ALTER COLUMN id SET DEFAULT nextval('mayor_hists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mayors ALTER COLUMN id SET DEFAULT nextval('mayors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY monedas ALTER COLUMN id SET DEFAULT nextval('monedas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY nivels ALTER COLUMN id SET DEFAULT nextval('nivels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oficinas ALTER COLUMN id SET DEFAULT nextval('oficinas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY origenasientos ALTER COLUMN id SET DEFAULT nextval('origenasientos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY periodos ALTER COLUMN id SET DEFAULT nextval('periodos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personas ALTER COLUMN id SET DEFAULT nextval('personas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY replegals ALTER COLUMN id SET DEFAULT nextval('replegals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tipocomprobantes ALTER COLUMN id SET DEFAULT nextval('tipocomprobantes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tipoentidads ALTER COLUMN id SET DEFAULT nextval('tipoentidads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tiposociedads ALTER COLUMN id SET DEFAULT nextval('tiposociedads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ubicaciongeograficas ALTER COLUMN id SET DEFAULT nextval('ubicaciongeograficas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ajustes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ajustes
    ADD CONSTRAINT ajustes_pkey PRIMARY KEY (id);


--
-- Name: balance_grals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY balance_grals
    ADD CONSTRAINT balance_grals_pkey PRIMARY KEY (id);


--
-- Name: cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id);


--
-- Name: catalogos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY catalogos
    ADD CONSTRAINT catalogos_pkey PRIMARY KEY (id);


--
-- Name: ciclos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ciclos
    ADD CONSTRAINT ciclos_pkey PRIMARY KEY (id);


--
-- Name: cierre_ciclos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cierre_ciclos
    ADD CONSTRAINT cierre_ciclos_pkey PRIMARY KEY (id);


--
-- Name: cierres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cierres
    ADD CONSTRAINT cierres_pkey PRIMARY KEY (id);


--
-- Name: correlcbtes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY correlcbtes
    ADD CONSTRAINT correlcbtes_pkey PRIMARY KEY (id);


--
-- Name: cuentabancos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cuentabancos
    ADD CONSTRAINT cuentabancos_pkey PRIMARY KEY (id);


--
-- Name: diariodets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT diariodets_pkey PRIMARY KEY (id);


--
-- Name: diarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY diarios
    ADD CONSTRAINT diarios_pkey PRIMARY KEY (id);


--
-- Name: direccions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY direccions
    ADD CONSTRAINT direccions_pkey PRIMARY KEY (id);


--
-- Name: docidenexts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY docidenexts
    ADD CONSTRAINT docidenexts_pkey PRIMARY KEY (id);


--
-- Name: docidens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY docidens
    ADD CONSTRAINT docidens_pkey PRIMARY KEY (id);


--
-- Name: empresas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY empresas
    ADD CONSTRAINT empresas_pkey PRIMARY KEY (id);


--
-- Name: entidads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entidads
    ADD CONSTRAINT entidads_pkey PRIMARY KEY (id);


--
-- Name: estado_resultados_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY estado_resultados
    ADD CONSTRAINT estado_resultados_pkey PRIMARY KEY (id);


--
-- Name: fondocuentabancos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fondocuentabancos
    ADD CONSTRAINT fondocuentabancos_pkey PRIMARY KEY (id);


--
-- Name: fondos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fondos
    ADD CONSTRAINT fondos_pkey PRIMARY KEY (id);


--
-- Name: grupos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grupos
    ADD CONSTRAINT grupos_pkey PRIMARY KEY (id);


--
-- Name: libauxdets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY libauxdets
    ADD CONSTRAINT libauxdets_pkey PRIMARY KEY (id);


--
-- Name: libroauxiliars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY libroauxiliars
    ADD CONSTRAINT libroauxiliars_pkey PRIMARY KEY (id);


--
-- Name: mayor_hists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mayor_hists
    ADD CONSTRAINT mayor_hists_pkey PRIMARY KEY (id);


--
-- Name: mayors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mayors
    ADD CONSTRAINT mayors_pkey PRIMARY KEY (id);


--
-- Name: monedas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY monedas
    ADD CONSTRAINT monedas_pkey PRIMARY KEY (id);


--
-- Name: nivels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY nivels
    ADD CONSTRAINT nivels_pkey PRIMARY KEY (id);


--
-- Name: oficinas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY oficinas
    ADD CONSTRAINT oficinas_pkey PRIMARY KEY (id);


--
-- Name: origenasientos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY origenasientos
    ADD CONSTRAINT origenasientos_pkey PRIMARY KEY (id);


--
-- Name: periodos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY periodos
    ADD CONSTRAINT periodos_pkey PRIMARY KEY (id);


--
-- Name: personas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT personas_pkey PRIMARY KEY (id);


--
-- Name: replegals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY replegals
    ADD CONSTRAINT replegals_pkey PRIMARY KEY (id);


--
-- Name: tipocomprobantes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tipocomprobantes
    ADD CONSTRAINT tipocomprobantes_pkey PRIMARY KEY (id);


--
-- Name: tipoentidads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tipoentidads
    ADD CONSTRAINT tipoentidads_pkey PRIMARY KEY (id);


--
-- Name: tiposociedads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tiposociedads
    ADD CONSTRAINT tiposociedads_pkey PRIMARY KEY (id);


--
-- Name: ubicaciongeograficas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ubicaciongeograficas
    ADD CONSTRAINT ubicaciongeograficas_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_ajustes_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ajustes_on_empresa_id ON ajustes USING btree (empresa_id);


--
-- Name: index_ajustes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ajustes_on_user_id ON ajustes USING btree (user_id);


--
-- Name: index_catalogos_on_grupo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_catalogos_on_grupo_id ON catalogos USING btree (grupo_id);


--
-- Name: index_catalogos_on_nivel_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_catalogos_on_nivel_id ON catalogos USING btree (nivel_id);


--
-- Name: index_ciclos_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ciclos_on_empresa_id ON ciclos USING btree (empresa_id);


--
-- Name: index_cierre_ciclos_on_ciclo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cierre_ciclos_on_ciclo_id ON cierre_ciclos USING btree (ciclo_id);


--
-- Name: index_cierre_ciclos_on_diario_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cierre_ciclos_on_diario_id ON cierre_ciclos USING btree (diario_id);


--
-- Name: index_cierre_ciclos_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cierre_ciclos_on_empresa_id ON cierre_ciclos USING btree (empresa_id);


--
-- Name: index_cierre_ciclos_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cierre_ciclos_on_user_id ON cierre_ciclos USING btree (user_id);


--
-- Name: index_cierres_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cierres_on_empresa_id ON cierres USING btree (empresa_id);


--
-- Name: index_cierres_on_periodo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cierres_on_periodo_id ON cierres USING btree (periodo_id);


--
-- Name: index_cierres_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cierres_on_user_id ON cierres USING btree (user_id);


--
-- Name: index_correlcbtes_on_diario_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_correlcbtes_on_diario_id ON correlcbtes USING btree (diario_id);


--
-- Name: index_correlcbtes_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_correlcbtes_on_empresa_id ON correlcbtes USING btree (empresa_id);


--
-- Name: index_correlcbtes_on_periodo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_correlcbtes_on_periodo_id ON correlcbtes USING btree (periodo_id);


--
-- Name: index_correlcbtes_on_tipocomprobante_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_correlcbtes_on_tipocomprobante_id ON correlcbtes USING btree (tipocomprobante_id);


--
-- Name: index_cuentabancos_on_catalogo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cuentabancos_on_catalogo_id ON cuentabancos USING btree (catalogo_id);


--
-- Name: index_cuentabancos_on_entidad_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cuentabancos_on_entidad_id ON cuentabancos USING btree (entidad_id);


--
-- Name: index_cuentabancos_on_moneda_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cuentabancos_on_moneda_id ON cuentabancos USING btree (moneda_id);


--
-- Name: index_diariodets_on_catalogo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diariodets_on_catalogo_id ON diariodets USING btree (catalogo_id);


--
-- Name: index_diariodets_on_diario_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diariodets_on_diario_id ON diariodets USING btree (diario_id);


--
-- Name: index_diariodets_on_fondo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diariodets_on_fondo_id ON diariodets USING btree (fondo_id);


--
-- Name: index_diariodets_on_libauxdet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diariodets_on_libauxdet_id ON diariodets USING btree (libauxdet_id);


--
-- Name: index_diariodets_on_moneda_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diariodets_on_moneda_id ON diariodets USING btree (moneda_id);


--
-- Name: index_diariodets_on_oficina_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diariodets_on_oficina_id ON diariodets USING btree (oficina_id);


--
-- Name: index_diariodets_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diariodets_on_user_id ON diariodets USING btree (user_id);


--
-- Name: index_diarios_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diarios_on_empresa_id ON diarios USING btree (empresa_id);


--
-- Name: index_diarios_on_origenasiento_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diarios_on_origenasiento_id ON diarios USING btree (origenasiento_id);


--
-- Name: index_diarios_on_tipocomprobante_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_diarios_on_tipocomprobante_id ON diarios USING btree (tipocomprobante_id);


--
-- Name: index_direccions_on_persona_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_direccions_on_persona_id ON direccions USING btree (persona_id);


--
-- Name: index_direccions_on_ubicaciongeografica_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_direccions_on_ubicaciongeografica_id ON direccions USING btree (ubicaciongeografica_id);


--
-- Name: index_docidenexts_on_dociden_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_docidenexts_on_dociden_id ON docidenexts USING btree (dociden_id);


--
-- Name: index_fondocuentabancos_on_cuentabanco_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fondocuentabancos_on_cuentabanco_id ON fondocuentabancos USING btree (cuentabanco_id);


--
-- Name: index_fondocuentabancos_on_fondo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fondocuentabancos_on_fondo_id ON fondocuentabancos USING btree (fondo_id);


--
-- Name: index_fondos_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fondos_on_empresa_id ON fondos USING btree (empresa_id);


--
-- Name: index_fondos_on_entidad_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fondos_on_entidad_id ON fondos USING btree (entidad_id);


--
-- Name: index_libauxdets_on_libauxdetable_type_and_libauxdetable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_libauxdets_on_libauxdetable_type_and_libauxdetable_id ON libauxdets USING btree (libauxdetable_type, libauxdetable_id);


--
-- Name: index_libauxdets_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_libauxdets_on_name ON libauxdets USING btree (name);


--
-- Name: index_mayor_hists_on_catalogo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mayor_hists_on_catalogo_id ON mayor_hists USING btree (catalogo_id);


--
-- Name: index_mayor_hists_on_ciclo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mayor_hists_on_ciclo_id ON mayor_hists USING btree (ciclo_id);


--
-- Name: index_mayor_hists_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mayor_hists_on_empresa_id ON mayor_hists USING btree (empresa_id);


--
-- Name: index_mayor_hists_on_oficina_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mayor_hists_on_oficina_id ON mayor_hists USING btree (oficina_id);


--
-- Name: index_mayor_hists_on_periodo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mayor_hists_on_periodo_id ON mayor_hists USING btree (periodo_id);


--
-- Name: index_periodos_on_ciclo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_periodos_on_ciclo_id ON periodos USING btree (ciclo_id);


--
-- Name: index_periodos_on_empresa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_periodos_on_empresa_id ON periodos USING btree (empresa_id);


--
-- Name: index_personas_on_cargo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_personas_on_cargo_id ON personas USING btree (cargo_id);


--
-- Name: index_personas_on_dociden_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_personas_on_dociden_id ON personas USING btree (dociden_id);


--
-- Name: index_personas_on_oficina_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_personas_on_oficina_id ON personas USING btree (oficina_id);


--
-- Name: index_personas_on_tipoentidad_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_personas_on_tipoentidad_id ON personas USING btree (tipoentidad_id);


--
-- Name: index_personas_on_tiposociedad_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_personas_on_tiposociedad_id ON personas USING btree (tiposociedad_id);


--
-- Name: index_replegals_on_codigo; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_replegals_on_codigo ON replegals USING btree (codigo);


--
-- Name: index_replegals_on_persona_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_replegals_on_persona_id ON replegals USING btree (persona_id);


--
-- Name: index_replegals_on_replegalable_type_and_replegalable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_replegals_on_replegalable_type_and_replegalable_id ON replegals USING btree (replegalable_type, replegalable_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_024b6bebbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY direccions
    ADD CONSTRAINT fk_rails_024b6bebbd FOREIGN KEY (ubicaciongeografica_id) REFERENCES ubicaciongeograficas(id);


--
-- Name: fk_rails_0264ff1aaa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT fk_rails_0264ff1aaa FOREIGN KEY (tiposociedad_id) REFERENCES tiposociedads(id);


--
-- Name: fk_rails_02ce31ba8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT fk_rails_02ce31ba8d FOREIGN KEY (dociden_id) REFERENCES docidens(id);


--
-- Name: fk_rails_0377ca131a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fondos
    ADD CONSTRAINT fk_rails_0377ca131a FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_0d61dc9ac3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY direccions
    ADD CONSTRAINT fk_rails_0d61dc9ac3 FOREIGN KEY (persona_id) REFERENCES personas(id);


--
-- Name: fk_rails_0e4e7d6f1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT fk_rails_0e4e7d6f1e FOREIGN KEY (fondo_id) REFERENCES fondos(id);


--
-- Name: fk_rails_176f917110; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT fk_rails_176f917110 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_1790598faf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fondocuentabancos
    ADD CONSTRAINT fk_rails_1790598faf FOREIGN KEY (fondo_id) REFERENCES fondos(id);


--
-- Name: fk_rails_19a30d7c94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierre_ciclos
    ADD CONSTRAINT fk_rails_19a30d7c94 FOREIGN KEY (ciclo_id) REFERENCES ciclos(id);


--
-- Name: fk_rails_1d827a2012; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT fk_rails_1d827a2012 FOREIGN KEY (oficina_id) REFERENCES oficinas(id);


--
-- Name: fk_rails_22767ad1b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierre_ciclos
    ADD CONSTRAINT fk_rails_22767ad1b7 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_247c1cdd58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY periodos
    ADD CONSTRAINT fk_rails_247c1cdd58 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_2b30e9a36c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ajustes
    ADD CONSTRAINT fk_rails_2b30e9a36c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_2cc7e0264b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY correlcbtes
    ADD CONSTRAINT fk_rails_2cc7e0264b FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_44756eb035; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mayor_hists
    ADD CONSTRAINT fk_rails_44756eb035 FOREIGN KEY (periodo_id) REFERENCES periodos(id);


--
-- Name: fk_rails_469eaf1c56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY correlcbtes
    ADD CONSTRAINT fk_rails_469eaf1c56 FOREIGN KEY (diario_id) REFERENCES diarios(id);


--
-- Name: fk_rails_5c425dea89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY catalogos
    ADD CONSTRAINT fk_rails_5c425dea89 FOREIGN KEY (grupo_id) REFERENCES grupos(id);


--
-- Name: fk_rails_65197937ad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diarios
    ADD CONSTRAINT fk_rails_65197937ad FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_68174d39e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fondos
    ADD CONSTRAINT fk_rails_68174d39e0 FOREIGN KEY (entidad_id) REFERENCES entidads(id);


--
-- Name: fk_rails_6ffa9fafdd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ciclos
    ADD CONSTRAINT fk_rails_6ffa9fafdd FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_84c0443092; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT fk_rails_84c0443092 FOREIGN KEY (catalogo_id) REFERENCES catalogos(id);


--
-- Name: fk_rails_96de3ef735; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cuentabancos
    ADD CONSTRAINT fk_rails_96de3ef735 FOREIGN KEY (moneda_id) REFERENCES monedas(id);


--
-- Name: fk_rails_9714ec4507; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY catalogos
    ADD CONSTRAINT fk_rails_9714ec4507 FOREIGN KEY (nivel_id) REFERENCES nivels(id);


--
-- Name: fk_rails_97961108df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY correlcbtes
    ADD CONSTRAINT fk_rails_97961108df FOREIGN KEY (periodo_id) REFERENCES periodos(id);


--
-- Name: fk_rails_9c2d9936e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierre_ciclos
    ADD CONSTRAINT fk_rails_9c2d9936e5 FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_9d35c3228d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT fk_rails_9d35c3228d FOREIGN KEY (cargo_id) REFERENCES cargos(id);


--
-- Name: fk_rails_a0d0742fef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fondocuentabancos
    ADD CONSTRAINT fk_rails_a0d0742fef FOREIGN KEY (cuentabanco_id) REFERENCES cuentabancos(id);


--
-- Name: fk_rails_a11f1a3292; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mayor_hists
    ADD CONSTRAINT fk_rails_a11f1a3292 FOREIGN KEY (oficina_id) REFERENCES oficinas(id);


--
-- Name: fk_rails_a5b863edd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mayor_hists
    ADD CONSTRAINT fk_rails_a5b863edd5 FOREIGN KEY (catalogo_id) REFERENCES catalogos(id);


--
-- Name: fk_rails_a8df49462d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY periodos
    ADD CONSTRAINT fk_rails_a8df49462d FOREIGN KEY (ciclo_id) REFERENCES ciclos(id);


--
-- Name: fk_rails_aaab96e8b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY replegals
    ADD CONSTRAINT fk_rails_aaab96e8b5 FOREIGN KEY (persona_id) REFERENCES personas(id);


--
-- Name: fk_rails_afb7c10539; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cuentabancos
    ADD CONSTRAINT fk_rails_afb7c10539 FOREIGN KEY (entidad_id) REFERENCES entidads(id);


--
-- Name: fk_rails_b27725684b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT fk_rails_b27725684b FOREIGN KEY (tipoentidad_id) REFERENCES tipoentidads(id);


--
-- Name: fk_rails_b768190e12; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY correlcbtes
    ADD CONSTRAINT fk_rails_b768190e12 FOREIGN KEY (tipocomprobante_id) REFERENCES tipocomprobantes(id);


--
-- Name: fk_rails_c21c74648a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierres
    ADD CONSTRAINT fk_rails_c21c74648a FOREIGN KEY (periodo_id) REFERENCES periodos(id);


--
-- Name: fk_rails_c337bc2a67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mayor_hists
    ADD CONSTRAINT fk_rails_c337bc2a67 FOREIGN KEY (ciclo_id) REFERENCES ciclos(id);


--
-- Name: fk_rails_c5947acd79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT fk_rails_c5947acd79 FOREIGN KEY (oficina_id) REFERENCES oficinas(id);


--
-- Name: fk_rails_cc6d5e3b91; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diarios
    ADD CONSTRAINT fk_rails_cc6d5e3b91 FOREIGN KEY (tipocomprobante_id) REFERENCES tipocomprobantes(id);


--
-- Name: fk_rails_d0ffe216eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT fk_rails_d0ffe216eb FOREIGN KEY (libauxdet_id) REFERENCES libauxdets(id);


--
-- Name: fk_rails_d3c886250b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mayor_hists
    ADD CONSTRAINT fk_rails_d3c886250b FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_d3dd95f0a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierre_ciclos
    ADD CONSTRAINT fk_rails_d3dd95f0a2 FOREIGN KEY (diario_id) REFERENCES diarios(id);


--
-- Name: fk_rails_d657a2beca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cuentabancos
    ADD CONSTRAINT fk_rails_d657a2beca FOREIGN KEY (catalogo_id) REFERENCES catalogos(id);


--
-- Name: fk_rails_dca2235f59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT fk_rails_dca2235f59 FOREIGN KEY (diario_id) REFERENCES diarios(id);


--
-- Name: fk_rails_e1477ba5ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierres
    ADD CONSTRAINT fk_rails_e1477ba5ee FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_e3febc5b9b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ajustes
    ADD CONSTRAINT fk_rails_e3febc5b9b FOREIGN KEY (empresa_id) REFERENCES empresas(id);


--
-- Name: fk_rails_e4ac4ba6c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cierres
    ADD CONSTRAINT fk_rails_e4ac4ba6c4 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_ecb5fb2b3b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diariodets
    ADD CONSTRAINT fk_rails_ecb5fb2b3b FOREIGN KEY (moneda_id) REFERENCES monedas(id);


--
-- Name: fk_rails_ede30beecc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docidenexts
    ADD CONSTRAINT fk_rails_ede30beecc FOREIGN KEY (dociden_id) REFERENCES docidens(id);


--
-- Name: fk_rails_fa77ded834; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY diarios
    ADD CONSTRAINT fk_rails_fa77ded834 FOREIGN KEY (origenasiento_id) REFERENCES origenasientos(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150515011927');

INSERT INTO schema_migrations (version) VALUES ('20150515011938');

INSERT INTO schema_migrations (version) VALUES ('20150515012241');

INSERT INTO schema_migrations (version) VALUES ('20150515012257');

INSERT INTO schema_migrations (version) VALUES ('20150515012314');

INSERT INTO schema_migrations (version) VALUES ('20150515012326');

INSERT INTO schema_migrations (version) VALUES ('20150515012337');

INSERT INTO schema_migrations (version) VALUES ('20150515160606');

INSERT INTO schema_migrations (version) VALUES ('20150519145850');

INSERT INTO schema_migrations (version) VALUES ('20150519160800');

INSERT INTO schema_migrations (version) VALUES ('20150519185726');

INSERT INTO schema_migrations (version) VALUES ('20150616162228');

INSERT INTO schema_migrations (version) VALUES ('20150616162242');

INSERT INTO schema_migrations (version) VALUES ('20150617203809');

INSERT INTO schema_migrations (version) VALUES ('20150703221501');

INSERT INTO schema_migrations (version) VALUES ('20150723211858');

INSERT INTO schema_migrations (version) VALUES ('20150723214013');

INSERT INTO schema_migrations (version) VALUES ('20150725204406');

INSERT INTO schema_migrations (version) VALUES ('20150727210534');

INSERT INTO schema_migrations (version) VALUES ('20150727220925');

INSERT INTO schema_migrations (version) VALUES ('20150803204706');

INSERT INTO schema_migrations (version) VALUES ('20150803204834');

INSERT INTO schema_migrations (version) VALUES ('20150803204941');

INSERT INTO schema_migrations (version) VALUES ('20150803205039');

INSERT INTO schema_migrations (version) VALUES ('20150803205132');

INSERT INTO schema_migrations (version) VALUES ('20150803205325');

INSERT INTO schema_migrations (version) VALUES ('20150803222039');

INSERT INTO schema_migrations (version) VALUES ('20150809191522');

INSERT INTO schema_migrations (version) VALUES ('20150809191543');

INSERT INTO schema_migrations (version) VALUES ('20150816124106');

INSERT INTO schema_migrations (version) VALUES ('20150816134732');

INSERT INTO schema_migrations (version) VALUES ('20150816134742');

INSERT INTO schema_migrations (version) VALUES ('20150816135743');

INSERT INTO schema_migrations (version) VALUES ('20150816160035');

INSERT INTO schema_migrations (version) VALUES ('20150816175344');

INSERT INTO schema_migrations (version) VALUES ('20150819215639');

INSERT INTO schema_migrations (version) VALUES ('20150820225119');

INSERT INTO schema_migrations (version) VALUES ('20150820225904');

INSERT INTO schema_migrations (version) VALUES ('20150827002028');

INSERT INTO schema_migrations (version) VALUES ('20150827204951');

INSERT INTO schema_migrations (version) VALUES ('20150830235017');

INSERT INTO schema_migrations (version) VALUES ('20150901201009');

INSERT INTO schema_migrations (version) VALUES ('20150903015059');

INSERT INTO schema_migrations (version) VALUES ('20150903015130');

INSERT INTO schema_migrations (version) VALUES ('20150903172634');

INSERT INTO schema_migrations (version) VALUES ('20150908230656');

INSERT INTO schema_migrations (version) VALUES ('20150909002305');

INSERT INTO schema_migrations (version) VALUES ('20150912024741');

INSERT INTO schema_migrations (version) VALUES ('20150912024811');

INSERT INTO schema_migrations (version) VALUES ('20150912024838');

INSERT INTO schema_migrations (version) VALUES ('20150912024857');

INSERT INTO schema_migrations (version) VALUES ('20150912030224');

INSERT INTO schema_migrations (version) VALUES ('20150912030534');

INSERT INTO schema_migrations (version) VALUES ('20150920164553');

INSERT INTO schema_migrations (version) VALUES ('20150920164605');

INSERT INTO schema_migrations (version) VALUES ('20150923113358');

INSERT INTO schema_migrations (version) VALUES ('20150923200341');

INSERT INTO schema_migrations (version) VALUES ('20150923202218');

INSERT INTO schema_migrations (version) VALUES ('20150927181704');

INSERT INTO schema_migrations (version) VALUES ('20150930155334');

INSERT INTO schema_migrations (version) VALUES ('20150930171941');

INSERT INTO schema_migrations (version) VALUES ('20150930204152');

INSERT INTO schema_migrations (version) VALUES ('20151001203230');

INSERT INTO schema_migrations (version) VALUES ('20151003193903');

INSERT INTO schema_migrations (version) VALUES ('20151004003554');

INSERT INTO schema_migrations (version) VALUES ('20151004014044');

INSERT INTO schema_migrations (version) VALUES ('20151005181505');

INSERT INTO schema_migrations (version) VALUES ('20151005182831');

INSERT INTO schema_migrations (version) VALUES ('20151005183045');

INSERT INTO schema_migrations (version) VALUES ('20151005224540');

INSERT INTO schema_migrations (version) VALUES ('20151006161921');

INSERT INTO schema_migrations (version) VALUES ('20151006163222');

INSERT INTO schema_migrations (version) VALUES ('20151006163542');

INSERT INTO schema_migrations (version) VALUES ('20151007205225');

INSERT INTO schema_migrations (version) VALUES ('20151007205552');

INSERT INTO schema_migrations (version) VALUES ('20151008150322');

INSERT INTO schema_migrations (version) VALUES ('20151019224633');

INSERT INTO schema_migrations (version) VALUES ('20151024032203');

