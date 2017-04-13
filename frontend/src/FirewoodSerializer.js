import Store from "./Store"

const dPersisted = true
const dIsTextOpened = false

function isMtTarget(token) {
  if (token.length < 3) { return false }
  return token[0] === "@" || token[0] === "!"
}

export default function (obj) {
  const mentioned = obj.contents.split(" ")
                       .filter(token => (isMtTarget(token)))
  const dIsImgOpened = Store.getState("global").isImageAutoOpen
  const dInStack = !Store.getState("global").isLiveStreaming
  const owned = Store.getState("user").user_id === obj.user_id

  return {
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
    inStack: obj.inStack === undefined ? dInStack : obj.inStack,
    isImgOpened: obj.isImgOpened === undefined ? dIsImgOpened : obj.isImgOpened,
    isTextOpened: obj.isTextOpened === undefined ? dIsTextOpened : obj.isTextOpened
  }
}
