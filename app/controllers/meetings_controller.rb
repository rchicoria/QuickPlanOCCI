class MeetingsController < ApplicationController
  # GET /meetings
  # GET /meetings.json

  def odt(meeting)
    report = ODFReport::Report.new("#{Rails.root}/app/test.odt") do |r|
      
      r.add_field "SUBJECT",  meeting.subject
      r.add_field "DATE", meeting.date.to_s
      r.add_field "HOSTED_BY", Person.find(meeting.creator_id).name
      attendances = []
      meeting.participants.each do |participant|
        if participant.presence == "yes"
          attendances << participant.name        
        end
      end
      r.add_field "ATTENDANCES", attendances.join(", ")
      tasks = ""
      meeting.topics.each do |topic|
        tasks += topic.name+":\n\n"+topic.description+"\n\n"
        topic.tasks.each do |task|
          tasks += task.description+": "+Person.find(task.person_id).name+"\n"
        end
        tasks += "\n"
      end
      r.add_field "TOPICS_AND_TASKS", tasks
    end

    report_file_name = report.generate
    return report_file_name  
  end

  def index
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.json
  def new
    @meeting = Meeting.new(params[:meeting])
    @meeting.creator = Person.new unless @meeting.creator
    
    if(params[:step] != 'first' and params[:step] != 'details')    
      @step = 'first'
    else
      @step = params[:step]
    end 
  
    @meeting.build_creator
    topic = @meeting.topics.build
    
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find_by_management_url!(params[:id])
    
    @gcal = export_cal(@meeting)

    @meeting.topics.each do |topic|
      topic.tasks.build
    end

    if(@meeting.state == 'A' or @meeting.state == 'B')    
      @step = 'invites'
    elsif(@meeting.state == nil)
      @step = 'details'  
    else
      @step = 'meeting'
    end

    puts @step

    if(params[:commit] == "Go back")
      @step = 'details_edit'
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @meeting }
    end
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = Meeting.new(params[:meeting])
    @creator = Person.new(params[:meeting][:creator_attributes])
    @creator.save
    @meeting.creator_id = @creator.id
    begin
      @meeting.date = (DateTime.strptime(params[:meeting][:date], '%m/%d/%Y %H:%M ')).to_datetime
    rescue Exception=>e
      @meeting.date = nil
    end
    @meeting.state = 'A'
    respond_to do |format|
      if @meeting.save
        @meeting.management_url = SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")+@meeting.id.to_s
        @meeting.participants = []        
        @meeting.save
        url = (Rails.env.development?) ? "http://localhost:3000/manage/" : "http://quickplan.heroku.com/manage/"
        url = url + @meeting.management_url  
        Notifier.management_email(@meeting, url).deliver
        format.html { redirect_to edit_meeting_path(:id => @meeting.management_url, :step => "invites")}
        format.js   { redirect_to edit_meeting_path(:id => @meeting.management_url, :step => "invites")}
        format.json { render json: @meeting, status: :created, location: @meeting }
      else
        format.html { render action: :new }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meetings/1
  # PUT /meetings/1.json
  def update
    @meeting = Meeting.find_by_management_url(params[:id])
    
    if(params[:commit] == "Continue")
      @step = 'invites'
    elsif(params[:commit] == "Go back")
      @step = 'details_edit'
    elsif(params[:commit] == "Meeting Management")
      @step = 'management'
    elsif(params[:commit] == "Start Meeting")
      @meeting.state = 'C'
      @step = 'meeting'
      @meeting.save
    elsif(params[:commit] == "Generate Documentation")
      @step = 'meeting'
    elsif(params[:commit] == "Invite")
      @meeting.state = 'B'
      emails = params[:meeting][:mail_list].split(',')  
      participants = []
      emails.each do |email|
        if email =~ /[^"]*<[^"]*@[^"]*.[^"]*>/
          participant = Person.new(:name => email.scan(/([^"]*)</)[0][0].strip, :email => email.scan(/<([^"]*)>/)[0][0].strip, :invitation_url => SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")+participants.length.to_s)
          participants << participant
        elsif email =~ /<[^"]*@[^"]*.[^"]*>/
          participant = Person.new(:name => 'Participant name', :email => email.scan(/<([^"]*)>/)[0][0].strip, :invitation_url => SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")+participants.length.to_s)
          participants << participant
        elsif email =~ /[^"]*@[^"]*.[^"]*/
          participant = Person.new(:name => "Participant name", :email => email.scan(/([^"]*)/)[0][0].strip, :invitation_url => SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")+participants.length.to_s) 
          participants << participant
        end
      end
      if participants.length != 0
        @meeting.participants |= participants
      end
      params[:meeting][:mail_list] = ""
      @meeting.save
      @step = 'invites'
    elsif(params[:commit] == "Invite more participants")
      @step = 'invites'
    end
  
    respond_to do |format|     
      if @meeting.update_attributes(params[:meeting])
        if(params[:commit] == "Invite")
          participants.each do |participant|
            Notifier.invitation_email(participant, @meeting).deliver     
          end        
        elsif(params[:commit] == "Generate Documentation")
          @meeting.participants.each do |participant|
            Notifier.report_email(participant, @meeting, odt(@meeting)).deliver     
          end
          Notifier.report_email(Person.find(@meeting.creator_id), @meeting, odt(@meeting)).deliver 
        end
        format.html { redirect_to edit_meeting_path(:id => @meeting.management_url, :step => @step)}
        format.js   { redirect_to edit_meeting_path(:id => @meeting.management_url, :step => @step)}
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy

    respond_to do |format|
      format.html { redirect_to meetings_url }
      format.json { head :ok }
    end
  end
end
