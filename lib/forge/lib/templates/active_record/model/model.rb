class <%= class_name %> < ActiveRecord::Base
  # Scopes, attachments, etc.
<% unless attributes.select{|a| a.name == "list_order" }.empty? -%>
  include Forge::Reorderable
  default_scope :order => '<%= table_name %>.list_order'
<% end -%>
<% attributes.select {|a| a.name.match(/_content_type|_file_size|_file_name/)}.map {|a| a.name.split('_')[0..-3].join('_')}.uniq.each do |f| -%>
  has_attached_file :<%= f %>, :styles => {:thumbnail => "120x108#"}
  can_use_asset_for :<%= f %>
<% end -%>
<% attributes.select { |a| ["datetime", "timestamp"].include?(a.type.to_s) }.each do |f| -%>
  attr_accessor :<%= f.name %>_date, :<%= f.name %>_time
  before_save :set_<%= f.name %>
<% end -%>

  # Validations
<% attributes.select { |a| ["datetime", "timestamp"].include?(a.type.to_s) }.each do |f| -%>
  validates_format_of :<%= f.name %>_time, :with => /\d{1,2}:\d{2}[AaPp][Mm]/i, :message => "must be a valid 12-hour time."
  validates_format_of :<%= f.name %>_date, :with => /\d{4}\-\d{2}\-\d{2}/, :message => "must match format of YYYY-MM-DD"
<% end -%>

  # Relationships
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
<% attributes.select {|a| a.name.match(/_id$/)}.each do |attribute| -%>
  belongs_to :<%= attribute.name.gsub(/_id$/, '') %>
<% end -%>

  private
<% attributes.select { |a| ["datetime", "timestamp"].include?(a.type.to_s) }.each do |f| -%>
    def set_<%= f.name %>
      begin
        self.<%= f.name %> = "#{self.<%= f.name %>_date} #{self.<%= f.name %>_time}"
      rescue
        errors.add(:<%= f.name %>, "must be a valid date and time.")
        false
      end
    end
<% end -%>
end