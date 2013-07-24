# == Schema Information
#
# Table name: samples
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  taxon_id                :integer
#  container_id            :integer
#  container_x             :integer
#  container_y             :integer
#  protocol_application_id :integer
#  ancestry                :string(500)
#  ancestry_depth          :integer          default(0)
#  tags                    :string(500)
#  notes                   :text
#  retired                 :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class SampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
