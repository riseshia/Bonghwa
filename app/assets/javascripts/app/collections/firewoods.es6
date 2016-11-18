(function () {
  "use strict"
  const app = window.app
  
  const FirewoodsFn = {
    prependSome(fws) {
      for(let i = fws.length - 1; i >= 0; i--) {
        const fw = this.parse(fws[i])
        app.firewoods.unshift(fw)
      }
    },

    appendSome(fws) {
      app.firewoods = app.firewoods.concat(fws).map(fw => (this.parse(fw)))
    },

    parse(fw) {
      this.setupParents(fw)
      fw.contents = this.unescapeContents(fw)
      fw.mentioned =
        fw.contents.split(" ").
        filter(token => (this.isMtTarget(token)))

      return fw
    },

    isMtTarget(token) {
      if (token.length < 3) { return false }
      return token[0] === "@" || token[0] === "!"
    },

    unescapeContents(fw) {
      return fw.contents.replace("&lt;", "<").replace("&gt;", ">")
    },

    setupParents(fw) {
      if (fw.prev_mt !== 0) {
        fw.parents = this.getPreviousFws(fw.prev_mt, 5)
      } else {
        fw.parents = []
      }
    },

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
