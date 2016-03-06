var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodView = Backbone.View.extend({
    tagName: 'li',

    initialize: function () {
      this.listenTo(this.model, 'fold', this.fold);
      this.listenTo(this.model, 'unFold', this.unFold);
      this.listenTo(this.model, 'highlight', this.highlight);

      this.initTemplate();
    },

    // Template Initialize will work lazy as there is some pages don't need to be trigger.
    initTemplate: function () {
      this.template = _.template($('#fw-template').html());
    },

    events: {
      'click .delete'  : 'delete',
      'click .mt-clk'  : 'clkUsername',
      'click .mt-to'   : 'toggleFolding',
      'click .fw-tag'  : 'clkTag',
      'click .link_url': 'clkLink'
    },

    render: function () {
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.addClass('list-group-item div-firewood');

      return this;
    },

    delete: function (e) {
      e.stopPropagation();
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
      e.stopPropagation();
      
      var targets = this.$('.mt-target');
      var arr = _.map(targets, function (target) { return $(target).text(); });
      arr.unshift((this.model.get('is_dm') == 0 ? '@':'!') + this.model.get('name'));

      app.firewoods.trigger('form:appendMt', _.uniq(arr), this.model.get('id'));
    },

    toggleFolding: function (e) {
      e.preventDefault();

      // return not neccesary
      if ( this.model.get('prev_mt') === 0 && this.model.get('img_link') === '0' ) {
        return this;
      } else if ( this.model.get('isOpened') ) {
        this.fold();
      } else {
        this.unFold();
      }

      return this;
    },

    // Prevent Override by another event
    clkLink: function (e) {
      e.stopPropagation();
      return this;
    },

    mtRender: function (fws) {
      this.subView = new app.MentionsView({parentView: this, fws: fws});
      this.$('.fw-sub').html(this.subView.render().el)
                 .slideDown(200);
      this.model.set('isOpened', true);
    },

    unFold: function (e) {
      var $self = this.$el;

      var fws = app.firewoods.getPreviousFws(this.model, 5);
      var view = this;
      if ( this.model.get('prev_mt') !== 0 && fws.length == 0 ) {
        $('<div class="loading" style="display:none;">로딩중입니다.</div>')
          .insertAfter($self.find('.fw-main')).slideDown(200);

        this.model.ajaxMtLoad().then(function (json) {
          view.mtRender(json.fws);
          view.$el.find('.loading')
               .remove();
        });
      } else {
        this.mtRender(fws);
      }

      return this;
    },

    fold: function (e) {
      var subView = this.subView;
      this.$('.fw-sub').slideUp(function () { subView.remove(); });
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
