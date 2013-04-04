class Asset < ActiveRecord::Base
  require 'mime/types'
  include Sprockets::Helpers::IsolatedHelper
  include Sprockets::Helpers::RailsHelper


  acts_as_taggable
  has_attached_file :attachment, :styles => {:thumbnail => "120x108#", :medium => "800x800>"}
  before_attachment_post_process :prevent_pdf_thumbnail


  default_scope :order => "assets.created_at DESC"

  def swfupload_file!(data, filename)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.attachment = data
    self.title = filename
  end

  def list_title
    self.title.size > 16 ? self.title[0..15].strip + '...' : self.title
  end

  def is_image?
    self.attachment_content_type =~ /image/
  end

  def dimensions(style = :original)
    Paperclip::Geometry.from_file(self.attachment.to_file(style)).to_s.split('x')
  end

  def self.for_drawer(params)
    unless params[:q].blank?
      assets = where("assets.title LIKE ? OR tags.name = ?", "%#{params[:q]}%", params[:q]).includes(:taggings => :tag)
    else
      case params[:filter]
      when "images"
        assets = where("attachment_content_type LIKE ?", "%image%")
      when "documents"
        assets = where("attachment_content_type NOT LIKE ?", "%image%")
      else
        assets = self
      end
    end
    assets.limit(20).offset(params[:offset] || 0)
  end

  def icon_path
    case attachment_content_type
    when /image/
      attachment.url(:thumbnail)
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


  private
   def prevent_pdf_thumbnail
     return false unless attachment_content_type.index("image")
   end

   def zencoder_setting
     require 'ostruct'
     raw_config = File.read(File.join(Rails.root, 'config', 'zencoder.yml'))
     @zencoder_config ||= YAML.load(ERB.new(raw_config).result)
   end

end
