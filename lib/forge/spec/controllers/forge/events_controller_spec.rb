require 'spec_helper'

describe Forge::EventsController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET events/new" do
      before do
        get :new
      end
    
      it "should assign @event" do
        assigns[:event].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET events/:id/edit" do
      before do
        @event = mock_model(Event)
        Event.should_receive(:find).with("1").and_return(@event)
        get :edit, :id => 1
      end
    
      it "should assign @event" do
        assigns[:event].should == @event
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST events/" do
      def do_create
        post :create, :event => {}
      end
    
      describe "with valid attributes" do    
        before do
          @event = mock_model(Event, :save => true)
          Event.stub!(:new).and_return(@event)
        end
      
        it "should assign @event" do
          do_create
          assigns[:event].should == @event
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_events_path)
        end
      
        it "should be valid" do
          @event.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @event = mock_model(Event, :save => false)
          Event.stub!(:new).and_return(@event)
        end
      
        it "should assign @event" do
          do_create
          assigns[:event].should == @event
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
          @event.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT events/:id" do
      def do_update
        put :update, :id => "1", :event => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @event = mock_model(Event, :update_attributes => true)
          Event.stub!(:find).with("1").and_return(@event)
        end
  
        it "should find event and return object" do
          do_update
          assigns[:event].should == @event
        end
  
        it "should update the event object's attributes" do
          @event.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the event index page" do
          do_update
          response.should redirect_to(forge_events_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @event = mock_model(Event, :update_attributes => false)
          Event.stub!(:find).with("1").and_return(@event)
        end
  
        it "should find event and return object" do
          do_update
          assigns[:event].should == @event
        end
  
        it "should update the event object's attributes" do
          @event.should_receive(:update_attributes)
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
    describe "DELETE /events/:id" do
      it "should delete" do
        @event = mock_model(Event)
        Event.stub!(:find).and_return(@event)
        @event.should_receive(:destroy)
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