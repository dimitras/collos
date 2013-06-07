class UsersController < ApplicationController
    skip_before_filter :require_login, :only => [:register]
    skip_authorization_check :only => [:register]

    load_and_authorize_resource

    @@per_page = 25

    def index
        @users = @users.paginate(per_page: params[:per_page] || @@per_page,
            page:  params[:page])
        if params[:status]
            @user.where(status: params[:status])
        end
    end

    def show; end

    # Regular edit functionality. If current_user.admin? then you can change
    # the active/inactive status of the supplied user
    def edit; end
    def update
        if @user.update_attributes(params[:user])
            redirect_to @user, notice: "User was successfully updated"
        else
            render action: "edit"
        end
    end

    def new; end
    def create
        @user.status = :pending
        if @user.save
            redirect_to @user, notice: 'Successfully registered. We will email a confirmation once your account is active'
        else
            render action: "new"
        end
    end


    def destroy
        redirect_to user_inactivate_path(@user)
    end

    def activate
        @user = User.find(params[:id])
        send_mail = @user.pending?
        @user.active!
        if send_mail
            UserRegistrationMailer.delay.welcome(@user.id)
        end
        flash[:success] = "User #{@user.name} now active"
        redirect_to user_path(@user)
    end

    def inactivate
        @user.inactive!
        @user.save
        flash[:success]= "User #{@user.name} now inactive"
        redirect_to user_path(@user)
    end

    # Review the list of pending registrations
    def approve
        @users = @users.pending
    end
end
