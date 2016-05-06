class MaterialTypesController < ApplicationController
  load_and_authorize_resource

  def index
    @material_types = MaterialType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @material_types }
    end
  end

  def show
    @material_type = MaterialType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @material_type }
    end
  end

  def new
    @material_type = MaterialType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @material_type }
    end
  end

  def edit
    @material_type = MaterialType.find(params[:id])
  end

  def create
    @material_type = MaterialType.new(params[:material_type])

    respond_to do |format|
      if @material_type.save
        format.html { redirect_to @material_type, notice: 'MaterialType was successfully created.' }
        format.json { render json: @material_type, status: :created, location: @material_type }
      else
        format.html { render action: "new" }
        format.json { render json: @material_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @material_type = MaterialType.find(params[:id])

    respond_to do |format|
      if @material_type.update_attributes(params[:material_type])
        format.html { redirect_to @material_type, notice: 'MaterialType was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @material_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @material_type = MaterialType.find(params[:id])
    @material_type.destroy

    respond_to do |format|
      format.html { redirect_to material_types_url }
      format.json { head :no_content }
    end
  end
end
