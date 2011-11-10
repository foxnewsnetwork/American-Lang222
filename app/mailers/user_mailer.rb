class UserMailer < ActionMailer::Base
  default :from => "notifications@example.com"

  def welcome_email(addresses)
    @url  = "http://example.com/login"
    mail(:to => addresses, :subject => "Welcome to My Awesome Site")
  end
  
  def company_email(addresses, contents, subject)
    @content = contents
    mail(:to => addresses[0..4], :bcc => addresses[5..(addresses.count-1)] , :subject => subject)
  end
end
