require 'spec_helper'

describe Forge::PostsController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET posts/new" do
      before do
        get :new
      end
    
      it "should assign @post" do
        assigns[:post].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET posts/:id/edit" do
      before do
        @post = mock_model(Post)
        Post.should_receive(:find).with("1").and_return(@post)
        get :edit, :id => 1
      end
    
      it "should assign @post" do
        assigns[:post].should == @post
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST posts/" do
      def do_create
        post :create, :post => {}
      end
    
      describe "with valid attributes" do    
        before do
          @post = mock_model(Post, :save => true)
          Post.stub!(:new).and_return(@post)
        end
      
        it "should assign @post" do
          do_create
          assigns[:post].should == @post
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_posts_path)
        end
      
        it "should be valid" do
          @post.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @post = mock_model(Post, :save => false)
          Post.stub!(:new).and_return(@post)
        end
      
        it "should assign @post" do
          do_create
          assigns[:post].should == @post
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
          @post.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT posts/:id" do
      def do_update
        put :update, :id => "1", :post => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @post = mock_model(Post, :update_attributes => true)
          Post.stub!(:find).with("1").and_return(@post)
        end
  
        it "should find post and return object" do
          do_update
          assigns[:post].should == @post
        end
  
        it "should update the post object's attributes" do
          @post.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the post index page" do
          do_update
          response.should redirect_to(forge_posts_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @post = mock_model(Post, :update_attributes => false)
          Post.stub!(:find).with("1").and_return(@post)
        end
  
        it "should find post and return object" do
          do_update
          assigns[:post].should == @post
        end
  
        it "should update the post object's attributes" do
          @post.should_receive(:update_attributes)
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
    describe "DELETE /posts/:id" do
      it "should delete" do
        @post = mock_model(Post)
        Post.stub!(:find).and_return(@post)
        @post.should_receive(:destroy)
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