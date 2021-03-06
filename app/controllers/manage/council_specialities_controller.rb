class Manage::CouncilSpecialitiesController < Manage::ApplicationController
  load_and_authorize_resource

  def index
    render partial: 'manage/angular/council_specialities', locals: { specialities: @council_specialities }
  end

  def show
    render partial: 'manage/angular/council_speciality', locals: { speciality: @council_speciality }
  end

  def update
    @council_speciality.update speciality_params
    render partial: 'manage/angular/council_speciality', locals: { speciality: @council_speciality }
  end

  def search
    @result = Searcher::CouncilSpecialitySearcher.new(search_params).collection
    render partial: 'manage/angular/council_specialities', locals: { specialities: @result }
  end

  def create
    @speciality = CouncilSpeciality.where(speciality_params).first_or_create
    associate_council_with_speciality if params[:council_id]
    render partial: 'manage/angular/council_speciality', locals: { speciality: @speciality }
  end

  def remove_from_council
    association = CouncilSpecialitiesDissertationCouncil
      .find_by(council_speciality_id:   params[:id],
               dissertation_council_id: params[:council_id])

    render json: !!association.destroy
  end

  def update_order
    association  = CouncilSpecialitiesDissertationCouncil
      .find_by(council_speciality_id:   params[:id],
               dissertation_council_id: params[:council_id])

    render json: association.update_attribute(:row_order_position, params[:index])
  end

  private

  def search_params
    %w(q ids).each_with_object({}){ |key, hash| hash[key.to_sym] = params[key] }
  end

  def speciality_params
    params.require(:speciality).permit(:id, :title, :code, :science_type)
  end

  def associate_council_with_speciality
    council = DissertationCouncil.find(params[:council_id])
    CouncilSpecialitiesDissertationCouncil
      .where(dissertation_council: council, council_speciality: @speciality)
      .first_or_create
  end
end
