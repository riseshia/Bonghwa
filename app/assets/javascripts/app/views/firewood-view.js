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
      'click .mt-to': 'unFold'
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
      app.BWClient.trigger('form:appendMt', arr);
    },

    unFold: function (e) {
      e.preventDefault();

      var prev_id = this.model.get('prev_mt');
      if ( prev_id == 0 ) {
        return this;
      }

      // find previous mt at most 5
      var fws = [];
      var tmp = this;
      while ( true ) {
        tmp = app.firewoods.findWhere({id: prev_id});
        fws.push(tmp);
        prev_id = tmp.get('prev_mt');

        if (prev_id == 0 && list < 5) {
          break;
        }
      }

      $self = this.$el;
      $self.removeClass('mt-to')
           .addClass('mt-open')
           .find('.fw-main')
           .after('<div class="loading" style="display:none;">로딩중입니다.</div>');
      $self.find('.loading')
           .slideDown(200);

      var $body = $('<li class="list-group-item div-mention">');
      _.each(fws, function (fw) {
        $body.append(this.mtTemplate(fw));
      }, this);

      $self.find('.loading').remove();
      $self.find('.fw-sub')
           .html($body.html())
           .slideDown(200);

      return this;
    }
  });
})(jQuery);
