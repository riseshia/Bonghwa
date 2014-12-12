var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodsView = Backbone.View.extend({
    el: '#timeline',

    initialize: function () {
      this.listenTo(app.firewoods, 'reset', this.addAll);
      this.listenTo(app.firewoods, 'add:prepend', this.prepend);
      this.listenTo(app.firewoods, 'add:append', this.append);
    },

    render: function () {

    },

    // Event
    addAll: function () {
      this.$el.html('');
      app.firewoods.each(function (fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$el.append(view.render().el);
      }, this);
    },
    prepend: function () {
      var fws = app.firewoods.where({ state: -1 });
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$el.prepend(view.render().el);
        fw.set('state', 0);
      }, this);
    },
    append: function () {
      var fws = app.firewoods.where({ state: 1 });
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$el.append(view.render().el);
        fw.set('state', 0);
      }, this);
    }
  });
})(jQuery);