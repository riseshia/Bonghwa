var app = app || {};

(function ($) {
  'use strict';

  app.UserView = Backbone.View.extend({
    tagName: 'li',

    template: _.template($('#user-template').html()),

    events: {
      'click .mt-clk': 'clkUsername'
    },

    render: function () {
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.addClass('list-group-item div-username');

      return this;
    },


    clkUsername: function () {
      var arr = ['@' + this.model.get('name')];

      app.firewoods.trigger('form:appendMt', arr);
    }
  });
})(jQuery);
