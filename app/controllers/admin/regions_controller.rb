class Admin::RegionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index; end

  def create
    @region = Region.create(name: params[:name],
                            time_zone: params[:time_zone],
                            parent_id: params[:parent_id])
    flash[:notice] = if @region.persisted?
                       "New Region '#{@region.name}' added."
                     else
                       @region.errors.full_messages.to_sentence
                     end
    redirect_to admin_regions_path
  end

  def show
    @region = Region.find(params[:id])
  end

  def assignment
    @region = Region.find_by_id(params[:region_id])
    @user = User.find_by_email(params[:user_email])
    assignment = @region.assignments.find_or_create_by(user: @user, title: params[:title])
    flash[:notice] = if assignment.persisted?
                       "New #{params[:title]} '#{@user.full_name}' added."
                     else
                       "Could not find User with email #{params[:user_email]}"
                     end
    redirect_to admin_region_path(@region.id)
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
