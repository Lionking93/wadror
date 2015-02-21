class PlacesController < ApplicationController
  def index

  end

  def search
    if params[:city].empty?
      params[:city] = "the search field"
      @places = []
    else
      @places = BeermappingApi.places_in(params[:city])
    end
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
    @place = BeermappingApi.show_place(params[:id])
    render :show
  end
end