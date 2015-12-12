CREATE TABLE "ajustes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "fechaproceso" datetime, "tipo" integer, "indiceant" decimal(20,8), "indiceact" decimal(20,8), "activo" boolean, "user_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "empresa_id" integer);
CREATE TABLE "balance_grals" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "sesion" integer, "em_of_c" varchar, "empresa_id" integer, "oficina_id" integer, "catalogo_id" integer, "ciclo_id" integer, "tlaux1" integer, "codtlaux1" varchar, "tlaux2" integer, "codtlaux2" varchar, "padre_id" integer, "codigo" varchar, "tipo" varchar(3), "numnivel" integer, "naturaleza" varchar(2), "estransaccional" boolean, "debe" decimal(20,8), "haber" decimal(20,8), "saldo" decimal(20,8), "saldob" decimal(20,8), "saldoc" decimal(20,8), "debeb" decimal(20,8), "haberb" decimal(20,8), "debec" decimal(20,8), "haberc" decimal(20,8), "debed" decimal(20,8), "haberd" decimal(20,8), "debesec" decimal(20,8), "habersec" decimal(20,8), "saldosec" decimal(20,8), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE c(cod text, des text, niv integer, codp text, nat text);
CREATE TABLE "cargos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Codigo" varchar, "Nombre" varchar, "Activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "catalogos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "padre" integer, "estransaccional" boolean, "esflujodeejec" boolean, "usalaux1" boolean, "usalaux2" boolean, "tlaux1" varchar, "tlaux2" varchar, "idctaajustetc" integer, "idctaajusteufv" integer, "activo" boolean, "nivel_id" integer, "grupo_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "naturaleza" varchar(2), "padre_id" varchar, "idctaacumajusteufv" integer);
CREATE TABLE "ciclos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "fini" datetime, "ffin" datetime, "activo" boolean, "empresa_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "tipo" varchar(3));
CREATE TABLE "cierre_ciclos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "fechaproceso" datetime, "esoficial" boolean, "iddiariocierre" integer, "activo" boolean, "ciclo_id" integer, "diario_id" integer, "user_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "desc" varchar, "empresa_id" integer);
CREATE TABLE "cierres" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "fechaproceso" datetime, "tipo" integer, "desc" varchar, "activo" boolean, "user_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "empresa_id" integer, "periodo_id" integer);
CREATE TABLE "correlcbtes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nro" integer, "activo" boolean, "tipocomprobante_id" integer, "empresa_id" integer, "periodo_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "diario_id" integer);
CREATE TABLE "cuentabancos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "nrocuenta" varchar, "tipocuenta" varchar(2), "activo" boolean, "moneda_id" integer, "entidad_id" integer, "catalogo_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "diariodets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tlaux1" integer, "codtlaux2" varchar, "tlaux2" integer, "glosa" varchar, "debe" decimal(20,8), "haber" decimal(20,8), "debesec" decimal(20,8), "habersec" decimal(20,8), "tcsec" decimal(20,8), "debeori" decimal(20,8), "haberori" decimal(20,8), "tcori" decimal(20,8), "catalogo_id" integer, "oficina_id" integer, "fondo_id" integer, "moneda_id" integer, "user_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "diario_id" integer, "item" integer, "codtlaux1" varchar, "esdebito" boolean, "monto" decimal(20,8), "ajuste" varchar(2), "libauxdet_id" integer);
CREATE TABLE "diarios" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nrocbte" integer, "fechacbte" datetime, "glosagral" varchar, "esanulado" boolean, "estado" varchar(2), "origenasiento_id" integer, "tipocomprobante_id" integer, "empresa_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "codigo" varchar, "tc" decimal(20,8));
CREATE TABLE "direccions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Zonaurbana" varchar, "Edificio" varchar, "Pisodepof" varchar, "Descripcion" varchar, "Persona_id" integer, "Ubicaciongeografica_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "docidenexts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Codigo" varchar, "Nombre" varchar, "Sigla" varchar, "Activo" boolean, "Dociden_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "docidens" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Codigo" varchar, "Nombre" varchar, "Sigla" varchar, "Formato" varchar, "Activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "empresas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "entidads" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "estado_cuenta_det_saldos_views" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL);
CREATE TABLE "estado_resultados" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "sesion" integer, "em_of_c" varchar, "empresa_id" integer, "oficina_id" integer, "catalogo_id" integer, "tlaux1" integer, "codtlaux1" varchar, "tlaux2" integer, "codtlaux2" varchar, "padre_id" integer, "codigo" varchar, "tipo" varchar(3), "numnivel" integer, "naturaleza" varchar(2), "estransaccional" boolean, "saldo" decimal(20,8), "saldosec" decimal(20,8), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "fondocuentabancos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "activo" boolean, "cuentabanco_id" integer, "fondo_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "fondos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "activo" boolean, "entidad_id" integer, "empresa_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "grupos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nombre" varchar, "esbalance" boolean, "esestresul" boolean, "naturaleza" varchar(2), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "libauxdets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "libauxdetable_id" integer, "libauxdetable_type" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "libroauxiliars" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "categoria" varchar, "descripcion" varchar, "selista" boolean, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "mayor_hists" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tlaux1" integer, "codtlaux1" varchar, "tlaux2" integer, "codtlaux2" varchar, "tipo" varchar(3), "esdebito" boolean, "debe" decimal(20,8), "haber" decimal(20,8), "debesec" decimal(20,8), "habersec" decimal(20,8), "empresa_id" integer, "oficina_id" integer, "catalogo_id" integer, "ciclo_id" integer, "periodo_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "mayors" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "sesion" integer, "em_of_c" varchar, "fechacbte" datetime, "grupo" integer, "catalogo_id" integer, "empresa_id" integer, "oficina_id" integer, "moneda_id" integer, "empresa" varchar, "oficina" varchar, "codigo" varchar, "tipocbte" varchar, "nrocbte" integer, "tlaux1" integer, "codtlaux1" varchar, "tlaux2" integer, "codtlaux2" varchar, "glosa" varchar, "esdebito" boolean, "debe" decimal(20,8), "haber" decimal(20,8), "debesec" decimal(20,8), "habersec" decimal(20,8), "tc" decimal(20,8), "saldo" decimal(20,8), "saldosec" decimal(20,8), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "monedas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "esfuncional" boolean, "esestranjera" boolean, "esufv" boolean, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "nivels" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "numnivel" integer, "nrodigitos" integer, "nrodigitostotal" integer, "esmoneda" boolean, "nrodigitosmoneda" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "nombre" varchar, "estransaccional" boolean, "activo" boolean);
CREATE TABLE "oficinas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Codigo" varchar, "Nombre" varchar, "Sigla" varchar, "Direccion" varchar, "Telefono" varchar, "Correo" varchar, "Activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "origenasientos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "periodos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "fini" datetime, "ffin" datetime, "nro" integer(2), "gestion" varchar(5), "activo" boolean, "empresa_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "ciclo_id" integer);
CREATE TABLE "personas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Codigo" varchar, "Nombres" varchar, "Appaterno" varchar, "Apmaterno" varchar, "Apcasada" varchar, "Di" varchar, "Telefono" varchar, "Correo" varchar, "type" varchar, "Oficina_id" integer, "Cargo_id" integer, "Dociden_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "fechaingreso" datetime, "fechanacimiento" datetime, "genero" boolean, "estadocivil" varchar(2), "tiposociedad_id" integer, "tipoentidad_id" integer, "esjuridica" boolean);
CREATE TABLE "replegals" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "replegalable_id" integer, "replegalable_type" varchar, "persona_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE TABLE "tipocomprobantes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "nombre" varchar, "sigla" varchar, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "tipoentidads" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "sigla" varchar, "nombre" varchar, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "tiposociedads" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "codigo" varchar, "sigla" varchar, "nombre" varchar, "activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "ubicaciongeograficas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "Codigodept" varchar, "Codigoprov" varchar, "Codigoloca" varchar, "Nombredept" varchar, "Nombreprov" varchar, "Nombreloca" varchar, "Activo" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "created_at" datetime, "updated_at" datetime, "username" varchar, "role" varchar, "persona_id" integer);
CREATE VIEW ajuste_ufv_saldos AS
      SELECT (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, Case When d.esdebito = 't' Then SUM(d.debe - d.haber) Else SUM(d.haber - d.debe) End saldo, Case When d.esdebito = 't' Then SUM(d.debesec - d.habersec) Else SUM(d.habersec - d.debesec) End saldosec, d.esdebito FROM (select id from catalogos  where idctaajusteufv >= 1 and  idctaacumajusteufv >=1 and activo = 't') c inner join diariodets d on c.id = d.catalogo_id inner join diarios t on t.id = d.diario_id  and t.tipocomprobante_id <> 5  WHERE t.esanulado='f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, d.esdebito;
CREATE VIEW balance_gral_suma_saldos AS SELECT (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, n.numnivel, c.padre_id, g.naturaleza, SUM(d.debe) debe, SUM(d.haber) haber, SUM(d.debesec) debesec, SUM(d.habersec) habersec, case when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'D' then 'ACT' when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'A' then 'PAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'D' then 'GAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'A'  then 'ING' else 'PAT' end tipo FROM diarios t INNER JOIN diariodets d on t.id = d.diario_id and t.tipocomprobante_id <> 5 INNER JOIN catalogos c on c.id = d.catalogo_id and c.activo = 't' INNER JOIN grupos g on g.id = c.grupo_id inner join nivels n on n.id = c.nivel_id  WHERE t.esanulado = 'f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, esbalance, esestresul, g.naturaleza, n.numnivel, c.padre_id;
CREATE VIEW estado_cuenta_det_saldos AS
      SELECT (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, Case When d.esdebito = 't' Then SUM(d.debe - d.haber) Else SUM(d.haber - d.debe) End saldo, Case When d.esdebito = 't' Then SUM(d.debesec - d.habersec) Else SUM(d.habersec - d.debesec) End saldosec FROM diarios t INNER JOIN diariodets d on t.id = d.diario_id and t.tipocomprobante_id <> 5 WHERE t.esanulado='f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.esdebito, d.tlaux1, d.codtlaux1;
CREATE VIEW mayor_detalles AS
      select (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.id, d.catalogo_id, t.empresa_id, e.sigla as empresa, tc.sigla as tipocbte, t.origenasiento_id, t.nrocbte, t.fechacbte, d.item, c.codigo, d.oficina_id, o.sigla as oficina ,d.debe, d.haber, d.debesec, d.habersec, d.tlaux1, d.codtlaux1, d.tlaux2, d.codtlaux2, t.glosagral, t.tc, d.moneda_id, d.tcsec, d.esdebito from diarios t inner join diariodets d on t.id = d.diario_id and t.tipocomprobante_id <> 5 inner join catalogos c on c.id = d.catalogo_id inner join tipocomprobantes tc on tc.id = t.tipocomprobante_id inner join empresas e on e.id = t.empresa_id inner join oficinas o on o.id = d.oficina_id where t.esanulado = 'f';
CREATE VIEW mayor_saldos AS
      SELECT (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, Case When d.esdebito = 't' Then SUM(d.debe - d.haber) Else SUM(d.haber - d.debe) End saldo, Case When d.esdebito = 't' Then SUM(d.debesec - d.habersec) Else SUM(d.habersec - d.debesec) End saldosec FROM diarios t INNER JOIN diariodets d on t.id = d.diario_id and t.tipocomprobante_id <> 5 WHERE t.esanulado='f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.esdebito;
CREATE VIEW saldo_dets AS
      SELECT (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id,d.tlaux1, d.codtlaux1, t.fechacbte, n.numnivel, c.padre_id, g.naturaleza, SUM(d.debe) debe, SUM(d.haber) haber, SUM(d.debesec) debesec, SUM(d.habersec) habersec, case when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'D' then 'ACT' when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'A' then 'PAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'D' then 'GAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'A'  then 'ING' else 'PAT' end tipo FROM diarios t INNER JOIN diariodets d on t.tipocomprobante_id <> 5 and t.id = d.diario_id INNER JOIN catalogos c on c.id = d.catalogo_id and c.activo = 't' INNER JOIN grupos g on g.id = c.grupo_id inner join nivels n on n.id = c.nivel_id  WHERE t.esanulado = 'f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, d.tlaux1, d.codtlaux1, t.fechacbte, esbalance, esestresul, g.naturaleza, n.numnivel, c.padre_id;
CREATE VIEW suma_saldos AS
      SELECT (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, c.codigo, t.fechacbte, SUM(d.debe) debe, SUM(d.haber) haber, SUM(d.debesec) debesec, SUM(d.habersec) habersec, case when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'D' then 'ACT' when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'A' then 'PAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'D' then 'GAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'A'  then 'ING' end Tipo FROM diarios t INNER JOIN diariodets d on t.id = d.diario_id and t.tipocomprobante_id <> 5 INNER JOIN catalogos c on c.id = d.catalogo_id and c.activo = 't' INNER JOIN grupos g on g.id = c.grupo_id WHERE t.esanulado='f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, esbalance, esestresul, g.naturaleza, c.codigo;
CREATE INDEX "index_ajustes_on_empresa_id" ON "ajustes" ("empresa_id");
CREATE INDEX "index_ajustes_on_user_id" ON "ajustes" ("user_id");
CREATE INDEX "index_catalogos_on_grupo_id" ON "catalogos" ("grupo_id");
CREATE INDEX "index_catalogos_on_nivel_id" ON "catalogos" ("nivel_id");
CREATE INDEX "index_ciclos_on_empresa_id" ON "ciclos" ("empresa_id");
CREATE INDEX "index_cierre_ciclos_on_ciclo_id" ON "cierre_ciclos" ("ciclo_id");
CREATE INDEX "index_cierre_ciclos_on_diario_id" ON "cierre_ciclos" ("diario_id");
CREATE INDEX "index_cierre_ciclos_on_empresa_id" ON "cierre_ciclos" ("empresa_id");
CREATE INDEX "index_cierre_ciclos_on_user_id" ON "cierre_ciclos" ("user_id");
CREATE INDEX "index_cierres_on_empresa_id" ON "cierres" ("empresa_id");
CREATE INDEX "index_cierres_on_periodo_id" ON "cierres" ("periodo_id");
CREATE INDEX "index_cierres_on_user_id" ON "cierres" ("user_id");
CREATE INDEX "index_correlcbtes_on_diario_id" ON "correlcbtes" ("diario_id");
CREATE INDEX "index_correlcbtes_on_empresa_id" ON "correlcbtes" ("empresa_id");
CREATE INDEX "index_correlcbtes_on_periodo_id" ON "correlcbtes" ("periodo_id");
CREATE INDEX "index_correlcbtes_on_tipocomprobante_id" ON "correlcbtes" ("tipocomprobante_id");
CREATE INDEX "index_cuentabancos_on_catalogo_id" ON "cuentabancos" ("catalogo_id");
CREATE INDEX "index_cuentabancos_on_entidad_id" ON "cuentabancos" ("entidad_id");
CREATE INDEX "index_cuentabancos_on_moneda_id" ON "cuentabancos" ("moneda_id");
CREATE INDEX "index_diariodets_on_catalogo_id" ON "diariodets" ("catalogo_id");
CREATE INDEX "index_diariodets_on_diario_id" ON "diariodets" ("diario_id");
CREATE INDEX "index_diariodets_on_fondo_id" ON "diariodets" ("fondo_id");
CREATE INDEX "index_diariodets_on_libauxdet_id" ON "diariodets" ("libauxdet_id");
CREATE INDEX "index_diariodets_on_moneda_id" ON "diariodets" ("moneda_id");
CREATE INDEX "index_diariodets_on_oficina_id" ON "diariodets" ("oficina_id");
CREATE INDEX "index_diariodets_on_user_id" ON "diariodets" ("user_id");
CREATE INDEX "index_diarios_on_empresa_id" ON "diarios" ("empresa_id");
CREATE INDEX "index_diarios_on_origenasiento_id" ON "diarios" ("origenasiento_id");
CREATE INDEX "index_diarios_on_tipocomprobante_id" ON "diarios" ("tipocomprobante_id");
CREATE INDEX "index_direccions_on_Persona_id" ON "direccions" ("Persona_id");
CREATE INDEX "index_direccions_on_Ubicaciongeografica_id" ON "direccions" ("Ubicaciongeografica_id");
CREATE INDEX "index_docidenexts_on_Dociden_id" ON "docidenexts" ("Dociden_id");
CREATE INDEX "index_fondocuentabancos_on_cuentabanco_id" ON "fondocuentabancos" ("cuentabanco_id");
CREATE INDEX "index_fondocuentabancos_on_fondo_id" ON "fondocuentabancos" ("fondo_id");
CREATE INDEX "index_fondos_on_empresa_id" ON "fondos" ("empresa_id");
CREATE INDEX "index_fondos_on_entidad_id" ON "fondos" ("entidad_id");
CREATE INDEX "index_libauxdets_on_libauxdetable_type_and_libauxdetable_id" ON "libauxdets" ("libauxdetable_type", "libauxdetable_id");
CREATE INDEX "index_libauxdets_on_name" ON "libauxdets" ("name");
CREATE INDEX "index_mayor_hists_on_catalogo_id" ON "mayor_hists" ("catalogo_id");
CREATE INDEX "index_mayor_hists_on_ciclo_id" ON "mayor_hists" ("ciclo_id");
CREATE INDEX "index_mayor_hists_on_empresa_id" ON "mayor_hists" ("empresa_id");
CREATE INDEX "index_mayor_hists_on_oficina_id" ON "mayor_hists" ("oficina_id");
CREATE INDEX "index_mayor_hists_on_periodo_id" ON "mayor_hists" ("periodo_id");
CREATE INDEX "index_periodos_on_ciclo_id" ON "periodos" ("ciclo_id");
CREATE INDEX "index_periodos_on_empresa_id" ON "periodos" ("empresa_id");
CREATE INDEX "index_personas_on_Cargo_id" ON "personas" ("Cargo_id");
CREATE INDEX "index_personas_on_Dociden_id" ON "personas" ("Dociden_id");
CREATE INDEX "index_personas_on_Oficina_id" ON "personas" ("Oficina_id");
CREATE INDEX "index_personas_on_tipoentidad_id" ON "personas" ("tipoentidad_id");
CREATE INDEX "index_personas_on_tiposociedad_id" ON "personas" ("tiposociedad_id");
CREATE INDEX "index_replegals_on_codigo" ON "replegals" ("codigo");
CREATE INDEX "index_replegals_on_persona_id" ON "replegals" ("persona_id");
CREATE INDEX "index_replegals_on_replegalable_type_and_replegalable_id" ON "replegals" ("replegalable_type", "replegalable_id");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE INDEX "index_users_on_username" ON "users" ("username");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
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

INSERT INTO schema_migrations (version) VALUES ('20150723215147');

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

INSERT INTO schema_migrations (version) VALUES ('20150902235911');

INSERT INTO schema_migrations (version) VALUES ('20150903015059');

INSERT INTO schema_migrations (version) VALUES ('20150903015130');

INSERT INTO schema_migrations (version) VALUES ('20150903172634');

INSERT INTO schema_migrations (version) VALUES ('20150908230656');

INSERT INTO schema_migrations (version) VALUES ('20150909002305');

INSERT INTO schema_migrations (version) VALUES ('20150911175705');

INSERT INTO schema_migrations (version) VALUES ('20150912024741');

INSERT INTO schema_migrations (version) VALUES ('20150912024811');

INSERT INTO schema_migrations (version) VALUES ('20150912024838');

INSERT INTO schema_migrations (version) VALUES ('20150912024857');

INSERT INTO schema_migrations (version) VALUES ('20150912030224');

INSERT INTO schema_migrations (version) VALUES ('20150912030534');

INSERT INTO schema_migrations (version) VALUES ('20150918173917');

INSERT INTO schema_migrations (version) VALUES ('20150918211025');

INSERT INTO schema_migrations (version) VALUES ('20150918232138');

INSERT INTO schema_migrations (version) VALUES ('20150918232145');

INSERT INTO schema_migrations (version) VALUES ('20150919155454');

INSERT INTO schema_migrations (version) VALUES ('20150920164553');

INSERT INTO schema_migrations (version) VALUES ('20150920164605');

INSERT INTO schema_migrations (version) VALUES ('20150920182955');

INSERT INTO schema_migrations (version) VALUES ('20150920215306');

INSERT INTO schema_migrations (version) VALUES ('20150923113358');

INSERT INTO schema_migrations (version) VALUES ('20150923200341');

INSERT INTO schema_migrations (version) VALUES ('20150923200353');

INSERT INTO schema_migrations (version) VALUES ('20150923202218');

INSERT INTO schema_migrations (version) VALUES ('20150925003521');

INSERT INTO schema_migrations (version) VALUES ('20150925133154');

INSERT INTO schema_migrations (version) VALUES ('20150925134735');

INSERT INTO schema_migrations (version) VALUES ('20150925143526');

INSERT INTO schema_migrations (version) VALUES ('20150927181704');

INSERT INTO schema_migrations (version) VALUES ('20150930155334');

INSERT INTO schema_migrations (version) VALUES ('20150930171941');

INSERT INTO schema_migrations (version) VALUES ('20150930204152');

INSERT INTO schema_migrations (version) VALUES ('20151001203230');

INSERT INTO schema_migrations (version) VALUES ('20151003193903');

INSERT INTO schema_migrations (version) VALUES ('20151004003554');

INSERT INTO schema_migrations (version) VALUES ('20151004014044');

INSERT INTO schema_migrations (version) VALUES ('20151004193927');

INSERT INTO schema_migrations (version) VALUES ('20151005181505');

INSERT INTO schema_migrations (version) VALUES ('20151005182831');

INSERT INTO schema_migrations (version) VALUES ('20151005183045');

INSERT INTO schema_migrations (version) VALUES ('20151005224540');

INSERT INTO schema_migrations (version) VALUES ('20151006161921');

INSERT INTO schema_migrations (version) VALUES ('20151006163222');

INSERT INTO schema_migrations (version) VALUES ('20151006163542');

INSERT INTO schema_migrations (version) VALUES ('20151007020235');

INSERT INTO schema_migrations (version) VALUES ('20151007020650');

INSERT INTO schema_migrations (version) VALUES ('20151007202707');

INSERT INTO schema_migrations (version) VALUES ('20151007202719');

INSERT INTO schema_migrations (version) VALUES ('20151007205225');

INSERT INTO schema_migrations (version) VALUES ('20151007205552');

INSERT INTO schema_migrations (version) VALUES ('20151008150322');

INSERT INTO schema_migrations (version) VALUES ('20151014203609');

INSERT INTO schema_migrations (version) VALUES ('20151019194501');

INSERT INTO schema_migrations (version) VALUES ('20151019224108');

INSERT INTO schema_migrations (version) VALUES ('20151019224633');

INSERT INTO schema_migrations (version) VALUES ('20151020212344');

INSERT INTO schema_migrations (version) VALUES ('20151024032203');

