module ActiveForm
  def self.included(base)
    base.class_eval do
      alias_method :save, :valid?
      def self.columns() @columns ||= []; end
 
      def self.column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
      end
    end
  end
end