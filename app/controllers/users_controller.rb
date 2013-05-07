class UsersController < ApplicationController

    @@per_page = 25

    def index
        @users = User.paginate(per_page: params[:per_page] || @@per_page,
            page:  params[:page])
        if params[:status]
            @user.where(status: params[:status])
        end
    end

    def show
        @user = User.find(params[:id])
    end

    # Regular edit functionality. If current_user.admin? then you can change
    # the active/inactive status of the supplied user
    def edit
        @user = current_user
        if current_user.admin?
            @user = User.find(params[:id])
        end
    end

    def new
        @user = User.new
    end

    def create
        @user  = User.new(params[:user])
        @user.status = :pending

        if @user.save
            redirect_to @user, notice: 'Successfully registered. We will email a confirmation once your account is active'
        else
            render action: "new"
        end
    end


    def update
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
            redirect_to @user, notice: "User was successfully updated"
        else
            render action: "edit"
        end
    end

    def destroy
        @user = User.find(params[:id])
        redirect_to user_inactivate_path(@user)
    end

    def activate
        @user = User.find(params[:user_id])
        @user.active!
        @user.save
        redirect_to edit_user_path(@user)
    end

    def inactivate
        @user = User.find(params[:user_id])
        @user.inactive!
        @user.save
        redirect_to edit_user_path(@user)
    end
end
