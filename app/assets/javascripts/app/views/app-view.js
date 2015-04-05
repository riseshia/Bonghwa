var app = app || {};

(function ($) {
  'use strict';

  app.AppView = Backbone.View.extend({
    el: 'body',

    initialize: function () {
      this.$title = this.$('#title');
      this.$hotkeyImgAutoOpen = this.$('#img_auto_open_op');
      this.$hotkeyLiveStream = this.$('#live_stream_op');
      this.$hotkeyFocus = this.$('#focus_hotkey');
      this.$hotkeyRefresh = this.$('#refresh_hotkey');
      this.$tagSelector = this.$('#select-tag');
      this.$info = this.$('#info');
      this.originTitle = this.$title.text();

      // load initial state from localStorage
      window.localStorage['auto_image_open'] = (window.localStorage['auto_image_open'] == '1' ? '0' : '1');
      this.toggleImgAutoOpen(null, true);
      window.localStorage['live_stream'] = (window.localStorage['live_stream'] == '1' ? '0' : '1');
      this.toggleLiveStream(null, true);

      this.listenTo(app.firewoods, 'activeTag', this.setTagSelector);
      this.listenTo(app.channel, 'ajaxError', this.disableApp);

      this.$info.html(this.$info.html().autoLink({ target: "_blank", rel: "nofollow" }));

      $(document).keycut();
    },

    events: {
      'click #img_auto_open_op': 'toggleImgAutoOpen',
      'click #live_stream_op': 'toggleLiveStream',
      'click #focus_hotkey': 'focusToInput',
      'click #refresh_hotkey': 'refreshTL',
      'keypress #select-tag': 'selectNewTag',
      'click #info': 'removeInfo',
      'focus #contents': function() {
        $('#contents-placeholder').remove();
      },
      'blur #contents': function() {
        if ($('#contents').text().length == 0) {
          $('#contents').html('<p id="contents-placeholder" class="text-muted">New...</p>');
        }
      }
    },

    toggleImgAutoOpen: function (e, silent) {
      if ( e ) {
        e.preventDefault();
      }

      var $iao = this.$hotkeyImgAutoOpen;
      var newState = (window.localStorage['auto_image_open'] == '1' ? '0' : '1');
      window.localStorage['auto_image_open'] = newState;
      var msg;

      $iao.toggleClass('true');
      if (newState == '1') {
        $iao.html($iao.html() + '<span class="glyphicon glyphicon-ok"></span>');
        msg = '이미지 자동 열기가 활성화되었습니다.';
        app.firewoods.trigger('timeline:unFoldAll');
      } else {
        $iao.find('.glyphicon-ok').remove();
        msg = '이미지 자동 열기가 비활성화되었습니다.';
        app.firewoods.trigger('timeline:foldAll');
      }

      if ( !silent ) {
        this.notifyWithWindow(msg, 'alert-info');
      }

      return this;
    },

    toggleLiveStream: function(e, silent) {
      if ( e ) {
        e.preventDefault();
      }

      var $ls = this.$hotkeyLiveStream;
      var newState = (window.localStorage['live_stream'] == '1' ? '0' : '1');
      window.localStorage['live_stream'] = newState;
      var msg;

      $ls.toggleClass('true');
      if (newState == '1') {
        $ls.html($ls.html() + '<span class="glyphicon glyphicon-ok"></span>');
        msg = 'Live Stream이 활성화되었습니다.';
        app.channel.toggleLiveStream(true);
      } else {
        $ls.find('.glyphicon-ok').remove();
        msg = 'Live Stream이 비활성화되었습니다.';
        app.channel.toggleLiveStream(false);
      }

      if ( !silent ) {
        this.notifyWithWindow(msg, 'alert-info');
      }

      return this;
    },

    refreshTL: function (e) {
      e.preventDefault();
      app.channel.load();

      return this;
    },

    focusToInput: function (e) {
      e.preventDefault();

      $('html, body').animate({scrollTop: 0}, 600);
      $('#contents').focus();

      return this;
    },

    notifyWithWindow: function (msg, option) {
      var $alert = $('<div class="alert" display="none;"></div>');
      var $timeline = $('#timeline');
      var left = $timeline.offset().left + $timeline.width()/2;

      $alert
        .appendTo('body')
        .html(msg)
        .addClass(option)
        .css({left: left, top: 80})
        .clearQueue()
        .stop()
        .fadeIn(600)
        .delay(1000)
        .fadeOut(1000);

      return this;
    },

    selectNewTag: function (e) {
      if ( e.which === ENTER_KEY ) {
        e.preventDefault();
        var newTag = this.$tagSelector.val();

        if ( newTag[0] != "#" && newTag.length > 1) {
          alert("태그는 #으로 시작해야합니다.");
        } else {
          app.firewoods.highlightTag(newTag);
        }
      }
    },

    setTagSelector: function (tag) {
      this.$tagSelector.val(tag);
    },

    removeInfo: function (e) {
      var $self = this.$info;
      $self.slideUp( function () {
        $self.remove();
      });
    },

    disableApp: function () {
      var $panel = $(".panel-info");
      $panel.removeClass("panel-info")
            .addClass("panel-danger");
      $("#info, #div-form").css("background-color","#f2dede");
      $('#new_firewood').find("fieldset").attr("disabled","a");
      $('#timeline_stack')
        .css("background-color","#f5c5c5")
        .html("서버와의 접속이 끊어졌습니다. 새로고침 해주세요.")
        .slideDown();
      this.$title.html("새로고침 해주세요.");
    }
  });
})(jQuery);