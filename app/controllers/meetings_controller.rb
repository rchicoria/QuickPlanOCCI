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
    @meeting.creator = Meeting::Person.new unless @meeting.creator
    
    @step = params[:step] ? params[:step] : 'first'
  
    @meeting.build_creator
    @meeting.topics.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find(params[:id])

    @step = params[:step] ? params[:step] : 'first'

    if(params[:commit] == "Go back")
      @step = 'details_edit'
    end

    respond_to do |format|
      format.html # new.html.erb
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
        Notifier.welcome_email(@meeting.creator).deliver
        format.html { redirect_to edit_meeting_path(:id => @meeting.id, :step => "invites")}
        format.js   { redirect_to edit_meeting_path(:id => @meeting.id, :step => "invites")}
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
    @meeting = Meeting.find(params[:id])
    
    if(params[:commit] == "Continue")
      @step = 'invites'
    elsif(params[:commit] == "Go back")
      @step = 'details_edit'
    elsif(params[:commit] == "Invite")
      @step = 'sent'
    elsif(params[:commit] == "Invite more participants")
      @step = 'invites'
    end

    respond_to do |format|
      if @meeting.update_attributes(params[:meeting])
        format.html { redirect_to edit_meeting_path(:id => @meeting.id, :step => @step)}
        format.js   { redirect_to edit_meeting_path(:id => @meeting.id, :step => @step)}
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