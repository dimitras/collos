# == Schema Information
#
# Table name: taxons
#
#  id              :integer          not null, primary key
#  ncbi_id         :integer          not null
#  scientific_name :string(255)
#  common_name     :string(255)
#

require 'test_helper'

class TaxonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
