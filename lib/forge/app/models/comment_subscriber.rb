class CommentSubscriber < ActiveRecord::Base
  validates_presence_of :email, :commentable
  validates_uniqueness_of :email, :scope => [:commentable_id, :commentable_type]
  belongs_to :commentable, :polymorphic => true
  
  # open up everything for mass assignment
  attr_protected

  def list(object)
    self.where(:commentable_id => object.id, :commentable_type => object.class)
  end
end
