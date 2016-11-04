let autoLink,
  slice = [].slice 

autoLink = function() {
  let callback, callbackOption, key, link_attributes, option, options, url_pattern, value
  options = 1 <= arguments.length ? slice.call(arguments, 0) : []
  url_pattern = /(^|\s)(https?\:\/\/\S+(\.[^\s\<]+))/gi
  if (options.length > 0) {
    option = options[0]
    callbackOption = option.callback 
    if ((callbackOption != null) && typeof callbackOption === "function") {
      callback = callbackOption
      delete option.callback 
    }
    link_attributes = ""
    for (key in option) {
      value = option[key]
      link_attributes += " " + key + "='" + value + "'"
    }
    return this.replace(url_pattern, function(match, space, url) {
      let link, returnCallback, short_url
      returnCallback = callback && callback(url) 
      short_url = url
      if (url.length > 20) {
        short_url = short_url.substring(0, 20) 
        short_url += "..." 
      }
      link = returnCallback || ("<a class='link_url' href='" + url + "'" + link_attributes + ">" + short_url + "</a>") 
      return "" + space + link 
    }) 
  } else {
    return this.replace(url_pattern, "$1<a href='$2'>$2</a>")
  }
}

String.prototype["autoLink"] = autoLink

const ReactAutolink = (() => {
  const delimiter = /((?:https?:\/\/)?(?:(?:[a-z0-9]?(?:[a-z0-9\-]{1,61}[a-z0-9])?\.[^\.|\s])+[a-z\.]*[a-z]+|(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3})(?::\d{1,5})*[a-z0-9.,_\/~#&= %+?\-\\(\\)]*)/ig

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