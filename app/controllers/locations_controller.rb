class LocationsController < ApplicationController
  before_action :set_location, only: %i[show edit update destroy]

  def show; end

  def new
    @location = Location.new
    authorize @location
  end

  def create
    @location = Location.new(location_params)
    authorize @location
    if @location.save
      ok_status
    else
      error_status
    end
  end

  def index
    @locations = Location.all.page(params[:page])
  end

  def edit; end

  def destroy
    authorize @location
    @location.destroy
    redirect_to location_path
  end

  def update
    authorize @location
    if @location.update(location_params)
      ok_status
    else
      error_status
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :active)
  end

  def set_location
    @location = Location.find(params[:id])
  rescue StandardError
    redirect_to_path(locations_path)
  end

  def ok_status
    respond_to do |format|
      format.html { redirect_to locations_path }
      format.json { render :show, status: :created, location: @location }
    end
  end

  def error_status
    format.html { render :edit }
    format.json { render json: @location.errors, status: :unprocessable_entity }
  end
end