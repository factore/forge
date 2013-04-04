module FormHelper
  # form-header form row helper
  def forge_form_for(*args, &block)
    options = args.extract_options!
    options.merge(:builder => ::ForgeFormBuilder)
    form_for(*(args + [options]), &block)
  end

  def title_row(options = {})
    title = content_tag(:h3, options[:title] ? options[:title] : "Title")
    explanation = options[:explanation] ? content_tag(:div, options[:explanation], :class => "explanation") : ""
    row_label = content_tag(:div, title.html_safe + explanation.html_safe, :class => "label")
    return row_label.html_safe + yield + content_tag(:div, "", :class => "spacer")
  end

  # form row helper for narrow side column rows
  def side_row(title, options = {})
    title = content_tag(:h3, title)
    explanation = options[:explanation].blank? ? "" : content_tag(:div, options[:explanation], :class => "explanation")
    content = title.html_safe + explanation.html_safe + yield
    content += "<hr />".html_safe unless options[:last]
    content
  end

  # form row helper for pop-up window forms
  def form_row(label = nil, options = {})
    explanation = options[:explanation].blank? ? nil : "<div class='explanation'>#{options[:explanation]}</div>"
    required = options[:required].blank? ? nil : "&nbsp; *"
    style = options[:style].blank? ? nil : options[:style]
    id = options[:id].blank? ? nil :  options[:id]

    file_link = nil
    unless options[:file].nil? || (options[:file].url && options[:file].url.blank?) || (options[:file].is_a?(ActiveRecord) && options[:file].new_record?)
      #check for a_fu or paperclip
      options[:file].url = options[:file].public_filename if options[:file].url.nil?
      file_link = '<br /><small><a href="' + options[:file].url + '" target="_">View Current</a></small>'
    end

    label_td = content_tag(:td, "#{label}#{required}#{file_link}".html_safe, :class => "label")
    control_td = content_tag(:td, yield + "#{explanation}", :class => "control")
    return content_tag(:tr, label_td.html_safe + control_td.html_safe, :id => id, :style => style).html_safe
  end

  # form row helper for content blocks
  def content_row(title, options = {})
    title = content_tag(:h3, title)
    explanation = options[:explanation].blank? ? "" : content_tag(:div, options[:explanation], :class => "explanation")
    return title.html_safe + explanation.html_safe + "<br />".html_safe + yield
  end

  # form row helper for boolean published block
  def publish_box(f, object)
    if can?(:publish, object)
      return content_tag(:h3, "Publish") +
      content_tag(:div, "Is your #{object.class.to_s.downcase} ready to appear on your website?", :class => "explanation") +
      slider("Yes", f.radio_button(:published, true), "Not Yet", f.radio_button(:published, false)) +
      "<hr />".html_safe
    end
  end

  # asset library helper for adding an image to a model
  def file_select_widget(f, method, options = {})
    unique_id = Time.now.to_i
    field = "#{f.object.class.to_s.downcase}_#{method}"
    thumbnail_url = f.object.send("#{method}_asset_url".to_sym).blank? ? f.object.send("#{method}_icon_path".to_sym) : f.object.send("#{method}_asset_url".to_sym)
    content = ""

    # Build the links
    links = [link_to("Upload From Computer", '#', :class => "upload-file"), link_to("Choose From Library", '#', :class => "select-asset")]
    links << remove_child_link("Remove", f) if options[:allow_destroy]
    links << content_tag(:label, check_box_tag("remove_asset") + "Remove this asset")  if options[:allow_remove]

    # Build the rest of the widget
    content << image_tag(thumbnail_url, :class => "form-thumbnail") unless thumbnail_url.blank? # If the form failed, show the thumbnail of the previously selected asset
    content << f.hidden_field("#{method}_asset_id".to_sym, :class => "file-widget-asset-id")  # Eg. avatar_asset_id
    content << f.hidden_field("#{method}_asset_url".to_sym, :class => "file-widget-asset-url") # Eg. avatar_asset_url
    content << content_tag(:small, content_tag(:div, "", :class => "spacer") + links.join('<br />').html_safe)
    return content_tag :div, content.html_safe, :class => "extendable-inset"
  end

  def add_child_link(name, association)
    link_to(name, "#", :class => "add_child", :"data-association" => association)
  end

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f

    content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        render(:partial => options[:partial], :locals => {options[:form_builder_local] => f})
      end
    end
  end

  def language_switcher(table)
    if Forge::Settings[:languages]
      if I18nLookup.fields[:tables][table]
        select_tag "current_language", options_for_select([["English", "en"]] + Forge::Settings[:languages].map {|k, v| [k.to_s.titleize, v]})
      end
    end
  end
end
