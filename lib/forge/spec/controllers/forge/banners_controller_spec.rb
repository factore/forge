require 'spec_helper'

describe Forge::BannersController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET banners/new" do
      before do
        get :new
      end
    
      it "should assign @banner" do
        assigns[:banner].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET banners/:id/edit" do
      before do
        @banner = mock_model(Banner)
        Banner.should_receive(:find).with("1").and_return(@banner)
        get :edit, :id => 1
      end
    
      it "should assign @banner" do
        assigns[:banner].should == @banner
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST banners/" do
      def do_create
        post :create, :banner => {}
      end
    
      describe "with valid attributes" do    
        before do
          @banner = mock_model(Banner, :save => true)
          Banner.stub!(:new).and_return(@banner)
        end
      
        it "should assign @banner" do
          do_create
          assigns[:banner].should == @banner
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_banners_path)
        end
      
        it "should be valid" do
          @banner.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @banner = mock_model(Banner, :save => false)
          Banner.stub!(:new).and_return(@banner)
        end
      
        it "should assign @banner" do
          do_create
          assigns[:banner].should == @banner
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
          @banner.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT banners/:id" do
      def do_update
        put :update, :id => "1", :banner => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @banner = mock_model(Banner, :update_attributes => true)
          Banner.stub!(:find).with("1").and_return(@banner)
        end
  
        it "should find banner and return object" do
          do_update
          assigns[:banner].should == @banner
        end
  
        it "should update the banner object's attributes" do
          @banner.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the banner index page" do
          do_update
          response.should redirect_to(forge_banners_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @banner = mock_model(Banner, :update_attributes => false)
          Banner.stub!(:find).with("1").and_return(@banner)
        end
  
        it "should find banner and return object" do
          do_update
          assigns[:banner].should == @banner
        end
  
        it "should update the banner object's attributes" do
          @banner.should_receive(:update_attributes)
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
    describe "DELETE /banners/:id" do
      it "should delete" do
        @banner = mock_model(Banner)
        Banner.stub!(:find).and_return(@banner)
        @banner.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
    
    # REORDER
    describe "POST /banners/reorder" do
      it "should call reorder" do
        Banner.should_receive(:reorder!).with(["1","2","3"]).and_return(nil)
        post :reorder, :banner_list => ["1","2","3"]
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
  end
end