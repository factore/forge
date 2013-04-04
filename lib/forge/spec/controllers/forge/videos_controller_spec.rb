require 'spec_helper'
class S3DirectUpload
  def initialize
  end
end

describe Forge::VideosController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))

    end

    # NEW
    describe "GET videos/new" do
      before do
        get :new
      end

      it "should assign @video" do
        assigns[:video].should_not be_nil
      end

      it "should render the new template" do
        response.should render_template('new')
      end
    end

    # EDIT
    describe "GET videos/:id/edit" do
      before do
        @video = mock_model(Video)
        Video.should_receive(:find).with("1").and_return(@video)
        get :edit, :id => 1
      end

      it "should assign @video" do
        assigns[:video].should == @video
      end

      it "should render the edit template" do
        response.should render_template('edit')
      end
    end


    # CREATE
    describe "POST videos/" do
      def do_create
        post :create, :video => {}
      end

      describe "with valid attributes" do
        before do
          @video = mock_model(Video, :save => true)
          Video.stub!(:new).and_return(@video)
        end

        it "should assign @video" do
          do_create
          assigns[:video].should == @video
        end

        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end

        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_videos_path)
        end

        it "should be valid" do
          @video.should_receive(:save).and_return(:true)
          do_create
        end
      end

      describe "with invalid attributes" do
        before do
          @video = mock_model(Video, :save => false)
          Video.stub!(:new).and_return(@video)
        end

        it "should assign @video" do
          do_create
          assigns[:video].should == @video
        end

        it "should not set the flash notice" do
          do_create
          flash[:notice].should be_nil
        end

        it "should render the new template" do
          do_create
          response.should render_template('new')
        end

        it "should not save" do
          @video.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end

    # UPDATE
    describe "PUT videos/:id" do
      def do_update
        put :update, :id => "1", :video => {}
      end

      describe "with valid params" do
        before(:each) do
          @video = mock_model(Video, :update_attributes => true)
          Video.stub!(:find).with("1").and_return(@video)
        end

        it "should find video and return object" do
          do_update
          assigns[:video].should == @video
        end

        it "should update the video object's attributes" do
          @video.should_receive(:update_attributes)
          do_update
        end

        it "should redirect to the video index page" do
          do_update
          response.should redirect_to(forge_videos_path)
        end
      end

      describe "with invalid params" do
        before(:each) do
          @video = mock_model(Video, :update_attributes => false)
          Video.stub!(:find).with("1").and_return(@video)
        end

        it "should find video and return object" do
          do_update
          assigns[:video].should == @video
        end

        it "should update the video object's attributes" do
          @video.should_receive(:update_attributes)
          do_update
        end

        it "should render the edit form" do
          do_update
          response.should render_template('edit')
        end

        it "should not have a flash notice" do
          do_update
          flash[:notice].should be_blank
        end
      end

    end

    # DESTROY
    describe "DELETE /videos/:id" do
      it "should delete" do
        @video = mock_model(Video)
        Video.stub!(:find).and_return(@video)
        @video.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end

    # ENCODE
    describe "GET /videos/:id/encode" do
      def do_encode
        get :encode, :id => 1
      end

      before do
        @video = mock_model(Video)
        Video.stub!(:find).and_return(@video)
        @video.stub!(:encode).and_return(mock('response', :success? => true))
      end

      it "should receive encode" do
        @video.should_receive(:encode)
        do_encode
      end

      it "should set the flash notice" do
        do_encode
        flash[:notice].should_not be_nil
      end

      it "should redirect to index" do
        do_encode
        response.should redirect_to(forge_videos_path)
      end
    end

  end


  describe "As someone who's not logged in" do
    before do
      controller.stub!(:current_user).and_return(nil)
    end

    it "should not let you get the new action" do
      get :new
      response.should redirect_to('/login')
    end

    it "should not let you get the edit action" do
      get :edit, :id => 1
      response.should redirect_to('/login')
    end

    it "should not let you get the create action" do
      post :create
      response.should redirect_to('/login')
    end

    it "should not let you get the update action" do
      put :update, :id => 1
      response.should redirect_to('/login')
    end

    it "should not let you get the destroy action" do
      delete :destroy, :id => 1
      response.should redirect_to('/login')
    end

    it "should be able to encode notify" do
      @video = mock_model(Video)
      Video.should_receive(:find_by_job_id!).and_return(@video)
      @video.should_receive(:encode_notify).and_return(true)
      post :encode_notify, {:job => {:id => 1}}
    end
  end
end