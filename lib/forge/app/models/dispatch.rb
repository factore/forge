class Dispatch < ActiveRecord::Base
  require 'hpricot'
  
  has_many :messages, :class_name => "QueuedDispatch"
  has_many :queued_messages, :class_name => "QueuedDispatch", :conditions => 'sent_at IS NULL'
  has_many :sent_messages, :class_name => "QueuedDispatch", :conditions => "sent_at IS NOT NULL"
  has_many :failed_messages, :class_name => "QueuedDispatch",  :conditions => ["failed_attempts > ?", 0]
  has_many :opens, :class_name => "DispatchOpen"
  has_many :dispatch_links
  has_many :clicks, :through => :dispatch_links
  has_many :unsubscribes, :class_name => "DispatchUnsubscribe"

  validates_presence_of :subject, :content
  
  after_save :update_dispatch_links
  
  def deliver!(group_ids = [])
    subscribers = group_ids.blank? ? Subscriber.all : SubscriberGroup.find_all_by_id(group_ids).map(&:subscribers).flatten.uniq
    subscribers.each {|s| 
      qd = QueuedDispatch.create(:subscriber => s, :dispatch => self)
      qd.send!
    }
    self.update_attributes(:sent_at => Time.now)
  end
  handle_asynchronously :deliver!
  
  def display_content
    doc = Hpricot(self.content)
    self.dispatch_links.each do |dispatch_link|
      doc.search('a')[dispatch_link.position]["href"] = "#{MySettings.site_url}/dispatches/#{self.id}/links/#{dispatch_link.id}" if doc.search('a')[dispatch_link.position]
    end
    return doc.to_s
  end
  
  def chart_data
    days = (self.sent_at.to_date..Date.today).to_a
    unsubscribes = DispatchUnsubscribe.find_by_sql("SELECT DATE(created_at) as date, COUNT(*) as total FROM dispatch_unsubscribes WHERE dispatch_id = #{self.id} GROUP BY DATE(created_at)").map { |u| {u.date => u.total} }
    opens = DispatchOpen.find_by_sql("SELECT DATE(created_at) as date, COUNT(*) as total FROM dispatch_opens WHERE dispatch_id = #{self.id} GROUP BY DATE(created_at)").map { |u| {u.date => u.total} }
    clicks = DispatchLinkClick.find_by_sql("SELECT DATE(dlc.created_at) as date, COUNT(*) as total FROM dispatch_link_clicks dlc, dispatch_links dl WHERE dlc.dispatch_link_id = dl.id AND dl.dispatch_id = #{self.id} GROUP BY DATE(dlc.created_at)").map { |u| {u.date => u.total} }
    [unsubscribes, opens, clicks].each do |items|
      (days - items.map{|i| i.keys[0]}).each {|day| items << {day => 0}}
    end
    
    return {
      :unsubscribes_over_time => unsubscribes.sort_by {|i| i.keys[0]}, 
      :opens_over_time => opens.sort_by {|i| i.keys[0]}, 
      :clicks_over_time => clicks.sort_by {|i| i.keys[0]},
      :sent_messages => self.sent_messages.count,
      :opened_messages => self.opens.count,
      :total_messages => self.messages.count,
      :days => days
    }
  end
  
  private
    def update_dispatch_links
      doc = Hpricot(self.content)
      links = doc.search('a')
      links.each_with_index do |link, i|
        dispatch_link = DispatchLink.find_or_initialize_by_position_and_dispatch_id(i, self.id)
        dispatch_link.uri = link["href"] and dispatch_link.save!
      end
    
      self.dispatch_links.where("position >= ?", links.size).destroy_all
    end

  
end
