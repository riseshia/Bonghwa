var app = app || {};

(function () {
  'use strict';

  var Firewoods = Backbone.Collection.extend({
    model: app.Firewood,

    comparator: 'id'
  });

  app.firewoods = new Firewoods();
})();