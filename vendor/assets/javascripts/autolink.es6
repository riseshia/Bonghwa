const ReactAutolink = (() => {
  const delimiter = /((^|\s)(?:https?:\/\/)(?:(?:[a-z0-9]?(?:[a-z0-9\-]{1,61}[a-z0-9])?\.[^\.|\s])+[a-z\.]*[a-z]+|(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3})(?::\d{1,5})*[a-z0-9.,_\/~#&= %+?\-\\(\\)]*)/ig

  const strStartsWith = (str, prefix) => {
    return str.slice(0, prefix.length) === prefix
  }

  return {
    autoLink (text, options = {}) {
      if (!text) return []

      return text.split(delimiter).map(word => {
        const match = word.match(delimiter)
        if (match) {
          let url = match[0] 

          const segments = url.split("/")
          // no scheme given, so check host portion length
          if (segments[1] !== "" && segments[0].length < 5) {
            return word
          }

          if (url.length > 20) {
            url = url.substring(0, 17) + "..." 
          }

          options.className = "link_url"
          options.href = strStartsWith(url, "http") ? url : `http://${url}`

          return React.createElement(
            "a", options, url
          )
        } else {
          return word
        }
      })
    }
  }
})()
