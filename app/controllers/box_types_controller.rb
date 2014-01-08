class BoxTypesController < ApplicationController
  # GET /box_types
  # GET /box_types.json
  def index
    @box_types = BoxType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @box_types }
    end
  end

  # GET /box_types/1
  # GET /box_types/1.json
  def show
    @box_type = BoxType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @box_type }
    end
  end

  # GET /box_types/new
  # GET /box_types/new.json
  def new
    @box_type = BoxType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @box_type }
    end
  end

  # GET /box_types/1/edit
  def edit
    @box_type = BoxType.find(params[:id])
  end

  # POST /box_types
  # POST /box_types.json
  def create
    @box_type = BoxType.new(params[:box_type])

    respond_to do |format|
      if @box_type.save
        format.html { redirect_to @box_type, notice: 'Box type was successfully created.' }
        format.json { render json: @box_type, status: :created, location: @box_type }
      else
        format.html { render action: "new" }
        format.json { render json: @box_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /box_types/1
  # PUT /box_types/1.json
  def update
    @box_type = BoxType.find(params[:id])

    respond_to do |format|
      if @box_type.update_attributes(params[:box_type])
        format.html { redirect_to @box_type, notice: 'Box type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @box_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /box_types/1
  # DELETE /box_types/1.json
  def destroy
    @box_type = BoxType.find(params[:id])
    @box_type.destroy

    respond_to do |format|
      format.html { redirect_to box_types_url }
      format.json { head :no_content }
    end
  end
end
