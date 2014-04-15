# == Schema Information
#
# Table name: material_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tsv_content :tsvector
#

require 'test_helper'

class MaterialTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
