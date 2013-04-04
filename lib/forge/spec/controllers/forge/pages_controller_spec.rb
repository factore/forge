require 'spec_helper'

describe Forge::PagesController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET pages/new" do
      before do
        get :new
      end
    
      it "should assign @page" do
        assigns[:page].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET pages/:id/edit" do
      before do
        @page = mock_model(Page)
        Page.should_receive(:find).with("1").and_return(@page)
        get :edit, :id => 1
      end
    
      it "should assign @page" do
        assigns[:page].should == @page
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST pages/" do
      def do_create
        post :create, :page => {}
      end
    
      describe "with valid attributes" do    
        before do
          @page = mock_model(Page, :save => true)
          Page.stub!(:new).and_return(@page)
        end
      
        it "should assign @page" do
          do_create
          assigns[:page].should == @page
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_pages_path)
        end
      
        it "should be valid" do
          @page.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @page = mock_model(Page, :save => false)
          Page.stub!(:new).and_return(@page)
        end
      
        it "should assign @page" do
          do_create
          assigns[:page].should == @page
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
          @page.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT pages/:id" do
      def do_update
        put :update, :id => "1", :page => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @page = mock_model(Page, :update_attributes => true)
          Page.stub!(:find).with("1").and_return(@page)
        end
  
        it "should find page and return object" do
          do_update
          assigns[:page].should == @page
        end
  
        it "should update the page object's attributes" do
          @page.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the page index page" do
          do_update
          response.should redirect_to(forge_pages_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @page = mock_model(Page, :update_attributes => false)
          Page.stub!(:find).with("1").and_return(@page)
        end
  
        it "should find page and return object" do
          do_update
          assigns[:page].should == @page
        end
  
        it "should update the page object's attributes" do
          @page.should_receive(:update_attributes)
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
    describe "DELETE /pages/:id" do
      it "should delete" do
        @page = mock_model(Page, :name => '')
        Page.stub!(:find).and_return(@page)
        @page.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
    
    # REORDER
    describe "POST /pages/reorder" do
      it "should call reorder" do
        Page.should_receive(:reorder!).with(["1","2", "3"], nil).and_return(nil)
        post :reorder, :page_list => ["1", "2", "3"], :parent_id => nil
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