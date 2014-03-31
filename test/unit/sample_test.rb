# == Schema Information
#
# Table name: samples
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  barcode_string          :string(255)
#  taxon_id                :integer
#  container_id            :integer
#  container_x             :integer          default(0)
#  container_y             :integer          default(0)
#  protocol_application_id :integer
#  tags                    :string(500)
#  notes                   :text
#  retired                 :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  tsv_content             :tsvector
#  source_name             :string(255)
#  study_id                :integer
#  ancestry                :string(500)
#  ancestry_depth          :integer          default(0)
#  sex_id                  :integer
#  material_type_id        :integer
#

require 'test_helper'

class SampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
