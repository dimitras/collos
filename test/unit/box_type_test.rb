# == Schema Information
#
# Table name: box_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  dimension_x :integer
#  dimension_y :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class BoxTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
