* had to run 'bundle update' to get everything cleared out

High Priority To-Do:

* [AD] check that the new scopes and finders work (see the first commit in this branch)
* update the secret token stuff (see http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html, 2.6)
* [AD] check that the changes to 'match' in routes work - ones I was unsure of are marked with TODO
* [AD] observers are removed - there is one observer for comment creation - we'll need to make sure this still
  works - I have pasted the code from that observer below.
* [AD] commented out the contents of config/initializers/ecommerce.rb due to errors, but we probably need it
  - actually, this isn't copied over into new projects, so perhaps we can just delete it
* added a devise secret key to config/initializers/devise.rb, this will need to get generated on application
  creation
* the above probably applies to config.pepper in the config/initializers/devise.rb file, and this may be
  a security issue in existing versions of Forge 3 sites
* [SR] asset uploader overlay doesn't appear (e.g. when trying to upload while creating a page)
* [AD] searching for help doesn't work
* [SR] the ckeditor content area is too large
* [SR] uploading an asset via the asset library fails
* inclusion of certain controllers that was taking place in the application controller must be done earlier
  in the application's loading.  So in app/controllers/application_controller.rb:
  -require 'forge/shared_controller_methods/posts.rb'
  -require 'forge/shared_controller_methods/ecommerce.rb'
  And in config/initializers/forge.rb:
  +require 'forge/shared_controller_methods/posts.rb'
  +require 'forge/shared_controller_methods/ecommerce.rb'
  - ACTUALLY, in my most recent installation of the app, this doesn't seem to be a problem any more.  Please
    test.
* [SR] you can't create or edit users because of devise and the way it handles strong parameters.  This blog post
  might be of some use: http://blog.12spokes.com/web-design-development/adding-custom-fields-to-your-devise-user-model-in-rails-4/
  The approach of simply using user_params with .require and .permit does not work here.
  We may need to rework the entire users controller to inherit from some other devise controller or something.
  I don't think we can use attr_accessible even though we have that gem installed, although we might be able to.
* [SR] check that 'remember me' and 'sign out' devise functionality work properly
* I haven't run any of the tests yet, so that may be a big ugly surprise too!

Second Priority To-Do:

* :confirm is deprecated in link_to.  You should instead rely on a data attribute
  (e.g. data: { confirm: 'Are you sure?' }).  This deprecation also concerns the helpers based on this one
  (such as link_to_if or link_to_unless).
* in application.rb, commented out:
  # config.action_controller.page_cache_directory = File.join(Rails.public_path, 'system', 'cache')
  But we may need something like that.
* the Forge homepage shows a blank error popup when you log in or return to it for some reason

Observer code:

class CommentObserver < ActiveRecord::Observer
  def after_save(comment)
    # create subscriber
    CommentSubscriber.create(:commentable => comment.commentable, :email => comment.author_email) if comment.subscribe.to_i == 1

    # notify subscribers
    comment.commentable.subscribers.each {|subscriber| CommentMailer.comment_notification(subscriber.email, comment).deliver} if comment.approved?
  end
end

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


