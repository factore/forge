class ProductCategory < ActiveRecord::Base
  include Forge::Reorderable
  default_scope :order => 'product_categories.list_order'
  before_destroy :validate_destroy
  has_many :products
  belongs_to :sale
  belongs_to :parent, :class_name => "ProductCategory", :foreign_key => "parent_id"
  has_many :subcategories, :class_name => "ProductCategory", :foreign_key => "parent_id", :dependent => :destroy, :order => "list_order"

  validates_presence_of :title

  def validate_destroy
    products.count < 1
  end

  def parents( category=self )
    #Probably need to modify this to use slug instead of title?  At least parameterize things.
    if category.parent.nil?
      return [category.title]
    else
      return parents(category.parent).concat([category.title])
    end
  end

  def path
    parents.join('/')
  end
end
