class DataSetsController < ApplicationController
  def index
    @data_portals = YAML.load_file "#{Rails.root}/app/views/data_sets/data_portals.yml"
  end

  def highlight
    @data_sets = @competition.data_sets.order(:name).preload(:region)
    respond_to do |format|
      format.html
      format.csv { send_data @data_sets.to_csv @competition }
    end
  end

  def show
    @data_set = DataSet.find(params[:id])
    @team_data_sets = TeamDataSet.where(url: @data_set.url)
    @teams = Team.published.where(id: @team_data_sets.pluck(:team_id)).preload(:current_project)
  end
end
