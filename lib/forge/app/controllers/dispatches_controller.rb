class DispatchesController < ApplicationController
  def read
    @dispatch = Dispatch.find(params[:id])
    @dispatch.opens.create(:email => params[:email], :ip => request.env["HTTP_X_FORWARDED_FOR"])
    File.open(File.join(Rails.root, 'public', 'pixel.gif'), 'rb') do |f|
      send_data f.read, :type => 'image/gif', :disposition => 'inline'
    end
  end

  def unsubscribe
    @dispatch = Dispatch.find(params[:id])
    @subscriber = Subscriber.find_by_id_and_email!(params[:s_id], params[:email])
    DispatchUnsubscribe.create(:dispatch => @dispatch, :email => @subscriber.email)
    @subscriber.destroy
    flash[:notice] = "You have been unsubscribed from our newsletter."
    redirect_to root_path
  end
end