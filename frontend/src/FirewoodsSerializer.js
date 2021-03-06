import Store from "./Store"

const assetHost = `${process.env.API_HOST}`

function isMtTarget(token) {
  if (token.length < 3) { return false }
  return token[0] === "@" || token[0] === "!"
}

const index = {}

function find(id) {
  return index[id]
}

function indexing(fw) {
  if (fw.id) { index[fw.id] = fw }
}

function parentsFor(fw) {
  const parents = []
  let nextId = fw.prevMtId
  let parentFw = find(nextId)

  while (parentFw) {
    parents.push(parentFw)
    nextId = parentFw.prevMtId
    parentFw = find(nextId)
  }

  return parents
}

function addParent(obj) {
  obj.parentNotEnough = false
  const parents = obj.parents

  if (parents.length === 0 && obj.rootMtId === 0) { return obj }
  if (parents.length !== 0 && obj.rootMtId === parents[parents.length - 1].id) {
    return obj
  }
  obj.parentNotEnough = true

  return obj
}

function serialize(obj) {
  const user = Store.getState("user")
  const formState = Store.getState("form-state") || {}
  const mentioned = obj.contents.split(" ")
                       .filter(token => (isMtTarget(token)))
  const regex = RegExp(`[@|!]${user.user_name}`)
  const userNamehighlightedContent =
    obj.contents.replace(regex, match => (
      `<span class="font-weight-bold">${match}</span>`
    ))
  const owned = user.user_id === obj.user_id

  if (obj.image) {
    const image = obj.image
    image.url = assetHost + image.url
    if (image.name.length > 20) {
      image.name = `${image.name.slice(0, 20)}...`
    }
    obj.image = image
  }

  const data = {
    contents: userNamehighlightedContent,
    createdAt: obj.created_at,
    id: obj.id,
    sensitiveFlg: obj.sensitive_flg,
    image: obj.image,
    isDm: obj.is_dm,
    mentionedNames: mentioned,
    name: obj.name,
    prevMtId: obj.prev_mt_id,
    rootMtId: obj.root_mt_id,
    userId: obj.user_id,
    isFaved: obj.is_faved,
    isDeletable: owned,
    isMentioned: formState.prevMtId === obj.id,
    isLastRecent: obj.isLastRecent || false,
    status: obj.status,
    ts: obj.ts
  }
  indexing(data)
  return data
}

export default function (fws, dStatus) {
  const serializedFws = fws.map((fw) => {
    if (fw.status === undefined) { fw.status = dStatus }
    return serialize(fw)
  })
  serializedFws.forEach((fw) => {
    fw.parents = parentsFor(fw)
    addParent(fw)
  })
  return serializedFws
}
