var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodsView = Backbone.View.extend({
    el: '#timeline',

    initialize: function () {
      this.listenTo(app.firewoods, 'reset', this.addAll);
    },

    render: function () {

    },

    // Event
    addAll: function() {
      this.$el.html('');
      app.firewoods.each(function (fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$el.append(view.render().el);
      }, this);
    }
  });
})(jQuery);