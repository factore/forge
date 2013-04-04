APP.features.checkout = {
  config: {
    $billingProvince: $("#billing_address_province_id"),
    $billingCountry: $("#billing_address_country_id"),
    $shippingProvince: $("#shipping_address_province_id"),
    $shippingCountry: $("#shipping_address_country_id")
  },
  
  init: function (options) {
    var self = APP.features.checkout;
    $.extend(self.config, options);
    self.updateProvincesForSelectedCountry(self.config.$billingProvince, self.config.$billingCountry);
    self.updateProvincesForSelectedCountry(self.config.$shippingProvince, self.config.$shippingCountry);
    
    self.config.$billingCountry.on('change', function() { self.updateProvincesForSelectedCountry(self.config.$billingProvince, self.config.$billingCountry) });
    self.config.$shippingCountry.on('change', function() { self.updateProvincesForSelectedCountry(self.config.$shippingProvince, self.config.$shippingCountry) });
    self.toggleShippingAddressField();
  },
  
  updateProvincesForSelectedCountry: function (provinceElement, countryElement) {
    var self = APP.features.checkout;
    
    $.getJSON('/countries/' + countryElement.val() + '/get_provinces_for_checkout.js', function(data) {
      province_element.html(self.createOptionsFromJSON(data, provinceElement.val())); 
    });
  },
  
  createOptionsFromJSON: function (data, currentVal) {
    var html = "";
    var selected = "";
    $.each(data, function(index, element) {
      selected = element[1] == currentVal ? " selected='selected'" : "";
      html += "<option value='" + element[1] + selected + "'>" + element[0] + "</option>\n";
    });
    return html;
  },
  
  toggleShippingAddressField: function () {
    if($("#use_billing_for_shipping").is(":checked")) {
      $('.shipping_address').hide();
    };

    $('#use_billing_for_shipping').change(function() {
      if($(this).is(":checked")) {
        $('.shipping_address').hide();
      } else {
        $('.shipping_address').show();
      }  
    });
  }
}
