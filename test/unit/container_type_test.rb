# == Schema Information
#
# Table name: container_types
#
#  id                :integer          not null, primary key
#  type_id           :integer
#  name              :string(255)
#  x_dimension       :integer          default(1)
#  y_dimension       :integer          default(1)
#  x_coord_labels    :string(255)      default("number")
#  y_coord_labels    :string(255)      default("number")
#  can_have_children :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ContainerTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
