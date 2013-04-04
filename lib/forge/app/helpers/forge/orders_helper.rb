module Forge::OrdersHelper

  def fulfillment_link(order)
    if order.fulfilled?
      content_tag :div, :class => "item-action fulfill" do
        icon_tag("yay") +
          content_tag(:div, "", :class => "spacer") +
          link_to("Unfulfill.", unfulfill_forge_order_path(order), :class => "unapprove", :method => :put, :id => order.id)
      end
    elsif order.aasm_events_for_state(order.state.to_sym).include?(:fulfill)
      content_tag :div, :class => "item-action fulfill" do
        icon_tag("nay") +
          content_tag(:div, "", :class => "spacer") +
          link_to("Fulfill", fulfill_forge_order_path(order), :class => "approve", :method => :put, :id => order.id)
      end
    end
  end

end
