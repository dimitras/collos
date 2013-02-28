class ContainerType < ActiveRecord::Base
  belongs_to :type
  attr_accessible :name, :x_coord_labels, :x_dimension, :y_coord_labels, :y_dimension
end
