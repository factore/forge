require 'spec_helper'

describe require 'spec_helper'

describe Forge::DispatchesController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET dispatches/new" do
      before do
        get :new
      end
    
      it "should assign @dispatch" do
        assigns[:dispatch].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET dispatches/:id/edit" do
      before do
        @dispatch = mock_model(Dispatch)
        Dispatch.should_receive(:find).with("1").and_return(@dispatch)
        get :edit, :id => 1
      end
    
      it "should assign @dispatch" do
        assigns[:dispatch].should == @dispatch
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST dispatches/" do
      def do_create
        post :create, :dispatch => {}
      end
    
      describe "with valid attributes" do    
        before do
          @dispatch = mock_model(Dispatch, :save => true)
          Dispatch.stub!(:new).and_return(@dispatch)
        end
      
        it "should assign @dispatch" do
          do_create
          assigns[:dispatch].should == @dispatch
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_dispatches_path)
        end
      
        it "should be valid" do
          @dispatch.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @dispatch = mock_model(Dispatch, :save => false)
          Dispatch.stub!(:new).and_return(@dispatch)
        end
      
        it "should assign @dispatch" do
          do_create
          assigns[:dispatch].should == @dispatch
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
          @dispatch.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT dispatches/:id" do
      def do_update
        put :update, :id => "1", :dispatch => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @dispatch = mock_model(Dispatch, :update_attributes => true)
          Dispatch.stub!(:find).with("1").and_return(@dispatch)
        end
  
        it "should find dispatch and return object" do
          do_update
          assigns[:dispatch].should == @dispatch
        end
  
        it "should update the dispatch object's attributes" do
          @dispatch.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the dispatch index page" do
          do_update
          response.should redirect_to(forge_dispatches_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @dispatch = mock_model(Dispatch, :update_attributes => false)
          Dispatch.stub!(:find).with("1").and_return(@dispatch)
        end
  
        it "should find dispatch and return object" do
          do_update
          assigns[:dispatch].should == @dispatch
        end
  
        it "should update the dispatch object's attributes" do
          @dispatch.should_receive(:update_attributes)
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
    describe "DELETE /dispatches/:id" do
      it "should delete" do
        @dispatch = mock_model(Dispatch)
        Dispatch.stub!(:find).and_return(@dispatch)
        @dispatch.should_receive(:destroy)
        delete :destroy, :id => 1
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