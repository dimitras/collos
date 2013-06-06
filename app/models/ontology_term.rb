# == Schema Information
#
# Table name: ontology_terms
#
#  id          :integer          not null, primary key
#  ontology_id :integer          not null
#  accession   :string(255)      not null
#  name        :string(255)      not null
#  definition  :string(255)
#  obsolete    :boolean          default(FALSE)
#

class OntologyTerm < ActiveRecord::Base
    belongs_to :ontology, inverse_of: :ontology_terms

    attr_accessible :accession, :definition, :name, :obsolete, :ontology_id, :ontology

    validates :ontology_id, :presence => true
    validates :accession, :presence => true
    validates :name, :presence => true

    def pretty_string
        "[#{ontology.prefix}:#{accession}] #{name}"
    end
    def self.from_pretty_string(term)
        # "[#{type.ontology.prefix}:#{type.accession}] #{type.name}"
        term =~ /\[(\w+)\:(\w+)\]\s(.+)/
        prf = $1
        acc = $2
        tn = $3
        OntologyTerm.where("ontology_terms.name like ? and ontology_terms.accession like ? ",tn, acc).joins(:ontology).where("ontologies.prefix = ?", prf)
    end
end
