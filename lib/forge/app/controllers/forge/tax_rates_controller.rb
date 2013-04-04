class Forge::TaxRatesController < ForgeController
  load_and_authorize_resource

  def index
    @tax_rate = TaxRate.new
    respond_to do |format|
      format.html { get_tax_rates }
      format.js {
        @tax_rates = TaxRate.where("title LIKE ?", "%#{params[:q]}%")
        render :partial => "tax_rate", :collection => @tax_rates
      }
    end
  end

  def edit
    render :layout => false
  end

  def create
    @tax_rate = TaxRate.new(params[:tax_rate])
    if @tax_rate.save
      flash[:notice] = 'Tax rate was successfully created.'
      redirect_to(forge_tax_rates_path)
    else
      get_tax_rates
      render :action => "index"
    end
  end

  def update
    if @tax_rate.update_attributes(params[:tax_rate])
      flash[:notice] = 'Tax rate was successfully updated.'
      redirect_to(forge_tax_rates_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @tax_rate.destroy
    redirect_to(forge_tax_rates_path)
  end


  private

    def get_tax_rates
      @tax_rates = TaxRate.by_country_and_province.paginate(:per_page => 10, :page => params[:page])
    end
end
