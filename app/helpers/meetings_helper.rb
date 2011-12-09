module MeetingsHelper
  def default_invitation_text(meeting)
    url = (Rails.env.development?) ? "http://localhost:3000/" : "http://localhost:3000/"
    url = url + meeting.management_url      
    return "Hi,
 I am using QuickPlan to notify you of a new meeting called '#{meeting.subject}', due to #{meeting.date.to_s}.

Regards,
#{meeting.creator.name}"
  end
end
