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

class Sample < ActiveRecord::Base
  belongs_to :container
  belongs_to :protocol_application

  attr_accessible :name

  validates :name, presence: true

  has_ancestry :orphan_strategy => :rootify, :cache_depth => true

end
