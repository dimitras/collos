class Contact < ActiveRecord::Base
  belongs_to :address
  attr_accessible :email, :fname, :lname
end
