var app = app || {};

(function () {
  'use strict';
  app.BWClient = {}
  _.extend(app.BWClient, Backbone.Events);
  _.extend(app.BWClient, {
    pullingTimer: null,
    pullingPeriod: 30000,
    sizeWhenBottomLoading: 50,
    failCount: 0,
    fwPostLock: false,
    logGetLock: false,
    mtGetLock: false,

    ajaxBasicOptions: {
      url:           'api/new',
      type:          'post',
      dataType:      'json',
      beforeSubmit: function (formData, jqForm, options) {
        var self = app.BWClient;
        $('#commit').button('loading');
        clearTimeout(self.pullingTimer);
        
        if ( self.fwPostLock || app.FirewoodsView.isFormEmpty() ) {
          return false;
        }

        self.fwPostLock = true;
      },
      success: function () {
        var self = app.BWClient;
        self.trigger('ajaxSuccess');
        self.fwPostLock = false;
        self.pulling();
      }
    },

    pageType: 1,
    load: function () {
      $('#loading').html('로드 중입니다.');
      $('#timeline').html('');

      clearTimeout(this.pullingTimer);
      $.get('/api/now?type=' + this.pageType, function (json) {
        var fws = _.map(json.fws, function (fw) { return new app.Firewood(fw); });
        app.firewoods.reset(fws);
        var users = _.map(json.users, function (user) { return new app.User(user); });
        app.users.reset(users);
        // 쌓아두기 처리
        // UITimeline.stackFlush();

        app.BWClient.pullingTimer = setTimeout(app.BWClient.pulling, app.BWClient.pullingPeriod);
      });
    },

    pulling: function () {
      clearTimeout(app.BWClient.pullingTimer);

      var recentId = app.firewoods.first().get('id');
      $.get('/api/pulling.json?after=' + recentId + '&type=' + app.BWClient.pageType, function (json) {
        if (json.fws) {
          var fws = _.map(json.fws, function (fw) { fw['state'] = -1; return new app.Firewood(fw); });
          app.firewoods.prepend(fws);
        }
        // if ( window.getStorageValue('live_stream') == window.TRUE )
          // UITimeline.stackFlush();

        // if ( app.BWClient.stackIsEmpty() )
        //   UITimeline.noticeNew();
        if (json.users) {
          var users = _.map(json.users, function (user) { return new app.User(user); });
          app.users.reset(users);
        }
        app.BWClient.pullingTimer = setTimeout(app.BWClient.pulling, app.BWClient.pullingPeriod);
      });
    },

    ajaxMtLoad: function ($self, prev_mt, img_tag) {
      // app.BWClient.mtGetLock = $self.attr('data-id') # 락걸기.
      // $.get('/api/get_mt.json?prev_mt=' + prev_mt + '&now=' + app.BWClient.mtGetLock, function (json) {
      //   str = '';
      //   if ( json.fws.length != 0 ) {
      //     mts = json.fws;

      //   build mention

      //   $self = $("div[data-id=#{app.BWClient.mtGetLock}]");
      //   // UITimeline.insertFWExpandResult($self, str + img_tag);
      //   app.BWClient.mtGetLock = 0;
      // });
    },

    getlogs: function () {
      var $fws = $('.firewood');
      if ( this.logGetLock || $fws.length < 50 || Number($fws.last().attr('data-id')) < 10 ) {
        return false;
      }

      if ( $fws.eq(-5).isOnScreen() ) {
        this.logGetLock = true;
        var $bottom = $fws.last();
        $('#div-loading').show();

        var bottom_id = $bottom.attr('data-id');
        $.get('/api/trace.json?before=' + bottom_id + '&count=' + this.sizeWhenBottomLoading + '&type=' + this.pageType, function (json) {
          if ( json.fws.length != 0 ) {
            var fws = _.map(json.fws, function (fw) { fw['state'] = 1; return new app.Firewood(fw); });
            app.firewoods.append(fws);

            timelineSize = $('.firewood').size() - 1;

            // $bottom.parent().after(TagBuilder.fwList(json.fws));
            // 이미지 자동 열기 옵션이 활성화 중이면, 새로 받아온 글에 한해서 트리거를 작동시킴
            // if window.getStorageValue('auto_image_open') is window.TRUE
            //   $list = $(".firewood:gt(#{timelineSize})").filter('.mt-to[img-link!=0]')
            //   UITimeline.expandImgs($list)
          }

          $("#div-loading").hide();
          app.BWClient.logGetLock = false;
        });
      }
    },

    ajaxError: function () {
      this.failCount += 1;

      if ( this.failCount < 3 ) {
        clearTimeout(this.pullingTimer);
        this.pullingTimer = setTimeout(this.pulling, this.pullingPeriod);
        return true;
      }

      $panel = $(".panel-info");
      $panel.removeClass("panel-info")
            .addClass("panel-danger");
      $("#info").css("background-color","#f2dede");
      $('#new_firewood').find("fieldset").attr("disabled","a");
      $DOM.timeline_stack()
        .css("background-color","#b94a48")
        .html("서버와의 접속이 끊어졌습니다. 새로고침 해주세요.")
        .slideDown();
      $('#title').html("새로고침 해주세요.");
    }
  });

  $(document).ajaxError(app.BWClient.ajaxError);
})();