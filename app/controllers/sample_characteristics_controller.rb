class SampleCharacteristicsController < ApplicationController
    load_and_authorize_resource :sample
    def show; end
    def new; end
    def create
        if @sample.save
            redirect_to sample_characteristic_url, success: "Sample Characteristic Created"
        else
            render action: 'new'
        end
    end
    def edit; end
    def update
        if @sample_characteristic.update_attributes(params[:sample_characteristic])
            redirect_to @sample_characteristic, success: 'Sample characteristic updated'
        else
            render action: 'edit'
        end
    end
    def destroy
        @sample_characteristic.destroy
        redirect_to sample_characteristics_url, success: 'Sample characteristic destroyed'
    end
end
