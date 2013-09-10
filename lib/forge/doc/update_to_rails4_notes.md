* had to run 'bundle update' to get everything cleared out

To-Do:

* check that the new scopes and finders work (see the first commit in this branch)
* update the secret token stuff (see http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html, 2.6)
* :confirm is deprecated in link_to.  You should instead rely on a data attribute
  (e.g. data: { confirm: 'Are you sure?' }).  This deprecation also concerns the helpers based on this one
  (such as link_to_if or link_to_unless).
* check that the changes to match in routes work - ones I was unsure of are marked with TODO
* observers are removed - there is one observer for comment creation - we'll need to make sure this still
  works - I have pasted the code from that observer below.
* in application.rb, commented out:
  # config.action_controller.page_cache_directory = File.join(Rails.public_path, 'system', 'cache')
  But we may need something like that.
* commented out the contents of config/initializers/ecommerce.rb, but we probably need it
* added a devise secret key to config/initializers/devise.rb, this will need to get generated on application
  creation
* the above probably applies to config.pepper in the config/initializers/devise.rb file, and this may be
  a security issue in existing versions of Forge 3 sites
* I have removed attr_accessible from the user model, but need to check to make sure that this is all working
  properly
* the way that menu items in Forge are generated will need to be changed, it is not feasible right now
* asset uploader overlay doesn't appear (e.g. when trying to upload while creating a page)
* searching for help doesn't work
* the ckeditor content area is too large
* uploading an asset via the asset library fails
* inclusion of certain controllers that was taking place in the application controller must be done earlier
  in the application's loading.  So in app/controllers/application_controller.rb:
  -require 'forge/shared_controller_methods/posts.rb'
  -require 'forge/shared_controller_methods/ecommerce.rb'
  And in config/initializers/forge.rb:
  +require 'forge/shared_controller_methods/posts.rb'
  +require 'forge/shared_controller_methods/ecommerce.rb'



Observer code:

class CommentObserver < ActiveRecord::Observer
  def after_save(comment)
    # create subscriber
    CommentSubscriber.create(:commentable => comment.commentable, :email => comment.author_email) if comment.subscribe.to_i == 1

    # notify subscribers
    comment.commentable.subscribers.each {|subscriber| CommentMailer.comment_notification(subscriber.email, comment).deliver} if comment.approved?
  end
end

Sean:

* I pretty much killed the entire Ckeditor config file - not sure what the deal is with that!
  -- might be able to get rid of all the stuff in /public related to ckeditor and just use the gem


Later:

* remove protected_attributes from ForgeRad and replace with the default Rails 4 behaviour, which moves
  that stuff to the controller
* deal with forge_cli and Gemfile creation/copying - based on appropriate versions of Rails and Ruby

Notes:

* use the local version of Forge to create new Forge sites - from the root folder, run:
  be bin/forge new NAME_OF_APP MODULE_LIST
  e.g:
  be bin/forge new testapp events,ecommerce
  be bin/forge new testapp banners,dispatches,ecommerce,events,galleries,posts,subscribers,videos


