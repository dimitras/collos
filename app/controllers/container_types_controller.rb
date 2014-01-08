class ContainerTypesController < ApplicationController
    load_and_authorize_resource

    def index
        @container_types = @container_types.includes(:type => [:ontology])
        unless params[:show_all]
            @container_types = @container_types.where(retired: false)
        end
        @container_types = @container_types.page(params[:page])
    end
    def show
        @type = @container_type.type
    end

    def new
        # grab container type ontology terms
        @container_type_terms = @container_type.container_type_terms()
    end
    def create
        if @container_type.save
            flash[:success] = "ContainerType successfully created."
            redirect_to @container_type
        else
            render action: 'new'
        end
    end

    def edit
        # grab container type ontology terms
        @container_type_terms = @container_type.container_type_terms()
    end
    def update
        if @container_type.update_attributes(params[:container_type])
            flash[:success] = "ContainerType successfully updated."
            redirect_to @container_type
        else
            render action: 'edit'
        end
    end

    def destroy
        # @container_type.destroy
        # redirect_to container_types_url, notice: "ContainerType was deleted."
        @container_type.retired = true
        begin
            @container_type.save
            flash[:success] = 'Container type retired'
            redirect_to container_types_url
        rescue Exception => e
            flash[:error] = "Container type was not retired because #{e.message}"
            render @container_type
        end
    end

end
