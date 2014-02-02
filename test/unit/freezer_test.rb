# == Schema Information
#
# Table name: freezers
#
#  id              :integer          not null, primary key
#  label           :string(255)
#  freezer_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class FreezerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
