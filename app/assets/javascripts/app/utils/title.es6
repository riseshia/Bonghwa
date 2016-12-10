(function () {
  "use strict"
  const app = window.app

  const originTitle = document.title
  
  const Title = {
    renderNumber(number) {
      return number > 0 ? `(${number}) ` : ""
    },

    render(number) {
      document.title = `${this.renderNumber(number)}${originTitle}`
    }
  }

  app.Title = Title
})()

