require 'spec_helper'

describe 'A product' do
  fixtures :products

  context 'being viewed by a search engine' do
    before do
      @product = products(:with_seo)
      visit product_path(@product)
    end

    it "should contain the SEO meta description" do
      within('head') do
        page.should have_css("meta[name=\"description\"][content=\"#{@product.seo_description}\"]")
      end
    end

    it "should contain the SEO meta keywords" do
      within('head') do
        page.should have_css("meta[name=\"keywords\"][content=\"#{@product.seo_keywords}\"]")
      end
    end
  end
end