class UserRegistrationMailer < ActionMailer::Base
  layout "mailer"
  default from: CONFIG.application.gmail_username

  def welcome(user_id)
    @user = User.find(user_id)
    @url = root_url(only_path: false)
    mail(to: @user.email, subject:"Welcome to CollOS" )
  end
end
