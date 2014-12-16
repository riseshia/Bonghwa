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

      this.listenTo(app.firewoods, 'reset', this.addAll);
      this.listenTo(app.firewoods, 'add:prepend', this.prepend);
      this.listenTo(app.firewoods, 'add:append', this.append);
      this.listenTo(app.firewoods, 'add:stack', this.updateStackNotice);
      this.listenTo(app.firewoods, 'change:isHighlighted', this.highlightOne);

      this.listenTo(app.BWClient, 'ajaxSuccess', this.formClear);
      this.listenTo(app.BWClient, 'form:appendMt', this.appendMt);
      this.listenTo(app.firewoods, 'timeline:foldAll', this.foldAll);
      this.listenTo(app.firewoods, 'timeline:unFoldAll', this.unFoldAll);

      this.$form.submit(this.submit);

      this.$('span[rel=tooltip]').tooltip();
      this.originTitle = this.$title.text();
    },

    events: {
      'input #firewood_contents': 'update_count',
      'keyup #firewood_contents': 'update_count',
      'paste #firewood_contents': 'update_count',
      'click #timeline_stack': 'flushStack'
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
      var fws = app.firewoods.where({ state: FW_STATE.IN_LOG }).reverse();
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

    // DOM Event
    submit: function (e) {
      e.preventDefault();

      $(this).ajaxSubmit(app.BWClient.ajaxBasicOptions);
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

      if ( app.FirewoodsView.isFormEmpty() ) {
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

      // 이미지 자동 열기 옵션이 활성화 중이면, 이미지가 있을경우 트리거를 작동시킴
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
    }
  });
  
  app.FirewoodsView.isFormEmpty = function () {
    if ( $('div.fileinput-exists').length == 0 ) {
      var str = $('#firewood_contents').val();
      if ( str.length == 0 || str.search(/^\s+$/) != -1 ) {
        return true;
      }
    }
    return false;
  };
})(jQuery);