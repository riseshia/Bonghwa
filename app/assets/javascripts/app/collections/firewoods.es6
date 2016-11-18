(function () {
  "use strict"
  const app = window.app
  
  const FirewoodsFn = {
    getPreviousFws(prev_id, limit) {
      let fw_id = prev_id
      const fws = []
      
      if (!this.findById(fw_id)) {
        return []
      }

      for (let i = 0; i < limit && fw_id != 0; i++) {
        const tmp = this.findById(fw_id)
        if (!tmp) { break }
        fws.push(tmp)
        fw_id = tmp.prev_mt
      }

      return fws
    },

    findById(id) {
      const fws = app.firewoods
      
      for(let i = 0; i!= fws.length; i++) {
        if (fws[i].id == id) {
          return fws[i]
        }
      }
      return null
    },

    flushStack() {
      app.firewoods.forEach(fw => fw.isVisible = true)
    }
  }

  app.FirewoodsFn = FirewoodsFn
})()
