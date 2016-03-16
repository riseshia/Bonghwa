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

    toggleLiveStream: function( isLive ) {
      if ( isLive === undefined ) {
        this.isLive = !this.isLive
      } else {
        this.isLive = isLive
      }
      this.stopPullingTimer().setPullingTimer()
    },

    load: function () {
      this.stopPullingTimer()
      return $.get("/api/now?type=" + window.PAGE_TYPE).then((json) => {
        const fws = _.map(json.fws, (fw) => { fw["state"] = window.FW_STATE.IN_TL; return new app.Firewood(fw) })
        app.firewoods.reset(fws)
        const users = _.map(json.users, (user) => { return new app.User(user) })
        app.users.reset(users)
        
        app.channel.setPullingTimer()
      })
    },

    pulling: function (isLive, isUserTriggered) {
      const self = app.channel
      self.stopPullingTimer()

      const firstFw = app.firewoods.first()
      const recentId = (firstFw ? firstFw.get("id") : 0)
      return $.get("/api/pulling.json?after=" + recentId + "&type=" + window.PAGE_TYPE).then( (json) => {
        let state = ( window.localStorage["live_stream"] == "1" ) ? window.FW_STATE.IN_TL : window.FW_STATE.IN_STACK
        if ( isLive ) {
          state = window.FW_STATE.IN_TL
        }

        if (json.fws) {
          if (isUserTriggered && json.fws.length == 0) {
            app.firewoods.trigger("form:flash")
          }

          const fws = _.map(json.fws, (fw) => { fw["state"] = window.FW_STATE.IN_STACK; return new app.Firewood(fw) })
          
          app.firewoods.addSome(fws, state)
          if ( window.localStorage["auto_image_open"] == "1" ) {
            const fwsHasImg = fws.filter((fw) => { return fw.get("img_link") != "0" })
            _.each(fwsHasImg, (fw) => { fw.trigger("unFold") })
          }
        }

        if (json.users) {
          const users = _.map(json.users, (user) => { return new app.User(user) })
          app.users.reset(users)
        }
        self.setPullingTimer()
      })
    },

    ajaxBasicOptions: {
      url:           "api/new",
      type:          "post",
      dataType:      "json",
      beforeSubmit: function (formData) {
        const self = app.channel
        const contents = {name: "firewood[contents]", value: $("#contents").text(), type: "text", required: false}
        formData.push(contents)

        $("#commit").button("loading")
        self.stopPullingTimer()
        
        if ( self.fwPostLock ) {
          return false
        }

        self.fwPostLock = true
      },
      success: function () {
        const self = app.channel
        self.fwPostLock = false
        self.pulling(true)
        self.trigger("ajaxSuccess")

        if (document.activeElement.getAttribute("id") == "contents") {
          $(document.activeElement).blur().focus()
        }
      }
    },

    getLogs: function () {
      const self = app.channel
      const firewoods = app.firewoods
      self.logGetLock = true

      return $.get("/api/trace.json?before=" + firewoods.last().get("id") + "&count=" + self.sizeWhenBottomLoading + "&type=" + window.PAGE_TYPE, (json) => {
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
        self.trigger("ajaxError")
      }
    }
  })
})()