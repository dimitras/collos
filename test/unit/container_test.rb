# == Schema Information
#
# Table name: containers
#
#  id                :integer          not null, primary key
#  container_type_id :integer
#  label             :string(255)
#  barcode_string    :string(255)
#  ancestry          :string(500)
#  ancestry_depth    :integer          default(0)
#  container_x       :integer          default(0)
#  container_y       :integer          default(0)
#  retired           :boolean          default(FALSE)
#  tags              :string(500)
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  tsv_content       :tsvector
#  ancestry_id       :integer
#

require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
