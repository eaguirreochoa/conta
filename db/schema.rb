# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150918173917) do

  create_table "cargos", force: :cascade do |t|
    t.string   "Codigo"
    t.string   "Nombre"
    t.boolean  "Activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalogos", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.integer  "padre"
    t.boolean  "estransaccional"
    t.boolean  "esflujodeejec"
    t.boolean  "usalaux1"
    t.boolean  "usalaux2"
    t.string   "tlaux1"
    t.string   "tlaux2"
    t.integer  "idctaajustetc"
    t.integer  "idctaajusteufv"
    t.boolean  "activo"
    t.integer  "nivel_id"
    t.integer  "grupo_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "naturaleza",      limit: 2
    t.string   "padre_id"
  end

  add_index "catalogos", ["grupo_id"], name: "index_catalogos_on_grupo_id"
  add_index "catalogos", ["nivel_id"], name: "index_catalogos_on_nivel_id"

  create_table "correlcbtes", force: :cascade do |t|
    t.integer  "nro"
    t.boolean  "activo"
    t.integer  "tipocomprobante_id"
    t.integer  "empresa_id"
    t.integer  "periodo_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "diario_id"
  end

  add_index "correlcbtes", ["diario_id"], name: "index_correlcbtes_on_diario_id"
  add_index "correlcbtes", ["empresa_id"], name: "index_correlcbtes_on_empresa_id"
  add_index "correlcbtes", ["periodo_id"], name: "index_correlcbtes_on_periodo_id"
  add_index "correlcbtes", ["tipocomprobante_id"], name: "index_correlcbtes_on_tipocomprobante_id"

  create_table "cuentabancos", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.string   "nrocuenta"
    t.string   "tipocuenta",  limit: 2
    t.boolean  "activo"
    t.integer  "moneda_id"
    t.integer  "entidad_id"
    t.integer  "catalogo_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "cuentabancos", ["catalogo_id"], name: "index_cuentabancos_on_catalogo_id"
  add_index "cuentabancos", ["entidad_id"], name: "index_cuentabancos_on_entidad_id"
  add_index "cuentabancos", ["moneda_id"], name: "index_cuentabancos_on_moneda_id"

  create_table "diariodets", force: :cascade do |t|
    t.integer  "tlaux1"
    t.string   "codtlaux2"
    t.integer  "tlaux2"
    t.string   "glosa"
    t.decimal  "debe",                   precision: 20, scale: 8
    t.decimal  "haber",                  precision: 20, scale: 8
    t.decimal  "debesec",                precision: 20, scale: 8
    t.decimal  "habersec",               precision: 20, scale: 8
    t.decimal  "tcsec",                  precision: 20, scale: 8
    t.decimal  "debeori",                precision: 20, scale: 8
    t.decimal  "haberori",               precision: 20, scale: 8
    t.decimal  "tcori",                  precision: 20, scale: 8
    t.integer  "catalogo_id"
    t.integer  "oficina_id"
    t.integer  "fondo_id"
    t.integer  "moneda_id"
    t.integer  "user_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "diario_id"
    t.integer  "item"
    t.string   "codtlaux1"
    t.boolean  "esdebito"
    t.decimal  "monto",                  precision: 20, scale: 8
    t.string   "ajuste",       limit: 2
    t.integer  "libauxdet_id"
  end

  add_index "diariodets", ["catalogo_id"], name: "index_diariodets_on_catalogo_id"
  add_index "diariodets", ["diario_id"], name: "index_diariodets_on_diario_id"
  add_index "diariodets", ["fondo_id"], name: "index_diariodets_on_fondo_id"
  add_index "diariodets", ["libauxdet_id"], name: "index_diariodets_on_libauxdet_id"
  add_index "diariodets", ["moneda_id"], name: "index_diariodets_on_moneda_id"
  add_index "diariodets", ["oficina_id"], name: "index_diariodets_on_oficina_id"
  add_index "diariodets", ["user_id"], name: "index_diariodets_on_user_id"

  create_table "diarios", force: :cascade do |t|
    t.integer  "nrocbte"
    t.datetime "fechacbte"
    t.string   "glosagral"
    t.boolean  "esanulado"
    t.string   "estado",             limit: 2
    t.integer  "origenasiento_id"
    t.integer  "tipocomprobante_id"
    t.integer  "empresa_id"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "codigo"
    t.decimal  "tc",                           precision: 20, scale: 8
  end

  add_index "diarios", ["empresa_id"], name: "index_diarios_on_empresa_id"
  add_index "diarios", ["origenasiento_id"], name: "index_diarios_on_origenasiento_id"
  add_index "diarios", ["tipocomprobante_id"], name: "index_diarios_on_tipocomprobante_id"

  create_table "direccions", force: :cascade do |t|
    t.string   "Zonaurbana"
    t.string   "Edificio"
    t.string   "Pisodepof"
    t.string   "Descripcion"
    t.integer  "Persona_id"
    t.integer  "Ubicaciongeografica_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "direccions", ["Persona_id"], name: "index_direccions_on_Persona_id"
  add_index "direccions", ["Ubicaciongeografica_id"], name: "index_direccions_on_Ubicaciongeografica_id"

  create_table "docidenexts", force: :cascade do |t|
    t.string   "Codigo"
    t.string   "Nombre"
    t.string   "Sigla"
    t.boolean  "Activo"
    t.integer  "Dociden_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "docidenexts", ["Dociden_id"], name: "index_docidenexts_on_Dociden_id"

  create_table "docidens", force: :cascade do |t|
    t.string   "Codigo"
    t.string   "Nombre"
    t.string   "Sigla"
    t.string   "Formato"
    t.boolean  "Activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "empresas", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.boolean  "activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entidads", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.boolean  "activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fondocuentabancos", force: :cascade do |t|
    t.boolean  "activo"
    t.integer  "cuentabanco_id"
    t.integer  "fondo_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "fondocuentabancos", ["cuentabanco_id"], name: "index_fondocuentabancos_on_cuentabanco_id"
  add_index "fondocuentabancos", ["fondo_id"], name: "index_fondocuentabancos_on_fondo_id"

  create_table "fondos", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.boolean  "activo"
    t.integer  "entidad_id"
    t.integer  "empresa_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fondos", ["empresa_id"], name: "index_fondos_on_empresa_id"
  add_index "fondos", ["entidad_id"], name: "index_fondos_on_entidad_id"

  create_table "grupos", force: :cascade do |t|
    t.string   "nombre"
    t.boolean  "esbalance"
    t.boolean  "esestresul"
    t.string   "naturaleza", limit: 2
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "libauxdets", force: :cascade do |t|
    t.string   "name"
    t.integer  "libauxdetable_id"
    t.string   "libauxdetable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "libauxdets", ["libauxdetable_type", "libauxdetable_id"], name: "index_libauxdets_on_libauxdetable_type_and_libauxdetable_id"
  add_index "libauxdets", ["name"], name: "index_libauxdets_on_name"

  create_table "libroauxiliars", force: :cascade do |t|
    t.string   "categoria"
    t.string   "descripcion"
    t.boolean  "selista"
    t.boolean  "activo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "monedas", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.boolean  "esfuncional"
    t.boolean  "esestranjera"
    t.boolean  "esufv"
    t.boolean  "activo"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "nivels", force: :cascade do |t|
    t.integer  "numnivel"
    t.integer  "nrodigitos"
    t.integer  "nrodigitostotal"
    t.boolean  "esmoneda"
    t.integer  "nrodigitosmoneda"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "nombre"
    t.boolean  "estransaccional"
    t.boolean  "activo"
  end

  create_table "oficinas", force: :cascade do |t|
    t.string   "Codigo"
    t.string   "Nombre"
    t.string   "Sigla"
    t.string   "Direccion"
    t.string   "Telefono"
    t.string   "Correo"
    t.boolean  "Activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "origenasientos", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.boolean  "activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periodos", force: :cascade do |t|
    t.datetime "fini"
    t.datetime "ffin"
    t.string   "nro",        limit: 2
    t.string   "gestion",    limit: 5
    t.boolean  "activo"
    t.integer  "empresa_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "periodos", ["empresa_id"], name: "index_periodos_on_empresa_id"

  create_table "personas", force: :cascade do |t|
    t.string   "Codigo"
    t.string   "Nombres"
    t.string   "Appaterno"
    t.string   "Apmaterno"
    t.string   "Apcasada"
    t.string   "Di"
    t.string   "Telefono"
    t.string   "Correo"
    t.string   "type"
    t.integer  "Oficina_id"
    t.integer  "Cargo_id"
    t.integer  "Dociden_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "fechaingreso"
    t.datetime "fechanacimiento"
    t.boolean  "genero"
    t.string   "estadocivil",     limit: 2
    t.integer  "tiposociedad_id"
    t.integer  "tipoentidad_id"
    t.boolean  "esjuridica"
  end

  add_index "personas", ["Cargo_id"], name: "index_personas_on_Cargo_id"
  add_index "personas", ["Dociden_id"], name: "index_personas_on_Dociden_id"
  add_index "personas", ["Oficina_id"], name: "index_personas_on_Oficina_id"
  add_index "personas", ["tipoentidad_id"], name: "index_personas_on_tipoentidad_id"
  add_index "personas", ["tiposociedad_id"], name: "index_personas_on_tiposociedad_id"

  create_table "replegals", force: :cascade do |t|
    t.string   "codigo"
    t.integer  "replegalable_id"
    t.string   "replegalable_type"
    t.integer  "persona_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "replegals", ["codigo"], name: "index_replegals_on_codigo"
  add_index "replegals", ["persona_id"], name: "index_replegals_on_persona_id"
  add_index "replegals", ["replegalable_type", "replegalable_id"], name: "index_replegals_on_replegalable_type_and_replegalable_id"

# Could not dump table "saldo_mayor" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "tipocomprobantes", force: :cascade do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.string   "sigla"
    t.boolean  "activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipoentidads", force: :cascade do |t|
    t.string   "codigo"
    t.string   "sigla"
    t.string   "nombre"
    t.boolean  "activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiposociedads", force: :cascade do |t|
    t.string   "codigo"
    t.string   "sigla"
    t.string   "nombre"
    t.boolean  "activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ubicaciongeograficas", force: :cascade do |t|
    t.string   "Codigodept"
    t.string   "Codigoprov"
    t.string   "Codigoloca"
    t.string   "Nombredept"
    t.string   "Nombreprov"
    t.string   "Nombreloca"
    t.boolean  "Activo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "role"
    t.integer  "persona_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username"

end
