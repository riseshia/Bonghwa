const delimiter = /https?:\/\/\S+(\.[^\s<]+)/gi

const buildAnker = (url, options) => {
  const href = url
  let shortenUrl = url
  let classes = ["link-url"]

  if (options.classes) {
    classes = classes.concat(options.classes)
  }

  if (url.length > 20) {
    shortenUrl = `${url.substring(0, 17)}...`
  }
  return `<a href="${href}" class="${classes.join(" ")}" target="_blank">${shortenUrl}</a>`
}

export default function (text, options = {}) {
  if (!text) { return text }

  return text.replace(delimiter, match => (buildAnker(match, options)))
}
