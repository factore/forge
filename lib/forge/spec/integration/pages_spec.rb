require 'spec_helper'

describe 'A page' do
  fixtures :all

  context 'being viewed by a search engine' do
    before do
      @page = pages(:with_seo)
      @page.send(:set_slug_and_path)
    end

    it "should contain the SEO fields" do
      visit @page.path
      within('head title') { page.should have_content(@page.seo_title) }
      within('head') do
        page.should have_css("meta[name=\"description\"][content=\"#{@page.seo_description}\"]")
        page.should have_css("meta[name=\"keywords\"][content=\"#{@page.seo_keywords}\"]")
      end
    end
  end
end