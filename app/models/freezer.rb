# == Schema Information
#
# Table name: freezers
#
#  id              :integer          not null, primary key
#  label           :string(255)
#  freezer_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Freezer < ActiveRecord::Base
  attr_accessible :freezer_type_id, :label

   belongs_to :freezer_type
end
