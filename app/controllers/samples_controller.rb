class SamplesController < ApplicationController
    load_and_authorize_resource
    autocomplete :taxon, :scientific_name, full: true, extra_data: [:scientific_name]

    def index
        @samples = @samples.includes([:barcode, :container ]).page(params[:page] || 1)
    end
    def show;end

    def new;end
    def create
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
        if @sample.destroy
            redirect_to samples_url, success: "Sample was deleted"
        else
            redirect_to @sample, error: "Sample was not deleted"
        end
    end
end
