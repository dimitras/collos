# == Schema Information
#
# Table name: taxon_names
#
#  id            :integer          not null, primary key
#  taxon_id      :integer
#  ncbi_taxon_id :integer          not null
#  name          :string(255)      not null
#  name_class    :string(255)
#

require 'test_helper'

class TaxonNameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
