class TaxRate < ActiveRecord::Base
  has_and_belongs_to_many :products
  belongs_to :country
  belongs_to :province

  validates_presence_of :title, :rate, :country
  validates_numericality_of :rate, :greater_than => 0.0
  validate :unique_country_and_province

  # the new ActiveAssociation stuff is teh bomb!
  scope :by_country_and_province, joins(:country).joins("LEFT OUTER JOIN provinces ON tax_rates.province_id = provinces.id").order('countries.title, provinces.title')
  
  protected

    def unique_country_and_province
      if self.id
        tax_rates = TaxRate.where(["country_id = ? and province_id = ? and id != ?", self.country_id, self.province_id, self.id]).all
      else
        tax_rates = TaxRate.where(:country_id => self.country_id, :province_id => self.province_id).all
      end
      if tax_rates.size > 0
          errors.add :base, "A tax rate already exists for this country and province"
      end
    end

end
