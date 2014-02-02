# == Schema Information
#
# Table name: boxes
#
#  id          :integer          not null, primary key
#  label       :string(255)
#  box_type_id :integer
#  freezer_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class BoxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
