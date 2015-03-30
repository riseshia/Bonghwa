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
      $('.all_nav').parent().removeClass('active')
      $('.now_nav').parent().addClass('active');
      app.channel.load();
    },

    typeMt: function () {
      window.PAGE_TYPE = 2;
      $('.all_nav').parent().removeClass('active')
      $('.mt_nav').parent().addClass('active');
      app.channel.load();
    },

    typeMe: function () {
      window.PAGE_TYPE = 3;
      $('.all_nav').parent().removeClass('active')
      $('.me_nav').parent().addClass('active');
      app.channel.load();
    }
  });

  app.BWRouter = new BWRouter();
})();
