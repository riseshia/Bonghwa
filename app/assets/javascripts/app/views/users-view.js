var app = app || {};

(function ($) {
  'use strict';

  app.UsersView = Backbone.View.extend({
    el: '#users',

    userTemplate: _.template($('#user-template').html()),

    initialize: function () {
      this.$header = $('#users-header');
      this.$body = $('#users-body');

      this.listenTo(app.users, 'reset', this.addAll);
    },

    addAll: function () {
      this.$body.html('');
      this.$header.html("접속자(" + app.users.length + "명)");

      app.users.each(function (user) {
        this.$body.append(this.userTemplate(user.toJSON()));
      }, this);
    }
  });
})(jQuery);