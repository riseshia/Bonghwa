var app = app || {};

(function ($) {
  'use strict';

  app.UsersView = Backbone.View.extend({
    el: '#users',

    userTemplate: _.template($('#user-template').html()),

    initialize: function () {
      this.$header = this.$('#users-header');
      this.$body = this.$('#users-body');

      this.listenTo(app.users, 'reset', this.addAll);
    },

    addAll: function () {
      this.$body.html('');
      this.$header.html('접속자(' + app.users.length + '명)');
      _.each(this.currentList, function (view) { view.remove(); });

      this.currentList = [];
      app.users.each(function (user) {
        var view = new app.UserView({ model: user });
        this.$body.append(view.render().el);
        this.currentList.push(view);
      }, this);
    },


    clkUsername: function () {
      var arr = [this.model.get('name')];

      app.FirewoodsView.trigger('form:appendMt', arr);
    }
  });
})(jQuery);