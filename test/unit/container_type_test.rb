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

require 'test_helper'

class ContainerTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
