var app = app || {};

(function () {
  'use strict';

  var Firewoods = Backbone.Collection.extend({
    model: app.Firewood,

    prepend: function (fws) {
      this.unshift(fws);
      this.trigger('add:prepend');
    },

    append: function (fws) {
      this.push(fws);
      this.trigger('add:append');
    }

  });

  app.firewoods = new Firewoods();
})();