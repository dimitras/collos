class SamplesController < ApplicationController
    load_and_authorize_resource

    def index
        @samples = @samples.includes([:barcode, :container ])
        unless params[:show_all]
            @samples = @samples.where(retired: false)
        end
        @samples = @samples.page(params[:page] || 1)
    end

    def show;end

    def new;end
    def create
        # scientific_name = params[:sample].delete(:scientific_name)
        # @sample = Sample.new(params[:sample])
        # @sample.taxon = Taxon.find_by_scientific_name(scientific_name)
        @studies = Study.all
        @material_types = MaterialType.all
        if @sample.save
            redirect_to @sample, success: "Sample created successfully"
        else
            render action: 'new'
        end
    end

    def edit; end
    def update
        if @sample.update_attributes(params[:sample])
            redirect_to @sample, success: "Sample updated"
        else
            render action: 'edit'
        end
    end

    def destroy
        @sample.retired = true
        if @sample.save
            redirect_to samples_url, success: "Sample was retired"
        else
            redirect_to samples_url, error: "Sample was not deleted"
        end
    end

    def edit_multiple
      @samples = Sample.find(params[:sample_ids])
    end

    def update_multiple
      @samples = Sample.find(params[:sample_ids])
      @samples.each do |sample|
        sample.update_attributes!(params[:sample].reject { |k,v| v.blank? })
      end
      flash[:notice] = "Samples were successfully updated!"
      redirect_to samples_path
    end

    def create_multiple
        @sample = Sample.new()
        3.times do
            @sample.save
            # study = @sample.studies.build
            # material_type = @sample.material_types.build
        end
        # @samples = Sample.find(params[:sample_ids])
        # @samples.each do |sample|
        #     sample.save#!(params[:sample].reject { |k,v| v.blank? })
        # end
        flash[:notice] = "Sample's children were successfully created!"
        redirect_to samples_path
    end
end
