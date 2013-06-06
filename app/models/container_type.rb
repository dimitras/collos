# == Schema Information
#
# Table name: container_types
#
#  id             :integer          not null, primary key
#  type_id        :integer
#  name           :string(255)
#  x_dimension    :integer
#  y_dimension    :integer
#  x_coord_labels :string(255)
#  y_coord_labels :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ContainerType < ActiveRecord::Base
    attr_accessible :name, :x_coord_labels, :x_dimension, :y_coord_labels, :y_dimension

    belongs_to :type, class_name: "OntologyTerm", foreign_key: "type_id"
    has_many :containers, inverse_of: :container_types

    def type_term
        type.pretty_string
    end

    def type_term=(term)
        self.type = OntologyTerm.from_pretty_string(term)
    end
end
