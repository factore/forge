require 'spec_helper'

describe Forge::OrdersController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET orders/new" do
      before do
        get :new
      end
    
      it "should assign @order" do
        assigns[:order].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET orders/:id/edit" do
      before do
        @order = mock_model(Order)
        Order.should_receive(:find).with("1").and_return(@order)
        get :edit, :id => 1
      end
    
      it "should assign @order" do
        assigns[:order].should == @order
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST orders/" do
      def do_create
        post :create, :order => {}
      end
    
      describe "with valid attributes" do    
        before do
          @order = mock_model(Order, :save => true)
          Order.stub!(:new).and_return(@order)
        end
      
        it "should assign @order" do
          do_create
          assigns[:order].should == @order
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_orders_path)
        end
      
        it "should be valid" do
          @order.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @order = mock_model(Order, :save => false)
          Order.stub!(:new).and_return(@order)
        end
      
        it "should assign @order" do
          do_create
          assigns[:order].should == @order
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
          @order.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT orders/:id" do
      def do_update
        put :update, :id => "1", :order => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @order = mock_model(Order, :update_attributes => true)
          Order.stub!(:find).with("1").and_return(@order)
        end
  
        it "should find order and return object" do
          do_update
          assigns[:order].should == @order
        end
  
        it "should update the order object's attributes" do
          @order.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the order index page" do
          do_update
          response.should redirect_to(forge_orders_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @order = mock_model(Order, :update_attributes => false)
          Order.stub!(:find).with("1").and_return(@order)
        end
  
        it "should find order and return object" do
          do_update
          assigns[:order].should == @order
        end
  
        it "should update the order object's attributes" do
          @order.should_receive(:update_attributes)
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
    describe "DELETE /orders/:id" do
      it "should delete" do
        @order = mock_model(Order)
        Order.stub!(:find).and_return(@order)
        @order.should_receive(:destroy)
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