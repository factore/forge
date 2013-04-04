module ApplicationHelper
  def jquery_for_environment
    path = ENV['RAILS_ENV'] == "production" ? 'http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js' : 'jquery'
    javascript_include_tag path
  end

  def flash_messages
    messages = []
    %w(notice warning error alert).each do |msg|
      messages << content_tag(:div, flash[msg.to_sym], :id => "flash-#{msg}", :class => "flash-msg") unless flash[msg.to_sym].blank?
    end
    messages.join('').html_safe
  end

  def menu_item(title, link, options = {})
    klass = ""
    #set the link class to active if it matches the current link or any of the alternate supplied links
    options[:alt_links].each { |a| klass = request.fullpath.match(a) ? "active" : "" unless klass == "active" } if options[:alt_links].is_a?(Array)
    klass = "active" if link == request.fullpath
    klass += " #{options[:class]}" unless options[:class].blank?
    return link_to(title, link, :class => klass)
  end

  # now uses http://github.com/mdeering/gravatar_image_tag
  def gravatar_for(object)
    gravatar_image_tag(object.email)
  end

  def table_row(*args)
    html = "<tr>"
    args.each_with_index do |cell, i|
      html += "<td class='cell-#{i+1}'>#{cell}</td>"
    end
    html += "</tr>\n"

    html.html_safe
  end

  def seo_meta_tags
    obj = instance_variable_get("@#{params[:controller].singularize}")
    tags = []
    if obj && obj.respond_to?(:seo_keywords) && obj.respond_to?(:seo_description)
      tags << tag(:meta, {:name => "description", :content => obj.seo_description}) unless obj.seo_description.blank?
      tags << tag(:meta, {:name => "keywords", :content => obj.seo_keywords }) unless obj.seo_keywords.blank?
      return tags.join
    end
  end

  # eg. first_image(@product)
  def first_image(obj, options = {})
    opts = {
      :collection => :images,
      :method => :image,
      :style => :thumbnail,
      :default => image_path('noimage.jpg')
    }.merge(options.symbolize_keys!)

    image = obj.send(opts[:collection]).first
    image ? image.send(opts[:method]).url(opts[:style]) : opts[:default]
  end

  def html(options = { }, &blk)
    options.recursive_symbolize_keys!

    open = h5bp_opening_tag(options[:ie_versions])
    body = capture_haml(&blk)
    close = "</html>".html_safe

    open + body + close
  end

  private

  def h5bp_opening_tag(ie_versions=6..8)
    ie_versions = ie_versions.to_a

    htmls = [ ]
    max = ie_versions.max

    # individual IE versions
    ie_versions.each do |version|
      next if version == max

      klass = ie_versions.select { |e| e > version }.map { |e| "ie-lt#{e}" }.join(' ')

      htmls << if_ie("<html lang='#{I18n.locale}' dir='ltr' class='noscript #{klass}'>", :version => version)
    end

    # trailing GT for forward compatibility
    htmls << if_ie("<html lang='#{I18n.locale}' dir='ltr' class='noscript'>", :version => ">=#{max}", :show_in_other_browsers => true)
    htmls.join($/).html_safe
  end

  def if_ie(obj, options = { })
    options.recursive_symbolize_keys!

    # grab the kwargs
    version = options[:version]
    negative = options[:negative]
    show_in_other_browsers = options[:show_in_other_browsers]

    # support things like >10
    if version.respond_to?(:start_with?) && version.respond_to?(:scan)
      modifier = if version.start_with?('>=')
        'gte'
      elsif version.start_with?('<=')
        'lte'
      elsif version.start_with?('<')
        'lt'
      elsif version.start_with?('>')
        'gt'
      end

      version = version.scan(/\d/).join.to_i
    end

    selector = "#{negative && '!'}(#{modifier} IE #{version})"

    if show_in_other_browsers
      "<!--[if #{selector}]> -->#{obj.to_s}<!-- <![endif]-->"
    else
      "<!--[if #{selector}]>#{obj.to_s}<![endif]-->"
    end
  end

end
