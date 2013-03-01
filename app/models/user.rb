class User < ActiveRecord::Base
  attr_accessible :email, :name
  @@email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 
  validates :email, :presence   => true,
            :format     => { :with => @@email_regex },
            :uniqueness => { :case_sensitive => false }

  def self.from_omniauth(auth)
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth['uid']
      user.email = auth["info"]["email"] 
      user.name = auth["info"]["name"]
    end
  end
end
