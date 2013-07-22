# == Schema Information
#
# Table name: sample_relationships
#
#  id            :integer          not null, primary key
#  ancestor_id   :integer
#  descendant_id :integer
#  direct        :boolean
#  count         :integer
#

require 'test_helper'

class SampleRelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
