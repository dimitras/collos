class SamplesController < ApplicationController
    load_and_authorize_resource

    def index
        @samples = @samples.includes([:barcode, :container ])
        if params[:show_all]
            @samples = @samples.where(retired: true)
		else
			@samples = @samples.where(retired: false)
        end

        # TODO: for the number of children to be created
        # if params[:number_of_children] && params[:number_of_children] != ''
        #    @samples = @samples.number_of_children(params[:number_of_children].to_i)
        # end

        @samples = @samples.page(params[:page] || 1)
    end

    def show
		#@sample = @sample.find(params[:retired=>false])
        # @children = @sample.children
    end

    def new;end
    def create
        # scientific_name = params[:sample].delete(:scientific_name)
        # @sample = Sample.new(params[:sample])
        # @sample.taxon = Taxon.find_by_scientific_name(scientific_name)
        @studies = Study.all
        @material_types = MaterialType.all
        @study = Study.new
        @container = @sample.container#.build
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

	def confirm
    	@sample.confirmed = true
		if @sample#.save
			redirect_to samples_url, success: "Sample was confirmed"
		else
			redirect_to samples_url, error: "Sample was not confirmed"
		end
	end

    def destroy
        @sample.retired = true
        if @sample.save
            redirect_to samples_url, success: "Sample was retired"
        else
            redirect_to samples_url, error: "Sample was not retired"
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

    #TODO
    # def new_multiple
    #     3.times do
    #         @sample.children.build
    #     end
    # end

    def create_multiple
        @sample = Sample.find(params[:id])
        3.times do
            # @child = Sample.new
            @child = @sample.children.create!
            @child.save
            #@sample.save
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

    # def update_laboratory_select
    #     laboratories = Container.where(:container_type_id=>params[:id]).order(:name) unless params[:id].blank?
    #     render :partial => "laboratories", :container_types => { :laboratories => laboratories }
    # end
    # def update_freezer_select
    #     freezers = Container.where(:container_type_id=>params[:id]).order(:name) unless params[:id].blank?
    #     render :partial => "freezers", :container_types => { :freezers => freezers }
    # end
    # def update_box_select
    #     boxes = Container.where(:container_type_id=>params[:id]).order(:name) unless params[:id].blank?
    #     render :partial => "boxes", :container_types => { :boxes => boxes }
    # end
    # def update_tube_select
    #     tubes = Container.where(:container_type_id=>params[:id]).order(:name) unless params[:id].blank?
    #     render :partial => "tubes", :container_types => { :tubes => tubes }
    # end

end
