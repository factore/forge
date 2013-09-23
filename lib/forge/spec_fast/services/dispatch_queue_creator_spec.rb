class DispatchQueueCreator
  class << self
    def self.handle_asynchronously(*args)
    end
  end
end

require_relative '../../app/services/dispatch_queue_creator'

describe DispatchQueueCreator do

  before do
    Subscriber = Struct.new(:email, :name, :id) unless defined?(Subscriber)
    SubscriberGroup = Struct.new(:title) unless defined?(SubscriberGroup)
    Dispatch = double.as_null_object unless defined?(Dispatch)
    Dispatch.stub(:id).and_return(1)
    QueuedDispatch = double.as_null_object unless defined?(QueuedDispatch)
    Job = double.as_null_object unless defined?(Job)
  end

  context "sending to subscribers" do
    before do
      Subscriber.stub(:all).and_return(build_subscribers(5))
    end

    it "should create a series of queued dispatches, one for each subscriber" do
      dispatch = Dispatch.new
      QueuedDispatch.should_receive(:send_dispatch_to_object_with_name_and_email!).exactly(5).times
      DispatchQueueCreator.send_to_all_subscribers!(dispatch)
    end
  end

  context "sending to groups" do
    before do
      SubscriberGroup.stub(:subscribers_from_group_ids).and_return(build_subscribers(10))
    end

    it "should create a series of queued dispatches, one for each subscriber" do
      dispatch = Dispatch.new
      QueuedDispatch.should_receive(:send_dispatch_to_object_with_name_and_email!).exactly(10).times
      DispatchQueueCreator.send_to_groups!(dispatch, [1,2])
    end

  end

  # for this test, we'll use the unsuccessful applicants on a job
  context "sending to any object that provides me with a list of recipients" do
    before do
      Job.stub(:unsuccessful_applicants).and_return(build_subscribers(2))
    end

    it "should create a series of queued dispatches, one for each subscriber" do
      dispatch = Dispatch.new
      QueuedDispatch.should_receive(:send_dispatch_to_object_with_name_and_email!).exactly(2).times
      DispatchQueueCreator.send_to_subscribers_from_object!(dispatch, Job, :unsuccessful_applicants)
    end

  end

  def build_subscribers(number)
    subscribers = []
    number.times do |i|
      subscribers << Subscriber.new("test#{i}@example.com", "Test Van #{i}", i)
    end
    subscribers
  end

end
