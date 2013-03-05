# == Schema Information
#
# Table name: sample_characteristics
#
#  id               :integer          not null, primary key
#  ontology_term_id :integer
#  name             :string(255)
#  value            :string(255)
#  unit_type_id     :integer
#  unit             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class SampleCharacteristicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
