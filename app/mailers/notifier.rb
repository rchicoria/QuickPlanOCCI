class Notifier < ActionMailer::Base
  default :from => "quickplaninviter@gmail.com"
 
  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "QuickPlan: Meeting Management URL")
  end
end
