class EthnicitiesController < ApplicationController
  load_and_authorize_resource

  def index
      @ethnicities = @ethnicities.page(params[:page])
  end
  def show; end

  def new; end
  def create
      if @ethnicity.save
          flash[:success] = "Ethnicity successfully created"
          redirect_to @ethnicity
      else
          render action: 'new'
      end
  end

  def edit; end
  def update
      if @ethnicity.update_attributes(params[:ethnicity])
          redirect_to @ethnicity, notice: 'Ethnicity was successfully updated'
      else
          render action: "edit"
      end
  end

  def destroy
      @ethnicity.destroy
      redirect_to ethnicities_url, notice: "Ethnicity was deleted"
  end

end
