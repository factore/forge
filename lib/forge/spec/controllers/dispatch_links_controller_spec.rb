require 'spec_helper'

describe DispatchLinksController do
  fixtures :all
  
  before do
    @dispatch_link = dispatch_links(:google)
  end
  
  it "should record a click" do
    lambda {
      get 'show', :id => @dispatch_link.position, :dispatch_id => @dispatch_link.dispatch_id
    }.should change(DispatchLinkClick, :count).by(1)
  end
  
  it "should redirect" do
    get 'show', :id => @dispatch_link.position, :dispatch_id => @dispatch_link.dispatch_id
    response.should redirect_to(@dispatch_link.uri)
  end
  
  it "should be nested" do
    dispatch_link_path(@dispatch_link.dispatch_id, @dispatch_link.position).should == "/dispatches/#{@dispatch_link.dispatch_id}/links/#{@dispatch_link.position}"
  end
end
