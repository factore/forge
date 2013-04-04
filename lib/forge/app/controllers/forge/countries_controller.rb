class Forge::CountriesController < ForgeController
  load_and_authorize_resource
  
  def index
    @active_countries = Country.active.all
    @countries = Country.alphabetical.all
  end 

  def update
    @country.update_attributes(params[:country])
    respond_to do |format|
      format.js { render :nothing => true}
    end
  end
  
  def get_provinces
    if params[:id]
      @provinces = Country.find(params[:id]).province_options_for_select(:add_blank => true)
      respond_to do |format|
        format.js {render :json => @provinces}
      end
    end
  end

  def get_active_countries
    @countries = Country.active.all.map {|country| country.title}
    respond_to do |format|
      format.js {render :json => @countries}
    end
  end
end
