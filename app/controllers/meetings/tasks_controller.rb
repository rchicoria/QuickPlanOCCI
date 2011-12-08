class MeetingTasksController < ApplicationController
  # GET /meeting_tasks
  # GET /meeting_tasks.json
  def index
    @meeting_tasks = MeetingTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meeting_tasks }
    end
  end

  # GET /meeting_tasks/1
  # GET /meeting_tasks/1.json
  def show
    @meeting_task = MeetingTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meeting_task }
    end
  end

  # GET /meeting_tasks/new
  # GET /meeting_tasks/new.json
  def new
    @meeting_task = MeetingTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meeting_task }
    end
  end

  # GET /meeting_tasks/1/edit
  def edit
    @meeting_task = MeetingTask.find(params[:id])
  end

  # POST /meeting_tasks
  # POST /meeting_tasks.json
  def create
    @meeting_task = MeetingTask.new(params[:meeting_task])

    respond_to do |format|
      if @meeting_task.save
        format.html { redirect_to @meeting_task, notice: 'Meeting task was successfully created.' }
        format.json { render json: @meeting_task, status: :created, location: @meeting_task }
      else
        format.html { render action: "new" }
        format.json { render json: @meeting_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meeting_tasks/1
  # PUT /meeting_tasks/1.json
  def update
    @meeting_task = MeetingTask.find(params[:id])

    respond_to do |format|
      if @meeting_task.update_attributes(params[:meeting_task])
        format.html { redirect_to @meeting_task, notice: 'Meeting task was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @meeting_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meeting_tasks/1
  # DELETE /meeting_tasks/1.json
  def destroy
    @meeting_task = MeetingTask.find(params[:id])
    @meeting_task.destroy

    respond_to do |format|
      format.html { redirect_to meeting_tasks_url }
      format.json { head :ok }
    end
  end
end
