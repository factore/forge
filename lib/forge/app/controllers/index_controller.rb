class IndexController < ApplicationController
  caches_page :index

  def index
    @page = Page.find_by_key("home")
    respond_to do |format|
      format.html {}
      format.mobile { render :template => "mobile/page" }
    end
  end

  def sitemap
    respond_to do |format|
      format.html do
        @pages = Page.published.all
      end

      format.xml do
        @homepage = Page.find_by_title('Home') # anything that responds to updated_at, for the homepage
        @models = @@models ||= YAML.load(Rails.root.join('config', 'google_sitemap.yml').read)
      end
    end
  end
end
