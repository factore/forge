require 'spec_helper'

describe Comment do
  describe "when saved" do
    before :each do
      @comment = Comment.new
      @comment.stub(:valid?).and_return(true)
      @comment.stub(:approved?).and_return(true)
    end

    it "creates a comment subscriber" do
      @comment.subscribe = 1
      @comment.stub_chain(:commentable, :subscribers).and_return([])

      CommentSubscriber.should_receive(:create)
      @comment.save
    end

    it "notifies subscribers" do
      @comment.subscribe = 0
      subscriber = mock("subscriber", :email => "something@something.com")
      @comment.stub_chain(:commentable, :subscribers).and_return([subscriber])
      CommentMailer.stub_chain(:comment_notification, :deliver)

      CommentMailer.should_receive(:comment_notification)
      @comment.save
    end
  end
end
