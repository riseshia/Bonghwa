var app = app || {};

(function () {
  'use strict';

  var Users = Backbone.Collection.extend({
    model: app.Users,

    comparator: 'id'
  });

  app.users = new Users();
})();