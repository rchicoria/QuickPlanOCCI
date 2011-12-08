class MeetingTopicsController < ApplicationController
  # GET /meeting_topics
  # GET /meeting_topics.json
  def index
    @meeting_topics = MeetingTopic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meeting_topics }
    end
  end

  # GET /meeting_topics/1
  # GET /meeting_topics/1.json
  def show
    @meeting_topic = MeetingTopic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meeting_topic }
    end
  end

  # GET /meeting_topics/new
  # GET /meeting_topics/new.json
  def new
    @meeting_topic = MeetingTopic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meeting_topic }
    end
  end

  # GET /meeting_topics/1/edit
  def edit
    @meeting_topic = MeetingTopic.find(params[:id])
  end

  # POST /meeting_topics
  # POST /meeting_topics.json
  def create
    @meeting_topic = MeetingTopic.new(params[:meeting_topic])

    respond_to do |format|
      if @meeting_topic.save
        format.html { redirect_to @meeting_topic, notice: 'Meeting topic was successfully created.' }
        format.json { render json: @meeting_topic, status: :created, location: @meeting_topic }
      else
        format.html { render action: "new" }
        format.json { render json: @meeting_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meeting_topics/1
  # PUT /meeting_topics/1.json
  def update
    @meeting_topic = MeetingTopic.find(params[:id])

    respond_to do |format|
      if @meeting_topic.update_attributes(params[:meeting_topic])
        format.html { redirect_to @meeting_topic, notice: 'Meeting topic was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @meeting_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meeting_topics/1
  # DELETE /meeting_topics/1.json
  def destroy
    @meeting_topic = MeetingTopic.find(params[:id])
    @meeting_topic.destroy

    respond_to do |format|
      format.html { redirect_to meeting_topics_url }
      format.json { head :ok }
    end
  end
end
