class Forge::CommentsController < ForgeController
  before_filter :get_comment, :only => [:approve, :unapprove, :destroy]

  def index
    conditions = ["approved = ?", false] if params[:show] == "unapproved"
    conditions = ["approved = ?", true] if params[:show] == "approved"
    respond_to do |format|
      format.html { @comments = Comment.where(conditions).paginate(:include => :commentable, :per_page => 10, :page => params[:page]) }
      format.js {
        @comments = Comment.where("author LIKE ? OR content LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
        render :partial => "comment", :collection => @comments
      }
    end
  end

  def approve
    respond_to do |format|
      if @comment.approve!
        format.js { render :nothing => true }
        format.html { flash[:notice] = "Comment approved." and redirect_to forge_comments_path }
      else
        format.js { render :status => 500 }
        format.html { flash[:warning] = "Error approving comment." and redirect_to forge_comments_path }
      end
    end
  end

  def unapprove
    respond_to do |format|
      if @comment.unapprove!
        format.js { render :nothing => true }
        format.html { flash[:notice] = "Comment unapproved." and redirect_to forge_comments_path }
      else
        format.js { render :status => 500 }
        format.html { flash[:warning] = "Error unapproving comment." and redirect_to forge_comments_path }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.js { render :nothing => true }
        format.html { flash[:notice] = "Comment deleted." and redirect_to forge_comments_path }
      else
        format.js { render :status => 500 }
        format.html { flash[:warning] = "Error deleting comment." and redirect_to forge_comments_path }
      end
    end
  end

protected

  def get_comment
    @comment = Comment.find(params[:id])
  end

end
