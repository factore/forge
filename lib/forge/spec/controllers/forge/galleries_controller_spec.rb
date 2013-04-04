require 'spec_helper'

describe Forge::GalleriesController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET galleries/new" do
      before do
        get :new
      end
    
      it "should assign @gallery" do
        assigns[:gallery].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET galleries/:id/edit" do
      before do
        @gallery = mock_model(Gallery)
        Gallery.should_receive(:find_with_photos).and_return(@gallery)
      end

      it "should assign @gallery" do
        get :edit, :id => 1
        assigns[:gallery].should == @gallery
      end

      it "should render the edit template" do
        get :edit, :id => 1
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST galleries/" do
      def do_create
        post :create, :gallery => {}
      end
    
      describe "with valid attributes" do    
        before do
          @gallery = mock_model(Gallery, :save => true)
          Gallery.stub!(:new).and_return(@gallery)
        end
      
        it "should assign @gallery" do
          do_create
          assigns[:gallery].should == @gallery
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_galleries_path)
        end
      
        it "should be valid" do
          @gallery.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @gallery = mock_model(Gallery, :save => false)
          Gallery.stub!(:new).and_return(@gallery)
        end
      
        it "should assign @gallery" do
          do_create
          assigns[:gallery].should == @gallery
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
          @gallery.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT galleries/:id" do
      def do_update
        put :update, :id => "1", :gallery => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @gallery = mock_model(Gallery, :update_attributes => true)
          Gallery.stub!(:find).with("1").and_return(@gallery)
        end
  
        it "should find gallery and return object" do
          do_update
          assigns[:gallery].should == @gallery
        end
  
        it "should update the gallery object's attributes" do
          @gallery.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the gallery index page" do
          do_update
          response.should redirect_to(edit_forge_gallery_path(@gallery))
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @gallery = mock_model(Gallery, :update_attributes => false)
          Gallery.stub!(:find).with("1").and_return(@gallery)
        end
  
        it "should find gallery and return object" do
          do_update
          assigns[:gallery].should == @gallery
        end
  
        it "should update the gallery object's attributes" do
          @gallery.should_receive(:update_attributes)
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
    describe "DELETE /galleries/:id" do
      it "should delete" do
        @gallery = mock_model(Gallery)
        Gallery.stub!(:find).and_return(@gallery)
        @gallery.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
    
    # REORDER
    describe "POST /galleries/reorder" do
      it "should call reorder" do
        Gallery.should_receive(:reorder!).with(["1","2","3"]).and_return(nil)
        post :reorder, :gallery_list => ["1","2","3"]
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