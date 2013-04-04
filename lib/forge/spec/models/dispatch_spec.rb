require 'spec_helper'
require 'delayed_job_spec_helper'

describe Dispatch do
  fixtures :all
  context '#creating' do
    before do
      @dispatch = dispatches(:unsent)
    end
    
    it "should be valid" do
      @dispatch.should be_valid
    end
    
    it "should create 3 dispatch_links upon save" do
      lambda { @dispatch.save }.should change(DispatchLink, :count).by(3)
    end
    
    it "should set display_content" do
      @dispatch.save
      @dispatch.display_content.blank?.should eql(false)
    end
    
    it "should have an encoded link in the display_content" do
      @dispatch.save
      @dispatch.display_content.should match(/\/dispatches\/\d+\/links\/\d+/)
    end
  end
  
  context '#editing and updating' do
    before do
      @dispatch = dispatches(:unsent)
      @dispatch.save
    end
    
    it "should update the urls if you change one" do
      @dispatch.content = "<a href='http://github.com'>Github!</a>"
      @dispatch.save
      @dispatch.dispatch_links.find_by_position(0).uri.should == 'http://github.com'
    end
    
    it "should clear the links that don't exist anymore" do
      @dispatch.content = "Hey <a href='http://google.com'>Google</a>"
      lambda { @dispatch.save }.should change(DispatchLink, :count).by(-2) 
    end
  end
  
  context '#sending' do
    include DelayedJobSpecHelper
    before do
      @dispatch = dispatches(:unsent)
    end
    
    it "should create some delayed jobs" do
      Subscriber.count.should == 2
      lambda { @dispatch.deliver! }.should change(Delayed::Job, :count).by(1) 
    end
    
    it "should create some queued messages" do
      @dispatch.deliver!
      work_off
      QueuedDispatch.count.should == 2
      Delayed::Job.count.should == 2
    end
    
    it "should actually send the messages" do
      @dispatch.save
      @dispatch.deliver!
      work_off
      Delayed::Job.count.should == 2
      work_off # Called twice to do the jobs that the first job queued
      Delayed::Job.count.should == 0
      puts QueuedDispatch.queued
    
      QueuedDispatch.queued.count.should == 0
      QueuedDispatch.sent.count.should == 2
      Delayed::Job.count.should == 0
    end
    
  end
end
    
    