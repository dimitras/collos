class OntologiesController < ApplicationController
    load_and_authorize_resource
    def index
        @ontologies = Ontology.page(params[:page])
    end
    def show; end

    def new; end
    def create
        if @ontology.save
            flash[:success] = "Ontology successfully created"
            redirect_to @ontology
        else
            render action: 'new'
        end
    end

    def edit; end
    def update
        if @ontology.update_attributes(params[:ontology])
            redirect_to @ontology, notice: 'Ontology was successfully updated.'
        else
            render action: "edit"
        end
    end

    def destroy
        @ontology.destroy
        redirect_to ontologies_url, notice: "Ontology was deleted"
    end

end
