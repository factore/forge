class ProductsController < ApplicationController
  before_filter :get_cart_order

  # GET /products
  # GET /products.xml
  def index
    @products = Product.published.find(:all, :order => "featured DESC, title")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  
  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    @page_title = @product.seo_title.blank? ? @product.title : @product.seo_title
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  def preview
    flash[:notice] = "Please note that product images do not appear in previews."
    @product = Product.new(params[:product])
    render :action => :show
  end

end
