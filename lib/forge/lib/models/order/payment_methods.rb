module Models
  module Order
    module PaymentMethods
      extend ActiveSupport::Concern

      included do
        # methods added here will be class_eval'd in the including class, so we can add stuff like:
        # has_many :friendships
        attr_reader :status, :message, :credit_card
      end

      module ClassMethods
        # used for billing address, but can also be used for shipping address
        # creates an options hash (needed for ActiveMerchant) from an object
        def options_from_addressed_object(object)
          options = {}
          if object
            cc = ActiveMerchant::Country::COUNTRIES.detect {|c| c[:name] == object[:country]}
            code = cc.nil? ? "" : cc[:alpha2]
            options = {
              :name => "#{object[:first_name]} #{object[:last_name]}",
              :address1 => object[:address1],
              :address2 => object[:address2],
              :city => object[:city],
              :state => object[:province],
              :zip => object[:postal],
              :phone => object[:phone],
              :country => code # get their country code
            }
          end
          options
        end
      end

      module InstanceMethods

        def create_credit_card(args)
          @credit_card = ActiveMerchant::Billing::CreditCard.new(
            :first_name => self.billing_address.first_name,
            :last_name => self.billing_address.last_name,
            :month => args[:month],
            :year => args[:year],
            :verification_value => args[:verification_value],
            :number => args[:number]
          )
        end

        def pay
          raise "Credit card cannot be nil" if @credit_card.nil?

          # build the options hash for the payment
          options = options_hash(self.description)
          if @credit_card.valid?
            capture = purchase(@credit_card, options)
            if capture.success? && self.paid?
              @message = "Successfully charged $#{sprintf("%.2f", self.total)} to the credit card #{credit_card.display_number}"
            else
              @status = :failure
              @message = "Payment capture failed.  <br />#{capture.message}<br />Please contact your credit card company to determine the problem, or retry with a different card."
            end
            @status = order.state.to_sym
          else
            @status = :invalid_credit_card
            @message = "The credit card number you have entered is not valid."
          end
          return @status == :paid
        end

        private

          def options_hash(description)
            options = {}
            options[:description] = description
            options[:currency] = MySettings.currency
            options[:customer] = "#{self.billing_address[:first_name]} #{self.billing_address[:last_name]}"
            options[:email] = self.billing_address[:email]
            options[:billing_address] = Order.options_from_addressed_object(self.billing_address)
            options[:shipping_address] = Order.options_from_addressed_object(self.shipping_address)
            options
          end
        end

      end
    end
  end
