module MobileHelper
  def mobile_menu_item(title, link, options = {})
    li_class = ""
    #set the link class to active if it matches the current link or any of the alternate supplied links
    options[:alt_links].each { |a| li_class = request.fullpath.match(a) ? "active" : "" unless li_class == "active" } if options[:alt_links].is_a?(Array)
    li_class = "active" if link == request.fullpath
    li_class += " #{options[:icon]}" unless options[:icon].blank?
    li_class += " #{options[:class]}" unless options[:class].blank?
    icon = image_tag(options[:icon].blank? ? "mobile/arrow-nav.png" : "mobile/#{options[:icon]}.png", :class => "icon")
    return content_tag(:li, link_to(title, link) + icon, :class => li_class)
  end

  def mobile_logo
    MySettings.logo_url.blank? ? MySettings.site_title : image_tag(MySettings.logo_url)
  end

  def mobile_color
    MySettings.mobile_color.blank? ? "#ee3124" : MySettings.mobile_color
  end
end
