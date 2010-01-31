class AdminController < ApplicationController
 
  def login
    if request.post?
      if User.count.zero?
        flash.now[:notice]="Create at least an admin user"
        redirect_to :controller=>:users, :action=>:new
      else
        user=User.authenticate(params[:name], params[:password])
        if user
          session[:user_id]=user.id
          redirect_to :action=>:index
        else
          flash.now[:notice]="Invalid user/password combination"
        end
      end
    end
  end

  def logout
    session[:user_id]=nil
    flash[:notice]="Logged Out"
    redirect_to :action=>:login
  end

  def index
    @total_orders=Order.count
  end

end
