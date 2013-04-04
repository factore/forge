FORGE.features.Dispatch = function (id) {
  this.id = id;
}


FORGE.features.Dispatch.prototype.init = function () {
  var self = this;
  $.getJSON('/forge/dispatches/' + self.id + '/chart_data', function(data) {
    $.extend(self, data);
    self.renderProgress();
    self.renderLineChart();
  });
}

FORGE.features.Dispatch.prototype.renderProgress = function () {
  var self = this,
      openedWidth = this.opened_messages / this.total_messages * 100,
      unopenedWidth = this.sent_messages / this.total_messages * 100;

  $('#dispatch-progress-sent').animate({width: unopenedWidth + '%'}, 850, function () {
    $('#dispatch-progress-read').animate({width: openedWidth + '%'}, 850);
  });
}

FORGE.features.Dispatch.prototype.renderLineChart = function () {
  var self = this;
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Date');
  data.addColumn('number', 'Clicks');
  data.addColumn('number', 'Opens');
  data.addColumn('number', 'Unsubscribes');

  data.addRows(self.days.length);
  for(i = 0; i < self.days.length; i++) {
    data.setValue(i, 0, FORGE.helpers.dateFormat(self.days[i], 'mmm d'));
    data.setValue(i, 1, self.clicks_over_time[i][self.days[i]]);
    data.setValue(i, 2, self.opens_over_time[i][self.days[i]]);
    data.setValue(i, 3, self.unsubscribes_over_time[i][self.days[i]]);
  }

  var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
  chart.draw(data, {
    width: 660,
    height: 200,
    backgroundColor: '#cdd2d6',
    title: null,
    chartArea: {left: 30, right: 0, width: 790, top: 15, height: 140},
    gridlineColor: '#5A5A5A',
    lineWidth: 3,
    pointSize: 6,
    hAxis: {textStyle: {color: '#5c5c5c'}},
    vAxis: {textStyle: {color: '#5c5c5c'}},
    colors: ['#FFF', '#D61D23', '#80b0e1']

  });

  $('#chart-div-holder').fadeIn(1250);
}