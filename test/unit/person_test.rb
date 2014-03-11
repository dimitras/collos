# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  firstname   :string(255)
#  type        :string(255)
#  institution :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email       :string(255)
#  phone       :integer
#  lastname    :string(255)
#  user_id     :integer
#  study_id    :integer
#

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
