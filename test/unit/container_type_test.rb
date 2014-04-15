# == Schema Information
#
# Table name: container_types
#
#  id                           :integer          not null, primary key
#  type_id                      :integer
#  name                         :string(255)
#  x_dimension                  :integer          default(1)
#  y_dimension                  :integer          default(1)
#  can_have_children            :boolean          default(TRUE)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  retired                      :boolean          default(FALSE)
#  label                        :string(255)
#  shipable                     :boolean
#  can_have_external_identifier :boolean          default(FALSE)
#

require 'test_helper'

class ContainerTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
