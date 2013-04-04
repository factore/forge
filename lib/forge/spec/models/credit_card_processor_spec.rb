require 'spec_helper'

describe Forge::CreditCardProcessor do
  # About the credit card processor: this is tightly coupled with ActiveMerchant, and with the Order model
  # it allows us to process credit cards and it returns some sensible messages when it does so.
  fixtures(:all)

  describe "credit card processing" do

    before(:each) do
      @order = orders(:pending_with_addresses)
    end

    it "should create a credit card" do
      processor = Forge::CreditCardProcessor.new(@order)
      processor.create_credit_card(
        :number => "4111111111111111", 
        :verification_value => "123",
        :month => "8",
        :year => "#{ Time.now.year + 1 }"
      )
      assert processor.credit_card.is_a?(ActiveMerchant::Billing::CreditCard)
      assert processor.credit_card.valid?
      assert_equal processor.credit_card.number, "4111111111111111"
      processor.credit_card.verification_value.should == "123"
    end
	
    it "should fail with invalid credit card" do
      processor = Forge::CreditCardProcessor.new(@order)
      processor.create_credit_card(
        :number => "blah blah blah", 
        :verification_value => "561",
        :month => "8",
        :year => "#{ Time.now.year + 1 }"
      )
      assert processor.pay(@order) == false
      processor.status.should == :invalid_credit_card
    end
    
    it "should fail" do
      processor = Forge::CreditCardProcessor.new(@order)
      processor.create_credit_card(
        :number => "2", 
        :verification_value => "561",
        :month => "8",
        :year => "#{ Time.now.year + 1 }"
      )
      assert processor.pay(@order) == false
      processor.status.should == :failed
    end
    
    it "should succeed" do
      processor = Forge::CreditCardProcessor.new(@order)
      processor.create_credit_card(
        :number => "1", 
        :verification_value => "123",
        :month => "8",
        :year => "#{ Time.now.year + 1 }"
      )
      
      assert processor.pay(@order) == true
      assert_equal processor.status, :paid
      assert @order.paid?
    end
  end
    
end
