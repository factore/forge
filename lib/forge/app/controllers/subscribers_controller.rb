class SubscribersController < ApplicationController
  def index
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(params[:subscriber])

    respond_to do |format|
      if @subscriber.save
        format.html {
          flash[:notice] = 'You have been subscribed successfully.'
          redirect_to :action => "index"
        }
        format.xml  { render :xml => @subscriber, :status => :created }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @subscriber.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @subscriber = Subscriber.find_by_email(params[:email])
    if @subscriber
      @subscriber.destroy
      respond_to do |format|
        format.html {
          flash[:notice] = "You have been unsubscribed."
          redirect_to :action => "index"
        }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html {
          flash[:warning] = "Your email was not found.  Are you sure you are subscribed?"
          redirect_to :action => "index"
        }
        format.xml  { head :bad_request }
      end
    end
  end
end
