class DispatchLinksController < ApplicationController
  def show
    @dispatch_link = DispatchLink.find_by_dispatch_id_and_position(params[:dispatch_id], params[:id])
    @dispatch_link.clicks.create(:ip => request.env["HTTP_X_FORWARDED_FOR"])
    redirect_to @dispatch_link.uri
  end
end
