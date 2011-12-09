class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def export_cal(meeting)
    details = "Topics for this meeting:%0A"
    
    sdate = meeting.date
    sdate_str = "#{sdate.strftime("%Y%m%d")}T#{sdate.strftime("%H%M%S")}Z"
    edate = meeting.date + 1.hour
    edate_str = "#{edate.strftime("%Y%m%d")}T#{edate.strftime("%H%M%S")}Z"
    
    meeting.topics.each do |topic|
      details += " - #{topic.name}%0A"
    end
    
    gcal = {:text => meeting.subject,
             :dates => "#{sdate_str}/#{edate_str}",
             :details => details
    }
    return gcal
  end
end
