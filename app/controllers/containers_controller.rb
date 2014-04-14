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
    def new
        @container = Container.new
        @containers = Container.all  
    end
    def create
        # @container.parent = nil
        if @container.save
            redirect_to container_path(@container), :success => "Container successfully created"
        else
            flash[:error] = @container.errors.to_yaml
            render :action => 'new'
        end
    end
    def edit
        @container = Container.includes(:barcode, :container_type).find(@container)
		@containers = Container.arrange_as_array({:order => 'name'}, @container.possible_parents)
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

    def edit_multiple
      @containers = Container.find(params[:container_ids])
    end

    def update_multiple
      @containers = Container.find(params[:container_ids])
      @containers.each do |container|
        container.update_attributes!(params[:container].reject { |k,v| v.blank? })
      end
      flash[:notice] = "Containers were successfully updated!"
      redirect_to containers_path
    end

    # def child_containers_by_depth
    #     if params[:id].present?
    #         @child_containers = Container.find(params[:id]).child_containers
    #     else
    #         @child_containers = []
    #     end

    #     respond_to do |format|
    #         format.js
    #     end
    # end
end
