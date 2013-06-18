# == Schema Information
#
# Table name: taxons
#
#  id              :integer          not null, primary key
#  parent_taxon_id :integer
#  ncbi_id         :integer          not null
#  parent_ncbi_id  :integer
#  rank            :string(255)
#  scientific_name :string(255)
#  common_name     :string(255)
#

class Taxon < ActiveRecord::Base
  attr_accessible :ancestry, :ancestry_depth, :ncbi_id, :parent_ncbi_id, :rank,
    :scientific_name, :common_name

  has_many :samples
  has_many :taxon_names
  belongs_to :parent, :class_name => "Taxon", :foreign_key => "parent_taxon_id"


end
