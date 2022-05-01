class UsersController < ApplicationController
  def create
    @user = User.create(email: params[:user][:email])
    redirect_to :controller => 'articles', :action => 'index'
  end
end
