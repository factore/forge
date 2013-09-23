class DispatchQueueCreator

  class << self

    def send_to_all_subscribers!(dispatch)
      send_dispatch_to_subscribers(dispatch, Subscriber.all)
    end

    def send_to_subscribed_users!(dispatch)
      send_dispatch_to_subscribers(dispatch, User.subscribed.select('id, first_name, last_name, email'))
    end

    def send_to_groups!(dispatch, group_ids)
      send_dispatch_to_subscribers(dispatch, SubscriberGroup.subscribers_from_group_ids(group_ids))
    end

    def send_to_roles!(dispatch, roles)
      users = User.subscribed
      conditions = roles.map {|r| "role = :#{r.gsub(" ","_").underscore}"}.join(" OR ")
      parameters = Hash[roles.map {|r| [r.underscore.dehumanize.to_sym, r]}]
      users = users.where(conditions, parameters)
      send_dispatch_to_subscribers(dispatch, users)
    end

    def send_to_subscribers_from_object!(dispatch, object, method_that_returns_objects_with_email_addresses, *args_for_method_that_returns_objects)
      send_dispatch_to_subscribers(dispatch, object.send(method_that_returns_objects_with_email_addresses, *args_for_method_that_returns_objects))
    end

    private

      def send_dispatch_to_subscribers(dispatch, subscribers)
        subscribers.each do |subscriber|
          QueuedDispatch.send_dispatch_to_object_with_name_and_email!(dispatch, subscriber)
        end
        dispatch.update_attributes(:sent_at => Time.now)
      end

  end
end
