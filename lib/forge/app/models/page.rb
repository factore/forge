class Page < ActiveRecord::Base
  # Scopes, Attrs, Etc.
  acts_as_nested_set
  attr_protected :lft, :rgt
  default_scope { order("pages.lft, pages.list_order") }
  scope :published, -> { where(:published => true) }
  scope :find_for_menu, -> { published.where("parent_id IS NULL AND show_in_menu = ?", true).includes(:subpages) }
  scope :top, -> { where(:parent_id => nil) }

  # Relationships
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  has_many :subpages, :class_name => "Page", :foreign_key => "parent_id", :dependent => :destroy, :order => "list_order"

  # Validations
  before_validation :set_slug_and_path
  after_move :set_slug_and_path
  validates_presence_of :title, :content
  validates_presence_of :slug, :message => "must exist in order to have a properly generated URL."
  validates_uniqueness_of :slug, :scope => :parent_id
  validate :path_is_not_route
  validate :parent_is_not_in_tree

  # Return siblings if subpages aren't available
  def subpages_for_menu
    if subpages.blank?
      Page.where(:published => true, :show_in_menu => true, :parent_id => parent_id) unless parent_id.blank?
    else
      subpages.where(:published => true, :show_in_menu => true)
    end
  end

  # this will be included in rails automatically soon
  def self.find_by_slug!(slug)
    self.find_by_slug(slug) or raise ActiveRecord::RecordNotFound, "could not find page '#{slug}'"
  end

  def parents
    parent, parents = self.parent, []
    while parent
      parents << parent
      parent = parent.parent
    end
    return parents
  end

  def breadcrumb(separator = ' > ')
    parent, pages = self.parent, [self.title]
    while parent
      pages << parent.title
      parent = parent.parent
    end
    pages.reverse.join(separator)
  end

  def top_parent
    parent, parents = self.parent, [self]
    while parent
      parents << self
      parent = parent.parent
    end
    return parents.last
  end

  def list_title
    title = self.title.size > 64 ? self.title[0..64].strip + '...' : self.title
    title = self.published? ? title : title + " (Draft)"
    return title
  end

  def option_title
    ot = ''
    ot << "&nbsp;" * ((depth || 0) * 3)
    ot << "- " if (depth || 0) > 0
    ot << title
    ot.html_safe
  end

  def self.reorder!(list, parent_id)
    unless list.blank?
      pages = []

      # Move all the pages to the right parent_id first
      list.each_with_index do |id,order|
        pages << Page.find_by_id(id)
        if pages[order] && parent_id
          pages[order].move_to_child_of(parent_id)
        end
      end

      # Then give them the ol shuffle
      first_page = pages[0]
      previous_page = first_page
      pages.each_with_index do |page, order|
        next if order == 0
        page = pages[order]
        page.move_to_right_of(previous_page)
        page.save
        previous_page = page
      end
    end
  end

  protected
    def path_is_not_route
      match = Rails.application.routes.recognize_path(path, :method => :get) rescue nil
      errors.add(:base, "There's already something happening at #{MySettings.site_url}#{path}.  Try giving the page a different name.") if match && !match[:slugs]
    end

    def set_slug_and_path
      self.slug = self.title.parameterize

      parent, pages = self.parent, [self.slug]
      while parent
        pages << parent.slug
        parent = parent.parent
      end
      self.path = "/" + pages.reverse.join('/')
    end

    def parent_is_not_in_tree
      if id && [id, descendants.map(&:id)].flatten.include?(parent_id)
        msg = "cannot be itself or one of its subpages."
        errors.add(:parent_id, msg)
      end
    end
end
