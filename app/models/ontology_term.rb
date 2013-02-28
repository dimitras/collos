class OntologyTerm < ActiveRecord::Base
  belongs_to :ontology
  attr_accessible :accession, :definition, :name, :obsolete
  validates :ontology_id, :presence => true
  validates :accession, :presence => true
  validates :name, :presence => true
end
