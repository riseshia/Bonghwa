const timelineTypes = [
  { id: 1, name: "Now", needDummy: true },
  { id: 2, name: "Mt", needDummy: false },
  { id: 3, name: "Me", needDummy: true },
  { id: 4, name: "Faved", needDummy: false }
]

export default {
  all() {
    return timelineTypes
  },
  find(id) {
    for (let i = 0; i !== timelineTypes.length; i += 1) {
      if (timelineTypes[i].id === id) { return timelineTypes[i] }
    }
    return null
  }
}
