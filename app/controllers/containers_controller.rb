class ContainersController < ApplicationController
    load_and_authorize_resource includes: [:barcode,:container_type]

    def index
        @containers = @containers.includes([:barcode,:container_type]).order(:created_at)
        unless params[:show_all]
            @containers = @containers.where(retired: false)
        end
        @containers = @containers.page(params[:page])
    end

    def show; end
    def new; end
    def create
        @container.parent = nil
        if @container.save
            redirect_to container_path(@container), :success => "Container successfully created"
        else
            flash[:error] = @container.errors.to_yaml
            render :action => 'new'
        end
    end
    def edit
        @container = Container.includes(:barcode, :container_type).find(@container)
    end
    def update
        if @container.update_attributes(params[:container])
            flash[:success] = "Container successfully updated."
            redirect_to @container
        else
            render action: 'edit'
        end
    end

    def destroy
        @container.retired = true
        begin
            @container.save
            flash[:success] = 'Container retired'
            redirect_to containers_url
        rescue Exception => e
            flash[:error] = "Container was not retired because #{e.message}"
            render @container
        end
    end
end
