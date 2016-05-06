# == Schema Information
#
# Table name: external_links
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sample_id  :integer
#

class ExternalLink < ActiveRecord::Base
	attr_accessible :name, :url, :sample_id

	belongs_to :sample
end
