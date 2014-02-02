# == Schema Information
#
# Table name: container_types
#
#  id                :integer          not null, primary key
#  type_id           :integer
#  name              :string(255)
#  x_dimension       :integer          default(1)
#  y_dimension       :integer          default(1)
#  can_have_children :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  retired           :boolean          default(FALSE)
#  label             :string(255)
#

class ContainerType < ActiveRecord::Base
    attr_accessible :name, :type, :type_id,
        :x_dimension, :parent_x,
        :y_dimension, :parent_y,
        :can_have_children, :retired, :name

    belongs_to :type, class_name: "OntologyTerm", foreign_key: "type_id"
    has_many :containers, inverse_of: :container_types

    def container_type_terms
        OntologyTerm.where(
            name: "container",
            accession: "obo:OBI_0000967"
        ).first.children()
    end

    def to_s
        name
    end

    def self.label_options
        [%w[number number],%w[letter letter]]
    end
    def label_options
        ContainerType.label_options
    end
end
