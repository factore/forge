class Product < ActiveRecord::Base
  # Scopes and Inclusions
  include Forge::Reorderable
  default_scope :order => 'products.list_order ASC'
  scope :published, :conditions => ["published = ?", true]

  # Relationships
  has_many :images, :class_name => "ProductImage"
  accepts_nested_attributes_for :images, :reject_if => lambda {|i| i[:image_asset_id].blank? && i[:id].blank? }, :allow_destroy => true
  has_and_belongs_to_many :tax_rates
  belongs_to :product_category
  belongs_to :sale
  #serialize :options # { :colours => {:Red => {:stock => 123, :selected => true} , :Blue => {:stock => 0}}, :sizes => {:small => {:stock => 10}} }

  # Validations
  validates_presence_of :title, :product_category
  validates_presence_of :short_description, :description, :if => :published
  validates_numericality_of :price, :flat_rate_shipping, :weight, :width, :height, :depth, :greater_than_or_equal_to => 0.00


  # for when the product is used in the cart or in an order hash
  def quantity
    @quantity ||= 1
  end

  def quantity=(quantity)
    @quantity = quantity
  end

  def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}".downcase
  end

  def options_yaml
    self.options
  end

  def options_hash
    YAML::load(self.options)
  end

  def all_breadcrumbs(join_character = ' > ')
    @all_breadcrumbs = []
    self.product_categories.each do |category|
      @breadcrumb = category.breadcrumb
      @all_breadcrumbs << @breadcrumb
    end

    if @all_breadcrumbs.blank?
      @all_breadcrumbs = "No categories."
    else
      @all_breadcrumbs.join(', ')
    end
  end

  def self.find_with_images(id)
    includes(:images).order('product_images.list_order').find(id)
  end

end
