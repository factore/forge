* had to run 'bundle update' to get everything cleared out

To-Do:

* check that the new scopes and finders work (see the first commit in this branch)
* update the secret token stuff (see http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html, 2.6)
* :confirm is deprecated in link_to.  You should instead rely on a data attribute
  (e.g. data: { confirm: 'Are you sure?' }).  This deprecation also concerns the helpers based on this one
  (such as link_to_if or link_to_unless).
* check that the changes to match in routes work - ones I was unsure of are marked with TODO
* observers are removed - there is one observer for comment creation - we'll need to make sure this still
  works
* in application.rb, commented out:
  # config.action_controller.page_cache_directory = File.join(Rails.public_path, 'system', 'cache')
  But we may need something like that.
* commented out the contents of config/initializers/ecommerce.rb, but we probably need it
* lib/forge/can_use_asset.rb is broken because of 'uninitialized constant Sprockets::Helpers'

Later:

* remove protected_attributes from ForgeRad and replace with the default Rails 4 behaviour, which moves
  that stuff to the controller

