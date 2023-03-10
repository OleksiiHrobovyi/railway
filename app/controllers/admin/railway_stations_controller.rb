module Admin
  class RailwayStationsController < Admin::BaseController
    before_action :set_railway_station, only: %i[show edit update destroy update_position update_time]

    def index
      @railway_stations = RailwayStation.all
    end

    def show; end

    def new
      @railway_station = RailwayStation.new
    end

    def edit; end

    def create
      @railway_station = RailwayStation.new(railway_station_params)

      respond_to do |format|
        if @railway_station.save
          format.html { redirect_to admin_railway_station_path(@railway_station), notice: 'Railway station was successfully created.' }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @railway_station.update(railway_station_params)
          format.html { redirect_to admin_railway_station_path(@railway_station), notice: 'Railway station was successfully updated.' }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def update_position
      route = Route.find(params[:route_id])
      if @railway_station.update_position(route, params[:number])
        redirect_to admin_routes_path(route), notice: 'Station index was successfully updated.'
      else
        redirect_to admin_routes_path(route)
      end
    end

    def update_time
      route = Route.find(params[:route_id])
      if @railway_station.update_arrival_time(route, params[:arrival_time]) \
       && @railway_station.update_departure_time(route, params[:departure_time])
        redirect_to admin_routes_path(route), notice: 'Times were successfully updated.'
      else
        redirect_to admin_routes_path(route)
      end
    end

    def destroy
      @railway_station.destroy
      respond_to do |format|
        format.html { redirect_to admin_railway_stations_url, notice: 'Railway station was successfully destroyed.' }
      end
    end

    private

    def set_railway_station
      @railway_station = RailwayStation.find(params[:id])
    end

    def railway_station_params
      params.require(:railway_station).permit(:title, :number, :arrival_time, :departure_time)
    end
  end
end
