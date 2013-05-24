class MembersController < ApplicationController
  before_filter :require_login

  def new
     @member = flash[:member] || Member.new
  end

  def create

    @member = Member.new(params[:member])

    if @member.save
      flash[:notice] = "Jasen lisatty!"
    else
      flash[:member] = @member
    end
    redirect_to new_member_path
  end

  def index
    @members = Member.all
  end

  private

  def require_login
    unless logged_in?
      flash[:error] = "Sinun on kirjauduttava sisaan ennen kuin voit hallitta jarjestelmaa"
      redirect_to login_path
    end
  end

  def logged_in?
    !!session[:admin]
  end
end