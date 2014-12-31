var app = app || {};

(function () {
  'use strict';

  var BWRouter = Backbone.Router.extend({
    routes: {
      'now': 'typeNow',
      'mt': 'typeMt',
      'me': 'typeMe'
    },

    typeNow: function () {
      window.PAGE_TYPE = 1;
      app.channel.load();
    },

    typeMt: function () {
      window.PAGE_TYPE = 2;
      app.channel.load();
    },

    typeMe: function () {
      window.PAGE_TYPE = 3;
      app.channel.load();
    }
  });

  app.BWRouter = new BWRouter();
  Backbone.history.start();
})();
