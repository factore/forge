require 'spec_helper'

describe Forge::ProductCategoriesController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # EDIT
    describe "GET product_categories/:id/edit" do
      before do
        @product_category = mock_model(ProductCategory)
        ProductCategory.should_receive(:find).with("1").and_return(@product_category)
        get :edit, :id => 1
      end
    
      it "should assign @product_category" do
        assigns[:product_category].should == @product_category
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST product_categories/" do
      def do_create
        post :create, :product_category => {}
      end
    
      describe "with valid attributes" do    
        before do
          @product_category = mock_model(ProductCategory, :save => true)
          ProductCategory.stub!(:new).and_return(@product_category)
        end
      
        it "should assign @product_category" do
          do_create
          assigns[:product_category].should == @product_category
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_product_categories_path)
        end
      
        it "should be valid" do
          @product_category.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @product_category = mock_model(ProductCategory, :save => false)
          ProductCategory.stub!(:new).and_return(@product_category)
        end
      
        it "should assign @product_category" do
          do_create
          assigns[:product_category].should == @product_category
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
          @product_category.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT product_categories/:id" do
      def do_update
        put :update, :id => "1", :product_category => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @product_category = mock_model(ProductCategory, :update_attributes => true)
          ProductCategory.stub!(:find).with("1").and_return(@product_category)
        end
  
        it "should find product_category and return object" do
          do_update
          assigns[:product_category].should == @product_category
        end
  
        it "should update the product_category object's attributes" do
          @product_category.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the product_category index page" do
          do_update
          response.should redirect_to(forge_product_categories_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @product_category = mock_model(ProductCategory, :update_attributes => false)
          ProductCategory.stub!(:find).with("1").and_return(@product_category)
        end
  
        it "should find product_category and return object" do
          do_update
          assigns[:product_category].should == @product_category
        end
  
        it "should update the product_category object's attributes" do
          @product_category.should_receive(:update_attributes)
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
    describe "DELETE /product_categories/:id" do
      it "should delete" do
        @product_category = mock_model(ProductCategory)
        ProductCategory.stub!(:find).and_return(@product_category)
        @product_category.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
    
    # REORDER
    describe "POST /product_categories/reorder" do
      it "should call reorder" do
        ProductCategory.should_receive(:reorder!).with(["1","2","3"]).and_return(nil)
        post :reorder, :product_category_list => ["1","2","3"]
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