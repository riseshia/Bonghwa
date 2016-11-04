(function () {
  "use strict"
  const app = window.app

  app.Channel = Backbone.Collection.extend({
    pullingTimer: null,
    isLive: false,
    sizeWhenBottomLoading: 50,
    failCount: 0,
    fwPostLock: false,
    logGetLock: false,

    initialize: function (firewoods, users) {
      this.firewoods = firewoods
      this.users = users
      $(document).ajaxError(this.ajaxError)
    },

    setPullingTimer: function() {
      const speed = (this.isLive ? 1000 : 10000)
      this.pullingTimer = setTimeout(this.pulling, speed)
      return this
    },

    stopPullingTimer: function () {
      clearTimeout(this.pullingTimer)
      return this
    },

    toggleLiveStream: function(isLive) {
      if ( isLive === undefined ) {
        this.isLive = !this.isLive
      } else {
        this.isLive = isLive
      }
      this.stopPullingTimer().setPullingTimer()
    },

    load: function () {
      this.stopPullingTimer()
      const params = app.channel.buildParams({
        type: window.PAGE_TYPE,
        ts: +(new Date())
      })
      return $.get(`/api/now${params}`).then(json => {
        const fws = _.map(json.fws, (fw) => { fw["state"] = window.FW_STATE.IN_TL; return new app.Firewood(fw) })
        app.firewoods.reset(fws)
        
        const users = _.map(json.users, (user) => { return new app.User(user) })
        app.users.reset(users)
        
        app.render()
        app.channel.setPullingTimer()
      })
    },

    pulling: function (isLive, isUserTriggered) {
      const self = app.channel
      self.stopPullingTimer()

      const firstFw = app.firewoods.first()
      const recentId = (firstFw ? firstFw.get("id") : 0)
      const params = app.channel.buildParams({
        after: recentId,
        type: window.PAGE_TYPE,
        ts: +(new Date())
      })
      return $.get(`/api/pulling.json${params}`).then(json => {
        let state = (localStorage.getItem("live_stream") == "1") ? window.FW_STATE.IN_TL : window.FW_STATE.IN_STACK
        if ( isLive ) {
          state = window.FW_STATE.IN_TL
        }

        if (json.fws) {
          if (isUserTriggered && json.fws.length == 0) {
            window._flashForm()
          }

          const fws = _.map(json.fws, (fw) => { fw["state"] = window.FW_STATE.IN_STACK; return new app.Firewood(fw) })
          
          app.firewoods.addSome(fws, state)
          if ( localStorage.getItem("auto_image_open") == "1" ) {
            const fwsHasImg = fws.filter((fw) => { return fw.get("img_link") != "0" })
            _.each(fwsHasImg, (fw) => { fw.trigger("unFold") })
          }
        }

        if (json.users) {
          const users = _.map(json.users, (user) => { return new app.User(user) })
          app.users.reset(users)
          app.render()
        }
        self.setPullingTimer()
      })
    },

    ajaxBasicOptions: {
      url:           "api/new",
      type:          "post",
      dataType:      "json",
      beforeSubmit: function () {
        const self = app.channel
        $("#commit").button("loading")
        self.stopPullingTimer()
        
        if (self.fwPostLock) { return false }
        self.fwPostLock = true
      },
      success: function () {
        const self = app.channel
        self.fwPostLock = false
        self.pulling(true)
        window.ajaxSuccess()

        if (document.activeElement.getAttribute("id") == "contents") {
          $(document.activeElement).blur().focus()
        }
      }
    },

    getLogs: function () {
      const self = app.channel
      const firewoods = app.firewoods
      self.logGetLock = true
      const params = app.channel.buildParams({
        before: firewoods.last().get("id"),
        count: self.sizeWhenBottomLoading,
        type: window.PAGE_TYPE,
        ts: +(new Date())
      })

      return $.get("/api/trace.json" + params, (json) => {
        if ( json.fws.length != 0 ) {
          const fws = _.map(json.fws, (fw) => { fw["state"] = window.FW_STATE.IN_LOG; return new app.Firewood(fw) })
          firewoods.addSome(fws, window.FW_STATE.IN_LOG)
        }
        self.logGetLock = false
      })
    },

    ajaxError: function () {
      const self = app.channel
      self.failCount += 1

      if ( self.failCount < 3 ) {
        self.stopPullingTimer()
            .setPullingTimer()
      } else {
        app.disableApp()
      }
    },

    buildParams: function (params) {
      const paramStrs = _.map(params, (value, key) => {
        return `${key}=${value}`
      })
      return `?${paramStrs.join("&")}`
    }
  })
})()
