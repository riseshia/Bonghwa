# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.$DOM =
  form: ->
    $('#new_firewood')
  form_commit: ->
    $('#commit')
  form_contents: ->
    $('#firewood_contents')
  form_prev_mt: ->
    $('#firewood_prev_mt')

  op_img_auto_open: ->
    $('#img_auto_open_op')
  op_live_stream: ->
    $('#live_stream_op')
  op_focus_hotkey: ->
    $('#focus_hotkey')
  op_refresh_hotkey: ->
    $('#refresh_hotkey')

  notice: ->
    $('#info')
  notice_list: ->
    $('#info > div')

  timeline: ->
    $('#timeline')
  timeline_stack: ->
    $('#timeline_stack')
  firewoods: ->
    $('.firewood')
  title: ->
    $('#title')
  div_loading: ->
    $('#loading')
  timeline_stack_anker: ->
    $('#notice_stack_new')

  div_currents_users: ->
    $('#current_users')

  nav_now: ->
    $('#now_nav')
  nav_mt: ->
    $('#mt_nav')
  nav_me: ->
    $('#me_nav')
  nav_lab: ->
    $('#lab_nav')

  isNowPage: ->
    $('#now_page').length > 0
  isMtPage: ->
    $('#mt_page').length > 0
  isMePage: ->
    $('#me_page').length > 0
  isLabPage: ->
    $('#lab_page').length > 0

window.UIForm =
  count:     0
  input:     0
  maxCount: 150

  clear: ->
    $DOM.form().clearForm()
    $('#img').val("")
    $('.fileinput-preview').html('')
    $('.fileinput').removeClass('fileinput-exists')
                   .addClass('fileinput-new')
    $('.fileinput-filename').html('')
    $DOM.form_commit().button('reset')
    $DOM.form_prev_mt().val('')
    # submit event는 키 입력 이벤트를 발생시키지 않으므로 수동으로 트리거를 당겨야함.
    UIForm.update_count()

  initialize: ->
    # 카운터 기능을 초기화한다.
    UIForm.count = $('#remaining_count')
    UIForm.input = $DOM.form_contents()

    # 입력글자수 체크
    UIForm.input.bind('input keyup paste', ->
      setTimeout(UIForm.update_count,10)
    )

    # 툴팁 활성화.
    $('span[rel=tooltip]').tooltip()

    # Bind ajax form
    $DOM.form().submit( ->
      $(this).ajaxSubmit(BWClient.ajaxBasicOptions)
      return false
    )

  update_count: ->
    before = Number(UIForm.count.text())
    now = UIForm.maxCount - UIForm.input.val().length;

    if UIForm.isEmpty()
      $DOM.form_commit().val("Refresh")
    else
      $DOM.form_commit().val("Submit")

    if now < 0
      str = UIForm.input.val()
      UIForm.input.val(str.substr(0, UIForm.maxCount))
      now = 0

    if before isnt now
      UIForm.count.text(now)

  isEmpty: ->
    if $('div.fileinput-exists').length is 0
      str = $DOM.form_contents().val()
      if str.length is 0 or str.search(/^\s+$/) isnt -1
        return true

    return false

window.UIUserList =
  update: (users) ->
    unless users.length isnt 0
      return false

    ($DOM.div_currents_users())[0].innerHTML = TagBuilder.userList(users)

window.UINotice =
  initialize: ->
    $self = $(this)
    # 공지사항이 있으면 클릭 remove 바인드할것.
    unless $DOM.notice().length is 0
      $DOM.notice().click( ->
        $self.slideUp( ->
          $self.remove()
        )
      )

    # 공자사항에 링크를 추가
    $DOM.notice_list().each( ->
      $self.html($self.html().autoLink({ target: "_blank", rel: "nofollow"}))
    )

window.UITimeline =
  initialize: ->
    $timeline = $DOM.timeline()

    # delecate fw expend
    $('body').on('click', '.mt-to', UITimeline.clickFWExpand)

    # delecate ajax delete
    $timeline.on('click', '.delete', UITimeline.clickDelete)

    # delecate name click
    $timeline.on('click', '.mt-clk', UITimeline.clickUsername)
    $DOM.div_currents_users().on('click', '.mt-clk', UITimeline.clickUsername)

    # delecate fw close
    $timeline.on('click', '.mt-open', UITimeline.clickFWFold)

    # delecate link url
    $timeline.on('click', '.link_url', UITimeline.clickLinkUrl)
    $('#info .link_url').click(UITimeline.clickLinkUrl) # 공지사항의 링크

    # delecate stack anker
    $DOM.timeline_stack().on('click', '#notice_stack_new', UITimeline.clickTimelineStackAnker)

    # load recent firewood
    BWClient.load()

    # bind get logs
    setInterval(BWClient.getlogs,1500)

    # focusing
    $DOM.form_contents().focus()

  prepend: (contents) ->
    $DOM.timeline().prepend(contents)

  append: (contents) ->
    $DOM.timeline().append(contents)

  # Event : link click
  clickLinkUrl: (e) ->
    if e.target isnt this
      return true

    # 버블링만 막고, 링크 연결은 그대로 처리.
    e.stopPropagation()

  # Event : click delete
  clickDelete: (e) ->
    if e.target isnt this
      return true

    really = confirm("정말 삭제하시겠어요?")

    if really
      $self = $(this)

      $div = $self.parent().parent().parent()
      id = $div.attr('data-id')
      $.ajax({
        url: '/api/destroy?id=' + id
        type: 'delete'
        dataType: 'json'
      })
      $div.parent().remove()

    return false

  # Event : click user name for mention
  clickUsername: (e) ->
    if e.target isnt this
      return true

    e.stopPropagation()

    $self = $(this)

    # get mention id in text
    text = $self.parent().text()
    ps = text.split(' ')
    ms = ''
    $selfPPP = $self.parent().parent().parent()
    if $selfPPP.attr('is_dm') is undefined or $selfPPP.attr('id') is "current_users" #접속자 리스트도 바인딩
      ms = '@'
    else
      ms = '!'

    $targets = $self.parent().find('.mt-target')
    main_target = ms + $self.text()

    real_targets = (main_target + ' ') # 이름값 넣고
    (
      real_targets += ($(target).text() + ' ')
    ) for target in $targets  when $(target).text() isnt main_target and $(target).text() isnt ms + BWUtil.userName()

    real_targets += $DOM.form_contents().val()

    $DOM.form_prev_mt().val($selfPPP.attr('data-id'))
    $DOM.form_contents().val(real_targets).focus()

    return false

  # Event : 장작을 닫는다.
  clickFWFold: (e) ->
    e.stopPropagation()

    $(this).addClass('mt-to')
           .removeClass('mt-open')
           .find('.sub, .loading').slideUp( ->
             $(this).remove()
           )

    return false

  # Event : 장작을 연다.
  clickFWExpand: (e) ->
    # 버블링 차단. 이렇게 처리하지 않으면, 장작내 링크를 사용할 수 없음.
    e.stopPropagation()

    $self = $(this)

    prev_id = $self.attr('prev_mt')
    $mt_list = UITimeline.traceMtFromTL($self.attr("data-id"))
    img_tag = TagBuilder.imgTag($self)

    # no mention
    if prev_id is "0" and img_tag is ""
      return true

    # 멘션 열고 로딩중 표시.
    $self.removeClass('mt-to')
         .addClass('mt-open')
         .find('.fw-main')
         .after('<div class="loading" style="display:none;">로딩중입니다.</div>')
    $self.find('.loading')
         .slideDown(200)

    str = ""
    if $mt_list.length > 0
      str = TagBuilder.mtListFromTimeline($mt_list, $self) + img_tag
      UITimeline.insertFWExpandResult($self, str)
    else if prev_id is "0" and img_tag isnt ""
      # 멘션은 없는데 이미지만 있으면.
      UITimeline.insertFWExpandResult($self, img_tag)
    else
      # 멘션은 있지만, ajax 요청이필요함.
      # 락이 걸려있다면 로드 무시.
      unless BWClient.isMtAjaxLocked is 0
        $self.find('.loading').html('로딩에 실패했습니다. 잠시 뒤에 다시 시도해보세요.')
        return true

      # ajax request
      BWClient.ajaxMtLoad($self, prev_id, img_tag)

    return true

  clickTimelineStackAnker: ->
    # 구분선이 이전에 있었다면 삭제
    $('.last_top').removeClass('last_top').attr('style','')

    #구분선 주기.
    $('.div-firewood:first').addClass('last_top').attr('style','border-top-width:3px;')

    UITimeline.stackFlush()

    return false

  traceMtFromTL: (last_id) ->
    prev_mt_of_leaf = $(".firewood[data-id=#{last_id}]").attr("prev_mt")
    traced_list = []

    $node = $(".firewood[data-id=#{prev_mt_of_leaf}]")

    # 추적할 멘션이 없을 경우.
    if $node.size() is 0
      return traced_list

    is_last = false
    while(not is_last and traced_list.length < 5)
      if $node.attr("prev_mt") is "0"
        is_last = true

      traced_list.push($node)
      prev_mt = $node.attr("prev_mt")
      $node = $(".firewood[data-id=#{prev_mt}]")

      if $node.size() is 0
        is_last = true

    return traced_list

  insertFWExpandResult: ($self, str) ->
    $self.find('.loading').remove()
    $self.find('.fw-main')
         .after("<div class='sub' style='display:none;'>#{str}</div>")
    $self.find('.sub')
         .slideDown(200)

  # 이미지가 달려있는 mt를 오픈한다.
  expandImgs: ($list) ->
    $list.each( ->
      $(this).trigger('click')
    )

  # 새 장작을 서버에서 받아왔을 경우, 스택에 쌓아두고 몇개를 받아두고 있는지를 시현한다.
  noticeNew: ->
    if BWUtil.stackIsEmpty()
      return false

    # 새글 알림 태그 생성
    $DOM.timeline_stack()
        .html("<a href='#' id='notice_stack_new'>새 장작이 #{BWUtil.stackSize}개 있습니다.</a>")
    $DOM.title().html("#{BWUtil.rawTitle} (#{BWUtil.stackSize})")

    $DOM.timeline_stack().slideDown(200)

    if window.getStorageValue('recent_alert_on') is window.TRUE
      $('#recent_alert_src').html('<embed src="se/recent.mp3" width="0" height="0" />')

  # print out from stack
  stackFlush: ->
    # 새글 알림이 떠 있으면 제거한다.
    if $DOM.timeline_stack_anker().length isnt 0
      $DOM.timeline_stack().slideUp(200, ->
        $(this).html('')
      )

    stack_size_temp = BWUtil.stackSize

    $DOM.timeline().prepend(BWUtil.stackPop())
    $DOM.title().text(BWUtil.rawTitle) # 타이틀 옆의 (4) 표시 제거. IE 8이하에서 에러뜸. 왜죠...

    # 이미지 자동 열기 옵션이 활성화 중이면, 새로 받아온 글에 한해서 트리거를 작동시킴
    if window.getStorageValue('auto_image_open') is window.TRUE
      $list = $(".firewood:lt(#{stack_size_temp})").filter('.mt-to[img-link!=0]')
      UITimeline.expandImgs($list)

    HashTagUtil.apply_tag($("#select-tag").val())

window.BWUtil =
  lastIdOfbw: 0 # 마지막 장작의 id. 스택에 들어있는 부분도 포함한다.
  stack: "" # 장작을 쌓아두는 스택
  stackSize: 0 # 스택의 크기
  rawTitle: "" # 봉화의 타이틀
  pageType: 0 # 페이지 타입. now/mt/me 구분하고 ajax req 시에 첨부한다.

  initialize: ->
    BWUtil.rawTitle = $DOM.title().text()
    BWUtil.supportCheck()
    BWUtil.pageCheck()

    BWUtil.initGlobalVariable()
    BWUtil.bindHotkey()
    BWUtil.initHotkey()

  userName: () ->
    return $.cookie('user_name')

  userName_r: () ->
    return new RegExp("(@|!)(#{$.cookie('user_name')})")

  stackPush: (itemStr, size, lastId) ->
    BWUtil.stack = itemStr + BWUtil.stack
    BWUtil.stackSize += size
    BWUtil.lastIdOfbw = lastId

    return true

  stackPop: ->
    tempStr = BWUtil.stack
    BWUtil.stack = ""
    BWUtil.stackSize = 0

    return tempStr

  stackIsEmpty: ->
    return BWUtil.stackSize is 0

  supportCheck: ->
    # Local Storage Support Check
    if( not ('localStorage' of window) or window['localStorage'] is null)
      alert("현재 브라우저는 WebStorage를 지원하지 않아, 봉화가 정상적으로 작동하지 않습니다. Chrome, Firefox, IE 8.0 이상의 브라우저 등을 이용해주세요.")
      return false
    else
      window.getStorageValue = (key) ->
        value = window.localStorage[key]
        if value
          return value
        else
          return false

      window.setStorageValue = (key, value) ->
        window.localStorage[key] = value
      return true

  pageCheck: ->
    # view 구분
    if $DOM.isNowPage()
      BWUtil.pageType = 1
      $DOM.nav_now().parent().addClass('active')
    else if $DOM.isMtPage()
      BWUtil.pageType = 2
      $DOM.nav_mt().parent().addClass('active')
    else if $DOM.isMePage()
      BWUtil.pageType = 3
      $DOM.nav_me().parent().addClass('active')
    else if $DOM.isLabPage()
      BWUtil.pageType = 1
      $DOM.nav_lab().parent().addClass('active')

  initGlobalVariable: ->
    # Global Variable
    window.TRUE = '1'
    window.FALSE = '0'
    window.isInitializeTime = true # 초기 로딩하는 부분인지 구별.

  # hotkey 설정을 바인딩한다.
  initHotkey: ->
    # 트리거 내부에서 Local Storage를 조작하므로 미리 플래그를 한번 꺽는다.
    if window.getStorageValue('auto_image_open') is window.TRUE
      window.setStorageValue('auto_image_open', window.FALSE)
      $DOM.op_img_auto_open().trigger('click')
    if window.getStorageValue('live_stream') is window.TRUE
      window.setStorageValue('live_stream', window.FALSE)
      $DOM.op_live_stream().trigger('click')

    # trigger key
    $(document).keycut();

  # make stack from json object
  parseFWs: (json) ->
    list = json.fws
    _last_id_now = Number($DOM.firewoods().first().attr("data-id"))

    # 갱신사항이 없으면 종료.
    if list.length is 0
      return false
    else if _last_id_now >= list[0].id
      return false
    else
      BWUtil.stackPush(TagBuilder.fwList(list), list.length, list[0].id)

  bindHotkey: ->
    # 새로고침 단축
    $DOM.op_refresh_hotkey().click( ->
      BWClient.load()
      return false
    )

    #bind img auto load option
    $DOM.op_img_auto_open().click( (e) ->
      e.stopPropagation()

      $self = $(this)
      if window.getStorageValue('auto_image_open') is window.TRUE
        $self.removeClass('true')
        $self.find('.glyphicon-ok').remove()

        window.setStorageValue('auto_image_open', window.FALSE)

        # close all mt
        $('.mt-open').trigger('click')
        popup_alert('이미지 자동 열기 옵션이 비활성화되었습니다.', 'alert-info')
      else
        $self.addClass('true')
        $self.html($self.html() + '<span class="glyphicon glyphicon-ok"></span>')

        window.setStorageValue('auto_image_open', window.TRUE)

        UITimeline.expandImgs($('.mt-to[img-link!=0]'))
        popup_alert('이미지 자동 열기 옵션이 활성화되었습니다.', 'alert-info')

      return false
    )

    #bind live stream option
    $DOM.op_live_stream().click( ->
      $self = $(this)
      if window.getStorageValue('live_stream') is window.TRUE
        $self.removeClass('true')
        $self.find('.glyphicon-ok').remove()
        window.setStorageValue('live_stream', window.FALSE)
        popup_alert('Live Stream이 비활성화되었습니다.', 'alert-info')

        # speed down
        clearTimeout(BWClient.pullingTimer)
        BWClient.pullingPeriod = 30000
        BWClient.pullingTimer = setTimeout(BWClient.pulling, BWClient.pullingPeriod)

      else
        $self.addClass('true')
        $self.html($self.html() + '<span class="glyphicon glyphicon-ok"></span>')
        UITimeline.stackFlush()
        window.setStorageValue('live_stream', window.TRUE)
        popup_alert('Live Stream이 활성화되었습니다.', 'alert-info')

        # speed up
        clearTimeout(BWClient.pullingTimer)
        BWClient.pullingPeriod = 1000
        BWClient.pullingTimer = setTimeout(BWClient.pulling, BWClient.pullingPeriod)

      return false
    )

    # 포커싱 단축키.
    $DOM.op_focus_hotkey().click( ->
      $("html, body").animate({ scrollTop: 0 }, 600)
      $DOM.form_contents().focus()

      return false
    )

window.BWClient =
  pullingTimer: 0 #setTimeout 객체를 보관하는 변수
  pullingPeriod: 30000 # 갱신 주기
  isBottomLoading: false # 로그 긁는지애 대한 비동기 처리.
  sizeWhenBottomLoading: 50 # 한번에 과거 로그를 얼마나 긁어올지에 대한 변수.
  isSendingNow: false # refresh에서 사용할 비동기 처리용 변수.
  isAjaxLocked: false # 연속 엔터 입력 방지용.
  isMtAjaxLocked: 0 # 멘션 비동기 로딩할때 동시 로딩으로 서버에 부하를 주는것을 막기위해서 사용.
  failCount: 0 #ajax 실패 횟수 기록

  initialize: ->
    $(document).ajaxError(BWClient.ajaxError)

  # Ajax 전송 전에 처리할 부분.
  preprocess: (formData, jqForm, options) ->
    $DOM.form_commit().button('loading') # 타이머 클리어.
    clearTimeout(BWClient.pullingTimer)
    BWClient.isSendingNow = true # refresh 처리를 위해서 플래그 세움

    if BWClient.isAjaxLocked
      return false

    # 아무것도 없으면 전송을 버리고, 새 데이터만 받는다.
    if UIForm.isEmpty()
      BWClient.succeedSubmit()
      return false

    # Tag 덧붙이기
    tag = $("#select-tag").val()
    prev_index = formData.length - 1
    if formData[prev_index].value isnt "" and formData[prev_index].value isnt "0"
      tag = ""
      $(".firewood[data-id=#{formData[prev_index].value}] .fw-main .fw-tag").each( ->
        tag += "#{$(this).text()} "
      )
    if tag.length > 2 and tag[0] is "#"
      formData[2].value += " " + tag

    #락 걸기
    BWClient.isAjaxLocked = true

  # Ajax 전송 후에 처리해야할 부분.
  succeedSubmit: (data) ->
    # Form 을 정리
    UIForm.clear()

    # 새 데이터를 받아옴.
    BWClient.pulling()

    # 락 해제.
    BWClient.isAjaxLocked = false

  # ajax basic firewood option
  # 옵션을 줄때 쓰는 콜백 함수가 이 옵션보다 상위에서 정의되어있어야 한다.
  ajaxBasicOptions:
    url:           'api/new'
    type:          'post'
    dataType:      'json'
    beforeSubmit: (formData, jqForm, options) ->
      BWClient.preprocess(formData, jqForm, options)
    success: ->
      BWClient.succeedSubmit()


  # 최근 장작을 가져온다.
  load: ->
    # 준비 표시
    $DOM.div_loading().html('로드 중입니다.')
    #타임 라인 비우기.
    $DOM.timeline().html('')

  	# 타이머 클리어.
    clearTimeout(BWClient.pullingTimer)
    $.get("/api/now?type=#{BWUtil.pageType}", (json) ->
      $DOM.timeline().html('') # 비우고

      BWUtil.parseFWs(json)
      UIUserList.update(json.users) # IE 호환 문제. append가 안먹어서 js가 stackFlush에서 사망함. 때문에 가독성은 좀 떨어지지만 유저 리스트를 우선 새로고치고 pop처리.
      UITimeline.stackFlush()

      BWClient.pullingTimer = setTimeout(BWClient.pulling, BWClient.pullingPeriod)
    )

  # refresh data
  pulling: ->
    clearTimeout(BWClient.pullingTimer)

    # $.get("/api/pulling.json?after=#{BWUtil.lastIdOfbw}&type=#{BWUtil.pageType}", (json) ->
    #   BWUtil.parseFWs(json)

    #   if window.getStorageValue('live_stream') is window.TRUE or BWClient.isSendingNow
    #     UITimeline.stackFlush()
    #     BWClient.isSendingNow = false # 사용후 플래그 해제

    #   unless BWUtil.stackIsEmpty()
    #     UITimeline.noticeNew()

    #   UIUserList.update(json.users)
    #   BWClient.pullingTimer = setTimeout(BWClient.pulling, BWClient.pullingPeriod)
    # )

  lockMtAjax: (id) ->
    BWClient.isMtAjaxLocked = id

  relMtAjax: ->
    BWClient.isMtAjaxLocked = 0

  # 서버에서 멘션을 받아올때.
  ajaxMtLoad: ($self, prev_mt, img_tag) ->
    # ajax request
    BWClient.lockMtAjax($self.attr('data-id')) # 락걸기.
    $.get("/api/get_mt.json?prev_mt=#{prev_mt}&now=#{BWClient.isMtAjaxLocked}", (json) ->
      str = ''
      if (json.fws.length isnt 0)
        mts = json.fws

        h = -1
        temp = []
        temp[++h] = '<li class="list-group-item div-mention">'
        (temp[++h] = '<div class="mt-trace"><small><a href="#">'
        temp[++h] = mt.name
        temp[++h] = '</a> : '
        temp[++h] = mt.contents
        temp[++h] = '</small>'
        temp[++h] = '<small class="pull-right">'
        temp[++h] = mt.created_at
        temp[++h] = '</small></div>'
        ) for mt in mts
        temp[++h] = '</li>'
        str = temp.join('')

      $self = $("div[data-id=#{BWClient.isMtAjaxLocked}]")
      UITimeline.insertFWExpandResult($self, str+img_tag)
      BWClient.relMtAjax() # 락 해제
    )

  # get logs automatically
  getlogs: ->
    if BWClient.isBottomLoading # 락 체크
      return false

    $fws = $DOM.firewoods()
    if $fws.length < 50 or Number($fws.last().attr('data-id')) < 10 # 장작수가 적으면 로딩할 필요가 없으므로 버린다.
      return false

    if $fws.eq(-5).isOnScreen()
      BWClient.isBottomLoading = true # 락 걸기.
      $bottom = $fws.last()
      $("#div-loading").show()

      # ajax load
      bottom_id = $bottom.attr('data-id')
      $.get("/api/trace.json?before=#{bottom_id}&count=#{BWClient.sizeWhenBottomLoading}&type=#{BWUtil.pageType}", (json) ->
        if (json.fws.length isnt 0)
          timelineSize = $DOM.firewoods().size()-1 # 필터링에서 사용하는건 index라서 -1 처리해줘야함...
          $bottom.parent().after(TagBuilder.fwList(json.fws))
          # 이미지 자동 열기 옵션이 활성화 중이면, 새로 받아온 글에 한해서 트리거를 작동시킴
          if window.getStorageValue('auto_image_open') is window.TRUE
            $list = $(".firewood:gt(#{timelineSize})").filter('.mt-to[img-link!=0]')
            UITimeline.expandImgs($list)

        $("#div-loading").hide()
        BWClient.isBottomLoading = false # 락 해제
      )

  ajaxError: ->
    BWClient.failCount += 1

    if BWClient.failCount < 3
      clearTimeout(BWClient.pullingTimer)
      BWClient.pullingTimer = setTimeout(BWClient.pulling, BWClient.pullingPeriod)
      return true

    $panel = $(".panel-info")
    $panel.removeClass("panel-info").addClass("panel-danger")
    $("#info").css("background-color","#f2dede")
    $DOM.form().find("fieldset").attr("disabled","a")
    $DOM.timeline_stack()
      .css("background-color","#b94a48")
      .html("서버와의 접속이 끊어졌습니다. 새로고침 해주세요.")
      .slideDown()
    $DOM.title().html("새로고침 해주세요.")

window.TagBuilder =
  mtListFromTimeline: ($mt_list, $self) ->
    str = '<li class="list-group-item div-mention">'
    for $mt in $mt_list when Number($mt.attr("data-id")) < Number($self.attr("data-id"))
      str += '<div class="mt-trace"><small>'
      str += $mt.find('.fw-main').html()
      str += '</small><small class="pull-right">'
      str += $mt.find('.time').text()
      str += '</small></div>'
    str += '</li>'
    # delete button 제거
    str = str.replace(/\[x\]/g, "")
    # 닉네임 클릭 기능 제거.
    str = str.replace(/fw-username mt-clk/g, "")
    return str

  # 이미지 url을 가지고 img tag를 만들어 반환한다.
  imgTag: ($self) ->
    # if having img
    img_link = $self.attr('img-link')
    if img_link is "0"
      return ""
    else if $(window).width() > $(window).height()
      return "<div class='img-content'><img class='img-standard' src='#{img_link}'></img><p><small><a href='#{img_link}' class='link_url' target='_blank'>크게 보기</a></small></p></div>"
    else
      return "<div class='img-content'><img class='img-mobile' src='#{img_link}'></img><p><small><a href='#{img_link}' class='link_url' target='_blank'>크게 보기</a></small></p></div>"

  insertTag: (fw) ->
    fw.contents = fw.contents.replace(/\s(#[^\s]+)/g, " <a href='#' class='fw-tag'>$1</a>")
    fw.contents = fw.contents.autoLink({ target: "_blank", rel: "nofollow"})
    if fw.is_dm isnt 0
      fw.contents = fw.contents.replace(/^!([^\s]\S+)/g, "<span class='mt-target'>!$1</span>")
    else
      fw.contents = fw.contents.replace(/(^|\s)(@[^@!\s]+)/g, "$1<span class='mt-target'>$2</span>")
    fw.contents = fw.contents.replace(BWUtil.userName_r(), "$1<strong>$2</strong>") # 멘션, DM에 대한 강조 처리.

    return fw

  # 장작 리스트를 받아서 html 태그 조각을 생성한다.
  fwList: (list) ->
    tag = $("#select-tag").val()
    _bottom = list[list.length - 1]
    if bottom_id is 0 or bottom_id > _bottom.id
      bottom_id = _bottom.id
    h = -1
    temp = []
    (fw = TagBuilder.insertTag(fw)
    temp[++h] = '<li class="list-group-item div-firewood'
    temp[++h] = '"><div class="row firewood mt-to" data-id="'
    temp[++h] = fw.id
    temp[++h] = '" prev_mt="'
    temp[++h] = fw.prev_mt
    if(fw.is_dm isnt 0)
      temp[++h] = '" is_dm="'
      temp[++h] = fw.is_dm
    temp[++h] = '" img-link="'
    temp[++h] = fw.img_link
    temp[++h] = '"><div class="col-md-10 fw-cnt"><div class="fw-main"><a class="fw-username mt-clk" href="#">'
    temp[++h] = fw.name
    temp[++h] = '</a> : <span class="fw-contents">'
    temp[++h] = fw.contents
    temp[++h] = "</span>"
    if Number($.cookie('user_id')) is fw.user_id
      temp[++h] = ' <a href="#" class="delete">[x]</a>'
    temp[++h] = '</div></div><div class="col-md-2 time"><small>'
    temp[++h] = fw.created_at
    temp[++h] = '</small></div></div></li>'
    ) for fw in list

    return temp.join('')

  userList: (users) ->
    count = users.length
    h = -1
    temp = []
    temp[++h]  = '<div class="panel-heading">접속자('
    temp[++h]  = users.length
    temp[++h]  = '명)</div><ul class="list-group">'
    (temp[++h] = '<li class="list-group-item div-username"><a class="mt-clk" href="#">'
    temp[++h]  = user.name
    temp[++h]  = '</a></li>'
    ) for user in users

    temp[h] = '</ul>'

    return temp.join('')

window.MobileUserList = 
  initialize: ->
    $(".mobile-userlist-trigger").click( ->
      content = $("#current_users").html()
      MobileUserList.toggleDiv().html(content)

      heading = $("#mobile-userlist-div .panel-heading").html()
      $("#mobile-userlist-div .panel-heading").html(heading + " - <a class='mt-clk' style='color: #21607f;'>돌아가기</a>")
    )

    $("#mobile-userlist-div").on('click', '.mt-clk', (e) ->
      MobileUserList.toggleDiv()

      if ($(this).parent().hasClass("div-username"))
        user_name = "@" + $(this).html() + " "
        $DOM.form_contents().val(user_name).focus()

      return false
    )

    return false

  toggleDiv: ->
    $("#mobile-userlist-div").animate({
          width: 'toggle'
      }, "slow")


window.HashTagUtil =
  initialize: ->
    $(".navbar-right")
      .after("<form class='navbar-form navbar-right visible-md visible-lg'><div class='form-group' id='div-select-tag'><input autocomplete='off' class='form-control' id='select-tag' placeholder='#Now' type='text'></div>")

    $("#select-tag").parent().parent().submit( ->
      tag = $("#select-tag").val()
      
      if tag[0] is "#"
        HashTagUtil.apply_tag(tag)
      else if tag.length isnt 0
        alert "태그는 #으로 시작해야합니다."
      else
        $(".tagged").removeClass("tagged")

      return false
    )

    # delecate tag click
    $('#timeline').on('click', '.fw-tag', (e) ->
      if e.target isnt this
        return true

      e.stopPropagation()

      now_tag = $("#select-tag").val()
      tag_name = $(this).text()
      if tag_name is now_tag
        $(".tagged").removeClass("tagged")
        $("#select-tag").val("")
      else
        HashTagUtil.apply_tag(tag_name)

      return false
    )


  apply_tag: (tag_name) ->
    if tag_name is undefined or tag_name[0] isnt "#"
      return

    $(".div-firewood").each((i)->
      $self = $(this)
      $tags = $self.find(".fw-tag")
      if $tags.size() == 0
        return

      is_tagged = false
      $tags.each( ->
        if $(this).text() is tag_name
          is_tagged = true
      )

      if is_tagged
        $self.addClass("tagged") 
      else
        $self.removeClass("tagged")
    )

    $("#select-tag").val(tag_name)

# 경고창을 상단에 띄워준다.
popup_alert = (error, option) ->
  # 로딩중에는 팝업창을 띄우지 않는다.
  if window.isInitializeTime is true
    return false

  $alert = $('<div class="alert" display="none;"></div>')
  $timeline = $DOM.timeline()
  $alert.appendTo('body')
    .html(error)
    .addClass(option)

  left = $timeline.offset().left + $timeline.width()/2
  $alert
    .css('left', left)
    .css('top', 80)

  $alert
    .clearQueue()
    .stop()
    .hide()
    .fadeIn(600)
    .delay(1000)
    .fadeOut(1000)

$(document).ready( ->
  # return true if $('#lab_page').length isnt 0

  # BWUtil.initialize()
  # BWClient.initialize()

  # unless $DOM.notice().length is 0
  #   UINotice.initialize()

  # # TL이 없다면 패스할것.
  # if $DOM.timeline().length > 0
  #   UITimeline.initialize()
  #   UIForm.initialize()

  # # Tag Util
  # HashTagUtil.initialize()

  # # Mobile userList
  # MobileUserList.initialize()

  # # Lab Mode check
  # if $DOM.isLabPage()
  #   window.isLabMode = true
  #   Lab.initialize()

  # # 로딩 종료.
  # window.isInitializeTime = false
  clearTimeout(BWClient.pullingTimer);
)
