require 'spec_helper'

describe TaxRate do
  fixtures :all

  it { should validate_presence_of :title  }
  it { should validate_presence_of :rate }
  it { should validate_presence_of :country }
  it { should validate_numericality_of :rate }


  # sanity check
  it "should be sane" do
    tax_rate = tax_rates(:valid)
    tax_rate.valid?.should_not == nil
  end

  it "should have unique country+province" do
    tr1 = TaxRate.new(:title => "Test1", :rate => 1.0, :country_id => countries(:us).id)
    tr1.save

    tr2 = TaxRate.new(:title => "Test2", :rate => 1.0, :country_id => countries(:us).id)
    tr2.valid?.should_not == true
    tr2.errors[:base].include?("There is already a tax rate for that country and province/state").should_not == nil

    tr3 = TaxRate.new(:title => "Test3", :rate => 1.0, :country_id => countries(:us).id, :province_id => provinces(:ny).id)
    tr3.valid?.should_not == nil
    tr3.save

    tr4 = TaxRate.new(:title => "Test3", :rate => 1.0, :country_id => countries(:us).id, :province_id => provinces(:ny).id)
    tr4.valid?.should_not == true
    tr4.errors[:base].include?("There is already a tax rate for that country and province/state").should_not == nil
  end

end
