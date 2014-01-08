class TaxonsController < ApplicationController
    load_and_authorize_resource

    def index
        @taxons = @taxons.page(params[:page])
    end
    def show; end

    def new; end
    def create
        if @taxon.save
            flash[:success] = "Taxon successfully created"
            redirect_to @taxon
        else
            render action: 'new'
        end
    end

    def edit; end
    def update
        if @taxon.update_attributes(params[:taxon])
            redirect_to @taxon, notice: 'Taxon was successfully updated.'
        else
            render action: "edit"
        end
    end

    def destroy
        @taxon.destroy
        redirect_to taxons_url, notice: "Taxon was deleted"
    end
end
