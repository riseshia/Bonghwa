var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodView = Backbone.View.extend({
    tagName: 'li class="list-group-item div-firewood"',

    template: _.template($('#fw-template').html()),

    render: function () {
    }

  });
})(jQuery);
