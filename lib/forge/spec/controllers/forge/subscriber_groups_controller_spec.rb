require 'spec_helper'

describe Forge::SubscriberGroupsController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET subscriber_groups/new" do
      before do
        get :new
      end
    
      it "should assign @subscriber_group" do
        assigns[:subscriber_group].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET subscriber_groups/:id/edit" do
      before do
        @subscriber_group = mock_model(SubscriberGroup)
        SubscriberGroup.should_receive(:find).with("1").and_return(@subscriber_group)
        get :edit, :id => 1
      end
    
      it "should assign @subscriber_group" do
        assigns[:subscriber_group].should == @subscriber_group
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST subscriber_groups/" do
      def do_create
        post :create, :subscriber_group => {}
      end
    
      describe "with valid attributes" do    
        before do
          @subscriber_group = mock_model(SubscriberGroup, :save => true)
          SubscriberGroup.stub!(:new).and_return(@subscriber_group)
        end
      
        it "should assign @subscriber_group" do
          do_create
          assigns[:subscriber_group].should == @subscriber_group
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_subscriber_groups_path)
        end
      
        it "should be valid" do
          @subscriber_group.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @subscriber_group = mock_model(SubscriberGroup, :save => false)
          SubscriberGroup.stub!(:new).and_return(@subscriber_group)
        end
      
        it "should assign @subscriber_group" do
          do_create
          assigns[:subscriber_group].should == @subscriber_group
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
          @subscriber_group.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT subscriber_groups/:id" do
      def do_update
        put :update, :id => "1", :subscriber_group => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @subscriber_group = mock_model(SubscriberGroup, :update_attributes => true)
          SubscriberGroup.stub!(:find).with("1").and_return(@subscriber_group)
        end
  
        it "should find subscriber_group and return object" do
          do_update
          assigns[:subscriber_group].should == @subscriber_group
        end
  
        it "should update the subscriber_group object's attributes" do
          @subscriber_group.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the subscriber_group index page" do
          do_update
          response.should redirect_to(forge_subscriber_groups_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @subscriber_group = mock_model(SubscriberGroup, :update_attributes => false)
          SubscriberGroup.stub!(:find).with("1").and_return(@subscriber_group)
        end
  
        it "should find subscriber_group and return object" do
          do_update
          assigns[:subscriber_group].should == @subscriber_group
        end
  
        it "should update the subscriber_group object's attributes" do
          @subscriber_group.should_receive(:update_attributes)
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
    describe "DELETE /subscriber_groups/:id" do
      it "should delete" do
        @subscriber_group = mock_model(SubscriberGroup)
        SubscriberGroup.stub!(:find).and_return(@subscriber_group)
        @subscriber_group.should_receive(:destroy)
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