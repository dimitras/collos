# == Schema Information
#
# Table name: taxons
#
#  id              :integer          not null, primary key
#  parent_taxon_id :integer
#  ncbi_id         :integer          not null
#  parent_ncbi_id  :integer
#  rank            :string(255)
#

require 'test_helper'

class TaxonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
