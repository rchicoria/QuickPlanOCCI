class PeopleController < ApplicationController
  def edit
    @person = Person.find_by_invitation_url!(params[:id])
    @person.rsvp = params[:option]
    @step = params[:step] ? params[:step] : 'form' 

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @meeting }
    end
  end

  def update
    @person = Person.find_by_invitation_url(params[:id])
    @step = "confirmation"

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to edit_person_path(:id => @person.invitation_url, :step => @step)}
        format.js   { redirect_to edit_person_path(:id => @person.invitation_url, :step => @step)}
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end
end
