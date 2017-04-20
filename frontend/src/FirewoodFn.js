import FirewoodsSerializer from "./FirewoodsSerializer"

const STATUS = {
  PENDING: 0,
  IN_STACK: 1,
  NORMAL: 2
}

const FirewoodFn = {
  initialize(fws, inStack = true) {
    const dStatus = inStack ? STATUS.IN_STACK : STATUS.NORMAL
    return FirewoodsSerializer(fws, dStatus)
  },
  initializeInStack(fws) {
    return FirewoodsSerializer(fws, STATUS.IN_STACK)
  },
  initializeInTL(fws) {
    return FirewoodsSerializer(fws, STATUS.NORMAL)
  },
  initializeDummy(formData, { user_id, user_name }) {
    const obj = {
      adult_flg: formData.adult_flg,
      prev_mt_id: formData.prev_mt_id,
      root_mt_id: formData.root_mt_id,
      contents: formData.contents,
      name: user_name,
      user_id,
      created_at: "--/--/-- --:--:--"
    }
    return FirewoodsSerializer([obj], STATUS.PENDING)
  },
  isPending(fw) {
    return fw.status === STATUS.PENDING
  },
  inStack(fw) {
    return fw.status === STATUS.IN_STACK
  },
  isNormal(fw) {
    return fw.status === STATUS.NORMAL
  },
  inTimeline(fw) {
    return fw.status === STATUS.NORMAL || fw.status === STATUS.PENDING
  },
  flushAll(fws, { needNotify = false }) {
    let lastRecentFw = null

    const newFws = fws.map((fw) => {
      if (fw.status === STATUS.IN_STACK) { lastRecentFw = fw }
      fw.status = STATUS.NORMAL
      return fw
    })
    if (needNotify && lastRecentFw) {
      lastRecentFw.isLastRecent = true
    }
    return newFws
  },
  lastPersisted(fws) {
    if (fws.length === 0) { return null }
    for (let i = 0; i !== fws.length; i += 1) {
      const fw = fws[i]
      if (fw.id) { return fw }
    }
    return null
  },
  removePending(fws, { ts, lastFwId }) {
    for (let i = 0; i !== fws.length; i += 1) {
      const fw = fws[i]
      if (fw.ts === ts) {
        fws.splice(i, 1)
        break
      }
      if (fw.id <= lastFwId) {
        break
      }
    }

    return fws
  }
}

export default FirewoodFn
