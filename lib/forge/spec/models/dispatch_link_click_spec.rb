require 'spec_helper'

describe DispatchLinkClick do
  fixtures :all
  it "should increment the counter_cache on its parent" do
    @dispatch_link = dispatch_links(:google)
    @dispatch_link.clicks.create(:ip => "1.1.1.1").should be_valid
    @dispatch_link.reload.clicks_count.should == 1
    @dispatch_link.clicks.create(:ip => "1.2.1.1").should be_valid
    @dispatch_link.reload.clicks_count.should == 2
  end
end
