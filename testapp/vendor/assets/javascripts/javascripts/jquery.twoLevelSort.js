(function($){
 $.fn.forgeTwoLevelSort = function(options) {

    var defaults = {
      subSelector: '.subpages',
      topSelector: 'li.top',
      topClass: 'top',
      subClass: 'subpage',
      promoteSelector: '.promote',
      itemArray: 'page_list[]'
    };

    var options = $.extend(defaults, options);

    return this.each(function() {
      var obj = $(this);
      obj.sortable({ items: options.topSelector, update: function(event, ui) { updateTopOrder(this); } });
      $('ul', obj).sortable({ connectWith: options.subSelector, update: function(event, ui) { updateSubpageOrder(this); } });


      $(options.promoteSelector, obj).click(function(e) {
        e.preventDefault();
        page = $(this).closest('li');
        page.remove().appendTo(obj).addClass(options.topClass).removeClass(options.subClass);
        var ul = $('<ul />').addClass(options.subSelector).append("<li class='placeholder'></li>");
        page.append(ul);
        $(this).parent().remove();

        updateTopOrder(obj);
      });


      function showValues(object) {
        var arr = new Array;
        $(object).children().each(function() {
          arr.push($(this).attr('id'));
        });
        return arr;
      }

      function updateTopOrder(object) {
        var data = {};
        data[options.itemArray] = showValues(object);
        $.ajax({type: "POST", url: options.callbackPath, data: data});
      }

      function alternateRows() {
        $('li', obj).removeClass('alternate').removeClass('normal');
        $('li:odd[class!=placeholder]', obj).addClass('alternate');
        $('li:even[class!=placeholder]', obj).addClass('normal');
      }

      function updateSubpageOrder(object) {
        FORGE.features.nestedLists.setSubpageTitleSize();
        var data = {parent_id: $(object).closest('li').attr('id')};
        data[options.itemArray] = showValues(object);
        $.ajax({type: "POST", url: options.callbackPath, data: data});
      }

    });
 };
})(jQuery);