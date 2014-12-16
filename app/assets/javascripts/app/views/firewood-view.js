var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodView = Backbone.View.extend({
    tagName: 'li',

    template: _.template($('#fw-template').html()),
    mtTemplate: _.template($('#mt-template').html()),

    initialize: function() {
      this.listenTo(this.model, 'fold', this.fold);
      this.listenTo(this.model, 'unFold', this.unFold);
      this.listenTo(this.model, 'highlight', this.highlight);
    },

    events: {
      'click .delete': 'delete',
      'click .mt-clk': 'clkUsername',
      'click .mt-to': 'toggleFolding',
      'click .fw-tag': 'clkTag'
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
      
      var targets = this.$('.mt-target');
      var arr = _.map(targets, function (target) { return $(target).text(); });
      arr.push((this.model.get('is_dm') == 0 ? '@':'!') + this.model.get('name'));

      app.firewoods.trigger('form:appendMt', _.uniq(arr), this.model.get('id'));
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
      // return not neccesary
      if ( this.model.get('prev_mt') === 0 && this.model.get('img_link') === '0' ) {
        return this;
      }

      var $self = this.$el;
      $self.find('.fw-main')
           .after('<div class="loading" style="display:none;">로딩중입니다.</div>');
      $self.find('.loading')
           .slideDown(200);

      var fws = app.firewoods.getPreviousFws(this.model, 5);
      var $body = $('<li class="list-group-item div-mention">');
      if ( fws.length == 0 ) {
        app.firewoods.ajaxMtLoad(function (json) {
          this.unFoldText(json.fws, $body);
          $self.find('.loading')
               .remove();
          $self.find('.fw-sub')
               .html($body.html())
               .slideDown(200);          
        }, this);
      } else {
        this.unFoldText(fws, $body);

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
      }

      return this;
    },

    unFoldText: function (fws, $el) {
      this.model.set('isOpened', true);

      if ( fws[0] && fws[0].toJSON ) {
        fws = _.map(fws, function (fw) { return fw.toJSON() });
      }

      // rendering
      _.each(fws, function (fw) {
        $el.append(this.mtTemplate(fw));
      }, this);
    },

    fold: function (e) {
      this.$('.fw-sub').slideUp(function () { $(this).html(''); });
      this.model.set('isOpened', false);
      return this;
    },

    clkTag: function (e) {
      e.preventDefault();

      var tag = $(e.currentTarget).text();
      if ( $('#select-tag').val() == tag ) {
        tag = '';
      }
      this.model.collection.highlightTag(tag);

      return this;
    },

    highlight: function () {
      this.$el.toggleClass('tagged', this.model.get('isHighlighted'));
    }
  });
})(jQuery);
