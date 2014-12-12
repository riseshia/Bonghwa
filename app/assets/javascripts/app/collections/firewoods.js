var app = app || {};

(function () {
  'use strict';

  var Firewoods = Backbone.Collection.extend({
    model: app.Firewood
  });

  app.firewoods = new Firewoods();
})();