var app = app || {};

(function () {
  'use strict';

  var Firewoods = Backbone.Collection.extend({
    model: app.Firewood,
    pullingTimer: null,
    pullingPeriod: 10000,
    isLive: false,
    sizeWhenBottomLoading: 50,
    failCount: 0,
    fwPostLock: false,
    logGetLock: false,

    setPullingTimer: function() {
      var speed = (this.isLive ? 1000 : 10000);
      this.pullingTimer = setTimeout(this.pulling, speed);
      return this;
    },

    stopPullingTimer: function () {
      clearTimeout(this.pullingTimer);
      return this;
    },

    toggleLiveStream: function( isLive ) {
      if ( isLive === undefined ) {
        this.isLive = !this.isLive;
      } else {
        this.isLive = isLive;
      }
      this.stopPullingTimer().setPullingTimer();
    },

    load: function () {
      this.stopPullingTimer();
      return $.get('/api/now?type=' + PAGE_TYPE).then(function (json) {
        var fws = _.map(json.fws, function (fw) { fw['state'] = FW_STATE.IN_TL; return new app.Firewood(fw); });
        app.firewoods.reset(fws);
        var users = _.map(json.users, function (user) { return new app.User(user); });
        app.users.reset(users);
        
        app.firewoods.setPullingTimer();
      });
    },

    pulling: function (isLive) {
      var self = app.firewoods;
      self.stopPullingTimer();

      var recentId = self.first().get('id');
      return $.get('/api/pulling.json?after=' + recentId + '&type=' + PAGE_TYPE).then(function (json) {
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
        self.setPullingTimer();
      });
    },

    ajaxBasicOptions: {
      url:           'api/new',
      type:          'post',
      dataType:      'json',
      beforeSubmit: function (formData, jqForm, options) {
        var self = app.firewoods;
        $('#commit').button('loading');
        self.stopPullingTimer();
        
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
      var self = app.firewoods;
      self.logGetLock = true;

      return $.get('/api/trace.json?before=' + self.last().get('id') + '&count=' + self.sizeWhenBottomLoading + '&type=' + PAGE_TYPE, function (json) {
        if ( json.fws.length != 0 ) {
          var fws = _.map(json.fws, function (fw) { fw['state'] = FW_STATE.IN_LOG; return new app.Firewood(fw); });
          self.addSome(fws, FW_STATE.IN_LOG);
        }
        self.logGetLock = false;
      });
    },

    ajaxError: function () {
      var self = app.firewoods;
      self.failCount += 1;

      if ( self.failCount < 3 ) {
        self.stopPullingTimer()
            .setPullingTimer();
      } else {
        self.trigger('ajaxError');
      }
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