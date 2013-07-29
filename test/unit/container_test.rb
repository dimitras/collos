# == Schema Information
#
# Table name: containers
#
#  id                :integer          not null, primary key
#  container_type_id :integer
#  name              :string(255)
#  ancestry          :string(500)
#  ancestry_depth    :integer          default(0)
#  parent_x          :integer          default(0)
#  parent_y          :integer          default(0)
#  retired           :boolean          default(FALSE)
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
