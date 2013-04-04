require 'spec_helper'

describe Event do
  before do
    @event = Event.create(
      :title => "Title",
      :location => "Location",
      :description => "Description",
      :starts_at => Time.now,
      :published => true)

    @older_event = Event.create(
      :title => "Older Title",
      :location => "Older Location",
      :description => "Older Description",
      :starts_at => Time.mktime(1970, 1, 1),
      :published => true)
  end

  it "doesn't update starts_at unless asked to" do
    original_date = 3.days.ago
    @event.starts_at = original_date
    @event.ends_at = 2.days.ago
    @event.save
    @event.starts_at.strftime("%m/%d/%Y %l:%M%p").should == original_date.strftime("%m/%d/%Y %l:%M%p")
  end

  it "doesn't update ends_at unless asked to" do
    original_date = 3.days.ago
    @event.ends_at = original_date
    @event.starts_at = 4.days.ago
    @event.save
    @event.ends_at.strftime("%m/%d/%Y %l:%M%p").should == original_date.strftime("%m/%d/%Y %l:%M%p")
  end

  it "successfully updates starts_at when given valid paramters" do
    time = Time.local(1985, 11, 24, 9, 0)
    @event.starts_at_date = "1985-11-24"
    @event.starts_at_time = "9:00AM"

    @event.save!
    @event.starts_at.should == time
  end

  it "successfully updates ends_at when given valid parameters" do
    time = Time.local(1985, 11, 24, 9, 0)
    @event.ends_at_date = "1985-11-24"
    @event.ends_at_time = "9:00AM"

    @event.save!
    @event.ends_at.should == time
  end

  it "should raise an error when given junky data on starts_at_date" do
    @event.starts_at_date = "100/21/1942"
    @event.save
    @event.errors_on(:starts_at_date).should_not be_nil
  end

  it "should raise an error when given junky data on ends_at_date" do
    @event.ends_at_date = "100/21/1942"
    @event.save
    @event.errors_on(:ends_at_date).should_not be_nil
  end

  it "should raise an error when given junky data on starts_at_time" do
    @event.starts_at_time = "25:14AM"
    @event.save
    @event.errors_on(:starts_at_time).should_not be_nil
  end

  it "should raise an error when given junky data on ends_at_time" do
    @event.ends_at_time = "25:14AM"
    @event.save
    @event.errors_on(:ends_at_time).should_not be_nil
  end

  context '#next' do
    it 'returns the next newest event by starts_at' do
      @older_event.next.should == @event
    end
  end

  context '#previous' do
    it 'returns the next oldest event by starts_at' do
      @event.previous.should == @older_event
    end
  end

  context '.on' do
    it 'finds events in a given year' do
      Event.on(@event.starts_at.year).should == [@event]
    end

    it 'finds events in a given month' do
      Event.on(@event.starts_at.year, @event.starts_at.month).should == [@event]
    end

    it 'finds events on a given day' do
      Event.on(@event.starts_at.year, @event.starts_at.month, @event.starts_at.day).should == [@event]
    end
  end
end


