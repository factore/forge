class Asset < ActiveRecord::Base
  require 'mime/types'

  acts_as_taggable
  has_attached_file :attachment, :styles => {:thumbnail => "120x108#", :medium => "800x800>"}
  before_attachment_post_process :prevent_pdf_thumbnail

  default_scope { order("assets.created_at DESC") }
  
  # open up everything for mass assignment
  attr_protected

  def swfupload_file!(data, filename)
    data.content_type = MIME::Types.type_for(data.original_filename).first.content_type rescue ""
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
    file = Paperclip.io_adapters.for(attachment.styles[style])
    Paperclip::Geometry.from_file(file).to_s.split('x')
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
      ActionController::Base.helpers.asset_path "forge/asset-icons/audio.jpg"
    when /excel/
      ActionController::Base.helpers.asset_path "forge/asset-icons/spreadsheet.jpg"
    when /pdf/
      ActionController::Base.helpers.asset_path "forge/asset-icons/pdf.jpg"
    else
      ActionController::Base.helpers.asset_path "forge/asset-icons/misc.jpg"
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
