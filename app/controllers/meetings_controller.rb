class MeetingsController < ApplicationController
  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetings }
    end
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
    @meeting = Meeting.new(params[:id])    
    @meeting.creator = Person.new unless @meeting.creator
    
    @step = params[:step] ? params[:step] : 'first'
  
    @meeting.build_creator
    topic = @meeting.topics.build
    #topic.tasks.build
    
    puts "new new "
    
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find_by_management_url!(params[:id])
    
    details = "Topics for this meeting:%0A"
    @meeting.topics.each do |topic|
      details += " - #{topic.name}%0A"
    end
    @gcal = {:text => @meeting.subject,
             :dates => "#{@meeting.date.strftime("%Y%m%d")}/#{@meeting.date.strftime("%Y%m%d")}",
             :details => details
    }

    @meeting.topics.each do |topic|
      topic.tasks.build
    end

    if(@meeting.state == 'B')    
      @step = params[:step] ? params[:step] : 'invites'
    else
      @step = params[:step] ? params[:step] : 'meeting'
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
    @meeting.state = 'A'
    respond_to do |format|
      if @meeting.save
        @meeting.management_url = SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")+@meeting.id.to_s
        @meeting.participants = []        
        @meeting.save
        url = (Rails.env.development?) ? "http://localhost:3000/manage/" : "http://localhost:3000/manage/"
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
        elsif email =~ /<[^"]*@[^"]*.[^"]*>/
          participant = Person.new(:email => email.scan(/<([^"]*)>/)[0][0].strip, :invitation_url => SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")+participants.length.to_s)
        elsif
          participant = Person.new(:email => email.scan(/([^"]*)/)[0][0].strip, :invitation_url => SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")+participants.length.to_s) 
        end
        participants << participant
      end
      puts "cenas"
      puts "lalalal"
      @meeting.participants |= participants
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
        end
        puts "ceeeeeeeeeeeeeeenas"
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
