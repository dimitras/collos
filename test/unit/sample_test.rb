# == Schema Information
#
# Table name: samples
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  container_id            :integer
#  protocol_application_id :integer
#  ancestry                :string(255)
#  ancestry_depth          :integer          default(0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class SampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
