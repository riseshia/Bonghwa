var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodView = Backbone.View.extend({
    tagName: 'li',

    template: _.template($('#fw-template').html()),
    mtTemplate: _.template($('#mt-template').html()),

    events: {
      'click .delete': 'delete',
      'click .mt-clk': 'clkUsername',
      'click .mt-to': 'toggleFolding',
      'click .mt-open': 'fold'
    },

    render: function () {
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.addClass('list-group-item div-firewood');

      return this;
    },

    delete: function () {
      var self = this;
      var dataId = this.model.get('id');
      var really = confirm('정말 삭제하시겠어요?');

      if ( !really )
        return false;

      $.ajax({
        url: '/api/destroy?id=' + dataId,
        type: 'delete',
        dataType: 'json'
      }).then(function () {
        self.remove();
      });
    },

    clkUsername: function (e) {
      e.preventDefault();
      
      var arr = [this.model.get('name')];
      app.BWClient.trigger('form:appendMt', arr, this.model.get('id'));
    },

    toggleFolding: function (e) {
      e.preventDefault();

      if ( this.$el.hasClass('mt-open') ) {
        this.fold();
      } else {
        this.unFold();
      }

      this.$el.toggleClass('mt-open');

      return this;
    },

    unFold: function (e) {
      var fws = app.firewoods.getPreviousFws(this.model, 5);
      if (fws.length == 0) {
        return this;
      }

      var $self = this.$el;
      $self.find('.fw-main')
           .after('<div class="loading" style="display:none;">로딩중입니다.</div>');
      $self.find('.loading')
           .slideDown(200);

      // rendering
      var $body = $('<li class="list-group-item div-mention">');
      _.each(fws, function (fw) {
        $body.append(this.mtTemplate(fw.toJSON()));
      }, this);

      // img check
      var imgLink = this.model.get('img_link');
      if (imgLink != '0') {
        var templ = _.template($('#img-template').html());
        // consider window size, use different css
        var scale = ( $(window).width() > $(window).height() ? 'standard' : 'mobile' );
        $body.append(templ({scale: scale, imgLink: imgLink}));
      }

      $self.find('.loading')
           .remove();
      $self.find('.fw-sub')
           .html($body.html())
           .slideDown(200);

      return this;
    },

    fold: function (e) {
      this.$el.find('.fw-sub').slideUp(function () { $(this).html(''); });
      return this;
    }
  });
})(jQuery);
