class UserMailer < ActionMailer::Base
  default :from => "notifications@example.com"

  def welcome_email()
    @url  = "http://example.com/login"
    @address = ["trevor.umeda@gmail.com","foxnewsnetwork@gmail.com"]
    mail(:to => @address, :subject => "Welcome to My Awesome Site")
  end
end
