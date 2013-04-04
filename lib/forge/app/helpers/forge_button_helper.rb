module ForgeButtonHelper
  # forge menu helpers
  def show_menu_item(menu_item)
    path = proc {|extension| "#{Rails.root}/app/views/forge/shared/menu_items/_#{menu_item}.#{extension}"}
    render :partial => "forge/shared/menu_items/#{menu_item}", :locals => {:item => menu_item} if File.exist?(path.call('html.erb')) || File.exist?(path.call('html.haml'))
  end

  def forge_menu_item(title, url, options = {})
    klass = options[:active] ? "forge-menu-item active" : "forge-menu-item normal"
    klass += options[:submenu] ? "" : " no-submenu"
    display_title = options[:alt_title] ? options[:alt_title] : title
    arrow = content_tag(:div, "", :class => "icon")
    submenu = options[:submenu] ? link_to(arrow, "javascript:;", :class => "#{title} arrow hide") : ""
    spacer = content_tag(:div, "", :class => "spacer")
    content_tag(:div, :class => klass) { link_to(display_title.titleize, url, options.merge({:class => "forge-menu-link"})) + submenu + spacer}
  end

  def is_active(controllers)
    controllers = controllers.is_a?(Array) ? controllers : [controllers]
    controllers.map{|c| "forge/#{c}"}.include?(params[:controller]) ? true : false
  end

  def has_submenu(submenu)
    !submenu.blank?
  end

  # grey buttons
  def button_link(text, url, options = {})
    options[:class] ||= "button"
    icon = content_tag(:div, "", :class => "icon")
    link_to(content_tag(:span, icon + text), url, options)
  end

  # grey submit buttons
  def button_submit_tag(text, options = {})
    options[:class] ||= "button"
    content_tag :input, "", :type => "submit", :value => text, :class => options[:class], :id => options[:id]
  end

  # big home page buttons
  def home_button(icon, title, subhead, url, options = {})
    content_tag :div, :class => "home-button" do
      content_tag(:div, "", :class => "image #{icon}") +
      content_tag(:h1, title) +
      content_tag(:p, subhead) +
      link_to('', url, options)
    end
  end
end
