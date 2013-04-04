describe Forge::SubscribersController do
  describe "As an admin, " do
    fixtures :roles, :users
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
      
    # EDIT
    describe "GET subscribers/:id/edit" do
      before do
        @subscriber = mock_model(Subscriber)
        Subscriber.should_receive(:find).with("1").and_return(@subscriber)
        get :edit, :id => 1
      end
    
      it "should assign @subscriber" do
        assigns[:subscriber].should == @subscriber
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST subscribers/" do
      def do_create
        post :create, :subscriber => {}
      end
    
      describe "with valid attributes" do    
        before do
          @subscriber = mock_model(Subscriber, :save => true)
          Subscriber.stub!(:new).and_return(@subscriber)
        end
      
        it "should assign @subscriber" do
          do_create
          assigns[:subscriber].should == @subscriber
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_subscribers_path)
        end
      
        it "should be valid" do
          @subscriber.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @subscriber = mock_model(Subscriber, :save => false)
          Subscriber.stub!(:new).and_return(@subscriber)
        end
      
        it "should assign @subscriber" do
          do_create
          assigns[:subscriber].should == @subscriber
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
          @subscriber.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT subscribers/:id" do
      def do_update
        put :update, :id => "1", :subscriber => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @subscriber = mock_model(Subscriber, :update_attributes => true)
          Subscriber.stub!(:find).with("1").and_return(@subscriber)
        end
  
        it "should find subscriber and return object" do
          do_update
          assigns[:subscriber].should == @subscriber
        end
  
        it "should update the subscriber object's attributes" do
          @subscriber.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the subscriber index page" do
          do_update
          response.should redirect_to(forge_subscribers_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @subscriber = mock_model(Subscriber, :update_attributes => false)
          Subscriber.stub!(:find).with("1").and_return(@subscriber)
        end
  
        it "should find subscriber and return object" do
          do_update
          assigns[:subscriber].should == @subscriber
        end
  
        it "should update the subscriber object's attributes" do
          @subscriber.should_receive(:update_attributes)
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
    
    # EXPORT
    describe "GET /subscribers/export" do
      it "should return a csv file on export" do
        get :export
        assigns[:subscribers]
        response.should_not be_redirect
        response.should be_success
        # controller.should_receive(:send_data)
      end
    end
    
    # DESTROY
    describe "DELETE /subscribers/:id" do
      it "should delete" do
        @subscriber = mock_model(Subscriber)
        Subscriber.stub!(:find).and_return(@subscriber)
        @subscriber.should_receive(:destroy)
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