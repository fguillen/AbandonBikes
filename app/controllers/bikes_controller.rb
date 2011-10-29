class BikesController < ApplicationController
  def index
    @bikes = Bike.geolocalized
    render :json => @bikes.map( &:to_hash )
  end

  def show
    @bike = Bike.find( params[:id] )
    render :json => @bike.to_hash
  end
end
