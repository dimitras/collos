# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  email      :string(255)      not null
#  provider   :string(255)
#  uid        :string(255)
#  contact_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User <  ActiveRecord::Base
  attr_accessible :email, :name
  belongs_to :contact
  has_many :shipments, class_name: "Shipment", foreign_key: "shipper_id"
  has_many :packages, class_name: "Shipment", foreign_key: "receiver_id"


  @@email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
            format:  { with:  @@email_regex },
            uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def self.from_omniauth(auth)
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    puts auth.to_yaml
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth['uid']
      user.email = auth["info"]["email"]
      user.name = auth["info"]["name"]
    end
  end

  # User status flag
  enum :status, [:pending,:active,:inactive]

end
