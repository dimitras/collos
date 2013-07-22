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

ActiveRecord::Schema.define(:version => 20130722131646) do

  create_table "addresses", :force => true do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "line_3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "province"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "barcodes", :force => true do |t|
    t.string  "barcode"
    t.integer "barcode_set",      :default => 0
    t.integer "barcodeable_id"
    t.string  "barcodeable_type"
  end

  add_index "barcodes", ["barcode"], :name => "index_barcodes_on_barcode", :unique => true
  add_index "barcodes", ["barcode_set"], :name => "index_barcodes_on_barcode_set"
  add_index "barcodes", ["barcodeable_type", "barcodeable_id"], :name => "index_barcodes_on_barcodeable_type_and_barcodeable_id"

  create_table "contacts", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.integer  "address_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contacts", ["address_id"], :name => "index_contacts_on_address_id"

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
    t.integer  "container_type_id"
    t.string   "name"
    t.string   "ancestry"
    t.integer  "ancestry_depth",    :default => 0
    t.integer  "container_x",       :default => 0
    t.integer  "container_y",       :default => 0
    t.boolean  "retired",           :default => false
    t.text     "notes"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "containers", ["ancestry"], :name => "index_containers_on_ancestry"
  add_index "containers", ["container_type_id"], :name => "index_containers_on_container_type_id"

  create_table "containers_shipments", :id => false, :force => true do |t|
    t.integer "container_id"
    t.integer "shipment_id"
  end

  add_index "containers_shipments", ["container_id"], :name => "index_containers_shipments_on_container_id"
  add_index "containers_shipments", ["shipment_id"], :name => "index_containers_shipments_on_shipment_id"

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "uid",          :null => false
    t.string   "secret",       :null => false
    t.string   "redirect_uri", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "ontologies", :force => true do |t|
    t.string "name",        :null => false
    t.string "release"
    t.string "description"
    t.string "uri",         :null => false
    t.string "prefix",      :null => false
  end

  add_index "ontologies", ["name"], :name => "index_ontologies_on_name"
  add_index "ontologies", ["prefix"], :name => "index_ontologies_on_prefix"
  add_index "ontologies", ["uri"], :name => "index_ontologies_on_uri"

  create_table "ontology_terms", :force => true do |t|
    t.integer "ontology_id",                       :null => false
    t.string  "accession",                         :null => false
    t.string  "name",                              :null => false
    t.string  "definition"
    t.string  "ancestry"
    t.integer "ancestry_depth", :default => 0
    t.boolean "obsolete",       :default => false
  end

  add_index "ontology_terms", ["accession"], :name => "index_ontology_terms_on_accession"
  add_index "ontology_terms", ["ancestry"], :name => "index_ontology_terms_on_ancestry"
  add_index "ontology_terms", ["name"], :name => "index_ontology_terms_on_name"
  add_index "ontology_terms", ["ontology_id"], :name => "index_ontology_terms_on_ontology_id"

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

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
    t.integer  "protocol_type_id"
    t.string   "name"
    t.string   "description"
    t.string   "accession"
    t.string   "uri"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "protocols", ["accession"], :name => "index_protocols_on_accession"
  add_index "protocols", ["name"], :name => "index_protocols_on_name"
  add_index "protocols", ["protocol_type_id"], :name => "index_protocols_on_protocol_type_id"

  create_table "sample_characteristics", :force => true do |t|
    t.integer  "sample_id"
    t.integer  "ontology_term_id"
    t.string   "name"
    t.string   "value"
    t.integer  "unit_type_id"
    t.string   "unit"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "sample_characteristics", ["ontology_term_id"], :name => "index_sample_characteristics_on_ontology_term_id"
  add_index "sample_characteristics", ["sample_id"], :name => "index_sample_characteristics_on_sample_id"
  add_index "sample_characteristics", ["unit_type_id"], :name => "index_sample_characteristics_on_unit_type_id"

  create_table "sample_relationships", :force => true do |t|
    t.integer "ancestor_id"
    t.integer "descendant_id"
    t.boolean "direct"
    t.integer "count"
  end

  create_table "samples", :force => true do |t|
    t.string   "name"
    t.integer  "taxon_id"
    t.integer  "container_id"
    t.integer  "container_x"
    t.integer  "container_y"
    t.integer  "protocol_application_id"
    t.string   "ancestry"
    t.integer  "ancestry_depth",          :default => 0
    t.text     "notes"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "samples", ["ancestry"], :name => "index_samples_on_ancestry"
  add_index "samples", ["container_id"], :name => "index_samples_on_container_id"
  add_index "samples", ["name"], :name => "index_samples_on_name"
  add_index "samples", ["protocol_application_id"], :name => "index_samples_on_protocol_application_id"
  add_index "samples", ["taxon_id"], :name => "index_samples_on_taxon_id"

  create_table "shipments", :force => true do |t|
    t.string   "tracking_number"
    t.integer  "shipper_id"
    t.integer  "receiver_id"
    t.datetime "ship_date"
    t.datetime "recieve_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "shipments", ["receiver_id"], :name => "index_shipments_on_receiver_id"
  add_index "shipments", ["shipper_id"], :name => "index_shipments_on_shipper_id"
  add_index "shipments", ["tracking_number"], :name => "index_shipments_on_tracking_number"

  create_table "taxons", :force => true do |t|
    t.integer "ncbi_id",         :null => false
    t.string  "scientific_name"
    t.string  "common_name"
  end

  add_index "taxons", ["common_name"], :name => "index_taxons_on_common_name"
  add_index "taxons", ["ncbi_id"], :name => "index_taxons_on_ncbi_id", :unique => true
  add_index "taxons", ["scientific_name"], :name => "index_taxons_on_scientific_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "email",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.integer  "contact_id"
    t.boolean  "admin",      :default => false
    t.string   "status",     :default => "pending"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "users", ["contact_id"], :name => "index_users_on_contact_id"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"
  add_index "users", ["status"], :name => "index_users_on_status"

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
