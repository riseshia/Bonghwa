var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodView = Backbone.View.extend({
    tagName: 'li',

    template: _.template($('#fw-template').html()),

    render: function () {
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.addClass("list-group-item div-firewood");

      return this;
    }
  });
})(jQuery);
