class ForgeFormBuilder < ActionView::Helpers::FormBuilder
  include Ckeditor::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  attr_accessor :output_buffer
  alias :super_label :label

  def title_field(method_name, options = {})
    options[:last] = true
    content = build_content(:title_field_content, method_name, options)
  end

  def title_field_content(method_name, options = {}, language = nil, language_title = nil)
    label = label(method_name, options[:label], language, language_title)
    explanation = explanation(options[:explanation])
    row_label = content_tag(:div, label + explanation, :class => "label")
    row_label.html_safe + @template.text_field(@object_name, get_method(method_name, language), options.merge({:class => "title"})) + content_tag(:div, "", :class => "spacer")
  end

  alias :super_cktext_area :cktext_area
  def cktext_area(method_name, options = {})
    content = build_content(:cktext_area_content, method_name, options)
  end

  def cktext_area_content(method_name, options = {}, language = nil, language_title = nil)
    label = label(method_name, options[:label], language, language_title)
    explanation = explanation(options[:explanation])
    label + explanation + super_cktext_area(get_method(method_name, language), options)
  end

  alias :super_text_field :text_field
  def text_field(method_name, options = {})
    content = build_content(:text_field_content, method_name, options)
  end

  def text_field_content(method_name, options = {}, language = nil, language_title = nil)
    label = label(method_name, options[:label], language, language_title)
    explanation = explanation(options[:explanation])
    label + explanation + super_text_field(get_method(method_name, language), options)
  end

  alias :super_text_area :text_area
  def text_area(method_name, options = {})
    content = build_content(:text_area_content, method_name, options)
  end

  def text_area_content(method_name, options = {}, language = nil, language_title = nil)
    label = label(method_name, options[:label], language, language_title)
    explanation = explanation(options[:explanation])
    label + explanation + super_text_area(get_method(method_name, language), options)
  end

  def datetime_widget(method_name, options = {})
    label = label(method_name, options[:label], nil, nil)
    explanation = explanation(options[:explanation])

    on = content_tag(:tr) do
      [
        content_tag(:td, "On: "),
        content_tag(:td, super_text_field("#{method_name}_date", :class => "datepicker", :size => 12, :value => @object.send(method_name) ? @object.send(method_name).strftime('%Y-%m-%d') : (options[:default_date] || Time.now.strftime('%Y-%m-%d'))))
      ].join("\n").html_safe
    end
    at = content_tag(:tr) do
      [
        content_tag(:td, "At: "),
        content_tag(:td, super_text_field("#{method_name}_time", :value => @object.send(method_name) ? @object.send(method_name).strftime('%l:%M%p').strip : (options[:default_time] || Time.now.strftime('%l:%M%p').strip), :size => 7))
      ].join("\n").html_safe
    end
    table = content_tag(:table, on + at, :class => 'datetime_select')

    content = label(method_name, options[:label], nil, nil)
    content += explanation(options[:explanation])
    content += content_tag(:div, table, :class => 'inset datetime-widget')
    content += content_tag :hr unless options[:last]
  end

  private
    def build_content(generator, method_name, options)
      content = self.send(generator, method_name, options)
      content = internationalize_content(generator, method_name, content, options) if ::I18nLookup.new(@object.class).fields.include? method_name.to_s
      content += content_tag :hr unless options[:last]
      content
    end

    def internationalize_content(generator, method_name, content, options = {})
      if Forge.config.languages
        content = content_tag(:div, content, :class => "i18n en")
        Forge.config.languages.each do |lang_title, lang|
          content += content_tag(:div, self.send(generator, method_name, options, lang, lang_title), :class => "i18n #{lang}")
        end
        content = framed_content(content, options)
      else
        content
      end
    end

    def explanation(explanation)
      explanation ? content_tag(:div, explanation.html_safe, :class => "explanation") : ""
    end

    def label(method_name, label, language = nil, language_title = nil)
      unless label == false
        label ||= method_name.to_s.titleize
        label = language_title ? label + " (#{language_title.to_s.titleize})" : label
        super(get_method(method_name, language), label.html_safe)
      else
        ''.html_safe
      end
    end

    def get_method(method, language = nil)
      language ? "#{method}_#{language}" : method
    end

    def framed_content(content, options = {})
      content_tag :div, :class => 'i18n-holder', :style => ('display: inline-block;' if options[:inline]) do
        content_tag :div, content, :class => "i18n-frame"
      end
    end
end
