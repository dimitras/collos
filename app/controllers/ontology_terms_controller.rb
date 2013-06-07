class OntologyTermsController < ApplicationController

    load_and_authorize_resource

    def index
        @ontology_terms = @ontology_terms.page(params[:page])
        if params[:ontology_id]
            @ontology_terms = @ontology_terms.where(ontology_id: params[:ontology_id])
        end
    end
    def new; end
    def create
        if @ontology_term.save
            flash[:success] = "Ontology successfully created"
            redirect_to @ontology_term
        else
            render action: 'new'
        end

    end
    def edit; end
    def update
        if @ontology_term.update_attributes(params[:ontology_term])
            redirect_to @ontology_term, notice: 'OntologyTerm was successfully updated.'
        else
            render action: "edit"
        end
    end

    def destroy
        @ontology_term.destroy
        redirect_to ontology_terms_url, notice: "OntologyTerm was deleted"
    end

    # DEPRECATED: Autocomplete query
    def query
        @ontology_terms = @ontology_terms.order(:name).where("lower(name) like ?", "%#{params[:term].downcase}%")
        render json: @ontology_terms.map{|t| t.pretty_string }
    end
end
