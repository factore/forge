class CountriesController < ApplicationController

  def get_provinces_for_checkout
    if params[:id]
      @provinces = Country.find(params[:id]).province_options_for_select()
      respond_to do |format|
        format.js {render :json => @provinces}
      end
    end
  end

end
