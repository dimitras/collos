class StrainsController < ApplicationController
    load_and_authorize_resource

    def index
        @strains = @strains.page(params[:page])
    end
    def show; end

    def new; end
    def create
        if @strain.save
            flash[:success] = "Strain successfully created"
            redirect_to @strain
        else
            render action: 'new'
        end
    end

    def edit; end
    def update
        if @strain.update_attributes(params[:strain])
            redirect_to @strain, notice: 'Strain was successfully updated'
        else
            render action: "edit"
        end
    end

    def destroy
        @strain.destroy
        redirect_to strains_url, notice: "Strain was deleted"
    end
end
