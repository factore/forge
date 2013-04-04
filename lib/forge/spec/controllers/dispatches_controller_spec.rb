require 'spec_helper'

require 'delayed_job_spec_helper'

describe DispatchesController do
  include DelayedJobSpecHelper
  fixtures :all

  it "should record an open" do
    @dispatch = dispatches(:unsent)
    send_dispatch(@dispatch)
    lambda {
      get :read, :id => @dispatch.id, :email => Subscriber.first.email
      response.should be_success, response.body
    }.should change(DispatchOpen, :count).by(1)
  end

  it "should record an unsubscribe" do
    @dispatch = dispatches(:unsent)
    send_dispatch(@dispatch)
    lambda {
      get :unsubscribe, :id => @dispatch.id, :s_id => Subscriber.first.id, :email => Subscriber.first.email
      response.should be_redirect
    }.should change(DispatchUnsubscribe, :count).by(1)
  end

  it "should fail an unsubscribe if the subscriber email and id don't match" do
    @dispatch = dispatches(:unsent)
    send_dispatch(@dispatch)
    lambda { get :unsubscribe, :id => @dispatch.id, :s_id => Subscriber.first.id + 340, :email => Subscriber.first.email }.should raise_error
  end
end

def send_dispatch(dispatch)
  dispatch.deliver!
  work_off
  work_off
end