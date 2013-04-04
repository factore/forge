class Province < ActiveRecord::Base
  # Scopes, Attrs, Etc.
  default_scope order("title ASC")

  # Relationships
  belongs_to :country
  has_one :tax_rate
  has_many :addresses
  
  # Validations
  validates_presence_of :title, :code
  validates_uniqueness_of :title, :code
  
  def self.options_for_select(options={})
    options[:add_blank] ||= false
    text_for_blank = options[:text_for_blank] || "All"
    provinces = Province.all.collect { |p| [p.title, p.id] }
    if options[:add_blank]
      provinces.unshift [text_for_blank, 0]
    end

    provinces
  end

end
