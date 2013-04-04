class CommentsController < ApplicationController
  before_filter :get_archive_months, :only => :create
  before_filter :get_post_categories, :only => :create  
  # TODO: figure out a caching mechanism
  # cache_sweeper :post_sweeper, :only => [:create, :destroy]
  # TODO: rakismet back in
  # has_rakismet :only => :create
  
  def create
     params[:comment].merge!({:user_ip => request.remote_ip, :user_agent => request.env['HTTP_USER_AGENT'], :referrer => request.env['HTTP_REFERER']})
     @comment = Comment.new(params[:comment])
     if @comment.save
       flash[:notice] = "Your comment was submitted successfully."
       flash[:notice] += "  It is awaiting moderation and will be posted soon." if !@comment.approved
       flash[:notice] += " <a href='#comment-#{@comment.id}'>Jump to it now.</a>" if @comment.approved
       session[:comment] = ""
       session[:comment_errors] = ""
       redirect_to @comment.referrer and return false
     else
       flash[:warning] = "There was a problem adding your comment. Check the comment form for more details."
       session[:comment] = params[:comment]
       session[:comment_errors] = @comment.error_message
       redirect_to @comment.referrer
     end
   end

   def destroy
     @comment = Comment.find(params[:comment_id])
     if logged_in? && current_user.staff?
       @comment.destroy
       flash[:notice] = "Comment deleted successfully."
     end
     redirect_to @comment.referrer
   end
end