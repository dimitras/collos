# == Schema Information
#
# Table name: taxon_names
#
#  id            :integer          not null, primary key
#  taxon_id      :integer
#  ncbi_taxon_id :integer          not null
#  name          :string(255)      not null
#  name_class    :string(255)
#

class TaxonName < ActiveRecord::Base
  belongs_to :taxon
  attr_accessible :name, :name_class, :uniq_name
end
