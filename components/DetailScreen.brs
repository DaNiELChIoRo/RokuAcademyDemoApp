sub init()
    m.label = m.top.findNode("descriptionLbl")
    m.title = m.top.findNode("titleLbl")
    m.duration = m.top.findNode("durationLbl")
    m.image = M.top.findNode("videoPoster")    
    m.vidPlayer = m.top.findNode("vidPlayer")
    m.playButton = m.top.findNode("playButton")  
    m.alert = m.top.findNode("alertDialog")

    m.alert.visible = false
    m.alert.buttons = ["OK"]

    m.playButton.observeField("buttonSelected", "playVideo")  
    m.playButton.setFocus(true)
    m.top.prebuffer = true

    m.vidContent = createObject("RoSGNode", "ContentNode")  
    m.vidPlayer.visible = false  
end sub

sub onDescriptionChange()
    m.video = m.top.videoNode
    m.label.text = m.video.description
    m.title.text = m.video.title
    
    'image
    m.image.uri = m.video.HDPosterUrl
    'video
    m.vidContent.url = m.video.url
    m.vidPlayer.content = m.vidContent    
    
    m.vidPlayer.observeField("state", "videoState")  
    
    'Verifyin' if bookmark exists
    sec = createObject("roRegistrySection", "MySection")
    bookmark = "PlaybackBookmark " + m.video.title
    if sec.Exists(bookmark)
      BookmarkTime =  Val(sec.Read(bookmark))
      ?"There is Bookmark for episode and it is: "; BookmarkTime
      m.vidPlayer.seek = BookmarkTime
    end if

    print "Prebuffering..."
    m.vidPlayer.control = "prebuffer"

    ' m.duration.text = m.vidPlayer.duration
end sub

sub videoState() 
    print "***** VIDEO STATE HAS CHANGED - TO "; m.vidPlayer.state
    if m.vidPlayer.state = "error" then
        error = m.vidPlayer
        ?"erro whilr trying to fetch the video, error: "; error.errorCode ; " errorMsg: "; error.errorMsg
        'Displaying error alert
        m.alert.message = error.errorMsg
        m.alert.visible = true
        m.alert.setFocus(true)
        m.alert.observeField("buttonSelected", "onDialogButtonSelected")

        m.vidPlayer.control = "stop"
    end if
end sub

sub onDialogButtonSelected()
    ?"Button dialog has been selected, button"
    m.alert.visible = false
    m.playButton.setFocus(true)
    fireEvent("NAVIGATION", { destination: "back" })
end sub

sub playVideo()
    m.vidPlayer.visible = true
    m.vidPlayer.setFocus(true)
    m.vidPlayer.control = "play"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handle = false
    if press
        if key = "back"
            if m.vidPlayer.visible then
                m.vidPlayer.control = "stop"
                m.vidPlayer.visible = false

                'Saving bookmark 
                TimeStamp = Str(m.vidPlayer.position)
                bookmark = "PlaybackBookmark " + m.video.title
                sec = createObject("roRegistrySection", "MySection")
                sec.Write(bookmark, TimeStamp)
                sec.Flush()

            else if m.alert.visible then
                m.alert.visible = false
                fireEvent("NAVIGATION", { destination: "back" })
            else
                fireEvent("NAVIGATION", { destination: "back" })
            end if
            handle = true         
        else if key = "OK" then
            playVideo()
            ' fireEvent("NAVIGATION", { destination: "videoScreen",  selected: m.video})
        end if
    endif
    return handle
end function