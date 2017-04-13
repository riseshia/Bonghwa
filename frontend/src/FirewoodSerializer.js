const dPersisted = true
const dIsImgOpened = false
const dIsTextOpened = false

function isMtTarget(token) {
  if (token.length < 3) { return false }
  return token[0] === "@" || token[0] === "!"
}

export default function (obj) {
  const mentioned = obj.contents.split(" ")
                       .filter(token => (isMtTarget(token)))

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
    isImgOpened: obj.isImgOpened === undefined ? dIsImgOpened : obj.isImgOpened,
    isTextOpened: obj.isTextOpened === undefined ? dIsTextOpened : obj.isTextOpened
  }
}
