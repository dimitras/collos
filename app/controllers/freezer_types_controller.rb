class FreezerTypesController < ApplicationController
  # GET /freezer_types
  # GET /freezer_types.json
  def index
    @freezer_types = FreezerType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @freezer_types }
    end
  end

  # GET /freezer_types/1
  # GET /freezer_types/1.json
  def show
    @freezer_type = FreezerType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @freezer_type }
    end
  end

  # GET /freezer_types/new
  # GET /freezer_types/new.json
  def new
    @freezer_type = FreezerType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @freezer_type }
    end
  end

  # GET /freezer_types/1/edit
  def edit
    @freezer_type = FreezerType.find(params[:id])
  end

  # POST /freezer_types
  # POST /freezer_types.json
  def create
    @freezer_type = FreezerType.new(params[:freezer_type])

    respond_to do |format|
      if @freezer_type.save
        format.html { redirect_to @freezer_type, notice: 'Freezer type was successfully created.' }
        format.json { render json: @freezer_type, status: :created, location: @freezer_type }
      else
        format.html { render action: "new" }
        format.json { render json: @freezer_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /freezer_types/1
  # PUT /freezer_types/1.json
  def update
    @freezer_type = FreezerType.find(params[:id])

    respond_to do |format|
      if @freezer_type.update_attributes(params[:freezer_type])
        format.html { redirect_to @freezer_type, notice: 'Freezer type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @freezer_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freezer_types/1
  # DELETE /freezer_types/1.json
  def destroy
    @freezer_type = FreezerType.find(params[:id])
    @freezer_type.destroy

    respond_to do |format|
      format.html { redirect_to freezer_types_url }
      format.json { head :no_content }
    end
  end
end
