var app = app || {};

(function () {
  'use strict';

  app.User = Backbone.Model.extend({
    defaults: {
      name: "initName"
    },
  });
})();
