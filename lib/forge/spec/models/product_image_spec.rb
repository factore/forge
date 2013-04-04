require 'spec_helper'

describe ProductImage do
  fixtures :assets, :product_images
  before do
    @png_asset, @txt_asset = assets(:png), assets(:txt)
    @png_asset.attachment = File.new(File.join(Rails.root, 'spec/fixtures/sample_file.png')) and @png_asset.save
    @txt_asset.attachment = File.new(File.join(Rails.root, 'spec/fixtures/sample_file.txt')) and @txt_asset.save
    @product_image = product_images(:first)
  end
  
  it "should save properly when assigned an image asset" do
    @product_image.image_asset_id = @png_asset.id
    @product_image.save.should_not == nil
  end
end
