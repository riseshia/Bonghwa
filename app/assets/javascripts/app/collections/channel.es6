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

    initialize: function () {
      this.isLive = JSON.parse(localStorage.getItem("live_stream"))
      $(document).ajaxError(this.ajaxError)
    },

    setPullingTimer: function() {
      const speed = (this.isLive ? 1000 : 10000)
      this.pullingTimer = setTimeout(this.pulling.bind(this), speed)
      return this
    },

    stopPullingTimer: function () {
      clearTimeout(this.pullingTimer)
      return this
    },

    toggleLiveStream: function() {
      this.isLive = !this.isLive
      localStorage.setItem("live_stream", this.isLive)
      this.stopPullingTimer().setPullingTimer()
      return this.isLive
    },

    load: function () {
      this.stopPullingTimer()
      const params = app.channel.buildParams({
        type: app.pageType,
        ts: +(new Date())
      })
      return $.get(`/api/now${params}`).then(json => {
        _.each(json.fws, fw => ( fw.isVisible = true ))
        app.firewoods = json.fws
        app.users = json.users
        
        app.render()
        app.channel.setPullingTimer()
      })
    },

    pulling: function (isUserTriggered = false) {
      const shouldVisible = this.isLive || isUserTriggered
      this.stopPullingTimer()

      const firstFw = app.firewoods[0]
      const recentId = (firstFw ? firstFw.id : 0)
      const params = app.channel.buildParams({
        after: recentId,
        type: app.pageType,
        ts: +(new Date())
      })

      return $.get(`/api/pulling.json${params}`).then(json => {
        if (json.fws) {
          if (isUserTriggered && json.fws.length === 0) {
            window._flashForm()
          }

          _.each(json.fws, fw => ( fw.isVisible = shouldVisible ))

          if ( localStorage.getItem("auto_image_open") == "1" ) {
            json.fws.forEach(fw => {
              if (fw.img_link != "0") {
                fw.defaultIsOpened = true
              }
            })
          }
          app.firewoods = json.fws.concat(app.firewoods)
        }

        if (json.users) {
          app.users = json.users
        }
        app.render()
        this.setPullingTimer()
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
      const lastIdx = firewoods.length - 1
      self.logGetLock = true
      const params = app.channel.buildParams({
        before: firewoods[lastIdx].id,
        count: self.sizeWhenBottomLoading,
        type: app.pageType,
        ts: +(new Date())
      })

      return $.get("/api/trace.json" + params, (json) => {
        if ( json.fws.length != 0 ) {
          _.each(json.fws, fw => ( fw.isVisible = true ))
          app.firewoods = app.firewoods.concat(json.fws)
        }
        self.logGetLock = false
        app.render()
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
