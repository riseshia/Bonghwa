var app = app || {};

(function () {
  'use strict';

  var Firewoods = Backbone.Collection.extend({
    model: app.Firewood,

    prepend: function (fws, type) {
      this.unshift(fws);

      if ( type == -1 ) {
        this.trigger('add:stack');
      } else if ( type == 0 ) {
        this.trigger('add:prepend');
      }
    },

    append: function (fws) {
      this.push(fws);
      this.trigger('add:append');
    }

  });

  app.firewoods = new Firewoods();
})();