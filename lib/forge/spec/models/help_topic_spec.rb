require 'spec_helper'

describe "HelpTopic" do
  # Sanity check...
  # This is a valid HelpTopic
  it "valid HelpTopic" do
    help_topic = HelpTopic.new(:language => "en", :slug => "test_slug", :title => "Title", :content => "Content")
    help_topic.should be_valid
  end

  # when content is saved, it is converted to html
  it "content is automatically converted to html when saved" do
    h = HelpTopic.new(:slug => "test_slug", :title => "Test Title", :content => "__Something__")
    h.save
    h.content.should == "<p><strong>Something</strong></p>\n"
  end

  # slug may only contain letters, numbers, underscores and dashes
  it "slug must be correctly formatted" do
    h1 = HelpTopic.new(:slug => "test slug")
    h1.valid?
    h1.errors[:slug].any?.should_not == nil

    h2 = HelpTopic.new(:slug => "test/slug")
    h2.valid?
    h2.errors[:slug].any?.should_not == nil

    h3 = HelpTopic.new(:slug => "test_slug?something=blah")
    h3.valid?
    h3.errors[:slug].any?.should_not == nil

    h4 = HelpTopic.new(:slug => "test_url#something")
    h4.valid?
    h4.errors[:slug].any?.should_not == nil
  end

  # HelpTopic must be unique, based on language+slug
  it "must be unique" do
    h1 = HelpTopic.new(:language => "en", :slug => "test_slug", :title => "Title 1", :content => "Content 1").save
    h2 = HelpTopic.new(:language => "en", :slug => "test_slug", :title => "Title 2", :content => "Content 2")
    h2.valid?
    
    h2.errors[:base].include?("A help topic already exists for that slug in that language").should_not == nil
  end
  
  # HelpTopic uniqueness is only checked on create, not save
  it "must be unique on create only" do
    h = HelpTopic.new(:language => "en", :slug => "test_slug", :title => "Title", :content => "Content")
    h.save
    h.title = "New Title"
   
    h.save .should_not == nil
  end
end
