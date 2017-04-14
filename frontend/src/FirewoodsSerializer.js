import Store from "./Store"

const dPersisted = true

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

  while (nextId !== 0) {
    const parentFw = find(nextId)
    parents.push(parentFw)
    nextId = parentFw.prevMtId
  }

  return parents
}

function serialize(obj) {
  const mentioned = obj.contents.split(" ")
                       .filter(token => (isMtTarget(token)))
  const owned = Store.getState("user").user_id === obj.user_id
  const data = {
    contents: obj.contents,
    createdAt: obj.created_at,
    id: obj.id,
    imageAdultFlg: obj.image_adult_flg,
    imageUrl: obj.image_url,
    isDm: obj.is_dm,
    name: obj.name,
    prevMtId: obj.prev_mt_id,
    rootMtId: obj.root_mt_id,
    userId: obj.user_id,
    mentionedNames: mentioned,
    persisted: obj.persisted === undefined ? dPersisted : obj.persisted,
    isDeletable: owned,
    inStack: obj.inStack === undefined ? false : obj.inStack
  }
  indexing(data)
  return data
}

export default function (fws, inStack = true) {
  const serializedFws = fws.map((fw) => {
    fw.inStack = inStack
    return serialize(fw)
  })
  serializedFws.forEach((fw) => {
    fw.parents = parentsFor(fw)
  })
  return serializedFws
}
