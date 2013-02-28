class TaxonName < ActiveRecord::Base
  belongs_to :taxon
  attr_accessible :name, :name_class, :uniq_name
end
