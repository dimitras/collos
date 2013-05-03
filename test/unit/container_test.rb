# == Schema Information
#
# Table name: containers
#
#  id                :integer          not null, primary key
#  barcode_id        :integer
#  container_type_id :integer
#  ancestry          :string(255)      not null
#  ancestry_depth    :integer          default(0)
#  x                 :integer          default(0)
#  y                 :integer          default(0)
#  retired           :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
