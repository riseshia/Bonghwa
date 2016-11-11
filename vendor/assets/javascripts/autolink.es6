const ReactAutolink = (() => {
  const delimiter = /((^|\s)(?:https?:\/\/)(?:(?:[a-z0-9]?(?:[a-z0-9\-]{1,61}[a-z0-9])?\.[^\.|\s])+[a-z\.]*[a-z]+|(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3})(?::\d{1,5})*[a-z0-9.,_\/~#&= %+?\-\\(\\)]*)/ig

  const strStartsWith = (str, prefix) => {
    return str.slice(0, prefix.length) === prefix
  }

  const clkLink = e => {
    e.stopPropagation()
    return false
  }

  return {
    autoLink (text, options = {}) {
      if (!text) return []

      return text.split(delimiter).map(word => {
        const match = word.match(delimiter)
        if (match) {
          const url = match[0] 
          let shortenUrl = url

          const segments = url.split("/")
          // no scheme given, so check host portion length
          if (segments[1] !== "" && segments[0].length < 5) {
            return word
          }

          if (url.length > 20) {
            shortenUrl = url.substring(0, 17) + "..." 
          }

          options.className = "link_url"
          options.onClick = clkLink
          options.href = strStartsWith(url, "http") ? url : `http://${url}`

          return React.createElement("a", options, shortenUrl)
        } else {
          return word
        }
      })
    }
  }
})()
