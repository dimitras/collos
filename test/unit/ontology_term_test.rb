# == Schema Information
#
# Table name: ontology_terms
#
#  id          :integer          not null, primary key
#  ontology_id :integer          not null
#  accession   :string(255)      not null
#  name        :string(255)      not null
#  definition  :string(255)
#  obsolete    :boolean          default(FALSE)
#

require 'test_helper'

class OntologyTermTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
