// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// make respond_to work with jquery
jQuery.ajaxSetup({ beforeSend: function(xhr) { xhr.setRequestHeader("Accept", "text/javascript"); } });

jQuery(document).ajaxSend(function(event, request, settings) {
  if (settings.type == 'GET' || settings.type == 'get' || typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

function clearUIClasses() {
  $('.ui-widget-content:not(.ui-datepicker)').removeClass('ui-widget ui-widget-content ui-widget-header ui-corner-all ui-corner-bottom');
  $('.ui-widget-header').removeClass('ui-widget-header');
  $('.tabbed li').removeClass('ui-corner-top');
}
