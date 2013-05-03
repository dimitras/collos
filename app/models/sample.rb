# == Schema Information
#
# Table name: samples
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  barcode_id              :integer
#  container_id            :integer
#  taxon_id                :integer
#  protocol_application_id :integer
#  ancestry                :string(255)
#  ancestry_depth          :integer          default(0)
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Sample < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true

  belongs_to :container
  belongs_to :barcode
  belongs_to :protocol_application
  belongs_to :taxon

  has_many :sample_characteristics

  has_ancestry :orphan_strategy => :rootify, :cache_depth => true


end
