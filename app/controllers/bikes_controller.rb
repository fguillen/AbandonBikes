class BikesController < ApplicationController
  def index
    @bikes = Bike.geolocalized

    render :map
  end

  def show
    @bike = Bike.find(params[:id])
  end

  def new
    @bike = Bike.new
  end

  def edit
    @bike = Bike.find(params[:id])
  end

  def create
    @bike = Bike.new(params[:bike])

    respond_to do |format|
      if @bike.save
        format.html { redirect_to @bike, :notice => 'Bike was successfully created.' }
        format.json { render :json => @bike, :status => :created, :location => @bike }
      else
        format.html { render :action => "new" }
        format.json { render :json => @bike.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @bike = Bike.find(params[:id])

    respond_to do |format|
      if @bike.update_attributes(params[:bike])
        format.html { redirect_to @bike, :notice => 'Bike was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @bike.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bikes/1
  # DELETE /bikes/1.json
  def destroy
    @bike = Bike.find(params[:id])
    @bike.destroy

    respond_to do |format|
      format.html { redirect_to bikes_url }
      format.json { head :ok }
    end
  end
end
