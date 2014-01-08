# == Schema Information
#
# Table name: experiments
#
#  id         :integer          not null, primary key
#  name       :text
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  study_id   :integer
#

require 'test_helper'

class ExperimentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
