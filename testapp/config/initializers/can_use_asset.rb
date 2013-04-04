module Forge
  module CanUseAsset
    
    def self.included(mod)
      mod.send(:include, Sprockets::Helpers::IsolatedHelper)
      mod.send(:include, Sprockets::Helpers::RailsHelper)
      mod.extend(ClassMethods)
    end
    
    module ClassMethods
      def can_use_asset_for(*args)
        args.each do |field|
          self.send("before_#{field}_post_process".to_sym, "prevent_#{field}_pdf_thumbnail".to_sym)

          self.send(:before_validation, "check_for_#{field}_asset".to_sym)
          self.send(:attr_accessor, "#{field}_asset_id".to_sym, "#{field}_asset_url".to_sym)
          
          define_method("check_for_#{field}_asset".to_sym) do
            raise "Your attachment must have a :thumbnail style (ideally '120x108#') to be compatible with can_use_asset" unless self.send(field.to_sym).styles.has_key?(:thumbnail)
            asset = Asset.find_by_id(self.send("#{field}_asset_id".to_sym))
            self.send("#{field}=".to_sym, File.new(asset.attachment.path)) unless asset.blank?
          end
          
          define_method("#{field}_icon_path".to_sym) do
            icon_path = "/images/forge/asset-icons"
            case self.send("#{field}_content_type")
            when /image/
              self.send(field.to_sym).url(:thumbnail)
            when /audio/
              asset_path "forge/asset-icons/audio.jpg"
            when /excel/
              asset_path "forge/asset-icons/spreadsheet.jpg"
            when /pdf/
              asset_path "forge/asset-icons/pdf.jpg"
            else
              asset_path "forge/asset-icons/misc.jpg"
            end
          end
          
          define_method("prevent_#{field}_pdf_thumbnail".to_sym) do
            return false unless self.send("#{field}_content_type".to_sym).index("image") 
          end

        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Forge::CanUseAsset)