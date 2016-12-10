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
      this.pullingTimer = setTimeout(() => {
        this.pulling(app.pageType)
      }, speed)
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

    load: function (pageType) {
      this.stopPullingTimer()
      const params = app.channel.buildParams({
        type: pageType,
        ts: +(new Date())
      })
      return $.get(`/api/now${params}`).then(json => {
        const fws = json.fws.map(fw => {
          fw.isVisible = true
          return fw
        })
        app.FirewoodsFn.reset(fws)
        app.users = json.users
        app.infos = json.infos
        
        app.render()
        app.channel.setPullingTimer()
      })
    },

    pulling: function (pageType, isUserTriggered = false) {
      const shouldVisible = this.isLive || isUserTriggered
      this.stopPullingTimer()

      const firstFw = app.firewoods[0]
      const recentId = (firstFw ? firstFw.id : 0)
      const params = app.channel.buildParams({
        after: recentId,
        type: pageType,
        ts: +(new Date())
      })

      return $.get(`/api/pulling.json${params}`).then(json => {
        if (json.fws) {
          if (isUserTriggered && json.fws.length === 0) {
            window._flashForm()
          }

          const fws = json.fws.map(fw => {
            fw.isVisible = shouldVisible
            return fw
          })

          if ( localStorage.getItem("auto_image_open") == "1" ) {
            fws.forEach(fw => {
              if (fw.img_link != "0") {
                fw.defaultIsImgOpened = true
              }
            })
          }

          app.FirewoodsFn.prependSome(fws)
          if (shouldVisible) {
            app.FirewoodsFn.flushStack()
          }
        }

        if (json.users) {
          app.users = json.users
        }
        app.render()
        this.setPullingTimer()
      })
    },

    getLogs: function (pageType) {
      const self = app.channel
      const firewoods = app.firewoods
      const lastIdx = firewoods.length - 1
      self.logGetLock = true
      const params = app.channel.buildParams({
        before: firewoods[lastIdx].id,
        count: self.sizeWhenBottomLoading,
        type: pageType,
        ts: +(new Date())
      })

      return $.get("/api/trace.json" + params, json => {
        if ( json.fws.length != 0 ) {
          const fws = json.fws.map(fw => {
            fw.isVisible = true
            return fw
          })
          app.FirewoodsFn.appendSome(fws)
        }
        self.logGetLock = false
        app.render()
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
        self.pulling(app.pageType, true)
        window.ajaxSuccess()

        if (document.activeElement.getAttribute("id") == "contents") {
          $(document.activeElement).blur().focus()
        }
      }
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
