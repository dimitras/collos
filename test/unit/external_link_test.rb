# == Schema Information
#
# Table name: external_links
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sample_id  :integer
#

require 'test_helper'

class ExternalLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
