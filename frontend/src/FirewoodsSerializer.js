import Store from "./Store"

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
  const data = {
    contents: userNamehighlightedContent,
    createdAt: obj.created_at,
    id: obj.id,
    imageAdultFlg: obj.image_adult_flg,
    imageUrl: obj.image_url,
    isDm: obj.is_dm,
    mentionedNames: mentioned,
    name: obj.name,
    prevMtId: obj.prev_mt_id,
    rootMtId: obj.root_mt_id,
    userId: obj.user_id,
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
