class Notifier < ActionMailer::Base
  default :from => "quickplaninviter@gmail.com"
 
  def management_email(meeting, url)
    @meeting = meeting
    @url = url
    mail(:to => meeting.creator.email, :subject => "Link for \"#{@meeting.subject}\" management")
  end
  
  def invitation_email(participant, meeting)
    @url = (Rails.env.development?) ? "http://localhost:3000/rsvp/" : "http://quickplan.heroku.com/rsvp/"
    @url = @url + participant.invitation_url
    @participant = participant
    @meeting = meeting
    mail(:to => participant.email, :subject => "You have been invited to \"#{@meeting.subject}\"")
  end
  
  def report_email(participant, meeting, report)
    @participant = participant
    @meeting = meeting
    attachments['record.odf'] = File.read(report)
    mail(:to => participant.email, :subject => "Meeting Record for \"#{@meeting.subject}\"")
  end
end
