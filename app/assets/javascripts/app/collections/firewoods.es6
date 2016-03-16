(function () {
  "use strict"
  const app = window.app

  const Firewoods = Backbone.Collection.extend({
    model: app.Firewood,

    addSome: function (fws, type) {
      this.add(fws)

      if ( type == window.FW_STATE.IN_STACK ) {
        this.trigger("add:stack")
      } else if ( type == window.FW_STATE.IN_TL ) {
        this.trigger("add:prepend")
      } else {
        this.trigger("add:append")
      }
    },

    getPreviousFws: function (fw, limit) {
      let prev_id = fw.get("prev_mt")
      let tmp = fw
      const fws = []
      
      if ( !this.findWhere({id: prev_id}) ) {
        return []
      }

      for (let i = 0; i < limit && prev_id != 0; i++) {
        tmp = this.findWhere({id: prev_id})
        fws.push(tmp)
        prev_id = tmp.get("prev_mt")
      }

      return fws
    },

    highlightTag: function (tag) {
      this.each((fw) => {
        fw.activeTag(tag)
      })
      this.trigger("activeTag", tag)
    },

    comparator: function(fw) {
      return -fw.get("id")
    }
  })

  app.firewoods = new Firewoods()
})()