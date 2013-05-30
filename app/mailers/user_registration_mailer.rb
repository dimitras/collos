class UserRegistrationMailer < ActionMailer::Base
  layout "mailer"
  default from: ENV['GMAIL_USERNAME']

  def welcome(user_id)
    @user = User.find(user_id)
    @url = root_url(only_path: false)
    mail(to: @user.email, subject:"Welcome to CollOS" )
  end
end
