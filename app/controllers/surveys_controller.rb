class SurveysController < ApplicationController

  before_action :find_survey

  def show
    @survey_dates = @survey.sort_by_votes
  end

  def destroy
    @trip = @survey.trip
    authorize @trip
    @survey_date = @survey.sort_by_votes.first
    @trip.start_date = @survey_date.start_date
    @trip.end_date = @survey_date.end_date
    @trip.save
    @survey.destroy
    redirect_to trip_path(@trip)
  end

  def vote
    @survey_date = SurveyDate.find(params[:survey_date_id])
    if current_user.voted_up_on? @survey_date
      # Downvote Survey Date
      @survey_date.unliked_by current_user
      render json: {
          survey_date: @survey_date,
          number_of_votes: @survey_date.votes_for.size,
          html_list_of_voters: @survey_date.get_html_list_of_voters,
          message: "downvote"
      }
    else
      # Vote for survey date
      @survey_date.liked_by current_user
      render json: {
          survey_date: @survey_date,
          number_of_votes: @survey_date.votes_for.size,
          html_list_of_voters: @survey_date.get_html_list_of_voters,
          message: "vote"
      }
    end
  end

  private

  def find_survey
    @survey = Survey.find(params[:id])
    authorize @survey
  end
end