var app = app || {};

(function ($) {
  'use strict';

  app.MentionsView = Backbone.View.extend({
    tagName: 'li',

    mtTemplate: _.template($('#mt-template').html()),
    imgTemplate: _.template($('#img-template').html()),

    initialize: function(args) {
      if ( args.fws[0] && args.fws[0].toJSON ) {
        args.fws = _.map(args.fws, function (fw) { return fw.toJSON() });
      }

      this.parentView = args.parentView;
      this.fws = args.fws || [];
    },

    render: function () {
      this.$el.html(this.textRender() + this.imgRender());
      this.$el.addClass('list-group-item div-mention');

      return this;
    },

    textRender: function () {
      var arr = _.map(this.fws, function (fw) {
        return this.mtTemplate(fw);
      }, this);
      return arr.join('');
    },

    imgRender: function () {
      var imgLink = this.parentView.model.get('img_link');
      if (imgLink != '0') {
        return this.imgTemplate({imgLink: imgLink});
      } else {
        return '';
      }
    }
  });
})(jQuery);
