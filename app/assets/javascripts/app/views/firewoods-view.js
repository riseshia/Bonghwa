var app = app || {};

(function ($) {
  'use strict';

  app.FirewoodsView = Backbone.View.extend({
    el: '#firewoods',
    $list: $('#timeline'),
    $stack: $('#timeline_stack'),
    $form: $('#new_firewood'),
    $input: $('#firewood_contents'),
    $title: $('#title'),
    count: 0,
    maxCount: 150,

    initialize: function () {
      this.listenTo(app.firewoods, 'reset', this.addAll);
      this.listenTo(app.firewoods, 'add:prepend', this.prepend);
      this.listenTo(app.firewoods, 'add:append', this.append);
      this.listenTo(app.firewoods, 'add:stack', this.updateStackNotice);

      this.listenTo(app.BWClient, 'ajaxSuccess', this.formClear);
      this.listenTo(app.BWClient, 'form:appendMt', this.appendMt);

      this.$form.submit(this.submit);

      $('span[rel=tooltip]').tooltip();
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
      var fws = app.firewoods.where({ state: -1 }).reverse();
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$list.prepend(view.render().el);
        fw.set('state', 0);
      }, this);

      return this;
    },

    append: function () {
      var fws = app.firewoods.where({ state: 1 }).reverse();
      _.each(fws, function(fw) {
        var view = new app.FirewoodView({ model: fw });
        this.$el.append(view.render().el);
        fw.set('state', 0);
      }, this);

      return this;
    },

    updateStackNotice: function () {
      var fws = app.firewoods.where({ state: - 1});
      if ( fws.length == 0 ) {
        return false;
      }

      this.$title.html(this.originTitle + ' (' + fws.length + ')');
      this.$stack
        .html('<a href="#" id="notice_stack_new">새 장작이 ' + fws.length + '개 있습니다.</a>')
        .slideDown(200);
    },

    // DOM Event
    submit: function () {
      $(this).ajaxSubmit(app.BWClient.ajaxBasicOptions);
      return false;
    },

    formClear: function() {
      $('#new_firewood').clearForm();
      $('#img').val('');
      $('.fileinput-preview').html('');
      $('.fileinput')
        .removeClass('fileinput-exists')
        .addClass('fileinput-new');
      $('.fileinput-filename').html('');
      $('#commit').button('reset');
      $('#firewood_prev_mt').val('');

      this.update_count();
    },

    update_count: function () {
      var before = this.count;
      var now = this.maxCount - this.$input.val().length;

      if ( app.FirewoodsView.isFormEmpty() ) {
        $('#commit').val('Refresh');
      } else {
        $('#commit').val('Submit');
      }

      if ( now < 0 ) {
        var str = this.$input.val();
        this.$input.val(str.substr(0, this.maxCount));
        now = 0;
      }

      if ( before != now ) {
        this.count = now;
        $('#remaining_count').text(now);
      }
    },

    appendMt: function (names) {
      var mts = _.map(names, function (name) { return '@' + name; });

      this.$input
        .val( mts.join(' ') + ' ' + this.$input.val() )
        .focus();
    },

    flushStack: function () {
      $('.last_top').removeClass('last_top').attr('style','');
      $('.div-firewood:first').addClass('last_top').attr('style','border-top-width:3px;');

      this.prepend();
      this.$title.html(this.originTitle);
      this.$stack.html('').slideUp(200);

    // # 이미지 자동 열기 옵션이 활성화 중이면, 새로 받아온 글에 한해서 트리거를 작동시킴
    // if window.getStorageValue('auto_image_open') is window.TRUE
    //   $list = $(".firewood:lt(#{stack_size_temp})").filter('.mt-to[img-link!=0]')
    //   UITimeline.expandImgs($list)

    // HashTagUtil.apply_tag($("#select-tag").val())

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