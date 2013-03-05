# == Schema Information
#
# Table name: taxons
#
#  id             :integer          not null, primary key
#  ncbi_id        :integer
#  parent_ncbi_id :integer
#  rank           :string(255)
#  ancestry       :string(255)
#  ancestry_depth :integer
#

require 'test_helper'

class TaxonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
