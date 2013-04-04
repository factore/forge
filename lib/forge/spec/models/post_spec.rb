require 'spec_helper'

describe Post do
  before do
    @post = Post.new :title => "Title", :content => "Content", :excerpt => "Excerpt"
  end

  it "doesn't update created_at unless asked to" do
    original_date = 3.days.ago
    @post.created_at = original_date
    @post.save
    @post.created_at.strftime("%m/%d/%Y %l:%M%p").should == original_date.strftime("%m/%d/%Y %l:%M%p")
  end

  it "successfully updates created_at when given valid paramters" do
    time = Time.local(1985, 11, 24, 9, 0)
    @post.created_at_date = "1985-11-24"
    @post.created_at_time = "9:00AM"

    @post.save!
    @post.created_at.should == time
  end

  it "should raise an error when given junky data on created_at_date" do
    @post.created_at_date = "100-21-1942"
    @post.save
    @post.errors_on(:created_at_date).should_not be_nil
  end

  it "should raise an error when given junky data on created_at_time" do
    @post.created_at_time = "25:14AM"
    @post.save
    @post.errors_on(:created_at_time).should_not be_nil
  end
end