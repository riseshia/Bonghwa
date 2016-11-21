const ReactAutolink = (() => {
  const delimiter = /(^|\s)(https?\:\/\/\S+(\.[^\s\<]+))/gi

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

      const match = text.match(delimiter)
      if (match) {
        const url = match[0] 
        let shortenUrl = url

        if (url.length > 20) {
          shortenUrl = url.substring(0, 17) + "..." 
        }

        options.className = "link_url"
        options.onClick = clkLink
        options.href = strStartsWith(url, "http") ? url : `http://${url}`

        return React.createElement("a", options, shortenUrl)
      } else {
        return text
      }
    }
  }
})()
