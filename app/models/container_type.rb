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
  belongs_to :type, class_name: "OntologyTerm", foreign_key: "type_id"
  attr_accessible :name, :x_coord_labels, :x_dimension, :y_coord_labels, :y_dimension
end
