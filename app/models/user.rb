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

class User <  OmniAuth::Identity::Models::ActiveRecord
  attr_accessible :email, :name, :password, :password_confirmation

  belongs_to :contact

  @@email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence   => true,
            :format     => { :with => @@email_regex },
            :uniqueness => { :case_sensitive => false }

  def self.from_omniauth(auth)
    user = User.find_by_provider_and_email(auth["provider"], auth["email"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth['email']
      user.email = auth["info"]["email"]
      user.name = auth["info"]["name"]
    end
  end
end
