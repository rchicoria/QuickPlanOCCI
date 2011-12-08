class MeetingPeopleController < ApplicationController
  # GET /meeting_people
  # GET /meeting_people.json
  def index
    @meeting_people = MeetingPerson.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meeting_people }
    end
  end

  # GET /meeting_people/1
  # GET /meeting_people/1.json
  def show
    @meeting_person = MeetingPerson.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meeting_person }
    end
  end

  # GET /meeting_people/new
  # GET /meeting_people/new.json
  def new
    @meeting_person = MeetingPerson.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meeting_person }
    end
  end

  # GET /meeting_people/1/edit
  def edit
    @meeting_person = MeetingPerson.find(params[:id])
  end

  # POST /meeting_people
  # POST /meeting_people.json
  def create
    @meeting_person = MeetingPerson.new(params[:meeting_person])

    respond_to do |format|
      if @meeting_person.save
        format.html { redirect_to @meeting_person, notice: 'Meeting person was successfully created.' }
        format.json { render json: @meeting_person, status: :created, location: @meeting_person }
      else
        format.html { render action: "new" }
        format.json { render json: @meeting_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meeting_people/1
  # PUT /meeting_people/1.json
  def update
    @meeting_person = MeetingPerson.find(params[:id])

    respond_to do |format|
      if @meeting_person.update_attributes(params[:meeting_person])
        format.html { redirect_to @meeting_person, notice: 'Meeting person was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @meeting_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meeting_people/1
  # DELETE /meeting_people/1.json
  def destroy
    @meeting_person = MeetingPerson.find(params[:id])
    @meeting_person.destroy

    respond_to do |format|
      format.html { redirect_to meeting_people_url }
      format.json { head :ok }
    end
  end
end
