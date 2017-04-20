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

function serialize(obj) {
  const user = Store.getState("user")
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
    name: obj.name,
    prevMtId: obj.prev_mt_id,
    rootMtId: obj.root_mt_id,
    userId: obj.user_id,
    mentionedNames: mentioned,
    isDeletable: owned,
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
  })
  return serializedFws
}
