var app = app || {};

(function () {
  'use strict';

  var Firewoods = Backbone.Collection.extend({
    model: app.Firewood,
    pullingTimer: null,
    pullingPeriod: 10000,
    sizeWhenBottomLoading: 50,
    failCount: 0,
    fwPostLock: false,
    logGetLock: false,

    load: function () {
      clearTimeout(this.pullingTimer);
      $.get('/api/now?type=' + PAGE_TYPE).then(function (json) {
        var fws = _.map(json.fws, function (fw) { fw['state'] = FW_STATE.IN_TL; return new app.Firewood(fw); });
        app.firewoods.reset(fws);
        var users = _.map(json.users, function (user) { return new app.User(user); });
        app.users.reset(users);
        
        this.pullingTimer = setTimeout(this.pulling, this.pullingPeriod);
      });
    },

    pulling: function (isLive) {
      var self = app.firewoods;
      clearTimeout(self.pullingTimer);

      var recentId = self.first().get('id');
      $.get('/api/pulling.json?after=' + recentId + '&type=' + PAGE_TYPE).then(function (json) {
        var state = ( window.localStorage['live_stream'] == '1' ) ? FW_STATE.IN_TL : FW_STATE.IN_STACK;
        if ( isLive ) {
          state = 0;
        }

        if (json.fws) {
          var fws = _.map(json.fws, function (fw) { fw['state'] = FW_STATE.IN_STACK; return new app.Firewood(fw); });
          
          app.firewoods.addSome(fws, state);
          if ( window.localStorage['auto_image_open'] == '1' ) {
            var fwsHasImg = fws.filter(function (fw) { return fw.get('img_link') != '0' });
            _.each(fwsHasImg, function (fw) { fw.trigger('unFold') });
          }
        }

        if (json.users) {
          var users = _.map(json.users, function (user) { return new app.User(user); });
          app.users.reset(users);
        }
        self.pullingTimer = setTimeout(self.pulling, self.pullingPeriod);
      });
    },

    ajaxBasicOptions: {
      url:           'api/new',
      type:          'post',
      dataType:      'json',
      beforeSubmit: function (formData, jqForm, options) {
        var self = app.firewoods;
        $('#commit').button('loading');
        clearTimeout(self.pullingTimer);
        
        if ( self.fwPostLock || app.FirewoodsView.isFormEmpty() ) {
          return false;
        }

        self.fwPostLock = true;
      },
      success: function () {
        var self = app.firewoods;
        self.trigger('ajaxSuccess');
        self.fwPostLock = false;
        self.pulling(true);
      }
    },

    getLogs: function () {
      var firewoods = app.firewoods;
      if ( firewoods.logGetLock || firewoods.length < 50 || firewoods.last().get('id') < 10 ) {
        return false;
      }

      var $fws = $('.firewood');
      if ( !$fws.eq(-5).isOnScreen() ) {
        return false;
      }
      firewoods.logGetLock = true;
      $('#div-loading').show();

      $.get('/api/trace.json?before=' + firewoods.last().get('id') + '&count=' + firewoods.sizeWhenBottomLoading + '&type=' + PAGE_TYPE, function (json) {
        if ( json.fws.length != 0 ) {
          var fws = _.map(json.fws, function (fw) { fw['state'] = FW_STATE.IN_LOG; return new app.Firewood(fw); });
          firewoods.addSome(fws, FW_STATE.IN_LOG);
        }

        $("#div-loading").hide();
        firewoods.logGetLock = false;
      });
    },

    ajaxError: function () {
      this.failCount += 1;

      if ( this.failCount < 3 ) {
        clearTimeout(this.pullingTimer);
        this.pullingTimer = setTimeout(this.pulling, this.pullingPeriod);
        return true;
      }

      var $panel = $(".panel-info");
      $panel.removeClass("panel-info")
            .addClass("panel-danger");
      $("#info").css("background-color","#f2dede");
      $('#new_firewood').find("fieldset").attr("disabled","a");
      $('#timeline_stack')
        .css("background-color","#b94a48")
        .html("서버와의 접속이 끊어졌습니다. 새로고침 해주세요.")
        .slideDown();
      $('#title').html("새로고침 해주세요.");
    },

    addSome: function (fws, type) {
      this.add(fws);

      if ( type == FW_STATE.IN_STACK ) {
        this.trigger('add:stack');
      } else if ( type == FW_STATE.IN_TL ) {
        this.trigger('add:prepend');
      } else {
        this.trigger('add:append');
      }
    },

    getPreviousFws: function (fw, limit) {
      var prev_id = fw.get('prev_mt');
      var fws = [];
      var tmp = fw;
      if ( !this.findWhere({id: prev_id}) ) {
          return [];
      }

      for (var i = 0; i < limit && prev_id != 0; i++ ) {
        tmp = this.findWhere({id: prev_id});
        fws.push(tmp);
        prev_id = tmp.get('prev_mt');
      }

      return fws;
    },

    highlightTag: function (tag) {
      this.each(function (fw) {
        fw.activeTag(tag);
      });
      this.trigger('activeTag', tag);
    },

    comparator: function(fw) {
      return -fw.get('id');
    }
  });

  app.firewoods = new Firewoods();
})();