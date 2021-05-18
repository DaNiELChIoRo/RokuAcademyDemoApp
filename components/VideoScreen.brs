sub init()
    m.videoPlayer = m.top.findNode("vidPlayer")
    m.vidContent = CreateObject("roSGNode", "ContentNode")
    ?"videoContent: "; m.videoContent
end sub

sub playVideo()
    location = m.top.videoUrl
    m.vidContent.url = location
    m.videoPlayer.content = m.vidContent
    m.videoPlayer.control = "play"
end sub

' Video buffering error handlin'
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

function onKeyEvent(key as string, press as boolean) as boolean
    handle = false
    if press then
        if key = "back" then
            m.videoPlayer.control = "stop"
            fireEvent("NAVIGATION", { destination: "back" })
            handle = true
        end if
    else if press = false
        if key = "play" then
            if m.videoPlayer.state = "playing" then
                m.videoPlayer.control = "pause"
            else if m.videoPlayer.state = "paused" then
                m.videoPlayer.control = "resume"
            endif
            handle = true        
        else if key = "left" or key = "right" then
            time = m.videoPlayer.position
            ?"video time: "; time; "time type: " type(time)
            if key = "right" then            
                newTime = time + 5
                m.videoPlayer.seek = newTime
            else 
                newTime = time - 5
                m.videoPlayer.seek = newTime
            endif
            handle = true
        endif 
    endif

    return handle
end function