require 'spec_helper'

describe Forge::<%= class_name.pluralize %>Controller do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # EDIT
    describe "GET <%= plural_table_name %>/:id/edit" do
      before do
        @<%= file_name %> = mock_model(<%= class_name %>)
        <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
        get :edit, :id => 1
      end
    
      it "should assign @<%= file_name %>" do
        assigns[:<%= file_name %>].should == @<%= file_name %>
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST <%= plural_table_name %>/" do
      def do_create
        post :create, :<%= file_name %> => {}
      end
    
      describe "with valid attributes" do    
        before do
          @<%= file_name %> = mock_model(<%= class_name %>, :save => true)
          <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
        end
      
        it "should assign @<%= file_name %>" do
          do_create
          assigns[:<%= file_name %>].should == @<%= file_name %>
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_<%= plural_table_name %>_path)
        end
      
        it "should be valid" do
          @<%= file_name %>.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @<%= file_name %> = mock_model(<%= class_name %>, :save => false)
          <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
        end
      
        it "should assign @<%= file_name %>" do
          do_create
          assigns[:<%= file_name %>].should == @<%= file_name %>
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
          @<%= file_name %>.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT <%= plural_table_name %>/:id" do
      def do_update
        put :update, :id => "1", :<%= file_name %> => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @<%= file_name %> = mock_model(<%= class_name %>, :update_attributes => true)
          <%= class_name %>.stub!(:find).with("1").and_return(@<%= file_name %>)
        end
  
        it "should find <%= file_name %> and return object" do
          do_update
          assigns[:<%= file_name %>].should == @<%= file_name %>
        end
  
        it "should update the <%= file_name %> object's attributes" do
          @<%= file_name %>.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the <%= file_name %> index page" do
          do_update
          response.should redirect_to(forge_<%= plural_table_name %>_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @<%= file_name %> = mock_model(<%= class_name %>, :update_attributes => false)
          <%= class_name %>.stub!(:find).with("1").and_return(@<%= file_name %>)
        end
  
        it "should find <%= file_name %> and return object" do
          do_update
          assigns[:<%= file_name %>].should == @<%= file_name %>
        end
  
        it "should update the <%= file_name %> object's attributes" do
          @<%= file_name %>.should_receive(:update_attributes)
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
    describe "DELETE /<%= plural_table_name %>/:id" do
      it "should delete" do
        @<%= file_name %> = mock_model(<%= class_name %>)
        <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
        @<%= file_name %>.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
<% unless attributes.select{|a| a.name == "list_order" }.empty? -%>   

    # REORDER
    describe "POST /<%= plural_table_name %>/reorder" do
      it "should call reorder" do
        <%= class_name %>.should_receive(:reorder!).with(["1","2","3"]).and_return(nil)
        post :reorder, :<%= file_name %>_list => ["1","2","3"]
      end
    end
<% end -%>
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