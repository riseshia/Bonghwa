(function () {
  "use strict"
  const app = window.app

  const Firewoods = Backbone.Collection.extend({
    model: app.Firewood,

    addSome: function (fws, type) {
      this.add(fws)

      if ( type == window.FW_STATE.IN_STACK ) {
        window._updateStackNotice()
      } else if ( type == window.FW_STATE.IN_TL ) {
        this.flushStack()
      } else {
        const newFws = app.firewoods.where({ state: window.FW_STATE.IN_LOG })
        _.each(newFws, fw => { fw.set("state", 0) })
      }
    },

    getPreviousFws: function (prev_id, limit) {
      let fw_id = prev_id
      const fws = []
      
      if ( !this.findWhere({id: fw_id}) ) {
        return []
      }

      for (let i = 0; i < limit && fw_id != 0; i++) {
        const tmp = this.findWhere({id: fw_id})
        fws.push(tmp)
        fw_id = tmp.get("prev_mt")
      }

      return fws
    },

    flushStack: function() {
      const newFws = app.firewoods.where({ state: window.FW_STATE.IN_STACK })
      _.each(newFws, fw => { fw.set("state", 0) })
    },

    comparator: function(fw) {
      return -fw.get("id")
    }
  })

  app.firewoods = new Firewoods()
})()
