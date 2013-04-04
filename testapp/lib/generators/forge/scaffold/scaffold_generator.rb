module Forge
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :small, :type => :boolean, :default => false, :description => "Use the small-style template?"
      invoke :model

      def copy_files
        style = options.small? ? 'small' : 'full'

        # Controller, helper, views, test and stylesheets directories.
        empty_directory(File.join('app/views/forge', plural_table_name))

        for action in %w{index new edit _form}
          template("view_#{action}.html.haml", File.join('app/views/forge', plural_table_name, "#{action}.html.haml"))
        end

        template("view__item.html.haml", File.join('app/views/forge', plural_table_name, "_#{file_name}.html.haml"))

        template("menu_section.html.haml", File.join('app/views/forge/shared/menu_items', "_#{file_name.pluralize}.html.haml"))

        template(
          'controller.rb', File.join('app/controllers/forge', "#{file_name.pluralize}_controller.rb")
        )

        template('controller_spec.rb', File.join('spec/controllers/forge', "#{file_name.pluralize}_controller_spec.rb"))

      end

      def add_routes
        case self.behavior
        when :invoke
          # Write the routes
          filename = File.join(Rails.root, 'config', 'routes.rb')
          pattern = "namespace :forge do"
          reorder = attributes.select{|a| a.name == "list_order" }.empty? ? "" : "do \n      post    'reorder', :on => :collection \n    end"
          replacement = "namespace :forge do \n    resources :#{plural_table_name} #{reorder}"
          converted_content = File.read(filename).gsub(pattern, replacement)
          File.open(filename, 'w'){ |f| f.write converted_content }
        when :revoke
          say "Be sure to clean up your routes!", :red
        end
      end

      def add_i18n
        case self.behavior
        when :invoke
          # Write a couple of lines to config/i18n_fields.yml
          pattern = "tables:"
          replacement = "tables:\n  #{plural_table_name}:\n    -\n"
        when :revoke
          # now remove them
          pattern = /^  #{plural_table_name}:\n(    - *[\w]*\n*)*/
          replacement = ""
        end

        filename = File.join(Rails.root, 'config', 'i18n_fields.yml')
        converted_content = File.read(filename).gsub(pattern, replacement)
        File.open(filename, 'w'){ |f| f.write converted_content }
      end
    end
  end
end
