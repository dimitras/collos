# == Schema Information
#
# Table name: ontologies
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  release     :string(255)
#  description :string(500)
#  uri         :string(255)      not null
#  prefix      :string(255)      not null
#

require 'test_helper'

class OntologyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
