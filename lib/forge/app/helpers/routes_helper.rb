module RoutesHelper
  def forge_help_topic_path(help_topic)
    "/forge/help/#{help_topic.slug}"
  end

  def page_path(page)
    page.path
  end

  def product_category_path(category)
    category.path
  end
end

