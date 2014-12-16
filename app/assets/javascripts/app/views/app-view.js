var app = app || {};

(function ($) {
  'use strict';

  app.AppView = Backbone.View.extend({
    el: 'body',
    $title: $('#title'),
    $hotkeyImgAutoOpen: $('#img_auto_open_op'),
    $hotkeyLiveStream: $('#live_stream_op'),
    $hotkeyFocus: $('#focus_hotkey'),
    $hotkeyRefresh: $('#refresh_hotkey'),
    $tagSelector: $('#select-tag'),

    initialize: function () {
      $('span[rel=tooltip]').tooltip();
      this.originTitle = this.$title.text();

      // load initial state from localStorage
      window.localStorage['auto_image_open'] = (window.localStorage['auto_image_open'] == '1' ? '0' : '1');
      this.toggleImgAutoOpen(null, true);
      window.localStorage['live_stream'] = (window.localStorage['live_stream'] == '1' ? '0' : '1');
      this.toggleLiveStream(null, true);
      this.listenTo(app.firewoods, 'activeTag', this.setTagSelector);

      $(document).keycut();
    },

    events: {
      'click #img_auto_open_op': 'toggleImgAutoOpen',
      'click #live_stream_op': 'toggleLiveStream',
      'click #focus_hotkey': 'focusToInput',
      'click #refresh_hotkey': 'refreshTL',
      'keypress #select-tag': 'selectNewTag'
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

      clearTimeout(app.BWClient.pullingTimer);
      $ls.toggleClass('true');
      if (newState == '1') {
        $ls.html($ls.html() + '<span class="glyphicon glyphicon-ok"></span>');
        msg = 'Live Stream이 활성화되었습니다.';
        
        app.BWClient.pullingPeriod = 1000;
        app.BWClient.pullingTimer = setTimeout(BWClient.pulling, BWClient.pullingPeriod);
      } else {
        $ls.find('.glyphicon-ok').remove();
        msg = 'Live Stream이 비활성화되었습니다.';

        app.BWClient.pullingPeriod = 10000;
        app.BWClient.pullingTimer = setTimeout(BWClient.pulling, BWClient.pullingPeriod);
      }

      if ( !silent ) {
        this.notifyWithWindow(msg, 'alert-info');
      }

      return this;
    },

    refreshTL: function (e) {
      e.preventDefault();
      BWClient.load();

      return this;
    },

    focusToInput: function (e) {
      e.preventDefault();

      $('html, body').animate({scrollTop: 0}, 600);
      $('#firewood_contents').focus();

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
    }
  });
})(jQuery);