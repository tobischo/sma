class UserController < ApplicationController
  
  def settings
  end

  def changepassword
    
    u = session[:current_user]
    
    if !u.has_password?(params[:currentPassword]) then
      flash[:error] = "Wrong password!"
    elsif params[:newPassword] != params[:newPassword_confirmation] then
      flash[:error] = "New Password does not match Confirmation"
    elsif params[:newPassword].blank? || params[:newPassword].blank? then
      flash[:error] = "New password must not be empty"
    else
      u.password=params[:newPassword]
      u.password_confirmation=params[:newPassword_confirmation]
      u.save
      flash[:notice] = "Password successfully changed"
    end
    
    redirect_to :controller => :user, :action => :settings
  end

end
