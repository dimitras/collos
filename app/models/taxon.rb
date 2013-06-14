# == Schema Information
#
# Table name: taxons
#
#  id              :integer          not null, primary key
#  parent_taxon_id :integer
#  ncbi_id         :integer          not null
#  parent_ncbi_id  :integer
#  rank            :string(255)
#

class Taxon < ActiveRecord::Base
  attr_accessible :ancestry, :ancestry_depth, :ncbi_id, :parent_ncbi_id, :rank

  has_many :samples
  has_many :taxon_names
  belongs_to :parent, :class_name => "Taxon", :foreign_key => "parent_taxon_id"

  def scientific_name
    taxon_names.where(:name_class => 'scientific name').first.name
  end

  def common_name
    taxon_names.where(:name_class => 'genbank common name').first.name
  end

end
