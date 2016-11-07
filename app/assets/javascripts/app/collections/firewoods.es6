(function () {
  "use strict"
  const app = window.app

  const Firewoods = Backbone.Collection.extend({
    model: app.Firewood,

    addSome: function (fws) {
      this.add(fws)
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
      this.
        where({ isVisible: false }).
        forEach(fw => fw.set("isVisible", true))
    },

    comparator: function(fw) {
      return -fw.get("id")
    }
  })

  app.firewoods = new Firewoods()
})()
