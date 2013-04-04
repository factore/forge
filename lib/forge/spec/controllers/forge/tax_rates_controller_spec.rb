require 'spec_helper'

describe Forge::TaxRatesController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end

  
    # EDIT
    describe "GET tax_rates/:id/edit" do
      before do
        @tax_rate = mock_model(TaxRate)
        TaxRate.should_receive(:find).with("1").and_return(@tax_rate)
        get :edit, :id => 1
      end
    
      it "should assign @tax_rate" do
        assigns[:tax_rate].should == @tax_rate
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST tax_rates/" do
      def do_create
        post :create, :tax_rate => {}
      end
    
      describe "with valid attributes" do    
        before do
          @tax_rate = mock_model(TaxRate, :save => true)
          TaxRate.stub!(:new).and_return(@tax_rate)
        end
      
        it "should assign @tax_rate" do
          do_create
          assigns[:tax_rate].should == @tax_rate
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_tax_rates_path)
        end
      
        it "should be valid" do
          @tax_rate.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @tax_rate = mock_model(TaxRate, :save => false)
          TaxRate.stub!(:new).and_return(@tax_rate)
        end
      
        it "should assign @tax_rate" do
          do_create
          assigns[:tax_rate].should == @tax_rate
        end
      
        it "should not set the flash notice" do
          do_create
          flash[:notice].should be_nil
        end
      
        it "should render the index template" do
          do_create
          response.should render_template('index')
        end
      
        it "should not save" do
          @tax_rate.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT tax_rates/:id" do
      def do_update
        put :update, :id => "1", :tax_rate => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @tax_rate = mock_model(TaxRate, :update_attributes => true)
          TaxRate.stub!(:find).with("1").and_return(@tax_rate)
        end
  
        it "should find tax_rate and return object" do
          do_update
          assigns[:tax_rate].should == @tax_rate
        end
  
        it "should update the tax_rate object's attributes" do
          @tax_rate.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the tax_rate index page" do
          do_update
          response.should redirect_to(forge_tax_rates_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @tax_rate = mock_model(TaxRate, :update_attributes => false)
          TaxRate.stub!(:find).with("1").and_return(@tax_rate)
        end
  
        it "should find tax_rate and return object" do
          do_update
          assigns[:tax_rate].should == @tax_rate
        end
  
        it "should update the tax_rate object's attributes" do
          @tax_rate.should_receive(:update_attributes)
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
    describe "DELETE /tax_rates/:id" do
      it "should delete" do
        @tax_rate = mock_model(TaxRate)
        TaxRate.stub!(:find).and_return(@tax_rate)
        @tax_rate.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
  end
  
  
  describe "As someone who's not logged in" do
    before do
      controller.stub!(:current_user).and_return(nil)
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