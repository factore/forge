module ForgeHelper
  def inset(&block)
    content_tag(:div, :class => 'inset', &block)
    # content_tag :div, :class => 'inset' do
      # [content_tag(:div, '', :class => 'inset-left'), content_tag(:div, :class => 'inset-content', &block), content_tag(:div, '', :class => 'inset-right')].join('').html_safe
    # end
  end

  # creates a slider control
  # pass in parameters like this: label, control, label, control
  # e.g. slider("Yes", f.radio_button(:published, true), "Not Yet", f.radio_button(:published, false))
  def slider(*labels_and_controls)
    raise "There must be an even number of parameters" if (labels_and_controls.size % 2) != 0

    # step through the parameters and create a label for the even ones and a control for the odd
    controls = ""
    0.step(labels_and_controls.size - 1, 2).each do |i|
      controls += content_tag(:label, labels_and_controls[i].html_safe + labels_and_controls[i + 1].html_safe)
    end

    return inset do
      content_tag :span, controls.html_safe, :class => 'radio-slider'
    end
  end

  def big_list_item(options = {}, &block)
    content_tag :li, options do
      content_tag(:div, :class => "item-content #{options[:class] if options[:class]}", &block)
    end.html_safe
  end

  def asset_editor_html(asset, options = {})
    if asset.is_image?
      style = "";
      style += "float: left; margin: 3px 5px 10px 0px;" if options[:wrap] == "left"
      style += "float: right; margin: 3px 0px 10px 5px;" if options[:wrap] == "right"
      style += "width: #{options[:width]}px;" if options[:width]
      # disabled a default height so that images placed into Forge work with mobile by default - eimaj
      # style += "height: #{options[:height]}px;" if options[:height]
      return image_tag("http://#{request.host}#{request.port == 80 ? "" : ":#{request.port}"}#{asset.attachment.url(:medium)}", :style => style).html_safe
    else
      return link_to(options[:title], "http://#{request.host}#{request.port == 80 ? "" : ":#{request.port}"}#{asset.attachment.url}".html_safe)
    end
  end

  # Generic list item with toggles. Originally country rows with yes/no toggles for forge/country#index
  def toggle_li_tag(opts={})
    toggle_row = content_tag(:div, "#{opts[:title]}".html_safe, :class => "item_title")
    opts[:actions].each do |action|
      toggle_row += content_tag(:div, "<small>#{action.keys[0]}</small><br /> #{action.values[0]}".html_safe, :class => "item_action")
    end
    toggle_row += content_tag(:div, "", :class => "spacer")

    li_content = content_tag(:div, toggle_row.html_safe, :class => "item-content")

    return content_tag(:li, li_content.html_safe, :class => "toggle-row #{opts[:class] unless opts[:class].blank?}", :id => opts[:id])
  end

  # create breadcrumb trail from current controller/action (default)
  # default breadcrumb title can be over-ridden in controller (@controller_crumb and/or @action_crumb)
  # default is set in forge_controller.rb
  def breadcrumb_trail(controller, action)
    begin
      trail = link_to("Home", "/forge", :class => "crumb no-arrow")
      trail += link_to(display_controller(controller), url_for(:controller => params[:controller]), :class => "crumb") if controller != "forge/index"
      trail += content_tag(:span, display_action(action), :class => "crumb") if action != "index"
      return trail
    rescue
      return ""
    end
  end

  def display_controller(controller)
    controller = controller.split('/')[1] if controller.match("/")
    controller.humanize.titleize
  end

  def display_action(action)
    action = "edit" if action == "update"
    action = "new" if action == "create"
    action.titleize.humanize
  end

  # row class helper for .item_title on index views
  def row_class(obj, extra = '')
    rc = ""
    rc += " draft" if obj.respond_to?(:published) && !obj.published
    rc += " #{extra}" unless extra.blank?
    return rc
  end

  # forge icon tag helper
  def icon_tag(icon)
    image_tag("forge/icons/#{icon}.png")
  end

  # default forge action link
  def action_link(title, link, options = {})
    klass = options[:class] unless options[:class].blank?
    confirmation = options[:confirm] unless options[:confirm].blank?
    icon_link = link_to(icon_tag(options[:icon]), link, :data => { :confirm => confirmation }) + "<br />".html_safe if options[:icon]
    title_link = content_tag(:small, link_to(title, link, :data => { :confirm => confirmation }))
    content = icon_link.blank? ? title_link.html_safe  : icon_link.html_safe  + title_link.html_safe
    return content_tag(:div, content.html_safe, :class => "item-action #{klass}")
  end

  # default forge edit link
  def edit_link(obj, icon = true, compact = false)
    line_break = compact ? "" : "<br/>".html_safe
    icon_link = link_to(icon_tag('edit'), polymorphic_url([:forge] + Array(obj)) + "/edit", :class => "edit") if icon
    title_link = content_tag(:small, (link_to "Edit", polymorphic_url([:forge] + Array(obj)) + "/edit", :class => "edit"))
    content = icon_link.blank? ? title_link.html_safe  : icon_link.html_safe   + line_break + title_link.html_safe
    return content_tag(:div, content, :class => 'item-action') if can?(:edit, obj)
  end

  # default forge delete link
  def delete_link(obj, icon = true, compact = false)
    line_break = compact ? "" : "<br/>".html_safe
    icon_link = link_to icon_tag('trash'), polymorphic_url([:forge] + Array(obj)), :method => :delete, :data => {:confirm => "Are you sure? There is no undo for this!"}, :class => "destroy" if icon
    title_link = content_tag(:small, (link_to "Delete", polymorphic_url([:forge] + Array(obj)), :method => :delete, :data => {:confirm => "Are you sure? There is no undo for this!"}, :class => "destroy"))
    content = icon_link.blank? ? title_link.html_safe  : icon_link.html_safe   + line_break + title_link.html_safe
    return content_tag(:div, content, :class => 'item-action last') if can?(:destroy, obj)
  end

  # browser detection and warning message
  def browser_detection(http)
    if http.match(/MSIE 6|MSIE 7|MSIE 8.0/)
      content_tag(:div, "For an optimal Forge experience, please upgrade Internet Explorer to the #{link_to 'latest version', 'http://browsehappy.com/', :target => '_blank'} or switch to another #{link_to 'modern browser', 'http://browsehappy.com/', :target => '_blank'}.".html_safe, :id => "flash-warning", :class => "flash-msg")
    end
  end

end
