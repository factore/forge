require 'spec_helper'

describe Forge::ProductsController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET products/new" do
      before do
        get :new
      end
    
      it "should assign @product" do
        assigns[:product].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET products/:id/edit" do
      before do
        @product = mock_model(Product)
        Product.should_receive(:find_with_images).with("1").and_return(@product)
        get :edit, :id => 1
      end
    
      it "should assign @product" do
        assigns[:product].should == @product
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST products/" do
      def do_create
        post :create, :product => {}
      end
    
      describe "with valid attributes" do    
        before do
          @product = mock_model(Product, :save => true)
          Product.stub!(:new).and_return(@product)
        end
      
        it "should assign @product" do
          do_create
          assigns[:product].should == @product
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the edit page" do
          do_create
          response.should redirect_to(edit_forge_product_path(@product))
        end
      
        it "should be valid" do
          @product.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @product = mock_model(Product, :save => false)
          Product.stub!(:new).and_return(@product)
        end
      
        it "should assign @product" do
          do_create
          assigns[:product].should == @product
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
          @product.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT products/:id" do
      def do_update
        put :update, :id => "1", :product => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @product = mock_model(Product, :update_attributes => true)
          Product.stub!(:find).with("1").and_return(@product)
        end
  
        it "should find product and return object" do
          do_update
          assigns[:product].should == @product
        end
  
        it "should update the product object's attributes" do
          @product.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the product edit page" do
          do_update
          response.should redirect_to(edit_forge_product_path(@product))
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @product = mock_model(Product, :update_attributes => false)
          Product.stub!(:find).with("1").and_return(@product)
        end
  
        it "should find product and return object" do
          do_update
          assigns[:product].should == @product
        end
  
        it "should update the product object's attributes" do
          @product.should_receive(:update_attributes)
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
    describe "DELETE /products/:id" do
      it "should delete" do
        @product = mock_model(Product)
        Product.stub!(:find).and_return(@product)
        @product.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
    
    # REORDER
    describe "POST /products/reorder" do
      it "should call reorder on Product if parent_id is there" do
        Product.should_receive(:reorder!).with(["1","2","3"]).and_return(nil)
        post :reorder, :product_list => ["menu_item_1","menu_item_2","menu_item_3"], :parent_id => 3
      end
      
      it "should call reorder on ProductCategory if parent_id is missing" do
        ProductCategory.should_receive(:reorder!).with(["1","2","3"]).and_return(nil)
        post :reorder, :product_list => ["menu_item_1","menu_item_2","menu_item_3"]
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