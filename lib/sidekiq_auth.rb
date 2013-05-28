class SidekiqAuth
    def matches?(request)
        if request.session[:user_id].nil?
            return false
        end
        user = User.find(request.session[:user_id])
        user && user.admin?
    end
end
