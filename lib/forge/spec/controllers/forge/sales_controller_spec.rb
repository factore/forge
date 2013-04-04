require 'spec_helper'

describe Forge::SalesController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET sales/new" do
      before do
        get :new
      end
    
      it "should assign @sale" do
        assigns[:sale].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET sales/:id/edit" do
      before do
        @sale = mock_model(Sale)
        Sale.should_receive(:find).with("1").and_return(@sale)
        get :edit, :id => 1
      end
    
      it "should assign @sale" do
        assigns[:sale].should == @sale
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST sales/" do
      def do_create
        post :create, :sale => {}
      end
    
      describe "with valid attributes" do    
        before do
          @sale = mock_model(Sale, :save => true)
          Sale.stub!(:new).and_return(@sale)
        end
      
        it "should assign @sale" do
          do_create
          assigns[:sale].should == @sale
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_sales_path)
        end
      
        it "should be valid" do
          @sale.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @sale = mock_model(Sale, :save => false)
          Sale.stub!(:new).and_return(@sale)
        end
      
        it "should assign @sale" do
          do_create
          assigns[:sale].should == @sale
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
          @sale.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT sales/:id" do
      def do_update
        put :update, :id => "1", :sale => {:product_ids => "1,2,3"}
      end    
    
      describe "with valid params" do
        before(:each) do
          @sale = mock_model(Sale, :update_attributes => true)
          Sale.stub!(:find).with("1").and_return(@sale)
        end
  
        it "should find sale and return object" do
          do_update
          assigns[:sale].should == @sale
        end
  
        it "should update the sale object's attributes" do
          @sale.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the sale index page" do
          do_update
          response.should redirect_to(forge_sales_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @sale = mock_model(Sale, :update_attributes => false)
          Sale.stub!(:find).with("1").and_return(@sale)
        end
  
        it "should find sale and return object" do
          do_update
          assigns[:sale].should == @sale
        end
  
        it "should update the sale object's attributes" do
          @sale.should_receive(:update_attributes)
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
    describe "DELETE /sales/:id" do
      it "should delete" do
        @sale = mock_model(Sale)
        Sale.stub!(:find).and_return(@sale)
        @sale.should_receive(:destroy)
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