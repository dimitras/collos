# == Schema Information
#
# Table name: studies
#
#  id          :integer          not null, primary key
#  title       :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identifier  :string(255)
#  description :text
#

require 'test_helper'

class StudyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
