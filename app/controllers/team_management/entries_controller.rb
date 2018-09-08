class TeamManagement::EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_team_privileges!

  def index
    @competition = @team.event.competition
  end

  def new
    @challenge = Challenge.find(params[:challenge_id])
    @entry = @team.entries.new(challenge: @challenge)
    @checkpoints = @team.available_checkpoints(@challenge)
  end

  def create
    @entry = @team.entries.new(entry_params)
    @challenge = Challenge.find(params[:challenge_id])
    @entry.challenge = @challenge
    @checkpoints = @team.available_checkpoints(@challenge)
    checkpoint = Checkpoint.find(params[:entry][:checkpoint_id])
    checkpoint_not_passed = @checkpoints.include?(checkpoint)
    if checkpoint_not_passed && @entry.save
      flash[:notice] = 'Challenge Entered'
      redirect_to challenge_path(@entry.challenge)
    else
      unless checkpoint_not_passed
        flash[:alert] = "#{checkpoint.name} has passed."
      else
        flash[:alert] = @entry.errors.full_messages.to_sentence
      end
      render :new
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    @team = @entry.team
    @challenge = @entry.challenge
    @checkpoints = (@team.available_checkpoints(@challenge) << @entry.checkpoint).uniq
  end

  def update
    @entry = Entry.find(params[:id])
    @challenge = @entry.challenge
    @checkpoints = (@team.available_checkpoints(@challenge) << @entry.checkpoint).uniq
    checkpoint = Checkpoint.find(params[:entry][:checkpoint_id])
    checkpoint_not_passed = @checkpoints.include?(checkpoint)
    if checkpoint_not_passed && @entry.update(entry_params)
      flash[:notice] = 'Entry Updated Successfully'
      redirect_to team_management_team_entries_path(@team)
    else
      unless checkpoint_not_passed
        flash[:alert] = "#{checkpoint.name} has passed."
      else
        flash[:alert] = @entry.errors.full_messages.to_sentence
      end
      render :edit
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    flash[:notice] = 'Challenge Entry Removed'
    redirect_to team_management_team_entries_path(@entry.team)
  end

  private

  def entry_params
    params.require(:entry).permit(:checkpoint_id, :justification, :challenge_id)
  end

  def check_user_team_privileges!
    @team = Team.find(params[:team_id])
    return if @team.permission?(current_user)
    flash[:notice] = 'You do not have access permissions for this team.'
    redirect_to root_path
  end
end
