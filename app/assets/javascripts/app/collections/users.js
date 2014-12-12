var app = app || {};

(function () {
  'use strict';

  var Users = Backbone.Collection.extend({
    model: app.Users,
  });

  app.users = new Users();
})();