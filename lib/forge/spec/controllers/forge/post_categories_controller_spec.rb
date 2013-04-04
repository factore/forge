require 'spec_helper'

describe Forge::PostCategoriesController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # EDIT
    describe "GET post_categories/:id/edit" do
      before do
        @post_category = mock_model(PostCategory)
        PostCategory.should_receive(:find).with("1").and_return(@post_category)
        get :edit, :id => 1
      end
    
      it "should assign @post_category" do
        assigns[:post_category].should == @post_category
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST post_categories/" do
      def do_create
        post :create, :post_category => {}
      end
    
      describe "with valid attributes" do    
        before do
          @post_category = mock_model(PostCategory, :save => true)
          PostCategory.stub!(:new).and_return(@post_category)
        end
      
        it "should assign @post_category" do
          do_create
          assigns[:post_category].should == @post_category
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_post_categories_path)
        end
      
        it "should be valid" do
          @post_category.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @post_category = mock_model(PostCategory, :save => false)
          PostCategory.stub!(:new).and_return(@post_category)
        end
      
        it "should assign @post_category" do
          do_create
          assigns[:post_category].should == @post_category
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
          @post_category.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT post_categories/:id" do
      def do_update
        put :update, :id => "1", :post_category => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @post_category = mock_model(PostCategory, :update_attributes => true)
          PostCategory.stub!(:find).with("1").and_return(@post_category)
        end
  
        it "should find post_category and return object" do
          do_update
          assigns[:post_category].should == @post_category
        end
  
        it "should update the post_category object's attributes" do
          @post_category.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the post_category index page" do
          do_update
          response.should redirect_to(forge_post_categories_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @post_category = mock_model(PostCategory, :update_attributes => false)
          PostCategory.stub!(:find).with("1").and_return(@post_category)
        end
  
        it "should find post_category and return object" do
          do_update
          assigns[:post_category].should == @post_category
        end
  
        it "should update the post_category object's attributes" do
          @post_category.should_receive(:update_attributes)
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
    describe "DELETE /post_categories/:id" do
      it "should delete" do
        @post_category = mock_model(PostCategory)
        PostCategory.stub!(:find).and_return(@post_category)
        @post_category.should_receive(:destroy)
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