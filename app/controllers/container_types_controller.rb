class ContainerTypesController < ApplicationController
    load_and_authorize_resource
    autocomplete :ontology_term, :name, display_value: :pretty_string, full: true, extra_data: [:accession]

    def index
        @container_types = @container_types.includes(:type => [:ontology]).page(params[:page])
    end
    def show
        @container_type = @container_type.includes(:type => [ :ontology ]).find(params[:id])
        @type = @container_type.type
    end

    def new; end
    def create
        if @container_type.save
            flash[:success] = "ContainerType successfully created."
            redirect_to @container_type
        else
            render action: 'new'
        end
    end

    def edit; end
    def update
        if @container_type.update_attributes(params[:container_type])
            flash[:success] = "ContainerType successfully updated."
            redirect_to @container_type
        else
            render action: 'edit'
        end
    end

    def destroy
        @container_type.destroy
        redirect_to container_types_url, notice: "ContainerType was deleted."
    end

end
