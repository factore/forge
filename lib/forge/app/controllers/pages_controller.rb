class PagesController < ApplicationController
  caches_page :show

  def show
    @page = current_user.blank? ? Page.published.find_by_path!("/#{params[:slugs]}") : Page.find_by_path!("/#{params[:slugs]}")
    @page_title = @page.seo_title.blank? ? @page.title : @page.seo_title

    if @page.key == "contact-us"
      redirect_to contact_index_path if @page.key == "contact-us"
    else
      respond_to do |format|
        format.html {  }
        format.mobile { render :template => "mobile/page" }
      end
    end
  end

  def preview
    @page = Page.new(params[:page])
    @page_title = @page.seo_title.blank? ? @page.title : @page.seo_title
    unless @page.published?
      flash[:warning] = "This page is not yet published and will not appear on your live website."
    end
    render :action => :show
  end
end
