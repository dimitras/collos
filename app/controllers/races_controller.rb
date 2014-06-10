class RacesController < ApplicationController
    load_and_authorize_resource

    def index
        @races = @races.page(params[:page])
    end
    def show; end

    def new; end
    def create
        if @race.save
            flash[:success] = "Race successfully created"
            redirect_to @race
        else
            render action: 'new'
        end
    end

    def edit; end
    def update
        if @race.update_attributes(params[:race])
            redirect_to @race, notice: 'Race was successfully updated'
        else
            render action: "edit"
        end
    end

    def destroy
        @race.destroy
        redirect_to races_url, notice: "Race was deleted"
    end
end
