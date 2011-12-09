class Notifier < ActionMailer::Base
  default :from => "quickplaninviter@gmail.com"
 
  def management_email(meeting, url)
    @meetings = meeting
    @url = url
    mail(:to => meeting.creator.email, :subject => "QuickPlan: Meeting Management URL")
  end
  def invitation_email(participant, meeting)
    @url = (Rails.env.development?) ? "http://localhost:3000/rsvp/" : "http://localhost:3000/rsvp/"
    @url = @url + participant.invitation_url
    @participant = participant
    @meeting = meeting
    mail(:to => participant.email, :subject => "QuickPlan: Invitation")
  end
end
