var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodsView = Backbone.View.extend({
    el: '#firewoods',
    count: 0,
    maxCount: 150,

    initialize: function () {
      this.$list = this.$('#timeline');
      this.$stack = this.$('#timeline_stack');
      this.$form = this.$('#new_firewood');
      this.$input = this.$('#firewood_contents');
      this.$title = this.$('#title');
      this.$commitBtn = this.$('#commit');
      this.$prevMt = this.$('#firewood_prev_mt');
      this.$footerLoading = this.$("#div-loading");

      this.listenTo(app.firewoods, 'reset', this.addAll);
      this.listenTo(app.firewoods, 'add:prepend', this.prepend);
      this.listenTo(app.firewoods, 'add:append', this.append);
      this.listenTo(app.firewoods, 'add:stack', this.updateStackNotice);
      this.listenTo(app.firewoods, 'change:isHighlighted', this.highlightOne);

      this.listenTo(app.channel, 'ajaxSuccess', this.formClear);
      this.listenTo(app.firewoods, 'form:appendMt', this.appendMt);
      this.listenTo(app.firewoods, 'timeline:foldAll', this.foldAll);
      this.listenTo(app.firewoods, 'timeline:unFoldAll', this.unFoldAll);

      this.$('span[rel=tooltip]').tooltip();
      this.originTitle = this.$title.text();
      
      $(document).ajaxError(app.channel.ajaxError);
      app.channel.load();
      app.channel.setPullingTimer();
      setInterval(this.isNearBottom, 1000, this);
    },

    events: {
      'input #firewood_contents': 'update_count',
      'keyup #firewood_contents': 'update_count',
      'paste #firewood_contents': 'update_count',
      'click #timeline_stack': 'flushStack',
      'submit #new_firewood': 'submit'
    },

    // Collection Event
    addAll: function () {
      this.$list.html('');
      app.firewoods.each(function (fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$list.append(view.render().el);
      }, this);
    },

    prepend: function () {
      var fws = app.firewoods.where({ state: FW_STATE.IN_STACK }).reverse();
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$list.prepend(view.render().el);
        fw.set('state', 0);
      }, this);

      return this;
    },

    append: function () {
      var fws = app.firewoods.where({ state: FW_STATE.IN_LOG });
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$el.append(view.render().el);
        fw.set('state', 0);
      }, this);

      return this;
    },

    updateStackNotice: function () {
      var fws = app.firewoods.where({ state: FW_STATE.IN_STACK});
      if ( fws.length == 0 ) {
        return false;
      }

      this.$title.html(this.originTitle + ' (' + fws.length + ')');
      this.$stack
        .html('<a href="#" id="notice_stack_new">새 장작이 ' + fws.length + '개 있습니다.</a>')
        .slideDown(200);
    },

    highlightOne: function (fw) {
      fw.trigger('highlight');
    },

    submit: function (e) {
      e.preventDefault();

      if ( !this.isFormEmpty() ) {
        this.$form.ajaxSubmit(app.channel.ajaxBasicOptions);
      } else {
        app.channel.pulling(true);
      }
      return false;
    },

    formClear: function() {
      this.$form.clearForm();
      this.$('#img').val('');
      this.$('.fileinput-preview').html('');
      this.$('.fileinput')
        .removeClass('fileinput-exists')
        .addClass('fileinput-new');
      this.$('.fileinput-filename').html('');
      this.$prevMt.val('');
      this.$commitBtn.button('reset');

      this.update_count();
    },

    update_count: function () {
      var before = this.count;
      var now = this.maxCount - this.$input.val().length;

      if ( this.isFormEmpty() ) {
        this.$commitBtn.val('Refresh');
      } else {
        this.$commitBtn.val('Submit');
      }

      if ( now < 0 ) {
        var str = this.$input.val();
        this.$input.val(str.substr(0, this.maxCount));
        now = 0;
      }

      if ( before != now ) {
        this.count = now;
        this.$('#remaining_count').text(now);
      }
    },

    appendMt: function (names, target) {
      var mts = _.map(names, function (name) { return name; });

      this.$prevMt.val(target);
      this.$input
        .val( mts.join(' ') + ' ' + this.$input.val() )
        .focus();
    },

    flushStack: function () {
      $('.last_top').removeClass('last_top').attr('style','');
      $('.div-firewood:first').addClass('last_top').attr('style','border-top-width:3px;');

      var fws = app.firewoods.filter(function (fw) { return fw.get('state') == -1 && fw.get('img_link') != '0' });
      this.prepend();
      this.$title.html(this.originTitle);
      this.$stack.html('').slideUp(200);

      if ( window.localStorage['auto_image_open'] == '1' ) {
        _.each(fws, function (fw) { fw.trigger('unFold') });        
      }
    },

    foldAll: function () {
      var fws = app.firewoods.where({ isOpened: true });
      _.each(fws, function ( fw ) { fw.trigger('fold'); });
    },

    unFoldAll: function () {
      var fws = app.firewoods.filter( function (fw) { return fw.get('img_link') !== '0' });
      _.each(fws, function ( fw ) { fw.trigger('unFold'); });
    },

    isNearBottom: function (context) {
      var $fws = $('.firewood');
      var fws = app.firewoods;
      if ( !$fws.eq(-5).isOnScreen() || fws.logGetLock || fws.length < 50 || fws.last().get('id') < 10 ) {
        return false;
      }

      context.$footerLoading.show();
      app.channel.getLogs().then(function () {
        context.$footerLoading.hide();
      });
    },

    isFormEmpty: function () {
      if ( this.$('div.fileinput-exists').length == 0 ) {
        var str = this.$('#firewood_contents').val();
        if ( str.length == 0 || str.search(/^\s+$/) != -1 ) {
          return true;
        }
      }
      return false;
    }
  });
})(jQuery);