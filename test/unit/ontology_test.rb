# == Schema Information
#
# Table name: ontologies
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  uri         :string(255)      not null
#  prefix      :string(255)      not null
#

require 'test_helper'

class OntologyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
