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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130301031746) do

  create_table "barcodes", :force => true do |t|
    t.string  "barcode"
    t.integer "barcode_set", :default => 0
  end

  add_index "barcodes", ["barcode"], :name => "index_barcodes_on_barcode", :unique => true
  add_index "barcodes", ["barcode_set"], :name => "index_barcodes_on_barcode_set"

  create_table "container_types", :force => true do |t|
    t.integer  "type_id"
    t.string   "name"
    t.integer  "x_dimension"
    t.integer  "y_dimension"
    t.string   "x_coord_labels"
    t.string   "y_coord_labels"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "container_types", ["type_id"], :name => "index_container_types_on_type_id"

  create_table "containers", :force => true do |t|
    t.string   "barcode",                              :null => false
    t.integer  "container_type_id"
    t.string   "ancestry",                             :null => false
    t.integer  "ancestry_depth",    :default => 0
    t.integer  "x",                 :default => 0
    t.integer  "y",                 :default => 0
    t.boolean  "retired",           :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "containers", ["ancestry"], :name => "index_containers_on_ancestry"
  add_index "containers", ["barcode"], :name => "index_containers_on_barcode", :unique => true
  add_index "containers", ["container_type_id"], :name => "index_containers_on_container_type_id"

  create_table "identities", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "identities", ["email"], :name => "index_identities_on_email"
  add_index "identities", ["name"], :name => "index_identities_on_name"

  create_table "ontologies", :force => true do |t|
    t.string "name",        :null => false
    t.string "description"
    t.string "uri",         :null => false
    t.string "prefix",      :null => false
  end

  add_index "ontologies", ["name"], :name => "index_ontologies_on_name"
  add_index "ontologies", ["prefix"], :name => "index_ontologies_on_prefix"
  add_index "ontologies", ["uri"], :name => "index_ontologies_on_uri"

  create_table "ontology_terms", :force => true do |t|
    t.integer "ontology_id",                    :null => false
    t.string  "accession",                      :null => false
    t.string  "name",                           :null => false
    t.string  "definition"
    t.boolean "obsolete",    :default => false
  end

  add_index "ontology_terms", ["accession"], :name => "index_ontology_terms_on_accession"
  add_index "ontology_terms", ["name"], :name => "index_ontology_terms_on_name"
  add_index "ontology_terms", ["ontology_id"], :name => "index_ontology_terms_on_ontology_id"

  create_table "protocol_applications", :force => true do |t|
    t.integer  "protocol_id"
    t.integer  "operator_id"
    t.date     "procedure_date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "protocol_applications", ["operator_id"], :name => "index_protocol_applications_on_operator_id"
  add_index "protocol_applications", ["protocol_id"], :name => "index_protocol_applications_on_protocol_id"

  create_table "protocol_parameter_values", :force => true do |t|
    t.integer  "protocol_application_id"
    t.integer  "protocol_parameter_id"
    t.string   "value"
    t.string   "unit"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "protocol_parameter_values", ["protocol_application_id"], :name => "index_protocol_parameter_values_on_protocol_application_id"
  add_index "protocol_parameter_values", ["protocol_parameter_id"], :name => "index_protocol_parameter_values_on_protocol_parameter_id"

  create_table "protocol_parameters", :force => true do |t|
    t.integer  "protocol_id"
    t.string   "name"
    t.string   "description"
    t.string   "default_value"
    t.integer  "unit_type_id"
    t.string   "unit"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "protocol_parameters", ["protocol_id"], :name => "index_protocol_parameters_on_protocol_id"
  add_index "protocol_parameters", ["unit_type_id"], :name => "index_protocol_parameters_on_unit_type_id"

  create_table "protocols", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "accession"
    t.string   "uri"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sample_characteristics", :force => true do |t|
    t.integer  "ontology_term_id"
    t.string   "name"
    t.string   "value"
    t.integer  "unit_type_id"
    t.string   "unit"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "sample_characteristics", ["ontology_term_id"], :name => "index_sample_characteristics_on_ontology_term_id"
  add_index "sample_characteristics", ["unit_type_id"], :name => "index_sample_characteristics_on_unit_type_id"

  create_table "samples", :force => true do |t|
    t.string   "name"
    t.integer  "container_id"
    t.integer  "protocol_application_id"
    t.string   "ancestry"
    t.integer  "ancestry_depth",          :default => 0
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "samples", ["ancestry"], :name => "index_samples_on_ancestry"
  add_index "samples", ["container_id"], :name => "index_samples_on_container_id"
  add_index "samples", ["name"], :name => "index_samples_on_name"
  add_index "samples", ["protocol_application_id"], :name => "index_samples_on_protocol_application_id"

  create_table "taxon_names", :force => true do |t|
    t.integer "taxon_id"
    t.string  "name"
    t.string  "uniq_name"
    t.string  "name_class"
  end

  add_index "taxon_names", ["name", "uniq_name"], :name => "index_taxon_names_on_name_and_uniq_name"
  add_index "taxon_names", ["taxon_id"], :name => "index_taxon_names_on_taxon_id"

  create_table "taxons", :force => true do |t|
    t.integer "ncbi_id"
    t.integer "parent_ncbi_id"
    t.string  "rank"
    t.string  "ancestry"
    t.integer "ancestry_depth"
  end

  add_index "taxons", ["ancestry"], :name => "index_taxons_on_ancestry"
  add_index "taxons", ["ancestry_depth"], :name => "index_taxons_on_ancestry_depth"
  add_index "taxons", ["ncbi_id"], :name => "index_taxons_on_ncbi_id", :unique => true
  add_index "taxons", ["parent_ncbi_id"], :name => "index_taxons_on_parent_ncbi_id"

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
