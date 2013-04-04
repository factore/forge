class Country < ActiveRecord::Base
  # Scopes, Attrs, Etc.
  scope :active, where(:active => true).order("top_of_list DESC, title ASC")
  scope :alphabetical, order("title ASC")

  # Relationships
  has_many :provinces
  has_many :tax_rates
  has_many :addresses

  # Validations
  validates_presence_of :title, :code
  validates_uniqueness_of :title, :code

  def self.options_for_select
    Country.active.all.collect { |c| [c.title, c.id] }
  end

  def province_options_for_select(options = {})
    display = options[:display] || "title"
    add_blank = options[:add_blank] || false
    text_for_blank = options[:text_for_blank] || "All"

    case display
    when "title"
      provinces = self.provinces.all.collect { |p| [p.title, p.id] }
    when "code"
      provinces = self.provinces.all.collect { |p| [p.code, p.id] }
    end

    if add_blank
      provinces.insert(0, [text_for_blank, 0])
    end

    provinces
  end
end
