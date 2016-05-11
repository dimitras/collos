class StudiesController < ApplicationController
  load_and_authorize_resource
  # GET /studies
  # GET /studies.json
  def index
    @studies = Study.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studies }
    end
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
    @study = Study.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study }
      #format.csv {send_data @study.samples.to_csv, :filename => "#{@study.identifier}_samples.csv"}
      format.csv { send_data @study.samples_for_csv, :filename => "#{@study.identifier}_samples.csv"}      
      #format.pdf { render :layout => false }
      #format.csv  { send_data @study.samples.to_csv(), :filename => "#{@study.identifier}_samples.csv" }
      #format.tsv  { send_data @study.samples.to_tsv(), :filename => "#{@study.samples}_samples.tsv" }
    end

    # TODO

    # # create a unique PDF filename
    # pdf_uuid = UUIDTools::UUID.timestamp_create().to_s
    # pdf_uuid_filename = Rails.root.join('app/assets/images/labels', "#{pdf_uuid}.pdf").to_s

    # # create a pdf but don't display it
    # pdf_file = render_to_string :pdf => pdf_uuid_filename, 
    #                             :template  => 'plans/show.pdf.erb' ,
    #                             :layout    => 'pdf',
    #                             :save_only => true
    # # save to a file
    # File.open(pdf_uuid_filename, 'wb') do |file|
    #   file << pdf_file
    # end
    # # create full URL path to created file  
    # @plan.url = request.url[0, request.url.index("plans")] +  'pdf/' + CGI::escape("#{pdf_uuid}.pdf")
    # @plan.save!
    # # render the page again with the link being displayed
    # redirect_to :back

  end

  # GET /studies/new
  # GET /studies/new.json
  def new
    @study = Study.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @study }
    end
  end

  # GET /studies/1/edit
  def edit
    @study = Study.find(params[:id])
  end

  # POST /studies
  # POST /studies.json
  def create
    @study = Study.new(params[:study])

    respond_to do |format|
      if @study.save
        format.html { redirect_to @study, notice: 'Study was successfully created.' }
        format.json { render json: @study, status: :created, location: @study }
      else
        format.html { render action: "new" }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /studies/1
  # PUT /studies/1.json
  def update
    @study = Study.find(params[:id])

    respond_to do |format|
      if @study.update_attributes(params[:study])
        format.html { redirect_to @study, notice: 'Study was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studies/1
  # DELETE /studies/1.json

  def destroy
    # @study = Study.find(params[:id])
    @study.destroy
    redirect_to studies_url, notice: "Study was deleted"
    # respond_to do |format|
    #   format.html { redirect_to studies_url }
    #   format.json { head :no_content }
    # end
  end
end
